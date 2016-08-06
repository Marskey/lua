local xml_loader = {}
xml_table = {}

function xml_loader.load_xml(filename)
    local xml = assert(io.open(filename, "r"))
    local data = xml:read("*all")
    xml:close()

    local x = 0
    local last_level = 0
    local level = 0
    local type = 0
    local extra = 0
    local group = {}

    while true do
        x, _, idx, level, type, extra = string.find(data, "idx=\"(%d+)\"%s*level=\"(%d+)\"%s*monopolytype=\"([%a_]+)\"%s*Icon=\"([%w-]+)\"", x + 1)

        if not x or level - last_level ~= 0 then
            table.insert(xml_table, group)
            last_level = level
            group = {}
            if not x then break end
        end

        local pair = {type, extra}
        table.insert(group, pair)
    end
    xml_loader.checkIdx()
    return xml_table
end

function xml_loader.checkIdx()
    for key, val in pairs(xml_table) do
        if G_MAX_STEP ~= #val then
            print("*** Error occurred in loading MonopolyConfig.xml ***")
            os.exit()
            break
        end
    end
end

return xml_loader.load_xml('test_files/MonoPolyConfig.xml')
