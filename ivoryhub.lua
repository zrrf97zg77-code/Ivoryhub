  --// ============================================================
--// IVORY HUB – OBSIDIAN SILENT AIM + FOV
--// ============================================================
print("Ivory Hub: starting...")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

local Player = Players.LocalPlayer

--// Find a parent that works
local function getSafeParent()
    local ok, gui = pcall(gethui)
    if ok and gui and gui.Parent then return gui end
    local core = game:GetService("CoreGui")
    if core then return core end
    return Player:WaitForChild("PlayerGui")
end
local parentGui = getSafeParent()
print("Ivory Hub: parent =", parentGui.Name)

--// Remove previous version
local Old = parentGui:FindFirstChild("IvoryHub")
if Old then Old:Destroy() end

--// Create ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parentGui

--//===========================================================
--// COLORS & HELPERS
--//===========================================================
local BLACK = Color3.fromRGB(7,7,7)
local DARK = Color3.fromRGB(13,13,13)
local DARKER = Color3.fromRGB(19,19,19)
local WHITE = Color3.fromRGB(245,245,245)
local GRAY = Color3.fromRGB(145,145,145)
local BORDER = Color3.fromRGB(40,40,40)
local RED = Color3.fromRGB(255,50,50)
local GREEN = Color3.fromRGB(50,255,50)

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

--//===========================================================
--// FLOATING TOGGLE BUTTON
--//===========================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "IvoryToggle"
ToggleBtn.Size = UDim2.fromOffset(48,48)
ToggleBtn.Position = UDim2.new(0, 30, 0.5, -24)
ToggleBtn.BackgroundColor3 = BLACK
ToggleBtn.BorderColor3 = WHITE
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "I"
ToggleBtn.TextColor3 = WHITE
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,10)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), { BackgroundColor3 = WHITE, TextColor3 = BLACK }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), { BackgroundColor3 = BLACK, TextColor3 = WHITE }):Play()
end)

--//===========================================================
--// MAIN WINDOW
--//===========================================================
local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0,560,0,550) -- wider for more settings
Main.Position = UDim2.new(0.5,-280,0.5,-275)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui
Corner(Main,12)
AddStroke(Main)

-- Top bar
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

local Open = true
ToggleBtn.MouseButton1Click:Connect(function()
    Open = not Open
    Main.Visible = Open
end)

--//===========================================================
--// SIDEBAR & CONTENT
--//===========================================================
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

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-155,1,-70)
Content.Position = UDim2.new(0,145,0,65)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content,10)
AddStroke(Content)

local Pages = {}

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

local function Section(parent,text)
    local Label = Text(parent,text,10,true)
    Label.TextColor3 = GRAY
    Label.Size = UDim2.new(1,0,0,24)
    return Label
end

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
    Btn.MouseEnter:Connect(function() Tween(Btn,.15,{BackgroundColor3 = Color3.fromRGB(28,28,28)}) end)
    Btn.MouseLeave:Connect(function() Tween(Btn,.15,{BackgroundColor3 = DARKER}) end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function Toggle(parent, text, default, callback)
    local State = default or false
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,38)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder,8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": OFF", 12, false)
    Label.Position = UDim2.new(0,13,0,0)
    Label.Size = UDim2.new(1,-70,1,0)

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,36,0,20)
    Switch.Position = UDim2.new(1,-46,.5,-10)
    Switch.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Switch.Text = ""
    Switch.BorderSizePixel = 0
    Switch.Parent = Holder
    Corner(Switch,20)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,14,0,14)
    Circle.Position = UDim2.new(0,3,.5,-7)
    Circle.BackgroundColor3 = GRAY
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    Corner(Circle,20)

    local function Update()
        if State then
            Tween(Switch,.2,{BackgroundColor3 = WHITE})
            Tween(Circle,.2,{Position = UDim2.new(1,-17,.5,-7), BackgroundColor3 = BLACK})
            Label.Text = text .. ": ON"
        else
            Tween(Switch,.2,{BackgroundColor3 = Color3.fromRGB(35,35,35)})
            Tween(Circle,.2,{Position = UDim2.new(0,3,.5,-7), BackgroundColor3 = GRAY})
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

