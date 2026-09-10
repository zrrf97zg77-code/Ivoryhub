-- =============================================
-- IVORY HUB v6.3 - FULL WORKING
-- =============================================

print("🦷 Ivory Hub v6.3 loading...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VIM = VirtualInputManager

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local parent = gethui and gethui() or CoreGui

local old = parent:FindFirstChild("IvoryHub")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parent

local COLORS = {
    BLACK = Color3.fromRGB(7,7,7),
    DARK = Color3.fromRGB(13,13,13),
    DARKER = Color3.fromRGB(19,19,19),
    WHITE = Color3.fromRGB(245,245,245),
    GRAY = Color3.fromRGB(145,145,145),
    RED = Color3.fromRGB(255,50,50),
    GREEN = Color3.fromRGB(50,255,50),
    BLUE = Color3.fromRGB(50,150,255),
}

local function Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function Stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(40,40,40)
    s.Thickness = 1
    s.Parent = obj
end

local function TweenIt(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.15), props):Play()
end

local function Text(parent, text, size, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = COLORS.WHITE
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

-- =============================================
-- FEATURES
-- =============================================
local Features = {
    SilentAim = false,
    SoruAim = false,
    ESP = false,
    Macro = false,
    FOVCircle = false,
    FOVRadius = 150,
    FOVMode = "V1",
}

-- =============================================
-- FOV
-- =============================================
local FOVGui = nil
local FOVRing = nil

local function getFOVCenter()
    if Features.FOVMode == "V2" then
        return UserInputService:GetMouseLocation()
    end
    return Camera.ViewportSize / 2
end

local function isInFOV(hrp)
    if not Features.FOVCircle then return true end
    if not hrp then return false end
    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then return false end
    local center = getFOVCenter()
    return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= Features.FOVRadius
end

local function UpdateFOVCircle()
    if Features.FOVCircle then
        if not FOVGui or not FOVGui.Parent then
            FOVGui = Instance.new("ScreenGui")
            FOVGui.Name = "IvoryFOV"
            FOVGui.ResetOnSpawn = false
            FOVGui.IgnoreGuiInset = true
            FOVGui.DisplayOrder = 1
            FOVGui.Parent = Gui
            
            FOVRing = Instance.new("Frame")
            FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
            FOVRing.BackgroundTransparency = 1
            FOVRing.BorderSizePixel = 0
            FOVRing.ZIndex = 100
            FOVRing.Parent = FOVGui
            Corner(FOVRing, 999)
            
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 2
            stroke.Color = COLORS.RED
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = FOVRing
        end
        
        if FOVRing then
            local center = getFOVCenter()
            local diameter = math.floor(Features.FOVRadius * 2)
            FOVRing.Position = UDim2.new(0, center.X, 0, center.Y)
            FOVRing.Size = UDim2.fromOffset(diameter, diameter)
            FOVRing.Visible = true
        end
    elseif FOVRing then
        FOVRing.Visible = false
    end
end

RunService.RenderStepped:Connect(function()
    pcall(UpdateFOVCircle)
end)

-- =============================================
-- GET NEAREST ENEMY
-- =============================================
local function GetNearestEnemy()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local best, bestDist = nil, math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                if isInFOV(hrp) then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < bestDist and dist <= 1000 then
                        bestDist = dist
                        best = hrp
                    end
                end
            end
        end
    end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in pairs(enemies:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    if isInFOV(hrp) then
                        local dist = (hrp.Position - root.Position).Magnitude
                        if dist < bestDist and dist <= 1000 then
                            bestDist = dist
                            best = hrp
                        end
                    end
                end
            end
        end
    end
    
    return best
end

-- =============================================
-- SILENT AIM
-- =============================================
local TargetPos = nil

pcall(function()
    local mt = getrawmetatable(game)
    if not mt then return end
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__index = function(self, key)
        if not checkcaller() and self == mouse and Features.SilentAim then
            if key == "Hit" or key == "Target" then
                local target = GetNearestEnemy()
                if target then
                    TargetPos = target.Position
                    if key == "Hit" then return CFrame.new(TargetPos) end
                    if key == "Target" then return nil end
                end
            end
        end
        return oldIndex(self, key)
    end
    
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if not checkcaller() and Features.SilentAim and TargetPos then
            if method == "FireServer" or method == "InvokeServer" then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = TargetPos
                    elseif typeof(v) == "CFrame" then
                        args[i] = CFrame.new(TargetPos)
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end
    
    setreadonly(mt, true)
    print("[Ivory] Silent Aim hooks installed")
end)

-- =============================================
-- SORU AIM
-- =============================================
local SoruRemote = nil
local SoruCooldown = 0

task.spawn(function()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            SoruRemote = remotes:FindFirstChild("CommF_")
        end
        if not SoruRemote then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj.Name == "CommF_" then
                    SoruRemote = obj
                    break
                end
            end
        end
        print("[Ivory] Soru remote:", SoruRemote and "yes" or "no")
    end)
end)

local function DoSoruTeleport()
    if not Features.SoruAim then return end
    if tick() < SoruCooldown then return end
    
    local target = GetNearestEnemy()
    if not target then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    pcall(function()
        if SoruRemote then
            SoruRemote:InvokeServer("Flashstep", target.Position)
        else
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
        end
        SoruCooldown = tick() + 1.0
    end)
end

local function MonitorFlashstep(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    hum.AnimationPlayed:Connect(function(track)
        if not Features.SoruAim then return end
        if tick() < SoruCooldown then return end
        
        local animName = string.lower(track.Name or "")
        local animId = tostring(track.Animation and track.Animation.AnimationId or "")
        
        if string.find(animName, "flashstep") or string.find(animName, "soru") or
           string.find(animName, "dash") or string.find(animId, "17555632156") or
           string.find(animId, "616006778") then
            DoSoruTeleport()
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    MonitorFlashstep(char)
end)

if player.Character then
    task.wait(0.5)
    MonitorFlashstep(player.Character)
end

-- =============================================
-- ESP
-- =============================================
local ESPData = {}

local function CreateESP(target)
    if ESPData[target] then return end
    local char = target.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local gui = Instance.new("BillboardGui")
    gui.Name = "IvoryESP"
    gui.Adornee = head
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 2, 0)
    gui.AlwaysOnTop = true
    gui.Parent = head
    
    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, 0, 0, 16)
    nameL.BackgroundTransparency = 1
    nameL.Text = target.Name
    nameL.TextColor3 = COLORS.WHITE
    nameL.TextSize = 11
    nameL.Font = Enum.Font.GothamBold
    nameL.TextXAlignment = Enum.TextXAlignment.Center
    nameL.Parent = gui
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 0, 3)
    healthBg.Position = UDim2.new(0, 0, 1, -3)
    healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = gui
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = COLORS.GREEN
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    ESPData[target] = {gui = gui, name = nameL, healthFill = healthFill}
end

