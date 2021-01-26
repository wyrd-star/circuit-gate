script.on_init(function()
    global.entries_by_decider = global.entries_by_decider or {}
    global.entries_by_control = global.entries_by_control or {}
end)

local gate_open = {
    first_signal = {
        type = "virtual",
        name = "signal-each"
    },
    second_constant = 1,
    operation = "*",
    output_signal = {
        type = "virtual",
        name = "signal-each"
    }
}

local gate_closed = {}

local function get_control_position(decider_entity)
    local position = decider_entity.position

    if decider_entity.direction == defines.direction.south then
        position.x = position.x - .5
    end
    if decider_entity.direction == defines.direction.north then
        position.x = position.x + .5
    end
    if decider_entity.direction == defines.direction.east then
        position.y = position.y + .5
    end
    if decider_entity.direction == defines.direction.west then
        position.y = position.y - .5
    end

    return position
end

local function get_control_direction(decider_entity)
    local direction = decider_entity.direction
    local directions = defines.direction
    if decider_entity.direction == directions.south then
        return directions.west
    end
    if decider_entity.direction == directions.east then
        return directions.south
    end
    if decider_entity.direction == directions.north then
        return directions.east
    end
    if decider_entity.direction == directions.west then
        return directions.north
    end
end

local function on_build(e)
    if not e.created_entity or e.created_entity.name ~= DECIDER_ENTITY_NAME then
        return
    end

    local decider_entity = e.created_entity
    decider_entity.operable = false
    decider_entity.get_control_behavior().parameters = gate_closed

    local control_entity = decider_entity.surface.create_entity {
        name = CONTROL_ENTITY_NAME,
        position = get_control_position(decider_entity),
        direction = get_control_direction(decider_entity),
        force = decider_entity.force,
        fast_replace = false,
        raise_built = false,
        create_built_effect_smoke = false
    }
    script.register_on_entity_destroyed(decider_entity)

    control_entity.destructible = false
    control_entity.operable = false
    control_entity.rotatable = false
    control_entity.minable = false

    local entry = {
        decider_entity = decider_entity,
        control_entity = control_entity,
        config = {
            selected_index = 1
        }
    }

    global.entries_by_decider[decider_entity.unit_number] = entry
    global.entries_by_control[control_entity.unit_number] = entry
end

local function on_removed(e)
    local decider_entity = e.entity
    if not decider_entity or decider_entity.name ~= DECIDER_ENTITY_NAME then
        return
    end

    local control_entity = global.entries_by_decider[decider_entity.unit_number].control_entity
    table.remove(global.entries_by_control, control_entity.unit_number)
    table.remove(global.entries_by_decider, decider_entity.unit_number)

    control_entity.destroy {
        raise_destroy = false
    }
end

local filter = {{
    filter = "name",
    name = DECIDER_ENTITY_NAME
}}

local operation_table = {function(a, b)
    return a < b
end, function(a, b)
    return a > b
end, function(a, b)
    return a == b
end, function(a, b)
    return a >= b
end, function(a, b)
    return a <= b
end, function(a, b)
    return a ~= b
end}

local function update_single_entry(entry)
    if not entry.decider_entity.valid then
        return
    end

    local config = entry.config
    if config.left_signal == nil or config.right_signal == nil then
        entry.decider_entity.get_control_behavior().parameters = gate_closed
        return
    end
    local left_signal_value = entry.control_entity.get_merged_signal(config.left_signal)
    local right_signal_value = entry.control_entity.get_merged_signal(config.right_signal)
    if operation_table[config.selected_index](left_signal_value, right_signal_value) then
        entry.decider_entity.get_control_behavior().parameters = gate_open
    else
        entry.decider_entity.get_control_behavior().parameters = gate_closed
    end
end

local function update_outputs()
    for _, entry in pairs(global.entries_by_decider) do
        update_single_entry(entry)
    end
end

script.on_event(defines.events.on_built_entity, on_build, filter)
script.on_event(defines.events.on_robot_built_entity, on_build, filter)
script.on_event(defines.events.script_raised_built, on_build, filter)
script.on_event(defines.events.on_player_mined_entity, on_removed, filter)
script.on_event(defines.events.on_robot_mined_entity, on_removed, filter)
script.on_event(defines.events.script_raised_destroy, on_removed, filter)
script.on_event(defines.events.on_entity_died, on_removed, filter)
script.on_event(defines.events.on_entity_destroyed, on_removed)
script.on_event(defines.events.on_tick, update_outputs)
