--// IVORY HUB
--// FULL BLACK / WHITE TEXT
--// Creator: Ivory
--// Ideas / Concepts: Rayo
--// Enhanced for Blox Fruits PVP – with tabs, silent aim 180, macros, and more

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

local Player = Players.LocalPlayer

local BLACK = Color3.fromRGB(0,0,0)
local WHITE = Color3.fromRGB(255,255,255)

local BOLD = Enum.Font.GothamBold
local REGULAR = Enum.Font.Gotham

--==================================================
-- FEATURE STATES
--==================================================
local SilentAimEnabled = false        -- 180° silent aim
local AutoDodgeEnabled = false
local AutoComboEnabled = false
local KillAuraEnabled = false
local AutoClickMacro = false          -- spam mouse1
local ComboMacro = false              -- spam 1,2,3
local AntiAFK = false

local RunningLoop = nil
local ComboStep = 0
local ComboTimer = 0

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- FLOATING TOGGLE
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Name = "IvoryToggle"
Toggle.Size = UDim2.fromOffset(48,48)
Toggle.Position = UDim2.new(0,30,0.5,-24)
Toggle.BackgroundColor3 = BLACK
Toggle.BorderColor3 = WHITE
Toggle.BorderSizePixel = 2
Toggle.Text = "I"
Toggle.TextColor3 = WHITE
Toggle.TextSize = 22
Toggle.Font = BOLD
Toggle.AutoButtonColor = false
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,10)
ToggleCorner.Parent = Toggle

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(455,285)
Main.Position = UDim2.new(0.5,-227,0.5,-142)
Main.BackgroundColor3 = BLACK
Main.BorderColor3 = WHITE
Main.BorderSizePixel = 2
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,52)
Header.BackgroundColor3 = BLACK
Header.BorderSizePixel = 0
Header.Parent = Main

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(38,38)
Logo.Position = UDim2.fromOffset(12,7)
Logo.BackgroundColor3 = BLACK
Logo.BorderColor3 = WHITE
Logo.BorderSizePixel = 1
Logo.Text = "I"
Logo.TextColor3 = WHITE
Logo.TextSize = 20
Logo.Font = BOLD
Logo.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0,8)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromOffset(150,24)
Title.Position = UDim2.fromOffset(60,7)
Title.BackgroundTransparency = 1
Title.Text = "IVORY"
Title.TextColor3 = WHITE
Title.TextSize = 18
Title.Font = BOLD
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.fromOffset(200,17)
Subtitle.Position = UDim2.fromOffset(60,28)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "CONTROL PANEL"
Subtitle.TextColor3 = WHITE
Subtitle.TextSize = 9
Subtitle.Font = REGULAR
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1,-24,0,1)
HeaderLine.Position = UDim2.new(0,12,1,-1)
HeaderLine.BackgroundColor3 = WHITE
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

--==================================================
-- SIDEBAR (no labels)
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,125,1,-53)
Sidebar.Position = UDim2.new(0,0,0,53)
Sidebar.BackgroundColor3 = BLACK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-125,1,-53)
Content.Position = UDim2.new(0,125,0,53)
Content.BackgroundColor3 = BLACK
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

--==================================================
-- PAGE SYSTEM
--==================================================

local Pages = {}

local function CreatePage(name)
	local Page = Instance.new("Frame")
	Page.Name = name
	Page.Size = UDim2.new(1,0,1,0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = Content
	Pages[name] = Page
	return Page
end

-- Pages
local Home = CreatePage("Home")
local AimbotPage = CreatePage("Aimbot")
local CombatPage = CreatePage("Combat")
local MacrosPage = CreatePage("Macros")
local UtilityPage = CreatePage("Utility")
local SettingsPage = CreatePage("Settings")
local Credits = CreatePage("Credits")

--==================================================
-- HOME
--==================================================

local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1,-30,0,35)
Welcome.Position = UDim2.fromOffset(15,15)
Welcome.BackgroundTransparency = 1
Welcome.Text = "WELCOME TO IVORY"
Welcome.TextColor3 = WHITE
Welcome.TextSize = 21
Welcome.Font = BOLD
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = Home

