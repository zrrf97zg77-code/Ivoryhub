--// =========================================================
--//                    IVORY HUB
--// =========================================================
--// Creators:
--// Ivory  | Discord: Ivory999
--// Rayo   | Discord: rayo06996
--//
--// Mobile Edition – Focused: Silent Aim, Soru Aimbot, Walkspeed, Gun M1
--// =========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VIM = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Remove previous version
local Old = PlayerGui:FindFirstChild("IvoryHub")
if Old then Old:Destroy() end

--//=========================================================
--// COLORS
--//=========================================================
local BLACK = Color3.fromRGB(7,7,7)
local DARK = Color3.fromRGB(13,13,13)
local DARKER = Color3.fromRGB(19,19,19)
local WHITE = Color3.fromRGB(245,245,245)
local GRAY = Color3.fromRGB(145,145,145)
local BORDER = Color3.fromRGB(40,40,40)
local RED = Color3.fromRGB(255,50,50)
local GREEN = Color3.fromRGB(50,255,50)

--//=========================================================
--// HELPERS
--//=========================================================
local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function AddStroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = BORDER
    s.Thickness = 1
    s.Parent = obj
end

local function Tween(obj, time, properties)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
end

local function Text(parent, text, size, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = WHITE
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

--//=========================================================
--// SCREEN GUI
--//=========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--//=========================================================
--// MAIN
--//=========================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,520,0,340)
Main.Position = UDim2.new(0.5,-260,0.5,-170)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Parent = Gui
Corner(Main,12)
AddStroke(Main)

--//=========================================================
--// TOP BAR
--//=========================================================
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,58)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top,12)

local Title = Text(Top,"IVORY",19,true)
Title.Position = UDim2.new(0,18,0,7)
Title.Size = UDim2.new(0,150,0,27)

local SubTitle = Text(Top,"H U B",10,false)
SubTitle.TextColor3 = GRAY
SubTitle.Position = UDim2.new(0,19,0,34)
SubTitle.Size = UDim2.new(0,100,0,15)

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,32,0,32)
Close.Position = UDim2.new(1,-42,0,13)
Close.BackgroundColor3 = DARKER
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 21
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Top
Corner(Close,8)

-- Minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,32,0,32)
Minimize.Position = UDim2.new(1,-80,0,13)
Minimize.BackgroundColor3 = DARKER
Minimize.Text = "—"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Minimize.Parent = Top
Corner(Minimize,8)

--//=========================================================
--// SIDEBAR
--//=========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,135,1,-70)
Sidebar.Position = UDim2.new(0,10,0,65)
Sidebar.BackgroundColor3 = DARK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar,10)
AddStroke(Sidebar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0,6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Sidebar

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0,10)
Padding.PaddingLeft = UDim.new(0,8)
Padding.PaddingRight = UDim.new(0,8)
Padding.Parent = Sidebar

--//=========================================================
--// CONTENT
--//=========================================================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-155,1,-70)
Content.Position = UDim2.new(0,145,0,65)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content,10)
AddStroke(Content)

local Pages = {}

--//=========================================================
--// CREATE PAGE
--//=========================================================
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1,-20,1,-20)
    Page.Position = UDim2.new(0,10,0,10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = WHITE
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 15)
    end)

    Pages[name] = Page
    return Page
end

--//=========================================================
--// SECTION TITLE
--//=========================================================
local function Section(parent,text)
    local Label = Text(parent,text,10,true)
    Label.TextColor3 = GRAY
    Label.Size = UDim2.new(1,0,0,24)
    return Label
end

--//=========================================================
--// BUTTON (kept for settings)
--//=========================================================
local function Button(parent,text,callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1,0,0,40)
    Btn.BackgroundColor3 = DARKER
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = WHITE
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Corner(Btn,8)
    AddStroke(Btn)

    Btn.MouseEnter:Connect(function()
        Tween(Btn,.15,{BackgroundColor3 = Color3.fromRGB(28,28,28)})
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn,.15,{BackgroundColor3 = DARKER})
    end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

