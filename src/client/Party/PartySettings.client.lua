local CurrentParty = script.Parent.Parent.Parent:WaitForChild("App"):WaitForChild("CurrentParty")

CurrentParty.PartySettings.PartyName.FocusLost:Connect(function()
    local partyName = CurrentParty.PartySettings.PartyName.Text
    
    
end)