local function SliderToggle(parent, text, default, minVal, maxVal, defaultSpeed, callback)
    local State = default or false
    local Speed = defaultSpeed or 50
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,58)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder,8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": OFF", 12, false)
    Label.Position = UDim2.new(0,13,0,4)
    Label.Size = UDim2.new(0,100,1,0)

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,36,0,20)
    Switch.Position = UDim2.new(0,13,.5,-6)
    Switch.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Switch.Text = ""
    Switch.BorderSizePixel = 0
    Switch.Parent = Holder
    Corner(Switch,20)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,14,0,14)
    Circle.Position = UDim2.new(0,3,.5,-7)
    Circle.BackgroundColor3 = GRAY
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    Corner(Circle,20)

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(0,160,0,4)
    SliderBg.Position = UDim2.new(0,140,.5,8)
    SliderBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Holder
    Corner(SliderBg,2)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0.5,0,1,0)
    SliderFill.BackgroundColor3 = WHITE
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    Corner(SliderFill,2)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.Position = UDim2.new(0.5,-8,0.5,-8)
    Knob.BackgroundColor3 = WHITE
    Knob.Text = ""
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg
    Corner(Knob,20)

    local ValueLabel = Text(Holder, tostring(Speed), 12, false)
    ValueLabel.TextColor3 = GRAY
    ValueLabel.Position = UDim2.new(1,-50,0,0)
    ValueLabel.Size = UDim2.new(0,40,1,0)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local function UpdateToggle()
        if State then
            Tween(Switch,.2,{BackgroundColor3 = WHITE})
            Tween(Circle,.2,{Position = UDim2.new(1,-17,.5,-7), BackgroundColor3 = BLACK})
            Label.Text = text .. ": ON"
            SliderBg.Visible = true
            ValueLabel.Visible = true
        else
            Tween(Switch,.2,{BackgroundColor3 = Color3.fromRGB(35,35,35)})
            Tween(Circle,.2,{Position = UDim2.new(0,3,.5,-7), BackgroundColor3 = GRAY})
            Label.Text = text .. ": OFF"
            SliderBg.Visible = false
            ValueLabel.Visible = false
        end
        if callback then callback(State, Speed) end
    end

    local function UpdateSlider(value)
        local clamped = math.clamp(value, minVal, maxVal)
        Speed = clamped
        local ratio = (clamped - minVal) / (maxVal - minVal)
        SliderFill.Size = UDim2.new(ratio,0,1,0)
        Knob.Position = UDim2.new(ratio,-8,0.5,-8)
        ValueLabel.Text = tostring(math.floor(clamped))
        if State and callback then callback(State, Speed) end
    end

    local DraggingKnob = false
    local function StartDrag(input) DraggingKnob = true end
    local function EndDrag() DraggingKnob = false end
    local function UpdateDrag(input)
        if not DraggingKnob then return end
        local pos = input.Position
        local sliderAbsPos = SliderBg.AbsolutePosition
        local sliderSize = SliderBg.AbsoluteSize.X
        local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
        local ratio = relativeX / sliderSize
        local value = minVal + ratio * (maxVal - minVal)
        UpdateSlider(value)
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then StartDrag(input) end
    end)
    Knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then EndDrag() end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then UpdateDrag(input) end
    end)
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local sliderAbsPos = SliderBg.AbsolutePosition
            local sliderSize = SliderBg.AbsoluteSize.X
            local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
            local ratio = relativeX / sliderSize
            local value = minVal + ratio * (maxVal - minVal)
            UpdateSlider(value)
        end
    end)

    Switch.MouseButton1Click:Connect(function()
        State = not State
        UpdateToggle()
    end)

    UpdateSlider(Speed)
    UpdateToggle()
    return {
        Holder = Holder,
        GetState = function() return State end,
        GetSpeed = function() return Speed end,
        SetSpeed = function(v) UpdateSlider(v) end,
        Toggle = function() State = not State; UpdateToggle() end
    }
end

local function Slider(parent, text, default, minVal, maxVal, callback, suffix)
    local Value = default or 50
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,42)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder,8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": " .. tostring(Value) .. (suffix or ""), 11, false)
    Label.Position = UDim2.new(0,13,0,0)
    Label.Size = UDim2.new(1,-50,1,0)

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(0,140,0,4)
    SliderBg.Position = UDim2.new(0,13,.5,6)
    SliderBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Holder
    Corner(SliderBg,2)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Value - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = WHITE
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    Corner(SliderFill,2)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.Position = UDim2.new((Value - minVal) / (maxVal - minVal), -8, 0.5, -8)
    Knob.BackgroundColor3 = WHITE
    Knob.Text = ""
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg
    Corner(Knob,20)

    local function UpdateSlider(value)
        local clamped = math.clamp(value, minVal, maxVal)
        Value = clamped
        local ratio = (clamped - minVal) / (maxVal - minVal)
        SliderFill.Size = UDim2.new(ratio,0,1,0)
        Knob.Position = UDim2.new(ratio,-8,0.5,-8)
        Label.Text = text .. ": " .. tostring(math.floor(clamped)) .. (suffix or "")
        if callback then callback(clamped) end
    end

    local DraggingKnob = false
    local function StartDrag(input) DraggingKnob = true end
    local function EndDrag() DraggingKnob = false end
    local function UpdateDrag(input)
        if not DraggingKnob then return end
        local pos = input.Position
        local sliderAbsPos = SliderBg.AbsolutePosition
        local sliderSize = SliderBg.AbsoluteSize.X
        local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
        local ratio = relativeX / sliderSize
        local value = minVal + ratio * (maxVal - minVal)
        UpdateSlider(value)
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then StartDrag(input) end
    end)
    Knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then EndDrag() end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then UpdateDrag(input) end
    end)
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local sliderAbsPos = SliderBg.AbsolutePosition
            local sliderSize = SliderBg.AbsoluteSize.X
            local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
            local ratio = relativeX / sliderSize
            local value = minVal + ratio * (maxVal - minVal)
            UpdateSlider(value)
        end
    end)

    UpdateSlider(Value)
    return {
        Holder = Holder,
        GetValue = function() return Value end,
        SetValue = function(v) UpdateSlider(v) end
    }
end

