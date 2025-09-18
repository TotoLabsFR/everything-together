local enabled = true
if enabled then
    local NotificationHandler = require(script.Parent.NotificationHandler)
    local CustomListLayout = require(script.Parent.CustomListLayout)
    CustomListLayout.setup(script.Parent.Parent:WaitForChild("App"):WaitForChild("Notifications"))

    local Notification = NotificationHandler.new(15)
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Parent = Frame
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel.Text = "test"

    Notification:setContent(Frame)
    task.wait(3)
    Notification:display()
    task.wait(1)
    local Notification2 = NotificationHandler.new(15)
    Notification2:display()
end