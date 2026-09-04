--// IVORY HUB
--// INVERTED BLACK & WHITE UI
--// Creator: Ivory
--// Ideas / Concepts: Rayo

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- COLORS
--==================================================

local WHITE = Color3.fromRGB(255,255,255)
local BLACK = Color3.fromRGB(0,0,0)

local BOLD = Enum.Font.GothamBold
local REGULAR = Enum.Font.Gotham

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- FLOATING BUTTON
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Name = "IvoryToggle"
Toggle.Size = UDim2.fromOffset(48,48)
Toggle.Position = UDim2.new(0,30,0.5,-24)
Toggle.BackgroundColor3 = WHITE
Toggle.BorderColor3 = BLACK
Toggle.BorderSizePixel = 2
Toggle.Text = "I"
Toggle.TextColor3 = BLACK
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
Main.BackgroundColor3 = WHITE
Main.BorderColor3 = BLACK
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
Header.BackgroundColor3 = WHITE
Header.BorderSizePixel = 0
Header.Parent = Main

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(38,38)
Logo.Position = UDim2.fromOffset(12,7)
Logo.BackgroundColor3 = BLACK
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
Title.TextColor3 = BLACK
Title.TextSize = 18
Title.Font = BOLD
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.fromOffset(200,17)
Subtitle.Position = UDim2.fromOffset(60,28)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "CONTROL PANEL"
Subtitle.TextColor3 = BLACK
Subtitle.TextSize = 9
Subtitle.Font = REGULAR
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1,-24,0,2)
HeaderLine.Position = UDim2.new(0,12,1,-2)
HeaderLine.BackgroundColor3 = BLACK
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,125,1,-53)
Sidebar.Position = UDim2.new(0,0,0,53)
Sidebar.BackgroundColor3 = BLACK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0,10)
SideCorner.Parent = Sidebar

local SideCover = Instance.new("Frame")
SideCover.Size = UDim2.fromOffset(12,285)
SideCover.Position = UDim2.new(1,-12,0,0)
SideCover.BackgroundColor3 = BLACK
SideCover.BorderSizePixel = 0
SideCover.Parent = Sidebar

--==================================================
-- SECTION LABEL
--==================================================

local function SectionLabel(text,y)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1,-22,0,18)
	Label.Position = UDim2.fromOffset(11,y)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = WHITE
	Label.TextSize = 9
	Label.Font = BOLD
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Sidebar

	return Label
end

SectionLabel("MAIN",10)
SectionLabel("OTHER",125)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-125,1,-53)
Content.Position = UDim2.new(0,125,0,53)
Content.BackgroundColor3 = WHITE
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

--==================================================
-- PAGE CREATOR
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

local Home = CreatePage("Home")
local Features = CreatePage("Features")
local Settings = CreatePage("Settings")
local Credits = CreatePage("Credits")

--==================================================
-- HOME
--==================================================

local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1,-30,0,35)
Welcome.Position = UDim2.fromOffset(15,15)
Welcome.BackgroundTransparency = 1
Welcome.Text = "WELCOME TO IVORY"
Welcome.TextColor3 = BLACK
Welcome.TextSize = 21
Welcome.Font = BOLD
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = Home

local WelcomeSub = Instance.new("TextLabel")
WelcomeSub.Size = UDim2.new(1,-30,0,20)
WelcomeSub.Position = UDim2.fromOffset(16,48)
WelcomeSub.BackgroundTransparency = 1
WelcomeSub.Text = "Clean. Simple. Built different."
WelcomeSub.TextColor3 = BLACK
WelcomeSub.TextSize = 11
WelcomeSub.Font = REGULAR
WelcomeSub.TextXAlignment = Enum.TextXAlignment.Left
WelcomeSub.Parent = Home

-- Creator

local CreatorCard = Instance.new("Frame")
CreatorCard.Size = UDim2.new(1,-30,0,62)
CreatorCard.Position = UDim2.fromOffset(15,82)
CreatorCard.BackgroundColor3 = BLACK
CreatorCard.BorderSizePixel = 0
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

