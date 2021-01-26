local combinator = table.deepcopy(data.raw["item"]["decider-combinator"])
combinator.name = ITEM_NAME
combinator.place_result = DECIDER_ENTITY_NAME
combinator.order = "c[combinators]-s[" .. ITEM_NAME .. "]"
data:extend{combinator}
