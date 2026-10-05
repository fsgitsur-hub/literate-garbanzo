-- ============================================================
--  TIMEBOMB DUELS - FULL v29 (Enhanced VFX & Dark UI)
-- ============================================================
print(">>> Loading v29...")

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local ContentProvider = game:GetService("ContentProvider")
local LP           = Players.LocalPlayer
local PG           = LP:WaitForChild("PlayerGui")
print(">>> Services OK")

-- تنظيف الواجهات القديمة
for _, v in pairs(PG:GetChildren()) do
    if v.Name:match("^Timebomb") then v:Destroy() end
end

local circleGui, autoCircle, autoStroke

-- ============================================================
--  شاشة الدخول (بدون نص عربي)
-- ============================================================
local intro = Instance.new("ScreenGui")
intro.Name = "TimebombIntro"
intro.IgnoreGuiInset = true
intro.DisplayOrder = 99999
intro.Parent = PG

local ibg = Instance.new("Frame", intro)
ibg.Size = UDim2.new(1,0,1,0)
ibg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ibg.BorderSizePixel = 0

-- جسيمات الخلفية
task.spawn(function()
    while ibg.Parent do
        local size = math.random(20, 45)
        local p = Instance.new("Frame", ibg)
        p.Size = UDim2.new(0, size, 0, size)
        p.Position = UDim2.new(math.random(), 0, 1.1, 0)
        p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.75, 1)
        p.BorderSizePixel = 0
        p.ZIndex = 2
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        local glow = Instance.new("UIStroke", p)
        glow.Color = p.BackgroundColor3
        glow.Thickness = 2
        glow.Transparency = 0.4
        local dur = math.random(5, 9)
        TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
            Position = UDim2.new(p.Position.X.Scale, 0, -0.3, 0),
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(glow, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Transparency = 1}):Play()
        task.delay(dur, function() if p then p:Destroy() end end)
        task.wait(0.08)
    end
end)

-- الشعار (إنجليزي فقط)
local logo = Instance.new("TextLabel", ibg)
logo.Size = UDim2.new(1,0,0,80)
logo.Position = UDim2.new(0,0,0.40,0)
logo.BackgroundTransparency = 1
logo.Text = "TIMEBOMB DUELS"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 44
logo.TextColor3 = Color3.fromRGB(255,255,255)
logo.TextTransparency = 1
logo.ZIndex = 10

local lgrad = Instance.new("UIGradient", logo)
lgrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 240, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 170, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(250, 230, 130)),
}

task.spawn(function()
    while ibg.Parent do
        lgrad.Rotation = (lgrad.Rotation + 2) % 360
        task.wait(0.03)
    end
end)

local barBG = Instance.new("Frame", ibg)
barBG.Size = UDim2.new(0,360,0,10)
barBG.Position = UDim2.new(0.5,-180,0.58,10)
barBG.BackgroundColor3 = Color3.fromRGB(25,25,40)
barBG.BorderSizePixel = 0
barBG.ZIndex = 10
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local barStroke = Instance.new("UIStroke", barBG)
barStroke.Color = Color3.fromRGB(120, 100, 180)
barStroke.Thickness = 1
barStroke.Transparency = 0.3

local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 11
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

local fillGrad = Instance.new("UIGradient", barFill)
fillGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
}

local pct = Instance.new("TextLabel", ibg)
pct.Size = UDim2.new(1,0,0,26)
pct.Position = UDim2.new(0,0,0.58,30)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.Font = Enum.Font.GothamBold
pct.TextSize = 16
pct.TextColor3 = Color3.fromRGB(240,235,255)
pct.TextTransparency = 1
pct.ZIndex = 10

