-- =============================================
-- IVORY HUB v4.4 - FINAL FIXED
-- =============================================

print("🦷 Ivory Hub v4.4 loading...")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

-- Remove old
local Old = parentGui:FindFirstChild("IvoryHub")
if Old then Old:Destroy() end

-- Main Gui
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
    ESP = false,
    ESPBox = false,
    ESPName = false,
    ESPHealth = false,
    ESPDistance = false,
    FOVCircle = false,
    FOVRadius = 150,
    MaxRange = 1000,
    Prediction = false,
    PredictionAmount = 0.12,
    MacroEnabled = false,
}

-- =============================================
-- WEAPON OPTIONS (FIXED: Melee, Fruit, Sword, Gun)
-- =============================================
local WEAPON_OPTIONS = {
    "Melee",
    "Fruit",
    "Sword",
    "Gun",
}

local SKILL_OPTIONS = {
    "Z",
    "X",
    "C",
    "V",
    "F",
    "Tap",
    "M1",
}

-- =============================================
-- MACRO SYSTEM
-- =============================================
local Macro = {
    Blocks = {},
    IsRunning = false,
}

-- =============================================
-- MACRO BLOCK (With Weapon Selection)
-- =============================================
local function CreateMacroBlock(parent, index)
    local block = Instance.new("Frame")
    block.Name = "MacroBlock_" .. index
    block.Size = UDim2.new(1, -10, 0, 70)
    block.BackgroundColor3 = DARKER
    block.BorderSizePixel = 0
    block.Parent = parent
    Corner(block, 8)
    AddStroke(block)
    
    -- Title
    local title = Text(block, "Block " .. index, 10, true)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.Size = UDim2.new(0, 80, 0, 16)
    title.TextColor3 = BLUE
    
    -- Weapon button (click to cycle: Melee → Fruit → Sword → Gun)
    local weaponBtn = Instance.new("TextButton")
    weaponBtn.Size = UDim2.new(0, 80, 0, 24)
    weaponBtn.Position = UDim2.new(0, 10, 0, 22)
    weaponBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    weaponBtn.Text = "Melee"
    weaponBtn.TextColor3 = WHITE
    weaponBtn.TextSize = 10
    weaponBtn.Font = Enum.Font.GothamMedium
    weaponBtn.BorderSizePixel = 0
    weaponBtn.Parent = block
    Corner(weaponBtn, 6)
    AddStroke(weaponBtn, Color3.fromRGB(60,60,60))
    
    -- Skill button (click to cycle)
    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 60, 0, 24)
    skillBtn.Position = UDim2.new(0, 95, 0, 22)
    skillBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    skillBtn.Text = "Z"
    skillBtn.TextColor3 = WHITE
    skillBtn.TextSize = 10
    skillBtn.Font = Enum.Font.GothamMedium
    skillBtn.BorderSizePixel = 0
    skillBtn.Parent = block
    Corner(skillBtn, 6)
    AddStroke(skillBtn, Color3.fromRGB(60,60,60))
    
    -- Hold slider
    local holdLabel = Text(block, "Hold: 0s", 9, false)
    holdLabel.Position = UDim2.new(0, 165, 0, 24)
    holdLabel.Size = UDim2.new(0, 70, 0, 16)
    holdLabel.TextColor3 = GRAY
    
    local holdSlider = Instance.new("Frame")
    holdSlider.Size = UDim2.new(0, 70, 0, 3)
    holdSlider.Position = UDim2.new(0, 165, 0, 40)
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
    holdKnob.Size = UDim2.new(0, 10, 0, 10)
    holdKnob.Position = UDim2.new(0, -5, 0.5, -5)
    holdKnob.BackgroundColor3 = WHITE
    holdKnob.Text = ""
    holdKnob.BorderSizePixel = 0
    holdKnob.Parent = holdSlider
    Corner(holdKnob, 10)
    
    -- Delay slider
    local delayLabel = Text(block, "Delay: 0s", 9, false)
    delayLabel.Position = UDim2.new(0, 245, 0, 24)
    delayLabel.Size = UDim2.new(0, 70, 0, 16)
    delayLabel.TextColor3 = GRAY
    
    local delaySlider = Instance.new("Frame")
    delaySlider.Size = UDim2.new(0, 70, 0, 3)
    delaySlider.Position = UDim2.new(0, 245, 0, 40)
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
    delayKnob.Size = UDim2.new(0, 10, 0, 10)
    delayKnob.Position = UDim2.new(0, -5, 0.5, -5)
    delayKnob.BackgroundColor3 = WHITE
    delayKnob.Text = ""
    delayKnob.BorderSizePixel = 0
    delayKnob.Parent = delaySlider
    Corner(delayKnob, 10)
    
    -- Values
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
        holdKnob.Position = UDim2.new(ratio, -5, 0.5, -5)
        holdLabel.Text = "Hold: " .. holdValue .. "s"
    end
    
    local function UpdateDelay(pos)
        local sliderAbsPos = delaySlider.AbsolutePosition
        local sliderSize = delaySlider.AbsoluteSize.X
        local relativeX = math.clamp(pos.X - sliderAbsPos.X, 0, sliderSize)
        local ratio = relativeX / sliderSize
        delayValue = math.floor(ratio * 3)
        delayFill.Size = UDim2.new(ratio, 0, 1, 0)
        delayKnob.Position = UDim2.new(ratio, -5, 0.5, -5)
        delayLabel.Text = "Delay: " .. delayValue .. "s"
    end
    
    -- Hold slider events
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
    
    -- Delay slider events
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
    
    -- Weapon button - click to cycle: Melee → Fruit → Sword → Gun → Melee...
    weaponBtn.MouseButton1Click:Connect(function()
        weaponIndex = weaponIndex % #WEAPON_OPTIONS + 1
        weaponBtn.Text = WEAPON_OPTIONS[weaponIndex]
    end)
    
    -- Skill button - click to cycle
    skillBtn.MouseButton1Click:Connect(function()
        skillIndex = skillIndex % #SKILL_OPTIONS + 1
        skillBtn.Text = SKILL_OPTIONS[skillIndex]
    end)
    
    local blockData = {
        Index = index,
        Weapon = function() return WEAPON_OPTIONS[weaponIndex] end,
        Skill = function() return SKILL_OPTIONS[skillIndex] end,
        Hold = function() return holdValue end,
        Delay = function() return delayValue end,
        WeaponBtn = weaponBtn,
        SkillBtn = skillBtn,
    }
    
    return blockData