local function UpdateESP()
    if not Features.ESP then
        for _, d in pairs(ESPData) do
            pcall(function() d.gui.Visible = false end)
        end
        return
    end
    
    local current = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    if not ESPData[plr] then CreateESP(plr) end
                    current[plr] = true
                    local d = ESPData[plr]
                    if d then
                        d.gui.Visible = true
                        d.name.Text = plr.Name
                        local hp = hum.Health / hum.MaxHealth
                        d.healthFill.Size = UDim2.new(hp, 0, 1, 0)
                        if hp > 0.5 then d.healthFill.BackgroundColor3 = COLORS.GREEN
                        elseif hp > 0.25 then d.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                        else d.healthFill.BackgroundColor3 = COLORS.RED end
                    end
                end
            end
        end
    end
    
    for target, d in pairs(ESPData) do
        if not current[target] then
            pcall(function() d.gui:Destroy() end)
            ESPData[target] = nil
        end
    end
end

RunService.Heartbeat:Connect(function() pcall(UpdateESP) end)

-- =============================================
-- MACRO
-- =============================================
local MacroBlocks = {}
local MacroRunning = false

local function PressKey(key)
    if key == "M1" then
        VIM:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, true)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, false)
    else
        local kc = Enum.KeyCode[key]
        if kc then
            VIM:SendKeyEvent(true, kc, false)
            task.wait(0.05)
            VIM:SendKeyEvent(false, kc, false)
        end
    end
end

