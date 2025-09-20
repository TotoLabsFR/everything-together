local WhosOnTop = require(script.Parent.Parent.WhosOnTop)
local CustomListLayout = require(script.Parent.Parent.CustomListLayout)
local Types = require(script.Parent.Parent.Types)

local EventFolder = game:GetService("ReplicatedStorage"):WaitForChild("Party")
local PartyTemplate = EventFolder:WaitForChild("Template")
local MemberTemplate = EventFolder:WaitForChild("MemberTemplate")

local Main = script.Parent.Parent.Parent:WaitForChild("App"):WaitForChild("PartySelect")
CustomListLayout.setup(Main:WaitForChild("PartyList"))

-- Track party buttons by party ID
local PartyButtons = {}

-- Refresh parties every 5 seconds
while true do
    local parties = EventFolder:WaitForChild("GetParties"):InvokeServer()
    local PartyList = Main:WaitForChild("PartyList")

    local existingIds = {}
    for _, party: Types.Party in pairs(parties) do
        local partyId: Types.uuid = party.id -- Assuming each party has a unique ID
        existingIds[partyId] = true

        local btn = PartyButtons[partyId]
        local isNewParty = false

        -- Create new party button if it doesn't exist
        if not btn then
            btn = PartyTemplate:Clone()
            btn.Name = "Party"
            WhosOnTop.setup(btn:WaitForChild("Members"))

            -- Set attribute to trigger tween only for party button
            btn:SetAttribute("IsNewItem", true)
            btn:SetAttribute("PartyId", partyId)

            -- Update host info & party name
            btn:WaitForChild("Host"):WaitForChild("Main"):WaitForChild("Headshot").Image =
                game:GetService("Players"):GetUserThumbnailAsync(party.leader, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            btn:WaitForChild("Host"):WaitForChild("Main"):WaitForChild("By").Text =
                "Hosted by " .. game:GetService("Players"):GetNameFromUserIdAsync(party.leader)
            btn:WaitForChild("PartyName").Text = party.name

            btn.Parent = PartyList
            PartyButtons[partyId] = btn
            isNewParty = true
        end

        local membersContainer = btn:WaitForChild("Members")

        -- Build a set of current member IDs (convert to number)
        local existingMembers = {}
        for _, child in pairs(membersContainer:GetChildren()) do
            if child:IsA("ImageLabel") then
                existingMembers[tonumber(child.Name)] = child
            end
        end

        -- Remove members that are no longer in the party
        for memberId, child in pairs(existingMembers) do
            if not table.find(party.members, memberId) then
                child:Destroy()
                existingMembers[memberId] = nil
            end
        end

        -- Add new members
        for _, memberId in pairs(party.members) do
            if not existingMembers[memberId] then
                local memberIcon = MemberTemplate:Clone()
                memberIcon.Name = tostring(memberId) -- ensure string Name
                memberIcon.Image = game:GetService("Players"):GetUserThumbnailAsync(memberId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                memberIcon.Parent = membersContainer
                existingMembers[memberId] = memberIcon
            end
        end
    end

    -- Remove buttons for parties that no longer exist
    for partyId, btn in pairs(PartyButtons) do
        if not existingIds[partyId] then
            btn:Destroy()
            PartyButtons[partyId] = nil
        end
    end

    task.wait(5)
end
