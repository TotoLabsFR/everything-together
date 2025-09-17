-- CustomListLayout Module
-- Replicates basic UIListLayout functionality with tweened positioning and direction attribute
local TweenService = game:GetService("TweenService")
local Animation = require(script.Parent.Animation)
local CustomListLayout = {}

-- Helper function to tween a GuiObject's position
local function tweenPosition(guiObject, targetPosition, isNew)
	if isNew then
		-- Start a bit higher to animate in
		guiObject.Position = targetPosition - UDim2.new(0, 0, 0, guiObject.AbsoluteSize.Y)
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
		tweenPosition(child, targetPosition, isNew)
		if isNew then
			child:SetAttribute("IsNewItem", nil)
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