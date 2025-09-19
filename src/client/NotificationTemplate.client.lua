-- template for notifications, set enabled to false to disable them from popping up at start of play test
local enabled = true
if enabled then
    local NotificationHandler = require(script.Parent.NotificationHandler)
    local CustomListLayout = require(script.Parent.CustomListLayout)
    local FillRemainder = require(script.Parent.FillRemainder)
    local NotificationList = require(script.Parent.NotificationList)
    CustomListLayout.setup(script.Parent.Parent:WaitForChild("App"):WaitForChild("Notifications"))

    local Notification = NotificationHandler.new(15)
    
    local Content = NotificationList.NowPlaying:Clone()

    FillRemainder.watch(Content, Content.TextLabel, Content.UIListLayout, Content.UIPadding)

    Notification:setContent(Content)
    task.wait(3)
    Notification:display()
end