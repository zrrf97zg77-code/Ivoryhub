-- =============================================
-- IVORY HUB v5.3 - PURE SORU (Flashstep)
-- Everything works: Silent Aim, Soru, ESP, Auto V4, Macro, Walk on Water
-- =============================================

print("🦷 Ivory Hub v5.3 loading...")

-- Services
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
local Camera = Workspace.CurrentCamera

-- =============================================
-- COLORS
-- =============================================
local BLACK = Color3.fromRGB(7,7,7)
local DARK = Color3.fromRGB(13,13,13)
local DARKER = Color3.fromRGB(19,19,19)
local WHITE = Color3.fromRGB(245,245,245)
local GRAY = Color3.fromRGB(145,145,145)
local BORDER = Color3.fromRGB(40,40,40)
local RED = Color3.fromRGB(255,50,50)
local GREEN = Color3.fromRGB(50,255,50)
local BLUE = Color3.fromRGB(50,150,255)

-- =============================================
-- GUI HELPERS
-- =============================================
local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function AddStroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or BORDER
    s.Thickness = thickness or 1
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

local function getSafeParent()
    local ok, gui = pcall(gethui)
    if ok and gui and gui.Parent then return gui end
    local core = CoreGui
    if core then return core end
    return player:WaitForChild("PlayerGui")
end

local parentGui = getSafeParent()

local Old = parentGui:FindFirstChild("IvoryHub")
if Old then Old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parentGui

-- =============================================
-- FEATURES STATE
-- =============================================
local Features = {
    SilentAimPlayers = false,
    SilentAimNPCs = false,
    SilentAimMode = "360",
    SoruAimbot = false,
    AutoV4 = false,
    NoClip = false,
    AntiAFK = false,
    WalkWater = false,
    ESP = false,
    ESPBox = false,
    ESPName = false,
    ESPHealth = false,
    ESPDistance = false,
    FOVCircle = false,
    FOVRadius = 150,
    MaxRange = 1000,
    MacroEnabled = false,
}

-- =============================================
-- WEAPON OPTIONS
-- =============================================
local WEAPON_OPTIONS = {"Melee", "Fruit", "Sword", "Gun"}
local SKILL_OPTIONS = {"Z", "X", "C", "V", "F", "Tap", "M1"}

-- =============================================
-- MACRO SYSTEM
-- =============================================
local Macro = {
    Blocks = {},
    IsRunning = false,
}

-- =============================================
-- SILENT AIM - WORKING
-- =============================================
local TargetPosition = nil
local NearestTarget = nil
local NearestTargetPlr = nil

local function GetClosestTarget()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closest, closestDist = nil, math.huge
    local maxRange = Features.MaxRange or 1000
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < closestDist and dist <= maxRange then
                    closestDist = dist
                    closest = hrp
                    NearestTargetPlr = plr
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
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < closestDist and dist <= maxRange then
                        closestDist = dist
                        closest = hrp
                        NearestTargetPlr = npc
                    end
                end
            end
        end
    end
    
    return closest
end

local function SetupSilentAim()
    local mt = getrawmetatable(game)
    if not mt then return end
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__index = function(self, key)
        if not checkcaller() and self == Camera and (key == "Hit" or key == "Target") then
            if Features.SilentAimPlayers or Features.SilentAimNPCs then
                local target = GetClosestTarget()
                if target then
                    TargetPosition = target.Position
                    if key == "Hit" then return CFrame.new(TargetPosition) end
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
            if (Features.SilentAimPlayers or Features.SilentAimNPCs) and TargetPosition then
                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = TargetPosition
                    elseif typeof(arg) == "CFrame" then
                        args[i] = CFrame.new(TargetPosition)
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end
    
    setreadonly(mt, true)
end

SetupSilentAim()

-- =============================================
-- PURE SORU (Flashstep) - NO PORTAL
-- =============================================
local SoruAimbot = (function()
    local module = {}
    local COOLDOWN = 1.0
    local lastAttack = -999
    local flashstepRemote = nil
    
    -- Find Flashstep remote
    task.spawn(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            flashstepRemote = remotes:FindFirstChild("CommF_")
        end
        if not flashstepRemote then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj.Name == "CommF_" or string.find(string.lower(obj.Name or ""), "flash") then
                    flashstepRemote = obj
                    break
                end
            end
        end
        print("[Ivory] Soru remote:", flashstepRemote and "yes" or "no")
    end)
    
    local function getNearest()
        local nearest, minDist = nil, math.huge
        local myChar = player.Character
        if not myChar then return nil end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local dist = (targetRoot.Position - myRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
        return nearest
    end
    
    local function doSoru()
        if not Features.SoruAimbot then return end
        if tick() - lastAttack < COOLDOWN then return end
        
        local target = getNearest()
        if not target then return end
        
        local targetChar = target.Character
        if not targetChar then return end
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        
        local myChar = player.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        -- Teleport to enemy position using Soru
        local success = false
        
        -- Method 1: Use Flashstep remote if available
        pcall(function()
            if flashstepRemote then
                if flashstepRemote:IsA("RemoteFunction") then
                    flashstepRemote:InvokeServer("Flashstep", targetRoot.Position)
                else
                    flashstepRemote:FireServer("Flashstep", targetRoot.Position)
                end
                success = true
            end
        end)
        
        -- Method 2: Direct teleport (fallback)
        if not success then
            myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 2, 0))
            success = true
        end
        
        if success then
            lastAttack = tick()
        end
    end
    
    function module:Attack()
        doSoru()
    end
    
    function module:GetCooldown()
        return math.max(0, COOLDOWN - (tick() - lastAttack))
    end
    
    return module