local function Dropdown(parent, text, options, default, callback)
    local State = default or options[1]
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,38)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder,8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": " .. State, 11, false)
    Label.Position = UDim2.new(0,13,0,0)
    Label.Size = UDim2.new(1,-50,1,0)

    local function UpdateDisplay()
        Label.Text = text .. ": " .. State
        if callback then callback(State) end
    end

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0,30,0,22)
    Btn.Position = UDim2.new(1,-40,.5,-11)
    Btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Btn.Text = "▼"
    Btn.TextColor3 = WHITE
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Btn.Parent = Holder
    Corner(Btn,6)

    Btn.MouseButton1Click:Connect(function()
        local currentIndex = table.find(options, State) or 1
        local nextIndex = (currentIndex % #options) + 1
        State = options[nextIndex]
        UpdateDisplay()
    end)

    UpdateDisplay()
    return {
        Holder = Holder,
        GetValue = function() return State end,
        SetValue = function(v) State = v; UpdateDisplay() end
    }
end

--//===========================================================
--// PAGES
--//===========================================================
local MainPage   = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visuals")
local SettingsPage = CreatePage("Settings")
local CreditsPage = CreatePage("Credits")

--//===========================================================
--// OBSIDIAN SILENT AIM MODULE (copied & adapted)
--//===========================================================
local SilentAimModule = (function()
    local module = {}
    local player = Player
    local camera = Camera
    local UIS = UIS
    local RS = game:GetService("ReplicatedStorage")

    -- State
    local SilentAimPlayersEnabled = false
    local SilentAimNPCsEnabled = false
    local PredictionEnabled = true
    local PredictionAmount = 0.12
    local ZSkillorM1 = true
    local ShowFOVCircle = false
    local FOVRadius = 150
    local FOVMode = "V1"  -- V1 = screen center, V2 = mouse
    local AimMode = "360"
    local TargetPriority = "Nearest"
    local maxRange = 1000
    local Selectedplayer = nil
    local PlayersPosition = nil
    local NPCPosition = nil
    local currentTool = nil
    local currentToolCategory = "Melee"
    local currentSkillKey = nil
    local lastSkillTime = 0
    local SKILL_KEYS = {"Z","X","C","V","F","TAP"}
    local BlacklistedKeys = {
        Melee = { Z=false, X=false, C=false },
        Sword = { Z=false, X=false },
        Fruit = { Z=false, X=false, C=false, V=false, F=false, TAP=false },
        Gun   = { Z=false, X=false }
    }

    -- FOV circle UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FOV_System_Ivory"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = Gui  -- Use our main GUI
    local FOVFrame = Instance.new("Frame")
    FOVFrame.Name = "FOVCircle"
    FOVFrame.AnchorPoint = Vector2.new(0.5,0.5)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.Visible = false
    FOVFrame.Parent = ScreenGui
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255,0,0)
    UIStroke.Thickness = 2
    UIStroke.Parent = FOVFrame
    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(1,0)
    FOVCorner.Parent = FOVFrame

    -- Helper: get FOV center
    local function getFOVCenter(mode)
        if mode == "V2" then return UIS:GetMouseLocation() end
        return camera.ViewportSize / 2
    end

    -- Helper: check if target is in FOV
    local function isTargetValid(hrp, lpHRP, aimMode, fovRadius, fovType)
        if not hrp or not lpHRP then return false end
        if aimMode == "180" then
            local dir = (hrp.Position - lpHRP.Position).Unit
            if lpHRP.CFrame.LookVector:Dot(dir) < 0 then return false end
        elseif aimMode == "FOV" then
            local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if not onScreen then return false end
            local center = getFOVCenter(fovType)
            if (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude > fovRadius then return false end
        end
        return true
    end

    -- Target acquisition
    local function getClosestplayer(lpHRP)
        if not lpHRP then return nil end
        if TargetPriority == "Lock Player" and Selectedplayer then
            local char = Selectedplayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char.HumanoidRootPart
                if hum and hum.Health > 0 and hrp and isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode) then
                    return Selectedplayer
                end
            end
            return nil
        end
        local valid = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and pl.Character and pl.Character.Parent then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp and isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode) then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= maxRange then
                        table.insert(valid, {Player=pl, Humanoid=hum, HRP=hrp, Distance=dist})
                    end
                end
            end
        end
        if #valid == 0 then return nil end
        if AimMode == "360" or AimMode == "180" then
            if TargetPriority == "Nearest" then table.sort(valid, function(a,b) return a.Distance < b.Distance end)
            elseif TargetPriority == "Low HP" then table.sort(valid, function(a,b) return a.Humanoid.Health < b.Humanoid.Health end)
            elseif TargetPriority == "Looking At Me" then
                table.sort(valid, function(a,b)
                    local dirA = (lpHRP.Position - a.HRP.Position).Unit
                    local lookA = a.HRP.CFrame.LookVector
                    local dirB = (lpHRP.Position - b.HRP.Position).Unit
                    local lookB = b.HRP.CFrame.LookVector
                    return lookA:Dot(dirA) > lookB:Dot(dirB)
                end)
            end
        else -- FOV
            local center = getFOVCenter(FOVMode)
            table.sort(valid, function(a,b)
                local pA = camera:WorldToViewportPoint(a.HRP.Position)
                local pB = camera:WorldToViewportPoint(b.HRP.Position)
                return (Vector2.new(pA.X, pA.Y) - center).Magnitude < (Vector2.new(pB.X, pB.Y) - center).Magnitude
            end)
        end
        return valid[1].Player
    end

    local function getClosestNPC(lpHRP)
        if not lpHRP then return nil end
        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if not enemiesFolder then return nil end
        local closest, closestDist = nil, math.huge
        for _, npc in ipairs(enemiesFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp and isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode) then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= maxRange and dist < closestDist then
                        closestDist = dist
                        closest = npc
                    end
                end
            end
        end
        return closest
    end

    -- Prediction
    local lastVelocity = nil
    local lastDirection = nil
    local function predicted(hrp)
        if not hrp then return nil end
        local hum = hrp.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return hrp.Position end
        if not PredictionEnabled then return hrp.Position end
        local vel = hrp.Velocity
        local speed = vel.Magnitude
        if speed < 5 then
            lastVelocity = nil; lastDirection = nil
            return hrp.Position
        end
        local currentDirection = vel.Unit
        if lastDirection then
            local dot = lastDirection:Dot(currentDirection)
            if dot < 0.7 then
                lastVelocity = nil; lastDirection = nil
                return hrp.Position
            end
        end
        lastDirection = currentDirection
        lastVelocity = vel
        local ping = 0
        pcall(function()
            local PingService = game:GetService("Stats").Network.ServerStatsItem
            ping = PingService:GetValue() / 1000
        end)
        ping = math.clamp(ping, 0, 0.35)
        local predictionFactor = PredictionAmount + ping
        if speed > 100 then predictionFactor = math.min(predictionFactor, 0.15) end
        return hrp.Position + (vel * predictionFactor)
    end

    -- Tool category
    local function getToolCategory(tool)
        if not tool then return "Melee" end
        local name = string.lower(tool.Name)
        local gunNames = {"guitar","rifle","cannon","gun","slingshot","kabucha","serpent bow","bow"}
        for _,g in ipairs(gunNames) do if string.find(name,g) then return "Gun" end end
        local meleeNames = {"claw","godhuman","superhuman","talon","step","karate","breath","kung fu","combat","fist","sanguine"}
        for _,m in ipairs(meleeNames) do if string.find(name,m) then return "Melee" end end
        if string.find(name,"fruit") or string.find(name,"-") then return "Fruit" end
        return "Sword"
    end

    local function isKeyCurrentlyBlacklisted(key)
        if not key then return false end
        local cat = currentToolCategory
        if BlacklistedKeys[cat] and BlacklistedKeys[cat][key] ~= nil then return BlacklistedKeys[cat][key] end
        return false
    end

    -- Set current skill key
    local function setCurrentSkillKey(key)
        currentSkillKey = key
        lastSkillTime = os.clock()
        -- face target if possible
        if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
            local targetPos = PlayersPosition or NPCPosition
            if targetPos then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local look = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Unit
                    if look.Magnitude > 0.001 then
                        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + look)
                    end
                end
            end
        end
        task.spawn(function()
            local myTime = lastSkillTime
            task.wait(1.5)
            if lastSkillTime == myTime and currentSkillKey == key then
                currentSkillKey = nil
            end
        end)
    end

    -- Hook input for skill keys
    local function hookMobileButton(btn)
        if btn:GetAttribute("Hooked") then return end
        btn:SetAttribute("Hooked", true)
        local key = btn.Name
        if table.find(SKILL_KEYS, key) then
            btn.Activated:Connect(function() setCurrentSkillKey(key) end)
        end
    end

    -- Main render loop for acquiring targets
    local renderConnection, heartbeatConnection = nil, nil
    local function startRenderLoop()
        if renderConnection then return end
        renderConnection = RunService.RenderStepped:Connect(function()
            -- Update FOV circle visibility
            if ShowFOVCircle then
                local center = getFOVCenter(FOVMode)
                FOVFrame.Position = UDim2.new(0, center.X, 0, center.Y)
                FOVFrame.Size = UDim2.new(0, FOVRadius*2, 0, FOVRadius*2)
                FOVFrame.Visible = true
            else
                FOVFrame.Visible = false
            end
            -- Get targets
            local lpChar = player.Character
            if not lpChar then return end
            local lpHRP = lpChar:FindFirstChild("HumanoidRootPart")
            if not lpHRP then return end
            if not SilentAimPlayersEnabled and not SilentAimNPCsEnabled then
                PlayersPosition = nil; NPCPosition = nil
                return
            end
            if SilentAimPlayersEnabled then
                local targetPlayer = getClosestplayer(lpHRP)
                if targetPlayer and targetPlayer.Character then
                    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then PlayersPosition = predicted(hrp) else PlayersPosition = nil end
                else PlayersPosition = nil end
            end
            if SilentAimNPCsEnabled then
                local npc = getClosestNPC(lpHRP)
                if npc then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then NPCPosition = predicted(hrp) else NPCPosition = nil end
                else NPCPosition = nil end
            end
        end)
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not ZSkillorM1 or (not SilentAimPlayersEnabled and not SilentAimNPCsEnabled) then return end
                if currentSkillKey and isKeyCurrentlyBlacklisted(currentSkillKey) then return end
                if currentTool and (string.find(string.lower(currentTool.Name),"portal") or string.find(string.lower(currentTool.Name),"lightning")) then return end
                local targetPos = PlayersPosition or NPCPosition
                if targetPos then
                    -- Redirect mouse Hit/Target for skills (this is done by metatable hooks)
                end
            end)
        end
    end

    local function stopRenderLoop()
        if renderConnection then renderConnection:Disconnect(); renderConnection = nil end
        if heartbeatConnection then heartbeatConnection:Disconnect(); heartbeatConnection = nil end
        FOVFrame.Visible = false
        PlayersPosition = nil; NPCPosition = nil
    end

    -- Metatable hooks for silent aim
    local function installHooks()
        -- Hook __index for mouse.Hit and mouse.Target
        local oldIndex, oldNamecall = nil, nil
        if hookmetamethod then
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                if not checkcaller() and self == camera and (key == "Hit" or key == "Target") then
                    if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
                        local targetPos = PlayersPosition or NPCPosition
                        if targetPos then
                            if key == "Hit" then return CFrame.new(targetPos) end
                            if key == "Target" then return nil end
                        end
                    end
                end
                return oldIndex(self, key)
            end)

            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                local methodStr = method and tostring(method):lower() or ""
                if not checkcaller() and (methodStr == "fireserver" or methodStr == "invokeserver") then
                    if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
                        local targetPos = PlayersPosition or NPCPosition
                        if targetPos then
                            -- Replace Vector3/CFrame arguments
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "Vector3" then args[i] = targetPos
                                elseif typeof(arg) == "CFrame" then args[i] = CFrame.new(targetPos) end
                            end
                            -- Handle RegisterHit
                            if self.Name == "RE/RegisterHit" or self.Name == "RegisterHit" then
                                local targetPart = (PlayersPosition and PlayersPosition ~= NPCPosition) and targetPos or nil
                                if targetPart then
                                    local targetChar = targetPart.Parent
                                    if targetChar then
                                        local head = targetChar:FindFirstChild("Head") or targetPart
                                        args[1] = head
                                        args[2] = { { targetChar, head } }
                                    end
                                end
                            end
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        else
            local mt = getrawmetatable(game)
            if mt then
                oldIndex = mt.__index
                oldNamecall = mt.__namecall
                if setreadonly then pcall(setreadonly, mt, false) end
                mt.__index = function(self, key)
                    if not checkcaller() and self == camera and (key == "Hit" or key == "Target") then
                        if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
                            local targetPos = PlayersPosition or NPCPosition
                            if targetPos then
                                if key == "Hit" then return CFrame.new(targetPos) end
                                if key == "Target" then return nil end
                            end
                        end
                    end
                    return oldIndex(self, key)
                end
                mt.__namecall = function(self, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    local methodStr = method and tostring(method):lower() or ""
                    if not checkcaller() and (methodStr == "fireserver" or methodStr == "invokeserver") then
                        if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
                            local targetPos = PlayersPosition or NPCPosition
                            if targetPos then
                                for i, arg in ipairs(args) do
                                    if typeof(arg) == "Vector3" then args[i] = targetPos
                                    elseif typeof(arg) == "CFrame" then args[i] = CFrame.new(targetPos) end
                                end
                                if self.Name == "RE/RegisterHit" or self.Name == "RegisterHit" then
                                    local targetPart = targetPos
                                    if targetPart then
                                        local targetChar = targetPart.Parent
                                        if targetChar then
                                            local head = targetChar:FindFirstChild("Head") or targetPart
                                            args[1] = head
                                            args[2] = { { targetChar, head } }
                                        end
                                    end
                                end
                                return oldNamecall(self, unpack(args))
                            end
                        end
                    end
                    return oldNamecall(self, ...)
                end
                if setreadonly then pcall(setreadonly, mt, true) end
            end
        end
    end
    installHooks()

    -- Track tool changes
    local function onCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.AnimationPlayed:Connect(function(track)
                -- could detect skill usage if needed
            end)
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                currentTool = child
                currentToolCategory = getToolCategory(child)
                currentSkillKey = nil
                child.AncestryChanged:Connect(function(_, parent)
                    if not parent then currentTool = nil end
                end)
            end
        end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                currentTool = child
                currentToolCategory = getToolCategory(child)
                currentSkillKey = nil
                child.AncestryChanged:Connect(function(_, parent)
                    if not parent then currentTool = nil end
                end)
            end
        end)
        char.ChildRemoved:Connect(function(child)
            if child == currentTool then currentTool = nil end
        end)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end

    -- Hook mobile skill buttons
    spawn(function()
        local pg = player:FindFirstChild("PlayerGui")
        if pg then
            local main = pg:FindFirstChild("Main")
            if main then
                local skills = main:FindFirstChild("Skills")
                if skills then
                    for _, wf in ipairs(skills:GetChildren()) do
                        if wf:IsA("GuiObject") then
                            for _, b in ipairs(wf:GetChildren()) do
                                if b:IsA("ImageButton") or b:IsA("TextButton") then
                                    hookMobileButton(b)
                                end
                            end
                        end
                    end
                    skills.ChildAdded:Connect(function(wf)
                        if wf:IsA("GuiObject") then
                            for _, b in ipairs(wf:GetChildren()) do
                                if b:IsA("ImageButton") or b:IsA("TextButton") then
                                    hookMobileButton(b)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)

    -- Keyboard input for skills
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        local keyMap = { [Enum.KeyCode.Z]="Z", [Enum.KeyCode.X]="X", [Enum.KeyCode.C]="C", [Enum.KeyCode.V]="V", [Enum.KeyCode.F]="F" }
        local key = keyMap[input.KeyCode]
        if key then setCurrentSkillKey(key) end
    end)

    -- Public API
    function module:SetPlayerSilentAim(state)
        SilentAimPlayersEnabled = state
        if state then startRenderLoop() else if not SilentAimNPCsEnabled then stopRenderLoop() end end
    end
    function module:SetNPCSilentAim(state)
        SilentAimNPCsEnabled = state
        if state then startRenderLoop() else if not SilentAimPlayersEnabled then stopRenderLoop() end end
    end
    function module:SetAimMode(mode) AimMode = mode end
    function module:SetTargetPriority(prio) TargetPriority = prio end
    function module:SetShowFOVCircle(state) ShowFOVCircle = state; if not state then FOVFrame.Visible = false end end
    function module:SetFOVRadius(radius) FOVRadius = radius end
    function module:SetFOVMode(mode) FOVMode = mode end  -- "V1" or "V2"
    function module:SetDistanceLimit(dist) maxRange = dist end
    function module:SetSelectedPlayer(name)
        if name and name ~= "None" then
            Selectedplayer = Players:FindFirstChild(name)
        else Selectedplayer = nil end
    end
    function module:SetBlacklistKey(cat, key, state)
        if BlacklistedKeys[cat] and BlacklistedKeys[cat][key] ~= nil then
            BlacklistedKeys[cat][key] = state
        end
    end
    function module:GetTargetPos() return PlayersPosition or NPCPosition end
    return module
