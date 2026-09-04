--// IVORY HUB — BLOX FRUITS PVP SCRIPT
--// 180° Aimbot + Combat Features
--// Black & Ivory / Mobile Friendly

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

local function tween(obj, time, props)
    TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// COMBAT VARIABLES
local Combat = {
    AimbotEnabled = false,
    AimbotAngle = 180, -- 180 degree aimbot
    AimbotTarget = nil,
    AimbotFOV = 180,
    AimbotLock = false,
    AutoAttack = false,
    AttackCooldown = 0.5,
    LastAttack = 0,
    ESPEnabled = false,
    ESPBoxes = {},
    AutoDodge = false,
    DodgeCooldown = 2,
    LastDodge = 0
}

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
Toggle.TextColor3 = WHITE
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 11)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = LIGHT
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = Toggle

--// MAIN
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(480, 305)
Main.Position = UDim2.new(0.5, -240, 0.5, -152)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = LIGHT
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
Title.TextColor3 = WHITE
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.fromOffset(19, 32)
SubTitle.Size = UDim2.fromOffset(200, 17)
SubTitle.Text = "BLOX FRUITS COMBAT"
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
Close.TextColor3 = LIGHT
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
Sidebar.Size = UDim2.fromOffset(112, 225)
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

--// TOGGLE CARD
local function AddToggle(Page, title, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -2, 0, 60)
    Card.BackgroundColor3 = PANEL
    Card.BorderSizePixel = 0
    Card.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = LIGHT
    Stroke.Transparency = 0.92
    Stroke.Parent = Card

    local T = Instance.new("TextLabel")
    T.BackgroundTransparency = 1
    T.Position = UDim2.fromOffset(12, 8)
    T.Size = UDim2.new(1, -80, 0, 20)
    T.Text = title
    T.TextColor3 = WHITE
    T.TextSize = 12
    T.Font = Enum.Font.GothamBold
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local D = Instance.new("TextLabel")
    D.BackgroundTransparency = 1
    D.Position = UDim2.fromOffset(12, 29)
    D.Size = UDim2.new(1, -80, 0, 20)
    D.Text = description
    D.TextColor3 = GREY
    D.TextSize = 9
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

--// CREATE PAGES
local Home = CreatePage("Home")
local AimbotPage = CreatePage("Aimbot")
local CombatPage = CreatePage("Combat")
local VisualPage = CreatePage("Visuals")
local SettingsPage = CreatePage("Settings")

--// AIMBOT PAGE
AddToggle(AimbotPage, "180° Aimbot", "Locks onto targets in 180° FOV", function(enabled)
    Combat.AimbotEnabled = enabled
    if enabled then
        Status.Text = "●  AIMBOT ON"
        Status.TextColor3 = RED
    else
        Status.Text = "●  ONLINE"
        Status.TextColor3 = GREEN
        Combat.AimbotTarget = nil
    end
end)

AddToggle(AimbotPage, "Aimbot Lock", "Hard lock onto target", function(enabled)
    Combat.AimbotLock = enabled
end)

AddToggle(AimbotPage, "Auto Attack", "Automatically attacks target", function(enabled)
    Combat.AutoAttack = enabled
end)

AddToggle(AimbotPage, "Auto Dodge", "Automatically dodges attacks", function(enabled)
    Combat.AutoDodge = enabled
end)

--// COMBAT PAGE
AddToggle(CombatPage, "ESP", "Show player boxes", function(enabled)
    Combat.ESPEnabled = enabled
    if not enabled then
        for _, box in pairs(Combat.ESPBoxes) do
            if box then
                box:Destroy()
            end
        end
        Combat.ESPBoxes = {}
    end
end)

--// VISUAL PAGE
AddToggle(VisualPage, "Aimbot FOV Circle", "Show 180° FOV circle", function(enabled)
    -- FOV circle implementation
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = enabled
    FOVCircle.Thickness = 1
    FOVCircle.Radius = 180
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Transparency = 0.7
    
    if enabled then
        RunService.RenderStepped:Connect(function()
            FOVCircle.Position = Camera.ViewportSize / 2
        end)
    end
end)

--// SETTINGS PAGE
AddToggle(SettingsPage, "Mobile Mode", "Optimized for mobile", function(enabled)
    if enabled then
        Main.Size = UDim2.fromOffset(430, 285)
        Main.Position = UDim2.new(0.5, -215, 0.5, -142)
    else
        Main.Size = UDim2.fromOffset(480, 305)
        Main.Position = UDim2.new(0.5, -240, 0.5, -152)
    end
end)

--// SIDEBAR BUTTONS
local Tabs = {}

