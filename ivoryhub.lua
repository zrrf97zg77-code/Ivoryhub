--// IVORY HUB (WORKING VERSION - BLACKLIST + MACRO)
--// Credits: lvory999, rayo06996
print("Ivory Hub loading...")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local VirtualInputManager
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

-- Delete old GUI
local Old = PlayerGui:FindFirstChild("IvoryHub")
if Old then Old:Destroy() end

--// COLORS
local BLACK = Color3.fromRGB(10,10,10)
local DARK = Color3.fromRGB(17,17,17)
local LIGHT = Color3.fromRGB(30,30,30)
local WHITE = Color3.fromRGB(245,245,245)
local GRAY = Color3.fromRGB(145,145,145)

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--// MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(520, 330)
Main.Position = UDim2.new(.5, -260, .5, -165)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Parent = Gui
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(55, 55, 55)
MainStroke.Thickness = 1

--// TOP
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 28)
Title.Position = UDim2.fromOffset(18, 7)
Title.BackgroundTransparency = 1
Title.Text = "IVORY HUB"
Title.TextColor3 = WHITE
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, -100, 0, 18)
Sub.Position = UDim2.fromOffset(19, 32)
Sub.BackgroundTransparency = 1
Sub.Text = "pvp • clean • simple"
Sub.TextColor3 = GRAY
Sub.TextSize = 9
Sub.Font = Enum.Font.Gotham
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Top

--// CLOSE
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -45, 0, 11)
Close.BackgroundColor3 = LIGHT
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 22
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Top
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 9)

--// SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 135, 1, -78)
Sidebar.Position = UDim2.fromOffset(10, 68)
Sidebar.BackgroundColor3 = DARK
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = GRAY
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 11)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 9)
SidePadding.PaddingBottom = UDim.new(0, 9)
SidePadding.Parent = Sidebar

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y + 18)
end)

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -78)
Content.Position = UDim2.fromOffset(155, 68)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 11)

--// PAGES
local Pages = {}

local function CreatePage(Name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.fromOffset(10, 10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = GRAY
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    Pages[Name] = Page
    return Page
end

--// CREATE BUTTON
local function CreateButton(Parent, Text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = LIGHT
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = WHITE
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Parent
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = LIGHT
    end)

    return Button
end

--// CREATE TOGGLE (simple)
local function CreateToggle(Parent, Text, Default, OnClick)
    local state = Default or false
    local btn = CreateButton(Parent, Text .. (state and " ON" or " OFF"))
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = Text .. (state and " ON" or " OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or LIGHT
        if OnClick then OnClick(state) end
    end)
    return btn
end

--// PAGES
local Home = CreatePage("Home")
local MainPage = CreatePage("Main")
local BlacklistPage = CreatePage("Blacklist")
local ComboPage = CreatePage("Combo")
local VisualsPage = CreatePage("Visuals")
local PlayersPage = CreatePage("Players")
local SettingsPage = CreatePage("Settings")
local InfoPage = CreatePage("Info")
local CreditsPage = CreatePage("Credits")

--// TABS
local function CreateTab(Text, Page)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -18, 0, 35)
    Button.BackgroundColor3 = LIGHT
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = GRAY
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Sidebar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        for _, P in pairs(Pages) do P.Visible = false end
        Page.Visible = true
        for _, B in ipairs(Sidebar:GetChildren()) do
            if B:IsA("TextButton") then
                B.BackgroundColor3 = LIGHT
                B.TextColor3 = GRAY
            end
        end
        Button.BackgroundColor3 = WHITE
        Button.TextColor3 = BLACK
    end)

    return Button
end

local HomeTab = CreateTab("Home", Home)
CreateTab("Main", MainPage)
CreateTab("Blacklist", BlacklistPage)
CreateTab("Combo", ComboPage)
CreateTab("Visuals", VisualsPage)
CreateTab("Players", PlayersPage)
CreateTab("Settings", SettingsPage)
CreateTab("Info", InfoPage)
CreateTab("Credits", CreditsPage)

