-- =============================================
-- IVORY HUB v10.9 - GRAVITY F AIMBOT
-- =============================================

print("🦷 Ivory Hub v10.9 loading...")

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
local Camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local parent = gethui and gethui() or CoreGui
local old = parent:FindFirstChild("IvoryHub")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "IvoryHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parent

local COLORS = {
    BLACK = Color3.fromRGB(7,7,7),
    DARK = Color3.fromRGB(13,13,13),
    DARKER = Color3.fromRGB(19,19,19),
    CARD = Color3.fromRGB(22,22,22),
    WHITE = Color3.fromRGB(245,245,245),
    GRAY = Color3.fromRGB(145,145,145),
    RED = Color3.fromRGB(255,50,50),
    GREEN = Color3.fromRGB(50,255,50),
    YELLOW = Color3.fromRGB(255,200,0),
    ACCENT = Color3.fromRGB(255,50,50),
}

local function Corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = o
end

local function Stroke(o, c, t)
    local s = Instance.new("UIStroke")
    s.Color = c or Color3.fromRGB(40,40,40)
    s.Thickness = t or 1
    s.Parent = o
    return s
end

local function TweenIt(o, p, t)
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play()
end

local function Text(parent, text, size, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = COLORS.WHITE
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

local Features = {
    SilentAim = false,
    SilentAimTarget = "Both",
    SilentAimMode = "360",
    SilentAimDistance = 500,
    SoruAim = false,
    SoruTarget = "Both",
    SoruMode = "360",
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPPlayers = true,
    ESPNPCs = true,
    FastAttack = false,
    GravityFAimbot = false,
    FOVCircle = false,
    FOVRadius = 150,
    FOVMode = "V1",
    Macro = false,
    MaxRange = 1000,
}

-- =============================================
-- CONFIG
-- =============================================
local CONFIG_FOLDER = "IvoryHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.txt"
local MACRO_FILE = CONFIG_FOLDER .. "/macro.txt"

pcall(function()
    if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

local function SaveConfig()
    local data = ""
    for k, v in pairs(Features) do
        local val = tostring(v)
        if type(v) == "boolean" then val = v and "true" or "false" end
        data = data .. k .. "=" .. val .. "\n"
    end
    pcall(function()
        if writefile then writefile(CONFIG_FILE, data) end
    end)
end

local function LoadConfig()
    local loaded = {}
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local content = readfile(CONFIG_FILE)
            for line in string.gmatch(content, "[^\r\n]+") do
                local k, v = string.match(line, "^([^=]+)=(.*)$")
                if k and v then
                    if v == "true" then loaded[k] = true
                    elseif v == "false" then loaded[k] = false
                    elseif tonumber(v) then loaded[k] = tonumber(v)
                    else loaded[k] = v end
                end
            end
        end
    end)
    for k, v in pairs(loaded) do
        if Features[k] ~= nil and type(v) ~= "boolean" then Features[k] = v end
    end
end

local function ResetConfig()
    for k, v in pairs(Features) do
        if type(v) == "boolean" then Features[k] = false end
    end
    Features.SilentAimTarget = "Both"
    Features.SilentAimMode = "360"
    Features.SilentAimDistance = 500
    Features.SoruTarget = "Both"
    Features.SoruMode = "360"
    Features.ESPBox = true
    Features.ESPName = true
    Features.ESPHealth = true
    Features.ESPDistance = true
    Features.ESPPlayers = true
    Features.ESPNPCs = true
    Features.FOVRadius = 150
    Features.FOVMode = "V1"
    Features.MaxRange = 1000
    SaveConfig()
end

LoadConfig()

-- =============================================
-- FOV
-- =============================================
local FOVGui = nil
local FOVRing = nil

local function getFOVCenter()
    if Features.FOVMode == "V2" then
        return UserInputService:GetMouseLocation()
    end
    return Camera.ViewportSize / 2
end

local function isInFOV(hrp)
    if not hrp then return false end
    local sp, on = Camera:WorldToViewportPoint(hrp.Position)
    if not on then return false end
    local c = getFOVCenter()
    return (Vector2.new(sp.X, sp.Y) - c).Magnitude <= Features.FOVRadius
end

local function UpdateFOVCircle()
    if Features.FOVCircle then
        if not FOVGui or not FOVGui.Parent then
            FOVGui = Instance.new("ScreenGui")
            FOVGui.Name = "IvoryFOV"
            FOVGui.ResetOnSpawn = false
            FOVGui.IgnoreGuiInset = true
            FOVGui.DisplayOrder = 1
            FOVGui.Parent = Gui
            FOVRing = Instance.new("Frame")
            FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
            FOVRing.BackgroundTransparency = 1
            FOVRing.BorderSizePixel = 0
            FOVRing.ZIndex = 100
            FOVRing.Parent = FOVGui
            Corner(FOVRing, 999)
            local s = Instance.new("UIStroke")
            s.Thickness = 2
            s.Color = COLORS.ACCENT
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Parent = FOVRing
        end
        if FOVRing then
            local c = getFOVCenter()
            local d = math.floor(Features.FOVRadius * 2)
            FOVRing.Position = UDim2.new(0, c.X, 0, c.Y)
            FOVRing.Size = UDim2.fromOffset(d, d)
            FOVRing.Visible = true
        end
    elseif FOVRing then
        FOVRing.Visible = false
    end
end

RunService.RenderStepped:Connect(function() pcall(UpdateFOVCircle) end)

local function isCombatNPC(model, hum, root)
    if not model or not hum or not root then return false end
    if hum.Health <= 0 then return false end
    local n = string.lower(model.Name)
    local block = {"shop","seller","dealer","quest","trainer","teacher","merchant",
        "gacha","title","dialog","manager","vendor","guide","helper","boat","customer",
        "spawn","luxury","bartender","captain","toribro","indra","nami","ability",
        "sword dealer","weapon","blox fruit","crew","quest giver","town","citizen"}
    for _, w in ipairs(block) do
        if string.find(n, w, 1, true) then return false end
    end
    if model:FindFirstChildWhichIsA("ProximityPrompt", true) then return false end
    if model:FindFirstChildWhichIsA("ClickDetector", true) then return false end
    if hum.MaxHealth < 100 then return false end
    return true
end

local function GetNearestTarget(targetType, mode, maxDist)
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local best, bestDist = nil, math.huge
    local maxRange = maxDist or Features.MaxRange or 1000

    if targetType == "Players" or targetType == "Both" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= maxRange then
                        if mode == "FOV" then
                            if isInFOV(hrp) and dist < bestDist then
                                bestDist = dist
                                best = hrp
                            end
                        else
                            if dist < bestDist then
                                bestDist = dist
                                best = hrp
                            end
                        end
                    end
                end
            end
        end
    end

    if targetType == "NPCs" or targetType == "Both" then
        local fns = {"Enemies","Enemy","Monsters","Monster","Mobs","Mob","Bosses","Boss"}
        for _, name in ipairs(fns) do
            local folder = workspace:FindFirstChild(name)
            if folder then
                for _, npc in pairs(folder:GetChildren()) do
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and isCombatNPC(npc, hum, hrp) then
                            local dist = (hrp.Position - root.Position).Magnitude
                            if dist <= maxRange then
                                if mode == "FOV" then
                                    if isInFOV(hrp) and dist < bestDist then
                                        bestDist = dist
                                        best = hrp
                                    end
                                else
                                    if dist < bestDist then
                                        bestDist = dist
                                        best = hrp
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function FaceTarget(targetHrp)
    if not targetHrp then return end
    local char = player.Character
    if not char then return end
    local myHrp = char:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    pcall(function()
        local look = (Vector3.new(targetHrp.Position.X, myHrp.Position.Y, targetHrp.Position.Z) - myHrp.Position).Unit
        if look.Magnitude > 0.001 then
            myHrp.CFrame = CFrame.lookAt(myHrp.Position, myHrp.Position + look)
        end
    end)
end

local TargetPos = nil

pcall(function()
    local mt = getrawmetatable(game)
    if not mt then return end
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__index = function(self, key)
        if not checkcaller() and self == mouse and Features.SilentAim then
            if key == "Hit" or key == "Target" then
                local t = GetNearestTarget(Features.SilentAimTarget, Features.SilentAimMode, Features.SilentAimDistance)
                if t then
                    TargetPos = t.Position
                    if key == "Hit" then return CFrame.new(TargetPos) end
                    if key == "Target" then return nil end
                end
            end
        end
        return oldIndex(self, key)
    end

    mt.__namecall = function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        -- =============================================
        -- GRAVITY F AIMBOT CHECK
        -- =============================================
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            local isGravityF = false
            local gravityFIndex = nil
            for i, arg in ipairs(args) do
                if typeof(arg) == "string" and string.upper(arg) == "F" then
                    isGravityF = true
                    gravityFIndex = i
                    break
                end
            end

            if isGravityF then
                if not Features.GravityFAimbot then
                    -- Gravity F OFF: normal fire, no aimbot
                    return oldNamecall(self, ...)
                end
                -- Gravity F ON: aim at nearest target
                local target = GetNearestTarget("Both", "360", 500)
                if target then
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = target.Position
                        elseif typeof(arg) == "CFrame" then
                            args[i] = CFrame.new(target.Position)
                        end
                    end
                    -- Face the target too
                    task.spawn(function() FaceTarget(target) end)
                    return oldNamecall(self, unpack(args))
                end
                return oldNamecall(self, ...)
            end
        end

        -- =============================================
        -- NORMAL SILENT AIM CHECK
        -- =============================================
        if not checkcaller() and Features.SilentAim and TargetPos then
            if method == "FireServer" or method == "InvokeServer" then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then args[i] = TargetPos
                    elseif typeof(v) == "CFrame" then args[i] = CFrame.new(TargetPos) end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end
    setreadonly(mt, true)
end)

task.spawn(function()
    while Gui and Gui.Parent do
        if not Features.SilentAim and not Features.GravityFAimbot then
            TargetPos = nil
        else
            local t = GetNearestTarget(Features.SilentAimTarget, Features.SilentAimMode, Features.SilentAimDistance)
            if t then
                TargetPos = t.Position
            else
                TargetPos = nil
            end
        end
        task.wait(0.05)
    end
end)

local SoruRemote = nil
local SoruCooldown = 0

task.spawn(function()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then SoruRemote = remotes:FindFirstChild("CommF_") end
        if not SoruRemote then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj.Name == "CommF_" then SoruRemote = obj break end
            end
        end
    end)
end)