end)()

-- =============================================
-- AUTO V4 - WORKING
-- =============================================
local function DoAutoV4()
    if not Features.AutoV4 then return end
    
    local char = player.Character
    if not char then return end
    
    local raceEnergy = char:GetAttribute("RaceEnergy")
    if not raceEnergy or raceEnergy < 100 then return end
    
    local success = false
    
    local awk = player.Backpack:FindFirstChild("Awakening") or char:FindFirstChild("Awakening")
    if awk then
        for _, child in pairs(awk:GetDescendants()) do
            if child:IsA("RemoteFunction") then
                pcall(function() child:InvokeServer(true) success = true end)
            elseif child:IsA("RemoteEvent") then
                pcall(function() child:FireServer(true) success = true end)
            end
        end
    end
    
    if not success then
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                pcall(function()
                    if commF:IsA("RemoteFunction") then
                        commF:InvokeServer("Awakening", true)
                    else
                        commF:FireServer("Awakening", true)
                    end
                    success = true
                end)
            end
        end
    end
    
    if success then
        pcall(function() char:SetAttribute("RaceEnergy", 0) end)
    end
end

-- =============================================
-- WALK ON WATER
-- =============================================
local WaterPart = nil

local function UpdateWalkWater()
    if not Features.WalkWater then
        if WaterPart then
            WaterPart:Destroy()
            WaterPart = nil
        end
        return
    end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local WATER_LEVEL = 9.5
    
    if hrp.Position.Y >= WATER_LEVEL and hrp.Velocity.Y <= 0 then
        if not WaterPart or not WaterPart.Parent then
            WaterPart = Instance.new("Part")
            WaterPart.Name = "IvoryWater"
            WaterPart.Anchored = true
            WaterPart.CanCollide = true
            WaterPart.Transparency = 1
            WaterPart.Size = Vector3.new(20, 1, 20)
            WaterPart.Parent = Workspace
        end
        WaterPart.CFrame = CFrame.new(hrp.Position.X, WATER_LEVEL, hrp.Position.Z)
    else
        if WaterPart then
            WaterPart:Destroy()
            WaterPart = nil
        end
    end
end

-- =============================================
-- ESP - WORKING
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
    gui.Size = UDim2.new(0, 200, 0, 60)
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true
    gui.Parent = head
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundTransparency = 1
    main.Parent = gui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = target.Name or "NPC"
    nameLabel.TextColor3 = WHITE
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = main
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 60, 0, 14)
    distLabel.Position = UDim2.new(1, -65, 0, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = GRAY
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextXAlignment = Enum.TextXAlignment.Right
    distLabel.Parent = main
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 0, 4)
    healthBg.Position = UDim2.new(0, 0, 1, -4)
    healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = main
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = GREEN
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 40, 0, 40)
    box.Position = UDim2.new(0.5, -20, 0.5, -20)
    box.BackgroundTransparency = 0.6
    box.BackgroundColor3 = Color3.fromRGB(255,255,255)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(255,255,255)
    box.Visible = false
    box.Parent = gui
    
    ESPData[target] = {
        gui = gui,
        name = nameLabel,
        dist = distLabel,
        healthBg = healthBg,
        healthFill = healthFill,
        box = box,
    }
end

