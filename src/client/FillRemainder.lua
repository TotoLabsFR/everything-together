-- a modulescript to make instances fill its entire container (with help from UIListLayout)
local FillRemainder = {}

function FillRemainder.watch(container: Frame, fillFrame: GuiObject, layout: UIListLayout, padding: UIPadding?)
    local function updateFill()
        local totalUsed = 0
        local paddingCount = 0

        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("GuiObject") and child ~= fillFrame and child.Visible then
                if layout.FillDirection == Enum.FillDirection.Vertical then
                    totalUsed += child.AbsoluteSize.Y
                else
                    totalUsed += child.AbsoluteSize.X
                end
                paddingCount += 1
            end
        end

        -- calculate padding from UIListLayout w/ padding count
        local totalLayoutPadding = 0
        if paddingCount > 0 then
            totalLayoutPadding = layout.Padding.Offset * paddingCount
        end

        -- account for UIPadding on both axes
        local extraPadding = 0
        if padding then
            if layout.FillDirection == Enum.FillDirection.Vertical then
                extraPadding = padding.PaddingTop.Offset + padding.PaddingBottom.Offset
            else
                extraPadding = padding.PaddingLeft.Offset + padding.PaddingRight.Offset
            end
        end

        -- leftover space depends on orientation
        local leftover = 0
        if layout.FillDirection == Enum.FillDirection.Vertical then
            leftover = container.AbsoluteSize.Y - totalUsed - totalLayoutPadding - extraPadding
            fillFrame.Size = UDim2.new(1, 0, 0, math.max(0, leftover))
        else
            leftover = container.AbsoluteSize.X - totalUsed - totalLayoutPadding - extraPadding
            fillFrame.Size = UDim2.new(0, math.max(0, leftover), 1, 0)
        end
    end

    -- connect signals
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateFill)
    container:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateFill)
    fillFrame:GetPropertyChangedSignal("Visible"):Connect(updateFill)

    if padding then
        padding:GetPropertyChangedSignal("PaddingTop"):Connect(updateFill)
        padding:GetPropertyChangedSignal("PaddingBottom"):Connect(updateFill)
        padding:GetPropertyChangedSignal("PaddingLeft"):Connect(updateFill)
        padding:GetPropertyChangedSignal("PaddingRight"):Connect(updateFill)
    end

    -- initial update
    task.defer(updateFill)
end

return FillRemainder