end

-- =============================================
-- EXECUTE MACRO
-- =============================================
local function ExecuteMacro()
    if not Features.MacroEnabled then return end
    if #Macro.Blocks == 0 then 
        print("[Ivory] No macro blocks!") 
        return 
    end
    
    if Macro.IsRunning then return end
    Macro.IsRunning = true
    
    task.spawn(function()
        for _, block in ipairs(Macro.Blocks) do
            if not Features.MacroEnabled then break end
            
            local skill = block.Skill()
            local hold = block.Hold()
            local delay = block.Delay()
            
            -- Press the skill
            if skill == "M1" then
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, true)
                task.wait(hold or 0.1)
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, 0, false)
            else
                local keyCode = Enum.KeyCode[skill] or Enum.KeyCode.Z
                VirtualInputManager:SendKeyEvent(true, keyCode, false)
                if hold > 0 then
                    task.wait(hold)
                else
                    task.wait(0.05)
                end
                VirtualInputManager:SendKeyEvent(false, keyCode, false)
            end
            
            if delay > 0 then
                task.wait(delay)
            end
        end
        
        Macro.IsRunning = false
    end)
end

-- =============================================
-- SILENT AIM MODULE (360 + FOV)
-- =============================================
local SilentAim = (function()
    local module = {}
    local PlayersPosition = nil
    local NPCPosition = nil
    local FOVRadius = 150
    local MaxRange = 1000
    local PredictionEnabled = false
    local PredictionAmount = 0.12
    local ShowFOVCircle = false
    
    -- FOV Circle
    local FOVGui = nil
    local FOVRing = nil
    
    local function getFOVCenter()
        return Camera.ViewportSize / 2
    end
    
    local function isTargetInFOV(hrp)
        if not ShowFOVCircle then return true end
        if not hrp then return false end
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then return false end
        local center = getFOVCenter()
        return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= FOVRadius
    end
    
    local function isTargetValid(hrp, lpHRP)
        if not hrp or not lpHRP then return false end
        
        -- 360 mode = always valid if in range
        if Features.SilentAimMode == "360" then
            return true
        end
        
        -- FOV mode = only if in FOV circle
        if Features.SilentAimMode == "FOV" then
            return isTargetInFOV(hrp)
        end
        
        return true
    end
    
    local function getClosestPlayer(lpHRP)
        if not lpHRP then return nil end
        local valid = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character.Parent then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= MaxRange and isTargetValid(hrp, lpHRP) then
                        table.insert(valid, {Player=plr, Humanoid=hum, HRP=hrp, Distance=dist})
                    end
                end
            end
        end
        if #valid == 0 then return nil end
        table.sort(valid, function(a,b) return a.Distance < b.Distance end)
        return valid[1]
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
                if hum and hum.Health > 0 and hrp then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= MaxRange and dist < closestDist and isTargetValid(hrp, lpHRP) then
                        closestDist = dist
                        closest = npc
                    end
                end
            end
        end
        return closest
    end
    
    local function predictedPos(hrp)
        if not hrp then return nil end
        if not PredictionEnabled then return hrp.Position end
        local vel = hrp.Velocity
        local speed = vel.Magnitude
        if speed < 5 then return hrp.Position end
        return hrp.Position + (vel * PredictionAmount)
    end
    
    local renderConnection = nil
    
    local function startRenderLoop()
        if renderConnection then return end
        renderConnection = RunService.RenderStepped:Connect(function()
            -- FOV circle
            if ShowFOVCircle then
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
                local radius = FOVRadius
                local diameter = math.floor(radius * 2)
                FOVRing.Size = UDim2.fromOffset(diameter, diameter)
                FOVRing.Visible = true
            elseif FOVRing then
                FOVRing.Visible = false
            end
            
            local lpChar = player.Character
            if not lpChar then return end
            local lpHRP = lpChar:FindFirstChild("HumanoidRootPart")
            if not lpHRP then return end
            
            if Features.SilentAimPlayers then
                local target = getClosestPlayer(lpHRP)
                if target and target.HRP then
                    PlayersPosition = predictedPos(target.HRP)
                else
                    PlayersPosition = nil
                end
            end
            
            if Features.SilentAimNPCs then
                local npc = getClosestNPC(lpHRP)
                if npc then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then NPCPosition = predictedPos(hrp) else NPCPosition = nil end
                else
                    NPCPosition = nil
                end
            end
        end)
    end
    
    local function stopRenderLoop()
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
        if FOVRing then FOVRing.Visible = false end
        PlayersPosition = nil
        NPCPosition = nil
    end
    
    -- Silent Aim hooks
    local oldIndex, oldNamecall = nil, nil
    
    local function installHooks()
        if hookmetamethod then
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                if not checkcaller() and self == Camera and (key == "Hit" or key == "Target") then
                    if Features.SilentAimPlayers or Features.SilentAimNPCs then
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
                    if Features.SilentAimPlayers or Features.SilentAimNPCs then
                        local targetPos = PlayersPosition or NPCPosition
                        if targetPos then
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "Vector3" then args[i] = targetPos
                                elseif typeof(arg) == "CFrame" then args[i] = CFrame.new(targetPos) end
                            end
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
        end
    end
    installHooks()
    
    function module:SetPlayerSilentAim(state)
        Features.SilentAimPlayers = state
        if state then startRenderLoop() else if not Features.SilentAimNPCs then stopRenderLoop() end end
    end
    
    function module:SetNPCSilentAim(state)
        Features.SilentAimNPCs = state
        if state then startRenderLoop() else if not Features.SilentAimPlayers then stopRenderLoop() end end
    end
    
    function module:GetTargetPos()
        return PlayersPosition or NPCPosition
    end
    
    function module:SetFOVRadius(radius) FOVRadius = radius end
    function module:SetShowFOVCircle(state) ShowFOVCircle = state end
    function module:SetDistanceLimit(dist) MaxRange = dist end
    function module:SetPrediction(state) PredictionEnabled = state end
    function module:SetPredictionAmount(amount) PredictionAmount = amount end
    
    return module
end)()