end)()

--//===========================================================
--// EXTRA FEATURES (Soru, Walkspeed, Jump, Clip, AFK, ESP)
--//===========================================================

-- Soru Aimbot (auto-F)
local SoruEnabled = false
local SoruCooldown = 0
local function SoruUpdate()
    if not SoruEnabled or not VirtualInputManager then return end
    if tick() < SoruCooldown then return end
    local targetPos = SilentAimModule:GetTargetPos()
    if not targetPos then return end
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local dist = (targetPos - hrp.Position).Magnitude
        if dist > 25 then return end
        pcall(function()
            local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if commF then
                commF:InvokeServer("Flashstep", targetPos)
            else
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))
            end
        end)
        SoruCooldown = tick() + 1.5
    end
end

-- Walkspeed
local WalkspeedState = false
local WalkspeedValue = 50
local function WalkspeedUpdate()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if WalkspeedState then hum.WalkSpeed = WalkspeedValue else if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end end
end

-- Infinite Jump
local InfiniteJump = false
local function InfiniteJumpUpdate()
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = InfiniteJump and 50 or 50 end
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
    if input.KeyCode == Enum.KeyCode.Space then HandleJump() end
end)

-- No Clip
local NoClip = false
local function NoClipUpdate()
    local char = Player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = not NoClip end
    end
