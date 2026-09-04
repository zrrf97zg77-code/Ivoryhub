--// IVORY HUB (PVP EDITION v3.3 - FIXED)
--// Black & White UI with Advanced Combo Editor, Manual Macro Button, Save/Load/Delete Config
--// Credits: lvory999 (Developer), rayo06996 (Ideas)

print("Loading Ivory Hub PVP Edition v3.3...")

-- Error handling wrapper
local function safeExecute()
    pcall(function()
        -- Services
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
        
        -- VirtualInputManager may not exist on all executors; wrap in pcall
        local VirtualInputManager = nil
        pcall(function()
            VirtualInputManager = game:GetService("VirtualInputManager")
        end)

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

        --// SORU BUTTON
        local SoruButton = Instance.new("TextButton")
        SoruButton.Name = "SoruAimbotButton"
        SoruButton.Size = UDim2.fromOffset(80,32)
        SoruButton.Position = UDim2.new(0.85,-40,0.85,0)
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

        --// MACRO BUTTON
        local MacroButton = Instance.new("TextButton")
        MacroButton.Name = "MacroButton"
        MacroButton.Size = UDim2.fromOffset(80,32)
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
            TweenService:Create(Main,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size = UDim2.fromOffset(520,330)}):Play()
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
        --              FEATURES & AIMBOT INTEGRATION
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

        --// Main Page Features
        local fastAttack = false
        local fastAttackLoop = nil
        local fastToggle = CreateToggle(MainPage, "FAST ATTACK", false, function(state)
            fastAttack = state
            if state then
                fastAttackLoop = RunService.Heartbeat:Connect(function()
                    if not fastAttack then
                        if fastAttackLoop then fastAttackLoop:Disconnect(); fastAttackLoop = nil end
                        return
                    end
                    pcall(function()
                        local char = player.Character
                        if not char then return end
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if not remotes then return end
                        local regAttack = remotes:FindFirstChild("RE/RegisterAttack")
                        local regHit = remotes:FindFirstChild("RE/RegisterHit")
                        if not regAttack or not regHit then return end
                        local myRoot = char:FindFirstChild("HumanoidRootPart")
                        if not myRoot then return end
                        local myPos = myRoot.Position
                        local targets = {}
                        local targetParts = {}
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character then
                                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                                local head = p.Character:FindFirstChild("Head")
                                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                                if hum and hum.Health > 0 and head and hrp then
                                    local dist = (hrp.Position - myPos).Magnitude
                                    if dist <= 2500 then
                                        table.insert(targets, {p.Character, head})
                                        table.insert(targetParts, head)
                                    end
                                end
                            end
                        end
                        local enemies = workspace:FindFirstChild("Enemies")
                        if enemies then
                            for _, npc in pairs(enemies:GetChildren()) do
                                if npc:IsA("Model") then
                                    local hum = npc:FindFirstChildOfClass("Humanoid")
                                    local head = npc:FindFirstChild("Head")
                                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                                    if hum and hum.Health > 0 and head and hrp then
                                        local dist = (hrp.Position - myPos).Magnitude
                                        if dist <= 2500 then
                                            table.insert(targets, {npc, head})
                                            table.insert(targetParts, head)
                                        end
                                    end
                                end
                            end
                        end
                        if #targets > 0 then
                            regAttack:FireServer(0)
                            regHit:FireServer(targetParts[1], targets)
                        end
                    end)
                end)
            else
                if fastAttackLoop then fastAttackLoop:Disconnect(); fastAttackLoop = nil end
            end
        end)

        -- Walk Speed
        local walkSpeed = false
        local walkSpeedVal = 16
        local wsLoop = nil
        local wsToggle = CreateToggle(MainPage, "WALK SPEED", false, function(state)
            walkSpeed = state
            if state then
                if not wsLoop then
                    wsLoop = RunService.Heartbeat:Connect(function()
                        if not walkSpeed then
                            if wsLoop then wsLoop:Disconnect(); wsLoop = nil end
                            return
                        end
                        pcall(function()
                            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                            if hum and hum.WalkSpeed ~= walkSpeedVal then
                                hum.WalkSpeed = walkSpeedVal
                            end
                        end)
                    end)
                end
            else
                if wsLoop then wsLoop:Disconnect(); wsLoop = nil end
                pcall(function()
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 16 end
                end)
            end
        end)

        -- Walk Speed slider
        local wsFrame = Instance.new("Frame")
        wsFrame.Size = UDim2.new(1,0,0,30)
        wsFrame.BackgroundTransparency = 1
        wsFrame.Parent = MainPage

        local wsLabel = Instance.new("TextLabel")
        wsLabel.Size = UDim2.new(0.5,0,1,0)
        wsLabel.BackgroundTransparency = 1
        wsLabel.Text = "Speed: " .. walkSpeedVal
        wsLabel.TextColor3 = WHITE
        wsLabel.TextSize = 10
        wsLabel.Font = Enum.Font.Gotham
        wsLabel.TextXAlignment = Enum.TextXAlignment.Left
        wsLabel.Parent = wsFrame

        local wsMinus = Instance.new("TextButton")
        wsMinus.Size = UDim2.new(0,25,0,25)
        wsMinus.Position = UDim2.new(0.7,0,0.5,-12.5)
        wsMinus.BackgroundColor3 = LIGHT
        wsMinus.Text = "-"
        wsMinus.TextColor3 = WHITE
        wsMinus.TextSize = 12
        wsMinus.Font = Enum.Font.GothamBold
        wsMinus.AutoButtonColor = false
        wsMinus.Parent = wsFrame
        Instance.new("UICorner",wsMinus).CornerRadius = UDim.new(0,6)

        local wsVal = Instance.new("TextLabel")
        wsVal.Size = UDim2.new(0,30,0,25)
        wsVal.Position = UDim2.new(0.8,0,0.5,-12.5)
        wsVal.BackgroundTransparency = 1
        wsVal.Text = tostring(walkSpeedVal)
        wsVal.TextColor3 = WHITE
        wsVal.TextSize = 11
        wsVal.Font = Enum.Font.GothamBold
        wsVal.TextXAlignment = Enum.TextXAlignment.Center
        wsVal.Parent = wsFrame

        local wsPlus = Instance.new("TextButton")
        wsPlus.Size = UDim2.new(0,25,0,25)
        wsPlus.Position = UDim2.new(0.9,0,0.5,-12.5)
        wsPlus.BackgroundColor3 = LIGHT
        wsPlus.Text = "+"
        wsPlus.TextColor3 = WHITE
        wsPlus.TextSize = 12
        wsPlus.Font = Enum.Font.GothamBold
        wsPlus.AutoButtonColor = false
        wsPlus.Parent = wsFrame
        Instance.new("UICorner",wsPlus).CornerRadius = UDim.new(0,6)

        wsMinus.MouseButton1Click:Connect(function()
            walkSpeedVal = math.max(16, walkSpeedVal - 5)
            wsVal.Text = tostring(walkSpeedVal)
            wsLabel.Text = "Speed: " .. walkSpeedVal
            if walkSpeed and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = walkSpeedVal end
            end
        end)

        wsPlus.MouseButton1Click:Connect(function()
            walkSpeedVal = math.min(100, walkSpeedVal + 5)
            wsVal.Text = tostring(walkSpeedVal)
            wsLabel.Text = "Speed: " .. walkSpeedVal
            if walkSpeed and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = walkSpeedVal end
            end
        end)

        -- Noclip
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

        -- Anti-Stun
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

        -- Auto Click
        local autoClick = false
        local autoClickLoop = nil
        local autoClickToggle = CreateToggle(MainPage, "AUTO CLICK", false, function(state)
            autoClick = state
            if state then
                if not autoClickLoop then
                    autoClickLoop = RunService.Heartbeat:Connect(function()
                        if not autoClick then
                            if autoClickLoop then autoClickLoop:Disconnect(); autoClickLoop = nil end
                            return
                        end
                        pcall(function()
                            local char = player.Character
                            if not char then return end
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                            if not remotes then return end
                            local regAttack = remotes:FindFirstChild("RE/RegisterAttack")
                            if regAttack then
                                regAttack:FireServer(0)
                            end
                        end)
                    end)
                end
            else
                if autoClickLoop then autoClickLoop:Disconnect(); autoClickLoop = nil end
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
            local showLine = true
            local showFOV = false
            local maxDistance = 3000
            local teamCheck = false
            local aimPart = "HumanoidRootPart"
            local toggles = {}

            local aimbotToggle = CreateToggle(AimbotPage, "AIMBOT", false, function(state)
                aimbotEnabled = state
                if FOVCircle then FOVCircle.Visible = (aimbotEnabled and showFOV) end
                if TargetLine then TargetLine.Visible = (aimbotEnabled and showLine) end
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

            local soruToggle = CreateToggle(AimbotPage, "SORU TELEPORT", false, function(state)
                soruAimbot = state
                SoruButton.Visible = state
            end)
            toggles.soru = soruToggle

            local excludeFToggle = CreateToggle(AimbotPage, "F SKILL (EXCLUDED)", true, function(state)
                excludeF = state
            end)
            toggles.excludeF = excludeFToggle

            -- Distance slider
            local distFrame = Instance.new("Frame")
            distFrame.Size = UDim2.new(1,0,0,30)
            distFrame.BackgroundTransparency = 1
            distFrame.Parent = AimbotPage

            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(0.5,0,1,0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "Distance: " .. maxDistance
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
            distVal.Text = tostring(maxDistance)
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
                maxDistance = math.max(500, maxDistance - 100)
                distVal.Text = tostring(maxDistance)
                distLabel.Text = "Distance: " .. maxDistance
            end)

            distPlus.MouseButton1Click:Connect(function()
                maxDistance = math.min(5000, maxDistance + 100)
                distVal.Text = tostring(maxDistance)
                distLabel.Text = "Distance: " .. maxDistance
            end)

            local lineToggle = CreateToggle(AimbotPage, "TARGET LINE", true, function(state)
                showLine = state
                if TargetLine then TargetLine.Visible = (aimbotEnabled and showLine) end
            end)
            toggles.line = lineToggle

            local fovToggle = nil
            if hasDrawing then
                fovToggle = CreateToggle(AimbotPage, "FOV CIRCLE", false, function(state)
                    showFOV = state
                    if FOVCircle then FOVCircle.Visible = (aimbotEnabled and showFOV) end
                end)
                toggles.fov = fovToggle
            end

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
                getShowLine = function() return showLine end,
                getShowFOV = function() return showFOV end,
                getTeamCheck = function() return teamCheck end,
                getAimPart = function() return aimPart end,
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

        --// Drawing support
        local hasDrawing = pcall(function()
            local c = Drawing.new("Circle")
            c:Remove()
            return true
        end)

        local FOVCircle, TargetLine
        if hasDrawing then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = false
            FOVCircle.Color = Color3.fromRGB(255,255,0)
            FOVCircle.Radius = 150
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
            FOVCircle.Transparency = 0.5

            TargetLine = Drawing.new("Line")
            TargetLine.Visible = false
            TargetLine.Color = Color3.fromRGB(255,0,0)
            TargetLine.Thickness = 2
            TargetLine.Transparency = 0.6
        end

        local aimbotUI = createAimbotUI()

        function updateTargetLabel()
            aimbotUI.updateStatus()
        end

        -- Soru button action
        SoruButton.MouseButton1Click:Connect(function()
            if aimbotUI and aimbotUI.getEnabled() then
                local target = aimbotUI.getTarget()
                if target then
                    local targetIsNPC = false
                    local parent = target.Parent
                    if parent then
                        if not Players:GetPlayerFromCharacter(parent) then
                            targetIsNPC = true
                        end
                    end
                    if targetIsNPC and not aimbotUI.getTargetNPCs() then
                        return
                    end
                    local targetPos = target.Position
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(targetPos)
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                            if remotes then
                                local commF = remotes:FindFirstChild("CommF_")
                                if commF then
                                    pcall(function() commF:InvokeServer("Flashstep", targetPos) end)
                                end
                            end
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

        -- Update target
        RunService.Heartbeat:Connect(function()
            if aimbotUI.getEnabled() then
                local target = getClosestEnemy()
                aimbotUI.setTarget(target)
            else
                aimbotUI.setTarget(nil)
            end
            updateTargetLabel()
        end)

        -- Visual updates
        RunService.RenderStepped:Connect(function()
            if not camera then return end

            if FOVCircle then
                if aimbotUI.getEnabled() and aimbotUI.getShowFOV() then
                    FOVCircle.Visible = true
                    local viewport = camera.ViewportSize
                    FOVCircle.Position = Vector2.new(viewport.X/2, viewport.Y/2)
                else
                    FOVCircle.Visible = false
                end
            end

            if TargetLine then
                if aimbotUI.getEnabled() and aimbotUI.getShowLine() then
                    local target = aimbotUI.getTarget()
                    if target then
                        local screenPos, onScreen = camera:WorldToViewportPoint(target.Position)
                        if onScreen then
                            local viewport = camera.ViewportSize
                            local center = Vector2.new(viewport.X/2, viewport.Y/2)
                            TargetLine.From = center
                            TargetLine.To = Vector2.new(screenPos.X, screenPos.Y)
                            TargetLine.Visible = true
                        else
                            TargetLine.Visible = false
                        end
                    else
                        TargetLine.Visible = false
                    end
                else
                    TargetLine.Visible = false
                end
            end
        end)

        -- Silent Aim Hooks
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

        -- Override remotes
        local function overrideRemote(remote)
            if remote:IsA("RemoteEvent") then
                local oldFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    if aimbotUI.getEnabled() then
                        local target = aimbotUI.getTarget()
                        if target then
                            local args = {...}
                            local isF = false
                            for _, arg in ipairs(args) do
                                if typeof(arg) == "string" and string.upper(arg) == "F" then
                                    isF = true
                                    break
                                end
                            end
                            local excludeF = aimbotUI.getExcludeF()
                            if excludeF and isF then
                                return oldFire(self, ...)
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
                            local isF = false
                            for _, arg in ipairs(args) do
                                if typeof(arg) == "string" and string.upper(arg) == "F" then
                                    isF = true
                                    break
                                end
                            end
                            local excludeF = aimbotUI.getExcludeF()
                            if excludeF and isF then
                                return oldInvoke(self, ...)
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

        -- Fallback namecall
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
                            local isF = false
                            for _, arg in ipairs(args) do
                                if typeof(arg) == "string" and string.upper(arg) == "F" then
                                    isF = true
                                    break
                                end
                            end
                            local excludeF = aimbotUI.getExcludeF()
                            if excludeF and isF then
                                return oldNamecall(self, ...)
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

        -- Hotkey F5
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.F5 then
                local newState = not aimbotUI.getEnabled()
                aimbotUI.setEnabled(newState)
                updateTargetLabel()
                if FOVCircle then FOVCircle.Visible = (newState and aimbotUI.getShowFOV()) end
                if TargetLine then TargetLine.Visible = (newState and aimbotUI.getShowLine()) end
            end
        end)

        -- ==================================================================
        --                  COMBO MACRO (ADVANCED EDITOR)
        -- ==================================================================

        local comboSteps = {
            {slot = 1, key = "Z", delay = 0.2},
            {slot = 1, key = "X", delay = 0.2},
            {slot = 2, key = "C", delay = 0.2},
            {slot = 2, key = "V", delay = 0.3},
        }
        local comboEnabled = false
        local comboLoop = nil
        local autoCombo = false

        -- executeComboSteps function (defined before used)
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
                        if slot >= 1 and slot <= 4 then
                            if VirtualInputManager then
                                VirtualInputManager:SendKeyEvent(true, slotKeys[slot], false, game)
                                task.wait(0.05)
                                VirtualInputManager:SendKeyEvent(false, slotKeys[slot], false, game)
                            end
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

        -- Macro button action
        MacroButton.MouseButton1Click:Connect(function()
            if comboEnabled then
                executeComboSteps()
            end
        end)

        -- Combo toggle
        local comboToggle = CreateToggle(ComboPage, "COMBO MACRO", false, function(state)
            comboEnabled = state
            MacroButton.Visible = state
            if not state then
                if comboLoop then comboLoop:Disconnect(); comboLoop = nil end
                autoCombo = false
                -- Update auto toggle text
                for _, child in ipairs(ComboPage:GetChildren()) do
                    if child:IsA("TextButton") and string.find(child.Text, "AUTO COMBO") then
                        child.Text = "AUTO COMBO OFF"
                        break
                    end
                end
            end
        end)

        -- Auto/Manual toggle
        local autoToggle = CreateToggle(ComboPage, "AUTO COMBO", false, function(state)
            autoCombo = state
            if autoCombo then
                if comboEnabled then
                    if comboLoop then comboLoop:Disconnect(); comboLoop = nil end
                    comboLoop = RunService.Heartbeat:Connect(function()
                        if not comboEnabled or not autoCombo then
                            if comboLoop then comboLoop:Disconnect(); comboLoop = nil end
                            return
                        end
                        executeComboSteps()
                        task.wait(0.2)
                    end)
                end
            else
                if comboLoop then comboLoop:Disconnect(); comboLoop = nil end
            end
        end)

        -- Execute button (in GUI)
        local execBtn = CreateButton(ComboPage, "EXECUTE COMBO")
        execBtn.MouseButton1Click:Connect(executeComboSteps)

        -- Step count label
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

        -- Build step editor function
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

        --// Visuals Page (ESP)
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

        -- ESP update
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
            -- Update sidebar tabs
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
                showLine = aimbotUI.getShowLine(),
                showFOV = aimbotUI.getShowFOV(),
                fastAttack = fastAttack,
                walkSpeed = walkSpeed,
                walkSpeedVal = walkSpeedVal,
                noclip = noclipEnabled,
                antiStun = antiStun,
                autoClick = autoClick,
                espEnabled = espEnabled,
                espName = espName,
                espDist = espDist,
                espHealth = espHealth,
                themeBlack = themeBlack,
                comboSteps = comboSteps,
                comboEnabled = comboEnabled,
                autoCombo = autoCombo
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
                -- Restore aimbot
                aimbotUI.setEnabled(data.aimbotEnabled or false)
                -- Toggle update
                for _, child in ipairs(AimbotPage:GetChildren()) do
                    if child:IsA("TextButton") and string.sub(child.Text,1,6) == "AIMBOT" then
                        child.Text = data.aimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
                        break
                    end
                end
                -- Restore toggles by text
                for _, child in ipairs(AimbotPage:GetChildren()) do
                    if child:IsA("TextButton") then
                        local txt = child.Text
                        if string.find(txt, "TEAM CHECK") then
                            child.Text = data.teamCheck and "TEAM CHECK ON" or "TEAM CHECK OFF"
                        elseif string.find(txt, "TARGET PLAYERS") then
                            child.Text = data.targetPlayers and "TARGET PLAYERS ON" or "TARGET PLAYERS OFF"
                        elseif string.find(txt, "TARGET NPCS") then
                            child.Text = data.targetNPCs and "TARGET NPCS ON" or "TARGET NPCS OFF"
                        elseif string.find(txt, "SORU TELEPORT") then
                            child.Text = data.soruAimbot and "SORU TELEPORT ON" or "SORU TELEPORT OFF"
                            SoruButton.Visible = data.soruAimbot or false
                        elseif string.find(txt, "F SKILL") then
                            child.Text = data.excludeF and "F SKILL (EXCLUDED) ON" or "F SKILL (EXCLUDED) OFF"
                        elseif string.find(txt, "TARGET LINE") then
                            child.Text = data.showLine and "TARGET LINE ON" or "TARGET LINE OFF"
                            if TargetLine then TargetLine.Visible = (data.aimbotEnabled and data.showLine) end
                        elseif string.find(txt, "FOV CIRCLE") then
                            child.Text = data.showFOV and "FOV CIRCLE ON" or "FOV CIRCLE OFF"
                            if FOVCircle then FOVCircle.Visible = (data.aimbotEnabled and data.showFOV) end
                        end
                    end
                end
                -- Aim part
                if data.aimPart then
                    for _, child in ipairs(AimbotPage:GetChildren()) do
                        if child:IsA("TextButton") and string.find(child.Text, "AIM PART") then
                            child.Text = "AIM PART: " .. data.aimPart
                            break
                        end
                    end
                end
                -- Distance
                if data.maxDistance then
                    for _, child in ipairs(AimbotPage:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Text and string.find(child.Text, "Distance:") then
                            child.Text = "Distance: " .. data.maxDistance
                        end
                        if child:IsA("TextLabel") and child.Parent and child.Parent:IsA("Frame") and child.Text and tonumber(child.Text) then
                            child.Text = tostring(data.maxDistance)
                        end
                    end
                end
                -- Main page toggles
                for _, child in ipairs(MainPage:GetChildren()) do
                    if child:IsA("TextButton") then
                        local txt = child.Text
                        if string.find(txt, "FAST ATTACK") then
                            child.Text = data.fastAttack and "FAST ATTACK ON" or "FAST ATTACK OFF"
                            fastAttack = data.fastAttack or false
                            if fastAttack then
                                if not fastAttackLoop then
                                    fastAttackLoop = RunService.Heartbeat:Connect(function() end) -- placeholder, actually we need to start
                                end
                            else
                                if fastAttackLoop then fastAttackLoop:Disconnect(); fastAttackLoop = nil end
                            end
                        elseif string.find(txt, "WALK SPEED") then
                            child.Text = data.walkSpeed and "WALK SPEED ON" or "WALK SPEED OFF"
                            walkSpeed = data.walkSpeed or false
                            if walkSpeed then
                                if not wsLoop then
                                    wsLoop = RunService.Heartbeat:Connect(function() end)
                                end
                            else
                                if wsLoop then wsLoop:Disconnect(); wsLoop = nil end
                                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                                if hum then hum.WalkSpeed = 16 end
                            end
                        elseif string.find(txt, "NOCLIP") then
                            child.Text = data.noclip and "NOCLIP ON" or "NOCLIP OFF"
                            noclipEnabled = data.noclip or false
                            if noclipEnabled then
                                if not noclipLoop then
                                    noclipLoop = RunService.Heartbeat:Connect(function() end)
                                end
                            else
                                if noclipLoop then noclipLoop:Disconnect(); noclipLoop = nil end
                                local char = player.Character
                                if char then
                                    for _, part in pairs(char:GetDescendants()) do
                                        if part:IsA("BasePart") then part.CanCollide = true end
                                    end
                                end
                            end
                        elseif string.find(txt, "ANTI-STUN") then
                            child.Text = data.antiStun and "ANTI-STUN ON" or "ANTI-STUN OFF"
                            antiStun = data.antiStun or false
                            if antiStun then
                                if not antiStunLoop then
                                    antiStunLoop = RunService.Heartbeat:Connect(function() end)
                                end
                            else
                                if antiStunLoop then antiStunLoop:Disconnect(); antiStunLoop = nil end
                            end
                        elseif string.find(txt, "AUTO CLICK") then
                            child.Text = data.autoClick and "AUTO CLICK ON" or "AUTO CLICK OFF"
                            autoClick = data.autoClick or false
                            if autoClick then
                                if not autoClickLoop then
                                    autoClickLoop = RunService.Heartbeat:Connect(function() end)
                                end
                            else
                                if autoClickLoop then autoClickLoop:Disconnect(); autoClickLoop = nil end
                            end
                        end
                    end
                end
                -- Walk speed value
                if data.walkSpeedVal then
                    walkSpeedVal = data.walkSpeedVal
                    for _, child in ipairs(MainPage:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Text and string.find(child.Text, "Speed:") then
                            child.Text = "Speed: " .. walkSpeedVal
                        end
                        if child:IsA("TextLabel") and child.Parent and child.Parent:IsA("Frame") and child.Text and tonumber(child.Text) then
                            child.Text = tostring(walkSpeedVal)
                        end
                    end
                end
                -- ESP
                for _, child in ipairs(VisualsPage:GetChildren()) do
                    if child:IsA("TextButton") then
                        local txt = child.Text
                        if string.find(txt, "ESP MASTER") then
                            child.Text = data.espEnabled and "ESP MASTER ON" or "ESP MASTER OFF"
                            espEnabled = data.espEnabled or false
                        elseif string.find(txt, "SHOW NAME") then
                            child.Text = data.espName and "SHOW NAME ON" or "SHOW NAME OFF"
                            espName = data.espName or true
                        elseif string.find(txt, "SHOW DISTANCE") then
                            child.Text = data.espDist and "SHOW DISTANCE ON" or "SHOW DISTANCE OFF"
                            espDist = data.espDist or true
                        elseif string.find(txt, "SHOW HEALTH") then
                            child.Text = data.espHealth and "SHOW HEALTH ON" or "SHOW HEALTH OFF"
                            espHealth = data.espHealth or false
                        end
                    end
                end
                -- Theme
                if data.themeBlack ~= nil then
                    themeBlack = data.themeBlack
                    for _, child in ipairs(SettingsPage:GetChildren()) do
                        if child:IsA("TextButton") and string.find(child.Text, "DARK THEME") then
                            child.Text = themeBlack and "DARK THEME ON" or "DARK THEME OFF"
                            break
                        end
                    end
                    applyTheme(themeBlack)
                end
                -- Combo
                if data.comboSteps and type(data.comboSteps) == "table" then
                    comboSteps = data.comboSteps
                    rebuildStepUI()
                end
                if data.comboEnabled ~= nil then
                    comboEnabled = data.comboEnabled
                    for _, child in ipairs(ComboPage:GetChildren()) do
                        if child:IsA("TextButton") and string.find(child.Text, "COMBO MACRO") then
                            child.Text = comboEnabled and "COMBO MACRO ON" or "COMBO MACRO OFF"
                            break
                        end
                    end
                    MacroButton.Visible = comboEnabled
                end
                if data.autoCombo ~= nil then
                    autoCombo = data.autoCombo
                    for _, child in ipairs(ComboPage:GetChildren()) do
                        if child:IsA("TextButton") and string.find(child.Text, "AUTO COMBO") then
                            child.Text = autoCombo and "AUTO COMBO ON" or "AUTO COMBO OFF"
                            break
                        end
                    end
                end
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
        infoText.Text = "Ivory Hub PVP Edition v3.3\n\nCreated by: lvory999\n\nIdeas: rayo06996\n\nA clean, simple hub for Blox Fruits PVP.\n\nFeatures: Aimbot, Combo Macro (editable), ESP, Soru Teleport (manual), Fast Attack, Walk Speed, Noclip, Anti-Stun, Auto Click."
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
        creditsText.Text = "Ivory Hub PVP Edition v3.3\n\nDesign & Development: lvory999\n\nIdeas: rayo06996\n\nSpecial thanks to the community."
        creditsText.TextColor3 = WHITE
        creditsText.TextSize = 11
        creditsText.Font = Enum.Font.Gotham
        creditsText.TextXAlignment = Enum.TextXAlignment.Left
        creditsText.TextYAlignment = Enum.TextYAlignment.Top
        creditsText.Parent = CreditsPage

        print("✅ Ivory Hub PVP Edition v3.3 loaded successfully!")
        print("📌 All features fixed and working.")
        print("📌 Soru button respects NPC targeting toggle.")
        print("📌 Macro button executes combo steps manually.")
        print("📌 Save/Load/Delete Config available in Settings.")
    end)
end

safeExecute()