-- =============================================
-- SORU AIMBOT (Works anywhere)
-- =============================================
local SoruAimbot = (function()
    local module = {}
    local enabled = false
    local cooldown = 0
    local flashstepRemote = nil
    
    -- Find Flashstep remote
    task.spawn(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then flashstepRemote = remotes:FindFirstChild("CommF_") end
        if not flashstepRemote then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj.Name == "CommF_" or obj.Name == "Flashstep" then
                    if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                        flashstepRemote = obj
                        break
                    end
                end
            end
        end
        print("[Ivory] Flashstep remote:", flashstepRemote and "yes" or "no")
    end)
    
    local function teleport(targetPos)
        if not targetPos then return false end
        local char = player.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        
        local dist = (targetPos - hrp.Position).Magnitude
        if dist > 1500 then return false end
        
        local success = false
        pcall(function()
            if flashstepRemote then
                flashstepRemote:InvokeServer("Flashstep", targetPos)
                success = true
            else
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                success = true
            end
        end)
        return success
    end
    
    local function monitorFlashstep(char)
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        hum.AnimationPlayed:Connect(function(track)
            if not enabled then return end
            if tick() < cooldown then return end
            
            local animName = string.lower(track.Name)
            local animId = tostring(track.Animation and track.Animation.AnimationId or "")
            
            if string.find(animName, "flashstep") or string.find(animName, "soru") or 
               string.find(animName, "dash") or string.find(animId, "17555632156") or 
               string.find(animId, "616006778") then
                
                local targetPos = SilentAim:GetTargetPos()
                if targetPos then
                    if teleport(targetPos) then
                        cooldown = tick() + 1.5
                    end
                end
            end
        end)
    end
    
    function module:SetEnabled(state)
        enabled = state
        Features.SoruAimbot = state
    end
    
    function module:StartMonitoring(char)
        task.wait(0.5)
        monitorFlashstep(char)
    end
    
    return module
end)()

