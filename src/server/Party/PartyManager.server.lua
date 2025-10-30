-- This script handles all the party features on the server (at least I think)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Types = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Types"))

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

EventFolder:WaitForChild("JoinParty").OnServerInvoke = function(player: Player, partyId: Types.uuid)
    local party: Types.Party = Parties[partyId]
    if not party then
        warn("Illegal invoke: Party not found")
        return nil
    end

    if table.find(party.members, player.UserId) then
        warn("Illegal invoke: Player already in party")
        return nil
    end

    table.insert(party.members, player.UserId)

    return party
end

EventFolder:WaitForChild("GetMyParty").OnServerInvoke = function(player: Player)
    for _, party in Parties do
		-- Check if leader
		if party.leader == player.UserId then
			return party
		end
		
		-- Check if member
		for _, memberId in party.members do
			if memberId == player.UserId then
				return party
			end
		end
	end
	return nil -- user not in any party
end

EventFolder:WaitForChild("EditPartySettings").OnServerInvoke = function(player: Player, partyId: Types.uuid, name: string)
    local party: Types.Party = Parties[partyId]
    
    if not party then
        warn("Illegal invoke: Party not found")
        return nil
    end

    party.name = name

    Parties[partyId] = party

    return party
end