local function ExecuteMacro()
    if not Features.Macro or #MacroBlocks == 0 or MacroRunning then return end
    MacroRunning = true
    task.spawn(function()
        for _, block in pairs(MacroBlocks) do
            if not Features.Macro then break end
            PressKey(block.Skill)
            if block.Hold > 0 then
                local kc = Enum.KeyCode[block.Skill]
                if kc then
                    VIM:SendKeyEvent(true, kc, false)
                    task.wait(block.Hold)
                    VIM:SendKeyEvent(false, kc, false)
                end
            end
            if block.Delay > 0 then task.wait(block.Delay) end
        end
        MacroRunning = false
    end)
end

-- =============================================
-- BUILD UI
-- =============================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(42,42)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -21)
ToggleBtn.BackgroundColor3 = COLORS.BLACK
ToggleBtn.BorderColor3 = COLORS.WHITE
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "I"
ToggleBtn.TextColor3 = COLORS.WHITE
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Gui
Corner(ToggleBtn, 10)

ToggleBtn.MouseEnter:Connect(function() TweenIt(ToggleBtn, {BackgroundColor3 = COLORS.WHITE, TextColor3 = COLORS.BLACK}) end)
ToggleBtn.MouseLeave:Connect(function() TweenIt(ToggleBtn, {BackgroundColor3 = COLORS.BLACK, TextColor3 = COLORS.WHITE}) end)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 350, 0, 380)
Main.Position = UDim2.new(0.5, -175, 0.5, -190)
Main.BackgroundColor3 = COLORS.BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui
Corner(Main, 12)
Stroke(Main)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 34)
Top.BackgroundColor3 = COLORS.DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 12)

local Title = Text(Top, "IVORY", 14, true)
Title.Position = UDim2.new(0, 12, 0, 1)
Title.Size = UDim2.new(0, 100, 0, 18)

local SubTitle = Text(Top, "HUB v6.3", 7, false)
SubTitle.TextColor3 = COLORS.GRAY
SubTitle.Position = UDim2.new(0, 13, 0, 20)
SubTitle.Size = UDim2.new(0, 60, 0, 12)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 26, 0, 26)
Close.Position = UDim2.new(1, -32, 0.5, -13)
Close.BackgroundColor3 = COLORS.DARKER
Close.Text = "×"
Close.TextColor3 = COLORS.WHITE
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Top
Corner(Close, 8)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 26, 0, 26)
Minimize.Position = UDim2.new(1, -62, 0.5, -13)
Minimize.BackgroundColor3 = COLORS.DARKER
Minimize.Text = "—"
Minimize.TextColor3 = COLORS.WHITE
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Minimize.Parent = Top
Corner(Minimize, 8)

local open = true
ToggleBtn.MouseButton1Click:Connect(function()
    open = not open
    Main.Visible = open
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 80, 1, -42)
Sidebar.Position = UDim2.new(0, 6, 0, 40)
Sidebar.BackgroundColor3 = COLORS.DARK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 10)
Stroke(Sidebar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Sidebar

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 6)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 4)
Pad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -96, 1, -42)
Content.Position = UDim2.new(0, 88, 0, 40)
Content.BackgroundColor3 = COLORS.DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 10)
Stroke(Content)

local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    Pages[name] = page
    return page
end

local function Section(parent, text)
    local lbl = Text(parent, text, 8, true)
    lbl.TextColor3 = COLORS.GRAY
    lbl.Size = UDim2.new(1, 0, 0, 14)
    return lbl
end

local function Button(parent, text, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = COLORS.DARKER
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = COLORS.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.Parent = parent
    Corner(btn, 8)
    Stroke(btn)
    btn.MouseButton1Click:Connect(cb)
    return btn
end

local function Toggle(parent, text, default, cb)
    local state = default or false
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 24)
    holder.BackgroundColor3 = COLORS.DARKER
    holder.BorderSizePixel = 0
    holder.Parent = parent
    Corner(holder, 8)
    Stroke(holder)

    local label = Text(holder, text .. ": OFF", 9, false)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Size = UDim2.new(1, -48, 1, 0)

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 24, 0, 12)
    sw.Position = UDim2.new(1, -32, 0.5, -6)
    sw.BackgroundColor3 = Color3.fromRGB(35,35,35)
    sw.Text = ""
    sw.BorderSizePixel = 0
    sw.Parent = holder
    Corner(sw, 20)

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 8, 0, 8)
    ball.Position = UDim2.new(0, 2, 0.5, -4)
    ball.BackgroundColor3 = COLORS.GRAY
    ball.BorderSizePixel = 0
    ball.Parent = sw
    Corner(ball, 20)

    local function Update()
        if state then
            TweenIt(sw, {BackgroundColor3 = COLORS.WHITE})
            TweenIt(ball, {Position = UDim2.new(1, -10, 0.5, -4), BackgroundColor3 = COLORS.BLACK})
            label.Text = text .. ": ON"
        else
            TweenIt(sw, {BackgroundColor3 = Color3.fromRGB(35,35,35)})
            TweenIt(ball, {Position = UDim2.new(0, 2, 0.5, -4), BackgroundColor3 = COLORS.GRAY})
            label.Text = text .. ": OFF"
        end
        if cb then cb(state) end
    end

    sw.MouseButton1Click:Connect(function()
        state = not state
        Update()
    end)
    Update()
    return holder
