--// IVORY HUB — FULL SCRIPT (Key System + 180° Aimbot + Fixed Soru + Macro Builder)
--// Key: Ivory | Mobile Only | Black & White Premium

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local mouse = Player:GetMouse()

pcall(function()
    PlayerGui:FindFirstChild("IvoryHub"):Destroy()
    PlayerGui:FindFirstChild("IvoryKeyGui"):Destroy()
end)

--// COLORS
local BLACK = Color3.fromRGB(8, 8, 8)
local DARK = Color3.fromRGB(13, 13, 13)
local PANEL = Color3.fromRGB(17, 17, 17)
local WHITE = Color3.fromRGB(255, 255, 255)
local IVORY = Color3.fromRGB(255, 255, 240)
local GREY = Color3.fromRGB(145, 145, 145)
local DARKGREY = Color3.fromRGB(35, 35, 35)
local RED = Color3.fromRGB(255, 80, 80)
local GREEN = Color3.fromRGB(80, 255, 120)
local GOLD = Color3.fromRGB(255, 215, 0)

local function tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

--// KEY SYSTEM
local VALID_KEY = "Ivory"
local KeyValid = false

--// AIMBOT VARIABLES
local Aimbot = {
    Enabled = false,
    MaxDistance = 3000,
    TargetPlayers = true,
    TargetNPCs = false,
    ShowLine = false,
    ShowFOV = false,
    CurrentTarget = nil,
    FOV = 180,
    Prediction = 0.15
}

--// COMBAT VARIABLES
local Combat = {
    ESPEnabled = false,
    ESPBoxes = {},
    ESPNames = {},
    ESPNamesEnabled = false,
    ESPDistance = {},
    ESPDistanceEnabled = false,
    SpeedHack = false,
    SpeedMultiplier = 15,
    NoClip = false,
    SoruButtonVisible = false,
    SoruCooldown = 1.5,
    LastSoru = 0,
    SoruDistance = 20,
    AntiStun = false,
    MacroEnabled = false,
    MacroSteps = {},
    LastMacroAction = 0
}

local MoveLists = {
    Melee = {"Z", "X", "C"},
    Sword = {"Z", "X"},
    Fruit = {"Z", "X", "C", "V", "F"},
    Gun = {"Z", "X"}
}

--// KEY GUI (Black & White Premium)
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "IvoryKeyGui"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent = PlayerGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(340, 200)
KeyFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
KeyFrame.BackgroundColor3 = BLACK
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = IVORY
KeyStroke.Thickness = 2
KeyStroke.Transparency = 0.2

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 4)
AccentBar.BackgroundColor3 = IVORY
AccentBar.BorderSizePixel = 0
AccentBar.Parent = KeyFrame
Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 16)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 20)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "IVORY HUB"
KeyTitle.TextColor3 = IVORY
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 24
KeyTitle.Parent = KeyFrame

local KeySubTitle = Instance.new("TextLabel")
KeySubTitle.Size = UDim2.new(1, 0, 0, 20)
KeySubTitle.Position = UDim2.new(0, 0, 0, 60)
KeySubTitle.BackgroundTransparency = 1
KeySubTitle.Text = "ENTER ACCESS KEY"
KeySubTitle.TextColor3 = GREY
KeySubTitle.Font = Enum.Font.GothamMedium
KeySubTitle.TextSize = 10
KeySubTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 36)
KeyBox.Position = UDim2.new(0.1, 0, 0, 90)
KeyBox.BackgroundColor3 = DARKGREY
KeyBox.BorderSizePixel = 0
KeyBox.Text = ""
KeyBox.PlaceholderText = "ENTER KEY"
KeyBox.PlaceholderColor3 = GREY
KeyBox.TextColor3 = WHITE
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 14
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
local BoxStroke = Instance.new("UIStroke", KeyBox)
BoxStroke.Color = IVORY
BoxStroke.Thickness = 1
BoxStroke.Transparency = 0.5

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0.8, 0, 0, 36)
KeyButton.Position = UDim2.new(0.1, 0, 0, 140)
KeyButton.BackgroundColor3 = IVORY
KeyButton.BorderSizePixel = 0
KeyButton.Text = "UNLOCK"
KeyButton.TextColor3 = BLACK
KeyButton.Font = Enum.Font.GothamBold
KeyButton.TextSize = 14
KeyButton.AutoButtonColor = false
KeyButton.Parent = KeyFrame
Instance.new("UICorner", KeyButton).CornerRadius = UDim.new(0, 8)

KeyButton.MouseEnter:Connect(function()
    tween(KeyButton, 0.2, {BackgroundColor3 = Color3.fromRGB(220, 220, 200)})
end)
KeyButton.MouseLeave:Connect(function()
    tween(KeyButton, 0.2, {BackgroundColor3 = IVORY})
end)