Home.Visible = true
HomeTab.BackgroundColor3 = WHITE
HomeTab.TextColor3 = BLACK

--// TOGGLE BUTTON (I icon)
local Toggle = Instance.new("TextButton")
Toggle.Name = "IvoryToggle"
Toggle.Size = UDim2.fromOffset(44, 44)
Toggle.Position = UDim2.new(0, 15, 0.5, -22)
Toggle.BackgroundColor3 = BLACK
Toggle.BorderSizePixel = 0
Toggle.Text = "I"
Toggle.TextColor3 = WHITE
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 12)
local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = WHITE
ToggleStroke.Thickness = 1

--// DRAG
local function MakeDraggable(Object)
    local Dragging = false
    local DragStart
    local StartPosition

    Object.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position
        end
    end)

    Object.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            Object.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
end

MakeDraggable(Main)
MakeDraggable(Toggle)

--// MACRO BUTTON (floating)
local MacroButton = Instance.new("TextButton")
MacroButton.Name = "MacroButton"
MacroButton.Size = UDim2.fromOffset(80, 32)
MacroButton.Position = UDim2.new(0.02, 0, 0.85, 0)
MacroButton.BackgroundColor3 = BLACK
MacroButton.BorderSizePixel = 0
MacroButton.Text = "⚡ MACRO"
MacroButton.TextColor3 = WHITE
MacroButton.TextSize = 12
MacroButton.Font = Enum.Font.GothamBold
MacroButton.AutoButtonColor = false
MacroButton.Visible = false
MacroButton.Parent = Gui
MacroButton.ZIndex = 20
Instance.new("UICorner", MacroButton).CornerRadius = UDim.new(0, 8)
local MacroStroke = Instance.new("UIStroke", MacroButton)
MacroStroke.Color = WHITE
MacroStroke.Thickness = 1
MakeDraggable(MacroButton)

--// OPEN/CLOSE
local Open = true

local function OpenGUI()
    Open = true
    Main.Visible = true
end

local function CloseGUI()
    Open = false
    Main.Visible = false
end

Toggle.MouseButton1Click:Connect(function()
    if Open then CloseGUI() else OpenGUI() end
end)

Close.MouseButton1Click:Connect(function()
    CloseGUI()
end)

OpenGUI()

-- ==================================================================
--                   HOME PAGE
-- ==================================================================
local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, 0, 0, 40)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "WELCOME TO IVORY HUB"
HomeTitle.TextColor3 = WHITE
HomeTitle.TextSize = 16
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.Parent = Home

local HomeSub = Instance.new("TextLabel")
HomeSub.Size = UDim2.new(1, 0, 0, 30)
HomeSub.Position = UDim2.new(0, 0, 0, 45)
HomeSub.BackgroundTransparency = 1
HomeSub.Text = "PVP • Clean • Simple"
HomeSub.TextColor3 = GRAY
HomeSub.TextSize = 11
HomeSub.Font = Enum.Font.Gotham
HomeSub.Parent = Home

-- ==================================================================
--                   MAIN PAGE – PLAYER STATS
-- ==================================================================
local function getStat(statName)
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            if string.lower(child.Name):find(string.lower(statName)) then
                return child.Value
            end
        end
    end
    return "?"
end

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 0, 100)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = MainPage

local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(1, 0, 0, 25)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Level: " .. tostring(getStat("Level"))
levelLabel.TextColor3 = WHITE
levelLabel.TextSize = 14
levelLabel.Font = Enum.Font.GothamBold
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = statsFrame

local bountyLabel = Instance.new("TextLabel")
bountyLabel.Size = UDim2.new(1, 0, 0, 25)
bountyLabel.Position = UDim2.new(0, 0, 0, 30)
bountyLabel.BackgroundTransparency = 1
bountyLabel.Text = "Bounty: " .. tostring(getStat("Bounty") or getStat("Honor") or "0")
bountyLabel.TextColor3 = WHITE
bountyLabel.TextSize = 14
bountyLabel.Font = Enum.Font.GothamBold
bountyLabel.TextXAlignment = Enum.TextXAlignment.Left
bountyLabel.Parent = statsFrame

