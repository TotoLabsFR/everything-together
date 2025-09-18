local enabled = true
if enabled then
    local NotificationHandler = require(script.Parent.NotificationHandler)
    local CustomListLayout = require(script.Parent.CustomListLayout)
    CustomListLayout.setup(script.Parent.Parent:WaitForChild("App"):WaitForChild("Notifications"))

    local Notification = NotificationHandler.new(15)
    task.wait(3)
    Notification:display()
    task.wait(1)
    local Notification2 = NotificationHandler.new(15)
    Notification2:display()
end