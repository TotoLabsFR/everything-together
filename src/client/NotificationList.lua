-- Just a list of notification instances I can pick up from different scripts
type NotificationList = { [string]: GuiObject }

local NotificationList: NotificationList = {
    NowPlaying = game.ReplicatedStorage:WaitForChild("Notifications"):WaitForChild("NowPlaying")
}

return NotificationList