task.spawn(function()
    TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    task.wait(0.2)
    TweenService:Create(pct, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    for i = 0, 100 do
        if not ibg.Parent then break end
        barFill.Size = UDim2.new(i/100, 0, 1, 0)
        pct.Text = i .. "%"
        task.wait(0.012)
    end
    task.wait(0.4)
    TweenService:Create(ibg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(pct, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(barBG, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    task.wait(0.55)
    if intro and intro.Parent then intro:Destroy() end
    gui.Enabled = true
    print(">>> GUI enabled!")
end)

task.delay(6, function()
    if intro and intro.Parent then intro:Destroy() end
    if gui then gui.Enabled = true end
end)

-- ============================================================
--  الواجهة الرئيسية (أزرار سوداء داكنة)
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TimebombUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Enabled = false
gui.Parent = PG

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 620, 0, 360)
main.Position = UDim2.new(0.5, -310, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- خلفية داكنة جداً
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(60, 60, 70)
mStroke.Thickness = 2
mStroke.Transparency = 0.3
mStroke.ZIndex = 10

local bgG = Instance.new("UIGradient", main)
bgG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30)),
}
bgG.Rotation = 125

-- ============================================================
--  المتغيرات
-- ============================================================
local autoFollowOn = false
local autoDistance = 1
local ritchScale = 2
local comboOn = false
local deathEffectOn = false
local currentEffect = "advanced" -- تم تغيير الافتراضي إلى متقدم
local jumpPowerValue = 50
local speedMultiplier = 1
local speedEnabled = true
local smartEscapeOn = false
local chaseModeOn = false
local lastKillsCount = 0
local recentDeaths = {}
local chaseReturnPos = nil

-- مكتبة الأصوات (فارغة)
local soundLibrary = {}

-- دوال مساعدة
local function hasBomb()
    if not LP.Character then return false end
    for _, tool in ipairs(LP.Character:GetChildren()) do
        if tool:IsA("Tool") then return true end
    end
    return false
end

local function useBomb()
    local char = LP.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            pcall(function() tool:Activate() end)
            return
        end
    end
end

local function isOpponent(plr)
    if plr == LP then return false end
    if not plr.Character then return false end
    local myTeam = LP.Team
    local theirTeam = plr.Team
    if theirTeam and myTeam then
        if theirTeam == myTeam then return false end
        return true
    end
    return true
end

-- ============================================================
--  ✅ تأثيرات VFX متقدمة (Flipbook + Beam + Trail)
-- ============================================================
local vfxFolder = Instance.new("Folder", workspace)
vfxFolder.Name = "_TimebombVFX"

-- تحميل مسبق للتأثيرات
local flipbookTextures = {
    explosion = "rbxassetid://13080240322", -- تأثير انفجار
    ice       = "rbxassetid://13080240322", -- تأثير ثلج
    fire      = "rbxassetid://13080240322", -- تأثير نار
}
for _, id in pairs(flipbookTextures) do
    pcall(function() ContentProvider:PreloadAsync({id}) end)
end

local function spawnDeathEffect(position)
    if not deathEffectOn then return end
    print(">>> 🎨 Spawning ADVANCED effect at: " .. tostring(position))
    
    pcall(function()
        -- تأثير انفجار متقدم (Flipbook OneShot)
        local explosionPart = Instance.new("Part")
        explosionPart.Size = Vector3.new(1, 1, 1)
        explosionPart.Position = position
        explosionPart.Anchored = true
        explosionPart.CanCollide = false
        explosionPart.CanQuery = false
        explosionPart.Transparency = 1
        explosionPart.Parent = vfxFolder

        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "VFX_Explosion"
        emitter.Texture = flipbookTextures.explosion
        emitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        emitter.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
        emitter.FlipbookFramerate = NumberRange.new(30, 30)
        emitter.FlipbookStartRandom = false
        emitter.Lifetime = NumberRange.new(0.8, 1.2)
        emitter.Rate = 0
        emitter.Speed = NumberRange.new(15, 30)
        emitter.SpreadAngle = Vector2.new(180, 180)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(0.5, 6),
            NumberSequenceKeypoint.new(1, 0)
        })
        emitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 200, 100)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 100, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
        })
        emitter.LightEmission = 1
        emitter.LightInfluence = 0
        emitter.Acceleration = Vector3.new(0, -20, 0)
        emitter.Drag = 5
        emitter.Orientation = Enum.ParticleOrientation.VelocityParallel
        emitter.Parent = explosionPart

        -- إطلاق الانفجار
        emitter:Emit(1)

        -- تأثير الشظايا (Neon Parts)
        for i = 1, 20 do
            local shard = Instance.new("Part")
            shard.Shape = Enum.PartType.Block
            shard.Size = Vector3.new(math.random(1, 3)/10, math.random(1, 3)/10, math.random(3, 8)/10)
            shard.Position = position
            shard.Anchored = false
            shard.CanCollide = false
            shard.CanQuery = false
            shard.Material = Enum.Material.Neon
            shard.Color = Color3.fromHSV(math.random(), 0.8, 1)
            shard.Parent = vfxFolder
            local dir = Vector3.new(math.random(-100,100)/100, math.random(40,120)/100, math.random(-100,100)/100).Unit
            shard.AssemblyLinearVelocity = dir * (50 + math.random(0, 50))
            shard.RotVelocity = Vector3.new(math.random(-20,20), math.random(-20,20), math.random(-20,20))
            task.spawn(function()
                local start = tick()
                while tick() - start < 1.5 and shard.Parent do
                    shard.Transparency = (tick() - start) / 1.5
                    task.wait(0.03)
                end
                if shard.Parent then shard:Destroy() end
            end)
        end

        -- تأثير الرنين (Ring)
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.2, 0.2, 0.2)
        ring.Position = position
        ring.Anchored = true
        ring.CanCollide = false
        ring.CanQuery = false
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 200, 100)
        ring.Transparency = 0.5
        ring.Parent = vfxFolder
        TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = Vector3.new(0.2, 20, 20),
            Transparency = 1
        }):Play()
        task.delay(0.5, function() if ring and ring.Parent then ring:Destroy() end end)

        -- تأثير الضوء
        local light = Instance.new("PointLight", explosionPart)
        light.Color = Color3.fromRGB(255, 200, 100)
        light.Range = 30
        light.Brightness = 5
        TweenService:Create(light, TweenInfo.new(0.5), {Brightness = 0, Range = 0}):Play()
        task.delay(0.5, function() if explosionPart and explosionPart.Parent then explosionPart:Destroy() end end)

    end)
end

