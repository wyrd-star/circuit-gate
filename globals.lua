local function global (name, value)
    if __DebugAdapter then
        __DebugAdapter.defineGlobal(name)
    end
    _G[name] = value
end

global("MOD_NAME", "circuit-gate")
global("ITEM_NAME", MOD_NAME)
global("RECIPE_NAME", MOD_NAME)
global("CONTROL_ENTITY_NAME", MOD_NAME .. "-control")
global("DECIDER_ENTITY_NAME", MOD_NAME )
global("CONFIGURE_CONTROL_NAME", MOD_NAME .. "-configure")
