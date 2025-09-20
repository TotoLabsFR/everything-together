-- Wanted to add tweening to list layouts so had to make my own
local TweenService = game:GetService("TweenService")
local Animation = require(script.Parent.Animation)
local CustomListLayout = {}

-- Helper function to tween a GuiObject's position
local function tweenPosition(guiObject: GuiObject, targetPosition, isNew, direction)
	if isNew then
		-- Start a bit on the side to animate in
		if direction == "Right" then
			guiObject.Position = targetPosition + UDim2.new(0, guiObject.AbsoluteSize.X, 0, 0)
		elseif direction == "Left" then
			guiObject.Position = targetPosition - UDim2.new(0, guiObject.AbsoluteSize.X, 0, 0)
		elseif direction == "Down" then
			guiObject.Position = targetPosition + UDim2.new(0, 0, 0, guiObject.AbsoluteSize.Y)
		elseif direction == "Up" then
			guiObject.Position = targetPosition - UDim2.new(0, 0, 0, guiObject.AbsoluteSize.Y)
		else
			guiObject.Position = targetPosition - UDim2.new(0, guiObject.AbsoluteSize.X, 0, 0)
		end
	end
	local tweenInfo = Animation.normal
	local tween = TweenService:Create(guiObject, tweenInfo, {Position = targetPosition})
	tween:Play()
end

-- Helper function to update layout
local function updateLayout(container)
	local padding = container:GetAttribute("CustomListPadding") or 0
	local horizontal = container:GetAttribute("CustomListHorizontal") or false
	local direction = container:GetAttribute("CustomListDirection") or "Down" -- "Down", "Up", "Left", "Right"
	local arriveDirection = container:GetAttribute("CustomListArriveDirection") or "Down" -- "Down", "Up", "Left", "Right"

	local pos = 0
	local children = {}
	for i, child in container:GetChildren() do
		if child:IsA("GuiObject") then
			table.insert(children, child)
		end
	end

	-- For "Up" direction, newest notification should be at the top
	if direction == "Up" then
		-- Sort children so newest is first (assuming last added is newest)
		local sorted = {}
		for i = #children, 1, -1 do
			table.insert(sorted, children[i])
		end
		children = sorted
	elseif direction == "Left" then
		-- For "Left", reverse order
		local reversed = {}
		for i = #children, 1, -1 do
			table.insert(reversed, children[i])
		end
		children = reversed
	end

	for i, child in children do
		local targetPosition
		if horizontal or direction == "Left" or direction == "Right" then
			-- Horizontal layout
			targetPosition = UDim2.new(0, pos, child.Position.Y.Scale, child.Position.Y.Offset)
			pos = pos + child.Size.X.Offset + padding
		else
			-- Vertical layout
			targetPosition = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, pos)
			pos = pos + child.Size.Y.Offset + padding
		end

		local isNew = child:GetAttribute("IsNewItem")
		tweenPosition(child, targetPosition, isNew, arriveDirection)
		if isNew then
			child:SetAttribute("IsNewItem", nil)
		end
	end

	if container:IsA("ScrollingFrame") then
		if horizontal or direction == "Left" or direction == "Right" then
			container.CanvasSize = UDim2.new(0, pos, 0, container.AbsoluteSize.Y)
		else
			container.CanvasSize = UDim2.new(0, container.AbsoluteSize.X, 0, pos)
		end
	end
end

function CustomListLayout.setup(container: Instance)
	-- Initial layout
	updateLayout(container)
	-- Listen for child changes
	container.ChildAdded:Connect(function(child)
		if child:IsA("GuiObject") then
			child:SetAttribute("IsNewItem", true)
		end
		updateLayout(container)
	end)
	container.ChildRemoved:Connect(function()
		updateLayout(container)
	end)
	-- Optionally listen for attribute changes (padding, direction)
	container:GetAttributeChangedSignal("CustomListPadding"):Connect(function()
		updateLayout(container)
	end)
	container:GetAttributeChangedSignal("CustomListHorizontal"):Connect(function()
		updateLayout(container)
	end)
	container:GetAttributeChangedSignal("CustomListDirection"):Connect(function()
		updateLayout(container)
	end)
end

return CustomListLayout