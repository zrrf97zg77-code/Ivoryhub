--// IVORY HUB (PVP EDITION v5.1)
--// Clean, minimal, with Flashstep Aimbot, Blacklist, Combo Editor, Unified Button Size
--// Credits: lvory999 (Developer), rayo06996 (Ideas)

print("Loading Ivory Hub PVP Edition v5.1...")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- VirtualInputManager (may be nil)
local VirtualInputManager
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local PlayerGui = player:WaitForChild("PlayerGui")

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
Main.Size = UDim2.fromOffset(520,330)
Main.Position = UDim2.new(.5,-260,.5,-165)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Parent = Gui
Main.Visible = true

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)
local MainStroke = Instance.new("UIStroke",Main)
MainStroke.Color = Color3.fromRGB(55,55,55)
MainStroke.Thickness = 1

-- GUI scale
local guiScale = 1
local buttonSize = 80 -- unified button size (width)

--// TOP
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,58)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner",Top).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,0,28)
Title.Position = UDim2.fromOffset(18,7)
Title.BackgroundTransparency = 1
Title.Text = "IVORY HUB"
Title.TextColor3 = WHITE
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1,-100,0,18)
Sub.Position = UDim2.fromOffset(19,32)
Sub.BackgroundTransparency = 1
Sub.Text = "pvp • clean • simple"
Sub.TextColor3 = GRAY
Sub.TextSize = 9
Sub.Font = Enum.Font.Gotham
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Top

--// CLOSE
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35,35)
Close.Position = UDim2.new(1,-45,0,11)
Close.BackgroundColor3 = LIGHT
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 22
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Top
Instance.new("UICorner",Close).CornerRadius = UDim.new(0,9)

--// SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0,135,1,-78)
Sidebar.Position = UDim2.fromOffset(10,68)
Sidebar.BackgroundColor3 = DARK
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = GRAY
Sidebar.CanvasSize = UDim2.new(0,0,0,0)
Sidebar.Parent = Main
Instance.new("UICorner",Sidebar).CornerRadius = UDim.new(0,11)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0,9)
SidePadding.PaddingBottom = UDim.new(0,9)
SidePadding.Parent = Sidebar

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize = UDim2.new(0,0,0,SideLayout.AbsoluteContentSize.Y + 18)
end)

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-155,1,-78)
Content.Position = UDim2.fromOffset(155,68)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner",Content).CornerRadius = UDim.new(0,11)

--// PAGES
local Pages = {}

local function CreatePage(Name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.new(1,-20,1,-20)
    Page.Position = UDim2.fromOffset(10,10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = GRAY
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
    end)

    Pages[Name] = Page
    return Page
end

--// CREATE BUTTON (always gray)
local function CreateButton(Parent,Text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,32)
    Button.BackgroundColor3 = LIGHT
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = WHITE
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Parent

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button,TweenInfo.new(.12),{BackgroundColor3 = Color3.fromRGB(45,45,45)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button,TweenInfo.new(.12),{BackgroundColor3 = LIGHT}):Play()
    end)

    return Button
end

--// CREATE TOGGLE
local function CreateToggle(Parent, Text, Default, OnClick)
    local state = Default or false
    local btn = CreateButton(Parent, Text .. (state and " ON" or " OFF"))
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = Text .. (state and " ON" or " OFF")
        if OnClick then OnClick(state) end
    end)
    return btn
end

--// PAGES
local Home = CreatePage("Home")
local MainPage = CreatePage("Main")
local AimbotPage = CreatePage("Aimbot")
local BlacklistPage = CreatePage("Blacklist")
local ComboPage = CreatePage("Combo")
local VisualsPage = CreatePage("Visuals")
local PlayersPage = CreatePage("Players")
local SettingsPage = CreatePage("Settings")
local InfoPage = CreatePage("Info")
local CreditsPage = CreatePage("Credits")

--// TAB CREATOR
local function CreateTab(Text,Page)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,-18,0,35)
    Button.BackgroundColor3 = LIGHT
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = GRAY
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

    Button.MouseButton1Click:Connect(function()
        for _,P in pairs(Pages) do P.Visible = false end
        Page.Visible = true
        for _,B in ipairs(Sidebar:GetChildren()) do
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

local HomeTab = CreateTab("Home",Home)
CreateTab("Main",MainPage)
CreateTab("Aimbot",AimbotPage)
CreateTab("Blacklist",BlacklistPage)
CreateTab("Combo",ComboPage)
CreateTab("Visuals",VisualsPage)
CreateTab("Players",PlayersPage)
CreateTab("Settings",SettingsPage)
CreateTab("Info",InfoPage)
CreateTab("Credits",CreditsPage)

Home.Visible = true
HomeTab.BackgroundColor3 = WHITE
HomeTab.TextColor3 = BLACK

--// TOGGLE BUTTON
local Toggle = Instance.new("TextButton")
Toggle.Name = "IvoryToggle"
Toggle.Size = UDim2.fromOffset(44,44)
Toggle.Position = UDim2.new(0,15,0.5,-22)
Toggle.BackgroundColor3 = BLACK
Toggle.BorderSizePixel = 0
Toggle.Text = "I"
Toggle.TextColor3 = WHITE
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Gui

Instance.new("UICorner",Toggle).CornerRadius = UDim.new(0,12)
local ToggleStroke = Instance.new("UIStroke",Toggle)
ToggleStroke.Color = WHITE
ToggleStroke.Thickness = 1

--// DRAG FUNCTION
local function MakeDraggableThreshold(Object, threshold)
    threshold = threshold or 10
    local Dragging = false
    local DragStart
    local StartPosition
    local isDraggingCandidate = false
    local startPos

    Object.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            isDraggingCandidate = true
            startPos = Input.Position
            StartPosition = Object.Position
            DragStart = Input.Position
        end
    end)

    Object.InputChanged:Connect(function(Input)
        if isDraggingCandidate and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local delta = (Input.Position - startPos).Magnitude
            if delta > threshold then
                Dragging = true
                isDraggingCandidate = false
                DragStart = Input.Position
                StartPosition = Object.Position
            end
        end

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

    Object.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            isDraggingCandidate = false
        end
    end)
end

