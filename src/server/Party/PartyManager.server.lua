-- This script handles all the party features (at least I think)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Variables
local EventFolder = ReplicatedStorage:WaitForChild("Party")
local Parties = {}

EventFolder:WaitForChild("GetParties").OnServerInvoke = function(player: Player)
    return Parties
end

EventFolder:WaitForChild("CreateParty").OnServerInvoke = function(player: Player, name: string)
    local party = {
        name = name,
        members = {
            player.UserId
        },
        leader = player.UserId,
        id = HttpService:GenerateGUID(true)
    }

    Parties[party.id] = party

    return party
end