-- ============================================================
--  مراقبة Kills
-- ============================================================
task.spawn(function()
    local st
    for i = 1, 30 do
        st = LP:FindFirstChild("leaderstats")
        if st and st:FindFirstChild("Kills") then break end
        task.wait(0.5)
    end
    if not st or not st:FindFirstChild("Kills") then
        print(">>> ⚠️ No Kills stat found!")
        return
    end
    lastKillsCount = st.Kills.Value
    print(">>> ✅ Kills tracking: " .. lastKillsCount)
    while task.wait(0.05) do
        if st and st.Parent and st:FindFirstChild("Kills") then
            local k = st.Kills
            if k.Value > lastKillsCount then
                lastKillsCount = k.Value
                print(">>> 💀 Kill! total=" .. k.Value)
                local latest, latestTime = nil, 0
                for _, d in ipairs(recentDeaths) do
                    if d.time > latestTime and tick() - d.time < 8 then
                        latest = d.pos
                        latestTime = d.time
                    end
                end
                if latest then
                    spawnDeathEffect(latest)
                else
                    print(">>> ⚠️ No recent death - using my position")
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        spawnDeathEffect(LP.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                    end
                end
            end
        end
    end
end)

-- ============================================================
--  Ritch
-- ============================================================
local savedData = {}
local healthState = {}

local function cleanupCharacter(character)
    if not character then return end
    local folder = character:FindFirstChild("_RitchDecoy")
    if folder then folder:Destroy() end
    local saved = savedData[character]
    if saved then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and saved[part.Name] then
                local d = saved[part.Name]
                part.Size = d.size
                part.CanCollide = d.collide
                part.Massless = d.massless
                part.LocalTransparencyModifier = 0
            end
        end
        savedData[character] = nil
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("Decal") or part:IsA("Texture") then
            pcall(function() part.Transparency = 0 end)
        end
    end
end

local function applyCombo(character, scale)
    if not character or not character.Parent then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return end
    local oldDecoy = character:FindFirstChild("_RitchDecoy")
    if oldDecoy then oldDecoy:Destroy() end
    if scale <= 1 then cleanupCharacter(character); return end

    if not savedData[character] then
        savedData[character] = {}
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                savedData[character][part.Name] = {
                    size = part.Size,
                    collide = part.CanCollide,
                    massless = part.Massless,
                }
            end
        end
    end

    local folder = Instance.new("Folder")
    folder.Name = "_RitchDecoy"
    folder.Parent = character

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and savedData[character][part.Name] then
            local orig = savedData[character][part.Name]
            part.Size = orig.size * scale
            part.CanCollide = false
            part.Massless = true
            part.LocalTransparencyModifier = 1

            local decoy
            if part:IsA("MeshPart") then
                decoy = Instance.new("MeshPart")
                decoy.MeshId = part.MeshId
                decoy.TextureID = part.TextureID
            else
                decoy = Instance.new("Part")
            end

            decoy.Name = "D_" .. part.Name
            decoy.Size = orig.size
            decoy.CFrame = part.CFrame
            decoy.Anchored = false
            decoy.CanCollide = false
            decoy.CanQuery = false
            decoy.CanTouch = false
            decoy.Massless = true
            decoy.Color = part.Color
            decoy.Material = part.Material
            decoy.Transparency = part.Transparency
            decoy.Parent = folder

            for _, c in ipairs(part:GetChildren()) do
                if c:IsA("Decal") or c:IsA("Texture") then
                    pcall(function() c.Transparency = 1 end)
                end
            end

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = part
            weld.Part1 = decoy
            weld.Parent = decoy
        end
    end
end

local function trackPlayer(plr)
    if plr == LP then return end
    local function onChar(char)
        task.wait(0.5)
        if not char or not char.Parent then return end
        savedData[char] = nil
        healthState[char] = nil
        if comboOn then applyCombo(char, ritchScale) end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                healthState[char] = "dead"
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local pos = hrp and (hrp.Position + Vector3.new(0, 4, 0))
                if pos then
                    table.insert(recentDeaths, {pos = pos, time = tick()})
                    for i = #recentDeaths, 1, -1 do
                        if tick() - recentDeaths[i].time > 10 then
                            table.remove(recentDeaths, i)
                        end
                    end
                    print(">>> 💀 Player died at: " .. tostring(pos))
                end
                cleanupCharacter(char)
            end)
            hum.HealthChanged:Connect(function(hp)
                if hp <= 0 then
                    if healthState[char] ~= "dead" then
                        healthState[char] = "dead"
                        cleanupCharacter(char)
                    end
                elseif hp >= hum.MaxHealth then
                    if healthState[char] ~= "full" then
                        healthState[char] = "full"
                        if comboOn then task.wait(0.1); applyCombo(char, ritchScale) end
                    end
                end
            end)
        end
    end

    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(onChar)
    plr.CharacterRemoving:Connect(function(char)
        healthState[char] = nil
        cleanupCharacter(char)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do trackPlayer(plr) end
Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then cleanupCharacter(plr.Character) end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if comboOn and LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and comboOn then
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- ============================================================
--  شريط العنوان
-- ============================================================
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,42)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 100

local tLabel = Instance.new("TextLabel", topBar)
tLabel.BackgroundTransparency = 1
tLabel.Size = UDim2.new(0, 260, 1, 0)
tLabel.Position = UDim2.new(0, 20, 0, 0)
tLabel.Text = "⚡ Timebomb Duels"
tLabel.Font = Enum.Font.GothamBold
tLabel.TextSize = 15
tLabel.TextColor3 = Color3.fromRGB(245,245,255)
tLabel.TextXAlignment = Enum.TextXAlignment.Left
tLabel.ZIndex = 101

-- زر الإغلاق (أسود داكن)
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 15
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.ZIndex = 101
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
local cStroke = Instance.new("UIStroke", closeBtn)
cStroke.Color = Color3.fromRGB(80, 30, 30)
cStroke.Thickness = 1
cStroke.Transparency = 0.4
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- زر التصغير (أسود داكن)
local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -78, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 15
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.ZIndex = 101
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
local mStroke2 = Instance.new("UIStroke", minBtn)
mStroke2.Color = Color3.fromRGB(60, 60, 70)
mStroke2.Thickness = 1
mStroke2.Transparency = 0.4

local dragArea = Instance.new("TextButton", topBar)
dragArea.Size = UDim2.new(1, -130, 1, 0)
dragArea.BackgroundTransparency = 1
dragArea.Text = ""
dragArea.ZIndex = 5

local dragging, dragStart, startPos
dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        local newX = startPos.X.Offset + d.X
        local newY = startPos.Y.Offset + d.Y
        local vp = workspace.CurrentCamera.ViewportSize
        local w = main.AbsoluteSize.X
        local h = main.AbsoluteSize.Y
        newX = math.clamp(newX, -w + 100, vp.X - 100)
        newY = math.clamp(newY, 0, vp.Y - 40)
        main.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)

-- ============================================================
--  الشريط الجانبي
-- ============================================================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 160, 1, -86)
sidebar.Position = UDim2.new(0, 14, 0, 52)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 20
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

local sbStroke = Instance.new("UIStroke", sidebar)
sbStroke.Color = Color3.fromRGB(40, 40, 50)
sbStroke.Thickness = 1
sbStroke.Transparency = 0.5

local itemsList = Instance.new("Frame", sidebar)
itemsList.Size = UDim2.new(1, 0, 0, 132)
itemsList.Position = UDim2.new(0, 0, 0, 8)
itemsList.BackgroundTransparency = 1
itemsList.ZIndex = 21

local sbList = Instance.new("UIListLayout", itemsList)
sbList.Padding = UDim.new(0, 6)
sbList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sbList.SortOrder = Enum.SortOrder.LayoutOrder

local profileCard = Instance.new("Frame", sidebar)
profileCard.AnchorPoint = Vector2.new(0, 1)
profileCard.Size = UDim2.new(1,-12,0,52)
profileCard.Position = UDim2.new(0, 6, 1, -8)
profileCard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
profileCard.BorderSizePixel = 0
profileCard.ZIndex = 21
Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
local pcStroke = Instance.new("UIStroke", profileCard)
pcStroke.Color = Color3.fromRGB(50, 50, 60)
pcStroke.Thickness = 1
pcStroke.Transparency = 0.4