end

local function Slider(parent, text, default, minVal, maxVal, cb, suffix)
    local Value = default or 50
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 28)
    holder.BackgroundColor3 = COLORS.DARKER
    holder.BorderSizePixel = 0
    holder.Parent = parent
    Corner(holder, 8)
    Stroke(holder)

    local label = Text(holder, text .. ": " .. tostring(Value) .. (suffix or ""), 9, false)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Size = UDim2.new(1, -48, 1, 0)

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 100, 0, 3)
    bg.Position = UDim2.new(0, 8, .5, 4)
    bg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    bg.BorderSizePixel = 0
    bg.Parent = holder
    Corner(bg, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Value - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.WHITE
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Corner(fill, 2)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((Value - minVal) / (maxVal - minVal), -5, 0.5, -5)
    knob.BackgroundColor3 = COLORS.WHITE
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Corner(knob, 10)

    local dragging = false
    
    local function UpdateSlider(value)
        local clamped = math.clamp(value, minVal, maxVal)
        Value = clamped
        local ratio = (clamped - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -5, 0.5, -5)
        label.Text = text .. ": " .. tostring(math.floor(clamped)) .. (suffix or "")
        if cb then cb(clamped) end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function() dragging = false end)
    
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local ap = bg.AbsolutePosition
            local sz = bg.AbsoluteSize.X
            local rx = math.clamp(pos.X - ap.X, 0, sz)
            local ratio = rx / sz
            UpdateSlider(minVal + ratio * (maxVal - minVal))
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position
            local ap = bg.AbsolutePosition
            local sz = bg.AbsoluteSize.X
            local rx = math.clamp(pos.X - ap.X, 0, sz)
            local ratio = rx / sz
            UpdateSlider(minVal + ratio * (maxVal - minVal))
        end
    end)

    return holder
end

-- PAGES
local MainPage = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local MacroPage = CreatePage("Macro")
local VisualPage = CreatePage("Visuals")
local SettingsPage = CreatePage("Settings")

-- MAIN
Section(MainPage, "IVORY HUB")
local mt = Text(MainPage, "IVORY HUB", 16, true)
mt.Size = UDim2.new(1, 0, 0, 24)
mt.TextXAlignment = Enum.TextXAlignment.Center
mt.TextColor3 = COLORS.WHITE

local ms = Text(MainPage, "Blox Fruits PVP Script", 9, false)
ms.Size = UDim2.new(1, 0, 0, 16)
ms.Position = UDim2.new(0, 0, 0, 26)
ms.TextXAlignment = Enum.TextXAlignment.Center
ms.TextColor3 = COLORS.GRAY

-- COMBAT
Section(CombatPage, "SILENT AIM")
Toggle(CombatPage, "Enable Silent Aim", false, function(s)
    Features.SilentAim = s
end)

Section(CombatPage, "FOV SETTINGS")
Toggle(CombatPage, "Show FOV Circle", false, function(s)
    Features.FOVCircle = s
end)

Slider(CombatPage, "FOV Radius", 150, 10, 500, function(v)
    Features.FOVRadius = v
end)

Button(CombatPage, "FOV Mode: V1 (Center)", function()
    local btn = CombatPage:FindFirstChild("FOVModeButton")
    if Features.FOVMode == "V1" then
        Features.FOVMode = "V2"
        if btn then btn.Text = "FOV Mode: V2 (Mouse)" end
    else
        Features.FOVMode = "V1"
        if btn then btn.Text = "FOV Mode: V1 (Center)" end
    end
end)

