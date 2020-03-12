local hit_effects = require("__base__/prototypes/entity/demo-hit-effects")
local sounds      = require("__base__/prototypes/entity/demo-sounds")

data:extend(
{
	{
		type = "assembling-machine",
		name = "kr-matter-assembler",		
		icon = kr_entities_icons_path .. "matter-assembler.png",
		icon_size = 128,
		flags = {"placeable-neutral","placeable-player", "player-creation"},
		minable = {mining_time = 1, result = "kr-matter-assembler"},
		max_health = 2000,
		damaged_trigger_effect = hit_effects.entity(),
		corpse = "kr-medium-random-pipes-remnant",
		dying_explosion = "matter-explosion",
		resistances = 
		{
			{type = "physical",percent = 50},
			{type = "fire",percent = 70},
			{type = "impact",percent = 70}
		},
		fluid_boxes =
		{
			-- Inputs
			{
				production_type = "input",
				pipe_picture = kr_pipe_path,
				pipe_covers = pipecoverspictures(),	
				base_area = 100,
				base_level = -1,
				pipe_connections = {{ type="input-output", position = {0, -4} }}
			},
			-- Outputs
			{
				production_type = "output",
				pipe_picture = kr_pipe_path,
				pipe_covers = pipecoverspictures(),	
				base_area = 100,
				base_level = 1,
				pipe_connections = {{ type="input-output", position = {-4, 0} }}
			},
			{
				production_type = "output",
				pipe_picture = kr_pipe_path,
				pipe_covers = pipecoverspictures(),	
				base_area = 100,
				base_level = 1,
				pipe_connections = {{ type="input-output", position = {4, 0} }}
			},
			{
				production_type = "output",
				pipe_picture = kr_pipe_path,
				pipe_covers = pipecoverspictures(),	
				base_area = 100,
				base_level = 1,
				pipe_connections = {{ type="input-output", position = {0, 4} }}
			},
			off_when_no_fluid_recipe = false
		},
		collision_box = {{-3.25, -3.25}, {3.25, 3.25}},
		selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
		fast_replaceable_group = "assembling-machine",
		animation =
		{
			layers =
			{
				{
				filename = kr_entities_path .. "matter-assembler/matter-assembler.png",
				priority = "high",
				width = 236,
				height = 244,
				frame_count = 1,
				shift = {0, -0.15},
				hr_version =
				{
					filename = kr_entities_path .. "matter-assembler/hr-matter-assembler.png",
					priority = "high",
					scale = scale,
					width = 473,
					height = 489,
					frame_count = 1,
					scale = 0.5,
					shift = {0, -0.15},
				}
				},
				{
				filename = kr_entities_path .. "matter-assembler/matter-assembler-sh.png",
				priority = "high",
				width = 254,
				height = 223,
				frame_count = 1,
				shift = {0.38, 0.22},
				draw_as_shadow = true,
				hr_version =
				{
					filename = kr_entities_path .. "matter-assembler/hr-matter-assembler-sh.png",
					priority = "high",
					width = 508,
					height = 446,
					frame_count = 1,
					scale = 0.5,
					shift = {0.38, 0.22},
					draw_as_shadow = true,
				}
				},
			}
		},		
		working_visualisations =
		{
			{
				animation =
				{
					layers =
					{
						{
						filename = kr_entities_path .. "matter-assembler/matter-assembler-working.png",
						priority = "high",
						width = 236,
						height = 244,
						frame_count = 30,
						line_length = 6,
						animation_speed = 0.75,
						shift = {0, -0.15},
						hr_version =
						{
							filename = kr_entities_path .. "matter-assembler/hr-matter-assembler-working.png",
							priority = "high",
							width = 473,
							height = 489,
							frame_count = 30,
							line_length = 6,
							scale = 0.5,
							animation_speed = 0.75,
							shift = {0, -0.15}
						}
						},
						{
						filename = kr_entities_path .. "matter-assembler/matter-assembler-working-glow.png",
						priority = "high",
						width = 72,
						height = 55,
						frame_count = 30,
						line_length = 6,
						blend_mode = "additive-soft",
						animation_speed = 0.75,
						shift = {0, -0.23},
						hr_version =
						{
							filename = kr_entities_path .. "matter-assembler/hr-matter-assembler-working-glow.png",
							priority = "high",
							width = 144,
							height = 110,
							frame_count = 30,
							line_length = 6,
							scale = 0.5,
							blend_mode = "additive-soft",
							animation_speed = 0.75,
							shift = {0, -0.23}
						}
						},
						{
						filename = kr_entities_path .. "matter-assembler/matter-assembler-working-glow.png",
						priority = "high",
						width = 72,
						height = 55,
						frame_count = 30,
						line_length = 6,
						blend_mode = "additive-soft",
						animation_speed = 0.75,
						shift = {0, -0.28},
						hr_version =
						{
							filename = kr_entities_path .. "matter-assembler/hr-matter-assembler-working-glow.png",
							priority = "high",
							width = 144,
							height = 110,
							frame_count = 30,
							line_length = 6,
							scale = 0.5,
							blend_mode = "additive-soft",
							animation_speed = 0.75,
							shift = {0, -0.28}
						}
						},
					}
				},
				light =
				{
					intensity = 1.5,
					size = 16,
					shift = {0, -0.15},
					color = {r=0.35, g=0.5, b=1}
				}
			}
		},		
		crafting_categories = {"matter-deconversion", "matter-items"},
		scale_entity_info_icon = true,
		vehicle_impact_sound = sounds.generic_impact,
		working_sound =
		{
			sound = { filename = kr_buildings_sounds_path .. "matter-assembler.ogg" },
			idle_sound = { filename = "__base__/sound/idle1.ogg" },
			apparent_volume = 1.5
		},
		crafting_speed = 1.0,
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = 50
		},
		energy_usage = "48.39MW",
		ingredient_count = 6,
		module_specification = { module_slots = 4, module_info_icon_shift = {0, 1.8}, module_info_icon_scale = 0.6 },
		allowed_effects = {"consumption", "productivity", "speed", "pollution"},
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.75 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 }
	}
})