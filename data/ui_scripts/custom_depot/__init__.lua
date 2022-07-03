custom_depot = {
    collection_details_menu = nil,
    data = {
        currencies = {
            ["1"] = 0, -- LaunchCredits
            ["2"] = 0, -- Credits
            ["3"] = 0, -- Parts
            ["4"] = 0, -- CoDPoints
            ["5"] = 0 -- Bonus
        },
        items = {},
        reward_splashes = {},
        has_accepted_mod_eula = false,
        has_seen_mod_eula = false,
    },
    directory_path = "h1-mod",
    file_name = "depot_save.json",
    file_path = nil,
    functions = {}
}

custom_depot.file_path = string.format("%s/%s", custom_depot.directory_path, custom_depot.file_name)

custom_depot.get_function = function(function_name)
    if not function_name or not custom_depot.functions[function_name] then
        return nil
    end

    return custom_depot.functions[function_name]
end

custom_depot.functions["save_depot_data"] = function()
    io.writefile(custom_depot.file_path, json.encode(custom_depot.data, {
        indent = true
    }), false)
end

custom_depot.functions["load_depot_data"] = function()
    if not io.directoryexists(custom_depot.directory_path) then
        os.execute(string.format("mkdir %s", custom_depot.directory_path))
    end

    if not io.fileexists(custom_depot.file_path) then
        custom_depot.get_function("save_depot_data")()
    end

    custom_depot.data = json.decode(io.readfile(custom_depot.file_path))
end

custom_depot.functions["add_currency"] = function(currency_type, amount)
    custom_depot.data.currencies[tostring(currency_type)] = custom_depot.data.currencies[tostring(currency_type)] + amount
end

custom_depot.functions["remove_currency"] = function(currency_type, amount)
    custom_depot.data.currencies[tostring(currency_type)] = custom_depot.data.currencies[tostring(currency_type)] - amount
end

custom_depot.functions["get_currency"] = function(currency_type)
    if not currency_type or not custom_depot.data.currencies[tostring(currency_type)] then
        return nil
    end

    return custom_depot.data.currencies[tostring(currency_type)]
end

custom_depot.functions["add_item"] = function(item, value)
    custom_depot.data.items[item] = value
end

custom_depot.functions["has_item"] = function(item)
    return custom_depot.data.items[item] ~= nil
end

custom_depot.functions["add_reward_splash"] = function(item, value)
    custom_depot.data.reward_splashes[item] = value
end

custom_depot.functions["has_reward_splash"] = function(item)
    return custom_depot.data.reward_splashes[item] ~= nil
end

custom_depot.functions["has_accepted_mod_eula"] = function()
    return custom_depot.data.has_accepted_mod_eula
end

custom_depot.functions["set_has_accepted_mod_eula"] = function(value)
    custom_depot.data.has_accepted_mod_eula = value
    custom_depot.get_function("save_depot_data")()
end

custom_depot.functions["has_seen_mod_eula"] = function()
    return custom_depot.data.has_seen_mod_eula
end

custom_depot.functions["set_has_seen_mod_eula"] = function(value)
    custom_depot.data.has_seen_mod_eula = value
    custom_depot.get_function("save_depot_data")()
end

custom_depot.get_function("load_depot_data")()
require("mod_eula")
require("depot_override")
require("scoreboard_override")
