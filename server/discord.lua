local discordInfo = {}
local discordCommands = {
    ["settime"] = function(admin, args)
        local hour, minute = args[1], args[2]
        local success = setTime(hour, minute)
        
        if success then
            outputMessage(admin .. " #ffffffedit the time of server to " .. hour .. ":" .. minute .. "!")
            return "you edited the time of server"
        else
            return "Error, send your message again!"
        end
    end,
    ["say"] = function(admin, args)
        outputMessage(admin .. " #ffffffsay: " .. args[1])
        return "your message ``" .. args[1] .. "`` as sent!"
    end,
    ["status"] = function(admin, args)
        local online = getPlayerCount()
        local maxPlayers = getMaxPlayers()
        local serverName = getServerName()
        local serverIp = getServerConfigSetting("serverip")
        local serverPort = getServerPort()

        return {
            online = online,
            maxPlayers = maxPlayers,
            serverName = serverName,
            serverIp = serverIp,
            serverPort = serverPort
        }
    end,
    ["mute"] = function(admin, args)
        local player = getPlayerFromName(args[1])
        
        if isElement(player) then
            local playerName = getPlayerName(player)

            setPlayerMuted(player, true)
            outputMessage(admin .. " #ffffffdeafened " .. playerName .. "!")
            return "**" .. playerName .. "** was muted!"
        else
            return "**" .. args[1] .. "** it's invalid"
        end
    end,
    ["givemoney"] = function(admin, args)
        local player = getPlayerFromName(args[1])
        local amount = tonumber(args[2])

        if not isElement(player) then
            return "**" .. args[1] .. "** it's invalid"
        end
        if not amount or amount <= 0 then
            return "say a number greater than 0"
        end

        local playerName = getPlayerName(player)

        givePlayerMoney(player, amount)
        outputMessage(admin .. " #ffffffgave #808080$" .. amount .. " #ffffffto " .. playerName .. "!")
        return "**" .. playerName .. "** received ``$" .. amount .. "``."
    end,
    ["creategroup"] = function(admin, args)
        local groupName = args[1]

        if groupName then
            local checkGroup = aclGetGroup(groupName)
            if checkGroup then
                return "There is already a group with that name in the ACL"
            end

            local newGroup = aclCreateGroup(groupName)
            if not newGroup then
                return "An error happened when creating a group in the ACL!"
            end

            return "The group" .. groupName .. "was created and added to the ACL."
        end
    end,
    ["uuu"] = function(admin, args)
        if admin == "Console" then
            discordInfo.members = args[1]
            discordInfo.inviteCode = args[2]
            discordInfo.guildName = args[3]

            updateInfo()
        end
    end
}

function discordRequest(command, admin, ...)
    if not discordCommands[command] then
        return "This command does not exist in MTAServer!"
    end

    local args = {...}
    return discordCommands[command](admin, args)
end

function updateInfo()
    triggerClientEvent("discordapp.update", resourceRoot, discordInfo)
end

function outputMessage(message)
    return outputChatBox("#f29dec[API] #ffffff" .. message, root, 255, 255, 255, true)
end