local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, 0, 0, 25)
moneyLabel.Position = UDim2.new(0, 0, 0, 60)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "Money: $" .. tostring(getStat("Money") or getStat("Cash") or "0")
moneyLabel.TextColor3 = WHITE
moneyLabel.TextSize = 14
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = statsFrame

spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            levelLabel.Text = "Level: " .. tostring(getStat("Level"))
            bountyLabel.Text = "Bounty: " .. tostring(getStat("Bounty") or getStat("Honor") or "0")
            moneyLabel.Text = "Money: $" .. tostring(getStat("Money") or getStat("Cash") or "0")
        end)
    end
end)

--// NOCLIP
local noclipEnabled = false
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    for _, child in ipairs(MainPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 6) == "NOCLIP" then
            child.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
            child.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
    if noclipEnabled then
        pcall(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        pcall(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end)
    end
end
local noclipBtn = CreateButton(MainPage, "NOCLIP: OFF")
noclipBtn.MouseButton1Click:Connect(toggleNoclip)

--// ANTI-STUN
local antiStun = false
local function toggleAntiStun()
    antiStun = not antiStun
    for _, child in ipairs(MainPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 9) == "ANTI-STUN" then
            child.Text = antiStun and "ANTI-STUN: ON" or "ANTI-STUN: OFF"
            child.BackgroundColor3 = antiStun and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
    if antiStun then
        pcall(function()
            local char = player.Character
            if char then
                char:SetAttribute("AllCooldown", 0)
                char:SetAttribute("FlashstepCooldown", 1)
                char:SetAttribute("UsingSkill", false)
                char:SetAttribute("isUsingSkill", false)
                char:SetAttribute("Busy", false)
            end
        end)
    else
        pcall(function()
            local char = player.Character
            if char then
                char:SetAttribute("AllCooldown", nil)
                char:SetAttribute("FlashstepCooldown", nil)
            end
        end)
    end
end
local antiStunBtn = CreateButton(MainPage, "ANTI-STUN: OFF")
antiStunBtn.MouseButton1Click:Connect(toggleAntiStun)

-- ==================================================================
--                   BLACKLIST PAGE
-- ==================================================================
local blacklist = {
    Fruit = { Z = false, X = false, C = false, V = false, F = false },
    Sword = { Z = false, X = false, C = false, V = false, F = false },
    Gun = { Z = false, X = false, C = false, V = false, F = false },
    Melee = { Z = false, X = false, C = false, V = false, F = false },
}

local function buildBlacklistUI()
    for _, child in ipairs(BlacklistPage:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
            child:Destroy()
        end
    end

    local categories = { "Fruit", "Sword", "Gun", "Melee" }
    local keys = { "Z", "X", "C", "V", "F" }
    local y = 10
    for _, cat in ipairs(categories) do
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 24)
        header.Position = UDim2.new(0, 0, 0, y)
        header.BackgroundTransparency = 1
        header.Text = cat:upper() .. " BLACKLIST"
        header.TextColor3 = WHITE
        header.TextSize = 12
        header.Font = Enum.Font.GothamBold
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = BlacklistPage
        y = y + 28
        for _, key in ipairs(keys) do
            local btn = CreateToggle(BlacklistPage, cat .. " " .. key, false, function(state)
                blacklist[cat][key] = state
            end)
            btn.Position = UDim2.new(0.03, 0, 0, y)
            btn.Size = UDim2.new(0.94, 0, 0, 26)
            y = y + 30
        end
        y = y + 10
    end
end
buildBlacklistUI()

-- ==================================================================
--                   COMBO MACRO PAGE
-- ==================================================================
local comboSteps = {
    {slot = 1, key = "Z", delay = 0.2},
    {slot = 1, key = "X", delay = 0.2},
    {slot = 2, key = "C", delay = 0.2},
    {slot = 2, key = "V", delay = 0.3},
}
local comboEnabled = false

function executeComboSteps()
    if not comboEnabled then return end
    task.spawn(function()
        for _, step in ipairs(comboSteps) do
            if not comboEnabled then break end
            pcall(function()
                local slot = step.slot or 1
                local key = step.key or "Z"
                local delay = step.delay or 0.3

                local slotKeys = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}
                if slot >= 1 and slot <= 4 and VirtualInputManager then
                    VirtualInputManager:SendKeyEvent(true, slotKeys[slot], false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, slotKeys[slot], false, game)
                end

                if key == "M1" then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local regAttack = remotes:FindFirstChild("RE/RegisterAttack")
                        if regAttack then regAttack:FireServer(0) end
                    end
                else
                    local keyCode = Enum.KeyCode[key]
                    if keyCode and VirtualInputManager then
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    end
                end

                if delay > 0 then task.wait(delay) end
            end)
        end
    end)
