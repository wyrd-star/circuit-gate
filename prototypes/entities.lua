local decider = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
decider.name = DECIDER_ENTITY_NAME
decider.minable.result = ITEM_NAME
decider.flags = {"not-upgradable"}

local control = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
control.name = CONTROL_ENTITY_NAME
control.minable = nil
control.flags = {"not-rotatable", "placeable-off-grid", "hide-alt-info", "not-upgradable", "not-in-kill-statistics",
                 "not-deconstructable"}

data:extend{decider, control}