local function DoSoruTeleport()
    if not Features.SoruAim then return end
    if tick() < SoruCooldown then return end
    local target = GetNearestTarget(Features.SoruTarget, Features.SoruMode, Features.MaxRange)
    if not target then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        if SoruRemote then
            SoruRemote:InvokeServer("Soru", target.Position)
        else
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
        end
        SoruCooldown = tick() + 0.8
    end)
end

local function MonitorFlashstep(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.AnimationPlayed:Connect(function(track)
        if not Features.SoruAim then return end
        if tick() < SoruCooldown then return end
        local n = string.lower(track.Name or "")
        local id = tostring(track.Animation and track.Animation.AnimationId or "")
        if string.find(n, "flashstep") or string.find(n, "soru") or
           string.find(n, "dash") or string.find(n, "dodge") or
           string.find(n, "skywalk") or string.find(n, "geppo") or
           string.find(n, "flash") or
           string.find(id, "17555632156") or string.find(id, "616006778") or
           string.find(id, "1846164274") or string.find(id, "1846163351") or
           string.find(id, "11420797633") then
            DoSoruTeleport()
        end
    end)
end

player.CharacterAdded:Connect(function(c) task.wait(0.5) MonitorFlashstep(c) end)
if player.Character then task.wait(0.5) MonitorFlashstep(player.Character) end

local FastAttack = (function()
    local module = {}
    local RegisterAttack, RegisterHit
    local RANGE = 25
    local SPEED = 0.08

    task.spawn(function()
        local modules = ReplicatedStorage:WaitForChild("Modules", 10)
        if not modules then return end
        local net = modules:WaitForChild("Net", 10)
        if not net then return end
        RegisterAttack = net:WaitForChild("RE/RegisterAttack", 10)
        RegisterHit = net:WaitForChild("RE/RegisterHit", 10)
    end)

    local function getTargets()
        local list = {}
        local myChar = player.Character
        if not myChar then return list end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return list end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    local dist = (hrp.Position - myRoot.Position).Magnitude
                    if dist <= RANGE then
                        table.insert(list, {model = plr.Character, root = hrp, dist = dist})
                    end
                end
            end
        end

        local fns = {"Enemies","Enemy","Monsters","Monster","Mobs","Mob","Bosses","Boss"}
        for _, name in ipairs(fns) do
            local folder = workspace:FindFirstChild(name)
            if folder then
                for _, npc in pairs(folder:GetChildren()) do
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and hrp and isCombatNPC(npc, hum, hrp) then
                            local dist = (hrp.Position - myRoot.Position).Magnitude
                            if dist <= RANGE then
                                table.insert(list, {model = npc, root = hrp, dist = dist})
                            end
                        end
                    end
                end
            end
        end

        return list
    end

    local function fire(target)
        if not RegisterAttack or not RegisterHit then return end
        pcall(function()
            RegisterAttack:FireServer()
            if target then
                local targetModel = target.model
                local targetRoot = target.root
                local targetHead = targetModel:FindFirstChild("Head") or targetRoot
                if targetRoot and targetHead then
                    local hitData = {}
                    for _, part in pairs(targetModel:GetChildren()) do
                        if part:IsA("BasePart") then
                            table.insert(hitData, {targetModel, part})
                        end
                    end
                    local sessionId = tostring(math.random(1, 100000))
                    RegisterHit:FireServer(targetHead, hitData, {}, sessionId)
                end
            end
        end)
    end

    local conn, last = nil, 0
    function module:SetEnabled(state)
        if state and not conn then
            conn = RunService.Heartbeat:Connect(function()
                if not Features.FastAttack then return end
                if tick() - last < SPEED then return end
                last = tick()
                local targets = getTargets()
                if #targets == 0 then
                    fire(nil)
                    return
                end
                table.sort(targets, function(a, b) return a.dist < b.dist end)
                for _, t in ipairs(targets) do
                    fire(t)
                end
            end)
        elseif not state and conn then
            conn:Disconnect()
            conn = nil
        end
    end
    return module
end)()

-- =============================================
-- ESP
-- =============================================
local ESPData = {}

local function CreateESP(target, displayName)
    if ESPData[target] then return end
    local char = target:IsA("Player") and target.Character or target
    if not char then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "IvoryESP"
    gui.Adornee = head
    gui.Size = UDim2.new(0, 100, 0, 60)
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true
    gui.Parent = head

    local box = Instance.new("Frame")
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.Size = UDim2.new(0, 30, 0, 40)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = gui
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.ACCENT
    stroke.Thickness = 1
    stroke.Parent = box

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, 0, 0, 12)
    nameL.Position = UDim2.new(0, 0, 0.5, -34)
    nameL.BackgroundTransparency = 1
    nameL.Text = displayName or "NPC"
    nameL.TextColor3 = COLORS.WHITE
    nameL.TextStrokeTransparency = 0
    nameL.TextStrokeColor3 = Color3.new(0,0,0)
    nameL.TextSize = 10
    nameL.Font = Enum.Font.GothamBold
    nameL.TextXAlignment = Enum.TextXAlignment.Center
    nameL.Parent = gui

    local hpText = Instance.new("TextLabel")
    hpText.Size = UDim2.new(1, 0, 0, 11)
    hpText.Position = UDim2.new(0, 0, 0.5, 22)
    hpText.BackgroundTransparency = 1
    hpText.Text = "100%"
    hpText.TextColor3 = COLORS.GREEN
    hpText.TextStrokeTransparency = 0
    hpText.TextStrokeColor3 = Color3.new(0,0,0)
    hpText.TextSize = 10
    hpText.Font = Enum.Font.GothamBold
    hpText.TextXAlignment = Enum.TextXAlignment.Center
    hpText.Parent = gui

    local distL = Instance.new("TextLabel")
    distL.Size = UDim2.new(1, 0, 0, 11)
    distL.Position = UDim2.new(0, 0, 0.5, 32)
    distL.BackgroundTransparency = 1
    distL.Text = "0m"
    distL.TextColor3 = COLORS.GRAY
    distL.TextStrokeTransparency = 0
    distL.TextStrokeColor3 = Color3.new(0,0,0)
    distL.TextSize = 10
    distL.Font = Enum.Font.Gotham
    distL.TextXAlignment = Enum.TextXAlignment.Center
    distL.Parent = gui

    local healthBg = Instance.new("Frame")
    healthBg.AnchorPoint = Vector2.new(0.5, 0.5)
    healthBg.Size = UDim2.new(0, 30, 0, 2)
    healthBg.Position = UDim2.new(0.5, 0, 0.5, -22)
    healthBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = gui
    Corner(healthBg, 2)

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = COLORS.GREEN
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    Corner(healthFill, 2)

    ESPData[target] = {
        gui = gui, box = box, stroke = stroke,
        name = nameL, dist = distL,
        healthBg = healthBg, healthFill = healthFill, hpText = hpText,
    }