--// SORU BUTTON (bottom-right)
local SoruButton = Instance.new("TextButton")
SoruButton.Name = "SoruAimbotButton"
SoruButton.Size = UDim2.fromOffset(buttonSize, buttonSize * 0.4)
SoruButton.Position = UDim2.new(0.85,-buttonSize/2,0.85,0)
SoruButton.BackgroundColor3 = BLACK
SoruButton.BorderSizePixel = 0
SoruButton.Text = "⚡ SORU"
SoruButton.TextColor3 = WHITE
SoruButton.TextSize = 12
SoruButton.Font = Enum.Font.GothamBold
SoruButton.AutoButtonColor = false
SoruButton.Visible = false
SoruButton.Parent = Gui
SoruButton.ZIndex = 20

Instance.new("UICorner",SoruButton).CornerRadius = UDim.new(0,8)
local SoruStroke = Instance.new("UIStroke",SoruButton)
SoruStroke.Color = WHITE
SoruStroke.Thickness = 1

MakeDraggableThreshold(SoruButton, 15)

--// MACRO BUTTON (bottom-left)
local MacroButton = Instance.new("TextButton")
MacroButton.Name = "MacroButton"
MacroButton.Size = UDim2.fromOffset(buttonSize, buttonSize * 0.4)
MacroButton.Position = UDim2.new(0.02,0,0.85,0)
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

Instance.new("UICorner",MacroButton).CornerRadius = UDim.new(0,8)
local MacroStroke = Instance.new("UIStroke",MacroButton)
MacroStroke.Color = WHITE
MacroStroke.Thickness = 1

MakeDraggableThreshold(MacroButton, 15)

--// OPEN/CLOSE
local Open = true

local function OpenGUI()
    Open = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(0,0)
    TweenService:Create(Main,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size = UDim2.fromOffset(520*guiScale,330*guiScale)}):Play()
end

local function CloseGUI()
    Open = false
    local Tween = TweenService:Create(Main,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size = UDim2.fromOffset(0,0)})
    Tween:Play()
    Tween.Completed:Connect(function()
        Main.Visible = false
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if Open then CloseGUI() else OpenGUI() end
end)

Close.MouseButton1Click:Connect(function()
    CloseGUI()
end)

-- ==================================================================
--              FEATURES
-- ==================================================================

--// Home Page
local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1,0,0,40)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "WELCOME TO IVORY HUB"
HomeTitle.TextColor3 = WHITE
HomeTitle.TextSize = 16
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.Parent = Home

local HomeSub = Instance.new("TextLabel")
HomeSub.Size = UDim2.new(1,0,0,30)
HomeSub.Position = UDim2.new(0,0,0,45)
HomeSub.BackgroundTransparency = 1
HomeSub.Text = "PVP • Clean • Simple"
HomeSub.TextColor3 = GRAY
HomeSub.TextSize = 11
HomeSub.Font = Enum.Font.Gotham
HomeSub.Parent = Home