local avatar = Instance.new("ImageLabel", profileCard)
avatar.Size = UDim2.new(0, 42, 0, 42)
avatar.Position = UDim2.new(0, 5, 0.5, -21)
avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
avatar.BorderSizePixel = 0
avatar.ZIndex = 22
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)
local avStroke = Instance.new("UIStroke", avatar)
avStroke.Color = Color3.fromRGB(100, 100, 120)
avStroke.Thickness = 1.5
avStroke.Transparency = 0.3

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if ok and thumb then avatar.Image = thumb
    else avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150" end
end)

local pName = Instance.new("TextLabel", profileCard)
pName.AnchorPoint = Vector2.new(1, 0)
pName.Position = UDim2.new(1, -8, 0, 10)
pName.Size = UDim2.new(1, -58, 0, 14)
pName.BackgroundTransparency = 1
pName.Text = LP.DisplayName
pName.Font = Enum.Font.GothamBold
pName.TextSize = 10
pName.TextColor3 = Color3.fromRGB(220,220,220)
pName.TextXAlignment = Enum.TextXAlignment.Right
pName.ZIndex = 22

local pUser = Instance.new("TextLabel", profileCard)
pUser.AnchorPoint = Vector2.new(1, 0)
pUser.Position = UDim2.new(1, -8, 0, 28)
pUser.Size = UDim2.new(1, -58, 0, 12)
pUser.BackgroundTransparency = 1
pUser.Text = "@" .. LP.Name
pUser.Font = Enum.Font.Gotham
pUser.TextSize = 9
pUser.TextColor3 = Color3.fromRGB(140, 140, 160)
pUser.TextXAlignment = Enum.TextXAlignment.Right
pUser.ZIndex = 22

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -200, 1, -86)
content.Position = UDim2.new(0, 188, 0, 52)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.ZIndex = 20

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    if not minimized then
        sidebar.Visible = false; content.Visible = false
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 42)}):Play()
        minimized = true
    else
        sidebar.Visible = true; content.Visible = true
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 620, 0, 360)}):Play()
        minimized = false
    end
end)

-- ============================================================
--  دوال الواجهة (الكل أسود داكن)
-- ============================================================
local function makeSideItem(text, order, iconType)
    local wrap = Instance.new("TextButton", itemsList)
    wrap.Size = UDim2.new(1,-14,0,34)
    wrap.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    wrap.Text = ""
    wrap.LayoutOrder = order
    wrap.AutoButtonColor = false
    wrap.ZIndex = 22
    wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
    local wStroke = Instance.new("UIStroke", wrap)
    wStroke.Color = Color3.fromRGB(50, 50, 60)
    wStroke.Thickness = 1
    wStroke.Transparency = 0.5

    if iconType == "i" then
        local circle = Instance.new("Frame", wrap)
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = UDim2.new(0, 10, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        circle.BorderSizePixel = 0
        circle.ZIndex = 23
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        local cStroke = Instance.new("UIStroke", circle)
        cStroke.Color = Color3.fromRGB(150, 150, 170)
        cStroke.Thickness = 1
        cStroke.Transparency = 0.2
        local iL = Instance.new("TextLabel", circle)
        iL.AnchorPoint = Vector2.new(0.5, 0.5)
        iL.Position = UDim2.new(0.5, 0, 0.5, 0)
        iL.Size = UDim2.new(1, 0, 1, 0)
        iL.BackgroundTransparency = 1
        iL.Text = "i"
        iL.Font = Enum.Font.GothamBold
        iL.TextSize = 12
        iL.TextColor3 = Color3.fromRGB(220, 220, 220)
        iL.ZIndex = 24

    elseif iconType == "player" then
        local head = Instance.new("Frame", wrap)
        head.Size = UDim2.new(0, 7, 0, 7)
        head.Position = UDim2.new(0, 15, 0.5, -7)
        head.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        head.BorderSizePixel = 0
        head.ZIndex = 23
        Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(0, 13, 0, 8)
        body.Position = UDim2.new(0, 12, 0.5, 1)
        body.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        body.BorderSizePixel = 0
        body.ZIndex = 23
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 3)

    elseif iconType == "eye" then
        local eyeShape = Instance.new("Frame", wrap)
        eyeShape.Size = UDim2.new(0, 20, 0, 12)
        eyeShape.Position = UDim2.new(0, 9, 0.5, -6)
        eyeShape.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        eyeShape.BorderSizePixel = 0
        eyeShape.ZIndex = 23
        Instance.new("UICorner", eyeShape).CornerRadius = UDim.new(0.7, 0)
        local eStroke = Instance.new("UIStroke", eyeShape)
        eStroke.Color = Color3.fromRGB(220, 220, 220)
        eStroke.Thickness = 1.5
        local pupil = Instance.new("Frame", eyeShape)
        pupil.AnchorPoint = Vector2.new(0.5, 0.5)
        pupil.Position = UDim2.new(0.5, 0, 0.5, 0)
        pupil.Size = UDim2.new(0, 4, 0, 4)
        pupil.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        pupil.BorderSizePixel = 0
        pupil.ZIndex = 24
        Instance.new("UICorner", pupil).CornerRadius = UDim.new(1, 0)
    end

    local lbl = Instance.new("TextLabel", wrap)
    lbl.AnchorPoint = Vector2.new(1, 0.5)
    lbl.Position = UDim2.new(1, -10, 0.5, 0)
    lbl.Size = UDim2.new(1, -44, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.ZIndex = 23

    return wrap, lbl
end

local function makeRow(parent, order, icon, label, value)
    local row = Instance.new("Frame", parent)
    row.Name = "InfoRow"
    row.Size = UDim2.new(1, -8, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rStroke = Instance.new("UIStroke", row)
    rStroke.Color = Color3.fromRGB(50, 50, 60)
    rStroke.Thickness = 1
    rStroke.Transparency = 0.6
    local lbl = Instance.new("TextLabel", row)
    lbl.AnchorPoint = Vector2.new(1, 0.5)
    lbl.Position = UDim2.new(1, -12, 0.5, 0)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. " " .. label .. ": " .. tostring(value)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.ZIndex = 22
end

local function makeSwitch(parent, order, title, description, callback, default)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1, -8, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(50, 50, 60)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.5

    local switchBg = Instance.new("Frame", box)
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.Position = UDim2.new(1, -10, 0.5, 0)
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 22
    switchBg.ClipsDescendants = true
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    knob.BorderSizePixel = 0
    knob.ZIndex = 23
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.AnchorPoint = Vector2.new(0, 0)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.Size = UDim2.new(1, -55, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 9
    titleLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 22

    local descLbl = Instance.new("TextLabel", box)
    descLbl.AnchorPoint = Vector2.new(0, 0)
    descLbl.Position = UDim2.new(0, 10, 0, 20)
    descLbl.Size = UDim2.new(1, -55, 0, 10)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 7
    descLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 22

    local clickBtn = Instance.new("TextButton", box)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 24

    local state = default and true or false
    if state then
        switchBg.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
        knob.Position = UDim2.new(0, 18, 0.5, 0)
    end

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 18, 0.5, 0)}):Play()
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
        end
        if callback then callback(state) end
    end)