end

local function UpdateESP()
    if not Features.ESP then
        for _, d in pairs(ESPData) do pcall(function() d.gui.Visible = false end) end
        return
    end
    local current = {}
    local cam = Camera

    local function apply(d, name, root, hum)
        d.gui.Visible = true
        local dist = (root.Position - cam.CFrame.Position).Magnitude
        d.name.Text = name
        d.dist.Text = math.floor(dist) .. "m"
        local hp = hum.Health / math.max(hum.MaxHealth, 1)
        d.healthFill.Size = UDim2.new(hp, 0, 1, 0)
        d.hpText.Text = math.floor(hp * 100) .. "%"
        local col
        if hp > 0.5 then col = COLORS.GREEN
        elseif hp > 0.25 then col = COLORS.YELLOW
        else col = COLORS.RED end
        d.healthFill.BackgroundColor3 = col
        d.hpText.TextColor3 = col
        d.box.Visible = Features.ESPBox
        d.stroke.Visible = Features.ESPBox
        d.name.Visible = Features.ESPName
        d.healthBg.Visible = Features.ESPHealth
        d.hpText.Visible = Features.ESPHealth
        d.dist.Visible = Features.ESPDistance
    end

    if Features.ESPPlayers then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and root then
                        if not ESPData[plr] then CreateESP(plr, plr.Name) end
                        current[plr] = true
                        if ESPData[plr] then apply(ESPData[plr], plr.Name, root, hum) end
                    end
                end
            end
        end
    end

    if Features.ESPNPCs then
        local fns = {"Enemies","Enemy","Monsters","Monster","Mobs","Mob","Bosses","Boss"}
        for _, name in ipairs(fns) do
            local folder = Workspace:FindFirstChild(name)
            if folder then
                for _, npc in pairs(folder:GetChildren()) do
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        local root = npc:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and root and isCombatNPC(npc, hum, root) then
                            if not ESPData[npc] then CreateESP(npc, npc.Name) end
                            current[npc] = true
                            if ESPData[npc] then apply(ESPData[npc], npc.Name, root, hum) end
                        end
                    end
                end
            end
        end
    end

    for t, d in pairs(ESPData) do
        if not current[t] then
            pcall(function() d.gui:Destroy() end)
            ESPData[t] = nil
        end
    end