-- Rayo

local IdeaCard = Instance.new("Frame")
IdeaCard.Size = UDim2.new(1,-30,0,62)
IdeaCard.Position = UDim2.fromOffset(15,153)
IdeaCard.BackgroundColor3 = WHITE
IdeaCard.BorderColor3 = BLACK
IdeaCard.BorderSizePixel = 2
IdeaCard.Parent = Home

local IdeaCorner = Instance.new("UICorner")
IdeaCorner.CornerRadius = UDim.new(0,8)
IdeaCorner.Parent = IdeaCard

local IdeaTitle = Instance.new("TextLabel")
IdeaTitle.Size = UDim2.new(1,-20,0,20)
IdeaTitle.Position = UDim2.fromOffset(10,8)
IdeaTitle.BackgroundTransparency = 1
IdeaTitle.Text = "IDEAS / CONCEPTS"
IdeaTitle.TextColor3 = BLACK
IdeaTitle.TextSize = 9
IdeaTitle.Font = BOLD
IdeaTitle.TextXAlignment = Enum.TextXAlignment.Left
IdeaTitle.Parent = IdeaCard

local IdeaName = Instance.new("TextLabel")
IdeaName.Size = UDim2.new(1,-20,0,25)
IdeaName.Position = UDim2.fromOffset(10,27)
IdeaName.BackgroundTransparency = 1
IdeaName.Text = "Rayo"
IdeaName.TextColor3 = BLACK
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
Status.TextColor3 = BLACK
Status.TextSize = 9
Status.Font = BOLD
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Home

--==================================================
-- FEATURES
--==================================================

local FeatureTitle = Instance.new("TextLabel")
FeatureTitle.Size = UDim2.new(1,-30,0,30)
FeatureTitle.Position = UDim2.fromOffset(15,15)
FeatureTitle.BackgroundTransparency = 1
FeatureTitle.Text = "FEATURES"
FeatureTitle.TextColor3 = BLACK
FeatureTitle.TextSize = 20
FeatureTitle.Font = BOLD
FeatureTitle.TextXAlignment = Enum.TextXAlignment.Left
FeatureTitle.Parent = Features

local function FeatureButton(text,y)

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-30,0,38)
	Button.Position = UDim2.fromOffset(15,y)
	Button.BackgroundColor3 = BLACK
	Button.Text = text
	Button.TextColor3 = WHITE
	Button.TextSize = 11
	Button.Font = BOLD
	Button.AutoButtonColor = false
	Button.Parent = Features

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,7)
	Corner.Parent = Button

	Button.MouseEnter:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = WHITE,
				TextColor3 = BLACK
			}
		):Play()

	end)

	Button.MouseLeave:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = BLACK,
				TextColor3 = WHITE
			}
		):Play()

	end)

	return Button
end

FeatureButton("FEATURE 01",55)
FeatureButton("FEATURE 02",100)
FeatureButton("FEATURE 03",145)
FeatureButton("FEATURE 04",190)

--==================================================
-- SETTINGS
--==================================================

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1,-30,0,30)
SettingsTitle.Position = UDim2.fromOffset(15,15)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = BLACK
SettingsTitle.TextSize = 20
SettingsTitle.Font = BOLD
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = Settings

local SettingsInfo = Instance.new("TextLabel")
SettingsInfo.Size = UDim2.new(1,-30,0,50)
SettingsInfo.Position = UDim2.fromOffset(15,55)
SettingsInfo.BackgroundTransparency = 1
SettingsInfo.Text = "Customize your Ivory experience.\nMore options can be added here."
SettingsInfo.TextColor3 = BLACK
SettingsInfo.TextSize = 11
SettingsInfo.Font = REGULAR
SettingsInfo.TextXAlignment = Enum.TextXAlignment.Left
SettingsInfo.TextYAlignment = Enum.TextYAlignment.Top
SettingsInfo.Parent = Settings

--==================================================
-- CREDITS
--==================================================