local function CreateTab(name, order)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 25)
    Button.BackgroundColor3 = DARK
    Button.Text = name:upper()
    Button.TextColor3 = GREY
    Button.TextSize = 9
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.fromOffset(2, 13)
    Accent.Position = UDim2.new(0, 4, 0.5, -6)
    Accent.BackgroundColor3 = WHITE
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
        if Button.BackgroundColor3 ~= LIGHT then
            tween(Button, 0.15, {
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                TextColor3 = LIGHT
            })
        end
    end)

    Button.MouseLeave:Connect(function()
        if Button.BackgroundColor3 ~= LIGHT then
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
            BackgroundColor3 = LIGHT,
            TextColor3 = BLACK
        })

        Accent.Visible = true

        for pageName, page in pairs(Pages) do
            page.Visible = (pageName == name)
        end
    end)

    return Button
end

CreateTab("Home", 1)
CreateTab("Aimbot", 2)
CreateTab("Combat", 3)
CreateTab("Visuals", 4)
CreateTab("Settings", 5)

--// DEFAULT TAB
Tabs.Home.Button.BackgroundColor3 = LIGHT
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

--// OPEN / CLOSE
local Open = true

local function ShowUI()
    Open = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(440, 280)

    tween(Main, 0.3, {
        Size = UDim2.fromOffset(480, 305)
    })
end

local function HideUI()
    Open = false

    tween(Main, 0.25, {
        Size = UDim2.fromOffset(440, 280)
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

--// BUTTON EFFECTS
Toggle.MouseEnter:Connect(function()
    tween(Toggle, 0.15, {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    })
end)

Toggle.MouseLeave:Connect(function()
    tween(Toggle, 0.15, {
        BackgroundColor3 = BLACK
    })
end)

Close.MouseEnter:Connect(function()
    tween(Close, 0.15, {
        BackgroundColor3 = LIGHT,
        TextColor3 = BLACK
    })
end)

Close.MouseLeave:Connect(function()
    tween(Close, 0.15, {
        BackgroundColor3 = DARKGREY,
        TextColor3 = LIGHT
    })
end)

--// MOBILE SCALE
local function UpdateScale()
    if not Camera then return end

    local Width = Camera.ViewportSize.X

    if Width < 500 then
        Main.Size = UDim2.fromOffset(430, 285)
        Main.Position = UDim2.new(0.5, -215, 0.5, -142)
    else
        Main.Size = UDim2.fromOffset(480, 305)
        Main.Position = UDim2.new(0.5, -240, 0.5, -152)
    end
end

UpdateScale()

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

--// AIMBOT FUNCTION (180° FOV)
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = 180 -- 180° FOV
    
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
    
    return closest
end

--// AIMBOT LOOP
RunService.RenderStepped:Connect(function()
    if Combat.AimbotEnabled then
        local target = GetClosestPlayer()
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Combat.AimbotTarget = target
            
            local character = Player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local targetRoot = target.Character.HumanoidRootPart
                
                -- 180° aimbot - locks camera to target
                local lookAt = CFrame.lookAt(root.Position, targetRoot.Position)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.5)
                
                if Combat.AimbotLock then
                    Camera.CFrame = lookAt
                end
                
                -- Auto attack
                if Combat.AutoAttack and tick() - Combat.LastAttack > Combat.AttackCooldown then
                    Combat.LastAttack = tick()
                    
                    -- Simulate click for attack
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                end
            end
        else
            Combat.AimbotTarget = nil
        end
    end
    
    -- Auto dodge
    if Combat.AutoDodge and tick() - Combat.LastDodge > Combat.DodgeCooldown then
        Combat.LastDodge = tick()
        
        -- Check for incoming attacks
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local otherRoot = otherPlayer.Character.HumanoidRootPart
                    local distance = (root.Position - otherRoot.Position).Magnitude
                    
                    if distance < 15 then
                        -- Dodge by moving
                        local dodgeDirection = (root.Position - otherRoot.Position).Unit
                        root.Velocity = dodgeDirection * Vector3.new(100, 0, 100)
                        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
                    end
                end
            end
        end
    end
    
    -- ESP
    if Combat.ESPEnabled then
        -- Clear old ESP boxes
        for _, box in pairs(Combat.ESPBoxes) do
            if box then
                box:Destroy()
            end
        end
        Combat.ESPBoxes = {}
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = otherPlayer.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                
                if onScreen then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Size = Vector2.new(50, 100)
                    box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 100)
                    box.Color = Color3.fromRGB(255, 0, 0)
                    box.Thickness = 2
                    box.Filled = false
                    
                    table.insert(Combat.ESPBoxes, box)
                end
            end
        end
    end
end)
