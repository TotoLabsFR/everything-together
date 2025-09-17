local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationTemplate = ReplicatedStorage:WaitForChild("Templates"):WaitForChild("Notification")
local Main = script.Parent.Parent.App.Notifications
local Animation = require(script.Parent.Animation)
local NotificationHandler = {}
NotificationHandler.__index = NotificationHandler

function NotificationHandler.new(Timeout: number)
	local self = setmetatable({
		Timeout = Timeout
	}, NotificationHandler)
	
	local notification = NotificationTemplate:Clone()
	self.Instance = notification
	
	return self
end

function NotificationHandler:display()
	local instance: CanvasGroup = self.Instance
	
	instance.Parent = Main
	instance.Visible = true
	TweenService:Create(instance, Animation.normal, { GroupTransparency = 0 }):Play()
end

return NotificationHandler