end

local function makeSlider(parent, order, title, description, minVal, maxVal, defaultVal, callback)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1, -8, 0, 54)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(50, 50, 60)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.5

    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.AnchorPoint = Vector2.new(1, 0)
    titleLbl.Position = UDim2.new(1, -12, 0, 5)
    titleLbl.Size = UDim2.new(1, -80, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 9
    titleLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Right
    titleLbl.ZIndex = 22

    local descLbl = Instance.new("TextLabel", box)
    descLbl.AnchorPoint = Vector2.new(1, 0)
    descLbl.Position = UDim2.new(1, -12, 0, 19)
    descLbl.Size = UDim2.new(1, -80, 0, 10)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 7
    descLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
    descLbl.TextXAlignment = Enum.TextXAlignment.Right
    descLbl.ZIndex = 22

    local valLbl = Instance.new("TextLabel", box)
    valLbl.AnchorPoint = Vector2.new(0, 0)
    valLbl.Position = UDim2.new(0, 12, 0, 6)
    valLbl.Size = UDim2.new(0, 55, 0, 15)
    valLbl.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    valLbl.BorderSizePixel = 0
    valLbl.Text = tostring(defaultVal)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 9
    valLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    valLbl.ZIndex = 23
    Instance.new("UICorner", valLbl).CornerRadius = UDim.new(0, 6)

    local track = Instance.new("Frame", box)
    track.AnchorPoint = Vector2.new(0.5, 0.5)
    track.Position = UDim2.new(0.5, 0, 0, 42)
    track.Size = UDim2.new(1, -24, 0, 5)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    track.BorderSizePixel = 0
    track.ZIndex = 22
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
    fill.BorderSizePixel = 0
    fill.ZIndex = 23
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    knob.BorderSizePixel = 0
    knob.ZIndex = 24
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton", box)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 25

    local currentVal = defaultVal
    local dragging2 = false

    local function updateVisual(xPos)
        local relX = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        currentVal = math.floor(minVal + relX * (maxVal - minVal) + 0.5)
        currentVal = math.clamp(currentVal, minVal, maxVal)
        fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
        knob.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
        valLbl.Text = tostring(currentVal)
    end

    click.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            updateVisual(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateVisual(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging2 and callback then callback(currentVal) end
            dragging2 = false
        end
    end)
end

local function makeTextInput(parent, order, title, description, defaultVal, minVal, maxVal, callback)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1, -8, 0, 50)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(50, 50, 60)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.5

    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.AnchorPoint = Vector2.new(1, 0)
    titleLbl.Position = UDim2.new(1, -12, 0, 5)
    titleLbl.Size = UDim2.new(1, -100, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 9
    titleLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Right
    titleLbl.ZIndex = 22

    local descLbl = Instance.new("TextLabel", box)
    descLbl.AnchorPoint = Vector2.new(1, 0)
    descLbl.Position = UDim2.new(1, -12, 0, 19)
    descLbl.Size = UDim2.new(1, -100, 0, 10)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 7
    descLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
    descLbl.TextXAlignment = Enum.TextXAlignment.Right
    descLbl.ZIndex = 22

    local inputBox = Instance.new("TextBox", box)
    inputBox.AnchorPoint = Vector2.new(0, 0.5)
    inputBox.Position = UDim2.new(0, 12, 0.5, 0)
    inputBox.Size = UDim2.new(0, 65, 0, 26)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    inputBox.BorderSizePixel = 0
    inputBox.Text = tostring(defaultVal)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 11
    inputBox.TextColor3 = Color3.fromRGB(200, 200, 210)
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 23
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 8)

    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text)
        if num then
            num = math.clamp(math.floor(num), minVal, maxVal)
            inputBox.Text = tostring(num)
            if callback then callback(num) end
        else
            inputBox.Text = tostring(defaultVal)
        end
    end)
end

local function makePage()
    local p = Instance.new("ScrollingFrame", content)
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(100,100,120)
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false
    p.ZIndex = 21
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 5)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return p
end

-- ============================================================
--  التبويبات
-- ============================================================
local itemInfo, lblInfo = makeSideItem("Info", 1, "i")
local itemPlayer, lblPlayer = makeSideItem("Player", 2, "player")
local itemView, lblView = makeSideItem("View", 3, "eye")

local pageInfo = makePage()
local pagePlayer = makePage()
local pageView = makePage()

local tabs = {
    {btn = itemInfo, lbl = lblInfo, page = pageInfo},
    {btn = itemPlayer, lbl = lblPlayer, page = pagePlayer},
    {btn = itemView, lbl = lblView, page = pageView},
}

local function selectTab(i)
    for k, tab in ipairs(tabs) do
        if k == i then
            tab.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            tab.lbl.TextColor3 = Color3.fromRGB(255,255,255)
            tab.page.Visible = true
        else
            tab.btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            tab.lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
            tab.page.Visible = false
        end
    end