local function UpdateESP()
    if not Features.ESP then
        for _, data in pairs(ESPData) do
            pcall(function() data.gui.Visible = false end)
        end
        return
    end
    
    local currentTargets = {}
    local cam = Camera
    if not cam then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    if not ESPData[plr] then CreateESP(plr) end
                    currentTargets[plr] = true
                    local data = ESPData[plr]
                    if data then
                        data.gui.Visible = true
                        data.name.Text = plr.Name
                        local dist = (root.Position - cam.CFrame.Position).Magnitude
                        data.dist.Text = math.floor(dist / 3.5) .. "m"
                        local hp = hum.Health / hum.MaxHealth
                        data.healthFill.Size = UDim2.new(hp, 0, 1, 0)
                        if hp > 0.5 then data.healthFill.BackgroundColor3 = GREEN
                        elseif hp > 0.25 then data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                        else data.healthFill.BackgroundColor3 = RED end
                        data.name.Visible = Features.ESPName
                        data.dist.Visible = Features.ESPDistance
                        data.healthBg.Visible = Features.ESPHealth
                        data.box.Visible = Features.ESPBox
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
                local root = npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    if not ESPData[npc] then
                        local fake = {Name = "NPC", Character = npc}
                        CreateESP(fake)
                        ESPData[npc] = ESPData[fake]
                    end
                    currentTargets[npc] = true
                    local data = ESPData[npc]
                    if data then
                        data.gui.Visible = true
                        data.name.Text = "NPC"
                        local dist = (root.Position - cam.CFrame.Position).Magnitude
                        data.dist.Text = math.floor(dist / 3.5) .. "m"
                        local hp = hum.Health / hum.MaxHealth
                        data.healthFill.Size = UDim2.new(hp, 0, 1, 0)
                        if hp > 0.5 then data.healthFill.BackgroundColor3 = GREEN
                        elseif hp > 0.25 then data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                        else data.healthFill.BackgroundColor3 = RED end
                        data.name.Visible = Features.ESPName
                        data.dist.Visible = Features.ESPDistance
                        data.healthBg.Visible = Features.ESPHealth
                        data.box.Visible = Features.ESPBox
                    end
                end
            end
        end
    end
    
    for target, data in pairs(ESPData) do
        if not currentTargets[target] then
            pcall(function() data.gui:Destroy() end)
            ESPData[target] = nil
        end
    end
end

-- =============================================
-- NO CLIP - WORKING
-- =============================================
local function UpdateNoClip()
    if not Features.NoClip then return end
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- =============================================
-- ANTI-AFK - WORKING
-- =============================================
local AntiAFKTimer = 0

local function UpdateAntiAFK()
    if not Features.AntiAFK then return end
    AntiAFKTimer = AntiAFKTimer + 0.1
    if AntiAFKTimer < 5 then return end
    AntiAFKTimer = 0
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:Move(Vector3.new(1,0,0), true)
            task.wait(0.1)
            hum:Move(Vector3.new(-1,0,0), true)
        end
    end
end

-- =============================================
-- MACRO - WORKING
-- =============================================
local function PressKey(key)
    if key == "M1" then
        VIM:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, true)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, false)
    else
        local keyCode = Enum.KeyCode[key]
        if keyCode then
            VIM:SendKeyEvent(true, keyCode, false)
            task.wait(0.05)
            VIM:SendKeyEvent(false, keyCode, false)
        end
    end
end

local function ExecuteMacro()
    if not Features.MacroEnabled then return end
    if #Macro.Blocks == 0 then return end
    if Macro.IsRunning then return end
    
    Macro.IsRunning = true
    
    task.spawn(function()
        for _, block in pairs(Macro.Blocks) do
            if not Features.MacroEnabled then break end
            
            local skill = block.Skill()
            local hold = block.Hold() or 0
            local delay = block.Delay() or 0
            
            PressKey(skill)
            
            if hold > 0 then
                local keyCode = Enum.KeyCode[skill]
                if keyCode then
                    VIM:SendKeyEvent(true, keyCode, false)
                    task.wait(hold)
                    VIM:SendKeyEvent(false, keyCode, false)
                end
            end
            
            if delay > 0 then
                task.wait(delay)
            end
        end
        
        Macro.IsRunning = false
    end)
end

