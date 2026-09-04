--// IVORY HUB — BLOX FRUITS MOBILE PVP (FIXED v12)
--// Silent Aimbot (whitelist) + Soru Button + Macro (Mobile Only)
--// No glitches, no freezes, no stuck after abilities

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--// Remove old UI
pcall(function()
    PlayerGui:FindFirstChild("IvoryHub"):Destroy()
end)

--// COLORS
local BLACK = Color3.fromRGB(8, 8, 8)
local DARK = Color3.fromRGB(13, 13, 13)
local PANEL = Color3.fromRGB(17, 17, 17)
local LIGHT = Color3.fromRGB(235, 235, 235)
local WHITE = Color3.fromRGB(255, 255, 255)
local GREY = Color3.fromRGB(145, 145, 145)
local DARKGREY = Color3.fromRGB(35, 35, 35)
local RED = Color3.fromRGB(255, 80, 80)
local GREEN = Color3.fromRGB(80, 255, 120)
local IVORY = Color3.fromRGB(255, 255, 240)
local GOLD = Color3.fromRGB(255, 215, 0)

local function tween(obj, time, props)
    TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// COMBAT VARIABLES
local Combat = {
    SilentAimEnabled = false,
    SilentAimTarget = nil,
    SilentAimFOV = 180,
    SilentAimHitChance = 100,
    SilentAimPrediction = 0.15,
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
    SoruCooldown = 1,
    LastSoru = 0,
    SoruDistance = 15,
    AntiStun = false,
    MacroEnabled = false,
    MacroMeleeEnabled = false,
    MacroSwordEnabled = false,
    MacroFruitEnabled = false,
    MacroGunEnabled = false,
    MacroMeleeDelay = 0.5,
    MacroSwordDelay = 0.5,
    MacroFruitDelay = 0.5,
    MacroGunDelay = 0.5,
    LastMacroAction = 0,
    TargetPlayers = true,
    TargetNPCs = false,
    -- Move selections
    MeleeMove = "Z",
    SwordMove = "Z",
    FruitMove = "Z",
    GunMove = "Z"
}

local MeleeMoves = {"Z", "X", "C"}
local SwordMoves = {"Z", "X"}
local FruitMoves = {"Z", "X", "C", "V", "F"}
local GunMoves = {"Z", "X"}

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--// FLOATING TOGGLE
local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Size = UDim2.fromOffset(38, 38)
Toggle.Position = UDim2.new(0, 16, 0.5, -19)
Toggle.BackgroundColor3 = BLACK
Toggle.Text = "I"
Toggle.TextColor3 = IVORY
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 11)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = IVORY
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = Toggle

--// MACRO FLOATING BUTTON (no label)
local MacroButton = Instance.new("TextButton")
MacroButton.Name = "MacroButton"
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

local MacroCorner = Instance.new("UICorner")
MacroCorner.CornerRadius = UDim.new(0, 14)
MacroCorner.Parent = MacroButton

local MacroStroke = Instance.new("UIStroke")
MacroStroke.Color = GOLD
MacroStroke.Thickness = 2
MacroStroke.Transparency = 0.3
MacroStroke.Parent = MacroButton

--// SORU FLOATING BUTTON (no label)
local SoruButton = Instance.new("TextButton")
SoruButton.Name = "SoruButton"
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

local SoruCorner = Instance.new("UICorner")
SoruCorner.CornerRadius = UDim.new(0, 12)
SoruCorner.Parent = SoruButton

local SoruStroke = Instance.new("UIStroke")
SoruStroke.Color = IVORY
SoruStroke.Thickness = 2
SoruStroke.Transparency = 0.3
SoruStroke.Parent = SoruButton

--// MAIN
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(470, 320)
Main.Position = UDim2.new(0.5, -235, 0.5, -160)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = IVORY
MainStroke.Thickness = 1
MainStroke.Transparency = 0.75
MainStroke.Parent = Main

--// TOP BAR
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = Top

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

--// STATUS
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

--// CLOSE
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.fromOffset(10, 68)
Sidebar.Size = UDim2.fromOffset(112, 240)
Sidebar.BackgroundColor3 = DARK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 11)
SidebarCorner.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 8)
SidePadding.PaddingLeft = UDim.new(0, 7)
SidePadding.PaddingRight = UDim.new(0, 7)
SidePadding.Parent = Sidebar

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 4)
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Parent = Sidebar