--// Main Page
local noclipEnabled = false
local noclipLoop = nil
local noclipToggle = CreateToggle(MainPage, "NOCLIP", false, function(state)
    noclipEnabled = state
    if state then
        if not noclipLoop then
            noclipLoop = RunService.Heartbeat:Connect(function()
                if not noclipEnabled then
                    if noclipLoop then noclipLoop:Disconnect(); noclipLoop = nil end
                    return
                end
                pcall(function()
                    local char = player.Character
                    if char then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)
        end
    else
        if noclipLoop then noclipLoop:Disconnect(); noclipLoop = nil end
        pcall(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end)

local antiStun = false
local antiStunLoop = nil
local antiStunToggle = CreateToggle(MainPage, "ANTI-STUN", false, function(state)
    antiStun = state
    if state then
        if not antiStunLoop then
            antiStunLoop = RunService.Heartbeat:Connect(function()
                if not antiStun then
                    if antiStunLoop then antiStunLoop:Disconnect(); antiStunLoop = nil end
                    return
                end
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
            end)
        end
    else
        if antiStunLoop then antiStunLoop:Disconnect(); antiStunLoop = nil end
    end
end)

--// Aimbot Page
local function createAimbotUI()
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,0,30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "AIMBOT SETTINGS"
    titleLabel.TextColor3 = WHITE
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = AimbotPage

    local aimbotEnabled = false
    local currentTarget = nil
    local targetPlayers = true
    local targetNPCs = true
    local soruAimbot = false
    local excludeF = true
    local maxDistance = 3000
    local teamCheck = false
    local aimPart = "HumanoidRootPart"
    local flashstepDistance = 150
    local toggles = {}

    local aimbotToggle = CreateToggle(AimbotPage, "AIMBOT", false, function(state)
        aimbotEnabled = state
        updateTargetLabel()
    end)
    toggles.aimbot = aimbotToggle

    local teamCheckToggle = CreateToggle(AimbotPage, "TEAM CHECK", false, function(state)
        teamCheck = state
    end)
    toggles.teamCheck = teamCheckToggle

    local aimPartBtn = CreateButton(AimbotPage, "AIM PART: " .. aimPart)
    aimPartBtn.MouseButton1Click:Connect(function()
        local parts = {"HumanoidRootPart", "Head", "Torso", "UpperTorso"}
        local idx = table.find(parts, aimPart) or 1
        idx = idx % #parts + 1
        aimPart = parts[idx]
        aimPartBtn.Text = "AIM PART: " .. aimPart
    end)

    local targetPlayersToggle = CreateToggle(AimbotPage, "TARGET PLAYERS", true, function(state)
        targetPlayers = state
    end)
    toggles.targetPlayers = targetPlayersToggle

    local targetNPCsToggle = CreateToggle(AimbotPage, "TARGET NPCS", true, function(state)
        targetNPCs = state
    end)
    toggles.targetNPCs = targetNPCsToggle

    local soruToggle = CreateToggle(AimbotPage, "SORU FLASHSTEP", false, function(state)
        soruAimbot = state
        SoruButton.Visible = state
    end)
    toggles.soru = soruToggle

    local excludeFToggle = CreateToggle(AimbotPage, "F SKILL (EXCLUDED)", true, function(state)
        excludeF = state
    end)
    toggles.excludeF = excludeFToggle

    -- Flashstep Distance slider
    local distFrame = Instance.new("Frame")
    distFrame.Size = UDim2.new(1,0,0,30)
    distFrame.BackgroundTransparency = 1
    distFrame.Parent = AimbotPage

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.5,0,1,0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "Flash Dist: " .. flashstepDistance
    distLabel.TextColor3 = WHITE
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = distFrame

    local distMinus = Instance.new("TextButton")
    distMinus.Size = UDim2.new(0,25,0,25)
    distMinus.Position = UDim2.new(0.7,0,0.5,-12.5)
    distMinus.BackgroundColor3 = LIGHT
    distMinus.Text = "-"
    distMinus.TextColor3 = WHITE
    distMinus.TextSize = 12
    distMinus.Font = Enum.Font.GothamBold
    distMinus.AutoButtonColor = false
    distMinus.Parent = distFrame
    Instance.new("UICorner",distMinus).CornerRadius = UDim.new(0,6)

    local distVal = Instance.new("TextLabel")
    distVal.Size = UDim2.new(0,30,0,25)
    distVal.Position = UDim2.new(0.8,0,0.5,-12.5)
    distVal.BackgroundTransparency = 1
    distVal.Text = tostring(flashstepDistance)
    distVal.TextColor3 = WHITE
    distVal.TextSize = 11
    distVal.Font = Enum.Font.GothamBold
    distVal.TextXAlignment = Enum.TextXAlignment.Center
    distVal.Parent = distFrame

    local distPlus = Instance.new("TextButton")
    distPlus.Size = UDim2.new(0,25,0,25)
    distPlus.Position = UDim2.new(0.9,0,0.5,-12.5)
    distPlus.BackgroundColor3 = LIGHT
    distPlus.Text = "+"
    distPlus.TextColor3 = WHITE
    distPlus.TextSize = 12
    distPlus.Font = Enum.Font.GothamBold
    distPlus.AutoButtonColor = false
    distPlus.Parent = distFrame
    Instance.new("UICorner",distPlus).CornerRadius = UDim.new(0,6)

    distMinus.MouseButton1Click:Connect(function()
        flashstepDistance = math.max(30, flashstepDistance - 10)
        distVal.Text = tostring(flashstepDistance)
        distLabel.Text = "Flash Dist: " .. flashstepDistance
    end)

    distPlus.MouseButton1Click:Connect(function()
        flashstepDistance = math.min(300, flashstepDistance + 10)
        distVal.Text = tostring(flashstepDistance)
        distLabel.Text = "Flash Dist: " .. flashstepDistance
    end)

    -- Aimbot max distance slider
    local maxDistFrame = Instance.new("Frame")
    maxDistFrame.Size = UDim2.new(1,0,0,30)
    maxDistFrame.BackgroundTransparency = 1
    maxDistFrame.Parent = AimbotPage

    local maxDistLabel = Instance.new("TextLabel")
    maxDistLabel.Size = UDim2.new(0.5,0,1,0)
    maxDistLabel.BackgroundTransparency = 1
    maxDistLabel.Text = "Aim Dist: " .. maxDistance
    maxDistLabel.TextColor3 = WHITE
    maxDistLabel.TextSize = 10
    maxDistLabel.Font = Enum.Font.Gotham
    maxDistLabel.TextXAlignment = Enum.TextXAlignment.Left
    maxDistLabel.Parent = maxDistFrame

    local maxDistMinus = Instance.new("TextButton")
    maxDistMinus.Size = UDim2.new(0,25,0,25)
    maxDistMinus.Position = UDim2.new(0.7,0,0.5,-12.5)
    maxDistMinus.BackgroundColor3 = LIGHT
    maxDistMinus.Text = "-"
    maxDistMinus.TextColor3 = WHITE
    maxDistMinus.TextSize = 12
    maxDistMinus.Font = Enum.Font.GothamBold
    maxDistMinus.AutoButtonColor = false
    maxDistMinus.Parent = maxDistFrame
    Instance.new("UICorner",maxDistMinus).CornerRadius = UDim.new(0,6)

    local maxDistVal = Instance.new("TextLabel")
    maxDistVal.Size = UDim2.new(0,30,0,25)
    maxDistVal.Position = UDim2.new(0.8,0,0.5,-12.5)
    maxDistVal.BackgroundTransparency = 1
    maxDistVal.Text = tostring(maxDistance)
    maxDistVal.TextColor3 = WHITE
    maxDistVal.TextSize = 11
    maxDistVal.Font = Enum.Font.GothamBold
    maxDistVal.TextXAlignment = Enum.TextXAlignment.Center
    maxDistVal.Parent = maxDistFrame

    local maxDistPlus = Instance.new("TextButton")
    maxDistPlus.Size = UDim2.new(0,25,0,25)
    maxDistPlus.Position = UDim2.new(0.9,0,0.5,-12.5)
    maxDistPlus.BackgroundColor3 = LIGHT
    maxDistPlus.Text = "+"
    maxDistPlus.TextColor3 = WHITE
    maxDistPlus.TextSize = 12
    maxDistPlus.Font = Enum.Font.GothamBold
    maxDistPlus.AutoButtonColor = false
    maxDistPlus.Parent = maxDistFrame
    Instance.new("UICorner",maxDistPlus).CornerRadius = UDim.new(0,6)

    maxDistMinus.MouseButton1Click:Connect(function()
        maxDistance = math.max(500, maxDistance - 100)
        maxDistVal.Text = tostring(maxDistance)
        maxDistLabel.Text = "Aim Dist: " .. maxDistance
    end)

    maxDistPlus.MouseButton1Click:Connect(function()
        maxDistance = math.min(5000, maxDistance + 100)
        maxDistVal.Text = tostring(maxDistance)
        maxDistLabel.Text = "Aim Dist: " .. maxDistance
    end)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1,0,0,20)
    statusLabel.Position = UDim2.new(0,0,1,-20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Target: None"
    statusLabel.TextColor3 = GRAY
    statusLabel.TextSize = 9
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = AimbotPage

    return {
        status = statusLabel,
        getTarget = function() return currentTarget end,
        setTarget = function(t) currentTarget = t end,
        getEnabled = function() return aimbotEnabled end,
        setEnabled = function(s) 
            aimbotEnabled = s
            for _, child in ipairs(AimbotPage:GetChildren()) do
                if child:IsA("TextButton") and string.sub(child.Text,1,6) == "AIMBOT" then
                    child.Text = s and "AIMBOT ON" or "AIMBOT OFF"
                    break
                end
            end
        end,
        getExcludeF = function() return excludeF end,
        getTargetPlayers = function() return targetPlayers end,
        getTargetNPCs = function() return targetNPCs end,
        getSoru = function() return soruAimbot end,
        getMaxDist = function() return maxDistance end,
        getTeamCheck = function() return teamCheck end,
        getAimPart = function() return aimPart end,
        getFlashDist = function() return flashstepDistance end,
        toggles = toggles,
        updateStatus = function()
            if aimbotEnabled and currentTarget then
                local name = "Unknown"
                local parent = currentTarget.Parent
                if parent then
                    local p = Players:GetPlayerFromCharacter(parent)
                    if p then name = p.Name else name = parent.Name end
                end
                statusLabel.Text = "Target: " .. name
                statusLabel.TextColor3 = Color3.fromRGB(0,255,100)
            else
                statusLabel.Text = "Target: None"
                statusLabel.TextColor3 = GRAY
            end
        end
    }
end

local aimbotUI = createAimbotUI()

function updateTargetLabel()
    aimbotUI.updateStatus()
end

--// Soru button action: perform flashstep towards target
SoruButton.MouseButton1Click:Connect(function()
    if aimbotUI and aimbotUI.getEnabled() then
        local target = aimbotUI.getTarget()
        if target then
            local targetIsNPC = false
            local parent = target.Parent
            if parent and not Players:GetPlayerFromCharacter(parent) then
                targetIsNPC = true
            end
            if targetIsNPC and not aimbotUI.getTargetNPCs() then
                return
            end
            local char = player.Character
            if not char then return
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return
            local myPos = hrp.Position
            local targetPos = target.Position
            local dir = (targetPos - myPos).Unit
            local flashDist = aimbotUI.getFlashDist() or 150
            local actualDist = math.min((targetPos - myPos).Magnitude, flashDist)
            local newPos = myPos + dir * actualDist
            -- Move the character
            hrp.CFrame = CFrame.new(newPos)
            -- Invoke Flashstep remote to trigger animation
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local commF = remotes:FindFirstChild("CommF_")
                if commF then
                    pcall(function() commF:InvokeServer("Flashstep", newPos) end)
                end
            end
        end
    end
end)

--// Aimbot core logic
local function isIn180FOV(pos)
    if not pos or not camera then return false end
    local look = camera.CFrame.LookVector
    local char = player.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local dir = (pos - root.Position).Unit
    return look:Dot(dir) >= 0
end

local function getScreenCenterDist(pos)
    if not pos or not camera then return math.huge end
    local sp, on = camera:WorldToViewportPoint(pos)
    if not on then return math.huge end
    local center = camera.ViewportSize / 2
    return (Vector2.new(sp.X, sp.Y) - center).Magnitude
end

local function getClosestEnemy()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position

    local best, bestScore = nil, math.huge
    local targetPlayers = aimbotUI.getTargetPlayers()
    local targetNPCs = aimbotUI.getTargetNPCs()
    local maxDist = aimbotUI.getMaxDist()
    local teamCheck = aimbotUI.getTeamCheck()
    local aimPartName = aimbotUI.getAimPart()

    if targetPlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local part = p.Character:FindFirstChild(aimPartName) or p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and part then
                    if teamCheck then
                        if player.Team and p.Team and player.Team == p.Team then continue end
                    end
                    local pos = part.Position
                    local dist = (pos - myPos).Magnitude
                    if dist <= maxDist and isIn180FOV(pos) then
                        local score = getScreenCenterDist(pos) + dist * 0.001
                        if score < bestScore then
                            bestScore, best = score, part
                        end
                    end
                end
            end
        end
    end

    if targetNPCs then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in pairs(enemies:GetChildren()) do
                if npc:IsA("Model") then
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    local part = npc:FindFirstChild(aimPartName) or npc:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and part then
                        local pos = part.Position
                        local dist = (pos - myPos).Magnitude
                        if dist <= maxDist and isIn180FOV(pos) then
                            local score = getScreenCenterDist(pos) + dist * 0.001
                            if score < bestScore then
                                bestScore, best = score, part
                            end
                        end
                    end
                end
            end
        end
    end

    return best
end

RunService.Heartbeat:Connect(function()
    if aimbotUI.getEnabled() then
        local target = getClosestEnemy()
        aimbotUI.setTarget(target)
    else
        aimbotUI.setTarget(nil)
    end
    updateTargetLabel()
end)

--// Blacklist System
local blacklist = {
    Fruit = { Z = false, X = false, C = false, V = false, F = false },
    Sword = { Z = false, X = false, C = false, V = false, F = false },
    Gun = { Z = false, X = false, C = false, V = false, F = false },
    Melee = { Z = false, X = false, C = false, V = false, F = false },
}
local blacklistToggles = {}

local function buildBlacklistUI()
    local categories = {"Fruit", "Sword", "Gun", "Melee"}
    local keys = {"Z", "X", "C", "V", "F"}
    local yOffset = 30
    for _, cat in ipairs(categories) do
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1,0,0,20)
        header.Position = UDim2.new(0,0,0,yOffset)
        header.BackgroundTransparency = 1
        header.Text = cat:upper() .. " BLACKLIST"
        header.TextColor3 = WHITE
        header.TextSize = 11
        header.Font = Enum.Font.GothamBold
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = BlacklistPage
        yOffset = yOffset + 24
        for _, key in ipairs(keys) do
            local btn = CreateToggle(BlacklistPage, cat .. " " .. key, false, function(state)
                blacklist[cat][key] = state
            end)
            btn.Position = UDim2.new(0,0,0,yOffset)
            btn.Size = UDim2.new(0.9,0,0,24)
            yOffset = yOffset + 28
            blacklistToggles[cat .. key] = btn
        end
        yOffset = yOffset + 10
    end
end
buildBlacklistUI()

local function getCurrentCategory()
    local char = player.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return "Melee" end
    local tName = string.lower(tool.Name)
    local tt = ""
    pcall(function() tt = string.lower(tool.ToolTip or tool:GetAttribute("Type") or "") end)
    if string.find(tName, "fruit") or string.find(tt, "fruit") or string.find(tt, "bloxfruit") or tool:FindFirstChild("Fruit") then
        return "Fruit"
    elseif string.find(tName, "blade") or string.find(tName, "sword") or string.find(tName, "katana") or string.find(tt, "sword") then
        return "Sword"
    elseif string.find(tName, "gun") or string.find(tName, "rifle") or string.find(tName, "flintlock") or string.find(tt, "gun") then
        return "Gun"
    else
        return "Melee"
    end
end

-- Override remotes with blacklist support
local function overrideRemote(remote)
    if remote:IsA("RemoteEvent") then
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            if aimbotUI.getEnabled() then
                local target = aimbotUI.getTarget()
                if target then
                    local args = {...}
                    local skillKey = nil
                    for _, arg in ipairs(args) do
                        if typeof(arg) == "string" then
                            local upper = string.upper(arg)
                            if upper == "Z" or upper == "X" or upper == "C" or upper == "V" or upper == "F" then
                                skillKey = upper
                                break
                            end
                        end
                    end
                    local excludeF = aimbotUI.getExcludeF()
                    if excludeF and skillKey == "F" then
                        return oldFire(self, ...)
                    end
                    if skillKey then
                        local category = getCurrentCategory()
                        if blacklist[category] and blacklist[category][skillKey] then
                            return oldFire(self, ...)
                        end
                    end
                    local targetPos = target.Position
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = targetPos
                        elseif typeof(arg) == "CFrame" then
                            args[i] = CFrame.new(targetPos)
                        end
                    end
                    local name = self.Name
                    if name == "RE/RegisterHit" or name == "RegisterHit" then
                        local targetChar = target.Parent
                        if targetChar then
                            args[1] = target
                            args[2] = { { targetChar, target } }
                        end
                    elseif name == "RE/RegisterAttack" or name == "RegisterAttack" then
                        local targetChar = target.Parent
                        if targetChar then
                            args[2] = { { targetChar, target } }
                        end
                    elseif name == "RE/ShootGunEvent" or name == "ShootGunEvent" then
                        args[1] = targetPos
                        if target.Parent then
                            args[2] = { target.Parent }
                        end
                    end
                    return oldFire(self, unpack(args))
                end
            end
            return oldFire(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            if aimbotUI.getEnabled() then
                local target = aimbotUI.getTarget()
                if target then
                    local args = {...}
                    local skillKey = nil
                    for _, arg in ipairs(args) do
                        if typeof(arg) == "string" then
                            local upper = string.upper(arg)
                            if upper == "Z" or upper == "X" or upper == "C" or upper == "V" or upper == "F" then
                                skillKey = upper
                                break
                            end
                        end
                    end
                    local excludeF = aimbotUI.getExcludeF()
                    if excludeF and skillKey == "F" then
                        return oldInvoke(self, ...)
                    end
                    if skillKey then
                        local category = getCurrentCategory()
                        if blacklist[category] and blacklist[category][skillKey] then
                            return oldInvoke(self, ...)
                        end
                    end
                    local targetPos = target.Position
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = targetPos
                        elseif typeof(arg) == "CFrame" then
                            args[i] = CFrame.new(targetPos)
                        end
                    end
                    return oldInvoke(self, unpack(args))
                end
            end
            return oldInvoke(self, ...)
        end
    end
end

task.spawn(function()
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            overrideRemote(remote)
        end
    end
    ReplicatedStorage.DescendantAdded:Connect(overrideRemote)
end)

local oldNamecall
local mt2 = getrawmetatable(game)
if mt2 then
    oldNamecall = mt2.__namecall
    setreadonly(mt2, false)
    mt2.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            if aimbotUI.getEnabled() then
                local target = aimbotUI.getTarget()
                if target then
                    local args = {...}
                    local skillKey = nil
                    for _, arg in ipairs(args) do
                        if typeof(arg) == "string" then
                            local upper = string.upper(arg)
                            if upper == "Z" or upper == "X" or upper == "C" or upper == "V" or upper == "F" then
                                skillKey = upper
                                break
                            end
                        end
                    end
                    local excludeF = aimbotUI.getExcludeF()
                    if excludeF and skillKey == "F" then
                        return oldNamecall(self, ...)
                    end
                    if skillKey then
                        local category = getCurrentCategory()
                        if blacklist[category] and blacklist[category][skillKey] then
                            return oldNamecall(self, ...)
                        end
                    end
                    local targetPos = target.Position
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = targetPos
                        elseif typeof(arg) == "CFrame" then
                            args[i] = CFrame.new(targetPos)
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt2, true)
end

-- Mouse hooks for mouse.Hit/Target
local lastKey = nil
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        lastKey = "F"
    end
end)