end

RunService.Heartbeat:Connect(function() pcall(UpdateESP) end)

-- =============================================
-- MACRO SYSTEM - 10 SLOTS
-- =============================================
local WEAPON_TYPES = {"Melee", "Fruit", "Sword", "Gun"}
local SLOT_FOR_WEAPON = {
    Melee = 1,
    Fruit = 2,
    Sword = 3,
    Gun = 4,
}
local SKILL_OPTIONS = {"Z", "X", "C", "V", "F", "M1", "OFF"}

local MacroSlots = {}
for i = 1, 10 do
    MacroSlots[i] = {
        weapon = "Melee",
        skill = (i == 1 and "Z") or (i == 2 and "X") or "OFF",
        delay = 0.30,
    }
end

local SLOT_KEYS = {
    [1] = Enum.KeyCode.One,
    [2] = Enum.KeyCode.Two,
    [3] = Enum.KeyCode.Three,
    [4] = Enum.KeyCode.Four,
}

local MacroRunning = false
local MacroThread = nil

local function SaveMacroConfig()
    local data = ""
    for i, slot in ipairs(MacroSlots) do
        data = data .. i .. "|" .. slot.weapon .. "|" .. slot.skill .. "|" .. slot.delay .. "\n"
    end
    pcall(function()
        if writefile then writefile(MACRO_FILE, data) end
    end)
end

local function LoadMacroConfig()
    pcall(function()
        if readfile and isfile and isfile(MACRO_FILE) then
            local content = readfile(MACRO_FILE)
            for line in string.gmatch(content, "[^\r\n]+") do
                local i, w, s, d = string.match(line, "^(%d+)|([^|]+)|([^|]+)|([%d%.]+)$")
                if i and tonumber(i) and MacroSlots[tonumber(i)] then
                    MacroSlots[tonumber(i)].weapon = w
                    MacroSlots[tonumber(i)].skill = s
                    MacroSlots[tonumber(i)].delay = tonumber(d) or 0.30
                end
            end
        end
    end)
end

LoadMacroConfig()

local function pressKey(kc)
    if not kc then return end
    pcall(function()
        VIM:SendKeyEvent(true, kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)
end

local function equipWeaponSlot(slotNum)
    local kc = SLOT_KEYS[slotNum]
    if not kc then return end
    pressKey(kc)
    task.wait(0.15)
    local char = player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        pressKey(kc)
        task.wait(0.1)
    end
end

local function ExecuteMacro()
    if MacroRunning then return end
    MacroRunning = true
    MacroThread = task.spawn(function()
        local lastWeapon = nil
        while MacroRunning do
            for i, item in ipairs(MacroSlots) do
                if not MacroRunning then break end
                if item.skill and item.skill ~= "OFF" then
                    if item.weapon ~= lastWeapon then
                        local slotNum = SLOT_FOR_WEAPON[item.weapon] or 1
                        equipWeaponSlot(slotNum)
                        lastWeapon = item.weapon
                    end
                    if item.skill == "M1" then
                        local vp = Camera.ViewportSize
                        pcall(function()
                            VIM:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 1)
                            task.wait(0.05)
                            VIM:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 1)
                        end)
                    else
                        local kc = Enum.KeyCode[item.skill]
                        if kc then pressKey(kc) end
                    end
                    task.wait(item.delay or 0.30)
                end
            end
        end
        MacroRunning = false
        MacroThread = nil
    end)
end

local function StopMacro()
    MacroRunning = false
    if MacroThread then
        pcall(function() task.cancel(MacroThread) end)
        MacroThread = nil
    end
end

-- =============================================
-- MACRO BUTTON
-- =============================================
local MacroBtn = Instance.new("TextButton")
MacroBtn.Name = "IvoryMacroBtn"
MacroBtn.Size = UDim2.fromOffset(70, 70)
MacroBtn.Position = UDim2.new(0.85, -35, 0.7, -35)
MacroBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MacroBtn.BackgroundTransparency = 0.15
MacroBtn.Text = "MACRO"
MacroBtn.TextColor3 = COLORS.WHITE
MacroBtn.TextSize = 11
MacroBtn.Font = Enum.Font.GothamBold
MacroBtn.BorderSizePixel = 0
MacroBtn.Visible = false
MacroBtn.Parent = Gui
Corner(MacroBtn, 999)
Stroke(MacroBtn, Color3.fromRGB(60, 60, 60), 1.5)

local macroDrag = {active = false, moved = false, startPos = nil, startMouse = nil}

MacroBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.active = true
        macroDrag.moved = false
        macroDrag.startMouse = input.Position
        macroDrag.startPos = MacroBtn.Position
    end
end)

MacroBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        macroDrag.active = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not macroDrag.active then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - macroDrag.startMouse
    if delta.Magnitude > 6 then macroDrag.moved = true end
    MacroBtn.Position = UDim2.new(
        macroDrag.startPos.X.Scale,
        macroDrag.startPos.X.Offset + delta.X,
        macroDrag.startPos.Y.Scale,
        macroDrag.startPos.Y.Offset + delta.Y
    )
end)

MacroBtn.MouseButton1Click:Connect(function()
    if macroDrag.moved then return end
    if MacroRunning then
        StopMacro()
        MacroBtn.Text = "MACRO"
        MacroBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MacroBtn.TextColor3 = COLORS.WHITE
    else
        ExecuteMacro()
        MacroBtn.Text = "STOP"
        MacroBtn.BackgroundColor3 = COLORS.RED
        MacroBtn.TextColor3 = COLORS.WHITE
    end
end)

-- =============================================
-- UI
-- =============================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(42,42)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -21)
ToggleBtn.BackgroundColor3 = COLORS.BLACK
ToggleBtn.BorderColor3 = COLORS.ACCENT
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "I"
ToggleBtn.TextColor3 = COLORS.WHITE
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Gui
Corner(ToggleBtn, 10)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 340)
Main.Position = UDim2.new(0.5, -250, 0.5, -170)
Main.BackgroundColor3 = COLORS.BLACK
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = Gui
Corner(Main, 14)
Stroke(Main, COLORS.ACCENT, 1.5)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 44)
Top.BackgroundColor3 = COLORS.DARK
Top.BorderSizePixel = 0
Top.Parent = Main
Corner(Top, 14)

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -20, 0, 1)
headerLine.Position = UDim2.new(0, 10, 1, -1)
headerLine.BackgroundColor3 = COLORS.ACCENT
headerLine.BackgroundTransparency = 0.5
headerLine.BorderSizePixel = 0
headerLine.Parent = Top

local Title = Text(Top, "IVORY", 18, true)
Title.Position = UDim2.new(0, 15, 0, 4)
Title.Size = UDim2.new(0, 100, 0, 22)

local SubTitle = Text(Top, "HUB", 9, false)
SubTitle.TextColor3 = COLORS.ACCENT
SubTitle.Position = UDim2.new(0, 16, 0, 26)
SubTitle.Size = UDim2.new(0, 60, 0, 12)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 26, 0, 26)
Close.Position = UDim2.new(1, -32, 0.5, -13)
Close.BackgroundColor3 = COLORS.DARKER
Close.Text = "×"
Close.TextColor3 = COLORS.WHITE
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Top
Corner(Close, 8)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 26, 0, 26)
Minimize.Position = UDim2.new(1, -62, 0.5, -13)
Minimize.BackgroundColor3 = COLORS.DARKER
Minimize.Text = "—"
Minimize.TextColor3 = COLORS.WHITE
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.BorderSizePixel = 0
Minimize.Parent = Top
Corner(Minimize, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    TweenIt(ToggleBtn, Main.Visible and
        {BackgroundColor3 = COLORS.ACCENT, TextColor3 = COLORS.BLACK} or
        {BackgroundColor3 = COLORS.BLACK, TextColor3 = COLORS.WHITE})
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 95, 1, -54)
Sidebar.Position = UDim2.new(0, 8, 0, 50)
Sidebar.BackgroundColor3 = COLORS.DARK
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Corner(Sidebar, 12)
Stroke(Sidebar)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Sidebar

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 6)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 4)
Pad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -111, 1, -54)
Content.Position = UDim2.new(0, 103, 0, 50)
Content.BackgroundColor3 = COLORS.DARK
Content.BorderSizePixel = 0
Content.Parent = Main
Corner(Content, 12)
Stroke(Content)

local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = COLORS.ACCENT
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = page
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 10)
    end)
    Pages[name] = page
    return page
end

local function Section(parent, text)
    local l = Text(parent, text, 8, true)
    l.TextColor3 = COLORS.ACCENT
    l.Size = UDim2.new(1, 0, 0, 14)
    return l
end

local function Button(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = COLORS.CARD
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = COLORS.WHITE
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent
    Corner(b, 8)
    Stroke(b, Color3.fromRGB(35,35,35), 1)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function CycleButton(parent, text, options, default, cb)
    local idx = 1
    for i, o in ipairs(options) do if o == default then idx = i break end end
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = COLORS.CARD
    b.BorderSizePixel = 0
    b.Text = text .. ": " .. options[idx]
    b.TextColor3 = COLORS.WHITE
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent
    Corner(b, 8)
    Stroke(b, Color3.fromRGB(35,35,35), 1)
    b.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        b.Text = text .. ": " .. options[idx]
        if cb then cb(options[idx]) end
    end)
    return b
end

local function Toggle(parent, text, default, cb)
    local state = default or false
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 26)
    h.BackgroundColor3 = COLORS.CARD
    h.BorderSizePixel = 0
    h.Parent = parent
    Corner(h, 8)
    Stroke(h, Color3.fromRGB(35,35,35), 1)
    local lbl = Text(h, text .. ": OFF", 10, false)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 26, 0, 14)
    sw.Position = UDim2.new(1, -34, 0.5, -7)
    sw.BackgroundColor3 = Color3.fromRGB(35,35,35)
    sw.Text = ""
    sw.BorderSizePixel = 0
    sw.Parent = h
    Corner(sw, 20)
    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 10, 0, 10)
    ball.Position = UDim2.new(0, 2, 0.5, -5)
    ball.BackgroundColor3 = COLORS.GRAY
    ball.BorderSizePixel = 0
    ball.Parent = sw
    Corner(ball, 20)
    local function Update()
        if state then
            TweenIt(sw, {BackgroundColor3 = COLORS.ACCENT})
            TweenIt(ball, {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = COLORS.WHITE})
            lbl.Text = text .. ": ON"
        else
            TweenIt(sw, {BackgroundColor3 = Color3.fromRGB(35,35,35)})
            TweenIt(ball, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = COLORS.GRAY})
            lbl.Text = text .. ": OFF"
        end
        if cb then cb(state) end
    end
    sw.MouseButton1Click:Connect(function() state = not state Update() end)
    Update()
    return h