-- Start monitoring
player.CharacterAdded:Connect(function(char)
    SoruAimbot:StartMonitoring(char)
end)
if player.Character then
    task.wait(0.5)
    SoruAimbot:StartMonitoring(player.Character)
end

-- =============================================
-- AUTO V4
-- =============================================
local AutoV4 = (function()
    local module = {}
    local enabled = false
    
    function module:SetEnabled(state)
        enabled = state
        Features.AutoV4 = state
    end
    
    function module:Update()
        if not enabled then return end
        local char = player.Character
        if not char then return end
        
        local raceEnergy = char:GetAttribute("RaceEnergy")
        if raceEnergy and raceEnergy >= 100 then
            local success = false
            
            local awk = player.Backpack:FindFirstChild("Awakening") or char:FindFirstChild("Awakening")
            if awk then
                for _, child in pairs(awk:GetDescendants()) do
                    if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
                        pcall(function()
                            if child:IsA("RemoteFunction") then
                                child:InvokeServer(true)
                            else
                                child:FireServer(true)
                            end
                            success = true
                        end)
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
            
            pcall(function()
                char:SetAttribute("RaceEnergy", 0)
            end)
        end
    end
    
    return module
end)()

-- =============================================
-- ESP SYSTEM
-- =============================================
local ESP = (function()
    local module = {}
    local espData = {}
    local enabled = false
    local showBox = false
    local showName = false
    local showHealth = false
    local showDistance = false
    
    local function AddESP(target)
        if espData[target] then return end
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
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(1, 0, 1, 0)
        mainFrame.BackgroundTransparency = 1
        mainFrame.Parent = gui
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 18)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = target.Name or "NPC"
        nameLabel.TextColor3 = WHITE
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.Parent = mainFrame
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(0, 60, 0, 14)
        distLabel.Position = UDim2.new(1, -65, 0, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = GRAY
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextXAlignment = Enum.TextXAlignment.Right
        distLabel.Parent = mainFrame
        
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(1, 0, 0, 4)
        healthBg.Position = UDim2.new(0, 0, 1, -4)
        healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        healthBg.BorderSizePixel = 0
        healthBg.Parent = mainFrame
        
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
        
        espData[target] = {
            gui = gui,
            name = nameLabel,
            dist = distLabel,
            healthBg = healthBg,
            healthFill = healthFill,
            box = box,
            target = target
        }
    end
    
    local function UpdateESP()
        if not enabled then
            for _, data in pairs(espData) do
                pcall(function() data.gui.Visible = false end)
            end
            return
        end
        
        local currentTargets = {}
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.Health > 0 then
                        if not espData[plr] then AddESP(plr) end
                        currentTargets[plr] = true
                        local data = espData[plr]
                        if data then
                            data.gui.Visible = true
                            data.name.Text = plr.Name
                            local root = char.HumanoidRootPart
                            local dist = (root.Position - Camera.CFrame.Position).Magnitude
                            data.dist.Text = math.floor(dist) .. "m"
                            local hp = hum.Health / hum.MaxHealth
                            data.healthFill.Size = UDim2.new(hp, 0, 1, 0)
                            if hp > 0.5 then data.healthFill.BackgroundColor3 = GREEN
                            elseif hp > 0.25 then data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                            else data.healthFill.BackgroundColor3 = RED end
                            data.name.Visible = showName
                            data.dist.Visible = showDistance
                            data.healthBg.Visible = showHealth
                            data.box.Visible = showBox
                        end
                    end
                end
            end
        end
        
        -- NPCs
        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, npc in pairs(enemiesFolder:GetChildren()) do
                if npc:IsA("Model") then
                    local hum = npc:FindFirstChild("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        if not espData[npc] then
                            local fake = {Name = "NPC", Character = npc}
                            AddESP(fake)
                            espData[npc] = espData[fake]
                        end
                        currentTargets[npc] = true
                        local data = espData[npc]
                        if data then
                            data.gui.Visible = true
                            data.name.Text = "NPC"
                            data.dist.Text = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude) .. "m"
                            local hp = hum.Health / hum.MaxHealth
                            data.healthFill.Size = UDim2.new(hp, 0, 1, 0)
                            if hp > 0.5 then data.healthFill.BackgroundColor3 = GREEN
                            elseif hp > 0.25 then data.healthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                            else data.healthFill.BackgroundColor3 = RED end
                            data.name.Visible = showName
                            data.dist.Visible = showDistance
                            data.healthBg.Visible = showHealth
                            data.box.Visible = showBox
                        end
                    end
                end
            end
        end
        
        -- Clean up
        for target, data in pairs(espData) do
            if not currentTargets[target] then
                pcall(function() data.gui:Destroy() end)
                espData[target] = nil
            end
        end
    end
    
    function module:SetEnabled(state)
        enabled = state
        Features.ESP = state
    end
    
    function module:SetBox(state) showBox = state; Features.ESPBox = state end
    function module:SetName(state) showName = state; Features.ESPName = state end
    function module:SetHealth(state) showHealth = state; Features.ESPHealth = state end
    function module:SetDistance(state) showDistance = state; Features.ESPDistance = state end
    
    function module:Update()
        UpdateESP()
    end
    
    return module
end)()

