local parent = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
local recipe = {
    type = "recipe",
    name = RECIPE_NAME,
    normal = {
        enabled = false,
        result = ITEM_NAME,
        ingredients = {{"decider-combinator", 1}, {"constant-combinator", 1}}
    },
    expensive = {
        enabled = false,
        result = ITEM_NAME,
        ingredients = {{"decider-combinator", 2}, {"constant-combinator", 2}}
    }
}
data:extend{recipe}