end

local function Slider(parent, text, default, minVal, maxVal, cb, suffix)
    local Value = default or 50
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 36)
    h.BackgroundColor3 = COLORS.CARD
    h.BorderSizePixel = 0
    h.Parent = parent
    Corner(h, 8)
    Stroke(h, Color3.fromRGB(35,35,35), 1)
    local lbl = Text(h, text .. ": " .. tostring(Value) .. (suffix or ""), 10, false)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    local barHolder = Instance.new("Frame")
    barHolder.Size = UDim2.new(1, -20, 0, 20)
    barHolder.Position = UDim2.new(0, 10, 0, 22)
    barHolder.BackgroundTransparency = 1
    barHolder.Parent = h
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 0, 4)
    bg.Position = UDim2.new(0, 0, 0.5, -2)
    bg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    bg.BorderSizePixel = 0
    bg.Parent = barHolder
    Corner(bg, 4)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Value - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Corner(fill, 4)
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new((Value - minVal) / (maxVal - minVal), -9, 0.5, -9)
    knob.BackgroundColor3 = COLORS.WHITE
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Corner(knob, 20)
    Stroke(knob, COLORS.ACCENT, 2)
    local dragging = false
    local function UpdateSlider(v)
        local cv = math.clamp(v, minVal, maxVal)
        Value = cv
        local r = (cv - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, -9, 0.5, -9)
        lbl.Text = text .. ": " .. tostring(math.floor(cv * 100) / 100) .. (suffix or "")
        if cb then cb(cv) end
    end
    local fullBar = Instance.new("TextButton")
    fullBar.Size = UDim2.new(1, 0, 0, 20)
    fullBar.Position = UDim2.new(0, 0, 0.5, -10)
    fullBar.BackgroundTransparency = 1
    fullBar.Text = ""
    fullBar.Parent = barHolder
    fullBar.MouseButton1Down:Connect(function() dragging = true end)
    fullBar.MouseButton1Up:Connect(function() dragging = false end)
    fullBar.MouseLeave:Connect(function() dragging = false end)
    knob.MouseButton1Down:Connect(function() dragging = true end)
    knob.MouseButton1Up:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position
            local ap = bg.AbsolutePosition
            local sz = bg.AbsoluteSize.X
            local rx = math.clamp(pos.X - ap.X, 0, sz)
            UpdateSlider(minVal + (rx / sz) * (maxVal - minVal))
        end
    end)
    return h
end

local MainPage = CreatePage("Main")
local CombatPage = CreatePage("Combat")
local FastPage = CreatePage("Fast")
local MacroPage = CreatePage("Macro")
local VisualPage = CreatePage("Visual")
local ConfigPage = CreatePage("Config")
local SocialsPage = CreatePage("Socials")
local AboutPage = CreatePage("About")

Section(MainPage, "IVORY HUB")
local mt = Text(MainPage, "IVORY HUB v10.9", 16, true)
mt.Size = UDim2.new(1, 0, 0, 24)
mt.TextXAlignment = Enum.TextXAlignment.Center
mt.TextColor3 = COLORS.WHITE

local msub = Text(MainPage, "Blox Fruits PVP Hub", 10, false)
msub.Size = UDim2.new(1, 0, 0, 16)
msub.Position = UDim2.new(0, 0, 0, 26)
msub.TextXAlignment = Enum.TextXAlignment.Center
msub.TextColor3 = COLORS.GRAY

Section(MainPage, "STATUS")
local statusLbl = Text(MainPage, "Active: None", 10, false)
statusLbl.Size = UDim2.new(1, -10, 0, 16)
statusLbl.Position = UDim2.new(0, 5, 0, 60)
statusLbl.TextColor3 = COLORS.GREEN

task.spawn(function()
    while Gui and Gui.Parent do
        local active = {}
        if Features.SilentAim then table.insert(active, "Silent Aim") end
        if Features.SoruAim then table.insert(active, "Soru") end
        if Features.FastAttack then table.insert(active, "Fast") end
        if Features.GravityFAimbot then table.insert(active, "Gravity F") end
        if Features.ESP then table.insert(active, "ESP") end
        if MacroRunning then table.insert(active, "Macro") end
        if statusLbl and statusLbl.Parent then
            if #active == 0 then
                statusLbl.Text = "Active: None"
                statusLbl.TextColor3 = COLORS.GRAY
            else
                statusLbl.Text = "Active: " .. table.concat(active, ", ")
                statusLbl.TextColor3 = COLORS.GREEN
            end
        end
        task.wait(0.5)
    end
end)

Section(MainPage, "TIP")
local tipLbl = Text(MainPage, "Hold the I button to drag UI", 10, false)
tipLbl.Size = UDim2.new(1, -10, 0, 16)
tipLbl.Position = UDim2.new(0, 5, 0, 85)
tipLbl.TextColor3 = COLORS.GRAY

Section(CombatPage, "SILENT AIM")
Toggle(CombatPage, "Enable Silent Aim", Features.SilentAim, function(s) Features.SilentAim = s SaveConfig() end)
CycleButton(CombatPage, "Target", {"Both","Players","NPCs"}, Features.SilentAimTarget, function(v) Features.SilentAimTarget = v SaveConfig() end)
CycleButton(CombatPage, "Mode", {"360","FOV"}, Features.SilentAimMode, function(v) Features.SilentAimMode = v SaveConfig() end)
Slider(CombatPage, "Aim Distance", Features.SilentAimDistance, 0, 2000, function(v) Features.SilentAimDistance = v SaveConfig() end, "m")

Section(CombatPage, "SORU")
Toggle(CombatPage, "Enable Soru", Features.SoruAim, function(s) Features.SoruAim = s SaveConfig() end)
CycleButton(CombatPage, "Soru Target", {"Both","Players","NPCs"}, Features.SoruTarget, function(v) Features.SoruTarget = v SaveConfig() end)
CycleButton(CombatPage, "Soru Mode", {"360","FOV"}, Features.SoruMode, function(v) Features.SoruMode = v SaveConfig() end)

