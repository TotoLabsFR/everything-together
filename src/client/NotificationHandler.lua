local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationTemplate = ReplicatedStorage:WaitForChild("Templates"):WaitForChild("Notification")
local Main = script.Parent.Parent.App.Notifications
local Animation = require(script.Parent.Animation)
local NotificationHandler = {}
NotificationHandler.__index = NotificationHandler

function NotificationHandler.new(Timeout: number)
	local self = setmetatable({
		Timeout = Timeout,
		Instance = nil,
		Content = nil
	}, NotificationHandler)
	
	local notification = NotificationTemplate:Clone()
	self.Instance = notification
	
	return self
end

function NotificationHandler:setContent(frame: Frame)
	-- TODO: Add the "ContentContainer" frame to NotificationTemplate

	frame.Name = "Content"
	frame.Parent = self.Instance.ContentContainer
	frame.Visible = true
	
	self.Content = frame

	return self
end

function NotificationHandler:display()
	local instance: CanvasGroup = self.Instance
	
	instance.Parent = Main
	instance.Visible = true
	TweenService:Create(instance, Animation.normal, { GroupTransparency = 0 }):Play()
	TweenService:Create(instance:FindFirstChild("FlashFrame"), Animation.normal, { BackgroundTransparency = 1 }):Play()

	return self
end

return NotificationHandler