local WelcomeSub = Instance.new("TextLabel")
WelcomeSub.Size = UDim2.new(1,-30,0,20)
WelcomeSub.Position = UDim2.fromOffset(16,48)
WelcomeSub.BackgroundTransparency = 1
WelcomeSub.Text = "Clean. Simple. Built different."
WelcomeSub.TextColor3 = WHITE
WelcomeSub.TextSize = 11
WelcomeSub.Font = REGULAR
WelcomeSub.TextXAlignment = Enum.TextXAlignment.Left
WelcomeSub.Parent = Home

-- Creator Card
local CreatorCard = Instance.new("Frame")
CreatorCard.Size = UDim2.new(1,-30,0,62)
CreatorCard.Position = UDim2.fromOffset(15,82)
CreatorCard.BackgroundColor3 = BLACK
CreatorCard.BorderColor3 = WHITE
CreatorCard.BorderSizePixel = 1
CreatorCard.Parent = Home
local CreatorCorner = Instance.new("UICorner")
CreatorCorner.CornerRadius = UDim.new(0,8)
CreatorCorner.Parent = CreatorCard

local CreatorTitle = Instance.new("TextLabel")
CreatorTitle.Size = UDim2.new(1,-20,0,20)
CreatorTitle.Position = UDim2.fromOffset(10,8)
CreatorTitle.BackgroundTransparency = 1
CreatorTitle.Text = "CREATOR"
CreatorTitle.TextColor3 = WHITE
CreatorTitle.TextSize = 9
CreatorTitle.Font = BOLD
CreatorTitle.TextXAlignment = Enum.TextXAlignment.Left
CreatorTitle.Parent = CreatorCard

local CreatorName = Instance.new("TextLabel")
CreatorName.Size = UDim2.new(1,-20,0,25)
CreatorName.Position = UDim2.fromOffset(10,27)
CreatorName.BackgroundTransparency = 1
CreatorName.Text = "Ivory"
CreatorName.TextColor3 = WHITE
CreatorName.TextSize = 16
CreatorName.Font = BOLD
CreatorName.TextXAlignment = Enum.TextXAlignment.Left
CreatorName.Parent = CreatorCard

-- Idea Card
local IdeaCard = Instance.new("Frame")
IdeaCard.Size = UDim2.new(1,-30,0,62)
IdeaCard.Position = UDim2.fromOffset(15,153)
IdeaCard.BackgroundColor3 = BLACK
IdeaCard.BorderColor3 = WHITE
IdeaCard.BorderSizePixel = 1
IdeaCard.Parent = Home
local IdeaCorner = Instance.new("UICorner")
IdeaCorner.CornerRadius = UDim.new(0,8)
IdeaCorner.Parent = IdeaCard

local IdeaTitle = Instance.new("TextLabel")
IdeaTitle.Size = UDim2.new(1,-20,0,20)
IdeaTitle.Position = UDim2.fromOffset(10,8)
IdeaTitle.BackgroundTransparency = 1
IdeaTitle.Text = "IDEAS / CONCEPTS"
IdeaTitle.TextColor3 = WHITE
IdeaTitle.TextSize = 9
IdeaTitle.Font = BOLD
IdeaTitle.TextXAlignment = Enum.TextXAlignment.Left
IdeaTitle.Parent = IdeaCard

local IdeaName = Instance.new("TextLabel")
IdeaName.Size = UDim2.new(1,-20,0,25)
IdeaName.Position = UDim2.fromOffset(10,27)
IdeaName.BackgroundTransparency = 1
IdeaName.Text = "Rayo"
IdeaName.TextColor3 = WHITE
IdeaName.TextSize = 16
IdeaName.Font = BOLD
IdeaName.TextXAlignment = Enum.TextXAlignment.Left
IdeaName.Parent = IdeaCard

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-30,0,20)
Status.Position = UDim2.new(0,15,1,-25)
Status.BackgroundTransparency = 1
Status.Text = "IVORY HUB  //  READY"
Status.TextColor3 = WHITE
Status.TextSize = 9
Status.Font = BOLD
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Home

--==================================================
-- HELPER FUNCTIONS FOR UI
--==================================================

local function UpdateFeatureButton(button, enabled)
	if enabled then
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = WHITE,
			TextColor3 = BLACK
		}):Play()
	else
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = BLACK,
			TextColor3 = WHITE
		}):Play()
	end
end