Section(CombatPage, "FOV")
Toggle(CombatPage, "Show FOV Circle", Features.FOVCircle, function(s) Features.FOVCircle = s SaveConfig() end)
Slider(CombatPage, "FOV Radius", Features.FOVRadius, 10, 500, function(v) Features.FOVRadius = v SaveConfig() end)
CycleButton(CombatPage, "FOV Mode", {"V1","V2"}, Features.FOVMode, function(v) Features.FOVMode = v SaveConfig() end)

Section(FastPage, "FAST ATTACK")
Toggle(FastPage, "Enable Fast Attack", Features.FastAttack, function(s)
    Features.FastAttack = s
    FastAttack:SetEnabled(s)
    SaveConfig()
end)
local fastInfo = Text(FastPage, "Attacks NPCs + Players within 25 studs", 9, false)
fastInfo.Size = UDim2.new(1, -10, 0, 14)
fastInfo.TextColor3 = COLORS.GRAY
fastInfo.TextXAlignment = Enum.TextXAlignment.Center

Section(FastPage, "GRAVITY F AIMBOT")
Toggle(FastPage, "Gravity F Aimbot", Features.GravityFAimbot, function(s)
    Features.GravityFAimbot = s
    SaveConfig()
end)
local gravityInfo = Text(FastPage, "ON: Gravity F targets nearest enemy\nOFF: Gravity F fires normally", 9, false)
gravityInfo.Size = UDim2.new(1, -10, 0, 28)
gravityInfo.TextColor3 = COLORS.GRAY
gravityInfo.TextXAlignment = Enum.TextXAlignment.Center
gravityInfo.TextWrapped = true

Section(MacroPage, "MACRO")
Toggle(MacroPage, "Enable Macro", Features.Macro, function(s)
    Features.Macro = s
    MacroBtn.Visible = s
    SaveConfig()
end)

local macroInfo = Text(MacroPage, "Tap the MACRO button on screen to start/stop.", 9, false)
macroInfo.Size = UDim2.new(1, -10, 0, 14)
macroInfo.TextColor3 = COLORS.GRAY
macroInfo.TextXAlignment = Enum.TextXAlignment.Center

Section(MacroPage, "SLOTS")

local slotUI = {}