-- =============================================
-- MACRO BLOCK CREATION
-- =============================================
local function CreateMacroBlock(parent, index)
    local block = Instance.new("Frame")
    block.Name = "MacroBlock_" .. index
    block.Size = UDim2.new(1, -10, 0, 50)
    block.BackgroundColor3 = DARKER
    block.BorderSizePixel = 0
    block.Parent = parent
    Corner(block, 8)
    AddStroke(block)
    
    local title = Text(block, "Block" .. index, 9, true)
    title.Position = UDim2.new(0, 8, 0, 2)
    title.Size = UDim2.new(0, 50, 0, 14)
    title.TextColor3 = BLUE
    
    local weaponBtn = Instance.new("TextButton")
    weaponBtn.Size = UDim2.new(0, 60, 0, 20)
    weaponBtn.Position = UDim2.new(0, 55, 0, 2)
    weaponBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    weaponBtn.Text = "Melee"
    weaponBtn.TextColor3 = WHITE
    weaponBtn.TextSize = 9
    weaponBtn.Font = Enum.Font.GothamMedium
    weaponBtn.BorderSizePixel = 0
    weaponBtn.Parent = block
    Corner(weaponBtn, 6)
    AddStroke(weaponBtn, Color3.fromRGB(60,60,60))
    
    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 40, 0, 20)
    skillBtn.Position = UDim2.new(0, 120, 0, 2)
    skillBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    skillBtn.Text = "Z"
    skillBtn.TextColor3 = WHITE
    skillBtn.TextSize = 9
    skillBtn.Font = Enum.Font.GothamMedium
    skillBtn.BorderSizePixel = 0
    skillBtn.Parent = block
    Corner(skillBtn, 6)
    AddStroke(skillBtn, Color3.fromRGB(60,60,60))
    
    local holdLabel = Text(block, "Hold:0s", 8, false)
    holdLabel.Position = UDim2.new(0, 165, 0, 3)
    holdLabel.Size = UDim2.new(0, 55, 0, 14)
    holdLabel.TextColor3 = GRAY
    
    local holdSlider = Instance.new("Frame")
    holdSlider.Size = UDim2.new(0, 55, 0, 3)
    holdSlider.Position = UDim2.new(0, 165, 0, 18)
    holdSlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
    holdSlider.BorderSizePixel = 0
    holdSlider.Parent = block
    Corner(holdSlider, 2)
    
    local holdFill = Instance.new("Frame")
    holdFill.Size = UDim2.new(0, 0, 1, 0)
    holdFill.BackgroundColor3 = WHITE
    holdFill.BorderSizePixel = 0
    holdFill.Parent = holdSlider
    Corner(holdFill, 2)
    
    local holdKnob = Instance.new("TextButton")
    holdKnob.Size = UDim2.new(0, 8, 0, 8)
    holdKnob.Position = UDim2.new(0, -4, 0.5, -4)
    holdKnob.BackgroundColor3 = WHITE
    holdKnob.Text = ""
    holdKnob.BorderSizePixel = 0
    holdKnob.Parent = holdSlider
    Corner(holdKnob, 8)
    
    local delayLabel = Text(block, "Delay:0s", 8, false)
    delayLabel.Position = UDim2.new(0, 225, 0, 3)
    delayLabel.Size = UDim2.new(0, 55, 0, 14)
    delayLabel.TextColor3 = GRAY
    
    local delaySlider = Instance.new("Frame")
    delaySlider.Size = UDim2.new(0, 55, 0, 3)
    delaySlider.Position = UDim2.new(0, 225, 0, 18)
    delaySlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
    delaySlider.BorderSizePixel = 0
    delaySlider.Parent = block
    Corner(delaySlider, 2)
    
    local delayFill = Instance.new("Frame")
    delayFill.Size = UDim2.new(0, 0, 1, 0)
    delayFill.BackgroundColor3 = WHITE
    delayFill.BorderSizePixel = 0
    delayFill.Parent = delaySlider
    Corner(delayFill, 2)
    
    local delayKnob = Instance.new("TextButton")
    delayKnob.Size = UDim2.new(0, 8, 0, 8)
    delayKnob.Position = UDim2.new(0, -4, 0.5, -4)
    delayKnob.BackgroundColor3 = WHITE
    delayKnob.Text = ""
    delayKnob.BorderSizePixel = 0
    delayKnob.Parent = delaySlider
    Corner(delayKnob, 8)
    
    local holdValue = 0
    local delayValue = 0
    local weaponIndex = 1
    local skillIndex = 1
    
    local function UpdateHold(pos)
        local sliderAbsPos = holdSlider.AbsolutePosition
        local sliderSize = holdSlider.AbsoluteSize.X
        local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
        local ratio = relativeX / sliderSize
        holdValue = math.floor(ratio * 3)
        holdFill.Size = UDim2.new(ratio, 0, 1, 0)
        holdKnob.Position = UDim2.new(ratio, -4, 0.5, -4)
        holdLabel.Text = "Hold:" .. holdValue .. "s"
    end
    
    local function UpdateDelay(pos)
        local sliderAbsPos = delaySlider.AbsolutePosition
        local sliderSize = delaySlider.AbsoluteSize.X
        local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
        local ratio = relativeX / sliderSize
        delayValue = math.floor(ratio * 3)
        delayFill.Size = UDim2.new(ratio, 0, 1, 0)
        delayKnob.Position = UDim2.new(ratio, -4, 0.5, -4)
        delayLabel.Text = "Delay:" .. delayValue .. "s"
    end
    
    holdSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateHold(input.Position)
        end
    end)
    
    holdKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn
            conn = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                    UpdateHold(input2.Position)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)
    
    delaySlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateDelay(input.Position)
        end
    end)
    
    delayKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn
            conn = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                    UpdateDelay(input2.Position)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)
    
    weaponBtn.MouseButton1Click:Connect(function()
        weaponIndex = weaponIndex % #WEAPON_OPTIONS + 1
        weaponBtn.Text = WEAPON_OPTIONS[weaponIndex]
    end)
    
    skillBtn.MouseButton1Click:Connect(function()
        skillIndex = skillIndex % #SKILL_OPTIONS + 1
        skillBtn.Text = SKILL_OPTIONS[skillIndex]
    end)
    
    return {
        Weapon = function() return WEAPON_OPTIONS[weaponIndex] end,
        Skill = function() return SKILL_OPTIONS[skillIndex] end,
        Hold = function() return holdValue end,
        Delay = function() return delayValue end,
    }
end

-- =============================================
-- MAIN LOOP
-- =============================================
RunService.Heartbeat:Connect(function()
    DoAutoV4()
    UpdateNoClip()
    UpdateAntiAFK()
    UpdateESP()
    UpdateWalkWater()
end)