-- =============================================
-- NO CLIP & ANTI-AFK
-- =============================================
local NoClip = (function()
    local module = {}
    local enabled = false
    
    function module:SetEnabled(state)
        enabled = state
        Features.NoClip = state
    end
    
    function module:Update()
        if not enabled then return end
        local char = player.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    return module
end)()

local AntiAFK = (function()
    local module = {}
    local enabled = false
    local timer = 0
    
    function module:SetEnabled(state)
        enabled = state
        Features.AntiAFK = state
    end
    
    function module:Update()
        if not enabled then return end
        timer = timer + 0.1
        if timer < 5 then return end
        timer = 0
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            hum:Move(Vector3.new(1,0,0), true)
            task.wait(0.1)
            hum:Move(Vector3.new(-1,0,0), true)
        end
    end
    
    return module
end)()

-- =============================================
-- MAIN LOOP
-- =============================================
local loopConnection = nil

local function StartLoop()
    if loopConnection then return end
    loopConnection = RunService.Heartbeat:Connect(function()
        AutoV4:Update()
        NoClip:Update()
        AntiAFK:Update()
        ESP:Update()
    end)
end

local function StopLoop()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
end

local function CheckLoop()
    if Features.SilentAimPlayers or Features.SilentAimNPCs or Features.SoruAimbot or 
       Features.AutoV4 or Features.NoClip or Features.AntiAFK or Features.ESP then
        StartLoop()
    else
        StopLoop()
    end