if mouse then
    local mt = getrawmetatable(game)
    if mt then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and self == mouse and (key == "Hit" or key == "Target") then
                if aimbotUI.getEnabled() then
                    local target = aimbotUI.getTarget()
                    if target then
                        local excludeF = aimbotUI.getExcludeF()
                        if excludeF and lastKey == "F" then
                            return oldIndex(self, key)
                        end
                        if key == "Hit" then
                            return CFrame.new(target.Position)
                        elseif key == "Target" then
                            return target
                        end
                    end
                end
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        local newState = not aimbotUI.getEnabled()
        aimbotUI.setEnabled(newState)
        updateTargetLabel()
    end
end)

-- ==================================================================
--                  COMBO MACRO
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

MacroButton.MouseButton1Click:Connect(function()
    if comboEnabled then
        executeComboSteps()
    end
end)

local comboToggle = CreateToggle(ComboPage, "COMBO MACRO", false, function(state)
    comboEnabled = state
    MacroButton.Visible = state
end)

local stepCountLabel = Instance.new("TextLabel")
stepCountLabel.Size = UDim2.new(1,0,0,20)
stepCountLabel.Position = UDim2.new(0,0,0,0)
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
    container.Size = UDim2.new(1,0,0,0)
    container.BackgroundTransparency = 1
    container.Parent = ComboPage

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,4)
    layout.Parent = container

    for i, step in ipairs(comboSteps) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,0,0,28)
        row.BackgroundTransparency = 1
        row.Parent = container

        local num = Instance.new("TextLabel")
        num.Size = UDim2.new(0,25,1,0)
        num.BackgroundTransparency = 1
        num.Text = i .. "."
        num.TextColor3 = WHITE
        num.TextSize = 10
        num.Font = Enum.Font.GothamBold
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.Parent = row

        local slotBtn = Instance.new("TextButton")
        slotBtn.Size = UDim2.new(0,45,1,0)
        slotBtn.Position = UDim2.new(0,30,0,0)
        slotBtn.BackgroundColor3 = LIGHT
        slotBtn.BorderSizePixel = 0
        slotBtn.Text = "S" .. step.slot
        slotBtn.TextColor3 = WHITE
        slotBtn.TextSize = 10
        slotBtn.Font = Enum.Font.GothamMedium
        slotBtn.AutoButtonColor = false
        slotBtn.Parent = row
        Instance.new("UICorner",slotBtn).CornerRadius = UDim.new(0,4)
        slotBtn.MouseButton1Click:Connect(function()
            step.slot = step.slot % 4 + 1
            slotBtn.Text = "S" .. step.slot
        end)

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0,45,1,0)
        keyBtn.Position = UDim2.new(0,80,0,0)
        keyBtn.BackgroundColor3 = LIGHT
        keyBtn.BorderSizePixel = 0
        keyBtn.Text = step.key
        keyBtn.TextColor3 = WHITE
        keyBtn.TextSize = 10
        keyBtn.Font = Enum.Font.GothamMedium
        keyBtn.AutoButtonColor = false
        keyBtn.Parent = row
        Instance.new("UICorner",keyBtn).CornerRadius = UDim.new(0,4)
        local keys = {"Z","X","C","V","F","M1"}
        local keyIdx = table.find(keys, step.key) or 1
        keyBtn.MouseButton1Click:Connect(function()
            keyIdx = keyIdx % #keys + 1
            step.key = keys[keyIdx]
            keyBtn.Text = step.key
        end)

        local delayFrame = Instance.new("Frame")
        delayFrame.Size = UDim2.new(0,110,1,0)
        delayFrame.Position = UDim2.new(0,130,0,0)
        delayFrame.BackgroundTransparency = 1
        delayFrame.Parent = row

        local delayLabel = Instance.new("TextLabel")
        delayLabel.Size = UDim2.new(0.5,0,1,0)
        delayLabel.BackgroundTransparency = 1
        delayLabel.Text = string.format("%.2f", step.delay)
        delayLabel.TextColor3 = WHITE
        delayLabel.TextSize = 10
        delayLabel.Font = Enum.Font.GothamBold
        delayLabel.TextXAlignment = Enum.TextXAlignment.Right
        delayLabel.Parent = delayFrame

        local decBtn = Instance.new("TextButton")
        decBtn.Size = UDim2.new(0,20,1,0)
        decBtn.Position = UDim2.new(0.55,0,0,0)
        decBtn.BackgroundColor3 = LIGHT
        decBtn.BorderSizePixel = 0
        decBtn.Text = "-"
        decBtn.TextColor3 = WHITE
        decBtn.TextSize = 12
        decBtn.Font = Enum.Font.GothamBold
        decBtn.AutoButtonColor = false
        decBtn.Parent = delayFrame
        Instance.new("UICorner",decBtn).CornerRadius = UDim.new(0,4)
        decBtn.MouseButton1Click:Connect(function()
            step.delay = math.max(0.05, math.floor((step.delay - 0.05) * 100) / 100)
            delayLabel.Text = string.format("%.2f", step.delay)
        end)

        local incBtn = Instance.new("TextButton")
        incBtn.Size = UDim2.new(0,20,1,0)
        incBtn.Position = UDim2.new(0.8,0,0,0)
        incBtn.BackgroundColor3 = LIGHT
        incBtn.BorderSizePixel = 0
        incBtn.Text = "+"
        incBtn.TextColor3 = WHITE
        incBtn.TextSize = 12
        incBtn.Font = Enum.Font.GothamBold
        incBtn.AutoButtonColor = false
        incBtn.Parent = delayFrame
        Instance.new("UICorner",incBtn).CornerRadius = UDim.new(0,4)
        incBtn.MouseButton1Click:Connect(function()
            step.delay = math.min(2.0, math.floor((step.delay + 0.05) * 100) / 100)
            delayLabel.Text = string.format("%.2f", step.delay)
        end)

        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0,20,1,0)
        removeBtn.Position = UDim2.new(1,-22,0,0)
        removeBtn.BackgroundColor3 = LIGHT
        removeBtn.BorderSizePixel = 0
        removeBtn.Text = "✕"
        removeBtn.TextColor3 = Color3.fromRGB(255,80,80)
        removeBtn.TextSize = 12
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.AutoButtonColor = false
        removeBtn.Parent = row
        Instance.new("UICorner",removeBtn).CornerRadius = UDim.new(0,4)
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(comboSteps, i)
            rebuildStepUI()
            stepCountLabel.Text = "Steps: " .. #comboSteps
        end)
    end

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(1,0,0,28)
    addBtn.BackgroundColor3 = LIGHT
    addBtn.BorderSizePixel = 0
    addBtn.Text = "+ ADD STEP"
    addBtn.TextColor3 = WHITE
    addBtn.TextSize = 11
    addBtn.Font = Enum.Font.GothamMedium
    addBtn.AutoButtonColor = false
    addBtn.Parent = container
    Instance.new("UICorner",addBtn).CornerRadius = UDim.new(0,4)
    addBtn.MouseButton1Click:Connect(function()
        table.insert(comboSteps, {slot = 1, key = "Z", delay = 0.2})
        rebuildStepUI()
        stepCountLabel.Text = "Steps: " .. #comboSteps
    end)

    container.Size = UDim2.new(1,0,0,28 * #comboSteps + 32)
    stepCountLabel.Text = "Steps: " .. #comboSteps
end

rebuildStepUI()

--// ESP
local espEnabled = false
local espName = true
local espDist = true
local espHealth = false

local espMasterToggle = CreateToggle(VisualsPage, "ESP MASTER", false, function(state)
    espEnabled = state
    if not state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "IvoryESP" then
                v:Destroy()
            end
        end
    end
end)

local espNameToggle = CreateToggle(VisualsPage, "SHOW NAME", true, function(state)
    espName = state
end)

local espDistToggle = CreateToggle(VisualsPage, "SHOW DISTANCE", true, function(state)
    espDist = state
end)

local espHealthToggle = CreateToggle(VisualsPage, "SHOW HEALTH", false, function(state)
    espHealth = state
end)

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
                    bill.Size = UDim2.new(0,200,0,50)
                    bill.Adornee = head
                    bill.AlwaysOnTop = true
                    bill.Parent = head
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1,0,1,0)
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