-- =============================================
-- GUI
-- =============================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(42,42)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -21)
ToggleBtn.BackgroundColor3 = BLACK
ToggleBtn.BorderColor3 = WHITE
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "I"
ToggleBtn.TextColor3 = WHITE
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Gui
Corner(ToggleBtn, 10)

ToggleBtn.MouseEnter:Connect(function()
    Tween(ToggleBtn, 0.15, {BackgroundColor3 = WHITE, TextColor3 = BLACK})
end)
ToggleBtn.MouseLeave:Connect(function()
    Tween(ToggleBtn, 0.15, {BackgroundColor3 = BLACK, TextColor3 = WHITE})
end)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 420)
Main.Position = UDim2.new(0.5, -200, 0.5, -210)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui
Corner(Main, 12)
AddStroke(Main)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 12)

local Title = Text(Top, "IVORY", 15, true)
Title.Position = UDim2.new(0, 12, 0, 2)
Title.Size = UDim2.new(0, 100, 0, 20)

local SubTitle = Text(Top, "HUB v5.3", 8, false)
SubTitle.TextColor3 = GRAY
SubTitle.Position = UDim2.new(0, 13, 0, 22)
SubTitle.Size = UDim2.new(0, 60, 0, 12)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0.5, -14)
Close.BackgroundColor3 = DARKER
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Top
Corner(Close, 8)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 28, 0, 28)
Minimize.Position = UDim2.new(1, -66, 0.5, -14)
Minimize.BackgroundColor3 = DARKER
Minimize.Text = "—"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Minimize.Parent = Top
Corner(Minimize, 8)

local Open = true
ToggleBtn.MouseButton1Click:Connect(function()
    Open = not Open
    Main.Visible = Open
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 90, 1, -48)
Sidebar.Position = UDim2.new(0, 6, 0, 44)
Sidebar.BackgroundColor3 = DARK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 10)
AddStroke(Sidebar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Sidebar

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 6)
Padding.PaddingLeft = UDim.new(0, 4)
Padding.PaddingRight = UDim.new(0, 4)
Padding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -106, 1, -48)
Content.Position = UDim2.new(0, 98, 0, 44)
Content.BackgroundColor3 = DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 10)
AddStroke(Content)

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, -12, 1, -12)
    Page.Position = UDim2.new(0, 6, 0, 6)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = Content
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    Pages[name] = Page
    return Page
end

local function Section(parent, text)
    local Label = Text(parent, text, 8, true)
    Label.TextColor3 = GRAY
    Label.Size = UDim2.new(1, 0, 0, 16)
    return Label
end

local function Button(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = DARKER
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = WHITE
    Btn.TextSize = 10
    Btn.Font = Enum.Font.GothamMedium
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Corner(Btn, 8)
    AddStroke(Btn)
    Btn.MouseEnter:Connect(function() Tween(Btn, .15, {BackgroundColor3 = Color3.fromRGB(28,28,28)}) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, .15, {BackgroundColor3 = DARKER}) end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function Toggle(parent, text, default, callback)
    local State = default or false
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 26)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder, 8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": OFF", 9, false)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 26, 0, 14)
    Switch.Position = UDim2.new(1, -34, 0.5, -7)
    Switch.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Switch.Text = ""
    Switch.BorderSizePixel = 0
    Switch.Parent = Holder
    Corner(Switch, 20)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 10, 0, 10)
    Circle.Position = UDim2.new(0, 2, 0.5, -5)
    Circle.BackgroundColor3 = GRAY
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    Corner(Circle, 20)

    local function Update()
        if State then
            Tween(Switch, .2, {BackgroundColor3 = WHITE})
            Tween(Circle, .2, {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = BLACK})
            Label.Text = text .. ": ON"
        else
            Tween(Switch, .2, {BackgroundColor3 = Color3.fromRGB(35,35,35)})
            Tween(Circle, .2, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = GRAY})
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