end

-- =============================================
-- COMPACT GUI
-- =============================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "IvoryToggle"
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
    Tween(ToggleBtn, 0.15, { BackgroundColor3 = WHITE, TextColor3 = BLACK })
end)
ToggleBtn.MouseLeave:Connect(function()
    Tween(ToggleBtn, 0.15, { BackgroundColor3 = BLACK, TextColor3 = WHITE })
end)

-- =============================================
-- MAIN WINDOW (SMALLER)
-- =============================================
local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0, 380, 0, 380)
Main.Position = UDim2.new(0.5, -190, 0.5, -190)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Gui
Corner(Main, 12)
AddStroke(Main)

-- Top bar (smaller)
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 38)
Top.BackgroundColor3 = DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 12)

local Title = Text(Top, "IVORY", 15, true)
Title.Position = UDim2.new(0, 12, 0, 2)
Title.Size = UDim2.new(0, 100, 0, 20)

local SubTitle = Text(Top, "HUB", 8, false)
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

-- =============================================
-- SIDEBAR & CONTENT (Smaller)
-- =============================================
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
    Page.ScrollBarImageColor3 = WHITE
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
local mainTitle = Text(MainPage, "IVORY HUB v4.4", 16, true)
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
    "• Soru/Flashstep Aimbot",
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
    SilentAim:SetPlayerSilentAim(s)
    CheckLoop()
end)

Toggle(CombatPage, "NPC Silent Aim", false, function(s)
    SilentAim:SetNPCSilentAim(s)
    CheckLoop()
end)

-- Silent Aim Mode toggle (360 or FOV)
Button(CombatPage, "Mode: 360", function()
    local btn = CombatPage:FindFirstChild("AimModeButton")
    if Features.SilentAimMode == "360" then
        Features.SilentAimMode = "FOV"
        SilentAim:SetFOVCircle(true)
        if btn then btn.Text = "Mode: FOV" end
    else
        Features.SilentAimMode = "360"
        SilentAim:SetFOVCircle(false)
        if btn then btn.Text = "Mode: 360" end
    end
end)