--// Players Page
CreateButton(PlayersPage, "Player List (Coming Soon)")
CreateButton(PlayersPage, "Refresh Players")

--// Settings Page
local themeBlack = true
local infoText, creditsText

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
        if SoruButton then
            SoruButton.BackgroundColor3 = BLACK
            SoruButton.TextColor3 = WHITE
            SoruStroke.Color = WHITE
        end
        if MacroButton then
            MacroButton.BackgroundColor3 = BLACK
            MacroButton.TextColor3 = WHITE
            MacroStroke.Color = WHITE
        end
        if infoText then infoText.TextColor3 = WHITE end
        if creditsText then creditsText.TextColor3 = WHITE end
    else
        Main.BackgroundColor3 = WHITE
        Top.BackgroundColor3 = Color3.fromRGB(230,230,230)
        Content.BackgroundColor3 = Color3.fromRGB(230,230,230)
        Sidebar.BackgroundColor3 = Color3.fromRGB(230,230,230)
        Title.TextColor3 = BLACK
        Sub.TextColor3 = Color3.fromRGB(80,80,80)
        MainStroke.Color = Color3.fromRGB(200,200,200)
        Toggle.BackgroundColor3 = WHITE
        Toggle.TextColor3 = BLACK
        ToggleStroke.Color = BLACK
        Close.BackgroundColor3 = Color3.fromRGB(220,220,220)
        Close.TextColor3 = BLACK
        if SoruButton then
            SoruButton.BackgroundColor3 = WHITE
            SoruButton.TextColor3 = BLACK
            SoruStroke.Color = BLACK
        end
        if MacroButton then
            MacroButton.BackgroundColor3 = WHITE
            MacroButton.TextColor3 = BLACK
            MacroStroke.Color = BLACK
        end
        if infoText then infoText.TextColor3 = BLACK end
        if creditsText then creditsText.TextColor3 = BLACK end
    end
    for _, obj in ipairs(Sidebar:GetChildren()) do
        if obj:IsA("TextButton") then
            if obj.BackgroundColor3 == WHITE then
                obj.BackgroundColor3 = dark and WHITE or BLACK
                obj.TextColor3 = dark and BLACK or WHITE
            else
                obj.BackgroundColor3 = dark and LIGHT or Color3.fromRGB(220,220,220)
                obj.TextColor3 = dark and WHITE or BLACK
            end
        end
    end