end

local function toggleCombo()
    comboEnabled = not comboEnabled
    for _, child in ipairs(ComboPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 11) == "COMBO MACRO" then
            child.Text = comboEnabled and "COMBO MACRO: ON" or "COMBO MACRO: OFF"
            child.BackgroundColor3 = comboEnabled and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
    MacroButton.Visible = comboEnabled
end
local comboBtn = CreateButton(ComboPage, "COMBO MACRO: OFF")
comboBtn.MouseButton1Click:Connect(toggleCombo)

MacroButton.MouseButton1Click:Connect(function()
    if comboEnabled then executeComboSteps() end
end)

local stepCountLabel = Instance.new("TextLabel")
stepCountLabel.Size = UDim2.new(1, 0, 0, 20)
stepCountLabel.Position = UDim2.new(0, 0, 0, 0)
stepCountLabel.BackgroundTransparency = 1
stepCountLabel.Text = "Steps: " .. #comboSteps
stepCountLabel.TextColor3 = WHITE
stepCountLabel.TextSize = 10
stepCountLabel.Font = Enum.Font.Gotham
stepCountLabel.TextXAlignment = Enum.TextXAlignment.Left
stepCountLabel.Parent = ComboPage

local function rebuildStepUI()
    for _, child in ipairs(ComboPage:GetChildren()) do
        if child:IsA("Frame") and child.Name == "StepContainer" then
            child:Destroy()
        end
    end

    local container = Instance.new("Frame")
    container.Name = "StepContainer"
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = ComboPage

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = container

    for i, step in ipairs(comboSteps) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.Parent = container

        local num = Instance.new("TextLabel")
        num.Size = UDim2.new(0, 25, 1, 0)
        num.BackgroundTransparency = 1
        num.Text = i .. "."
        num.TextColor3 = WHITE
        num.TextSize = 10
        num.Font = Enum.Font.GothamBold
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.Parent = row

        local slotBtn = Instance.new("TextButton")
        slotBtn.Size = UDim2.new(0, 45, 1, 0)
        slotBtn.Position = UDim2.new(0, 30, 0, 0)
        slotBtn.BackgroundColor3 = LIGHT
        slotBtn.BorderSizePixel = 0
        slotBtn.Text = "S" .. step.slot
        slotBtn.TextColor3 = WHITE
        slotBtn.TextSize = 10
        slotBtn.Font = Enum.Font.GothamMedium
        slotBtn.AutoButtonColor = false
        slotBtn.Parent = row
        Instance.new("UICorner", slotBtn).CornerRadius = UDim.new(0, 4)
        slotBtn.MouseButton1Click:Connect(function()
            step.slot = step.slot % 4 + 1
            slotBtn.Text = "S" .. step.slot
        end)

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0, 45, 1, 0)
        keyBtn.Position = UDim2.new(0, 80, 0, 0)
        keyBtn.BackgroundColor3 = LIGHT
        keyBtn.BorderSizePixel = 0
        keyBtn.Text = step.key
        keyBtn.TextColor3 = WHITE
        keyBtn.TextSize = 10
        keyBtn.Font = Enum.Font.GothamMedium
        keyBtn.AutoButtonColor = false
        keyBtn.Parent = row
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 4)
        local keys = {"Z", "X", "C", "V", "F", "M1"}
        local keyIdx = table.find(keys, step.key) or 1
        keyBtn.MouseButton1Click:Connect(function()
            keyIdx = keyIdx % #keys + 1
            step.key = keys[keyIdx]
            keyBtn.Text = step.key
        end)

        local delayFrame = Instance.new("Frame")
        delayFrame.Size = UDim2.new(0, 110, 1, 0)
        delayFrame.Position = UDim2.new(0, 130, 0, 0)
        delayFrame.BackgroundTransparency = 1
        delayFrame.Parent = row

        local delayLabel = Instance.new("TextLabel")
        delayLabel.Size = UDim2.new(0.5, 0, 1, 0)
        delayLabel.BackgroundTransparency = 1
        delayLabel.Text = string.format("%.2f", step.delay)
        delayLabel.TextColor3 = WHITE
        delayLabel.TextSize = 10
        delayLabel.Font = Enum.Font.GothamBold
        delayLabel.TextXAlignment = Enum.TextXAlignment.Right
        delayLabel.Parent = delayFrame

        local decBtn = Instance.new("TextButton")
        decBtn.Size = UDim2.new(0, 20, 1, 0)
        decBtn.Position = UDim2.new(0.55, 0, 0, 0)
        decBtn.BackgroundColor3 = LIGHT
        decBtn.BorderSizePixel = 0
        decBtn.Text = "-"
        decBtn.TextColor3 = WHITE
        decBtn.TextSize = 12
        decBtn.Font = Enum.Font.GothamBold
        decBtn.AutoButtonColor = false
        decBtn.Parent = delayFrame
        Instance.new("UICorner", decBtn).CornerRadius = UDim.new(0, 4)
        decBtn.MouseButton1Click:Connect(function()
            step.delay = math.max(0.05, math.floor((step.delay - 0.05) * 100) / 100)
            delayLabel.Text = string.format("%.2f", step.delay)
        end)

        local incBtn = Instance.new("TextButton")
        incBtn.Size = UDim2.new(0, 20, 1, 0)
        incBtn.Position = UDim2.new(0.8, 0, 0, 0)
        incBtn.BackgroundColor3 = LIGHT
        incBtn.BorderSizePixel = 0
        incBtn.Text = "+"
        incBtn.TextColor3 = WHITE
        incBtn.TextSize = 12
        incBtn.Font = Enum.Font.GothamBold
        incBtn.AutoButtonColor = false
        incBtn.Parent = delayFrame
        Instance.new("UICorner", incBtn).CornerRadius = UDim.new(0, 4)
        incBtn.MouseButton1Click:Connect(function()
            step.delay = math.min(2.0, math.floor((step.delay + 0.05) * 100) / 100)
            delayLabel.Text = string.format("%.2f", step.delay)
        end)

        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 20, 1, 0)
        removeBtn.Position = UDim2.new(1, -22, 0, 0)
        removeBtn.BackgroundColor3 = LIGHT
        removeBtn.BorderSizePixel = 0
        removeBtn.Text = "✕"
        removeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        removeBtn.TextSize = 12
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.AutoButtonColor = false
        removeBtn.Parent = row
        Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 4)
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(comboSteps, i)
            rebuildStepUI()
            stepCountLabel.Text = "Steps: " .. #comboSteps
        end)
    end

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(1, 0, 0, 28)
    addBtn.BackgroundColor3 = LIGHT
    addBtn.BorderSizePixel = 0
    addBtn.Text = "+ ADD STEP"
    addBtn.TextColor3 = WHITE
    addBtn.TextSize = 11
    addBtn.Font = Enum.Font.GothamMedium
    addBtn.AutoButtonColor = false
    addBtn.Parent = container
    Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 4)
    addBtn.MouseButton1Click:Connect(function()
        table.insert(comboSteps, {slot = 1, key = "Z", delay = 0.2})
        rebuildStepUI()
        stepCountLabel.Text = "Steps: " .. #comboSteps
    end)

    container.Size = UDim2.new(1, 0, 0, 28 * #comboSteps + 32)
    stepCountLabel.Text = "Steps: " .. #comboSteps
end
rebuildStepUI()

-- ==================================================================
--                   VISUALS (ESP) PAGE
-- ==================================================================
local espEnabled = false
local espName = true
local espDist = true
local espHealth = false

local function toggleESP()
    espEnabled = not espEnabled
    for _, child in ipairs(VisualsPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 10) == "ESP MASTER" then
            child.Text = espEnabled and "ESP MASTER: ON" or "ESP MASTER: OFF"
            child.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
    if not espEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "IvoryESP" then v:Destroy() end
        end
    end
end
local espBtn = CreateButton(VisualsPage, "ESP MASTER: OFF")
espBtn.MouseButton1Click:Connect(toggleESP)

local function toggleESPName()
    espName = not espName
    for _, child in ipairs(VisualsPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 9) == "SHOW NAME" then
            child.Text = espName and "SHOW NAME: ON" or "SHOW NAME: OFF"
            child.BackgroundColor3 = espName and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
end
local nameBtn = CreateButton(VisualsPage, "SHOW NAME: ON")
nameBtn.MouseButton1Click:Connect(toggleESPName)

local function toggleESPDist()
    espDist = not espDist
    for _, child in ipairs(VisualsPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 13) == "SHOW DISTANCE" then
            child.Text = espDist and "SHOW DISTANCE: ON" or "SHOW DISTANCE: OFF"
            child.BackgroundColor3 = espDist and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
end
local distBtn = CreateButton(VisualsPage, "SHOW DISTANCE: ON")
distBtn.MouseButton1Click:Connect(toggleESPDist)

local function toggleESPHealth()
    espHealth = not espHealth
    for _, child in ipairs(VisualsPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 11) == "SHOW HEALTH" then
            child.Text = espHealth and "SHOW HEALTH: ON" or "SHOW HEALTH: OFF"
            child.BackgroundColor3 = espHealth and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
end
local healthBtn = CreateButton(VisualsPage, "SHOW HEALTH: OFF")
healthBtn.MouseButton1Click:Connect(toggleESPHealth)

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            if head then
                local bill = head:FindFirstChild("IvoryESP")
                if not bill then
                    bill = Instance.new("BillboardGui")
                    bill.Name = "IvoryESP"
                    bill.Size = UDim2.new(0, 200, 0, 50)
                    bill.Adornee = head
                    bill.AlwaysOnTop = true
                    bill.Parent = head
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = WHITE
                    label.TextStrokeColor3 = BLACK
                    label.TextStrokeTransparency = 0
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 10
                    label.Parent = bill
                end
                local label = bill:FindFirstChild("TextLabel")
                if label then
                    local text = ""
                    if espName then text = text .. p.Name end
                    if espDist then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if root and myRoot then
                            local dist = math.floor((root.Position - myRoot.Position).Magnitude)
                            if espName then text = text .. "  " end
                            text = text .. dist .. "m"
                        end
                    end
                    if espHealth then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local hp = math.floor((hum.Health / hum.MaxHealth) * 100)
                            if espName or espDist then text = text .. "  " end
                            text = text .. hp .. "% HP"
                        end
                    end
                    label.Text = text
                end
            end
        end
    end
end)