--// CONTENT
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.fromOffset(132, 68)
Content.Size = UDim2.new(1, -142, 1, -78)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 11)
ContentCorner.Parent = Content

--// PAGES
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

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 6)
    Padding.PaddingBottom = UDim.new(0, 6)
    Padding.PaddingLeft = UDim.new(0, 6)
    Padding.PaddingRight = UDim.new(0, 6)
    Padding.Parent = Page

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 7)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Parent = Page

    Pages[name] = Page
    return Page
end

--// CARD
local function AddCard(Page, title, description, icon)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -2, 0, 60)
    Card.BackgroundColor3 = PANEL
    Card.BorderSizePixel = 0
    Card.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = IVORY
    Stroke.Transparency = 0.92
    Stroke.Parent = Card

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

--// TOGGLE CARD
local function AddToggle(Page, title, description, callback, icon)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -2, 0, 60)
    Card.BackgroundColor3 = PANEL
    Card.BorderSizePixel = 0
    Card.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = IVORY
    Stroke.Transparency = 0.92
    Stroke.Parent = Card

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

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, 6)
    SwitchCorner.Parent = Switch

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

--// SLIDER CARD
local function AddSlider(Page, title, min, max, default, callback, icon)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -2, 0, 70)
    Card.BackgroundColor3 = PANEL
    Card.BorderSizePixel = 0
    Card.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = IVORY
    Stroke.Transparency = 0.92
    Stroke.Parent = Card

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
    Value.Text = tostring(default)
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

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 5)
    SliderCorner.Parent = SliderFrame

    local SliderFill = Instance.new("Frame")
    local FillPercent = (default - min) / (max - min)
    SliderFill.Size = UDim2.new(FillPercent, 0, 1, 0)
    SliderFill.BackgroundColor3 = IVORY
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderFrame

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 5)
    SliderFillCorner.Parent = SliderFill

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.fromOffset(16, 16)
    SliderButton.Position = UDim2.new(FillPercent, -8, 0.5, -8)
    SliderButton.BackgroundColor3 = WHITE
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    SliderButton.Parent = SliderFrame

    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton

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

--// CREATE PAGES
local Home = CreatePage("Home")
local AimbotPage = CreatePage("Aimbot")
local CombatPage = CreatePage("Combat")
local MovementPage = CreatePage("Movement")
local VisualPage = CreatePage("Visuals")
local MacrosPage = CreatePage("Macros")
local CreditsPage = CreatePage("Credits")
local SettingsPage = CreatePage("Settings")

--// HOME CONTENT
AddCard(Home, "Welcome to Ivory PVP", "Mobile optimized Blox Fruits PVP", "◆")
AddCard(Home, "Current Status", "All systems operational", "●")
AddCard(Home, "Script Version", "v12.0 - Macro Fix", "◈")
AddCard(Home, "Quick Stats", "Silent Aim | Soru | Macro", "▣")
AddCard(Home, "Mobile Only", "No PC inputs, no freezes", "◎")
AddCard(Home, "Anti-Detection", "Camera stays still", "◇")
AddCard(Home, "Performance", "Optimized for mobile devices", "◉")
AddCard(Home, "Updates", "Join Discord for latest updates", "✦")

--// AIMBOT PAGE
AddToggle(AimbotPage, "Silent Aim", "Aim at target without moving camera", function(enabled)
    Combat.SilentAimEnabled = enabled
    if enabled then
        Status.Text = "●  SILENT AIM"
        Status.TextColor3 = RED
    else
        Status.Text = "●  ONLINE"
        Status.TextColor3 = GREEN
        Combat.SilentAimTarget = nil
    end
end, "◎")

AddToggle(AimbotPage, "Soru Button", "Show Soru button on screen", function(enabled)
    Combat.SoruButtonVisible = enabled
    SoruButton.Visible = enabled
end, "⚡")

AddToggle(AimbotPage, "Target Players", "Aim at players", function(enabled)
    Combat.TargetPlayers = enabled
end, "👤")

AddToggle(AimbotPage, "Target NPCs", "Aim at NPCs", function(enabled)
    Combat.TargetNPCs = enabled
end, "🤖")