end

local themeToggle = CreateToggle(SettingsPage, "DARK THEME", true, function(state)
    applyTheme(state)
end)
applyTheme(true)

-- GUI Scale slider
local scaleFrame = Instance.new("Frame")
scaleFrame.Size = UDim2.new(1,0,0,30)
scaleFrame.BackgroundTransparency = 1
scaleFrame.Parent = SettingsPage

local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(0.5,0,1,0)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "GUI Size: " .. string.format("%.1f", guiScale)
scaleLabel.TextColor3 = WHITE
scaleLabel.TextSize = 10
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = scaleFrame

local scaleMinus = Instance.new("TextButton")
scaleMinus.Size = UDim2.new(0,25,0,25)
scaleMinus.Position = UDim2.new(0.7,0,0.5,-12.5)
scaleMinus.BackgroundColor3 = LIGHT
scaleMinus.Text = "-"
scaleMinus.TextColor3 = WHITE
scaleMinus.TextSize = 12
scaleMinus.Font = Enum.Font.GothamBold
scaleMinus.AutoButtonColor = false
scaleMinus.Parent = scaleFrame
Instance.new("UICorner",scaleMinus).CornerRadius = UDim.new(0,6)

local scaleVal = Instance.new("TextLabel")
scaleVal.Size = UDim2.new(0,30,0,25)
scaleVal.Position = UDim2.new(0.8,0,0.5,-12.5)
scaleVal.BackgroundTransparency = 1
scaleVal.Text = string.format("%.1f", guiScale)
scaleVal.TextColor3 = WHITE
scaleVal.TextSize = 11
scaleVal.Font = Enum.Font.GothamBold
scaleVal.TextXAlignment = Enum.TextXAlignment.Center
scaleVal.Parent = scaleFrame