local CreditsTitle = Instance.new("TextLabel")
CreditsTitle.Size = UDim2.new(1,-30,0,35)
CreditsTitle.Position = UDim2.fromOffset(15,15)
CreditsTitle.BackgroundTransparency = 1
CreditsTitle.Text = "CREDITS"
CreditsTitle.TextColor3 = BLACK
CreditsTitle.TextSize = 21
CreditsTitle.Font = BOLD
CreditsTitle.TextXAlignment = Enum.TextXAlignment.Left
CreditsTitle.Parent = Credits

local CreditsText = Instance.new("TextLabel")
CreditsText.Size = UDim2.new(1,-30,0,150)
CreditsText.Position = UDim2.fromOffset(15,60)
CreditsText.BackgroundTransparency = 1
CreditsText.Text =
	"IVORY\n" ..
	"CREATOR / DEVELOPER\n\n" ..
	"RAYO\n" ..
	"IDEAS / CONCEPTS\n\n" ..
	"IVORY HUB"
CreditsText.TextColor3 = BLACK
CreditsText.TextSize = 12
CreditsText.Font = REGULAR
CreditsText.TextXAlignment = Enum.TextXAlignment.Left
CreditsText.TextYAlignment = Enum.TextYAlignment.Top
CreditsText.Parent = Credits

--==================================================
-- TABS
--==================================================

local CurrentTab

local function CreateTab(text,y,page)

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-18,0,34)
	Button.Position = UDim2.fromOffset(9,y)
	Button.BackgroundColor3 = BLACK
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

		TweenService:Create(
			page,
			TweenInfo.new(
				0.18,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.Out
			),
			{
				Position = UDim2.new(0,0,0,0)
			}
		):Play()

	end

	Button.MouseButton1Click:Connect(Select)

	Button.MouseEnter:Connect(function()

		if not CurrentTab or CurrentTab.Button ~= Button then

			TweenService:Create(
				Button,
				TweenInfo.new(0.12),
				{
					BackgroundColor3 = WHITE,
					TextColor3 = BLACK
				}
			):Play()

		end

	end)

	Button.MouseLeave:Connect(function()

		if not CurrentTab or CurrentTab.Button ~= Button then

			TweenService:Create(
				Button,
				TweenInfo.new(0.12),
				{
					BackgroundColor3 = BLACK,
					TextColor3 = WHITE
				}
			):Play()

		end

	end)

	return {
		Button = Button,
		Indicator = Indicator,
		Select = Select
	}
end

local HomeTab = CreateTab("HOME",35,Home)
local FeaturesTab = CreateTab("FEATURES",75,Features)
local SettingsTab = CreateTab("SETTINGS",150,Settings)
local CreditsTab = CreateTab("CREDITS",190,Credits)

HomeTab.Select()

--==================================================
-- DRAG SYSTEM
--==================================================

local function MakeDraggable(object,handle)

	local dragging = false
	local dragStart
	local startPosition

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

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

		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

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

MakeDraggable(Main,Header)
MakeDraggable(Toggle,Toggle)

--==================================================
-- TOGGLE
--==================================================

local Open = true

Toggle.MouseButton1Click:Connect(function()

	Open = not Open

	if Open then

		Main.Visible = true
		Main.Size = UDim2.fromOffset(435,270)

		TweenService:Create(
			Main,
			TweenInfo.new(
				0.2,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.Out
			),
			{
				Size = UDim2.fromOffset(455,285)
			}
		):Play()

	else

		TweenService:Create(
			Main,
			TweenInfo.new(
				0.15,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.In
			),
			{
				Size = UDim2.fromOffset(435,270)
			}
		):Play()

		task.wait(0.15)
		Main.Visible = false

	end

end)

--==================================================
-- TOGGLE HOVER
--==================================================

Toggle.MouseEnter:Connect(function()

	TweenService:Create(
		Toggle,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = BLACK,
			TextColor3 = WHITE
		}
	):Play()

end)

Toggle.MouseLeave:Connect(function()

	TweenService:Create(
		Toggle,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = WHITE,
			TextColor3 = BLACK
		}
	):Play()

end)

print("IVORY HUB // LOADED")