Section(CombatPage, "SORU")
Toggle(CombatPage, "Enable Soru Aimbot", false, function(s)
    Features.SoruAim = s
    if SoruBtn then SoruBtn.Visible = s end
end)

-- MACRO
Section(MacroPage, "MACRO")
Toggle(MacroPage, "Enable Macro", false, function(s)
    Features.Macro = s
    if not s then
        MacroRunning = false
        if MacroBtn then MacroBtn.Visible = false end
    else
        if MacroBtn and #MacroBlocks > 0 then
            MacroBtn.Visible = true
        end
    end
end)

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -10, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.Parent = MacroPage

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.45, -5, 1, 0)
addBtn.Position = UDim2.new(0, 0, 0, 0)
addBtn.BackgroundColor3 = COLORS.DARKER
addBtn.Text = "+ Add"
addBtn.TextColor3 = COLORS.WHITE
addBtn.TextSize = 10
addBtn.Font = Enum.Font.GothamMedium
addBtn.BorderSizePixel = 0
addBtn.Parent = btnRow
Corner(addBtn, 8)
Stroke(addBtn)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.45, -5, 1, 0)
clearBtn.Position = UDim2.new(0.55, 5, 0, 0)
clearBtn.BackgroundColor3 = COLORS.DARKER
clearBtn.Text = "Clear"
clearBtn.TextColor3 = COLORS.WHITE
clearBtn.TextSize = 10
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.BorderSizePixel = 0
clearBtn.Parent = btnRow
Corner(clearBtn, 8)
Stroke(clearBtn)

local blockContainer = Instance.new("ScrollingFrame")
blockContainer.Size = UDim2.new(1, -10, 0, 180)
blockContainer.BackgroundTransparency = 1
blockContainer.BorderSizePixel = 0
blockContainer.ScrollBarThickness = 3
blockContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
blockContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
blockContainer.Parent = MacroPage

local blockLayout = Instance.new("UIListLayout")
blockLayout.Padding = UDim.new(0, 4)
blockLayout.SortOrder = Enum.SortOrder.LayoutOrder
blockLayout.Parent = blockContainer

local SKILLS = {"Z", "X", "C", "V", "F", "Tap", "M1"}

