--// IVORY HUB
--// Premium Black & White UI
--// UI FRAMEWORK — plug your own legitimate game functions into the buttons

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Remove old UI
local Old = PlayerGui:FindFirstChild("IvoryHub")
if Old then
	Old:Destroy()
end

--//==================================================
--// SETTINGS
--//==================================================

local WHITE = Color3.fromRGB(245,245,245)
local LIGHT = Color3.fromRGB(185,185,185)
local DARK = Color3.fromRGB(10,10,10)
local DARK2 = Color3.fromRGB(15,15,15)
local DARK3 = Color3.fromRGB(22,22,22)
local DARK4 = Color3.fromRGB(30,30,30)

local TweenFast = TweenInfo.new(.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenSmooth = TweenInfo.new(.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

--//==================================================
--// HELPERS
--//==================================================

local function New(class, props, parent)
	local obj = Instance.new(class)

	for property, value in pairs(props or {}) do
		obj[property] = value
	end

	obj.Parent = parent
	return obj
end

local function Corner(parent, radius)
	return New("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, parent)
end

local function Stroke(parent, color, transparency, thickness)
	return New("UIStroke", {
		Color = color,
		Transparency = transparency or 0,
		Thickness = thickness or 1
	}, parent)
end

local function Tween(object, info, properties)
	return TweenService:Create(object, info, properties)
end

--//==================================================
--// SCREEN GUI
--//==================================================

local Screen = New("ScreenGui", {
	Name = "IvoryHub",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--//==================================================
--// INTRO
--//==================================================

local Intro = New("Frame", {
	Size = UDim2.fromScale(1,1),
	BackgroundColor3 = DARK,
	BorderSizePixel = 0,
	ZIndex = 100
}, Screen)

local IntroTitle = New("TextLabel", {
	Size = UDim2.fromOffset(500,80),
	Position = UDim2.new(.5,-250,.5,-55),
	BackgroundTransparency = 1,
	Text = "IVORY",
	TextColor3 = WHITE,
	TextTransparency = 1,
	TextSize = 48,
	Font = Enum.Font.GothamBlack,
	ZIndex = 101
}, Intro)

local IntroLine = New("Frame", {
	Size = UDim2.fromOffset(0,2),
	Position = UDim2.new(.5,0,.5,35),
	AnchorPoint = Vector2.new(.5,.5),
	BackgroundColor3 = WHITE,
	BorderSizePixel = 0,
	ZIndex = 101
}, Intro)

local IntroSub = New("TextLabel", {
	Size = UDim2.fromOffset(400,30),
	Position = UDim2.new(.5,-200,.5,48),
	BackgroundTransparency = 1,
	Text = "PREMIUM INTERFACE",
	TextColor3 = LIGHT,
	TextTransparency = 1,
	TextSize = 11,
	Font = Enum.Font.GothamMedium,
	ZIndex = 101
}, Intro)

task.spawn(function()
	Tween(IntroTitle,TweenSmooth,{
		TextTransparency = 0
	}):Play()

	task.wait(.15)

	Tween(IntroLine,TweenSmooth,{
		Size = UDim2.fromOffset(180,2)
	}):Play()

	task.wait(.15)

	Tween(IntroSub,TweenSmooth,{
		TextTransparency = 0
	}):Play()

	task.wait(.8)

	Tween(Intro,TweenSmooth,{
		BackgroundTransparency = 1
	}):Play()

	task.wait(.35)
	Intro:Destroy()
end)

--//==================================================
--// MAIN WINDOW
--//==================================================

local Main = New("Frame", {
	Size = UDim2.fromOffset(620,390),
	Position = UDim2.new(.5,-310,.5,-195),
	BackgroundColor3 = DARK2,
	BorderSizePixel = 0,
	ClipsDescendants = true
}, Screen)

Corner(Main,18)
Stroke(Main,WHITE,.82,1)

--// Shadow
local Shadow = New("ImageLabel", {
	Size = UDim2.new(1,50,1,50),
	Position = UDim2.fromOffset(-25,-25),
	BackgroundTransparency = 1,
	Image = "rbxassetid://1316045217",
	ImageTransparency = .65,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(10,10,118,118),
	ZIndex = 0
}, Main)

--//==================================================
--// TOP BAR
--//==================================================

local Top = New("Frame", {
	Size = UDim2.new(1,0,0,58),
	BackgroundColor3 = DARK,
	BorderSizePixel = 0
}, Main)

Corner(Top,18)

local Logo = New("TextLabel", {
	Size = UDim2.fromOffset(45,45),
	Position = UDim2.fromOffset(10,7),
	BackgroundColor3 = WHITE,
	Text = "I",
	TextColor3 = DARK,
	TextSize = 23,
	Font = Enum.Font.GothamBlack
}, Top)

Corner(Logo,12)

local Title = New("TextLabel", {
	Size = UDim2.fromOffset(180,30),
	Position = UDim2.fromOffset(66,7),
	BackgroundTransparency = 1,
	Text = "IVORY",
	TextColor3 = WHITE,
	TextSize = 18,
	Font = Enum.Font.GothamBlack,
	TextXAlignment = Enum.TextXAlignment.Left
}, Top)

local Version = New("TextLabel", {
	Size = UDim2.fromOffset(180,20),
	Position = UDim2.fromOffset(67,31),
	BackgroundTransparency = 1,
	Text = "PREMIUM • v1.0",
	TextColor3 = LIGHT,
	TextSize = 9,
	Font = Enum.Font.GothamMedium,
	TextXAlignment = Enum.TextXAlignment.Left
}, Top)

--// Status
local Status = New("Frame", {
	Size = UDim2.fromOffset(105,32),
	Position = UDim2.new(1,-115,0,13),
	BackgroundColor3 = DARK3,
	BorderSizePixel = 0
}, Top)

Corner(Status,10)
Stroke(Status,WHITE,.9,1)

local Dot = New("Frame", {
	Size = UDim2.fromOffset(7,7),
	Position = UDim2.fromOffset(11,12),
	BackgroundColor3 = WHITE,
	BorderSizePixel = 0
}, Status)

Corner(Dot,99)

local StatusText = New("TextLabel", {
	Size = UDim2.fromOffset(75,30),
	Position = UDim2.fromOffset(25,1),
	BackgroundTransparency = 1,
	Text = "ONLINE",
	TextColor3 = WHITE,
	TextSize = 10,
	Font = Enum.Font.GothamBold
}, Status)

--//==================================================
--// SIDEBAR
--//==================================================

local Sidebar = New("Frame", {
	Size = UDim2.new(0,145,1,-70),
	Position = UDim2.fromOffset(10,65),
	BackgroundColor3 = DARK,
	BorderSizePixel = 0
}, Main)

Corner(Sidebar,14)

local SideLayout = New("UIListLayout", {
	Padding = UDim.new(0,7),
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

New("UIPadding", {
	PaddingTop = UDim.new(0,12)
}, Sidebar)

local Pages = New("Frame", {
	Size = UDim2.new(1,-175,1,-70),
	Position = UDim2.fromOffset(165,65),
	BackgroundTransparency = 1
}, Main)

--//==================================================
--// PAGE SYSTEM
--//==================================================

local CurrentPage

local function CreatePage(name)
	local Page = New("ScrollingFrame", {
		Name = name,
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = WHITE,
		Visible = false,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, Pages)

	New("UIPadding", {
		PaddingTop = UDim.new(0,4),
		PaddingBottom = UDim.new(0,10),
		PaddingLeft = UDim.new(0,3),
		PaddingRight = UDim.new(0,8)
	}, Page)

	New("UIListLayout", {
		Padding = UDim.new(0,9),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, Page)

	return Page
end

local Home = CreatePage("Home")
local Features = CreatePage("Features")
local Settings = CreatePage("Settings")
local Info = CreatePage("Info")

--//==================================================
--// SIDEBAR BUTTON
--//==================================================

local function SidebarButton(text, icon, page)
	local Button = New("TextButton", {
		Size = UDim2.fromOffset(125,42),
		BackgroundColor3 = DARK,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false
	}, Sidebar)

	Corner(Button,10)

	local Icon = New("TextLabel", {
		Size = UDim2.fromOffset(30,42),
		Position = UDim2.fromOffset(5,0),
		BackgroundTransparency = 1,
		Text = icon,
		TextColor3 = LIGHT,
		TextSize = 15,
		Font = Enum.Font.GothamBold
	}, Button)

	local Label = New("TextLabel", {
		Size = UDim2.new(1,-40,1,0),
		Position = UDim2.fromOffset(38,0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = LIGHT,
		TextSize = 11,
		Font = Enum.Font.GothamSemibold,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Button)

	Button.MouseEnter:Connect(function()
		Tween(Button,TweenFast,{
			BackgroundColor3 = DARK3
		}):Play()

		Tween(Icon,TweenFast,{
			TextColor3 = WHITE
		}):Play()

		Tween(Label,TweenFast,{
			TextColor3 = WHITE
		}):Play()
	end)

	Button.MouseLeave:Connect(function()
		if CurrentPage ~= page then
			Tween(Button,TweenFast,{
				BackgroundColor3 = DARK
			}):Play()

			Tween(Icon,TweenFast,{
				TextColor3 = LIGHT
			}):Play()

			Tween(Label,TweenFast,{
				TextColor3 = LIGHT
			}):Play()
		end
	end)

	Button.MouseButton1Click:Connect(function()

		for _, child in ipairs(Sidebar:GetChildren()) do
			if child:IsA("TextButton") then
				Tween(child,TweenFast,{
					BackgroundColor3 = DARK
				}):Play()
			end
		end

		for _, child in ipairs(Pages:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = false
			end
		end

		Button.BackgroundColor3 = DARK4
		page.Visible = true
		CurrentPage = page
	end)

	return Button
end

SidebarButton("Home","⌂",Home)
SidebarButton("Features","◇",Features)
SidebarButton("Settings","⚙",Settings)
SidebarButton("Info","i",Info)

--//==================================================
--// CARDS
--//==================================================

local function Card(parent,title,description)
	local Frame = New("Frame", {
		Size = UDim2.new(1,0,0,72),
		BackgroundColor3 = DARK,
		BorderSizePixel = 0
	}, parent)

	Corner(Frame,12)
	Stroke(Frame,WHITE,.9,1)

	New("TextLabel", {
		Size = UDim2.new(1,-25,0,25),
		Position = UDim2.fromOffset(13,9),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = WHITE,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Frame)

	New("TextLabel", {
		Size = UDim2.new(1,-25,0,30),
		Position = UDim2.fromOffset(13,34),
		BackgroundTransparency = 1,
		Text = description,
		TextColor3 = LIGHT,
		TextSize = 10,
		Font = Enum.Font.GothamMedium,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	}, Frame)

	return Frame
end

--// HOME
Card(Home,"Welcome to Ivory","A clean monochrome interface built for a smooth Roblox experience.")
Card(Home,"SYSTEM STATUS","All interface systems are initialized and ready.")
Card(Home,"DESIGN","Minimal. Sharp. Black. White. Ivory.")

--//==================================================
--// FEATURE BUTTON
--//==================================================

local function Feature(parent,title,description,callback)
	local Button = New("TextButton", {
		Size = UDim2.new(1,0,0,66),
		BackgroundColor3 = DARK,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false
	}, parent)

	Corner(Button,12)
	Stroke(Button,WHITE,.9,1)

	local Accent = New("Frame", {
		Size = UDim2.fromOffset(3,36),
		Position = UDim2.fromOffset(10,15),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0
	}, Button)

	Corner(Accent,4)

	New("TextLabel", {
		Size = UDim2.new(1,-40,0,24),
		Position = UDim2.fromOffset(25,8),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = WHITE,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Button)

	New("TextLabel", {
		Size = UDim2.new(1,-45,0,22),
		Position = UDim2.fromOffset(25,33),
		BackgroundTransparency = 1,
		Text = description,
		TextColor3 = LIGHT,
		TextSize = 9,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Button)

	Button.MouseEnter:Connect(function()
		Tween(Button,TweenFast,{
			BackgroundColor3 = DARK3
		}):Play()

		Tween(Accent,TweenFast,{
			Size = UDim2.fromOffset(5,36)
		}):Play()
	end)

	Button.MouseLeave:Connect(function()
		Tween(Button,TweenFast,{
			BackgroundColor3 = DARK
		}):Play()

		Tween(Accent,TweenFast,{
			Size = UDim2.fromOffset(3,36)
		}):Play()
	end)

	Button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	return Button
end

Feature(
	Features,
	"TEST BUTTON",
	"Example feature slot",
	function()
		print("[IVORY] Test button activated.")
	end
)

Feature(
	Features,
	"NOTIFICATION",
	"Test the Ivory notification system",
	function()
		-- Notification created below
	end
)

Feature(
	Features,
	"RESET UI",
	"Return the interface to its default state",
	function()
		print("[IVORY] UI reset.")
	end
)

--// SETTINGS
Card(Settings,"INTERFACE","Ivory uses a monochrome black & white visual system.")
Card(Settings,"MOBILE SUPPORT","Touch input and draggable controls are enabled.")
Card(Settings,"ANIMATIONS","Smooth transitions are built into the interface.")

--// INFO
Card(Info,"IVORY HUB","Premium monochrome Roblox interface.")
Card(Info,"VERSION","Ivory UI Framework • 1.0")
Card(Info,"STATUS","ONLINE")

--//==================================================
--// NOTIFICATION SYSTEM
--//==================================================

local Notifications = New("Frame", {
	Size = UDim2.fromOffset(280,400),
	Position = UDim2.new(1,-300,0,25),
	BackgroundTransparency = 1
}, Screen)

New("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Top,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0,8)
}, Notifications)

local function Notify(title,text)
	local Note = New("Frame", {
		Size = UDim2.fromOffset(0,62),
		BackgroundColor3 = DARK,
		BorderSizePixel = 0
	}, Notifications)

	Corner(Note,12)
	Stroke(Note,WHITE,.8,1)

	local Bar = New("Frame", {
		Size = UDim2.fromOffset(3,38),
		Position = UDim2.fromOffset(10,12),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0
	}, Note)

	Corner(Bar,5)

	New("TextLabel", {
		Size = UDim2.new(1,-35,0,22),
		Position = UDim2.fromOffset(22,8),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = WHITE,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Note)

	New("TextLabel", {
		Size = UDim2.new(1,-35,0,20),
		Position = UDim2.fromOffset(22,30),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = LIGHT,
		TextSize = 9,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Note)

	Tween(Note,TweenSmooth,{
		Size = UDim2.fromOffset(280,62)
	}):Play()

	task.delay(3,function()
		local out = Tween(Note,TweenSmooth,{
			Size = UDim2.fromOffset(0,62)
		})

		out:Play()

		out.Completed:Connect(function()
			Note:Destroy()
		end)
	end)
end

--//==================================================
--// FLOATING IVORY BUTTON
--//==================================================

local Float = New("TextButton", {
	Size = UDim2.fromOffset(58,58),
	Position = UDim2.new(0,25,.5,-29),
	BackgroundColor3 = DARK,
	BorderSizePixel = 0,
	Text = "I",
	TextColor3 = WHITE,
	TextSize = 24,
	Font = Enum.Font.GothamBlack,
	AutoButtonColor = false,
	ZIndex = 20
}, Screen)

Corner(Float,18)
Stroke(Float,WHITE,.65,1)

local FloatScale = New("UIScale",{},Float)

Float.MouseButton1Click:Connect(function()

	if Main.Visible then
		Tween(Main,TweenSmooth,{
			Size = UDim2.fromOffset(0,0)
		}):Play()

		task.delay(.3,function()
			Main.Visible = false
		end)
	else
		Main.Visible = true
		Main.Size = UDim2.fromOffset(0,0)

		Tween(Main,TweenSmooth,{
			Size = UDim2.fromOffset(620,390)
		}):Play()
	end
end)

Float.MouseEnter:Connect(function()
	Tween(FloatScale,TweenFast,{
		Scale = 1.08
	}):Play()
end)

Float.MouseLeave:Connect(function()
	Tween(FloatScale,TweenFast,{
		Scale = 1
	}):Play()
end)

--//==================================================
--// DRAGGING
--//==================================================

local function MakeDraggable(handle,object)

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

		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart

		object.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

MakeDraggable(Top,Main)
MakeDraggable(Float,Float)

--//==================================================
--// INITIAL PAGE
--//==================================================

Home.Visible = true
CurrentPage = Home

--//==================================================
--// STARTUP
--//==================================================

task.delay(1.5,function()
	Notify("IVORY HUB","Interface initialized successfully.")
end)

print("================================")
print("       IVORY HUB LOADED")
print("       BLACK & WHITE UI")
print("================================")