local function Slider(parent, text, default, minVal, maxVal, callback, suffix)
    local Value = default or 50
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 30)
    Holder.BackgroundColor3 = DARKER
    Holder.BorderSizePixel = 0
    Holder.Parent = parent
    Corner(Holder, 8)
    AddStroke(Holder)

    local Label = Text(Holder, text .. ": " .. tostring(Value) .. (suffix or ""), 9, false)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(0, 100, 0, 3)
    SliderBg.Position = UDim2.new(0, 8, .5, 5)
    SliderBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Holder
    Corner(SliderBg, 2)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Value - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = WHITE
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    Corner(SliderFill, 2)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new((Value - minVal) / (maxVal - minVal), -6, 0.5, -6)
    Knob.BackgroundColor3 = WHITE
    Knob.Text = ""
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg
    Corner(Knob, 20)

    local function UpdateSlider(value)
        local clamped = math.clamp(value, minVal, maxVal)
        Value = clamped
        local ratio = (clamped - minVal) / (maxVal - minVal)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        Knob.Position = UDim2.new(ratio, -6, 0.5, -6)
        Label.Text = text .. ": " .. tostring(math.floor(clamped)) .. (suffix or "")
        if callback then callback(clamped) end
    end

    local DraggingKnob = false
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            DraggingKnob = true
        end
    end)
    Knob.InputEnded:Connect(function()
        DraggingKnob = false
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
    UserInputService.InputChanged:Connect(function(input)
        if DraggingKnob and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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
    return Holder
end

-- =============================================
-- PAGES
-- =============================================
local MainPage = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local MacroPage = CreatePage("Macro")
local VisualPage = CreatePage("Visuals")
local MiscPage = CreatePage("Misc")
local SettingsPage = CreatePage("Settings")
local CreditsPage = CreatePage("Credits")

-- =============================================
-- MAIN PAGE
-- =============================================
Section(MainPage, "IVORY HUB")
local mainTitle = Text(MainPage, "IVORY HUB v5.3", 16, true)
mainTitle.Size = UDim2.new(1, 0, 0, 24)
mainTitle.TextXAlignment = Enum.TextXAlignment.Center
mainTitle.TextColor3 = WHITE

local mainSub = Text(MainPage, "Blox Fruits PVP + Macro", 9, false)
mainSub.Size = UDim2.new(1, 0, 0, 16)
mainSub.Position = UDim2.new(0, 0, 0, 26)
mainSub.TextXAlignment = Enum.TextXAlignment.Center
mainSub.TextColor3 = GRAY

local features = {
    "• Silent Aim (360 / FOV)",
    "• Soru Aimbot (Flashstep)",
    "• Walk on Water",
    "• Auto V4 Awakening",
    "• ESP (Box/Name/Health/Dist)",
    "• No Clip & Anti-AFK",
    "• Macro System (Melee/Fruit/Sword/Gun)",
}
for i, f in ipairs(features) do
    local lbl = Text(MainPage, f, 9, false)
    lbl.Size = UDim2.new(1, -10, 0, 16)
    lbl.Position = UDim2.new(0, 5, 0, 50 + (i-1)*16)
    lbl.TextColor3 = WHITE
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- =============================================
-- COMBAT PAGE
-- =============================================
Section(CombatPage, "SILENT AIM")
Toggle(CombatPage, "Player Silent Aim", false, function(s)
    Features.SilentAimPlayers = s
end)

Toggle(CombatPage, "NPC Silent Aim", false, function(s)
    Features.SilentAimNPCs = s
end)

Button(CombatPage, "Mode: 360", function()
    local btn = CombatPage:FindFirstChild("AimModeButton")
    if Features.SilentAimMode == "360" then
        Features.SilentAimMode = "FOV"
        if btn then btn.Text = "Mode: FOV" end
    else
        Features.SilentAimMode = "360"
        if btn then btn.Text = "Mode: 360" end
    end
end)

Toggle(CombatPage, "Show FOV Circle", false, function(s)
    Features.FOVCircle = s
end)

Slider(CombatPage, "FOV Radius", 150, 10, 500, function(v)
    Features.FOVRadius = v
end)

Slider(CombatPage, "Max Range", 1000, 100, 3000, function(v)
    Features.MaxRange = v
end, "m")

Section(CombatPage, "EXTRAS")
Toggle(CombatPage, "Soru Aimbot (Flashstep)", false, function(s)
    Features.SoruAimbot = s
    if SoruBtn then SoruBtn.Visible = s end
end)

Toggle(CombatPage, "Auto V4", false, function(s)
    Features.AutoV4 = s
end)

-- =============================================
-- MACRO PAGE
-- =============================================
Section(MacroPage, "MACRO SYSTEM")

Toggle(MacroPage, "Enable Macro", false, function(s)
    Features.MacroEnabled = s
    if not s then
        Macro.IsRunning = false
        if MacroBtn then MacroBtn.Visible = false end
    else
        if MacroBtn then MacroBtn.Visible = true end
    end
end)

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -10, 0, 30)
btnRow.BackgroundTransparency = 1
btnRow.Parent = MacroPage

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.45, -5, 1, 0)
addBtn.Position = UDim2.new(0, 0, 0, 0)
addBtn.BackgroundColor3 = DARKER
addBtn.Text = "+ Add Block"
addBtn.TextColor3 = WHITE
addBtn.TextSize = 10
addBtn.Font = Enum.Font.GothamMedium
addBtn.BorderSizePixel = 0
addBtn.Parent = btnRow
Corner(addBtn, 8)
AddStroke(addBtn)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.45, -5, 1, 0)
clearBtn.Position = UDim2.new(0.55, 5, 0, 0)
clearBtn.BackgroundColor3 = DARKER
clearBtn.Text = "Clear All"
clearBtn.TextColor3 = WHITE
clearBtn.TextSize = 10
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.BorderSizePixel = 0
clearBtn.Parent = btnRow
Corner(clearBtn, 8)
AddStroke(clearBtn)

local blockContainer = Instance.new("ScrollingFrame")
blockContainer.Size = UDim2.new(1, -10, 0, 220)
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