--// LOAD FULL SCRIPT
local function LoadFullScript()
    KeyValid = true
    KeyGui:Destroy()

    --// MAIN GUI
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "IvoryHub"
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.Parent = PlayerGui

    -- Floating Toggle
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.fromOffset(38, 38)
    Toggle.Position = UDim2.new(0, 16, 0.5, -19)
    Toggle.BackgroundColor3 = BLACK
    Toggle.Text = "I"
    Toggle.TextColor3 = IVORY
    Toggle.TextSize = 18
    Toggle.Font = Enum.Font.GothamBold
    Toggle.AutoButtonColor = false
    Toggle.Parent = Gui
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 11)
    local ToggleStroke = Instance.new("UIStroke", Toggle)
    ToggleStroke.Color = IVORY
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.35

    -- Macro Button
    local MacroButton = Instance.new("TextButton")
    MacroButton.Size = UDim2.fromOffset(50, 50)
    MacroButton.Position = UDim2.new(1, -70, 0.5, -25)
    MacroButton.BackgroundColor3 = BLACK
    MacroButton.Text = "M"
    MacroButton.TextColor3 = GOLD
    MacroButton.TextSize = 20
    MacroButton.Font = Enum.Font.GothamBold
    MacroButton.AutoButtonColor = false
    MacroButton.Visible = false
    MacroButton.Parent = Gui
    Instance.new("UICorner", MacroButton).CornerRadius = UDim.new(0, 14)
    local MacroStroke = Instance.new("UIStroke", MacroButton)
    MacroStroke.Color = GOLD
    MacroStroke.Thickness = 2
    MacroStroke.Transparency = 0.3

    -- Soru Button
    local SoruButton = Instance.new("TextButton")
    SoruButton.Size = UDim2.fromOffset(45, 45)
    SoruButton.Position = UDim2.new(1, -70, 0.5, 40)
    SoruButton.BackgroundColor3 = BLACK
    SoruButton.Text = "S"
    SoruButton.TextColor3 = IVORY
    SoruButton.TextSize = 18
    SoruButton.Font = Enum.Font.GothamBold
    SoruButton.AutoButtonColor = false
    SoruButton.Visible = false
    SoruButton.Parent = Gui
    Instance.new("UICorner", SoruButton).CornerRadius = UDim.new(0, 12)
    local SoruStroke = Instance.new("UIStroke", SoruButton)
    SoruStroke.Color = IVORY
    SoruStroke.Thickness = 2
    SoruStroke.Transparency = 0.3

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.fromOffset(470, 320)
    Main.Position = UDim2.new(0.5, -235, 0.5, -160)
    Main.BackgroundColor3 = BLACK
    Main.BorderSizePixel = 0
    Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = IVORY
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.75

    -- Top Bar
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 58)
    Top.BackgroundColor3 = DARK
    Top.BorderSizePixel = 0
    Top.Parent = Main
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(18, 9)
    Title.Size = UDim2.fromOffset(200, 25)
    Title.Text = "IVORY PVP"
    Title.TextColor3 = IVORY
    Title.TextSize = 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Top

    local SubTitle = Instance.new("TextLabel")
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.fromOffset(19, 32)
    SubTitle.Size = UDim2.fromOffset(200, 17)
    SubTitle.Text = "BLOX FRUITS MOBILE PVP"
    SubTitle.TextColor3 = GREY
    SubTitle.TextSize = 8
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Top

    local Status = Instance.new("TextLabel")
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(1, -130, 0, 20)
    Status.Size = UDim2.fromOffset(80, 20)
    Status.Text = "●  ONLINE"
    Status.TextColor3 = GREEN
    Status.TextSize = 9
    Status.Font = Enum.Font.GothamBold
    Status.TextXAlignment = Enum.TextXAlignment.Right
    Status.Parent = Top

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(28, 28)
    Close.Position = UDim2.new(1, -38, 0, 15)
    Close.BackgroundColor3 = DARKGREY
    Close.Text = "×"
    Close.TextColor3 = IVORY
    Close.TextSize = 18
    Close.Font = Enum.Font.GothamMedium
    Close.AutoButtonColor = false
    Close.Parent = Top
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Position = UDim2.fromOffset(10, 68)
    Sidebar.Size = UDim2.fromOffset(112, 240)
    Sidebar.BackgroundColor3 = DARK
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 11)
    local SidePadding = Instance.new("UIPadding", Sidebar)
    SidePadding.PaddingTop = UDim.new(0, 8)
    SidePadding.PaddingLeft = UDim.new(0, 7)
    SidePadding.PaddingRight = UDim.new(0, 7)
    local SideList = Instance.new("UIListLayout", Sidebar)
    SideList.Padding = UDim.new(0, 4)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content
    local Content = Instance.new("Frame")
    Content.Position = UDim2.fromOffset(132, 68)
    Content.Size = UDim2.new(1, -142, 1, -78)
    Content.BackgroundColor3 = DARK
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = Main
    Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 11)

    -- Pages
    local Pages = {}
    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name
        Page.Size = UDim2.new(1, -12, 1, -12)
        Page.Position = UDim2.fromOffset(6, 6)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = GREY
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = Content
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 6)
        Instance.new("UIPadding", Page).PaddingBottom = UDim.new(0, 6)
        Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 6)
        Instance.new("UIPadding", Page).PaddingRight = UDim.new(0, 6)
        local List = Instance.new("UIListLayout", Page)
        List.Padding = UDim.new(0, 7)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        Pages[name] = Page
        return Page
    end

    -- UI Components
    local function AddCard(Page, title, description, icon)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -2, 0, 60)
        Card.BackgroundColor3 = PANEL
        Card.BorderSizePixel = 0
        Card.Parent = Page
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 9)
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = IVORY
        Stroke.Transparency = 0.92
        local Icon = Instance.new("TextLabel")
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.fromOffset(10, 15)
        Icon.Size = UDim2.fromOffset(30, 30)
        Icon.Text = icon or "◆"
        Icon.TextColor3 = IVORY
        Icon.TextSize = 16
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Card
        local T = Instance.new("TextLabel")
        T.BackgroundTransparency = 1
        T.Position = UDim2.fromOffset(48, 8)
        T.Size = UDim2.new(1, -60, 0, 20)
        T.Text = title
        T.TextColor3 = WHITE
        T.TextSize = 12
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Parent = Card
        local D = Instance.new("TextLabel")
        D.BackgroundTransparency = 1
        D.Position = UDim2.fromOffset(48, 29)
        D.Size = UDim2.new(1, -60, 0, 20)
        D.Text = description
        D.TextColor3 = GREY
        D.TextSize = 9
        D.Font = Enum.Font.Gotham
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.Parent = Card
        return Card
    end

    local function AddToggle(Page, title, description, callback, icon)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -2, 0, 60)
        Card.BackgroundColor3 = PANEL
        Card.BorderSizePixel = 0
        Card.Parent = Page
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 9)
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = IVORY
        Stroke.Transparency = 0.92
        local Icon = Instance.new("TextLabel")
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.fromOffset(10, 15)
        Icon.Size = UDim2.fromOffset(30, 30)
        Icon.Text = icon or "◈"
        Icon.TextColor3 = IVORY
        Icon.TextSize = 14
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Card
        local T = Instance.new("TextLabel")
        T.BackgroundTransparency = 1
        T.Position = UDim2.fromOffset(48, 8)
        T.Size = UDim2.new(1, -100, 0, 20)
        T.Text = title
        T.TextColor3 = WHITE
        T.TextSize = 11
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Parent = Card
        local D = Instance.new("TextLabel")
        D.BackgroundTransparency = 1
        D.Position = UDim2.fromOffset(48, 29)
        D.Size = UDim2.new(1, -100, 0, 20)
        D.Text = description
        D.TextColor3 = GREY
        D.TextSize = 8
        D.Font = Enum.Font.Gotham
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.Parent = Card
        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.fromOffset(40, 20)
        Switch.Position = UDim2.new(1, -52, 0.5, -10)
        Switch.BackgroundColor3 = DARKGREY
        Switch.Text = "OFF"
        Switch.TextColor3 = WHITE
        Switch.TextSize = 8
        Switch.Font = Enum.Font.GothamBold
        Switch.AutoButtonColor = false
        Switch.Parent = Card
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 6)
        local Enabled = false
        Switch.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            if Enabled then
                Switch.BackgroundColor3 = GREEN
                Switch.Text = "ON"
                Switch.TextColor3 = BLACK
            else
                Switch.BackgroundColor3 = DARKGREY
                Switch.Text = "OFF"
                Switch.TextColor3 = WHITE
            end
            callback(Enabled)
        end)
        return Card, Switch
    end

    local function AddSlider(Page, title, min, max, default, callback, icon)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -2, 0, 70)
        Card.BackgroundColor3 = PANEL
        Card.BorderSizePixel = 0
        Card.Parent = Page
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 9)
        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = IVORY
        Stroke.Transparency = 0.92
        local Icon = Instance.new("TextLabel")
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.fromOffset(10, 20)
        Icon.Size = UDim2.fromOffset(30, 30)
        Icon.Text = icon or "▣"
        Icon.TextColor3 = IVORY
        Icon.TextSize = 14
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Card
        local T = Instance.new("TextLabel")
        T.BackgroundTransparency = 1
        T.Position = UDim2.fromOffset(48, 8)
        T.Size = UDim2.new(1, -60, 0, 20)
        T.Text = title
        T.TextColor3 = WHITE
        T.TextSize = 11
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Parent = Card
        local Value = Instance.new("TextLabel")
        Value.BackgroundTransparency = 1
        Value.Position = UDim2.new(1, -60, 0, 8)
        Value.Size = UDim2.fromOffset(48, 20)
        Value.Text = string.format("%.2f", default)
        Value.TextColor3 = IVORY
        Value.TextSize = 10
        Value.Font = Enum.Font.GothamBold
        Value.TextXAlignment = Enum.TextXAlignment.Right
        Value.Parent = Card
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Position = UDim2.fromOffset(48, 44)
        SliderFrame.Size = UDim2.new(1, -60, 0, 10)
        SliderFrame.BackgroundColor3 = DARKGREY
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = Card
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 5)
        local SliderFill = Instance.new("Frame")
        local FillPercent = (default - min) / (max - min)
        SliderFill.Size = UDim2.new(FillPercent, 0, 1, 0)
        SliderFill.BackgroundColor3 = IVORY
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderFrame
        Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 5)
        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.fromOffset(16, 16)
        SliderButton.Position = UDim2.new(FillPercent, -8, 0.5, -8)
        SliderButton.BackgroundColor3 = WHITE
        SliderButton.Text = ""
        SliderButton.AutoButtonColor = false
        SliderButton.Parent = SliderFrame
        Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)
        local function UpdateSlider(input)
            local pos = input.Position.X
            local framePos = SliderFrame.AbsolutePosition.X
            local frameSize = SliderFrame.AbsoluteSize.X
            local percent = math.clamp((pos - framePos) / frameSize, 0, 1)
            local val = min + (max - min) * percent
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
            Value.Text = string.format("%.2f", val)
            callback(val)
        end
        SliderButton.MouseButton1Down:Connect(function()
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    UpdateSlider({Position = Vector2.new(UserInputService:GetMouseLocation().X, 0)})
                else
                    connection:Disconnect()
                end
            end)
        end)
        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                UpdateSlider(input)
            end
        end)
        return Card
    end

    -- Create Pages
    local Home = CreatePage("Home")
    local AimbotPage = CreatePage("Aimbot")
    local CombatPage = CreatePage("Combat")
    local MovementPage = CreatePage("Movement")
    local VisualPage = CreatePage("Visuals")
    local MacrosPage = CreatePage("Macros")
    local CreditsPage = CreatePage("Credits")
    local SettingsPage = CreatePage("Settings")

    -- Home
    AddCard(Home, "Welcome to Ivory PVP", "Mobile optimized Blox Fruits PVP", "◆")
    AddCard(Home, "Current Status", "All systems operational", "●")
    AddCard(Home, "Script Version", "v16.0 - Fixed Soru", "◈")
    AddCard(Home, "Quick Stats", "180° Aimbot | Soru | Macro", "▣")
    AddCard(Home, "Mobile Only", "No PC inputs, no freezes", "◎")
    AddCard(Home, "Anti-Detection", "Silent aim leaves no trace", "◇")
    AddCard(Home, "Performance", "Optimized for mobile devices", "◉")
    AddCard(Home, "Updates", "Join Discord for latest updates", "✦")

    -- Aimbot Page
    AddToggle(AimbotPage, "180° Aimbot", "Only targets enemies in front of you", function(enabled)
        Aimbot.Enabled = enabled
        if enabled then
            Status.Text = "●  AIMBOT"
            Status.TextColor3 = RED
        else
            Status.Text = "●  ONLINE"
            Status.TextColor3 = GREEN
            Aimbot.CurrentTarget = nil
        end
    end, "◎")
    AddToggle(AimbotPage, "Target Players", "Aim at players", function(enabled)
        Aimbot.TargetPlayers = enabled
    end, "👤")
    AddToggle(AimbotPage, "Target NPCs", "Aim at NPCs", function(enabled)
        Aimbot.TargetNPCs = enabled
    end, "🤖")
    AddSlider(AimbotPage, "Max Distance", 500, 5000, 3000, function(val)
        Aimbot.MaxDistance = val
    end, "📐")
    AddSlider(AimbotPage, "Prediction", 0, 1, 0.15, function(val)
        Aimbot.Prediction = val
    end, "▣")

    -- Combat Page
    AddToggle(CombatPage, "Soru Button", "Show Soru button on screen", function(enabled)
        Combat.SoruButtonVisible = enabled
        SoruButton.Visible = enabled
    end, "⚡")
    AddSlider(CombatPage, "Soru Distance", 10, 30, 20, function(val)
        Combat.SoruDistance = val
    end, "⚡")
    AddToggle(CombatPage, "Anti Stun", "Prevents stun effects", function(enabled)
        Combat.AntiStun = enabled
    end, "🛡")
    AddToggle(CombatPage, "No Clip", "Walk through walls", function(enabled)
        Combat.NoClip = enabled
    end, "◌")

    -- Movement Page
    AddToggle(MovementPage, "Speed Hack", "Multiply your movement speed", function(enabled)
        Combat.SpeedHack = enabled
        if not enabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end, "»")
    AddSlider(MovementPage, "Speed Multiplier", 1, 50, 15, function(val)
        Combat.SpeedMultiplier = val
        if Combat.SpeedHack and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16 * val
        end
    end, "»")

    -- Visual Page
    AddToggle(VisualPage, "ESP Boxes", "Show player boxes through walls", function(enabled)
        Combat.ESPEnabled = enabled
        if not enabled then
            for _, box in pairs(Combat.ESPBoxes) do if box then box:Destroy() end end
            for _, name in pairs(Combat.ESPNames) do if name then name:Destroy() end end
            for _, dist in pairs(Combat.ESPDistance) do if dist then dist:Destroy() end end
            Combat.ESPBoxes = {}
            Combat.ESPNames = {}
            Combat.ESPDistance = {}
        end
    end, "▣")
    AddToggle(VisualPage, "ESP Names", "Show player names", function(enabled)
        Combat.ESPNamesEnabled = enabled
    end, "◈")
    AddToggle(VisualPage, "ESP Distance", "Show distance to players", function(enabled)
        Combat.ESPDistanceEnabled = enabled
    end, "◎")

    -- Macros Page
    AddToggle(MacrosPage, "Macro System", "Enable macro button on screen", function(enabled)
        Combat.MacroEnabled = enabled
        MacroButton.Visible = enabled
        if enabled then
            Status.Text = "●  MACRO"
            Status.TextColor3 = GOLD
        else
            Status.Text = "●  ONLINE"
            Status.TextColor3 = GREEN
        end
    end, "⌨")

    local StepsContainer = Instance.new("Frame")
    StepsContainer.Size = UDim2.new(1, -2, 0, 10)
    StepsContainer.BackgroundTransparency = 1
    StepsContainer.Parent = MacrosPage
    local StepsList = Instance.new("UIListLayout", StepsContainer)
    StepsList.Padding = UDim.new(0, 5)
    StepsList.SortOrder = Enum.SortOrder.LayoutOrder

    local function RefreshStepsUI()
        for _, child in pairs(StepsContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
        end
        for i, step in ipairs(Combat.MacroSteps) do
            local StepFrame = Instance.new("Frame")
            StepFrame.Size = UDim2.new(1, 0, 0, 60)
            StepFrame.BackgroundColor3 = PANEL
            StepFrame.BorderSizePixel = 0
            StepFrame.LayoutOrder = i
            StepFrame.Parent = StepsContainer
            Instance.new("UICorner", StepFrame).CornerRadius = UDim.new(0, 8)
            
            local TypeBtn = Instance.new("TextButton")
            TypeBtn.Size = UDim2.new(0.3, -5, 1, -10)
            TypeBtn.Position = UDim2.fromOffset(5, 5)
            TypeBtn.BackgroundColor3 = DARKGREY
            TypeBtn.Text = step.Type
            TypeBtn.TextColor3 = WHITE
            TypeBtn.Font = Enum.Font.GothamBold
            TypeBtn.TextSize = 10
            TypeBtn.AutoButtonColor = false
            TypeBtn.Parent = StepFrame
            Instance.new("UICorner", TypeBtn).CornerRadius = UDim.new(0, 6)
            
            local TypeIndex = table.find({"Melee", "Sword", "Fruit", "Gun"}, step.Type) or 1
            TypeBtn.MouseButton1Click:Connect(function()
                TypeIndex = TypeIndex % 4 + 1
                local newType = ({"Melee", "Sword", "Fruit", "Gun"})[TypeIndex]
                step.Type = newType
                if not table.find(MoveLists[newType], step.Move) then
                    step.Move = MoveLists[newType][1]
                end
                RefreshStepsUI()
            end)
            
            local MoveBtn = Instance.new("TextButton")
            MoveBtn.Size = UDim2.new(0.15, -5, 1, -10)
            MoveBtn.Position = UDim2.new(0.3, 10, 0, 5)
            MoveBtn.BackgroundColor3 = DARKGREY
            MoveBtn.Text = step.Move
            MoveBtn.TextColor3 = WHITE
            MoveBtn.Font = Enum.Font.GothamBold
            MoveBtn.TextSize = 12
            MoveBtn.AutoButtonColor = false
            MoveBtn.Parent = StepFrame
            Instance.new("UICorner", MoveBtn).CornerRadius = UDim.new(0, 6)
            
            local moves = MoveLists[step.Type]
            local moveIndex = table.find(moves, step.Move) or 1
            MoveBtn.MouseButton1Click:Connect(function()
                moveIndex = moveIndex % #moves + 1
                step.Move = moves[moveIndex]
                MoveBtn.Text = step.Move
            end)
            
            local DelayBtn = Instance.new("TextButton")
            DelayBtn.Size = UDim2.new(0.3, -5, 1, -10)
            DelayBtn.Position = UDim2.new(0.45, 10, 0, 5)
            DelayBtn.BackgroundColor3 = DARKGREY
            DelayBtn.Text = string.format("%.2f", step.Delay)
            DelayBtn.TextColor3 = WHITE
            DelayBtn.Font = Enum.Font.GothamBold
            DelayBtn.TextSize = 10
            DelayBtn.AutoButtonColor = false
            DelayBtn.Parent = StepFrame
            Instance.new("UICorner", DelayBtn).CornerRadius = UDim.new(0, 6)
            
            local delayValues = {}
            for d = 0, 5, 0.1 do table.insert(delayValues, math.floor(d*100+0.5)/100) end
            local delayIndex = math.max(1, math.min(#delayValues, math.floor(step.Delay*10+0.5)+1))
            DelayBtn.MouseButton1Click:Connect(function()
                delayIndex = delayIndex % #delayValues + 1
                step.Delay = delayValues[delayIndex]
                DelayBtn.Text = string.format("%.2f", step.Delay)
            end)
            
            local RemoveBtn = Instance.new("TextButton")
            RemoveBtn.Size = UDim2.new(0.15, -5, 1, -10)
            RemoveBtn.Position = UDim2.new(0.75, 10, 0, 5)
            RemoveBtn.BackgroundColor3 = RED
            RemoveBtn.Text = "X"
            RemoveBtn.TextColor3 = WHITE
            RemoveBtn.Font = Enum.Font.GothamBold
            RemoveBtn.TextSize = 14
            RemoveBtn.AutoButtonColor = false
            RemoveBtn.Parent = StepFrame
            Instance.new("UICorner", RemoveBtn).CornerRadius = UDim.new(0, 6)
            RemoveBtn.MouseButton1Click:Connect(function()
                table.remove(Combat.MacroSteps, i)
                RefreshStepsUI()
            end)
        end
        StepsContainer.Size = UDim2.new(1, -2, 0, #Combat.MacroSteps * 65 + 10)
    end

    local AddStepBtn = Instance.new("TextButton")
    AddStepBtn.Size = UDim2.new(1, -2, 0, 40)
    AddStepBtn.BackgroundColor3 = GOLD
    AddStepBtn.Text = "+ Add Step"
    AddStepBtn.TextColor3 = BLACK
    AddStepBtn.Font = Enum.Font.GothamBold
    AddStepBtn.TextSize = 14
    AddStepBtn.AutoButtonColor = false
    AddStepBtn.Parent = MacrosPage
    Instance.new("UICorner", AddStepBtn).CornerRadius = UDim.new(0, 8)
    AddStepBtn.MouseButton1Click:Connect(function()
        table.insert(Combat.MacroSteps, {Type = "Melee", Move = "Z", Delay = 0.5})
        RefreshStepsUI()
    end)
    RefreshStepsUI()

    -- Credits
    AddCard(CreditsPage, "Made By", "Ivory", "◆")
    AddCard(CreditsPage, "Discord", "Ivory999", "◈")
    AddCard(CreditsPage, "Ideas By", "Rayo", "✦")
    AddCard(CreditsPage, "Discord", "rayo06996", "◎")
    AddCard(CreditsPage, "Version", "v16.0 - Fixed Soru", "▣")
    AddCard(CreditsPage, "Special Thanks", "All supporters and testers", "♡")
    AddCard(CreditsPage, "Updates", "Join Discord for latest updates", "↻")

    -- Settings
    AddToggle(SettingsPage, "Hide UI", "Toggle UI visibility", function(enabled)
        Main.Visible = not enabled
    end, "◇")
    AddCard(SettingsPage, "Save Config", "Settings auto-save on change", "♢")
    AddCard(SettingsPage, "Reset Settings", "Click to reset all settings", "↺")

    -- Tabs
    local Tabs = {}
    local function CreateTab(name, order, icon)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 24)
        Button.BackgroundColor3 = DARK
        Button.Text = icon .. " " .. name:upper()
        Button.TextColor3 = GREY
        Button.TextSize = 8
        Button.Font = Enum.Font.GothamBold
        Button.AutoButtonColor = false
        Button.LayoutOrder = order
        Button.Parent = Sidebar
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 7)
        local Accent = Instance.new("Frame")
        Accent.Size = UDim2.fromOffset(2, 15)
        Accent.Position = UDim2.new(0, 4, 0.5, -7)
        Accent.BackgroundColor3 = IVORY
        Accent.BorderSizePixel = 0
        Accent.Visible = false
        Accent.Parent = Button
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(1, 0)
        Tabs[name] = {Button = Button, Accent = Accent}
        Button.MouseEnter:Connect(function()
            if Button.BackgroundColor3 ~= IVORY then
                tween(Button, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = IVORY})
            end
        end)
        Button.MouseLeave:Connect(function()
            if Button.BackgroundColor3 ~= IVORY then
                tween(Button, 0.15, {BackgroundColor3 = DARK, TextColor3 = GREY})
            end
        end)
        Button.MouseButton1Click:Connect(function()
            for _, data in pairs(Tabs) do
                tween(data.Button, 0.15, {BackgroundColor3 = DARK, TextColor3 = GREY})
                data.Accent.Visible = false
            end
            tween(Button, 0.2, {BackgroundColor3 = IVORY, TextColor3 = BLACK})
            Accent.Visible = true
            for pageName, page in pairs(Pages) do
                page.Visible = (pageName == name)
            end
        end)
        return Button
    end

    CreateTab("Home", 1, "◆")
    CreateTab("Aimbot", 2, "◎")
    CreateTab("Combat", 3, "⚔")
    CreateTab("Movement", 4, "»")
    CreateTab("Visuals", 5, "▣")
    CreateTab("Macros", 6, "⌨")
    CreateTab("Credits", 7, "♛")
    CreateTab("Settings", 8, "⚙")

    Tabs.Home.Button.BackgroundColor3 = IVORY
    Tabs.Home.Button.TextColor3 = BLACK
    Tabs.Home.Accent.Visible = true
    Home.Visible = true

    -- Dragging
    local function MakeDraggable(Object, DragObject)
        local dragging = false
        local dragStart, startPos
        DragObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                Object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(Main, Top)
    MakeDraggable(Toggle, Toggle)
    MakeDraggable(MacroButton, MacroButton)
    MakeDraggable(SoruButton, SoruButton)

    -- Open/Close
    local Open = true
    local function ShowUI()
        Open = true
        Main.Visible = true
        tween(Main, 0.3, {Size = UDim2.fromOffset(470, 320)})
    end
    local function HideUI()
        Open = false
        tween(Main, 0.25, {Size = UDim2.fromOffset(440, 290)})
        task.delay(0.25, function() if not Open then Main.Visible = false end end)
    end
    Toggle.MouseButton1Click:Connect(function() if Open then HideUI() else ShowUI() end end)
    Close.MouseButton1Click:Connect(HideUI)

    -- Macro Handler
    MacroButton.MouseButton1Click:Connect(function()
        if not Combat.MacroEnabled or #Combat.MacroSteps == 0 then return end
        if tick() - Combat.LastMacroAction < 0.5 then return end
        Combat.LastMacroAction = tick()
        for _, step in ipairs(Combat.MacroSteps) do
            task.wait(step.Delay)
        end
    end)

    -- FIXED SORU HANDLER (normal flashstep distance + animation)
    SoruButton.MouseButton1Click:Connect(function()
        if not Combat.SoruButtonVisible then return end
        if tick() - Combat.LastSoru < Combat.SoruCooldown then return end
        Combat.LastSoru = tick()

        local character = Player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local root = character.HumanoidRootPart

        local targetRoot = nil
        local shortestDist = math.huge

        if Aimbot.TargetPlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local otherRoot = p.Character.HumanoidRootPart
                    local dist = (root.Position - otherRoot.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetRoot = otherRoot
                    end
                end
            end
        end

        if Aimbot.TargetNPCs then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, npc in pairs(enemies:GetChildren()) do
                    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                        local otherRoot = npc.HumanoidRootPart
                        local dist = (root.Position - otherRoot.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            targetRoot = otherRoot
                        end
                    end
                end
            end
        end

        if not targetRoot then return end

        -- Normal flashstep: only move SHORT distance toward target
        local direction = (targetRoot.Position - root.Position).Unit
        local flashstepPos = root.Position + direction * Combat.SoruDistance

        -- Animation: afterimages
        for i = 1, 5 do
            local afterimage = Instance.new("Part")
            afterimage.Size = root.Size
            afterimage.CFrame = root.CFrame
            afterimage.Anchored = true
            afterimage.CanCollide = false
            afterimage.Transparency = 0.3 + (i * 0.15)
            afterimage.Color = IVORY
            afterimage.Material = Enum.Material.ForceField
            afterimage.Parent = workspace
            game:GetService("Debris"):AddItem(afterimage, 0.15)
            task.wait(0.02)
        end

        -- Flash effect
        local flash = Instance.new("Part")
        flash.Size = Vector3.new(2, 2, 2)
        flash.Position = flashstepPos
        flash.Anchored = true
        flash.CanCollide = false
        flash.Transparency = 0.5
        flash.Color = IVORY
        flash.Material = Enum.Material.Neon
        flash.Parent = workspace
        game:GetService("Debris"):AddItem(flash, 0.3)

        -- Move player
        root.CFrame = CFrame.new(flashstepPos)
    end)

    -- Aimbot Functions
    local function isIn180FOV(position)
        if not position or not Camera then return false end
        local char = Player.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local lookVector = Camera.CFrame.LookVector
        local dirToTarget = (position - root.Position).Unit
        local dot = lookVector:Dot(dirToTarget)
        return dot >= 0
    end

    local function getScreenCenterDistance(position)
        if not position or not Camera then return math.huge end
        local screenPos, onScreen = Camera:WorldToViewportPoint(position)
        if not onScreen then return math.huge end
        local center = Camera.ViewportSize / 2
        return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
    end

    local function getClosestEnemy()
        local char = Player.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local myPos = root.Position
        local best = nil
        local bestScore = math.huge
        if Aimbot.TargetPlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local part = p.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and part then
                        if Player.Team and p.Team and Player.Team == p.Team then continue end
                        local pos = part.Position
                        local dist = (pos - myPos).Magnitude
                        if dist <= Aimbot.MaxDistance and isIn180FOV(pos) then
                            local centerDist = getScreenCenterDistance(pos)
                            local score = centerDist + dist * 0.001
                            if score < bestScore then bestScore = score; best = part end
                        end
                    end
                end
            end
        end
        if Aimbot.TargetNPCs then
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, npc in pairs(enemies:GetChildren()) do
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        local part = npc:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and part then
                            local pos = part.Position
                            local dist = (pos - myPos).Magnitude
                            if dist <= Aimbot.MaxDistance and isIn180FOV(pos) then
                                local centerDist = getScreenCenterDistance(pos)
                                local score = centerDist + dist * 0.001
                                if score < bestScore then bestScore = score; best = part end
                            end
                        end
                    end
                end
            end
        end
        return best
    end

    RunService.Heartbeat:Connect(function()
        if Aimbot.Enabled and KeyValid then
            Aimbot.CurrentTarget = getClosestEnemy()
        else
            Aimbot.CurrentTarget = nil
        end
    end)

    -- Silent Aim Hook
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if Aimbot.Enabled and KeyValid and not checkcaller() then
            if method == "FireServer" or method == "InvokeServer" then
                local remoteName = self.Name or ""
                local attackKeywords = {"Attack", "Melee", "Sword", "Fruit", "Gun", "Click", "Fire", "Damage", "Combat", "Ability", "Hit", "Shoot"}
                local isAttack = false
                for _, kw in ipairs(attackKeywords) do
                    if string.find(remoteName:lower(), kw:lower()) then isAttack = true; break end
                end
                if isAttack and Aimbot.CurrentTarget then
                    local targetRoot = Aimbot.CurrentTarget
                    local character = Player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local root = character.HumanoidRootPart
                        local predictedPos = targetRoot.Position
                        if targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid") then
                            local hum = targetRoot.Parent:FindFirstChildOfClass("Humanoid")
                            local velocity = hum.MoveDirection * hum.WalkSpeed
                            predictedPos = targetRoot.Position + velocity * Aimbot.Prediction
                        end
                        local originalCFrame = root.CFrame
                        root.CFrame = CFrame.lookAt(root.Position, predictedPos)
                        local result = OldNamecall(self, unpack(args))
                        root.CFrame = originalCFrame
                        return result
                    end
                end
            end
        end
        return OldNamecall(self, ...)
    end)

    -- Main Loop
    RunService.RenderStepped:Connect(function()
        if not KeyValid then return end
        if Combat.SpeedHack and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16 * Combat.SpeedMultiplier
        end
        if Combat.NoClip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        if Combat.AntiStun and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local humanoid = Player.Character.Humanoid
            if humanoid:GetState() == Enum.HumanoidStateType.Stunned then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
        if Combat.ESPEnabled then
            for _, box in pairs(Combat.ESPBoxes) do if box then box:Destroy() end end
            for _, name in pairs(Combat.ESPNames) do if name then name:Destroy() end end
            for _, dist in pairs(Combat.ESPDistance) do if dist then dist:Destroy() end end
            Combat.ESPBoxes = {}
            Combat.ESPNames = {}
            Combat.ESPDistance = {}
            local targets = {}
            if Aimbot.TargetPlayers then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        table.insert(targets, p.Character)
                    end
                end
            end
            if Aimbot.TargetNPCs then
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, model in pairs(enemies:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                            table.insert(targets, model)
                        end
                    end
                end
            end
            for _, target in pairs(targets) do
                local root = target:FindFirstChild("HumanoidRootPart")
                if root then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        if Combat.ESPEnabled then
                            local box = Drawing.new("Square")
                            box.Visible = true
                            box.Size = Vector2.new(50, 100)
                            box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 100)
                            box.Color = Color3.fromRGB(255, 0, 0)
                            box.Thickness = 2
                            box.Filled = false
                            table.insert(Combat.ESPBoxes, box)
                        end
                        if Combat.ESPNamesEnabled then
                            local name = Drawing.new("Text")
                            name.Visible = true
                            name.Text = target.Name
                            name.Position = Vector2.new(screenPos.X, screenPos.Y - 110)
                            name.Color = Color3.fromRGB(255, 255, 255)
                            name.Size = 14
                            name.Center = true
                            table.insert(Combat.ESPNames, name)
                        end
                        if Combat.ESPDistanceEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = Drawing.new("Text")
                            dist.Visible = true
                            local distance = (Player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                            dist.Text = string.format("%.0f studs", distance)
                            dist.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
                            dist.Color = Color3.fromRGB(255, 255, 0)
                            dist.Size = 12
                            dist.Center = true
                            table.insert(Combat.ESPDistance, dist)
                        end
                    end
                end
            end
        end
    end)
end

--// KEY BUTTON CLICK
KeyButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == VALID_KEY then
        KeyButton.Text = "✓ UNLOCKED"
        tween(KeyButton, 0.3, {BackgroundColor3 = Color3.fromRGB(0, 255, 100)})
        task.wait(0.5)
        LoadFullScript()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "WRONG KEY"
        KeyBox.PlaceholderColor3 = RED
        tween(KeyFrame, 0.1, {Position = UDim2.new(0.5, -170, 0.5, -105)})
        task.wait(0.1)
        tween(KeyFrame, 0.1, {Position = UDim2.new(0.5, -170, 0.5, -100)})
        task.wait(1)
        KeyBox.PlaceholderText = "ENTER KEY"
        KeyBox.PlaceholderColor3 = GREY
    end
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        KeyButton.MouseButton1Click:Fire()
    end
end)