--//=========================================================
--// TOGGLE – shows ON/OFF
--//=========================================================
local function Toggle(parent, text, default, callback)
    local State = default or false
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,42)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder,8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": OFF", 13, false)
    Label.Position = UDim2.new(0,13,0,0)
    Label.Size = UDim2.new(1,-70,1,0)

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,42,0,22)
    Switch.Position = UDim2.new(1,-54,.5,-11)
    Switch.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Switch.Text = ""
    Switch.BorderSizePixel = 0
    Switch.Parent = Holder
    Corner(Switch,20)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,16,0,16)
    Circle.Position = UDim2.new(0,3,.5,-8)
    Circle.BackgroundColor3 = GRAY
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    Corner(Circle,20)

    local function Update()
        if State then
            Tween(Switch,.2,{BackgroundColor3 = WHITE})
            Tween(Circle,.2,{Position = UDim2.new(1,-19,.5,-8), BackgroundColor3 = BLACK})
            Label.Text = text .. ": ON"
        else
            Tween(Switch,.2,{BackgroundColor3 = Color3.fromRGB(35,35,35)})
            Tween(Circle,.2,{Position = UDim2.new(0,3,.5,-8), BackgroundColor3 = GRAY})
            Label.Text = text .. ": OFF"
        end
        if callback then callback(State) end
    end

    Switch.MouseButton1Click:Connect(function()
        State = not State
        Update()
    end)

    Update()
    return Holder
end

--//=========================================================
--// PAGES
--//=========================================================
local MainPage   = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visuals")
local SettingsPage = CreatePage("Settings")
local CreditsPage = CreatePage("Credits")

--//=========================================================
--// FEATURE STATES
--//=========================================================
-- Combat (main four)
local SilentAim      = false
local SoruAimbot     = false   -- Soru = Flash Step key F
local Walkspeed      = false
local GunM1          = false

-- Player extras
local InfiniteJump   = false
local NoClip         = false
local AntiAFK        = false

-- Visuals (ESP)
local ESPEnabled     = false
local ESPBox         = false
local ESPName        = false
local ESPHealth      = false
local ESPDistance    = false

local RunningLoop = nil

--//=========================================================
--// HELPERS
--//=========================================================
local function GetNearestPlayer()
    local nearest, dist = nil, math.huge
    local char = Player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local pos = root.Position
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local c = plr.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
                local p = c.HumanoidRootPart.Position
                local d = (p - pos).Magnitude
                if d < dist then
                    dist = d
                    nearest = plr
                end
            end
        end
    end
    return nearest, dist
end

local function HasGunEquipped()
    local char = Player.Character
    if not char then return false end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("rifle") or tool.Name:lower():find("pistol") or tool.Name:lower():find("cannon") or tool:FindFirstChild("Handle")) then
            return true
        end
    end
    return false
end

--//=========================================================
--// COMBAT UPDATES (mobile compatible)
--//=========================================================
local function SilentAimUpdate()
    if not SilentAim then return end
    local target, dist = GetNearestPlayer()
    if not target or dist > 50 then return end
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local myChar = Player.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local look = Vector3.new(tRoot.Position.X - myRoot.Position.X, 0, tRoot.Position.Z - myRoot.Position.Z)
    if look.Magnitude > 0.5 then
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + look.Unit)
    end
end

local function SoruAimbotUpdate()
    if not SoruAimbot or not VIM then return end
    local target, dist = GetNearestPlayer()
    if not target or dist > 25 then return end
    -- Simulate Soru (Flash Step) key F
    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

local function WalkspeedUpdate()
    if not Walkspeed then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.WalkSpeed ~= 16 then
                char.Humanoid.WalkSpeed = 16
            end
        end
        return
    end
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 50
    end
end

local function GunM1Update()
    if not GunM1 or not VIM then return end
    if not HasGunEquipped() then return end
    local target, dist = GetNearestPlayer()
    if not target or dist > 25 then return end
    VIM:SendMouseButtonEvent(1, true, game, 0, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(1, false, game, 0, 0)
    task.wait(0.2)
end

--//=========================================================
--// PLAYER EXTRAS
--//=========================================================
local function InfiniteJumpUpdate()
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = InfiniteJump and 50 or 50
    end
end

local function HandleJump()
    if InfiniteJump then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            local root = char.HumanoidRootPart
            if hum:GetState() ~= Enum.HumanoidStateType.Jumping and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
            end
        end
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then
        HandleJump()
    end
end)

local function NoClipUpdate()
    local char = Player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not NoClip
        end
    end
end

local function AntiAFKUpdate()
    if not AntiAFK then return end
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        hum:Move(Vector3.new(1,0,0), true)
        task.wait(0.1)
        hum:Move(Vector3.new(-1,0,0), true)
    end
end