local function UpdateStatus()
	local active = {}
	if SilentAimEnabled then table.insert(active, "SILENT AIM") end
	if AutoDodgeEnabled then table.insert(active, "DODGE") end
	if AutoComboEnabled then table.insert(active, "COMBO") end
	if KillAuraEnabled then table.insert(active, "AURA") end
	if AutoClickMacro then table.insert(active, "AUTO-CLICK") end
	if ComboMacro then table.insert(active, "COMBO-MACRO") end
	if AntiAFK then table.insert(active, "ANTI-AFK") end
	if #active == 0 then
		Status.Text = "IVORY HUB  //  READY"
	else
		Status.Text = "IVORY HUB  //  " .. table.concat(active, " | ")
	end
end

--==================================================
-- FEATURE BUTTON CREATOR (with white border)
--==================================================

local function FeatureButton(text, y, callback, parent)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-30,0,38)
	Button.Position = UDim2.fromOffset(15,y)
	Button.BackgroundColor3 = BLACK
	Button.BorderColor3 = WHITE
	Button.BorderSizePixel = 1
	Button.Text = text
	Button.TextColor3 = WHITE
	Button.TextSize = 11
	Button.Font = BOLD
	Button.AutoButtonColor = false
	Button.Parent = parent or CombatPage

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,7)
	Corner.Parent = Button

	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.15), {
			BackgroundColor3 = WHITE,
			TextColor3 = BLACK
		}):Play()
	end)
	Button.MouseLeave:Connect(function()
		if Button.BackgroundColor3 ~= WHITE or Button.TextColor3 ~= BLACK then
			TweenService:Create(Button, TweenInfo.new(0.15), {
				BackgroundColor3 = BLACK,
				TextColor3 = WHITE
			}):Play()
		end
	end)

	if callback then
		Button.MouseButton1Click:Connect(callback)
	end

	return Button
end

--==================================================
-- PVP CORE FUNCTIONS
--==================================================

-- Get nearest enemy
local function GetNearestPlayer()
	local nearest = nil
	local dist = math.huge
	local myChar = Player.Character
	if not myChar then return nil end
	local myRoot = myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end
	local myPos = myRoot.Position

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= Player then
			local char = plr.Character
			if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
				local pos = char.HumanoidRootPart.Position
				local d = (pos - myPos).magnitude
				if d < dist then
					dist = d
					nearest = plr
				end
			end
		end
	end
	return nearest, dist
end

-- Silent Aim 180 – only adjust character facing, not camera
local function SilentAimUpdate()
	if not SilentAimEnabled then return end
	local target, dist = GetNearestPlayer()
	if not target or dist > 50 then return end -- range limit
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return end

	local myChar = Player.Character
	if not myChar then return end
	local myRoot = myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end

	-- Calculate direction to target (ignoring Y to keep character upright)
	local lookDir = Vector3.new(targetRoot.Position.X - myRoot.Position.X, 0, targetRoot.Position.Z - myRoot.Position.Z)
	if lookDir.Magnitude > 0.5 then
		-- Set root CFrame to face target, but keep position
		local newCF = CFrame.lookAt(myRoot.Position, myRoot.Position + lookDir.Unit)
		myRoot.CFrame = newCF
	end
end

-- Auto Dodge – use Flash Step (F) when enemy is close and facing us
local function AutoDodgeUpdate()
	if not AutoDodgeEnabled or not VIM then return end
	local myChar = Player.Character
	if not myChar then return end
	local myRoot = myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end

	local target, dist = GetNearestPlayer()
	if not target or dist > 25 then return end
	local enemyRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if not enemyRoot then return end

	-- Check if enemy is facing us (rough)
	local enemyLook = enemyRoot.CFrame.LookVector
	local toUs = (myRoot.Position - enemyRoot.Position).Unit
	if enemyLook:Dot(toUs) > 0.4 then
		VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
		task.wait(0.05)
		VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
	end
end

-- Auto Combo – sequence: mouse1, 1, 2, 3
local function AutoComboUpdate()
	if not AutoComboEnabled or not VIM then return end
	local target, dist = GetNearestPlayer()
	if not target or dist > 30 then
		ComboStep = 0
		return
	end
	local myChar = Player.Character
	if not myChar then return end

	if dist < 30 then
		local step = ComboStep
		if step == 0 then
			VIM:SendMouseButtonEvent(1, true, game, 0, 0)
			task.wait(0.05)
			VIM:SendMouseButtonEvent(1, false, game, 0, 0)
			ComboStep = 1
			ComboTimer = tick() + 0.3
		elseif step == 1 and tick() > ComboTimer then
			VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
			task.wait(0.05)
			VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
			ComboStep = 2
			ComboTimer = tick() + 0.4
		elseif step == 2 and tick() > ComboTimer then
			VIM:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
			task.wait(0.05)
			VIM:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
			ComboStep = 3
			ComboTimer = tick() + 0.4
		elseif step == 3 and tick() > ComboTimer then
			VIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
			task.wait(0.05)
			VIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
			ComboStep = 0
			ComboTimer = tick() + 0.8
		end
	end
