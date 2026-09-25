local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "IvoryHubNotice"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 190)
frame.Position = UDim2.new(0.5, -170, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BackgroundTransparency = 1
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 65, 75)
stroke.Thickness = 1.2
stroke.Transparency = 1
stroke.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 70)
title.Position = UDim2.new(0, 15, 0, 20)
title.BackgroundTransparency = 1
title.Text = "made a new script for ivory hub"
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextSize = 21
title.Font = Enum.Font.GothamSemibold
title.TextWrapped = true
title.TextTransparency = 1
title.Parent = frame

-- OK button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -50, 0, 45)
button.Position = UDim2.new(0, 25, 1, -60)
button.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
button.BackgroundTransparency = 1
button.Text = "OK"
button.TextColor3 = Color3.fromRGB(245, 245, 250)
button.TextSize = 16
button.Font = Enum.Font.GothamMedium
button.TextTransparency = 1
button.AutoButtonColor = false
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- Smooth fade in
local fadeIn = TweenInfo.new(
	0.45,
	Enum.EasingStyle.Quint,
	Enum.EasingDirection.Out
)

TweenService:Create(frame, fadeIn, {
	BackgroundTransparency = 0
}):Play()

TweenService:Create(stroke, fadeIn, {
	Transparency = 0
}):Play()

TweenService:Create(title, fadeIn, {
	TextTransparency = 0
}):Play()

TweenService:Create(button, fadeIn, {
	BackgroundTransparency = 0,
	TextTransparency = 0
}):Play()

-- Button hover
button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(52, 52, 60)
	}):Play()
end)

button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(38, 38, 45)
	}):Play()
end)

-- Close
button.MouseButton1Click:Connect(function()
	local fadeOut = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	)

	TweenService:Create(frame, fadeOut, {
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(stroke, fadeOut, {
		Transparency = 1
	}):Play()

	TweenService:Create(title, fadeOut, {
		TextTransparency = 1
	}):Play()

	TweenService:Create(button, fadeOut, {
		BackgroundTransparency = 1,
		TextTransparency = 1
	}):Play()

	task.wait(0.3)
	gui:Destroy()
end)
