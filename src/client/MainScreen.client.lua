-- services
local TweenService = game:GetService("TweenService")

-- modules
local Animation = require(script.Parent.Animation)

-- variables
local Main = script.Parent.Parent:WaitForChild("App"):WaitForChild("MainScreen")
local MainItems = Main.MainItems
local MainButton = MainItems.MainButton

MainButton.MouseEnter:Connect(function()
	TweenService:Create(MainButton.UIScale, Animation.bouncy, { Scale = 1.2 }):Play()
end)

MainButton.MouseLeave:Connect(function()
	TweenService:Create(MainButton.UIScale, Animation.bouncy, { Scale = 1 }):Play()
end)

function itemButton_onMouseEnter(button)
	TweenService:Create(button, Animation.bouncy, { Size = UDim2.new(0, 350, 0, 150) }):Play()
	TweenService:Create(button.Frame, Animation.bouncy, { Size = UDim2.new(1, 0, 1, 0) }):Play()
end

function itemButton_onMouseLeave(button)
	TweenService:Create(button, Animation.bouncy, { Size = UDim2.new(0, 250, 0, 150) }):Play()
	TweenService:Create(button.Frame, Animation.bouncy, { Size = UDim2.new(.84, 0, 1, 0) }):Play()
end

for i, v in MainItems:GetChildren() do
	if v:IsA("ImageButton") then
		v.MouseEnter:Connect(function()
			itemButton_onMouseEnter(v)
		end)
		v.MouseLeave:Connect(function()
			itemButton_onMouseLeave(v)
		end)
	end
end