end

-- Kill Aura – spam mouse1 when enemy in range
local function KillAuraUpdate()
	if not KillAuraEnabled or not VIM then return end
	local target, dist = GetNearestPlayer()
	if not target or dist > 22 then return end
	VIM:SendMouseButtonEvent(1, true, game, 0, 0)
	task.wait(0.08)
	VIM:SendMouseButtonEvent(1, false, game, 0, 0)
end

-- Macros
local function AutoClickMacroUpdate()
	if not AutoClickMacro or not VIM then return end
	VIM:SendMouseButtonEvent(1, true, game, 0, 0)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(1, false, game, 0, 0)
	task.wait(0.1)
end

local function ComboMacroUpdate()
	if not ComboMacro or not VIM then return end
	-- spam 1,2,3, mouse1 repeatedly
	VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
	task.wait(0.05)
	VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
	task.wait(0.1)
	VIM:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
	task.wait(0.05)
	VIM:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
	task.wait(0.1)
	VIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
	task.wait(0.05)
	VIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
	task.wait(0.1)
	VIM:SendMouseButtonEvent(1, true, game, 0, 0)
	task.wait(0.05)
	VIM:SendMouseButtonEvent(1, false, game, 0, 0)
	task.wait(0.15)
end

-- Anti-AFK – simply move a tiny bit
local function AntiAFKUpdate()
	if not AntiAFK then return end
	local myChar = Player.Character
	if myChar and myChar:FindFirstChild("Humanoid") then
		local hum = myChar.Humanoid
		hum:Move(Vector3.new(1,0,0), true) -- move a step
		task.wait(0.1)
		hum:Move(Vector3.new(-1,0,0), true)
	end
end

--==================================================
-- MAIN LOOP CONTROLLER
--==================================================

local function StartPVPLoop()
	if RunningLoop then return end
	RunningLoop = RunService.Heartbeat:Connect(function()
		SilentAimUpdate()
		AutoDodgeUpdate()
		AutoComboUpdate()
		KillAuraUpdate()
		AutoClickMacroUpdate()
		ComboMacroUpdate()
		AntiAFKUpdate()
	end)
end

local function StopPVPLoop()
	if RunningLoop then
		RunningLoop:Disconnect()
		RunningLoop = nil
	end
end

-- Check if any feature is active to start/stop loop
local function CheckLoopState()
	if SilentAimEnabled or AutoDodgeEnabled or AutoComboEnabled or KillAuraEnabled or AutoClickMacro or ComboMacro or AntiAFK then
		StartPVPLoop()
	else
		StopPVPLoop()
	end
end

-- Toggle functions
local function ToggleSilentAim()
	SilentAimEnabled = not SilentAimEnabled
	UpdateFeatureButton(aimbotBtn, SilentAimEnabled)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleAutoDodge()
	AutoDodgeEnabled = not AutoDodgeEnabled
	UpdateFeatureButton(dodgeBtn, AutoDodgeEnabled)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleAutoCombo()
	AutoComboEnabled = not AutoComboEnabled
	UpdateFeatureButton(comboBtn, AutoComboEnabled)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleKillAura()
	KillAuraEnabled = not KillAuraEnabled
	UpdateFeatureButton(auraBtn, KillAuraEnabled)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleAutoClick()
	AutoClickMacro = not AutoClickMacro
	UpdateFeatureButton(clickBtn, AutoClickMacro)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleComboMacro()
	ComboMacro = not ComboMacro
	UpdateFeatureButton(comboMacroBtn, ComboMacro)
	UpdateStatus()
	CheckLoopState()
end

local function ToggleAntiAFK()
	AntiAFK = not AntiAFK
	UpdateFeatureButton(afkBtn, AntiAFK)
	UpdateStatus()
	CheckLoopState()
end

--==================================================
-- BUILD PAGES
--==================================================

