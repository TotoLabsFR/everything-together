local EventFolder = game:GetService("ReplicatedStorage"):WaitForChild("Party")
local CurrentParty = script.Parent.Parent.Parent:WaitForChild("App"):WaitForChild("CurrentParty")

CurrentParty.PartySettings.PartyName.FocusLost:Connect(function()
    local partyName = CurrentParty.PartySettings.PartyName.Text
    
    EventFolder:WaitForChild("EditPartySettings"):InvokeServer(CurrentParty.PartyId.Value, partyName)
end)