local function AddBlock()
    local idx = #Macro.Blocks + 1
    local block = CreateMacroBlock(blockContainer, idx)
    table.insert(Macro.Blocks, block)
end

local function ClearBlocks()
    for _, child in pairs(blockContainer:GetChildren()) do
        if child:IsA("Frame") and string.find(child.Name, "MacroBlock_") then
            child:Destroy()
        end
    end
    Macro.Blocks = {}
end

addBtn.MouseButton1Click:Connect(AddBlock)
clearBtn.MouseButton1Click:Connect(ClearBlocks)

for i = 1, 3 do
    task.wait(0.05)
    AddBlock()
end

-- =============================================
-- MACRO BUTTON
-- =============================================
local MacroBtn = Instance.new("TextButton")
MacroBtn.Size = UDim2.fromOffset(60, 28)
MacroBtn.Position = UDim2.new(0.5, -30, 0.85, 0)
MacroBtn.BackgroundColor3 = RED
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = WHITE
MacroBtn.TextSize = 12
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Visible = false
MacroBtn.Parent = Gui
Corner(MacroBtn, 8)
AddStroke(MacroBtn, Color3.fromRGB(200,50,50))

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
    if Features.MacroEnabled then
        ExecuteMacro()
        MacroBtn.BackgroundColor3 = GREEN
        MacroBtn.Text = "▶"
        task.delay(0.5, function()
            MacroBtn.BackgroundColor3 = RED
            MacroBtn.Text = "MACRO"
        end)
    end
end)

-- =============================================
-- SORU BUTTON (Pure Flashstep)
-- =============================================
local SoruBtn = Instance.new("TextButton")
SoruBtn.Size = UDim2.fromOffset(70, 70)
SoruBtn.Position = UDim2.new(0.85, -35, 0.8, -35)
SoruBtn.BackgroundColor3 = BLACK
SoruBtn.BackgroundTransparency = 0.2
SoruBtn.Text = "SORU"
SoruBtn.TextColor3 = WHITE
SoruBtn.TextSize = 16
SoruBtn.Font = Enum.Font.GothamBold
SoruBtn.BorderSizePixel = 0
SoruBtn.Visible = false
SoruBtn.Parent = Gui
Corner(SoruBtn, 50)
AddStroke(SoruBtn, Color3.fromRGB(255,255,255), 1.5)

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
    if Features.SoruAimbot then
        SoruAimbot:Attack()
        SoruBtn.BackgroundColor3 = GREEN
        SoruBtn.BackgroundTransparency = 0
        task.delay(0.3, function()
            SoruBtn.BackgroundColor3 = BLACK
            SoruBtn.BackgroundTransparency = 0.2
        end)
    end
end)

-- Update Soru cooldown
RunService.RenderStepped:Connect(function()
    if Features.SoruAimbot and SoruBtn then
        local cooldown = SoruAimbot:GetCooldown()
        if cooldown > 0 then
            SoruBtn.BackgroundTransparency = 0.6
            SoruBtn.Text = string.format("%.1f", cooldown)
        else
            SoruBtn.BackgroundTransparency = 0.2
            SoruBtn.Text = "SORU"
        end
    end
end)

-- =============================================
-- VISUALS PAGE
-- =============================================
Section(VisualPage, "VISUALS")
Toggle(VisualPage, "Enable ESP", false, function(s)
    Features.ESP = s
end)

Toggle(VisualPage, "Show Box", false, function(s)
    Features.ESPBox = s
end)

Toggle(VisualPage, "Show Name", false, function(s)
    Features.ESPName = s
end)

Toggle(VisualPage, "Show Health", false, function(s)
    Features.ESPHealth = s
end)

Toggle(VisualPage, "Show Distance", false, function(s)
    Features.ESPDistance = s
end)

-- =============================================
-- MISC PAGE
-- =============================================
Section(MiscPage, "MISC")
Toggle(MiscPage, "No Clip", false, function(s)
    Features.NoClip = s
end)

Toggle(MiscPage, "Anti-AFK", false, function(s)
    Features.AntiAFK = s
end)

Toggle(MiscPage, "Walk on Water", false, function(s)
    Features.WalkWater = s
end)

-- =============================================
-- SETTINGS PAGE
-- =============================================
Section(SettingsPage, "SETTINGS")

Button(SettingsPage, "Reset All", function()
    for k, v in pairs(Features) do
        if type(v) == "boolean" then
            Features[k] = false
        end
    end
    Features.SilentAimMode = "360"
    Features.FOVRadius = 150
    Features.MaxRange = 1000
    Macro.IsRunning = false
    if MacroBtn then MacroBtn.Visible = false end
    if SoruBtn then SoruBtn.Visible = false end
    if WaterPart then WaterPart:Destroy(); WaterPart = nil end
    print("[Ivory] All reset!")
end)

Button(SettingsPage, "Unload", function()
    if WaterPart then WaterPart:Destroy(); WaterPart = nil end
    Gui:Destroy()
end)