-- Aimbot Page
local aimbotTitle = Instance.new("TextLabel")
aimbotTitle.Size = UDim2.new(1,-30,0,30)
aimbotTitle.Position = UDim2.fromOffset(15,15)
aimbotTitle.BackgroundTransparency = 1
aimbotTitle.Text = "AIMBOT"
aimbotTitle.TextColor3 = WHITE
aimbotTitle.TextSize = 20
aimbotTitle.Font = BOLD
aimbotTitle.TextXAlignment = Enum.TextXAlignment.Left
aimbotTitle.Parent = AimbotPage

local aimbotDesc = Instance.new("TextLabel")
aimbotDesc.Size = UDim2.new(1,-30,0,25)
aimbotDesc.Position = UDim2.fromOffset(15,48)
aimbotDesc.BackgroundTransparency = 1
aimbotDesc.Text = "180° Silent Aim – locks onto nearest enemy without moving your camera."
aimbotDesc.TextColor3 = WHITE
aimbotDesc.TextSize = 10
aimbotDesc.Font = REGULAR
aimbotDesc.TextXAlignment = Enum.TextXAlignment.Left
aimbotDesc.TextYAlignment = Enum.TextYAlignment.Top
aimbotDesc.Parent = AimbotPage

local aimbotBtn = FeatureButton("SILENT AIM", 85, ToggleSilentAim, AimbotPage)

-- Combat Page
local combatTitle = Instance.new("TextLabel")
combatTitle.Size = UDim2.new(1,-30,0,30)
combatTitle.Position = UDim2.fromOffset(15,15)
combatTitle.BackgroundTransparency = 1
combatTitle.Text = "COMBAT"
combatTitle.TextColor3 = WHITE
combatTitle.TextSize = 20
combatTitle.Font = BOLD
combatTitle.TextXAlignment = Enum.TextXAlignment.Left
combatTitle.Parent = CombatPage

dodgeBtn = FeatureButton("AUTO DODGE", 55, ToggleAutoDodge, CombatPage)
comboBtn = FeatureButton("AUTO COMBO", 100, ToggleAutoCombo, CombatPage)
auraBtn = FeatureButton("KILL AURA", 145, ToggleKillAura, CombatPage)

-- Macros Page
local macroTitle = Instance.new("TextLabel")
macroTitle.Size = UDim2.new(1,-30,0,30)
macroTitle.Position = UDim2.fromOffset(15,15)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "MACROS"
macroTitle.TextColor3 = WHITE
macroTitle.TextSize = 20
macroTitle.Font = BOLD
macroTitle.TextXAlignment = Enum.TextXAlignment.Left
macroTitle.Parent = MacrosPage

clickBtn = FeatureButton("AUTO CLICK", 55, ToggleAutoClick, MacrosPage)
comboMacroBtn = FeatureButton("COMBO MACRO (1,2,3,M1)", 100, ToggleComboMacro, MacrosPage)

-- Utility Page
local utilTitle = Instance.new("TextLabel")
utilTitle.Size = UDim2.new(1,-30,0,30)
utilTitle.Position = UDim2.fromOffset(15,15)
utilTitle.BackgroundTransparency = 1
utilTitle.Text = "UTILITY"
utilTitle.TextColor3 = WHITE
utilTitle.TextSize = 20
utilTitle.Font = BOLD
utilTitle.TextXAlignment = Enum.TextXAlignment.Left
utilTitle.Parent = UtilityPage

afkBtn = FeatureButton("ANTI-AFK", 55, ToggleAntiAFK, UtilityPage)

-- Settings Page
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1,-30,0,30)
settingsTitle.Position = UDim2.fromOffset(15,15)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "SETTINGS"
settingsTitle.TextColor3 = WHITE
settingsTitle.TextSize = 20
settingsTitle.Font = BOLD
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = SettingsPage

local settingsInfo = Instance.new("TextLabel")
settingsInfo.Size = UDim2.new(1,-30,0,60)
settingsInfo.Position = UDim2.fromOffset(15,55)
settingsInfo.BackgroundTransparency = 1
settingsInfo.Text = "Customize your Ivory experience.\nMore options can be added here."
settingsInfo.TextColor3 = WHITE
settingsInfo.TextSize = 11
settingsInfo.Font = REGULAR
settingsInfo.TextXAlignment = Enum.TextXAlignment.Left
settingsInfo.TextYAlignment = Enum.TextYAlignment.Top
settingsInfo.Parent = SettingsPage