-- ==================================================================
--                   PLAYERS & SETTINGS
-- ==================================================================
CreateButton(PlayersPage, "Player List (Coming Soon)")
CreateButton(PlayersPage, "Refresh Players")

-- Settings: Dark Theme
local themeBlack = true
local function applyTheme(dark)
    themeBlack = dark
    if dark then
        Main.BackgroundColor3 = BLACK
        Top.BackgroundColor3 = DARK
        Content.BackgroundColor3 = DARK
        Sidebar.BackgroundColor3 = DARK
        Title.TextColor3 = WHITE
        Sub.TextColor3 = GRAY
        MainStroke.Color = Color3.fromRGB(55,55,55)
        Toggle.BackgroundColor3 = BLACK
        Toggle.TextColor3 = WHITE
        ToggleStroke.Color = WHITE
        Close.BackgroundColor3 = LIGHT
        Close.TextColor3 = WHITE
        MacroButton.BackgroundColor3 = BLACK
        MacroButton.TextColor3 = WHITE
        MacroStroke.Color = WHITE
        for _, page in pairs(Pages) do
            for _, child in ipairs(page:GetDescendants()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = WHITE
                end
                if child:IsA("TextButton") and child.BackgroundColor3 ~= Color3.fromRGB(0, 180, 0) then
                    child.TextColor3 = WHITE
                end
            end
        end
    else
        Main.BackgroundColor3 = WHITE
        Top.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        Content.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        Sidebar.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        Title.TextColor3 = BLACK
        Sub.TextColor3 = Color3.fromRGB(80, 80, 80)
        MainStroke.Color = Color3.fromRGB(200, 200, 200)
        Toggle.BackgroundColor3 = WHITE
        Toggle.TextColor3 = BLACK
        ToggleStroke.Color = BLACK
        Close.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        Close.TextColor3 = BLACK
        MacroButton.BackgroundColor3 = WHITE
        MacroButton.TextColor3 = BLACK
        MacroStroke.Color = BLACK
        for _, page in pairs(Pages) do
            for _, child in ipairs(page:GetDescendants()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = BLACK
                end
                if child:IsA("TextButton") and child.BackgroundColor3 ~= Color3.fromRGB(0, 180, 0) then
                    child.TextColor3 = BLACK
                end
            end
        end
    end
    for _, obj in ipairs(Sidebar:GetChildren()) do
        if obj:IsA("TextButton") then
            if obj.BackgroundColor3 == WHITE then
                obj.BackgroundColor3 = dark and WHITE or BLACK
                obj.TextColor3 = dark and BLACK or WHITE
            else
                obj.BackgroundColor3 = dark and LIGHT or Color3.fromRGB(220, 220, 220)
                obj.TextColor3 = dark and WHITE or BLACK
            end
        end
    end
end

local function toggleTheme()
    themeBlack = not themeBlack
    for _, child in ipairs(SettingsPage:GetChildren()) do
        if child:IsA("TextButton") and string.sub(child.Text, 1, 10) == "DARK THEME" then
            child.Text = themeBlack and "DARK THEME: ON" or "DARK THEME: OFF"
            child.BackgroundColor3 = themeBlack and Color3.fromRGB(0, 180, 0) or LIGHT
            break
        end
    end
    applyTheme(themeBlack)
end
local themeBtn = CreateButton(SettingsPage, "DARK THEME: ON")
themeBtn.MouseButton1Click:Connect(toggleTheme)
applyTheme(true)

-- Info
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 0, 140)
infoText.Position = UDim2.new(0, 0, 0, 10)
infoText.BackgroundTransparency = 1
infoText.Text = "Ivory Hub (Blacklist + Macro)\n\nCreated by: lvory999\n\nIdeas: rayo06996\n\nFeatures:\n- Blacklist: disable aimbot for specific skills\n- Combo Macro: custom step editor with execute"
infoText.TextColor3 = WHITE
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = InfoPage

local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, 0, 0, 120)
creditsText.Position = UDim2.new(0, 0, 0, 10)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Ivory Hub\n\nDesign & Development: lvory999\n\nIdeas: rayo06996\n\nSpecial thanks to the community."
creditsText.TextColor3 = WHITE
creditsText.TextSize = 11
creditsText.Font = Enum.Font.Gotham
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Parent = CreditsPage

print("Ivory Hub loaded successfully!")
