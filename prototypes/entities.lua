local decider = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
decider.name = DECIDER_ENTITY_NAME
decider.minable.result = ITEM_NAME
decider.flags = {"not-upgradable"}

-- copied from base/prototypes/entity/combinator-pictures.lua:1040
decider.sprites = make_4way_animation_from_spritesheet({
    layers = {{
        filename = "__base__/graphics/entity/combinator/decider-combinator.png",
        width = 78,
        height = 66,
        frame_count = 1,
        shift = util.by_pixel(0, 7),
        hr_version = {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/hr-decider-combinator.png",
            width = 156,
            height = 132,
            frame_count = 1,
            shift = util.by_pixel(0.5, 7.5)
        }
    }, {
        filename = "__base__/graphics/entity/combinator/decider-combinator-shadow.png",
        width = 78,
        height = 80,
        frame_count = 1,
        shift = util.by_pixel(12, 24),
        draw_as_shadow = true,
        hr_version = {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/hr-decider-combinator-shadow.png",
            width = 156,
            height = 158,
            frame_count = 1,
            shift = util.by_pixel(12, 24),
            draw_as_shadow = true
        }
    }}
})

local control = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
control.name = CONTROL_ENTITY_NAME
control.minable = nil
control.flags = {"not-rotatable", "placeable-off-grid", "hide-alt-info", "not-upgradable", "not-in-kill-statistics",
                 "not-deconstructable"}

data:extend{decider, control}