end

itemInfo.MouseButton1Click:Connect(function() selectTab(1) end)
itemPlayer.MouseButton1Click:Connect(function() selectTab(2) end)
itemView.MouseButton1Click:Connect(function() selectTab(3) end)
selectTab(1)

local function refreshInfo()
    for _, c in pairs(pageInfo:GetChildren()) do
        if c:IsA("Frame") and c.Name == "InfoRow" then c:Destroy() end
    end
    local st = LP:FindFirstChild("leaderstats")
    local w, k, d = 0, 0, 0
    if st then
        if st:FindFirstChild("Wins") then w = st.Wins.Value end
        if st:FindFirstChild("Kills") then k = st.Kills.Value end
        if st:FindFirstChild("Deaths") then d = st.Deaths.Value end
    end
    makeRow(pageInfo, 1,  "👤", "Name", LP.DisplayName)
    makeRow(pageInfo, 2,  "💎", "User", "@" .. LP.Name)
    makeRow(pageInfo, 3,  "🆔", "ID", LP.UserId)
    makeRow(pageInfo, 4,  "📅", "Age", (LP.AccountAge or 0) .. " days")
    makeRow(pageInfo, 5,  "⚡", "Executor", "Delta")
    makeRow(pageInfo, 6,  "🏆", "Wins", w)
    makeRow(pageInfo, 7,  "⚔️", "Kills", k)
    makeRow(pageInfo, 8,  "👥", "Players", #Players:GetPlayers())
    makeRow(pageInfo, 9,  "💀", "Deaths", d)
end
refreshInfo()
task.spawn(function() while pageInfo.Parent do task.wait(3); refreshInfo() end end)

-- ============================================================
--  السرعة
-- ============================================================
local speedConn = nil

local function setupSpeed(char)
    if speedConn then speedConn:Disconnect() end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hrp or not hum then return end

    speedConn = RunService.Heartbeat:Connect(function(dt)
        if not speedEnabled then return end
        if speedMultiplier <= 1 then return end
        if hum.Health <= 0 then return end
        local dir = hum.MoveDirection
        if dir.Magnitude < 0.1 then return end
        if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        local extraSpeed = (speedMultiplier - 1) * 1.45
        local extra = dir * extraSpeed * dt
        hrp.CFrame = hrp.CFrame + extra
    end)
end

if LP.Character then setupSpeed(LP.Character) end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    setupSpeed(char)
end)

-- ============================================================
--  دوائر (Kill, Escape, Chase, Auto)
-- ============================================================
local function createCircle(name, color, text, homePos)
    local gui = Instance.new("ScreenGui")
    gui.Name = "Timebomb" .. name .. "Circle"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1001
    gui.Parent = PG
    gui.Enabled = false

    local circle = Instance.new("TextButton", gui)
    circle.Size = UDim2.new(0, 52, 0, 52)
    circle.Position = homePos
    circle.BackgroundColor3 = color
    circle.Text = text
    circle.Font = Enum.Font.GothamBold
    circle.TextSize = 22
    circle.TextColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.AutoButtonColor = false
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", circle)
    stroke.Color = color:Lerp(Color3.new(1,1,1), 0.3)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local moved = false
    local dragging = false
    local start, pos

    circle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; start = input.Position; pos = circle.Position; moved = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - start
            if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then moved = true end
            local vp = workspace.CurrentCamera.ViewportSize
            local nx = math.clamp(pos.X.Offset + d.X, 0, vp.X - 52)
            local ny = math.clamp(pos.Y.Offset + d.Y, 0, vp.Y - 52)
            circle.Position = UDim2.new(pos.X.Scale, nx, pos.Y.Scale, ny)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return circle, gui, stroke, function() return moved end, function(v) moved = v end
end

-- Kill Circle
local killCircle, killCircleGui, kcStroke, isKillMoved, setKillMoved = createCircle("Kill", Color3.fromRGB(150, 60, 80), "☠", UDim2.new(0, 20, 0.3, -26))
killCircle.MouseButton1Click:Connect(function()
    if isKillMoved() then return end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then hum.Health = 0 end
    end
end)

-- Escape Circle
local escapeCircle, escapeCircleGui, ecStroke, isEscMoved, setEscMoved = createCircle("Escape", Color3.fromRGB(50, 90, 130), "🏃", UDim2.new(0, 20, 0.5, -26))
escapeCircle.MouseButton1Click:Connect(function()
    if isEscMoved() then return end
    smartEscapeOn = not smartEscapeOn
    if smartEscapeOn then
        escapeCircle.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
        ecStroke.Color = Color3.fromRGB(150, 255, 200)
        escapeCircle.Text = "STOP"
    else
        escapeCircle.BackgroundColor3 = Color3.fromRGB(50, 90, 130)
        ecStroke.Color = Color3.fromRGB(120, 180, 240)
        escapeCircle.Text = "🏃"
        if LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum then hum:MoveTo(hrp.Position) end
        end
    end
end)

-- Chase Circle
local chaseCircle, chaseCircleGui, ccStroke, isChaseMoved, setChaseMoved = createCircle("Chase", Color3.fromRGB(130, 60, 100), "🎯", UDim2.new(0, 20, 0.7, -26))
chaseCircle.MouseButton1Click:Connect(function()
    if isChaseMoved() then return end
    chaseModeOn = not chaseModeOn
    if chaseModeOn then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            chaseReturnPos = LP.Character.HumanoidRootPart.CFrame
        end
        chaseCircle.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
        ccStroke.Color = Color3.fromRGB(150, 255, 200)
        chaseCircle.Text = "STOP"
    else
        chaseCircle.BackgroundColor3 = Color3.fromRGB(130, 60, 100)
        ccStroke.Color = Color3.fromRGB(220, 130, 200)
        chaseCircle.Text = "🎯"
        chaseReturnPos = nil
    end
end)

