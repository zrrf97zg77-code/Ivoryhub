--// IVORY HUB
--// PURE BLACK / PURE WHITE
--// Compact • Mobile • Draggable • Toggleable

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local BLACK = Color3.fromRGB(0,0,0)
local WHITE = Color3.fromRGB(255,255,255)

local GUI = Instance.new("ScreenGui")
GUI.Name = "IVORY"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = PlayerGui

local function Corner(obj,r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,r)
	c.Parent = obj
end

local function Stroke(obj)
	local s = Instance.new("UIStroke")
	s.Color = WHITE
	s.Thickness = 1
	s.Parent = obj
end

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(400,240)
Main.Position = UDim2.new(.5,-200,.5,-120)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Parent = GUI

Corner(Main,12)
Stroke(Main)

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,45)
Header.BackgroundColor3 = BLACK
Header.BorderSizePixel = 0
Header.Parent = Main

Corner(Header,12)

local Logo = Instance.new("TextButton")
Logo.Size = UDim2.fromOffset(31,31)
Logo.Position = UDim2.fromOffset(8,7)
Logo.BackgroundColor3 = WHITE
Logo.BorderSizePixel = 0
Logo.Text = "I"
Logo.TextColor3 = BLACK
Logo.TextSize = 17
Logo.Font = Enum.Font.GothamBlack
Logo.Parent = Header

Corner(Logo,8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromOffset(150,25)
Title.Position = UDim2.fromOffset(48,5)
Title.BackgroundTransparency = 1
Title.Text = "IVORY"
Title.TextColor3 = WHITE
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.fromOffset(180,15)
Subtitle.Position = UDim2.fromOffset(49,25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PURE MONOCHROME"
Subtitle.TextColor3 = WHITE
Subtitle.TextSize = 7
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

--==================================================
-- CLOSE
--==================================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(28,28)
Close.Position = UDim2.new(1,-37,0,8)
Close.BackgroundColor3 = BLACK
Close.BorderSizePixel = 1
Close.BorderColor3 = WHITE
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

Corner(Close,7)

Close.MouseEnter:Connect(function()
	TweenService:Create(Close,TweenInfo.new(.15),{
		BackgroundColor3 = WHITE,
		TextColor3 = BLACK
	}):Play()
end)

Close.MouseLeave:Connect(function()
	TweenService:Create(Close,TweenInfo.new(.15),{
		BackgroundColor3 = BLACK,
		TextColor3 = WHITE
	}):Play()
end)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-20,1,-58)
Content.Position = UDim2.fromOffset(10,52)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.Parent = Content

local function Button(text)

	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1,0,0,40)
	B.BackgroundColor3 = BLACK
	B.BorderSizePixel = 1
	B.BorderColor3 = WHITE
	B.Text = text
	B.TextColor3 = WHITE
	B.TextSize = 10
	B.Font = Enum.Font.GothamBold
	B.AutoButtonColor = false
	B.Parent = Content

	Corner(B,8)

	B.MouseEnter:Connect(function()
		TweenService:Create(B,TweenInfo.new(.15),{
			BackgroundColor3 = WHITE,
			TextColor3 = BLACK
		}):Play()
	end)

	B.MouseLeave:Connect(function()
		TweenService:Create(B,TweenInfo.new(.15),{
			BackgroundColor3 = BLACK,
			TextColor3 = WHITE
		}):Play()
	end)

	return B
end

local Home = Button("HOME")
local Features = Button("FEATURES")
local Settings = Button("SETTINGS")

--==================================================
-- FLOATING TOGGLE
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.fromOffset(48,48)
Toggle.Position = UDim2.new(0,20,.5,-24)
Toggle.BackgroundColor3 = BLACK
Toggle.BorderSizePixel = 1
Toggle.BorderColor3 = WHITE
Toggle.Text = "I"
Toggle.TextColor3 = WHITE
Toggle.TextSize = 20
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.Parent = GUI

Corner(Toggle,12)

--==================================================
-- TOGGLE ANIMATION
--==================================================

local Open = true

local function OpenHub()
	Open = true
	Main.Visible = true
	Main.Size = UDim2.fromOffset(0,0)

	TweenService:Create(
		Main,
		TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		{Size = UDim2.fromOffset(400,240)}
	):Play()
end

local function CloseHub()
	Open = false

	local Tween = TweenService:Create(
		Main,
		TweenInfo.new(.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),
		{Size = UDim2.fromOffset(0,0)}
	)

	Tween:Play()

	Tween.Completed:Connect(function()
		if not Open then
			Main.Visible = false
		end
	end)
end

Toggle.MouseButton1Click:Connect(function()
	if Open then
		CloseHub()
	else
		OpenHub()
	end
end)

Close.MouseButton1Click:Connect(CloseHub)

--==================================================
-- TOGGLE HOVER
--==================================================

Toggle.MouseEnter:Connect(function()
	TweenService:Create(Toggle,TweenInfo.new(.15),{
		BackgroundColor3 = WHITE,
		TextColor3 = BLACK
	}):Play()
end)

Toggle.MouseLeave:Connect(function()
	TweenService:Create(Toggle,TweenInfo.new(.15),{
		BackgroundColor3 = BLACK,
		TextColor3 = WHITE
	}):Play()
end)

--==================================================
-- DRAG FUNCTION
--==================================================

local function MakeDraggable(handle,object)

	local dragging = false
	local startPosition
	local startInput

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			startInput = input.Position
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

			local Delta = input.Position - startInput

			object.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + Delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + Delta.Y
			)
		end
	end)
end

MakeDraggable(Header,Main)
MakeDraggable(Toggle,Toggle)

print("IVORY HUB | PURE BLACK & WHITE | LOADED")
