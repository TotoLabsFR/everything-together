local TweenService = game:GetService("TweenService")

local WhosOnTop = require(script.Parent.Parent.WhosOnTop)
local CustomListLayout = require(script.Parent.Parent.CustomListLayout)
local Types = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Types"))

local EventFolder = game:GetService("ReplicatedStorage"):WaitForChild("Party")
local PartyTemplate = EventFolder:WaitForChild("Template")
local SelectPartyMember = EventFolder:WaitForChild("SelectPartyMember")
local CurrentPartyMember = EventFolder:WaitForChild("CurrentPartyMember")

local PartySelect = script.Parent.Parent.Parent:WaitForChild("App"):WaitForChild("PartySelect")
local CurrentParty = script.Parent.Parent.Parent:WaitForChild("App"):WaitForChild("CurrentParty")
CustomListLayout.setup(PartySelect:WaitForChild("PartyList"))

local IsInParty = false

-- Track party buttons by party ID
local PartyButtons = {}

-- Track current party members by userId
local PartyMembers = {}

PartySelect:WaitForChild("Create").MouseButton1Click:Connect(function()
    local party: Types.Party = EventFolder:WaitForChild("CreateParty"):InvokeServer("New Party")
    CurrentParty.Visible = true
    IsInParty = true
	CurrentParty.PartyId.Value = party.id
end)

PartySelect:WaitForChild("Bottom"):WaitForChild("Back").MouseButton1Click:Connect(function()
    CurrentParty.Visible = false
    IsInParty = false
end)

-- Refresh parties every 5 seconds
while true do
	if not IsInParty then
		local parties = EventFolder:WaitForChild("GetParties"):InvokeServer()
		local PartyList = PartySelect:WaitForChild("PartyList")

		local existingIds = {}
		for _, party: Types.Party in pairs(parties) do
			local partyId: Types.uuid = party.id -- Assuming each party has a unique ID
			existingIds[partyId] = true

			local btn = PartyButtons[partyId]

			if btn and btn:WaitForChild("PartyName").Text ~= party.name then
				btn:Destroy()
				PartyButtons[partyId] = nil
				btn = nil
			end

			-- Create new party button if it doesn't exist
			if not btn then
				btn = PartyTemplate:Clone()
				btn.Name = "Party"
				WhosOnTop.setup(btn:WaitForChild("Members"))

				btn:SetAttribute("IsNewItem", true)
				btn:SetAttribute("PartyId", partyId)

				local success, response = pcall(function()
					game:GetService("Players"):GetNameFromUserIdAsync(party.leader)
				end)

				if not success then
					warn(response)
					response = "Roblox Test Account"
				end

				btn:WaitForChild("Host"):WaitForChild("Main"):WaitForChild("Headshot").Image =
					game:GetService("Players"):GetUserThumbnailAsync(party.leader, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
				btn:WaitForChild("Host"):WaitForChild("Main"):WaitForChild("By").Text =
					"Hosted by " .. response
				btn:WaitForChild("PartyName").Text = party.name

				btn.Parent = PartyList
				PartyButtons[partyId] = btn

				btn.MouseButton1Click:Connect(function()
					local joinedParty = EventFolder:WaitForChild("JoinParty"):InvokeServer(partyId)
					IsInParty = true
					PartyMembers = {} -- Reset member store when joining
					CurrentParty.PartyId.Value = partyId
					CurrentParty.Visible = true
				end)
			end

			local membersContainer = btn:WaitForChild("Members")

			-- Build set of current members in UI
			local existingMembers = {}
			for _, child in pairs(membersContainer:GetChildren()) do
				if child:IsA("ImageLabel") then
					existingMembers[tonumber(child.Name)] = child
				end
			end

			-- Remove members no longer in the party
			for memberId, child in pairs(existingMembers) do
				if not table.find(party.members, memberId) then
					child:Destroy()
					existingMembers[memberId] = nil
				end
			end

			-- Add new members
			for _, memberId in pairs(party.members) do
				if not existingMembers[memberId] then
					local memberIcon = SelectPartyMember:Clone()
					memberIcon.Name = tostring(memberId)
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
	else
		local party = EventFolder:WaitForChild("GetMyParty"):InvokeServer()
		local memberList = CurrentParty:WaitForChild("MemberList")

		if party then
			local existingIds = {}

			-- Add or update members
			for _, memberId in pairs(party.members) do
				existingIds[memberId] = true

				local icon = PartyMembers[memberId]
				if not icon then
					-- Create new member icon
					icon = CurrentPartyMember:Clone()
					local success, response = pcall(function()
						game:GetService("Players"):GetNameFromUserIdAsync(memberId)
					end)

					if not success then
						warn(response)
						response = "Roblox Test Account"
					end
					icon.Name = tostring(memberId)
					icon:WaitForChild("Headshot").Image =
						game:GetService("Players"):GetUserThumbnailAsync(memberId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
					icon:WaitForChild("Username").Text =
						response
					icon.Parent = memberList

					PartyMembers[memberId] = icon
				else
					local success, response = pcall(function()
						game:GetService("Players"):GetNameFromUserIdAsync(memberId)
					end)

					if not success then
						warn(response)
						response = "Roblox Test Account"
					end

					-- Update existing member (in case username/headshot changes)
					icon:WaitForChild("Headshot").Image =
						game:GetService("Players"):GetUserThumbnailAsync(memberId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
					icon:WaitForChild("Username").Text =
						response
				end
			end

			-- Remove members no longer in the party
			for memberId, icon in pairs(PartyMembers) do
				if not existingIds[memberId] then
					icon:Destroy()
					PartyMembers[memberId] = nil
				end
			end
		end

		task.wait(5)
	end
end