--//=========================================================
--// ESP SYSTEM (unchanged)
--//=========================================================
local ESPObjects = {}
local function CreateESP()
    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ESPOverlay"
    ESPGui.IgnoreGuiInset = true
    ESPGui.Parent = Gui

    local function AddESPForPlayer(plr)
        if ESPObjects[plr] then return end
        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(0,0,0,0)
        container.Parent = ESPGui

        local box = Instance.new("Frame")
        box.BackgroundTransparency = 0.5
        box.BackgroundColor3 = WHITE
        box.BorderSizePixel = 1
        box.BorderColor3 = WHITE
        box.Visible = false
        box.Parent = container

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.TextColor3 = WHITE
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Size = UDim2.new(0,100,0,18)
        nameLabel.Parent = container

        local healthBg = Instance.new("Frame")
        healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        healthBg.BorderSizePixel = 0
        healthBg.Size = UDim2.new(0,100,0,4)
        healthBg.Parent = container

        local healthFill = Instance.new("Frame")
        healthFill.BackgroundColor3 = GREEN
        healthFill.BorderSizePixel = 0
        healthFill.Size = UDim2.new(0,100,0,4)
        healthFill.Parent = healthBg

        local distLabel = Instance.new("TextLabel")
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = GRAY
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.Size = UDim2.new(0,60,0,16)
        distLabel.Parent = container

        ESPObjects[plr] = {
            container = container,
            box = box,
            name = nameLabel,
            healthBg = healthBg,
            healthFill = healthFill,
            dist = distLabel
        }
    end

    local function RemoveESPForPlayer(plr)
        local data = ESPObjects[plr]
        if data then
            data.container:Destroy()
            ESPObjects[plr] = nil
        end
    end

    local function UpdateESP()
        if not ESPEnabled then
            for _, data in pairs(ESPObjects) do
                data.container.Visible = false
            end
            return
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                if not ESPObjects[plr] then AddESPForPlayer(plr) end
                local data = ESPObjects[plr]
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local root = char.HumanoidRootPart
                    local hum = char.Humanoid
                    local pos, onScreen = Camera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        data.container.Visible = true
                        local head = char:FindFirstChild("Head") or root
                        local headPos, _ = Camera:WorldToScreenPoint(head.Position)
                        local rootPos, _ = Camera:WorldToScreenPoint(root.Position)
                        local height = (headPos.Y - rootPos.Y) * 1.2
                        local width = height * 0.6

                        data.container.Position = UDim2.new(0, pos.X - width/2, 0, pos.Y - height - 20)
                        data.container.Size = UDim2.new(0, width, 0, height + 20)

                        if ESPBox then
                            data.box.Visible = true
                            data.box.Size = UDim2.new(1,0,1,-20)
                            data.box.Position = UDim2.new(0,0,0,0)
                        else
                            data.box.Visible = false
                        end

                        if ESPName then
                            data.name.Visible = true
                            data.name.Text = plr.Name
                            data.name.Size = UDim2.new(1,0,0,18)
                            data.name.Position = UDim2.new(0,0,0,-18)
                        else
                            data.name.Visible = false
                        end

                        if ESPHealth then
                            data.healthBg.Visible = true
                            data.healthBg.Size = UDim2.new(1,0,0,4)
                            data.healthBg.Position = UDim2.new(0,0,1,-4)
                            local healthPercent = hum.Health / hum.MaxHealth
                            data.healthFill.Size = UDim2.new(healthPercent,0,1,0)
                            if healthPercent > 0.5 then
                                data.healthFill.BackgroundColor3 = GREEN
                            elseif healthPercent > 0.25 then
                                data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                            else
                                data.healthFill.BackgroundColor3 = RED
                            end
                        else
                            data.healthBg.Visible = false
                        end

                        if ESPDistance then
                            data.dist.Visible = true
                            local dist = (root.Position - Camera.CFrame.Position).Magnitude
                            data.dist.Text = math.floor(dist) .. " m"
                            data.dist.Size = UDim2.new(0,60,0,16)
                            data.dist.Position = UDim2.new(1,-60,0,-16)
                        else
                            data.dist.Visible = false
                        end
                    else
                        data.container.Visible = false
                    end
                else
                    data.container.Visible = false
                end
            end
        end
    end

    Players.PlayerRemoving:Connect(RemoveESPForPlayer)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then AddESPForPlayer(plr) end
    end
    return UpdateESP
end

local ESPUpdate = CreateESP()

