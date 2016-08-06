package.path = package.path .. ";test_files/?.lua;test_files/"
local main = {}

--Global Macro
G_MAX_STEP = 30

require('monopoly')
local xml_table = require('config_loader')

local errmesgs = {}
local type_check = {
    "REWARD",
    "SKILL",
    "MONEY",
    "INSTANCEN",
    "GAME",
}

 lv_count = {
    [0] = {
        ["MONOPOLYTYPE_COMM"] = 0,
        ["MONOPOLYTYPE_STEP"] = 0,
        ["MONOPOLYTYPE_MONEY"] = 0,
        ["MONOPOLYTYPE_SKILL"] = 0,
        ["MONOPOLYTYPE_REWARD"] = 0,
        ["MONOPOLYTYPE_GAME"] = 0,
        ["MONOPOLYTYPE_INSTANCEN"] = 0,
        ["MONOPOLYTYPE_RETURN"] = 0,
    },
    [1] = {
        ["MONOPOLYTYPE_COMM"] = 0,
        ["MONOPOLYTYPE_STEP"] = 0,
        ["MONOPOLYTYPE_MONEY"] = 0,
        ["MONOPOLYTYPE_SKILL"] = 0,
        ["MONOPOLYTYPE_REWARD"] = 0,
        ["MONOPOLYTYPE_GAME"] = 0,
        ["MONOPOLYTYPE_INSTANCEN"] = 0,
        ["MONOPOLYTYPE_RETURN"] = 0,
    },
    [2] = {
        ["MONOPOLYTYPE_COMM"] = 0,
        ["MONOPOLYTYPE_STEP"] = 0,
        ["MONOPOLYTYPE_MONEY"] = 0,
        ["MONOPOLYTYPE_SKILL"] = 0,
        ["MONOPOLYTYPE_REWARD"] = 0,
        ["MONOPOLYTYPE_GAME"] = 0,
        ["MONOPOLYTYPE_INSTANCEN"] = 0,
        ["MONOPOLYTYPE_RETURN"] = 0,
    },
    [3] = {
        ["MONOPOLYTYPE_COMM"] = 0,
        ["MONOPOLYTYPE_STEP"] = 0,
        ["MONOPOLYTYPE_MONEY"] = 0,
        ["MONOPOLYTYPE_SKILL"] = 0,
        ["MONOPOLYTYPE_REWARD"] = 0,
        ["MONOPOLYTYPE_GAME"] = 0,
        ["MONOPOLYTYPE_INSTANCEN"] = 0,
        ["MONOPOLYTYPE_RETURN"] = 0,
    },
}

function main.checkCount(level, param, count)
    local has_error = false

    for i = 1, #type_check do
        type = "MONOPOLYTYPE_"..type_check[i]
        if lv_count[level][type] - count[type] ~= 0 then
            table.insert(errmesgs, "LEVEL "..level.." PARAM "..param.." TYPE "..type_check[i].." TYPE CNT REQ "..lv_count[level][type].." CUR CNT "..count[type])
            has_error =true
        end
    end

    if true == has_error then
        table.insert(errmesgs, "Above Wrong ==== In ===== LEVEL "..level.." == PARAM "..param.." ==================\n")
    end
end

function main.check (level, param)
    local cur_step = 0
    local next_step = 0
    local count = {
        ["MONOPOLYTYPE_COMM"] = 0,
        ["MONOPOLYTYPE_STEP"] = 0,
        ["MONOPOLYTYPE_MONEY"] = 0,
        ["MONOPOLYTYPE_SKILL"] = 0,
        ["MONOPOLYTYPE_REWARD"] = 0,
        ["MONOPOLYTYPE_GAME"] = 0,
        ["MONOPOLYTYPE_INSTANCEN"] = 0,
        ["MONOPOLYTYPE_RETURN"] = 0,
    }

    for i = 1, #monopoly[level][param] do
        local has_error = true

        next_step = monopoly[level][param][i]
        if next_step <= cur_step then --找回退
            for i = 1, 6 do 
                local pos = i + cur_step

                if pos > G_MAX_STEP then pos = G_MAX_STEP end

                local grid = xml_table[level + 1][pos]

                if "MONOPOLYTYPE_RETURN" == grid[1] and ""..next_step == grid[2] then
                    has_error = false
                    count[grid[1]] = count[grid[1]] + 1
                    break
                end
                if pos == G_MAX_STEP then break end
            end
        elseif next_step - cur_step > 6 then --找跳跃
            for i = 1, 6 do
                local pos = i + cur_step
                if pos > G_MAX_STEP then pos = G_MAX_STEP end
                local grid = xml_table[level + 1][pos]

                if "MONOPOLYTYPE_STEP" == grid[1] and ""..next_step == grid[2] then
                    has_error = false
                    count[grid[1]] = count[grid[1]] + 1
                    break
                end
                if pos == G_MAX_STEP then break end
            end
        elseif next_step - cur_step > 0 then
            has_error = false
        end

        if true == has_error then
            table.insert(errmesgs, "ERROR, check out level: "..level.." param: "..param.." Current pos: "..cur_step.." Next pos: "..next_step.."\n")
        end

        if next_step > G_MAX_STEP then next_step = G_MAX_STEP end
        cur_step = next_step
        type = xml_table[level + 1][cur_step][1]
        count[type] = count[type] + 1
    end

    if param == 1 then
        lv_count[level] = count
    else
        main.checkCount(level, param, count)
    end
end

function main.start ()
    print("*************** START ***************")
    print("MAX_STEP: "..G_MAX_STEP)
    for key, val in pairs(monopoly) do
        for i = 1, #val do
            main.check (key, i)
        end
    end
    if 0 == #errmesgs then
        print ("None ERRORs")
    else
        local filename = "logs/errLog_"..os.date("%d_%b_%Y_%H_%M_%S")..".txt"
        local f = assert(io.open(filename, "w"))
        for i = 1, #errmesgs do
            io.write(errmesgs[i],"\n")
            f:write(errmesgs[i],"\n")
        end
        f:close()
    end
    print("**************** END +***************")
end

main.start()
