-- =============================================
-- MACRO BUTTON - ONLY SHOWS WHEN ENABLED
-- =============================================
local MacroBtn = Instance.new("TextButton")
MacroBtn.Size = UDim2.fromOffset(60, 28)
MacroBtn.Position = UDim2.new(0.5, -30, 0.85, 0)
MacroBtn.BackgroundColor3 = COLORS.RED
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = COLORS.WHITE
MacroBtn.TextSize = 12
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Visible = false  -- HIDDEN by default
MacroBtn.Parent = Gui
Corner(MacroBtn, 8)
Stroke(MacroBtn)

-- Update macro button visibility
local function UpdateMacroButton()
    if Features.Macro and #MacroBlocks > 0 then
        MacroBtn.Visible = true
        MacroBtn.BackgroundColor3 = COLORS.RED
        MacroBtn.Text = "MACRO"
        MacroBtn.TextColor3 = COLORS.WHITE
    else
        MacroBtn.Visible = false
    end
end

-- Drag for Macro button
local macroDrag = {dragging = false, startPos = nil, startMouse = nil}

MacroBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.dragging = true
        macroDrag.startMouse = input.Position
        macroDrag.startPos = MacroBtn.Position
    end
end)

MacroBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if macroDrag.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - macroDrag.startMouse
        MacroBtn.Position = UDim2.new(
            macroDrag.startPos.X.Scale,
            macroDrag.startPos.X.Offset + delta.X,
            macroDrag.startPos.Y.Scale,
            macroDrag.startPos.Y.Offset + delta.Y
        )
    end
end)

MacroBtn.MouseButton1Click:Connect(function()
    if Features.Macro and #MacroBlocks > 0 then
        ExecuteMacro()
        MacroBtn.BackgroundColor3 = COLORS.GREEN
        MacroBtn.Text = "▶"
        task.delay(0.5, function()
            if Features.Macro and #MacroBlocks > 0 then
                MacroBtn.BackgroundColor3 = COLORS.RED
                MacroBtn.Text = "MACRO"
            else
                MacroBtn.Visible = false
            end
        end)
    end
end)

-- Update button when macro state changes
task.spawn(function()
    while Gui and Gui.Parent do
        UpdateMacroButton()
        task.wait(0.5)
    end
end)