end

-- Anti-AFK
local AntiAFK = false
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

-- ESP
local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPHealth = false
local ESPDistance = false
local ESPObjects = {}
local function CreateESP()
    local ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ESPOverlay"
    ESPGui.IgnoreGuiInset = true
    ESPGui.Parent = Gui

    local function AddESPForTarget(rootPart, plr)
        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(0,0,0,0)
        container.Parent = ESPGui

        local box = Instance.new("Frame")
        box.BackgroundTransparency = 0.3
        box.BackgroundColor3 = WHITE
        box.BorderSizePixel = 1
        box.BorderColor3 = WHITE
        box.Visible = false
        box.Parent = container

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr and plr.Name or "NPC"
        nameLabel.TextColor3 = WHITE
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.Size = UDim2.new(0,120,0,18)
        nameLabel.Parent = container

        local healthBg = Instance.new("Frame")
        healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        healthBg.BorderSizePixel = 0
        healthBg.Size = UDim2.new(0,0,0,4)
        healthBg.Parent = container

        local healthFill = Instance.new("Frame")
        healthFill.BackgroundColor3 = GREEN
        healthFill.BorderSizePixel = 0
        healthFill.Size = UDim2.new(1,0,1,0)
        healthFill.Parent = healthBg

        local distLabel = Instance.new("TextLabel")
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = GRAY
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextXAlignment = Enum.TextXAlignment.Right
        distLabel.Size = UDim2.new(0,60,0,16)
        distLabel.Parent = container

        local key = plr or rootPart
        ESPObjects[key] = {
            container = container,
            box = box,
            name = nameLabel,
            healthBg = healthBg,
            healthFill = healthFill,
            dist = distLabel,
            root = rootPart,
            plr = plr
        }
    end

    local function UpdateESP()
        if not ESPEnabled then
            for _, data in pairs(ESPObjects) do data.container.Visible = false end
            return
        end
        local currentTargets = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local root = char.HumanoidRootPart
                    if not ESPObjects[plr] then AddESPForTarget(root, plr) end
                    currentTargets[plr] = true
                end
            end
        end
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= Player.Character then
                local hum = obj:FindFirstChild("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    if not ESPObjects[obj] then AddESPForTarget(root, nil) end
                    currentTargets[obj] = true
                end
            end
        end
        for key, data in pairs(ESPObjects) do
            if not currentTargets[key] then data.container:Destroy(); ESPObjects[key] = nil end
        end
        for key, data in pairs(ESPObjects) do
            local root = data.root
            local plr = data.plr
            local char = root.Parent
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                local head = char:FindFirstChild("Head") or root
                local headPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                local footPos, _ = Camera:WorldToScreenPoint(root.Position - Vector3.new(0, 2, 0))
                if onScreen then
                    data.container.Visible = true
                    local height = math.abs(headPos.Y - footPos.Y) * 0.9
                    local width = height * 0.5
                    local boxTop = headPos.Y - height
                    local boxLeft = headPos.X - width/2
                    data.container.Position = UDim2.new(0, boxLeft, 0, boxTop)
                    data.container.Size = UDim2.new(0, width, 0, height)

                    if ESPBox then
                        data.box.Visible = true
                        data.box.Size = UDim2.new(1,0,1,0)
                        data.box.Position = UDim2.new(0,0,0,0)
                    else data.box.Visible = false end

                    if ESPName then
                        data.name.Visible = true
                        data.name.Text = plr and plr.Name or "NPC"
                        data.name.Size = UDim2.new(0, width*1.2, 0, 18)
                        data.name.Position = UDim2.new(-0.1,0,-1.2,-2)
                        data.name.TextSize = 12
                    else data.name.Visible = false end

                    if ESPHealth then
                        data.healthBg.Visible = true
                        data.healthBg.Size = UDim2.new(1,0,0,4)
                        data.healthBg.Position = UDim2.new(0,0,1,4)
                        local hp = hum.Health / hum.MaxHealth
                        data.healthFill.Size = UDim2.new(hp,0,1,0)
                        if hp > 0.5 then data.healthFill.BackgroundColor3 = GREEN
                        elseif hp > 0.25 then data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                        else data.healthFill.BackgroundColor3 = RED end
                    else data.healthBg.Visible = false end

                    if ESPDistance then
                        data.dist.Visible = true
                        local d = (root.Position - Camera.CFrame.Position).Magnitude
                        data.dist.Text = math.floor(d) .. "m"
                        data.dist.Size = UDim2.new(0,60,0,16)
                        data.dist.Position = UDim2.new(1, -5, -1.2, -2)
                    else data.dist.Visible = false end
                else data.container.Visible = false end
            else data.container.Visible = false end
        end
    end
    return UpdateESP
end
local ESPUpdate = CreateESP()

--//===========================================================
--// MAIN LOOP
--//===========================================================
local RunningLoop = nil
local function StartLoop()
    if RunningLoop then return end
    RunningLoop = RunService.Heartbeat:Connect(function()
        SoruUpdate()
        WalkspeedUpdate()
        NoClipUpdate()
        AntiAFKUpdate()
        ESPUpdate()
        -- Infinite jump is handled by event
        InfiniteJumpUpdate()
    end)
end
local function StopLoop()
    if RunningLoop then RunningLoop:Disconnect(); RunningLoop = nil end
end
local function CheckLoop()
    if SoruEnabled or WalkspeedState or NoClip or AntiAFK or ESPEnabled or InfiniteJump then
        StartLoop()
    else
        StopLoop()
    end
end

--//===========================================================
--// BUILD UI PAGES
--//===========================================================
Section(MainPage, "MAIN")
Toggle(MainPage, "Welcome Feature", false, function(s) print("[IVORY] Welcome:", s) end)

Section(CombatPage, "SILENT AIM")
Toggle(CombatPage, "Player Silent Aim", false, function(s)
    SilentAimModule:SetPlayerSilentAim(s)
end)
Toggle(CombatPage, "NPC Silent Aim", false, function(s)
    SilentAimModule:SetNPCSilentAim(s)
end)

-- Aim Mode
Dropdown(CombatPage, "Aim Mode", {"360", "180", "FOV"}, "360", function(v)
    SilentAimModule:SetAimMode(v)
end)

-- Target Priority
local priorityDropdown = Dropdown(CombatPage, "Target Priority", {"Nearest", "Low HP", "Looking At Me", "Lock Player"}, "Nearest", function(v)
    SilentAimModule:SetTargetPriority(v)
    -- Show/hide player dropdown when Lock Player is selected
    local lockPlayerGroup = CombatPage:FindFirstChild("LockPlayerGroup")
    if lockPlayerGroup then
        lockPlayerGroup.Visible = (v == "Lock Player")
    end
end)

-- Lock Player dropdown (dynamic)
local lockPlayerGroup = Instance.new("Frame")
lockPlayerGroup.Name = "LockPlayerGroup"
lockPlayerGroup.Size = UDim2.new(1, -20, 0, 38)
lockPlayerGroup.BackgroundTransparency = 1
lockPlayerGroup.Visible = false
lockPlayerGroup.Parent = CombatPage

local playerList = {"None"}
local function refreshPlayerList()
    local list = {"None"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player then table.insert(list, p.Name) end
    end
    return list
end
local lockPlayerDropdown = Dropdown(lockPlayerGroup, "Lock Player", refreshPlayerList(), "None", function(v)
    SilentAimModule:SetSelectedPlayer(v)
end)
-- Update player list every few seconds
task.spawn(function()
    while true do
        task.wait(3)
        local newList = refreshPlayerList()
        lockPlayerDropdown:SetValues(newList)
    end
end)

-- FOV settings
Section(CombatPage, "FOV SETTINGS")
Toggle(CombatPage, "Show FOV Circle", false, function(s)
    SilentAimModule:SetShowFOVCircle(s)
end)
Slider(CombatPage, "FOV Radius", 150, 10, 500, function(v)
    SilentAimModule:SetFOVRadius(v)
end)
Dropdown(CombatPage, "FOV Mode", {"V1 (Screen Center)", "V2 (Mouse Position)"}, "V1 (Screen Center)", function(v)
    local mode = (v == "V1 (Screen Center)") and "V1" or "V2"
    SilentAimModule:SetFOVMode(mode)
end)

-- Range
Slider(CombatPage, "Max Range", 1000, 100, 3000, function(v)
    SilentAimModule:SetDistanceLimit(v)
end, "m")

-- Extras
Section(CombatPage, "EXTRAS")
Toggle(CombatPage, "Soru Aimbot (F)", false, function(s)
    SoruEnabled = s
    CheckLoop()
end)
SliderToggle(CombatPage, "Walkspeed", false, 16, 100, 50, function(s, v)
    WalkspeedState = s
    WalkspeedValue = v
    CheckLoop()
end)

-- Blacklists (separate page for cleanliness)
local BlacklistPage = CreatePage("Blacklist")
Pages.Blacklist = BlacklistPage
Section(BlacklistPage, "BLACKLIST KEYS")

local function addBlacklistGroup(cat, keys)
    Section(BlacklistPage, cat)
    for _, key in ipairs(keys) do
        Toggle(BlacklistPage, "Blacklist " .. cat .. " " .. key, false, function(s)
            SilentAimModule:SetBlacklistKey(cat, key, s)
        end)
    end
end
addBlacklistGroup("Melee", {"Z","X","C"})
addBlacklistGroup("Fruit", {"Z","X","C","V","F","TAP"})
addBlacklistGroup("Sword", {"Z","X"})
addBlacklistGroup("Gun", {"Z","X"})

-- Add Blacklist tab to sidebar
local function addTab(name, page)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(1,0,0,38)
    Tab.BackgroundColor3 = DARKER
    Tab.BorderSizePixel = 0
    Tab.Text = name
    Tab.TextColor3 = GRAY
    Tab.TextSize = 11
    Tab.Font = Enum.Font.GothamBold
    Tab.AutoButtonColor = false
    Tab.Parent = Sidebar
    Corner(Tab,8)
    AddStroke(Tab)
    Tab.MouseEnter:Connect(function()
        if CurrentTab ~= page then Tween(Tab,.15,{BackgroundColor3 = Color3.fromRGB(27,27,27)}) end
    end)
    Tab.MouseLeave:Connect(function()
        if CurrentTab ~= page then Tween(Tab,.15,{BackgroundColor3 = DARKER}) end
    end)
    Tab.MouseButton1Click:Connect(function()
        SelectTab(Tab, page)
    end)
    return Tab
end

-- Player page
Section(PlayerPage, "PLAYER EXTRAS")
Toggle(PlayerPage, "Infinite Jump", false, function(s)
    InfiniteJump = s
    CheckLoop()
end)
Toggle(PlayerPage, "No Clip", false, function(s)
    NoClip = s
    CheckLoop()
end)
Toggle(PlayerPage, "Anti-AFK", false, function(s)
    AntiAFK = s
    CheckLoop()
end)

-- Visuals page
Section(VisualPage, "VISUALS (ESP)")
Toggle(VisualPage, "Enable ESP", false, function(s)
    ESPEnabled = s
    CheckLoop()
end)
Toggle(VisualPage, "Show Box", false, function(s) ESPBox = s end)
Toggle(VisualPage, "Show Name", false, function(s) ESPName = s end)
Toggle(VisualPage, "Show Health", false, function(s) ESPHealth = s end)
Toggle(VisualPage, "Show Distance", false, function(s) ESPDistance = s end)

-- Settings page
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
    local M = Text(Notification,"Loaded! Tap 'I' to toggle.",11,false)
    M.TextColor3 = GRAY
    M.Position = UDim2.new(0,14,0,32)
    M.Size = UDim2.new(1,-20,0,18)
    Tween(Notification,.3,{Position = UDim2.new(1,-300,0,20)})
    task.delay(3,function()
        Tween(Notification,.3,{Position = UDim2.new(1,20,0,20)})
        task.wait(.3); Notification:Destroy()
    end)
end)
Button(SettingsPage, "Print GUI Info", function()
    print("================================")
    print("IVORY HUB - Obsidian Silent Aim")
    print("Features: Silent Aim (Players/NPC), FOV, Soru, Walkspeed, ESP")
    print("Creators: Ivory & Rayo")
    print("================================")
end)

-- Credits page
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

local Version = Text(CreditsPage,"Ivory Hub  •  Obsidian Aim",10,false)
Version.TextColor3 = GRAY
Version.Size = UDim2.new(1,0,0,25)

--//===========================================================
--// TABS
--//===========================================================
local Tabs = {
    {name="MAIN", page=MainPage},
    {name="COMBAT", page=CombatPage},
    {name="BLACKLIST", page=BlacklistPage},
    {name="PLAYER", page=PlayerPage},
    {name="VISUALS", page=VisualPage},
    {name="SETTINGS", page=SettingsPage},
    {name="CREDITS", page=CreditsPage}
}
local CurrentTab
local function SelectTab(button,page)
    for _, data in ipairs(Tabs) do
        local otherButton = data.button
        if otherButton then Tween(otherButton,.15,{BackgroundColor3 = DARKER}) end
        data.page.Visible = false
    end
    Tween(button,.15,{BackgroundColor3 = WHITE})
    button.TextColor3 = BLACK
    page.Visible = true
    CurrentTab = page
end
for _, data in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = DARKER
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = GRAY
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn,8)
    AddStroke(btn)
    data.button = btn
    btn.MouseEnter:Connect(function()
        if CurrentTab ~= data.page then Tween(btn,.15,{BackgroundColor3 = Color3.fromRGB(27,27,27)}) end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentTab ~= data.page then Tween(btn,.15,{BackgroundColor3 = DARKER}) end
    end)
    btn.MouseButton1Click:Connect(function()
        SelectTab(btn, data.page)
    end)
