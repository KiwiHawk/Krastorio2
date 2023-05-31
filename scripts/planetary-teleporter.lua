local util = require("__Krastorio2__/scripts/util")

--- @type MapPosition[]
local collision_entity_offsets = {
  { x = 0, y = 0 },
  { x = -2, y = 2 },
  { x = 2, y = 2 },
}

--- @class PlanetaryTeleporterEntities
--- @field base LuaEntity
--- @field turret LuaEntity
--- @field collision_1 LuaEntity
--- @field collision_2 LuaEntity
--- @field collision_3 LuaEntity
--- @field front_layer LuaEntity

--- @param base_entity LuaEntity
--- @return PlanetaryTeleporterEntities?
local function create_entities(base_entity)
  local entities = {
    base = base_entity,
  }
  local surface = base_entity.surface
  local position = base_entity.position

  -- Building the turret can fail due to AAI vehicles
  entities.turret = surface.create_entity({
    name = "kr-planetary-teleporter-turret",
    position = { x = position.x, y = position.y + 1.15 },
    force = "kr-internal-turrets",
    create_build_effect_smoke = false,
    raise_built = true,
  })

  if not entities.turret or not entities.turret.valid then
    game.print(
      "Building planetary teleporter failed due to AAI Programmable Vehicles. This teleporter will not function."
    )
    base_entity.active = false
    return
  end

  for i, offset in pairs(collision_entity_offsets) do
    entities["collision_" .. i] = surface.create_entity({
      name = "kr-planetary-teleporter-collision-" .. i,
      position = { x = position.x + offset.x, y = position.y + offset.y },
      create_build_effect_smoke = false,
      raise_built = true,
    })
  end
  entities.front_layer = surface.create_entity({
    name = "kr-planetary-teleporter-front-layer",
    position = position,
    create_build_effect_smoke = false,
    raise_built = true,
  })
  for name, entity in pairs(entities) do
    if name ~= "base" then
      entity.destructible = false
    end
  end
  return entities
end

--- @param e EntityBuiltEvent
local function on_entity_built(e)
  local entity = e.entity or e.created_entity or e.destination
  if not entity or not entity.valid then
    return
  end

  -- Sometimes the internal entities can be built by cloning, destroy them in that case
  local entity_name = entity.name
  if
    e.name == defines.events.on_entity_cloned
    -- FIXME: Move the first two to tesla coil
    and (
      entity_name == "kr-tesla-coil-turret"
      or entity_name == "kr-tesla-coil-collision"
      or entity_name == "kr-planetary-teleporter-front-layer"
      or entity_name == "kr-planetary-teleporter-turret"
      or string.find(entity_name, "kr-planetary-teleporter-collision", nil, true)
    )
  then
    entity.destroy()
    return
  end

  if entity_name ~= "kr-planetary-teleporter" then
    return
  end

  local entities = create_entities(entity)
  if not entities then
    return
  end
  local name = e.tags and e.tags.kr_planetary_teleporter_name or nil --[[@as string?]]
  --- @class PlanetaryTeleporterData
  local data = {
    entities = entities,
    force = entity.force,
    name = name,
    position = entity.position,
    surface = entity.surface,
    turret_unit_number = entities.turret.unit_number,
  }
  global.planetary_teleporter[entity.unit_number] = data
end

--- @param e EntityDestroyedEvent
local function on_entity_destroyed(e)
  local entity = e.entity
  if not entity or not entity.valid then
    return
  end
  local unit_number = entity.unit_number --[[@as uint]]
  local data = global.planetary_teleporter[unit_number]
  -- XXX: AAI vehicles can immediately destroy the turret before the data is even saved
  if not data then
    return
  end
  for _, entity_to_destroy in pairs(data.entities) do
    if entity_to_destroy.valid then
      entity_to_destroy.destroy()
    end
  end
  global.planetary_teleporter[unit_number] = nil
end

--- @param e EventData.on_player_setup_blueprint
local function on_player_setup_blueprint(e)
  local blueprint = util.get_blueprint(e)
  if not blueprint then
    return
  end

  local entities = blueprint.get_blueprint_entities()
  if not entities then
    return
  end

  local surface = game.get_player(e.player_index).surface
  for _, entity in pairs(entities) do
    if entity.name == "kr-planetary-teleporter" then
      local real_entity = surface.find_entity("kr-planetary-teleporter", entity.position)
      if real_entity then
        local data = global.planetary_teleporter[real_entity.unit_number]
        blueprint.set_blueprint_entity_tag(entity.entity_number, "kr_planetary_teleporter_name", data.name)
      end
    end
  end
end

--- @param e EventData.on_script_trigger_effect
local function on_script_trigger_effect(e)
  if e.effect_id ~= "kr-planetary-teleporter-character-trigger" then
    return
  end

  local source, target = e.source_entity, e.target_entity
  if not source or not source.valid or not target or not target.valid then
    return
  end

  local player = target.player
  if not player or not player.valid then
    return
  end
  player.create_local_flying_text({ text = "In range!", position = player.position })
end

local function on_init()
  --- @type table<uint, PlanetaryTeleporterData>
  global.planetary_teleporter = {}
end

local planetary_teleporter = {}

planetary_teleporter.on_init = on_init

planetary_teleporter.events = {
  [defines.events.on_built_entity] = on_entity_built,
  [defines.events.on_entity_cloned] = on_entity_built,
  [defines.events.on_entity_died] = on_entity_destroyed,
  [defines.events.on_player_mined_entity] = on_entity_destroyed,
  [defines.events.on_player_setup_blueprint] = on_player_setup_blueprint,
  [defines.events.on_robot_built_entity] = on_entity_built,
  [defines.events.on_robot_mined_entity] = on_entity_destroyed,
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.script_raised_built] = on_entity_built,
  [defines.events.script_raised_destroy] = on_entity_destroyed,
  [defines.events.script_raised_revive] = on_entity_built,
}

return planetary_teleporter