-- Auto Circle
circleGui = Instance.new("ScreenGui")
circleGui.Name = "TimebombAutoCircle"
circleGui.IgnoreGuiInset = true
circleGui.ResetOnSpawn = false
circleGui.DisplayOrder = 1001
circleGui.Parent = PG
autoCircle = Instance.new("TextButton", circleGui)
autoCircle.Size = UDim2.new(0, 52, 0, 52)
autoCircle.Position = UDim2.new(0, 20, 0.5, -26)
autoCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
autoCircle.Text = "Auto"
autoCircle.Font = Enum.Font.GothamBold
autoCircle.TextSize = 10
autoCircle.TextColor3 = Color3.fromRGB(230, 230, 245)
autoCircle.BorderSizePixel = 0
autoCircle.AutoButtonColor = false
Instance.new("UICorner", autoCircle).CornerRadius = UDim.new(1, 0)
autoStroke = Instance.new("UIStroke", autoCircle)
autoStroke.Color = Color3.fromRGB(120, 120, 160)
autoStroke.Thickness = 2
circleGui.Enabled = false

local autoMoved = false
local autoDragging = false
local autoStart, autoPos
autoCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        autoDragging = true; autoStart = input.Position; autoPos = autoCircle.Position; autoMoved = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if autoDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - autoStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then autoMoved = true end
        local vp = workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(autoPos.X.Offset + d.X, 0, vp.X - 52)
        local ny = math.clamp(autoPos.Y.Offset + d.Y, 0, vp.Y - 52)
        autoCircle.Position = UDim2.new(autoPos.X.Scale, nx, autoPos.Y.Scale, ny)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        autoDragging = false
    end
end)
autoCircle.MouseButton1Click:Connect(function()
    if not autoMoved then
        autoFollowOn = not autoFollowOn
        if autoFollowOn then
            autoCircle.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
            autoCircle.Text = "ON"
        else
            autoCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            autoCircle.Text = "Auto"
        end
    end
end)

-- ============================================================
--  منطق الهروب واللحاق
-- ============================================================
local lastEscapeTime = 0
local ESCAPE_DISTANCE = 25

local function escapeUpdate()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    if hasBomb() then return end

    local nearest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if isOpponent(plr) then
            local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local oHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if oHrp and oHum and oHum.Health > 0 then
                local d = (oHrp.Position - hrp.Position).Magnitude
                if d < minDist then minDist = d; nearest = oHrp end
            end
        end
    end

    if nearest and minDist < ESCAPE_DISTANCE then
        if tick() - lastEscapeTime > 0.03 then
            lastEscapeTime = tick()
            local awayDir = (hrp.Position - nearest.Position)
            if awayDir.Magnitude > 0.1 then
                awayDir = awayDir.Unit
                hrp.CFrame = hrp.CFrame + awayDir * 7.5
            end
        end
    end
end

local lastChaseTime = 0

local function chaseUpdate()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    if not hasBomb() then return end

    local nearest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if isOpponent(plr) then
            local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local oHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if oHrp and oHum and oHum.Health > 0 then
                local d = (oHrp.Position - hrp.Position).Magnitude
                if d < minDist then minDist = d; nearest = oHrp end
            end
        end
    end

    if not nearest then return end

    if minDist < 6 then
        useBomb()
        task.wait(0.4)
        if chaseReturnPos then
            pcall(function() hrp.CFrame = chaseReturnPos end)
            chaseReturnPos = nil
        end
        return
    end

    if tick() - lastChaseTime > 0.03 then
        lastChaseTime = tick()
        local dir = (nearest.Position - hrp.Position)
        if dir.Magnitude > 0.1 then
            dir = dir.Unit
            hrp.CFrame = hrp.CFrame + dir * 7.5
        end
    end
end

local function autoUpdate()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local nearest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if isOpponent(plr) then
            local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local oHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if oHrp and oHum and oHum.Health > 0 then
                local d = (oHrp.Position - hrp.Position).Magnitude
                if d < minDist then minDist = d; nearest = oHrp end
            end
        end
    end
    if nearest and minDist > autoDistance then
        hum:MoveTo(nearest.Position)
    end
end

-- ============================================================
--  الحلقات الرئيسية
-- ============================================================
RunService.Heartbeat:Connect(function()
    if smartEscapeOn and LP.Character then pcall(escapeUpdate) end
    if chaseModeOn and LP.Character then pcall(chaseUpdate) end
    if autoFollowOn and LP.Character then pcall(autoUpdate) end
end)

-- ============================================================
--  صفحة لاعب
-- ============================================================
makeSwitch(pagePlayer, 1, "Auto", "Follow opponent", function(state)
    if state then
        circleGui.Enabled = true
        autoFollowOn = true
        autoCircle.BackgroundColor3 = Color3.fromRGB(80, 210, 150)
        autoCircle.Text = "ON"
    else
        circleGui.Enabled = false
        autoFollowOn = false
        autoCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        autoCircle.Text = "Auto"
    end
end)