--//=========================================================
--// MAIN LOOP
--//=========================================================
local function StartPVPLoop()
    if RunningLoop then return end
    RunningLoop = RunService.Heartbeat:Connect(function()
        SilentAimUpdate()
        SoruAimbotUpdate()
        WalkspeedUpdate()
        GunM1Update()
        NoClipUpdate()
        AntiAFKUpdate()
        ESPUpdate()
    end)
end

local function StopPVPLoop()
    if RunningLoop then
        RunningLoop:Disconnect()
        RunningLoop = nil
    end
end

local function CheckLoopState()
    if SilentAim or SoruAimbot or Walkspeed or GunM1 or NoClip or AntiAFK or ESPEnabled or InfiniteJump then
        StartPVPLoop()
    else
        StopPVPLoop()
    end
end

--//=========================================================
--// BUILD PAGES
--//=========================================================

-- MAIN page
Section(MainPage, "MAIN")
Toggle(MainPage, "Welcome Feature", false, function(state)
    print("[IVORY] Welcome:", state)
end)

-- COMBAT page – main four
Section(CombatPage, "COMBAT")
Toggle(CombatPage, "180° Silent Aim", false, function(state)
    SilentAim = state
    CheckLoopState()
end)
Toggle(CombatPage, "Soru Aimbot (F)", false, function(state)   -- renamed
    SoruAimbot = state
    CheckLoopState()
end)
Toggle(CombatPage, "Walkspeed (x2)", false, function(state)
    Walkspeed = state
    if not state then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end
    CheckLoopState()
end)
Toggle(CombatPage, "Gun M1 Aimbot", false, function(state)
    GunM1 = state
    CheckLoopState()
end)

-- PLAYER page (extras)
Section(PlayerPage, "PLAYER EXTRAS")
Toggle(PlayerPage, "Infinite Jump", false, function(state)
    InfiniteJump = state
    CheckLoopState()
end)
Toggle(PlayerPage, "No Clip", false, function(state)
    NoClip = state
    CheckLoopState()
end)
Toggle(PlayerPage, "Anti-AFK", false, function(state)
    AntiAFK = state
    CheckLoopState()
end)

-- VISUALS page
Section(VisualPage, "VISUALS (ESP)")
Toggle(VisualPage, "Enable ESP", false, function(state)
    ESPEnabled = state
    CheckLoopState()
end)
Toggle(VisualPage, "Show Box", false, function(state)
    ESPBox = state
end)
Toggle(VisualPage, "Show Name", false, function(state)
    ESPName = state
end)
Toggle(VisualPage, "Show Health", false, function(state)
    ESPHealth = state
end)
Toggle(VisualPage, "Show Distance", false, function(state)
    ESPDistance = state
end)

-- SETTINGS page
Section(SettingsPage, "SETTINGS")
Button(SettingsPage, "Show Notification", function()
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0,280,0,65)
    Notification.Position = UDim2.new(1,20,0,20)
    Notification.BackgroundColor3 = BLACK
    Notification.BorderSizePixel = 0
    Notification.Parent = Gui
    Corner(Notification,10)
    AddStroke(Notification)
    local T = Text(Notification,"IVORY HUB",14,true)
    T.Position = UDim2.new(0,14,0,8)
    T.Size = UDim2.new(1,-20,0,20)
    local M = Text(Notification,"Mobile – Silent Aim, Soru, Speed, Gun",11,false)
    M.TextColor3 = GRAY
    M.Position = UDim2.new(0,14,0,32)
    M.Size = UDim2.new(1,-20,0,18)

    Tween(Notification,.3,{Position = UDim2.new(1,-300,0,20)})
    task.delay(3,function()
        Tween(Notification,.3,{Position = UDim2.new(1,20,0,20)})
        task.wait(.3)
        Notification:Destroy()
    end)
end)

Button(SettingsPage, "Print GUI Info", function()
    print("================================")
    print("IVORY HUB - Mobile Edition")
    print("Features: 180 Silent Aim, Soru Aimbot, Walkspeed, Gun M1")
    print("Creators: Ivory & Rayo")
    print("================================")
end)

-- CREDITS page
Section(CreditsPage, "CREATORS")
local CreatorBox = Instance.new("Frame")
CreatorBox.Size = UDim2.new(1,0,0,82)
CreatorBox.BackgroundColor3 = DARKER
CreatorBox.BorderSizePixel = 0
CreatorBox.Parent = CreditsPage
Corner(CreatorBox,8)
AddStroke(CreatorBox)
local Creator1 = Text(CreatorBox,"IVORY",15,true)
Creator1.Position = UDim2.new(0,14,0,10)
Creator1.Size = UDim2.new(1,-28,0,22)
local Discord1 = Text(CreatorBox,"Discord  •  Ivory999",11,false)
Discord1.TextColor3 = GRAY
Discord1.Position = UDim2.new(0,14,0,38)
Discord1.Size = UDim2.new(1,-28,0,18)