local scalePlus = Instance.new("TextButton")
scalePlus.Size = UDim2.new(0,25,0,25)
scalePlus.Position = UDim2.new(0.9,0,0.5,-12.5)
scalePlus.BackgroundColor3 = LIGHT
scalePlus.Text = "+"
scalePlus.TextColor3 = WHITE
scalePlus.TextSize = 12
scalePlus.Font = Enum.Font.GothamBold
scalePlus.AutoButtonColor = false
scalePlus.Parent = scaleFrame
Instance.new("UICorner",scalePlus).CornerRadius = UDim.new(0,6)

scaleMinus.MouseButton1Click:Connect(function()
    guiScale = math.max(0.5, guiScale - 0.1)
    scaleVal.Text = string.format("%.1f", guiScale)
    scaleLabel.Text = "GUI Size: " .. string.format("%.1f", guiScale)
    Main.Size = UDim2.fromOffset(520 * guiScale, 330 * guiScale)
end)

scalePlus.MouseButton1Click:Connect(function()
    guiScale = math.min(1.5, guiScale + 0.1)
    scaleVal.Text = string.format("%.1f", guiScale)
    scaleLabel.Text = "GUI Size: " .. string.format("%.1f", guiScale)
    Main.Size = UDim2.fromOffset(520 * guiScale, 330 * guiScale)
end)

-- Unified Button Size slider
local btnSizeFrame = Instance.new("Frame")
btnSizeFrame.Size = UDim2.new(1,0,0,30)
btnSizeFrame.BackgroundTransparency = 1
btnSizeFrame.Parent = SettingsPage

local btnSizeLabel = Instance.new("TextLabel")
btnSizeLabel.Size = UDim2.new(0.5,0,1,0)
btnSizeLabel.BackgroundTransparency = 1
btnSizeLabel.Text = "Button Size: " .. buttonSize
btnSizeLabel.TextColor3 = WHITE
btnSizeLabel.TextSize = 10
btnSizeLabel.Font = Enum.Font.Gotham
btnSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
btnSizeLabel.Parent = btnSizeFrame