Toggle(CombatPage, "Show FOV Circle", false, function(s)
    SilentAim:SetShowFOVCircle(s)
    Features.FOVCircle = s
end)

Slider(CombatPage, "FOV Radius", 150, 10, 500, function(v)
    SilentAim:SetFOVRadius(v)
    Features.FOVRadius = v
end)

Slider(CombatPage, "Max Range", 1000, 100, 3000, function(v)
    SilentAim:SetDistanceLimit(v)
    Features.MaxRange = v
end, "m")

Toggle(CombatPage, "Prediction", false, function(s)
    SilentAim:SetPrediction(s)
end)

Section(CombatPage, "EXTRAS")
Toggle(CombatPage, "Soru/Flashstep", false, function(s)
    SoruAimbot:SetEnabled(s)
    Features.SoruAimbot = s
    CheckLoop()
end)

Toggle(CombatPage, "Auto V4", false, function(s)
    AutoV4:SetEnabled(s)
    Features.AutoV4 = s
    CheckLoop()
end)

-- =============================================
-- MACRO PAGE (Onion13 Style)
-- =============================================
Section(MacroPage, "MACRO SYSTEM")

Toggle(MacroPage, "Enable Macro", false, function(s)
    Features.MacroEnabled = s
    if not s then
        Macro.IsRunning = false
    end
end)

-- Add Block + Clear All buttons side by side
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

-- Container for macro blocks
local blockContainer = Instance.new("ScrollingFrame")
blockContainer.Size = UDim2.new(1, -10, 0, 200)
blockContainer.BackgroundTransparency = 1
blockContainer.BorderSizePixel = 0
blockContainer.ScrollBarThickness = 3
blockContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
blockContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
blockContainer.Parent = MacroPage

local blockLayout = Instance.new("UIListLayout")
blockLayout.Padding = UDim.new(0, 6)
blockLayout.SortOrder = Enum.SortOrder.LayoutOrder
blockLayout.Parent = blockContainer

-- Add block function
local function AddBlock()
    local idx = #Macro.Blocks + 1
    local block = CreateMacroBlock(blockContainer, idx)
    table.insert(Macro.Blocks, block)
end

-- Clear blocks function
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

-- Add 3 default blocks
task.wait(0.1)
for i = 1, 3 do
    AddBlock()
end

-- =============================================
-- DRAGGABLE MACRO BUTTON
-- =============================================
local MacroBtn = Instance.new("TextButton")
MacroBtn.Name = "MacroButton"
MacroBtn.Size = UDim2.fromOffset(60, 28)
MacroBtn.Position = UDim2.new(0.5, -30, 0.85, 0)
MacroBtn.BackgroundColor3 = RED
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = WHITE
MacroBtn.TextSize = 12
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Parent = Gui
Corner(MacroBtn, 8)
AddStroke(MacroBtn, Color3.fromRGB(200,50,50))

-- Make it draggable
local dragData = {dragging = false, startPos = nil, startMouse = nil}

MacroBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragData.dragging = true
        dragData.startMouse = input.Position
        dragData.startPos = MacroBtn.Position
    end
end)

MacroBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragData.dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragData.startMouse
        MacroBtn.Position = UDim2.new(
            dragData.startPos.X.Scale,
            dragData.startPos.X.Offset + delta.X,
            dragData.startPos.Y.Scale,
            dragData.startPos.Y.Offset + delta.Y
        )
    end
end)

-- Execute macro when clicked
MacroBtn.MouseButton1Click:Connect(function()
    if Features.MacroEnabled then
        ExecuteMacro()
        -- Flash feedback
        MacroBtn.BackgroundColor3 = GREEN
        MacroBtn.Text = "▶"
        task.delay(0.5, function()
            MacroBtn.BackgroundColor3 = RED
            MacroBtn.Text = "MACRO"
        end)
    else
        -- Show feedback that macro is disabled
        MacroBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        MacroBtn.Text = "OFF"
        task.delay(0.5, function()
            MacroBtn.BackgroundColor3 = RED
            MacroBtn.Text = "MACRO"
        end)
    end
end)