makeSwitch(pagePlayer, 2, "Ritch + Noclip", "Bigger hitbox + phase through walls", function(state)
    comboOn = state
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then applyCombo(plr.Character, ritchScale) end
            end
        end
        if LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then cleanupCharacter(plr.Character) end
        end
        if LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

makeSlider(pagePlayer, 3, "Ritch Power", "1-12", 1, 12, 2, function(val)
    ritchScale = val
    if comboOn then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then applyCombo(plr.Character, val) end
            end
        end
    end
end)

makeSwitch(pagePlayer, 4, "Death Effect", "Show effect on kill", function(state)
    deathEffectOn = state
end)

-- أزرار إظهار الدوائر (تستخدم نفس تصميم الأزرار السوداء)
local escapeBtn = Instance.new("TextButton", pagePlayer)
escapeBtn.Size = UDim2.new(1, -8, 0, 38)
escapeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
escapeBtn.Text = "🏃  Show Escape Circle"
escapeBtn.Font = Enum.Font.GothamBold
escapeBtn.TextSize = 10
escapeBtn.TextColor3 = Color3.fromRGB(220, 240, 255)
escapeBtn.LayoutOrder = 5
escapeBtn.AutoButtonColor = false
escapeBtn.ZIndex = 21
Instance.new("UICorner", escapeBtn).CornerRadius = UDim.new(0, 10)
escapeBtn.MouseButton1Click:Connect(function()
    if escapeCircleGui.Enabled then
        escapeCircleGui.Enabled = false
        escapeBtn.Text = "🏃  Show Escape Circle"
        smartEscapeOn = false
        escapeCircle.BackgroundColor3 = Color3.fromRGB(50, 90, 130)
        ecStroke.Color = Color3.fromRGB(120, 180, 240)
        escapeCircle.Text = "🏃"
    else
        escapeCircleGui.Enabled = true
        escapeBtn.Text = "🏃  Hide Escape Circle"
    end
end)

local chaseBtn = Instance.new("TextButton", pagePlayer)
chaseBtn.Size = UDim2.new(1, -8, 0, 38)
chaseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
chaseBtn.Text = "🎯  Show Chase Circle (needs bomb)"
chaseBtn.Font = Enum.Font.GothamBold
chaseBtn.TextSize = 10
chaseBtn.TextColor3 = Color3.fromRGB(255, 220, 240)
chaseBtn.LayoutOrder = 6
chaseBtn.AutoButtonColor = false
chaseBtn.ZIndex = 21
Instance.new("UICorner", chaseBtn).CornerRadius = UDim.new(0, 10)
chaseBtn.MouseButton1Click:Connect(function()
    if chaseCircleGui.Enabled then
        chaseCircleGui.Enabled = false
        chaseBtn.Text = "🎯  Show Chase Circle (needs bomb)"
        chaseModeOn = false
        chaseCircle.BackgroundColor3 = Color3.fromRGB(130, 60, 100)
        ccStroke.Color = Color3.fromRGB(220, 130, 200)
        chaseCircle.Text = "🎯"
    else
        chaseCircleGui.Enabled = true
        chaseBtn.Text = "🎯  Hide Chase Circle"
    end
end)

local killBtn = Instance.new("TextButton", pagePlayer)
killBtn.Size = UDim2.new(1, -8, 0, 38)
killBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
killBtn.Text = "☠️  Show Kill Circle"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 10
killBtn.TextColor3 = Color3.fromRGB(255, 220, 235)
killBtn.LayoutOrder = 7
killBtn.AutoButtonColor = false
killBtn.ZIndex = 21
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0, 10)
killBtn.MouseButton1Click:Connect(function()
    if killCircleGui.Enabled then
        killCircleGui.Enabled = false
        killBtn.Text = "☠️  Show Kill Circle"
        killCircle.BackgroundColor3 = Color3.fromRGB(150, 60, 80)
        kcStroke.Color = Color3.fromRGB(255, 130, 160)
        killCircle.Text = "☠"
    else
        killCircleGui.Enabled = true
        killBtn.Text = "☠️  Hide Kill Circle"
    end
end)

-- قائمة التأثيرات
local effectNames = {
    {id="advanced", name="🌟 Advanced VFX"},
}

local function makeMenuButton(order, title, valueText, icon)
    local btn = Instance.new("TextButton", pagePlayer)
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = ""
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.ZIndex = 21
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(50, 50, 60)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.5

    local ic = Instance.new("TextLabel", btn)
    ic.Size = UDim2.new(0, 26, 1, 0)
    ic.Position = UDim2.new(0, 10, 0, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.Font = Enum.Font.GothamBold
    ic.TextSize = 14
    ic.ZIndex = 22

    local tl = Instance.new("TextLabel", btn)
    tl.AnchorPoint = Vector2.new(1, 0)
    tl.Position = UDim2.new(1, -36, 0, 6)
    tl.Size = UDim2.new(1, -46, 0, 12)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 9
    tl.TextColor3 = Color3.fromRGB(220, 220, 220)
    tl.TextXAlignment = Enum.TextXAlignment.Right
    tl.ZIndex = 22

    local vl = Instance.new("TextLabel", btn)
    vl.AnchorPoint = Vector2.new(1, 0)
    vl.Position = UDim2.new(1, -36, 0, 22)
    vl.Size = UDim2.new(1, -46, 0, 11)
    vl.BackgroundTransparency = 1
    vl.Text = valueText
    vl.Font = Enum.Font.Gotham
    vl.TextSize = 8
    vl.TextColor3 = Color3.fromRGB(150, 150, 170)
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.ZIndex = 22

    return btn, vl
end

local effectBtn, effectVal = makeMenuButton(8, "Effect Type", getName(effectNames, currentEffect), "🎨")
local effectPanel, refreshEffects = makeMenuPanel(effectNames, function(id, name)
    currentEffect = id
    effectVal.Text = name
end)
effectBtn.MouseButton1Click:Connect(function()
    if effectPanel.Visible then effectPanel.Visible = false
    else effectPanel.Visible = true; refreshEffects(currentEffect) end
end)

makeSlider(pagePlayer, 9, "Speed", "1 = normal, 10 = 29", 1, 10, 1, function(val)
    speedMultiplier = val
end)

makeTextInput(pagePlayer, 10, "Jump Power", "50 - 70", 50, 50, 70, function(val)
    jumpPowerValue = val
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true; hum.JumpPower = val end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.JumpPower ~= jumpPowerValue then
                hum.UseJumpPower = true
                hum.JumpPower = jumpPowerValue
            end
        end)
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = jumpPowerValue
    end
end)

-- ============================================================
--  صفحة منظر
-- ============================================================
makeSwitch(pageView, 1, "Quality Boost", "Improve lighting", function(state)
    pcall(function()
        if state then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.Brightness = 3
            Lighting.Ambient = Color3.fromRGB(120, 120, 140)
            Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 150)
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(70, 70, 80)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end)
end)

makeSwitch(pageView, 2, "Anti-Lag", "Remove hair & accessories", function(state)
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

local savedFOV = 70
makeSwitch(pageView, 3, "Extended Screen", "Increase FOV", function(state)
    local cam = workspace.CurrentCamera
    if cam then
        if state then
            savedFOV = cam.FieldOfView
            cam.FieldOfView = 105
        else
            cam.FieldOfView = savedFOV
        end
    end
end)

print(">>> Timebomb v29 loaded (Advanced VFX + Dark UI)!")