end
SelectTab(Tabs[2].button, Tabs[2].page)  -- Combat as default

--//===========================================================
--// DRAGGING, MINIMIZE, CLOSE
--//===========================================================
local Dragging = false; local DragStart, StartPosition
local function UpdateDrag(input)
    local Delta = input.Position - DragStart
    Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
end
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true; DragStart = input.Position; StartPosition = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateDrag(input) end
end)

local Minimized = false
Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Sidebar.Visible = false; Content.Visible = false
        Tween(Main,.25,{Size = UDim2.new(0,560,0,58)})
        Minimize.Text = "+"
    else
        Tween(Main,.25,{Size = UDim2.new(0,560,0,550)})
        task.wait(.15)
        Sidebar.Visible = true; Content.Visible = true
        Minimize.Text = "—"
    end
end)
Close.MouseButton1Click:Connect(function()
    Tween(Main,.25,{Size = UDim2.new(0,0,0,0)})
    task.wait(.3)
    Gui:Destroy()
end)

--//===========================================================
--// OPEN/CLOSE KEY (RightShift)
--//===========================================================
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end
end)

--//===========================================================
--// START
--//===========================================================
CheckLoop()
print("================================")
print("        IVORY HUB LOADED (Obsidian Aim)")
print("================================")
print("Features: Silent Aim (Players/NPC), FOV, Soru, Walkspeed, ESP")
print("Creators: Ivory & Rayo")
print("================================")