local btnSizeMinus = Instance.new("TextButton")
btnSizeMinus.Size = UDim2.new(0,25,0,25)
btnSizeMinus.Position = UDim2.new(0.7,0,0.5,-12.5)
btnSizeMinus.BackgroundColor3 = LIGHT
btnSizeMinus.Text = "-"
btnSizeMinus.TextColor3 = WHITE
btnSizeMinus.TextSize = 12
btnSizeMinus.Font = Enum.Font.GothamBold
btnSizeMinus.AutoButtonColor = false
btnSizeMinus.Parent = btnSizeFrame
Instance.new("UICorner",btnSizeMinus).CornerRadius = UDim.new(0,6)

local btnSizeVal = Instance.new("TextLabel")
btnSizeVal.Size = UDim2.new(0,30,0,25)
btnSizeVal.Position = UDim2.new(0.8,0,0.5,-12.5)
btnSizeVal.BackgroundTransparency = 1
btnSizeVal.Text = tostring(buttonSize)
btnSizeVal.TextColor3 = WHITE
btnSizeVal.TextSize = 11
btnSizeVal.Font = Enum.Font.GothamBold
btnSizeVal.TextXAlignment = Enum.TextXAlignment.Center
btnSizeVal.Parent = btnSizeFrame

local btnSizePlus = Instance.new("TextButton")
btnSizePlus.Size = UDim2.new(0,25,0,25)
btnSizePlus.Position = UDim2.new(0.9,0,0.5,-12.5)
btnSizePlus.BackgroundColor3 = LIGHT
btnSizePlus.Text = "+"
btnSizePlus.TextColor3 = WHITE
btnSizePlus.TextSize = 12
btnSizePlus.Font = Enum.Font.GothamBold
btnSizePlus.AutoButtonColor = false
btnSizePlus.Parent = btnSizeFrame
Instance.new("UICorner",btnSizePlus).CornerRadius = UDim.new(0,6)

local function updateButtonSizes(newSize)
    buttonSize = newSize
    SoruButton.Size = UDim2.fromOffset(buttonSize, buttonSize * 0.4)
    SoruButton.Position = UDim2.new(0.85, -buttonSize/2, 0.85, 0)
    MacroButton.Size = UDim2.fromOffset(buttonSize, buttonSize * 0.4)
    MacroButton.Position = UDim2.new(0.02, 0, 0.85, 0)
    btnSizeVal.Text = tostring(buttonSize)
    btnSizeLabel.Text = "Button Size: " .. buttonSize
end

btnSizeMinus.MouseButton1Click:Connect(function()
    local newSize = math.max(40, buttonSize - 5)
    updateButtonSizes(newSize)
end)

btnSizePlus.MouseButton1Click:Connect(function()
    local newSize = math.min(120, buttonSize + 5)
    updateButtonSizes(newSize)
end)

-- Helper to get all settings
local function getConfig()
    return {
        aimbotEnabled = aimbotUI.getEnabled(),
        teamCheck = aimbotUI.getTeamCheck(),
        aimPart = aimbotUI.getAimPart(),
        targetPlayers = aimbotUI.getTargetPlayers(),
        targetNPCs = aimbotUI.getTargetNPCs(),
        soruAimbot = aimbotUI.getSoru(),
        excludeF = aimbotUI.getExcludeF(),
        maxDistance = aimbotUI.getMaxDist(),
        flashDist = aimbotUI.getFlashDist(),
        noclip = noclipEnabled,
        antiStun = antiStun,
        espEnabled = espEnabled,
        espName = espName,
        espDist = espDist,
        espHealth = espHealth,
        themeBlack = themeBlack,
        guiScale = guiScale,
        buttonSize = buttonSize,
        comboSteps = comboSteps,
        comboEnabled = comboEnabled,
        blacklist = blacklist
    }
end

-- Save Config
local saveBtn = CreateButton(SettingsPage, "SAVE CONFIG")
saveBtn.MouseButton1Click:Connect(function()
    local config = getConfig()
    local success, err = pcall(function()
        if writefile then
            writefile("IvoryHub_Config.json", HttpService:JSONEncode(config))
        end
    end)
    if success then
        saveBtn.Text = "SAVED!"
        task.delay(1.5, function() saveBtn.Text = "SAVE CONFIG" end)
    end
end)

-- Load Config
local loadBtn = CreateButton(SettingsPage, "LOAD CONFIG")
loadBtn.MouseButton1Click:Connect(function()
    local success, data = pcall(function()
        if readfile and isfile and isfile("IvoryHub_Config.json") then
            return HttpService:JSONDecode(readfile("IvoryHub_Config.json"))
        end
        return nil
    end)
    if success and data then
        -- Load basic settings (can be expanded)
        loadBtn.Text = "LOADED!"
        task.delay(1.5, function() loadBtn.Text = "LOAD CONFIG" end)
    end
end)

-- Delete Config
local deleteBtn = CreateButton(SettingsPage, "DELETE CONFIG")
deleteBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        if isfile and isfile("IvoryHub_Config.json") then
            delfile("IvoryHub_Config.json")
        end
    end)
    if success then
        deleteBtn.Text = "DELETED!"
        task.delay(1.5, function() deleteBtn.Text = "DELETE CONFIG" end)
    end
end)

--// Info Page
infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1,0,0,140)
infoText.Position = UDim2.new(0,0,0,10)
infoText.BackgroundTransparency = 1
infoText.Text = "Ivory Hub PVP Edition v5.1\n\nCreated by: lvory999\n\nIdeas: rayo06996\n\nA clean, simple hub for Blox Fruits PVP.\n\nFeatures: Aimbot, Blacklist (per skill), Combo Macro, ESP, Flashstep Aimbot, Noclip, Anti-Stun."
infoText.TextColor3 = WHITE
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = InfoPage

--// Credits Page
creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1,0,0,120)
creditsText.Position = UDim2.new(0,0,0,10)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Ivory Hub PVP Edition v5.1\n\nDesign & Development: lvory999\n\nIdeas: rayo06996\n\nSpecial thanks to the community."
creditsText.TextColor3 = WHITE
creditsText.TextSize = 11
creditsText.Font = Enum.Font.Gotham
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Parent = CreditsPage

print("✅ Ivory Hub PVP Edition v5.1 loaded successfully!")
print("📌 Unified Button Size slider controls both Soru and Macro buttons.")
print("📌 Blacklist works for all weapon categories per skill key.")
print("📌 All features optimized for mobile.")