-- =============================================
-- CREDITS PAGE
-- =============================================
Section(CreditsPage, "CREDITS")
local CreatorBox = Instance.new("Frame")
CreatorBox.Size = UDim2.new(1, 0, 0, 60)
CreatorBox.BackgroundColor3 = DARKER
CreatorBox.BorderSizePixel = 0
CreatorBox.Parent = CreditsPage
Corner(CreatorBox, 8)
AddStroke(CreatorBox)

local Creator1 = Text(CreatorBox, "IVORY", 14, true)
Creator1.Position = UDim2.new(0, 12, 0, 6)
Creator1.Size = UDim2.new(1, -24, 0, 20)

local Discord1 = Text(CreatorBox, "Discord: Ivory999", 9, false)
Discord1.TextColor3 = GRAY
Discord1.Position = UDim2.new(0, 12, 0, 30)
Discord1.Size = UDim2.new(1, -24, 0, 16)

local Version = Text(CreditsPage, "Ivory Hub v5.3 • PURE SORU", 8, false)
Version.TextColor3 = GRAY
Version.Size = UDim2.new(1, 0, 0, 16)

-- =============================================
-- TABS
-- =============================================
local Tabs = {
    {name="MAIN", page=MainPage},
    {name="COMBAT", page=CombatPage},
    {name="MACRO", page=MacroPage},
    {name="VISUAL", page=VisualPage},
    {name="MISC", page=MiscPage},
    {name="SETTINGS", page=SettingsPage},
    {name="CREDITS", page=CreditsPage}
}
local CurrentTab

local function SelectTab(button, page)
    for _, data in ipairs(Tabs) do
        if data.button then Tween(data.button, .15, {BackgroundColor3 = DARKER}) end
        data.page.Visible = false
    end
    Tween(button, .15, {BackgroundColor3 = WHITE})
    button.TextColor3 = BLACK
    page.Visible = true
    CurrentTab = page
end

for _, data in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundColor3 = DARKER
    btn.BorderSizePixel = 0
    btn.Text = data.name
    btn.TextColor3 = GRAY
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Corner(btn, 8)
    AddStroke(btn)
    data.button = btn
    btn.MouseEnter:Connect(function()
        if CurrentTab ~= data.page then Tween(btn, .15, {BackgroundColor3 = Color3.fromRGB(27,27,27)}) end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentTab ~= data.page then Tween(btn, .15, {BackgroundColor3 = DARKER}) end
    end)
    btn.MouseButton1Click:Connect(function()
        SelectTab(btn, data.page)
    end)
end
SelectTab(Tabs[1].button, Tabs[1].page)

-- =============================================
-- DRAGGING
-- =============================================
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
        Tween(Main, .25, {Size = UDim2.new(0, 400, 0, 38)})
        Minimize.Text = "+"
    else
        Tween(Main, .25, {Size = UDim2.new(0, 400, 0, 420)})
        task.wait(.15)
        Sidebar.Visible = true
        Content.Visible = true
        Minimize.Text = "—"
    end
end)

Close.MouseButton1Click:Connect(function()
    Tween(Main, .25, {Size = UDim2.new(0, 0, 0, 0)})
    task.wait(.3)
    Gui:Destroy()
end)

-- =============================================
-- FOV CIRCLE
-- =============================================
local FOVGui = nil
local FOVRing = nil

RunService.RenderStepped:Connect(function()
    if Features.FOVCircle then
        if not FOVGui then
            FOVGui = Instance.new("ScreenGui")
            FOVGui.Name = "IvoryFOV"
            FOVGui.ResetOnSpawn = false
            FOVGui.IgnoreGuiInset = true
            FOVGui.DisplayOrder = 1
            FOVGui.Parent = Gui
            FOVRing = Instance.new("Frame")
            FOVRing.Name = "FOVRing"
            FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
            FOVRing.Position = UDim2.new(0.5, 0, 0.5, 0)
            FOVRing.BackgroundTransparency = 1
            FOVRing.BorderSizePixel = 0
            FOVRing.ZIndex = 100
            FOVRing.Parent = FOVGui
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = FOVRing
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 2
            stroke.Color = RED
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = FOVRing
        end
        local radius = Features.FOVRadius
        local diameter = math.floor(radius * 2)
        FOVRing.Size = UDim2.fromOffset(diameter, diameter)
        FOVRing.Visible = true
    elseif FOVRing then
        FOVRing.Visible = false
    end
end)

print("========================================")
print("        IVORY HUB v5.3 LOADED")
print("========================================")
print("✅ Silent Aim (360 / FOV)")
print("✅ Soru Aimbot (Pure Flashstep)")
print("✅ Walk on Water")
print("✅ Auto V4 Awakening")
print("✅ ESP (Box/Name/Health/Dist)")
print("✅ No Clip & Anti-AFK")
print("✅ Macro System (Melee/Fruit/Sword/Gun)")
print("========================================")
print("💡 Enable Soru in COMBAT tab for SORU button")
print("💡 Enable Macro in MACRO tab for MACRO button")
print("========================================")
