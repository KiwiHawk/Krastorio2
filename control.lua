local handler = require("__core__/lualib/event_handler")

handler.add_lib(require("__flib__/gui-lite"))

handler.add_lib(require("__Krastorio2__/scripts/creep-collector"))
handler.add_lib(require("__Krastorio2__/scripts/energy-absorber"))
handler.add_lib(require("__Krastorio2__/scripts/intergalactic-transceiver"))
handler.add_lib(require("__Krastorio2__/scripts/jackhammer"))
handler.add_lib(require("__Krastorio2__/scripts/loader-snapping"))
handler.add_lib(require("__Krastorio2__/scripts/offshore-pump"))
handler.add_lib(require("__Krastorio2__/scripts/patreon"))
handler.add_lib(require("__Krastorio2__/scripts/planetary-teleporter"))
handler.add_lib(require("__Krastorio2__/scripts/planetary-teleporter-gui"))
handler.add_lib(require("__Krastorio2__/scripts/radioactivity"))
handler.add_lib(require("__Krastorio2__/scripts/roboport"))
handler.add_lib(require("__Krastorio2__/scripts/shelter"))
handler.add_lib(require("__Krastorio2__/scripts/virus"))

local migration = require("__flib__/migration")

-- local creep = require("__Krastorio2__/scripts/creep")
local migrations = require("__Krastorio2__/scripts/migrations")
local tesla_coil = require("__Krastorio2__/scripts/tesla-coil")

-- COMMANDS

-- util.add_commands(creep.commands)

-- INTERFACES

-- remote.add_interface("kr-creep", creep.remote_interface)
-- remote.add_interface("kr-intergalactic-transceiver", intergalactic_transceiver.remote_interface)
-- remote.add_interface("kr-radioactivity", radioactivity.remote_interface)

-- BOOTSTRAP

local legacy_lib = {}

function legacy_lib.on_init()
  -- Initialize `global` table
  -- creep.init()
  tesla_coil.init()

  -- Initialize mod
  migrations.generic()
end

--- @param e ConfigurationChangedData
function legacy_lib.on_configuration_changed(e)
  if migration.on_config_changed(e, migrations.versions) then
    migrations.generic()
  end
end

legacy_lib.events = {}

-- CUSTOM INPUT

-- ENTITY

local function on_entity_destroyed(e)
  local entity = e.entity
  if not entity or not entity.valid then
    return
  end
  local entity_name = entity.name
  if entity_name == "kr-tesla-coil" then
    tesla_coil.destroy(entity)
  end
end

legacy_lib.events[defines.events.on_player_mined_entity] = on_entity_destroyed
legacy_lib.events[defines.events.on_robot_mined_entity] = on_entity_destroyed
legacy_lib.events[defines.events.on_entity_died] = on_entity_destroyed
legacy_lib.events[defines.events.script_raised_destroy] = on_entity_destroyed

legacy_lib.events[defines.events.on_entity_destroyed] = function(e)
  local beam_data = global.tesla_coil.beams[e.registration_number]
  if beam_data then
    tesla_coil.remove_connection(beam_data.target_data, beam_data.tower_data)
  end
end

-- legacy_lib.events[defines.events.on_biter_base_built] = function(e)
--   creep.on_biter_base_built(e.entity)
-- end

-- EQUIPMENT

legacy_lib.events[defines.events.on_equipment_inserted] = function(e)
  if e.equipment.valid and e.equipment.name == "energy-absorber" then
    tesla_coil.update_target_grid(e.grid)
  end
end
legacy_lib.events[defines.events.on_equipment_removed] = function(e)
  if e.equipment == "energy-absorber" then
    tesla_coil.update_target_grid(e.grid)
  end
end

-- FORCE

legacy_lib.events[defines.events.on_technology_effects_reset] = function(e)
  if game.finished or game.finished_but_continuing then
    e.force.technologies["kr-logo"].enabled = true
  end
end

legacy_lib.events[defines.events.on_player_armor_inventory_changed] = tesla_coil.on_player_armor_inventory_changed

-- TICKS AND TRIGGERS

legacy_lib.events[defines.events.on_script_trigger_effect] = function(e)
  if e.effect_id == "kr-tesla-coil-trigger" then
    tesla_coil.process_turret_fire(e.target_entity, e.source_entity)
  end
end

handler.add_lib(legacy_lib)