-- Credits Page
local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1,-30,0,35)
creditsTitle.Position = UDim2.fromOffset(15,15)
creditsTitle.BackgroundTransparency = 1
creditsTitle.Text = "CREDITS"
creditsTitle.TextColor3 = WHITE
creditsTitle.TextSize = 21
creditsTitle.Font = BOLD
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Parent = Credits

local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1,-30,0,150)
creditsText.Position = UDim2.fromOffset(15,60)
creditsText.BackgroundTransparency = 1
creditsText.Text = "IVORY\nCREATOR / DEVELOPER\n\nRAYO\nIDEAS / CONCEPTS\n\nIVORY HUB"
creditsText.TextColor3 = WHITE
creditsText.TextSize = 12
creditsText.Font = REGULAR
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Parent = Credits

--==================================================
-- SIDEBAR TABS (with white borders)
--==================================================

local CurrentTab

local function CreateTab(text, y, page)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-18,0,34)
	Button.Position = UDim2.fromOffset(9,y)
	Button.BackgroundColor3 = BLACK
	Button.BorderColor3 = WHITE
	Button.BorderSizePixel = 1
	Button.Text = text
	Button.TextColor3 = WHITE
	Button.TextSize = 10
	Button.Font = BOLD
	Button.AutoButtonColor = false
	Button.Parent = Sidebar

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,7)
	Corner.Parent = Button

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.fromOffset(3,20)
	Indicator.Position = UDim2.new(1,-7,0.5,-10)
	Indicator.BackgroundColor3 = WHITE
	Indicator.BorderSizePixel = 0
	Indicator.Visible = false
	Indicator.Parent = Button

	local function Select()
		if CurrentTab then
			CurrentTab.Button.BackgroundColor3 = BLACK
			CurrentTab.Button.TextColor3 = WHITE
			CurrentTab.Indicator.Visible = false
			CurrentTab.Page.Visible = false
		end

		CurrentTab = {
			Button = Button,
			Indicator = Indicator,
			Page = page
		}

		Button.BackgroundColor3 = WHITE
		Button.TextColor3 = BLACK
		Indicator.BackgroundColor3 = BLACK
		Indicator.Visible = true

		page.Visible = true
		page.Position = UDim2.new(0,15,0,0)

		TweenService:Create(page, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0,0,0,0)
		}):Play()
	end

	Button.MouseButton1Click:Connect(Select)

	return {
		Button = Button,
		Indicator = Indicator,
		Select = Select,
		Page = page
	}
end

-- Create all tabs (no labels on sidebar)
local HomeTab = CreateTab("HOME", 20, Home)
local AimbotTab = CreateTab("AIMBOT", 60, AimbotPage)
local CombatTab = CreateTab("COMBAT", 100, CombatPage)
local MacrosTab = CreateTab("MACROS", 140, MacrosPage)
local UtilityTab = CreateTab("UTILITY", 180, UtilityPage)
local SettingsTab = CreateTab("SETTINGS", 220, SettingsPage)
local CreditsTab = CreateTab("CREDITS", 260, Credits)

HomeTab.Select()

--==================================================
-- DRAGGING
--==================================================

local function MakeDraggable(object, handle)
	local dragging = false
	local dragStart
	local startPosition

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)
end

MakeDraggable(Main, Header)
MakeDraggable(Toggle, Toggle)

--==================================================
-- TOGGLE VISIBILITY
--==================================================

local Open = true
Toggle.MouseButton1Click:Connect(function()
	Open = not Open
	if Open then
		Main.Visible = true
		Main.Size = UDim2.fromOffset(435,270)
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(455,285)
		}):Play()
	else
		TweenService:Create(Main, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(435,270)
		}):Play()
		task.wait(0.15)
		Main.Visible = false
	end
end)

-- Hover effects on toggle
Toggle.MouseEnter:Connect(function()
	TweenService:Create(Toggle, TweenInfo.new(0.15), {
		BackgroundColor3 = WHITE,
		TextColor3 = BLACK
	}):Play()
end)
Toggle.MouseLeave:Connect(function()
	TweenService:Create(Toggle, TweenInfo.new(0.15), {
		BackgroundColor3 = BLACK,
		TextColor3 = WHITE
	}):Play()
end)

--==================================================
-- INIT
--==================================================
UpdateStatus()
print("IVORY HUB // LOADED – Enhanced PVP Edition")