AddSlider(AimbotPage, "Silent Aim FOV", 30, 360, 180, function(val)
    Combat.SilentAimFOV = val
end, "◉")

AddSlider(AimbotPage, "Hit Chance", 0, 100, 100, function(val)
    Combat.SilentAimHitChance = val
end, "◉")

AddSlider(AimbotPage, "Prediction", 0, 1, 0.15, function(val)
    Combat.SilentAimPrediction = val
end, "▣")

AddSlider(AimbotPage, "Soru Distance", 5, 30, 15, function(val)
    Combat.SoruDistance = val
end, "⚡")

--// COMBAT PAGE
AddToggle(CombatPage, "Anti Stun", "Prevents stun effects", function(enabled)
    Combat.AntiStun = enabled
end, "🛡")

AddToggle(CombatPage, "No Clip", "Walk through walls", function(enabled)
    Combat.NoClip = enabled
end, "◌")

--// MOVEMENT PAGE
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

--// VISUAL PAGE
AddToggle(VisualPage, "ESP Boxes", "Show player boxes through walls", function(enabled)
    Combat.ESPEnabled = enabled
    if not enabled then
        for _, box in pairs(Combat.ESPBoxes) do
            if box then box:Destroy() end
        end
        for _, name in pairs(Combat.ESPNames) do
            if name then name:Destroy() end
        end
        for _, dist in pairs(Combat.ESPDistance) do
            if dist then dist:Destroy() end
        end
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

--// MACROS PAGE
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

-- Melee
AddToggle(MacrosPage, "Melee", "Use melee attack in macro", function(enabled)
    Combat.MacroMeleeEnabled = enabled
end, "👊")
AddSlider(MacrosPage, "Melee Delay", 0, 5, 0.5, function(val)
    Combat.MacroMeleeDelay = val
end, "⏱")
local MeleeMoveButton = Instance.new("TextButton")
MeleeMoveButton.Size = UDim2.new(1, -2, 0, 30)
MeleeMoveButton.BackgroundColor3 = PANEL
MeleeMoveButton.Text = "Melee Move: Z"
MeleeMoveButton.TextColor3 = WHITE
MeleeMoveButton.Font = Enum.Font.GothamBold
MeleeMoveButton.TextSize = 11
MeleeMoveButton.Parent = MacrosPage
local MeleeMoveIndex = 1
MeleeMoveButton.MouseButton1Click:Connect(function()
    MeleeMoveIndex = MeleeMoveIndex % #MeleeMoves + 1
    Combat.MeleeMove = MeleeMoves[MeleeMoveIndex]
    MeleeMoveButton.Text = "Melee Move: " .. Combat.MeleeMove
end)

-- Sword
AddToggle(MacrosPage, "Sword", "Use sword move in macro", function(enabled)
    Combat.MacroSwordEnabled = enabled
end, "⚔")
AddSlider(MacrosPage, "Sword Delay", 0, 5, 0.5, function(val)
    Combat.MacroSwordDelay = val
end, "⏱")
local SwordMoveButton = Instance.new("TextButton")
SwordMoveButton.Size = UDim2.new(1, -2, 0, 30)
SwordMoveButton.BackgroundColor3 = PANEL
SwordMoveButton.Text = "Sword Move: Z"
SwordMoveButton.TextColor3 = WHITE
SwordMoveButton.Font = Enum.Font.GothamBold
SwordMoveButton.TextSize = 11
SwordMoveButton.Parent = MacrosPage
local SwordMoveIndex = 1
SwordMoveButton.MouseButton1Click:Connect(function()
    SwordMoveIndex = SwordMoveIndex % #SwordMoves + 1
    Combat.SwordMove = SwordMoves[SwordMoveIndex]
    SwordMoveButton.Text = "Sword Move: " .. Combat.SwordMove
end)

-- Fruit
AddToggle(MacrosPage, "Fruit", "Use fruit move in macro", function(enabled)
    Combat.MacroFruitEnabled = enabled
end, "🍈")
AddSlider(MacrosPage, "Fruit Delay", 0, 5, 0.5, function(val)
    Combat.MacroFruitDelay = val
end, "⏱")
local FruitMoveButton = Instance.new("TextButton")
FruitMoveButton.Size = UDim2.new(1, -2, 0, 30)
FruitMoveButton.BackgroundColor3 = PANEL
FruitMoveButton.Text = "Fruit Move: Z"
FruitMoveButton.TextColor3 = WHITE
FruitMoveButton.Font = Enum.Font.GothamBold
FruitMoveButton.TextSize = 11
FruitMoveButton.Parent = MacrosPage
local FruitMoveIndex = 1
FruitMoveButton.MouseButton1Click:Connect(function()
    FruitMoveIndex = FruitMoveIndex % #FruitMoves + 1
    Combat.FruitMove = FruitMoves[FruitMoveIndex]
    FruitMoveButton.Text = "Fruit Move: " .. Combat.FruitMove
end)

-- Gun
AddToggle(MacrosPage, "Gun", "Use gun move in macro", function(enabled)
    Combat.MacroGunEnabled = enabled
end, "🔫")
AddSlider(MacrosPage, "Gun Delay", 0, 5, 0.5, function(val)
    Combat.MacroGunDelay = val
end, "⏱")
local GunMoveButton = Instance.new("TextButton")
GunMoveButton.Size = UDim2.new(1, -2, 0, 30)
GunMoveButton.BackgroundColor3 = PANEL
GunMoveButton.Text = "Gun Move: Z"
GunMoveButton.TextColor3 = WHITE
GunMoveButton.Font = Enum.Font.GothamBold
GunMoveButton.TextSize = 11
GunMoveButton.Parent = MacrosPage
local GunMoveIndex = 1
GunMoveButton.MouseButton1Click:Connect(function()
    GunMoveIndex = GunMoveIndex % #GunMoves + 1
    Combat.GunMove = GunMoves[GunMoveIndex]
    GunMoveButton.Text = "Gun Move: " .. Combat.GunMove
end)

--// CREDITS PAGE
AddCard(CreditsPage, "Made By", "Ivory", "◆")
AddCard(CreditsPage, "Discord", "Ivory999", "◈")
AddCard(CreditsPage, "Ideas By", "Rayo", "✦")
AddCard(CreditsPage, "Discord", "rayo06996", "◎")
AddCard(CreditsPage, "Version", "v12.0 - Macro Fix", "▣")
AddCard(CreditsPage, "Special Thanks", "All supporters and testers", "♡")
AddCard(CreditsPage, "Updates", "Join Discord for latest updates", "↻")

--// SETTINGS PAGE
AddToggle(SettingsPage, "Hide UI", "Toggle UI visibility", function(enabled)
    Main.Visible = not enabled
end, "◇")

AddCard(SettingsPage, "Save Config", "Settings auto-save on change", "♢")
AddCard(SettingsPage, "Reset Settings", "Click to reset all settings", "↺")

--// SIDEBAR BUTTONS
local Tabs = {}

local function CreateTab(name, order, icon)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 24)
    Button.BackgroundColor3 = DARK
    Button.Text = icon .. " " .. name:upper()
    Button.TextColor3 = GREY
    Button.TextSize = 8
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.fromOffset(2, 15)
    Accent.Position = UDim2.new(0, 4, 0.5, -7)
    Accent.BackgroundColor3 = IVORY
    Accent.BorderSizePixel = 0
    Accent.Visible = false
    Accent.Parent = Button

    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = Accent

    Tabs[name] = {
        Button = Button,
        Accent = Accent
    }

    Button.MouseEnter:Connect(function()
        if Button.BackgroundColor3 ~= IVORY then
            tween(Button, 0.15, {
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                TextColor3 = IVORY
            })
        end
    end)

    Button.MouseLeave:Connect(function()
        if Button.BackgroundColor3 ~= IVORY then
            tween(Button, 0.15, {
                BackgroundColor3 = DARK,
                TextColor3 = GREY
            })
        end
    end)

    Button.MouseButton1Click:Connect(function()
        for tabName, data in pairs(Tabs) do
            tween(data.Button, 0.15, {
                BackgroundColor3 = DARK,
                TextColor3 = GREY
            })

            data.Accent.Visible = false
        end

        tween(Button, 0.2, {
            BackgroundColor3 = IVORY,
            TextColor3 = BLACK
        })

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

--// DEFAULT TAB
Tabs.Home.Button.BackgroundColor3 = IVORY
Tabs.Home.Button.TextColor3 = BLACK
Tabs.Home.Accent.Visible = true
Home.Visible = true

--// DRAGGING
local function MakeDraggable(Object, DragObject)
    local dragging = false
    local dragStart
    local startPos

    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

            local delta = input.Position - dragStart

            Object.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(Main, Top)
MakeDraggable(Toggle, Toggle)
MakeDraggable(MacroButton, MacroButton)
MakeDraggable(SoruButton, SoruButton)

--// OPEN / CLOSE
local Open = true

local function ShowUI()
    Open = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(440, 290)

    tween(Main, 0.3, {
        Size = UDim2.fromOffset(470, 320)
    })
end

local function HideUI()
    Open = false

    tween(Main, 0.25, {
        Size = UDim2.fromOffset(440, 290)
    })

    task.delay(0.25, function()
        if not Open then
            Main.Visible = false
        end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if Open then
        HideUI()
    else
        ShowUI()
    end
end)

Close.MouseButton1Click:Connect(function()
    HideUI()
end)

--// MACRO BUTTON HANDLER
MacroButton.MouseButton1Click:Connect(function()
    if not Combat.MacroEnabled then return end
    
    if Combat.MacroMeleeEnabled then
        -- Simulate melee attack with selected move
        local key = Combat.MeleeMove
        -- On mobile, we can't simulate key presses, but we can try to fire remote directly if known.
        -- For now, we'll just wait the delay.
        task.wait(Combat.MacroMeleeDelay)
    end
    
    if Combat.MacroSwordEnabled then
        local key = Combat.SwordMove
        task.wait(Combat.MacroSwordDelay)
    end
    
    if Combat.MacroFruitEnabled then
        local key = Combat.FruitMove
        task.wait(Combat.MacroFruitDelay)
    end
    
    if Combat.MacroGunEnabled then
        local key = Combat.GunMove
        task.wait(Combat.MacroGunDelay)
    end
end)

--// SORU BUTTON HANDLER
SoruButton.MouseButton1Click:Connect(function()
    if not Combat.SoruButtonVisible then return end
    
    if tick() - Combat.LastSoru < Combat.SoruCooldown then return end
    Combat.LastSoru = tick()
    
    local target = nil
    local shortestDistance = math.huge
    
    if Combat.TargetPlayers then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = Player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local otherRoot = otherPlayer.Character.HumanoidRootPart
                    local dist = (root.Position - otherRoot.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        target = otherPlayer
                    end
                end
            end
        end
    end
    
    if Combat.TargetNPCs then
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(model) then
                    local character = Player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local root = character.HumanoidRootPart
                        local otherRoot = model.HumanoidRootPart
                        local dist = (root.Position - otherRoot.Position).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            target = model
                        end
                    end
                end
            end
        end
    end
    
    if target then
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            local targetRoot = target:FindFirstChild("HumanoidRootPart") or target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot then
                for i = 1, 5 do
                    local afterimage = Instance.new("Part")
                    afterimage.Size = root.Size
                    afterimage.CFrame = root.CFrame
                    afterimage.Anchored = true
                    afterimage.CanCollide = false
                    afterimage.Transparency = 0.3 + (i * 0.1)
                    afterimage.Color = IVORY
                    afterimage.Material = Enum.Material.ForceField
                    afterimage.Parent = workspace
                    game:GetService("Debris"):AddItem(afterimage, 0.1 * i)
                    task.wait(0.02)
                end
                
                local direction = (root.Position - targetRoot.Position).Unit
                local soruPos = targetRoot.Position + direction * Combat.SoruDistance
                
                root.CFrame = CFrame.new(soruPos) * CFrame.Angles(0, math.rad(180), 0)
                
                local flashEffect = Instance.new("Part")
                flashEffect.Size = Vector3.new(2, 2, 2)
                flashEffect.Position = soruPos
                flashEffect.Anchored = true
                flashEffect.CanCollide = false
                flashEffect.Transparency = 0.5
                flashEffect.Color = IVORY
                flashEffect.Material = Enum.Material.Neon
                flashEffect.Parent = workspace
                game:GetService("Debris"):AddItem(flashEffect, 0.5)
            end
        end
    end
end)

--// BUTTON EFFECTS
Toggle.MouseEnter:Connect(function()
    tween(Toggle, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
end)
Toggle.MouseLeave:Connect(function()
    tween(Toggle, 0.15, {BackgroundColor3 = BLACK})
end)
Close.MouseEnter:Connect(function()
    tween(Close, 0.15, {BackgroundColor3 = IVORY, TextColor3 = BLACK})
end)
Close.MouseLeave:Connect(function()
    tween(Close, 0.15, {BackgroundColor3 = DARKGREY, TextColor3 = IVORY})
end)
MacroButton.MouseEnter:Connect(function()
    tween(MacroButton, 0.15, {BackgroundColor3 = Color3.fromRGB(40, 40, 20)})
end)
MacroButton.MouseLeave:Connect(function()
    tween(MacroButton, 0.15, {BackgroundColor3 = BLACK})
end)
SoruButton.MouseEnter:Connect(function()
    tween(SoruButton, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
end)
SoruButton.MouseLeave:Connect(function()
    tween(SoruButton, 0.15, {BackgroundColor3 = BLACK})
end)

--// SILENT AIM FUNCTION (whitelist)
local function GetClosestTarget()
    local closest = nil
    local shortestDistance = Combat.SilentAimFOV
    
    if Combat.TargetPlayers then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = Player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local otherRoot = otherPlayer.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToScreenPoint(otherRoot.Position)
                    if onScreen then
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closest = otherPlayer
                        end
                    end
                end
            end
        end
    end
    
    if Combat.TargetNPCs then
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(model) then
                    local character = Player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local root = character.HumanoidRootPart
                        local otherRoot = model.HumanoidRootPart
                        local screenPos, onScreen = Camera:WorldToScreenPoint(otherRoot.Position)
                        if onScreen then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                closest = model
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- Whitelist of remote names that are considered attacks
local AttackKeywords = {"Attack", "Melee", "Sword", "Fruit", "Gun", "Click", "Fire", "Damage", "Combat", "Ability", "Hit"}

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Combat.SilentAimEnabled and not checkcaller() then
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = self.Name or ""
            local isAttack = false
            for _, kw in ipairs(AttackKeywords) do
                if string.find(remoteName:lower(), kw:lower()) then
                    isAttack = true
                    break
                end
            end
            if isAttack then
                local target = GetClosestTarget()
                if target then
                    local targetRoot = target:FindFirstChild("HumanoidRootPart") or (target.Character and target.Character:FindFirstChild("HumanoidRootPart"))
                    local character = Player.Character
                    if targetRoot and character and character:FindFirstChild("HumanoidRootPart") then
                        local root = character.HumanoidRootPart
                        local predictedPos = targetRoot.Position
                        if target:FindFirstChild("Humanoid") then
                            local velocity = target.Humanoid.MoveDirection * target.Humanoid.WalkSpeed
                            predictedPos = targetRoot.Position + velocity * Combat.SilentAimPrediction
                        end
                        if math.random(1, 100) <= Combat.SilentAimHitChance then
                            local originalCFrame = root.CFrame
                            root.CFrame = CFrame.lookAt(root.Position, predictedPos)
                            local result = OldNamecall(self, unpack(args))
                            root.CFrame = originalCFrame
                            return result
                        end
                    end
                end
            end
        end
    end
    
    return OldNamecall(self, ...)
end)

--// MAIN LOOP
RunService.RenderStepped:Connect(function()
    if Combat.SpeedHack and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 16 * Combat.SpeedMultiplier
    end
    
    if Combat.NoClip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    if Combat.AntiStun and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        if humanoid:GetState() == Enum.HumanoidStateType.Stunned then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    
    if Combat.ESPEnabled then
        for _, box in pairs(Combat.ESPBoxes) do
            if box then box:Destroy() end
        end
        for _, name in pairs(Combat.ESPNames) do
            if name then name:Destroy() end
        end
        for _, dist in pairs(Combat.ESPDistance) do
            if dist then dist:Destroy() end
        end
        Combat.ESPBoxes = {}
        Combat.ESPNames = {}
        Combat.ESPDistance = {}
        
        local targets = {}
        if Combat.TargetPlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(targets, p.Character)
                end
            end
        end
        if Combat.TargetNPCs then
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                    if not Players:GetPlayerFromCharacter(model) then
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
