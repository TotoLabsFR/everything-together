local WhosOnTop = {}

function WhosOnTop.setup(container: GuiObject)
    local function reorder()
        local index = 1
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("GuiObject") then
                child.LayoutOrder = index
                child.ZIndex = -index
                index += 1
            end
        end
    end

    -- Initial pass
    reorder()

    container.ChildAdded:Connect(function(child)
        if child:IsA("GuiObject") then
            reorder()
        end
    end)

    container.ChildRemoved:Connect(function()
        reorder()
    end)
end

return WhosOnTop