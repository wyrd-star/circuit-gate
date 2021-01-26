if __DebugAdapter then
    __DebugAdapter.defineGlobal("debug_print")
    debug_print = __DebugAdapter.print
else
    debug_print = function(...) end
end