for i = 1, 10 do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 26)
    row.BackgroundColor3 = COLORS.CARD
    row.BorderSizePixel = 0
    row.Parent = MacroPage
    Corner(row, 6)
    Stroke(row, Color3.fromRGB(35,35,35), 1)

    local numL = Text(row, "#" .. i, 9, true)
    numL.Position = UDim2.new(0, 6, 0, 0)
    numL.Size = UDim2.new(0, 22, 1, 0)
    numL.TextColor3 = COLORS.ACCENT

    local weaponBtn = Instance.new("TextButton")
    weaponBtn.Size = UDim2.new(0, 60, 0, 20)
    weaponBtn.Position = UDim2.new(0, 30, 0.5, -10)
    weaponBtn.BackgroundColor3 = COLORS.DARKER
    weaponBtn.Text = MacroSlots[i].weapon
    weaponBtn.TextColor3 = COLORS.WHITE
    weaponBtn.TextSize = 9
    weaponBtn.Font = Enum.Font.GothamMedium
    weaponBtn.BorderSizePixel = 0
    weaponBtn.Parent = row
    Corner(weaponBtn, 5)
    Stroke(weaponBtn, Color3.fromRGB(60,60,60), 1)

    local skillBtn = Instance.new("TextButton")
    skillBtn.Size = UDim2.new(0, 42, 0, 20)
    skillBtn.Position = UDim2.new(0, 94, 0.5, -10)
    skillBtn.BackgroundColor3 = COLORS.DARKER
    skillBtn.Text = MacroSlots[i].skill
    skillBtn.TextColor3 = COLORS.WHITE
    skillBtn.TextSize = 9
    skillBtn.Font = Enum.Font.GothamMedium
    skillBtn.BorderSizePixel = 0
    skillBtn.Parent = row
    Corner(skillBtn, 5)
    Stroke(skillBtn, Color3.fromRGB(60,60,60), 1)

    local delayLbl = Text(row, string.format("%.2fs", MacroSlots[i].delay), 9, false)
    delayLbl.Position = UDim2.new(0, 142, 0, 0)
    delayLbl.Size = UDim2.new(0, 48, 1, 0)
    delayLbl.TextColor3 = COLORS.GRAY

    local dBar = Instance.new("Frame")
    dBar.Size = UDim2.new(0, 90, 0, 3)
    dBar.Position = UDim2.new(1, -100, 0.5, -1.5)
    dBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
    dBar.BorderSizePixel = 0
    dBar.Parent = row
    Corner(dBar, 2)

    local dFill = Instance.new("Frame")
    dFill.Size = UDim2.new((MacroSlots[i].delay - 0.05) / (2.0 - 0.05), 0, 1, 0)
    dFill.BackgroundColor3 = COLORS.ACCENT
    dFill.BorderSizePixel = 0
    dFill.Parent = dBar
    Corner(dFill, 2)

    local dKnob = Instance.new("TextButton")
    dKnob.Size = UDim2.new(0, 8, 0, 8)
    dKnob.Position = UDim2.new((MacroSlots[i].delay - 0.05) / (2.0 - 0.05), -4, 0.5, -4)
    dKnob.BackgroundColor3 = COLORS.WHITE
    dKnob.Text = ""
    dKnob.BorderSizePixel = 0
    dKnob.Parent = dBar
    Corner(dKnob, 8)

    weaponBtn.MouseButton1Click:Connect(function()
        local cur = MacroSlots[i].weapon
        local idx = 1
        for j, w in ipairs(WEAPON_TYPES) do if w == cur then idx = j break end end
        idx = idx % #WEAPON_TYPES + 1
        MacroSlots[i].weapon = WEAPON_TYPES[idx]
        weaponBtn.Text = MacroSlots[i].weapon
        SaveMacroConfig()
    end)

    skillBtn.MouseButton1Click:Connect(function()
        local cur = MacroSlots[i].skill
        local idx = 1
        for j, s in ipairs(SKILL_OPTIONS) do if s == cur then idx = j break end end
        idx = idx % #SKILL_OPTIONS + 1
        MacroSlots[i].skill = SKILL_OPTIONS[idx]
        skillBtn.Text = MacroSlots[i].skill
        SaveMacroConfig()
    end)

    local dragging = false
    local function updateDelayFromPos(pos)
        local ap = dBar.AbsolutePosition
        local sz = dBar.AbsoluteSize.X
        local rx = math.clamp(pos.X - ap.X, 0, sz)
        local ratio = rx / sz
        local newDelay = math.floor((0.05 + ratio * (2.0 - 0.05)) * 100 + 0.5) / 100
        MacroSlots[i].delay = newDelay
        dFill.Size = UDim2.new(ratio, 0, 1, 0)
        dKnob.Position = UDim2.new(ratio, -4, 0.5, -4)
        delayLbl.Text = string.format("%.2fs", newDelay)
        SaveMacroConfig()
    end

    dBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateDelayFromPos(input.Position)
        end
    end)
    dKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateDelayFromPos(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    slotUI[i] = {weaponBtn = weaponBtn, skillBtn = skillBtn, delayLbl = delayLbl}
end

Section(VisualPage, "ESP")
Toggle(VisualPage, "Enable ESP", Features.ESP, function(s) Features.ESP = s SaveConfig() end)
Toggle(VisualPage, "Box", Features.ESPBox, function(s) Features.ESPBox = s SaveConfig() end)
Toggle(VisualPage, "Name", Features.ESPName, function(s) Features.ESPName = s SaveConfig() end)
Toggle(VisualPage, "Health %", Features.ESPHealth, function(s) Features.ESPHealth = s SaveConfig() end)
Toggle(VisualPage, "Distance", Features.ESPDistance, function(s) Features.ESPDistance = s SaveConfig() end)
Toggle(VisualPage, "Players", Features.ESPPlayers, function(s) Features.ESPPlayers = s SaveConfig() end)
Toggle(VisualPage, "NPCs", Features.ESPNPCs, function(s) Features.ESPNPCs = s SaveConfig() end)

Section(ConfigPage, "CONFIG")
Button(ConfigPage, "Save Config", function() SaveConfig() SaveMacroConfig() end)
Button(ConfigPage, "Load Config", function() LoadConfig() LoadMacroConfig() end)
Button(ConfigPage, "Reset Config", function()
    ResetConfig()
    for i = 1, 10 do
        MacroSlots[i] = {
            weapon = "Melee",
            skill = (i == 1 and "Z") or (i == 2 and "X") or "OFF",
            delay = 0.30,
        }
        if slotUI[i] then
            slotUI[i].weaponBtn.Text = MacroSlots[i].weapon
            slotUI[i].skillBtn.Text = MacroSlots[i].skill
            slotUI[i].delayLbl.Text = string.format("%.2fs", MacroSlots[i].delay)
        end
    end
    SaveMacroConfig()
end)
Button(ConfigPage, "Unload UI", function() SaveConfig() SaveMacroConfig() StopMacro() Gui:Destroy() end)

Section(SocialsPage, "⭐ JOIN US ⭐")
local socialTitle = Text(SocialsPage, "Ivory & Rayo's Discord", 12, true)
socialTitle.Size = UDim2.new(1, 0, 0, 20)
socialTitle.Position = UDim2.new(0, 0, 0, 26)
socialTitle.TextXAlignment = Enum.TextXAlignment.Center
socialTitle.TextColor3 = COLORS.ACCENT

local function socialCard(name, discord, y)
    local crd = Instance.new("Frame")
    crd.Size = UDim2.new(1, -10, 0, 60)
    crd.Position = UDim2.new(0, 5, 0, y)
    crd.BackgroundColor3 = COLORS.CARD
    crd.BorderSizePixel = 0
    crd.Parent = SocialsPage
    Corner(crd, 10)
    Stroke(crd, COLORS.ACCENT, 1)
    local n = Text(crd, name, 13, true)
    n.Position = UDim2.new(0, 12, 0, 8)
    n.Size = UDim2.new(1, -20, 0, 18)
    n.TextColor3 = COLORS.WHITE
    local d = Text(crd, "Discord: " .. discord, 10, false)
    d.Position = UDim2.new(0, 12, 0, 30)
    d.Size = UDim2.new(1, -20, 0, 16)
    d.TextColor3 = COLORS.GRAY
end

socialCard("IVORY", "Ivory999", 55)
socialCard("RAYO", "Rayo06996", 125)

Section(AboutPage, "📖 ABOUT IVORY HUB")
local aboutLines = {
    "Ivory Hub v10.9 - Mobile PVP",
    "",
    "• Silent Aim (Players / NPCs / Both)",
    "• Soru Aimbot (auto-teleport on dash)",
    "• Fast Attack (M1 spam, 25 studs)",
    "• Gravity F Aimbot (targets nearest)",
    "• ESP (Box, Name, HP%, Distance)",
    "• Macro (10 customizable slots)",
    "",
    "GRAVITY F: Toggle in FAST tab. When",
    "ON, pressing F (Gravity fruit move)",
    "aims at the nearest enemy.",
    "",
    "Thanks for using Ivory Hub 🦷"
}
for i, line in ipairs(aboutLines) do
    local lbl = Text(AboutPage, line, 9, false)
    lbl.Size = UDim2.new(1, -10, 0, 14)
    lbl.Position = UDim2.new(0, 5, 0, 26 + (i-1)*15)
    lbl.TextColor3 = COLORS.WHITE
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local Tabs = {
    {name="MAIN", icon="🏠", page=MainPage},
    {name="COMBAT", icon="⚔️", page=CombatPage},
    {name="FAST", icon="⚡", page=FastPage},
    {name="MACRO", icon="🎮", page=MacroPage},
    {name="VISUAL", icon="👁️", page=VisualPage},
    {name="CONFIG", icon="⚙️", page=ConfigPage},
    {name="SOCIALS", icon="💬", page=SocialsPage},
    {name="ABOUT", icon="📖", page=AboutPage},
}
local Current