local function AddBlock()
    local idx = #MacroBlocks + 1
    local block = Instance.new("Frame")
    block.Size = UDim2.new(1, 0, 0, 34)
    block.BackgroundColor3 = COLORS.DARKER
    block.BorderSizePixel = 0
    block.Parent = blockContainer
    Corner(block, 8)
    Stroke(block)
    
    local num = Text(block, "#" .. idx, 9, true)
    num.Position = UDim2.new(0, 8, 0, 2)
    num.Size = UDim2.new(0, 30, 0, 14)
    num.TextColor3 = COLORS.BLUE
    
    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 50, 0, 20)
    skillBtn.Position = UDim2.new(0, 40, 0, 2)
    skillBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    skillBtn.Text = "Z"
    skillBtn.TextColor3 = COLORS.WHITE
    skillBtn.TextSize = 10
    skillBtn.Font = Enum.Font.GothamMedium
    skillBtn.BorderSizePixel = 0
    skillBtn.Parent = block
    Corner(skillBtn, 6)
    Stroke(skillBtn)
    
    local skillIdx = 1
    skillBtn.MouseButton1Click:Connect(function()
        skillIdx = skillIdx % #SKILLS + 1
        skillBtn.Text = SKILLS[skillIdx]
    end)
    
    local hLabel = Text(block, "Hold:0s", 8, false)
    hLabel.Position = UDim2.new(0, 95, 0, 2)
    hLabel.Size = UDim2.new(0, 50, 0, 14)
    hLabel.TextColor3 = COLORS.GRAY
    
    local hSlider = Instance.new("Frame")
    hSlider.Size = UDim2.new(0, 50, 0, 3)
    hSlider.Position = UDim2.new(0, 95, 0, 17)
    hSlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
    hSlider.BorderSizePixel = 0
    hSlider.Parent = block
    Corner(hSlider, 2)
    
    local hFill = Instance.new("Frame")
    hFill.Size = UDim2.new(0,0,1,0)
    hFill.BackgroundColor3 = COLORS.WHITE
    hFill.BorderSizePixel = 0
    hFill.Parent = hSlider
    Corner(hFill, 2)
    
    local hKnob = Instance.new("TextButton")
    hKnob.Size = UDim2.new(0,8,0,8)
    hKnob.Position = UDim2.new(0,-4,0.5,-4)
    hKnob.BackgroundColor3 = COLORS.WHITE
    hKnob.Text = ""
    hKnob.BorderSizePixel = 0
    hKnob.Parent = hSlider
    Corner(hKnob, 8)
    
    local dLabel = Text(block, "Delay:0s", 8, false)
    dLabel.Position = UDim2.new(0, 150, 0, 2)
    dLabel.Size = UDim2.new(0, 50, 0, 14)
    dLabel.TextColor3 = COLORS.GRAY
    
    local dSlider = Instance.new("Frame")
    dSlider.Size = UDim2.new(0, 50, 0, 3)
    dSlider.Position = UDim2.new(0, 150, 0, 17)
    dSlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
    dSlider.BorderSizePixel = 0
    dSlider.Parent = block
    Corner(dSlider, 2)
    
    local dFill = Instance.new("Frame")
    dFill.Size = UDim2.new(0,0,1,0)
    dFill.BackgroundColor3 = COLORS.WHITE
    dFill.BorderSizePixel = 0
    dFill.Parent = dSlider
    Corner(dFill, 2)
    
    local dKnob = Instance.new("TextButton")
    dKnob.Size = UDim2.new(0,8,0,8)
    dKnob.Position = UDim2.new(0,-4,0.5,-4)
    dKnob.BackgroundColor3 = COLORS.WHITE
    dKnob.Text = ""
    dKnob.BorderSizePixel = 0
    dKnob.Parent = dSlider
    Corner(dKnob, 8)
    
    local hVal = 0
    local dVal = 0
    
    local function UpdateHold(pos)
        local ap = hSlider.AbsolutePosition
        local sz = hSlider.AbsoluteSize.X
        local rx = math.clamp(pos.X - ap.X, 0, sz)
        local ratio = rx / sz
        hVal = math.floor(ratio * 3)
        hFill.Size = UDim2.new(ratio,0,1,0)
        hKnob.Position = UDim2.new(ratio,-4,0.5,-4)
        hLabel.Text = "Hold:" .. hVal .. "s"
    end
    
    local function UpdateDelay(pos)
        local ap = dSlider.AbsolutePosition
        local sz = dSlider.AbsoluteSize.X
        local rx = math.clamp(pos.X - ap.X, 0, sz)
        local ratio = rx / sz
        dVal = math.floor(ratio * 3)
        dFill.Size = UDim2.new(ratio,0,1,0)
        dKnob.Position = UDim2.new(ratio,-4,0.5,-4)
        dLabel.Text = "Delay:" .. dVal .. "s"
    end
    
    hSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateHold(input.Position)
        end
    end)
    
    hKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn
            conn = UserInputService.InputChanged:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then
                    UpdateHold(i2.Position)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end
            end)
        end
    end)
    
    dSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateDelay(input.Position)
        end
    end)
    
    dKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn
            conn = UserInputService.InputChanged:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then
                    UpdateDelay(i2.Position)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end
            end)
        end
    end)
    
    table.insert(MacroBlocks, {
        Skill = function() return SKILLS[skillIdx] end,
        Hold = function() return hVal end,
        Delay = function() return dVal end,
    })
    
    if Features.Macro and MacroBtn then
        MacroBtn.Visible = true
    end
end

addBtn.MouseButton1Click:Connect(AddBlock)
clearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(blockContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    MacroBlocks = {}
    if MacroBtn then MacroBtn.Visible = false end
end)

for i = 1, 3 do AddBlock() end

-- MACRO BUTTON
local MacroBtn = Instance.new("TextButton")
MacroBtn.Size = UDim2.fromOffset(60, 28)
MacroBtn.Position = UDim2.new(0.5, -30, 0.85, 0)
MacroBtn.BackgroundColor3 = COLORS.RED
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = COLORS.WHITE
MacroBtn.TextSize = 12
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Visible = false
MacroBtn.Parent = Gui
Corner(MacroBtn, 8)
Stroke(MacroBtn)

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