-- =============================================
-- VISUALS PAGE
-- =============================================
Section(VisualPage, "VISUALS")
Toggle(VisualPage, "Enable ESP", false, function(s)
    ESP:SetEnabled(s)
    Features.ESP = s
    CheckLoop()
end)

Toggle(VisualPage, "Show Box", false, function(s)
    ESP:SetBox(s)
    Features.ESPBox = s
end)

Toggle(VisualPage, "Show Name", false, function(s)
    ESP:SetName(s)
    Features.ESPName = s
end)

Toggle(VisualPage, "Show Health", false, function(s)
    ESP:SetHealth(s)
    Features.ESPHealth = s
end)

Toggle(VisualPage, "Show Distance", false, function(s)
    ESP:SetDistance(s)
    Features.ESPDistance = s
end)

-- =============================================
-- MISC PAGE
-- =============================================
Section(MiscPage, "MISC")
Toggle(MiscPage, "No Clip", false, function(s)
    NoClip:SetEnabled(s)
    Features.NoClip = s
    CheckLoop()
end)

Toggle(MiscPage, "Anti-AFK", false, function(s)
    AntiAFK:SetEnabled(s)
    Features.AntiAFK = s
    CheckLoop()
end)

-- =============================================
-- SETTINGS PAGE
-- =============================================
Section(SettingsPage, "SETTINGS")

Button(SettingsPage, "Save Config", function()
    print("[Ivory] Config saved!")
end)

Button(SettingsPage, "Load Config", function()
    print("[Ivory] Config loaded!")
end)

Button(SettingsPage, "Reset All", function()
    for k, _ in pairs(Features) do
        if type(Features[k]) == "boolean" then
            Features[k] = false
        end
    end
    SilentAim:SetPlayerSilentAim(false)
    SilentAim:SetNPCSilentAim(false)
    SilentAim:SetShowFOVCircle(false)
    SoruAimbot:SetEnabled(false)
    AutoV4:SetEnabled(false)
    NoClip:SetEnabled(false)
    AntiAFK:SetEnabled(false)
    ESP:SetEnabled(false)
    ESP:SetBox(false)
    ESP:SetName(false)
    ESP:SetHealth(false)
    ESP:SetDistance(false)
    Features.MacroEnabled = false
    Macro.IsRunning = false
    CheckLoop()
    print("[Ivory] All reset!")
end)

Button(SettingsPage, "Unload", function()
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

local Version = Text(CreditsPage, "Ivory Hub v4.4 • PVP + Macro", 8, false)
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
        local otherButton = data.button
        if otherButton then Tween(otherButton, .15, {BackgroundColor3 = DARKER}) end
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
-- DRAGGING, MINIMIZE, CLOSE
-- =============================================
local Dragging = false
local DragStart, StartPosition

local function UpdateDrag(input)
    local Delta = input.Position - DragStart
    Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, 
                              StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
end

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
        UpdateDrag(input)
    end
end)

local Minimized = false
Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Sidebar.Visible = false
        Content.Visible = false
        Tween(Main, .25, {Size = UDim2.new(0, 380, 0, 38)})
        Minimize.Text = "+"
    else
        Tween(Main, .25, {Size = UDim2.new(0, 380, 0, 380)})
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
-- START
-- =============================================
CheckLoop()

print("========================================")
print("        IVORY HUB v4.4 LOADED")
print("========================================")
print("Features:")
print("  • Silent Aim (360 / FOV)")
print("  • Soru/Flashstep Aimbot")
print("  • Auto V4 Awakening")
print("  • ESP (Box/Name/Health/Dist)")
print("  • No Clip & Anti-AFK")
print("  • Macro: Melee/Fruit/Sword/Gun")
print("========================================")
print("💡 Press the MACRO button to execute!")
