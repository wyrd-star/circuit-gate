local function display_gui(screen, selected_entry)
    global.gui_is_open = true

    local config = selected_entry.config
    debug_print("config = {config}")

    local frame = screen.add {
        type = "frame",
        name = MOD_NAME .. "-config-gui",
        direction = "vertical"
    }

    local title_flow = frame.add {
        type = "flow",
        name = "title_flow"
    }
    local title = title_flow.add {
        type = "label",
        caption = {"entity-name.circuit-gate"},
        style = "frame_title"
    }
    local pusher = title_flow.add {
        type = "empty-widget",
        style = "draggable_space_header"
    }
    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = frame
    title_flow.add {
        type = "sprite-button",
        style = "frame_action_button",
        sprite = "utility/close_white",
        name = "close_gui"
    }

    frame.add {
        type = "label",
        caption = {"gui-text.enabled-condition"}
    }
    local selector = frame.add {
        type = "flow",
        name = "selector"
    }
    selector.add {
        type = "choose-elem-button",
        name = MOD_NAME .. "-left",
        elem_type = "signal",
        signal = config.left_signal
    }
    selector.add {
        type = "drop-down",
        name = MOD_NAME .. "-comparison",
        items = {{"", "<"}, {"", ">"}, {"", "="}, {"", "≥"}, {"", "≤"}, {"", "≠"}},
        selected_index = config.selected_index
    }
    selector.add {
        type = "choose-elem-button",
        name = MOD_NAME .. "-right",
        elem_type = "signal",
        signal = config.right_signal
    }

    frame.force_auto_center()
end

local function refresh_gui(screen, selected_entry)
    local config = selected_entry.config
    debug_print("config = {config}")

    local frame = screen[MOD_NAME .. "-config-gui"]
    frame.force_auto_center()
    local selector = frame.selector
    selector[MOD_NAME .. "-left"].elem_value = config.left_signal
    selector[MOD_NAME .. "-comparison"].selected_index = config.selected_index
    selector[MOD_NAME .. "-right"].elem_value = config.right_signal
end

local function destroy_gui(screen)
    screen[MOD_NAME .. "-config-gui"].destroy()
    global.gui_is_open = false
end

local function on_gui_select(event)
    if event.element == nil or event.element.name == nil then
        return
    end
    if string.find(event.element.name, MOD_NAME, 1, true) ~= 1 then
        return
    end

    local gui = event.element.parent
    local config = global.selected_entry.config
    config.left_signal = gui[MOD_NAME .. "-left"].elem_value
    config.right_signal = gui[MOD_NAME .. "-right"].elem_value
    config.selected_index = gui[MOD_NAME .. "-comparison"].selected_index

    debug_print("config = {config}")
end

local function on_click(event)
    if event.element.name == "close_gui" then
        destroy_gui(game.players[event.player_index].gui.screen)
        return
    end
end

local function on_hotkey_pressed(event)
    local player = game.players[event.player_index]
    local selected = player.selected
    if selected == nil then
        if global.gui_is_open then
            destroy_gui(player.gui.screen)
        end
        return
    end

    local selected_entry
    if selected.name == DECIDER_ENTITY_NAME then
        selected_entry = global.entries_by_decider[selected.unit_number]
    elseif selected.name == CONTROL_ENTITY_NAME then
        selected_entry = global.entries_by_control[selected.unit_number]
    else
        return
    end
    global.selected_entry = selected_entry
    if selected_entry == nil and global.gui_is_open then
        destroy_gui(player.gui.screen)
    end

    if global.gui_is_open then
        refresh_gui(player.gui.screen, selected_entry)
    else
        display_gui(player.gui.screen, selected_entry)
    end
end

local function on_gui_opened(event)
    if global.gui_is_open then
        destroy_gui(game.players[event.player_index].gui.screen)
    end
end

script.on_event(CONFIGURE_CONTROL_NAME, on_hotkey_pressed)
script.on_event(defines.events.on_gui_elem_changed, on_gui_select)
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_select)
script.on_event(defines.events.on_gui_click, on_click)
script.on_event(defines.events.on_gui_opened, on_gui_opened)