local CreatorBox2 = Instance.new("Frame")
CreatorBox2.Size = UDim2.new(1,0,0,82)
CreatorBox2.BackgroundColor3 = DARKER
CreatorBox2.BorderSizePixel = 0
CreatorBox2.Parent = CreditsPage
Corner(CreatorBox2,8)
AddStroke(CreatorBox2)
local Creator2 = Text(CreatorBox2,"RAYO",15,true)
Creator2.Position = UDim2.new(0,14,0,10)
Creator2.Size = UDim2.new(1,-28,0,22)
local Discord2 = Text(CreatorBox2,"Discord  •  rayo06996",11,false)
Discord2.TextColor3 = GRAY
Discord2.Position = UDim2.new(0,14,0,38)
Discord2.Size = UDim2.new(1,-28,0,18)

local Version = Text(CreditsPage,"Ivory Hub  •  Mobile Edition",10,false)
Version.TextColor3 = GRAY
Version.Size = UDim2.new(1,0,0,25)

--//=========================================================
--// TABS
--//=========================================================
local Tabs = {
    {"MAIN",    MainPage},
    {"COMBAT",  CombatPage},
    {"PLAYER",  PlayerPage},
    {"VISUALS", VisualPage},
    {"SETTINGS",SettingsPage},
    {"CREDITS", CreditsPage}
}

local CurrentTab

local function SelectTab(button,page)
    for _,data in ipairs(Tabs) do
        local otherButton = data[3]
        if otherButton then
            Tween(otherButton,.15,{BackgroundColor3 = DARKER})
        end
        data[2].Visible = false
    end
    Tween(button,.15,{BackgroundColor3 = WHITE})
    button.TextColor3 = BLACK
    page.Visible = true
    CurrentTab = page
end

for _,data in ipairs(Tabs) do
    local Name = data[1]
    local Page = data[2]
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(1,0,0,38)
    Tab.BackgroundColor3 = DARKER
    Tab.BorderSizePixel = 0
    Tab.Text = Name
    Tab.TextColor3 = GRAY
    Tab.TextSize = 11
    Tab.Font = Enum.Font.GothamBold
    Tab.AutoButtonColor = false
    Tab.Parent = Sidebar
    Corner(Tab,8)
    AddStroke(Tab)
    data[3] = Tab

    Tab.MouseEnter:Connect(function()
        if CurrentTab ~= Page then
            Tween(Tab,.15,{BackgroundColor3 = Color3.fromRGB(27,27,27)})
        end
    end)
    Tab.MouseLeave:Connect(function()
        if CurrentTab ~= Page then
            Tween(Tab,.15,{BackgroundColor3 = DARKER})
        end
    end)
    Tab.MouseButton1Click:Connect(function()
        SelectTab(Tab,Page)
    end)
end

-- Default: Combat
SelectTab(Tabs[2][3], Tabs[2][2])

--//=========================================================
--// DRAGGING (touch friendly)
--//=========================================================
local Dragging = false
local DragStart, StartPosition

local function UpdateDrag(input)
    local Delta = input.Position - DragStart
    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateDrag(input)
    end
end)

--//=========================================================
--// MINIMIZE / CLOSE
--//=========================================================
local Minimized = false
Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Sidebar.Visible = false
        Content.Visible = false
        Tween(Main,.25,{Size = UDim2.new(0,520,0,58)})
        Minimize.Text = "+"
    else
        Tween(Main,.25,{Size = UDim2.new(0,520,0,340)})
        task.wait(.15)
        Sidebar.Visible = true
        Content.Visible = true
        Minimize.Text = "—"
    end
end)

Close.MouseButton1Click:Connect(function()
    Tween(Main,.25,{Size = UDim2.new(0,0,0,0)})
    task.wait(.3)
    Gui:Destroy()
end)

--//=========================================================
--// OPEN/CLOSE KEY (optional – works on external keyboards)
--//=========================================================
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

--//=========================================================
--// START
--//=========================================================
CheckLoopState()

print("================================")
print("        IVORY HUB LOADED")
print("================================")
print("Mobile – Silent Aim, Soru Aimbot, Walkspeed, Gun M1")
print("Creators: Ivory & Rayo")
print("================================")