-- SORU BUTTON
local SoruBtn = Instance.new("TextButton")
SoruBtn.Size = UDim2.fromOffset(60, 60)
SoruBtn.Position = UDim2.new(0.85, -30, 0.7, -30)
SoruBtn.BackgroundColor3 = COLORS.BLACK
SoruBtn.BackgroundTransparency = 0.2
SoruBtn.Text = "SORU"
SoruBtn.TextColor3 = COLORS.WHITE
SoruBtn.TextSize = 14
SoruBtn.Font = Enum.Font.GothamBold
SoruBtn.BorderSizePixel = 0
SoruBtn.Visible = false
SoruBtn.Parent = Gui
Corner(SoruBtn, 30)
Stroke(SoruBtn)

local soruDrag = {dragging = false, startPos = nil, startMouse = nil}

SoruBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        soruDrag.dragging = true
        soruDrag.startMouse = input.Position
        soruDrag.startPos = SoruBtn.Position
    end
end)

SoruBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        soruDrag.dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if soruDrag.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - soruDrag.startMouse
        SoruBtn.Position = UDim2.new(
            soruDrag.startPos.X.Scale,
            soruDrag.startPos.X.Offset + delta.X,
            soruDrag.startPos.Y.Scale,
            soruDrag.startPos.Y.Offset + delta.Y
        )
    end
end)

SoruBtn.MouseButton1Click:Connect(function()
    DoSoruTeleport()
    SoruBtn.BackgroundColor3 = COLORS.GREEN
    SoruBtn.BackgroundTransparency = 0
    task.delay(0.3, function()
        SoruBtn.BackgroundColor3 = COLORS.BLACK
        SoruBtn.BackgroundTransparency = 0.2
    end)
end)

-- VISUALS
Section(VisualPage, "VISUALS")
Toggle(VisualPage, "Enable ESP", false, function(s)
    Features.ESP = s
end)

-- SETTINGS
Section(SettingsPage, "SETTINGS")

Button(SettingsPage, "Reset All", function()
    for k, v in pairs(Features) do
        if type(v) == "boolean" then Features[k] = false end
    end
    MacroRunning = false
    if SoruBtn then SoruBtn.Visible = false end
    if MacroBtn then MacroBtn.Visible = false end
end)

Button(SettingsPage, "Unload", function()
    Gui:Destroy()
end)

-- TABS
local Tabs = {
    {name="MAIN", page=MainPage},
    {name="COMBAT", page=CombatPage},
    {name="MACRO", page=MacroPage},
    {name="VISUAL", page=VisualPage},
    {name="SETTINGS", page=SettingsPage}
}
local CurrentTab

local function SelectTab(button, page)
    for _, data in ipairs(Tabs) do
        if data.button then TweenIt(data.button, {BackgroundColor3 = COLORS.DARKER}) end
        data.page.Visible = false
    end
    TweenIt(button, {BackgroundColor3 = COLORS.WHITE})
    button.TextColor3 = COLORS.BLACK
    page.Visible = true
    CurrentTab = page
end

for _, data in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundColor3 = COLORS.DARKER
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = COLORS.GRAY
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn, 8)
    Stroke(btn)
    data.button = btn
    btn.MouseButton1Click:Connect(function()
        SelectTab(btn, data.page)
    end)
end
SelectTab(Tabs[1].button, Tabs[1].page)

-- DRAGGING
local Dragging = false
local DragStart, StartPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, 
                                  StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
end)

local Minimized = false
Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Sidebar.Visible = false
        Content.Visible = false
        TweenIt(Main, {Size = UDim2.new(0, 350, 0, 34)})
        Minimize.Text = "+"
    else
        TweenIt(Main, {Size = UDim2.new(0, 350, 0, 380)})
        task.wait(.15)
        Sidebar.Visible = true
        Content.Visible = true
        Minimize.Text = "—"
    end
end)

Close.MouseButton1Click:Connect(function()
    TweenIt(Main, {Size = UDim2.new(0, 0, 0, 0)})
    task.wait(.3)
    Gui:Destroy()
end)

print("========================================")
print("        IVORY HUB v6.3 LOADED")
print("========================================")
print("✅ Silent Aim (with FOV)")
print("✅ Soru Auto Aim (Flashstep)")
print("✅ ESP")
print("✅ Macro System")
print("========================================")
