-- ============================================================
--  TIMEBOMB DUELS - PRO v28
-- ============================================================
print(">>> Loading v28 Pro...")

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local LP           = Players.LocalPlayer
local PG           = LP:WaitForChild("PlayerGui")
print(">>> Services OK")

for _, v in pairs(PG:GetChildren()) do
    if v.Name:match("^Timebomb") then v:Destroy() end
end

local circleGui, autoCircle, autoStroke

-- ============================================================
--  INTRO SCREEN
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

local logo = Instance.new("TextLabel", ibg)
logo.Size = UDim2.new(1,0,0,80)
logo.Position = UDim2.new(0,0,0.33,0)
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

-- ✅ English subtitle (was Arabic)
local subText = Instance.new("TextLabel", ibg)
subText.Size = UDim2.new(1,0,0,50)
subText.Position = UDim2.new(0,0,0.42,0)
subText.BackgroundTransparency = 1
subText.Text = "PRO EDITION"
subText.Font = Enum.Font.GothamBold
subText.TextSize = 24
subText.TextColor3 = Color3.fromRGB(255,255,255)
subText.TextTransparency = 1
subText.ZIndex = 10

local agrad = Instance.new("UIGradient", subText)
agrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
}
agrad.Rotation = 30

task.spawn(function()
    while ibg.Parent do
        lgrad.Rotation = (lgrad.Rotation + 2) % 360
        agrad.Rotation = 30 + ((agrad.Rotation - 30 + 2) % 360)
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

-- ============================================================
--  MAIN UI
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
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18) -- dark black
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(60, 60, 70)
mStroke.Thickness = 2
mStroke.Transparency = 0.2
mStroke.ZIndex = 10

local bgG = Instance.new("UIGradient", main)
bgG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 28)),
}
bgG.Rotation = 125

task.spawn(function()
    TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    task.wait(0.15)
    TweenService:Create(subText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
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
    TweenService:Create(subText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
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
--  VARIABLES
-- ============================================================
local autoFollowOn = false
local autoDistance = 1
local ritchScale = 2
local comboOn = false
local deathEffectOn = false
local currentEffect = "balls"
local jumpPowerValue = 50
local speedMultiplier = 1
local speedEnabled = true
local smartEscapeOn = false
local chaseModeOn = false
local lastKillsCount = 0
local recentDeaths = {}
local chaseReturnPos = nil

local function playSound(position, id) end

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
--  ✅ ADVANCED DEATH EFFECTS (TikTok Style)
-- ============================================================
local function createShockwave(position, color)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.4, 2, 2)
    ring.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanQuery = false
    ring.Material = Enum.Material.Neon
    ring.Color = color or Color3.fromRGB(255, 255, 255)
    ring.Transparency = 0.1
    ring.Parent = workspace

    local light = Instance.new("PointLight", ring)
    light.Color = ring.Color
    light.Range = 20
    light.Brightness = 8

    local tween = TweenService:Create(ring, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.4, 45, 45),
        Transparency = 1,
    })
    tween:Play()
    TweenService:Create(light, TweenInfo.new(0.7), {Brightness = 0, Range = 40}):Play()
    task.delay(0.8, function() if ring then ring:Destroy() end end)
end

local function createLightBeam(position, color)
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(3, 80, 3)
    beam.Position = position + Vector3.new(0, 40, 0)
    beam.Anchored = true
    beam.CanCollide = false
    beam.CanQuery = false
    beam.Material = Enum.Material.Neon
    beam.Color = color or Color3.fromRGB(255, 255, 200)
    beam.Transparency = 0.2
    beam.Parent = workspace

    local light = Instance.new("PointLight", beam)
    light.Color = beam.Color
    light.Range = 35
    light.Brightness = 10

    TweenService:Create(beam, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.1, 80, 0.1),
        Transparency = 1,
    }):Play()
    TweenService:Create(light, TweenInfo.new(0.9), {Brightness = 0}):Play()
    task.delay(1.0, function() if beam then beam:Destroy() end end)
end

local function screenFlash(color, duration)
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.Position = UDim2.new(0, 0, 0, 0)
    flash.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 0.2
    flash.BorderSizePixel = 0
    flash.ZIndex = 99999
    flash.Parent = PG

    TweenService:Create(flash, TweenInfo.new(duration or 0.35), {BackgroundTransparency = 1}):Play()
    task.delay((duration or 0.35) + 0.05, function() if flash then flash:Destroy() end end)
end

local function screenShake(intensity, duration)
    task.spawn(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local startTick = tick()
        local origCFrame = cam.CFrame
        while tick() - startTick < duration do
            local ox = (math.random() - 0.5) * intensity
            local oy = (math.random() - 0.5) * intensity
            local oz = (math.random() - 0.5) * intensity
            cam.CFrame = origCFrame + Vector3.new(ox, oy, oz)
            RunService.RenderStepped:Wait()
        end
        cam.CFrame = origCFrame
    end)
end

local function spawnDeathEffect(position)
    if not deathEffectOn then return end
    print(">>> 🎨 Spawning advanced effect at: " .. tostring(position))
    pcall(function()
        local folder = workspace:FindFirstChild("_TimebombFX")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_TimebombFX"
            folder.Parent = workspace
        end

        -- ✅ Presets with theme colors
        local presets = {
            balls   = {count=45, mat=Enum.Material.Neon, color=function() return Color3.fromHSV(math.random(), 0.75, 1) end, shape=Enum.PartType.Ball, min=0.6, max=1.3, light=true, spdMin=40, spdMax=90, life=1.8, theme=Color3.fromRGB(200, 100, 255)},
            sparks  = {count=60, mat=Enum.Material.Neon, color=function() return Color3.fromHSV(math.random(0,15)/360, 0.9, 1) end, shape=Enum.PartType.Ball, min=0.2, max=0.5, light=true, spdMin=70, spdMax=140, life=1.2, theme=Color3.fromRGB(255, 180, 50)},
            stars   = {count=40, mat=Enum.Material.Neon, color=function() return Color3.fromRGB(math.random(170,230), math.random(90,150), math.random(210,255)) end, shape=Enum.PartType.Block, min=0.4, max=0.9, light=true, spdMin=35, spdMax=75, life=2.0, theme=Color3.fromRGB(180, 130, 255)},
            smoke   = {count=45, mat=Enum.Material.SmoothPlastic, color=function() return Color3.fromHSV(math.random(), 0.3, 0.95) end, shape=Enum.PartType.Ball, min=1.2, max=2.2, light=false, spdMin=20, spdMax=45, life=2.5, theme=Color3.fromRGB(140, 140, 150)},
            fire    = {count=55, mat=Enum.Material.Neon, color=function() return Color3.fromRGB(255, math.random(100,200), 30) end, shape=Enum.PartType.Ball, min=0.5, max=1.4, light=true, spdMin=50, spdMax=100, life=1.5, theme=Color3.fromRGB(255, 100, 30)},
            ice     = {count=65, mat=Enum.Material.Ice, color=function() return Color3.fromRGB(math.random(180,220), 230, 255) end, shape=Enum.PartType.Block, min=0.5, max=1.3, light=true, spdMin=25, spdMax=65, life=2.6, theme=Color3.fromRGB(150, 220, 255)},
            rainbow = {count=70, mat=Enum.Material.Neon, color=function() return Color3.fromHSV(math.random(), 0.85, 1) end, shape=Enum.PartType.Ball, min=0.4, max=1.2, light=true, spdMin=50, spdMax=110, life=2.2, theme=Color3.fromRGB(255, 100, 255)},
            hearts  = {count=40, mat=Enum.Material.Neon, color=function() return Color3.fromRGB(255, math.random(80,140), math.random(170,220)) end, shape=Enum.PartType.Ball, min=0.6, max=1.4, light=true, spdMin=25, spdMax=60, life=2.2, theme=Color3.fromRGB(255, 100, 160)},
        }

        local preset = presets[currentEffect] or presets.balls

        -- ✅ 1. SHOCKWAVE
        createShockwave(position, preset.theme)

        -- ✅ 2. LIGHT BEAM
        createLightBeam(position, preset.theme)

        -- ✅ 3. SCREEN FLASH
        screenFlash(preset.theme, 0.3)

        -- ✅ 4. SCREEN SHAKE
        screenShake(0.6, 0.35)

        -- ✅ 5. PARTICLE EXPLOSION
        for i = 1, preset.count do
            local ball = Instance.new("Part")
            ball.Shape = preset.shape
            local sz = preset.min + math.random() * (preset.max - preset.min)
            ball.Size = Vector3.new(sz, sz, sz)
            ball.Position = position
            ball.Anchored = false
            ball.CanCollide = false
            ball.CanQuery = false
            ball.Material = preset.mat
            ball.Color = preset.color()
            ball.Transparency = 0
            ball.Parent = folder

            -- ✅ Trail for each particle
            if i <= 15 then
                local a0 = Instance.new("Attachment", ball)
                local a1 = Instance.new("Attachment", ball)
                a1.Position = Vector3.new(0, -0.5, 0)
                local trail = Instance.new("Trail", ball)
                trail.Attachment0 = a0
                trail.Attachment1 = a1
                trail.Lifetime = 0.4
                trail.Color = ColorSequence.new(ball.Color)
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(1, 1),
                })
            end

            if preset.light then
                local pl = Instance.new("PointLight", ball)
                pl.Color = ball.Color
                pl.Range = 10
                pl.Brightness = 3
            end

            local dir = Vector3.new(math.random(-100,100)/100, math.random(40,120)/100, math.random(-100,100)/100).Unit
            ball.AssemblyLinearVelocity = dir * (preset.spdMin + math.random() * (preset.spdMax - preset.spdMin))

            local life = preset.life
            local startSize = ball.Size
            task.spawn(function()
                local start = tick()
                while tick() - start < life and ball.Parent do
                    local t = (tick() - start) / life
                    ball.Transparency = t
                    ball.Size = startSize * (1 - t * 0.5)
                    task.wait(0.03)
                end
                if ball.Parent then ball:Destroy() end
            end)
        end

        -- ✅ 6. EXTRA SPARK BURST (small fast particles)
        for i = 1, 20 do
            local spark = Instance.new("Part")
            spark.Shape = Enum.PartType.Ball
            spark.Size = Vector3.new(0.15, 0.15, 0.15)
            spark.Position = position
            spark.Anchored = false
            spark.CanCollide = false
            spark.Material = Enum.Material.Neon
            spark.Color = Color3.fromRGB(255, 255, 255)
            spark.Parent = folder
            local dir = Vector3.new(math.random(-100,100)/100, math.random(-30,120)/100, math.random(-100,100)/100).Unit
            spark.AssemblyLinearVelocity = dir * (100 + math.random() * 80)
            task.delay(0.5, function() if spark then spark:Destroy() end end)
        end
    end)
end

-- ============================================================
--  KILLS TRACKER
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
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        spawnDeathEffect(LP.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                    end
                end
            end
        end
    end
end)

-- ============================================================
--  RITCH / HITBOX
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
--  TOP BAR (Title + Buttons)
-- ============================================================
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,42)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 100

local tLabel = Instance.new("TextLabel", topBar)
tLabel.BackgroundTransparency = 1
tLabel.Size = UDim2.new(0, 260, 1, 0)
tLabel.Position = UDim2.new(0, 20, 0, 0)
tLabel.Text = "⚡ TIMEBOMB DUELS PRO"
tLabel.Font = Enum.Font.GothamBold
tLabel.TextSize = 15
tLabel.TextColor3 = Color3.fromRGB(245,245,255)
tLabel.TextXAlignment = Enum.TextXAlignment.Left
tLabel.ZIndex = 101

-- ✅ Dark black close button
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 15
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 130)
closeBtn.ZIndex = 101
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Color = Color3.fromRGB(60, 20, 30)
closeStroke.Thickness = 1
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ✅ Dark black min button
local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -78, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 15
minBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
minBtn.ZIndex = 101
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = Color3.fromRGB(40, 40, 45)
minStroke.Thickness = 1

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
        newX = math.clamp(newX, -w + 100, vp.X - 100)
        newY = math.clamp(newY, 0, vp.Y - 40)
        main.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)

-- ============================================================
--  SIDEBAR
-- ============================================================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 160, 1, -86)
sidebar.Position = UDim2.new(0, 14, 0, 52)
sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- dark black
sidebar.BackgroundTransparency = 0
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 20
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local sbStroke = Instance.new("UIStroke", sidebar)
sbStroke.Color = Color3.fromRGB(40, 40, 45)
sbStroke.Thickness = 1

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
profileCard.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
profileCard.BorderSizePixel = 0
profileCard.ZIndex = 21
Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
local pcStroke = Instance.new("UIStroke", profileCard)
pcStroke.Color = Color3.fromRGB(50, 50, 55)
pcStroke.Thickness = 1

local avatar = Instance.new("ImageLabel", profileCard)
avatar.Size = UDim2.new(0, 42, 0, 42)
avatar.Position = UDim2.new(0, 5, 0.5, -21)
avatar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
avatar.BorderSizePixel = 0
avatar.ZIndex = 22
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

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
pName.TextColor3 = Color3.fromRGB(255,255,255)
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
pUser.TextColor3 = Color3.fromRGB(180, 170, 210)
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
--  HELPERS
-- ============================================================
local function makeSideItem(text, order, iconType)
    local wrap = Instance.new("TextButton", itemsList)
    wrap.Size = UDim2.new(1,-14,0,34)
    wrap.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    wrap.Text = ""
    wrap.LayoutOrder = order
    wrap.AutoButtonColor = false
    wrap.ZIndex = 22
    wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
    local wrapStroke = Instance.new("UIStroke", wrap)
    wrapStroke.Color = Color3.fromRGB(45, 45, 50)
    wrapStroke.Thickness = 1

    if iconType == "i" then
        local circle = Instance.new("Frame", wrap)
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = UDim2.new(0, 10, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        circle.BorderSizePixel = 0
        circle.ZIndex = 23
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        local cStroke = Instance.new("UIStroke", circle)
        cStroke.Color = Color3.fromRGB(150, 245, 230)
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
        iL.TextColor3 = Color3.fromRGB(255, 255, 255)
        iL.ZIndex = 24

    elseif iconType == "player" then
        local head = Instance.new("Frame", wrap)
        head.Size = UDim2.new(0, 7, 0, 7)
        head.Position = UDim2.new(0, 15, 0.5, -7)
        head.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        head.BorderSizePixel = 0
        head.ZIndex = 23
        Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(0, 13, 0, 8)
        body.Position = UDim2.new(0, 12, 0.5, 1)
        body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        body.BorderSizePixel = 0
        body.ZIndex = 23
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 3)

    elseif iconType == "eye" then
        local eyeShape = Instance.new("Frame", wrap)
        eyeShape.Size = UDim2.new(0, 20, 0, 12)
        eyeShape.Position = UDim2.new(0, 9, 0.5, -6)
        eyeShape.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
        eyeShape.BorderSizePixel = 0
        eyeShape.ZIndex = 23
        Instance.new("UICorner", eyeShape).CornerRadius = UDim.new(0.7, 0)
        local eStroke = Instance.new("UIStroke", eyeShape)
        eStroke.Color = Color3.fromRGB(230, 230, 240)
        eStroke.Thickness = 1.5
        local pupil = Instance.new("Frame", eyeShape)
        pupil.AnchorPoint = Vector2.new(0.5, 0.5)
        pupil.Position = UDim2.new(0.5, 0, 0.5, 0)
        pupil.Size = UDim2.new(0, 4, 0, 4)
        pupil.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
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
    lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.ZIndex = 23

    return wrap, lbl
end

local function makeRow(parent, order, icon, label, value)
    local row = Instance.new("Frame", parent)
    row.Name = "InfoRow"
    row.Size = UDim2.new(1, -8, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rStroke = Instance.new("UIStroke", row)
    rStroke.Color = Color3.fromRGB(40, 40, 45)
    rStroke.Thickness = 1
    local lbl = Instance.new("TextLabel", row)
    lbl.AnchorPoint = Vector2.new(1, 0.5)
    lbl.Position = UDim2.new(1, -12, 0.5, 0)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. " " .. label .. ": " .. tostring(value)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = Color3.fromRGB(235,230,250)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.ZIndex = 22
end

local function makeSwitch(parent, order, title, description, callback, default)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1, -8, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(40, 40, 45)
    bStroke.Thickness = 1

    local switchBg = Instance.new("Frame", box)
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.Position = UDim2.new(1, -10, 0.5, 0)
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 22
    switchBg.ClipsDescendants = true
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switchBg)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
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
    titleLbl.TextColor3 = Color3.fromRGB(245, 240, 255)
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
    descLbl.TextColor3 = Color3.fromRGB(185, 175, 210)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 22

    local clickBtn = Instance.new("TextButton", box)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 24

    local state = default and true or false
    if state then
        switchBg.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
        knob.Position = UDim2.new(0, 18, 0.5, 0)
    end

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 18, 0.5, 0)}):Play()
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
        end
        if callback then callback(state) end
    end)
end

local function makeSlider(parent, order, title, description, minVal, maxVal, defaultVal, callback)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(1, -8, 0, 54)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local sStroke = Instance.new("UIStroke", box)
    sStroke.Color = Color3.fromRGB(40, 40, 45)
    sStroke.Thickness = 1

    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.AnchorPoint = Vector2.new(1, 0)
    titleLbl.Position = UDim2.new(1, -12, 0, 5)
    titleLbl.Size = UDim2.new(1, -80, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 9
    titleLbl.TextColor3 = Color3.fromRGB(245, 240, 255)
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
    descLbl.TextColor3 = Color3.fromRGB(185, 175, 210)
    descLbl.TextXAlignment = Enum.TextXAlignment.Right
    descLbl.ZIndex = 22

    local valLbl = Instance.new("TextLabel", box)
    valLbl.AnchorPoint = Vector2.new(0, 0)
    valLbl.Position = UDim2.new(0, 12, 0, 6)
    valLbl.Size = UDim2.new(0, 55, 0, 15)
    valLbl.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- ✅ dark black
    valLbl.BorderSizePixel = 0
    valLbl.Text = tostring(defaultVal)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 9
    valLbl.TextColor3 = Color3.fromRGB(150, 245, 230)
    valLbl.ZIndex = 23
    Instance.new("UICorner", valLbl).CornerRadius = UDim.new(0, 6)

    local track = Instance.new("Frame", box)
    track.AnchorPoint = Vector2.new(0.5, 0.5)
    track.Position = UDim2.new(0.5, 0, 0, 42)
    track.Size = UDim2.new(1, -24, 0, 5)
    track.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    track.BorderSizePixel = 0
    track.ZIndex = 22
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 160, 240)
    fill.BorderSizePixel = 0
    fill.ZIndex = 23
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    box.BorderSizePixel = 0
    box.LayoutOrder = order
    box.ZIndex = 21
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local tStroke = Instance.new("UIStroke", box)
    tStroke.Color = Color3.fromRGB(40, 40, 45)
    tStroke.Thickness = 1

    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.AnchorPoint = Vector2.new(1, 0)
    titleLbl.Position = UDim2.new(1, -12, 0, 5)
    titleLbl.Size = UDim2.new(1, -100, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 9
    titleLbl.TextColor3 = Color3.fromRGB(245, 240, 255)
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
    descLbl.TextColor3 = Color3.fromRGB(185, 175, 210)
    descLbl.TextXAlignment = Enum.TextXAlignment.Right
    descLbl.ZIndex = 22

    local inputBox = Instance.new("TextBox", box)
    inputBox.AnchorPoint = Vector2.new(0, 0.5)
    inputBox.Position = UDim2.new(0, 12, 0.5, 0)
    inputBox.Size = UDim2.new(0, 65, 0, 26)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- ✅ dark black
    inputBox.BorderSizePixel = 0
    inputBox.Text = tostring(defaultVal)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 11
    inputBox.TextColor3 = Color3.fromRGB(150, 245, 230)
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
    p.ScrollBarImageColor3 = Color3.fromRGB(180, 160, 240)
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
--  TABS (English)
-- ============================================================
local itemInfo, lblInfo = makeSideItem("INFO", 1, "i")
local itemPlayer, lblPlayer = makeSideItem("PLAYER", 2, "player")
local itemView, lblView = makeSideItem("VIEW", 3, "eye")

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
            -- ✅ Selected: dark black with accent border
            tab.btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            tab.lbl.TextColor3 = Color3.fromRGB(120, 220, 255)
            tab.page.Visible = true
        else
            tab.btn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
            tab.lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
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
--  SPEED
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
--  KILL CIRCLE (dark black)
-- ============================================================
local killCircleGui = Instance.new("ScreenGui")
killCircleGui.Name = "TimebombKillCircle"
killCircleGui.IgnoreGuiInset = true
killCircleGui.ResetOnSpawn = false
killCircleGui.DisplayOrder = 1001
killCircleGui.Parent = PG
killCircleGui.Enabled = false

local killCircle = Instance.new("TextButton", killCircleGui)
killCircle.Size = UDim2.new(0, 52, 0, 52)
killCircle.Position = UDim2.new(0, 20, 0.3, -26)
killCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
killCircle.Text = "☠"
killCircle.Font = Enum.Font.GothamBold
killCircle.TextSize = 22
killCircle.TextColor3 = Color3.fromRGB(255, 100, 130)
killCircle.BorderSizePixel = 0
killCircle.AutoButtonColor = false
Instance.new("UICorner", killCircle).CornerRadius = UDim.new(1, 0)

local kcStroke = Instance.new("UIStroke", killCircle)
kcStroke.Color = Color3.fromRGB(200, 60, 90)
kcStroke.Thickness = 2
kcStroke.Transparency = 0.2

local kcMoved = false
local kcDragging = false
local kcStart, kcPos

killCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        kcDragging = true; kcStart = input.Position; kcPos = killCircle.Position; kcMoved = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if kcDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - kcStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then kcMoved = true end
        local vp = workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(kcPos.X.Offset + d.X, 0, vp.X - 52)
        local ny = math.clamp(kcPos.Y.Offset + d.Y, 0, vp.Y - 52)
        killCircle.Position = UDim2.new(kcPos.X.Scale, nx, kcPos.Y.Scale, ny)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        kcDragging = false
    end
end)
killCircle.MouseButton1Click:Connect(function()
    if kcMoved then return end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then hum.Health = 0 end
    end
end)

-- ============================================================
--  ESCAPE CIRCLE
-- ============================================================
local escapeCircleGui = Instance.new("ScreenGui")
escapeCircleGui.Name = "TimebombEscapeCircle"
escapeCircleGui.IgnoreGuiInset = true
escapeCircleGui.ResetOnSpawn = false
escapeCircleGui.DisplayOrder = 1001
escapeCircleGui.Parent = PG
escapeCircleGui.Enabled = false

local escapeCircle = Instance.new("TextButton", escapeCircleGui)
escapeCircle.Size = UDim2.new(0, 52, 0, 52)
escapeCircle.Position = UDim2.new(0, 20, 0.5, -26)
escapeCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
escapeCircle.Text = "🏃"
escapeCircle.Font = Enum.Font.GothamBold
escapeCircle.TextSize = 22
escapeCircle.TextColor3 = Color3.fromRGB(150, 200, 255)
escapeCircle.BorderSizePixel = 0
escapeCircle.AutoButtonColor = false
Instance.new("UICorner", escapeCircle).CornerRadius = UDim.new(1, 0)

local ecStroke = Instance.new("UIStroke", escapeCircle)
ecStroke.Color = Color3.fromRGB(100, 160, 220)
ecStroke.Thickness = 2
ecStroke.Transparency = 0.2

local ecMoved = false
local ecDragging = false
local ecStart, ecPos

escapeCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ecDragging = true; ecStart = input.Position; ecPos = escapeCircle.Position; ecMoved = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if ecDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - ecStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then ecMoved = true end
        local vp = workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(ecPos.X.Offset + d.X, 0, vp.X - 52)
        local ny = math.clamp(ecPos.Y.Offset + d.Y, 0, vp.Y - 52)
        escapeCircle.Position = UDim2.new(ecPos.X.Scale, nx, ecPos.Y.Scale, ny)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ecDragging = false
    end
end)

escapeCircle.MouseButton1Click:Connect(function()
    if ecMoved then return end
    smartEscapeOn = not smartEscapeOn
    if smartEscapeOn then
        escapeCircle.TextColor3 = Color3.fromRGB(100, 255, 180)
        ecStroke.Color = Color3.fromRGB(100, 255, 180)
        escapeCircle.Text = "STOP"
    else
        escapeCircle.TextColor3 = Color3.fromRGB(150, 200, 255)
        ecStroke.Color = Color3.fromRGB(100, 160, 220)
        escapeCircle.Text = "🏃"
        if LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                hum:MoveTo(hrp.Position)
                hum.WalkSpeed = 16
            end
        end
    end
end)

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

RunService.Heartbeat:Connect(function()
    if smartEscapeOn and LP.Character then
        pcall(escapeUpdate)
    end
end)

-- ============================================================
--  CHASE CIRCLE
-- ============================================================
local chaseCircleGui = Instance.new("ScreenGui")
chaseCircleGui.Name = "TimebombChaseCircle"
chaseCircleGui.IgnoreGuiInset = true
chaseCircleGui.ResetOnSpawn = false
chaseCircleGui.DisplayOrder = 1001
chaseCircleGui.Parent = PG
chaseCircleGui.Enabled = false

local chaseCircle = Instance.new("TextButton", chaseCircleGui)
chaseCircle.Size = UDim2.new(0, 52, 0, 52)
chaseCircle.Position = UDim2.new(0, 20, 0.7, -26)
chaseCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
chaseCircle.Text = "🎯"
chaseCircle.Font = Enum.Font.GothamBold
chaseCircle.TextSize = 22
chaseCircle.TextColor3 = Color3.fromRGB(255, 150, 220)
chaseCircle.BorderSizePixel = 0
chaseCircle.AutoButtonColor = false
Instance.new("UICorner", chaseCircle).CornerRadius = UDim.new(1, 0)

local ccStroke = Instance.new("UIStroke", chaseCircle)
ccStroke.Color = Color3.fromRGB(200, 100, 170)
ccStroke.Thickness = 2
ccStroke.Transparency = 0.2

local ccMoved = false
local ccDragging = false
local ccStart, ccPos

chaseCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ccDragging = true; ccStart = input.Position; ccPos = chaseCircle.Position; ccMoved = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if ccDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - ccStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then ccMoved = true end
        local vp = workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(ccPos.X.Offset + d.X, 0, vp.X - 52)
        local ny = math.clamp(ccPos.Y.Offset + d.Y, 0, vp.Y - 52)
        chaseCircle.Position = UDim2.new(ccPos.X.Scale, nx, ccPos.Y.Scale, ny)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ccDragging = false
    end
end)

chaseCircle.MouseButton1Click:Connect(function()
    if ccMoved then return end
    chaseModeOn = not chaseModeOn
    if chaseModeOn then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            chaseReturnPos = LP.Character.HumanoidRootPart.CFrame
        end
        chaseCircle.TextColor3 = Color3.fromRGB(100, 255, 180)
        ccStroke.Color = Color3.fromRGB(100, 255, 180)
        chaseCircle.Text = "STOP"
    else
        chaseCircle.TextColor3 = Color3.fromRGB(255, 150, 220)
        ccStroke.Color = Color3.fromRGB(200, 100, 170)
        chaseCircle.Text = "🎯"
        chaseReturnPos = nil
    end
end)

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

RunService.Heartbeat:Connect(function()
    if chaseModeOn and LP.Character then
        pcall(chaseUpdate)
    end
end)

-- ============================================================
--  PLAYER PAGE (English)
-- ============================================================
makeSwitch(pagePlayer, 1, "Auto Follow", "Chases nearest enemy", function(state)
    if state then
        circleGui.Enabled = true
        autoFollowOn = true
        autoCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        autoCircle.Text = "ON"
        autoStroke.Color = Color3.fromRGB(100, 255, 180)
    else
        circleGui.Enabled = false
        autoFollowOn = false
        autoCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        autoCircle.Text = "Auto"
        autoStroke.Color = Color3.fromRGB(80, 80, 90)
    end
end)

makeSwitch(pagePlayer, 2, "Reach + Hitbox", "Big hitbox + wall penetration", function(state)
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

makeSlider(pagePlayer, 3, "Reach Power", "1-12", 1, 12, 2, function(val)
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

makeSwitch(pagePlayer, 4, "Death Effect", "Advanced VFX on kill", function(state)
    deathEffectOn = state
    print(">>> Death effect: " .. tostring(state))
end)

-- ✅ Dark black escape button
local escapeBtn = Instance.new("TextButton", pagePlayer)
escapeBtn.Size = UDim2.new(1, -8, 0, 38)
escapeBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
escapeBtn.Text = "🏃  Show Escape Circle"
escapeBtn.Font = Enum.Font.GothamBold
escapeBtn.TextSize = 10
escapeBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
escapeBtn.LayoutOrder = 5
escapeBtn.AutoButtonColor = false
escapeBtn.ZIndex = 21
Instance.new("UICorner", escapeBtn).CornerRadius = UDim.new(0, 10)
local ebStroke = Instance.new("UIStroke", escapeBtn)
ebStroke.Color = Color3.fromRGB(60, 90, 130)
ebStroke.Thickness = 1

escapeBtn.MouseButton1Click:Connect(function()
    if escapeCircleGui.Enabled then
        escapeCircleGui.Enabled = false
        escapeBtn.Text = "🏃  Show Escape Circle"
        smartEscapeOn = false
        escapeCircle.TextColor3 = Color3.fromRGB(150, 200, 255)
        ecStroke.Color = Color3.fromRGB(100, 160, 220)
        escapeCircle.Text = "🏃"
    else
        escapeCircleGui.Enabled = true
        escapeBtn.Text = "🏃  Hide Escape Circle"
    end
end)

-- ✅ Dark black chase button
local chaseBtn = Instance.new("TextButton", pagePlayer)
chaseBtn.Size = UDim2.new(1, -8, 0, 38)
chaseBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
chaseBtn.Text = "🎯  Show Chase Circle (needs bomb)"
chaseBtn.Font = Enum.Font.GothamBold
chaseBtn.TextSize = 10
chaseBtn.TextColor3 = Color3.fromRGB(255, 150, 220)
chaseBtn.LayoutOrder = 6
chaseBtn.AutoButtonColor = false
chaseBtn.ZIndex = 21
Instance.new("UICorner", chaseBtn).CornerRadius = UDim.new(0, 10)
local cbStroke = Instance.new("UIStroke", chaseBtn)
cbStroke.Color = Color3.fromRGB(80, 40, 70)
cbStroke.Thickness = 1

chaseBtn.MouseButton1Click:Connect(function()
    if chaseCircleGui.Enabled then
        chaseCircleGui.Enabled = false
        chaseBtn.Text = "🎯  Show Chase Circle (needs bomb)"
        chaseModeOn = false
        chaseCircle.TextColor3 = Color3.fromRGB(255, 150, 220)
        ccStroke.Color = Color3.fromRGB(200, 100, 170)
        chaseCircle.Text = "🎯"
    else
        chaseCircleGui.Enabled = true
        chaseBtn.Text = "🎯  Hide Chase Circle"
    end
end)

-- ✅ Dark black kill button
local killBtn = Instance.new("TextButton", pagePlayer)
killBtn.Size = UDim2.new(1, -8, 0, 38)
killBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
killBtn.Text = "☠️  Show Kill Circle"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 10
killBtn.TextColor3 = Color3.fromRGB(255, 100, 130)
killBtn.LayoutOrder = 7
killBtn.AutoButtonColor = false
killBtn.ZIndex = 21
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0, 10)
local kbStroke = Instance.new("UIStroke", killBtn)
kbStroke.Color = Color3.fromRGB(80, 30, 45)
kbStroke.Thickness = 1

local killCircleOn = false
killBtn.MouseButton1Click:Connect(function()
    killCircleOn = not killCircleOn
    if killCircleOn then
        killCircleGui.Enabled = true
        killBtn.Text = "☠️  Hide Kill Circle"
    else
        killCircleGui.Enabled = false
        killBtn.Text = "☠️  Show Kill Circle"
    end
end)

-- ============================================================
--  EFFECT NAMES (English)
-- ============================================================
local effectNames = {
    {id="balls", name="🎈 Balls"},
    {id="sparks", name="✨ Sparks"},
    {id="stars", name="⭐ Stars"},
    {id="smoke", name="💨 Smoke"},
    {id="fire", name="🔥 Fire"},
    {id="ice", name="❄️ Ice"},
    {id="rainbow", name="🌈 Rainbow"},
    {id="hearts", name="💖 Hearts"},
}

local function makeMenuButton(order, title, valueText, icon)
    local btn = Instance.new("TextButton", pagePlayer)
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
    btn.Text = ""
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.ZIndex = 21
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local mbStroke = Instance.new("UIStroke", btn)
    mbStroke.Color = Color3.fromRGB(40, 40, 45)
    mbStroke.Thickness = 1

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
    tl.TextColor3 = Color3.fromRGB(245, 240, 255)
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
    vl.TextColor3 = Color3.fromRGB(150, 245, 230)
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.ZIndex = 22

    return btn, vl
end

local function makeMenuPanel(list, onSelect)
    local panel = Instance.new("Frame", main)
    panel.Size = UDim2.new(1, -200, 1, -86)
    panel.Position = UDim2.new(0, 188, 0, 52)
    panel.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- ✅ dark black
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 200
    panel.Active = true
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
    local pStroke = Instance.new("UIStroke", panel)
    pStroke.Color = Color3.fromRGB(50, 50, 55)
    pStroke.Thickness = 1

    local cls = Instance.new("TextButton", panel)
    cls.Size = UDim2.new(0, 30, 0, 30)
    cls.Position = UDim2.new(0, 10, 0, 5)
    cls.BackgroundColor3 = Color3.fromRGB(15, 15, 18) -- ✅ dark black
    cls.Text = "◀"
    cls.Font = Enum.Font.GothamBold
    cls.TextSize = 13
    cls.TextColor3 = Color3.fromRGB(255, 100, 130)
    cls.AutoButtonColor = false
    cls.ZIndex = 202
    Instance.new("UICorner", cls).CornerRadius = UDim.new(0, 8)
    local clsStroke = Instance.new("UIStroke", cls)
    clsStroke.Color = Color3.fromRGB(60, 30, 40)
    clsStroke.Thickness = 1

    local sc = Instance.new("ScrollingFrame", panel)
    sc.Size = UDim2.new(1, -20, 1, -50)
    sc.Position = UDim2.new(0, 10, 0, 44)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sc.ZIndex = 201
    sc.Active = true

    local lay = Instance.new("UIListLayout", sc)
    lay.Padding = UDim.new(0, 6)
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local buttons = {}
    local function refresh(current)
        for _, b in ipairs(buttons) do b:Destroy() end
        buttons = {}
        for i, e in ipairs(list) do
            local opt = Instance.new("TextButton", sc)
            opt.Size = UDim2.new(1, -4, 0, 36)
            opt.BackgroundColor3 = (e.id == current) and Color3.fromRGB(30, 30, 38) or Color3.fromRGB(10, 10, 12)
            opt.Text = e.name
            opt.Font = Enum.Font.GothamBold
            opt.TextSize = 10
            opt.TextColor3 = (e.id == current) and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(245, 240, 255)
            opt.LayoutOrder = i
            opt.AutoButtonColor = false
            opt.ZIndex = 202
            opt.Active = true
            Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 8)

            opt.MouseButton1Click:Connect(function()
                onSelect(e.id, e.name)
                task.wait(0.1)
                panel.Visible = false
            end)
            table.insert(buttons, opt)
        end
    end

    cls.MouseButton1Click:Connect(function() panel.Visible = false end)
    return panel, refresh
end

local function getName(list, id)
    for _, e in ipairs(list) do if e.id == id then return e.name end end
    return "?"
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

makeSlider(pagePlayer, 9, "Speed", "1=normal, 10=fast", 1, 10, 1, function(val)
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
--  VIEW PAGE (English)
-- ============================================================
makeSwitch(pageView, 1, "Graphics Boost", "Better lighting", function(state)
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

makeSwitch(pageView, 2, "Anti Lag", "Removes hair/accessories", function(state)
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
makeSwitch(pageView, 3, "Wide Screen", "Increases FOV", function(state)
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

-- ============================================================
--  AUTO CIRCLE (dark black)
-- ============================================================
circleGui = Instance.new("ScreenGui")
circleGui.Name = "TimebombAutoCircle"
circleGui.IgnoreGuiInset = true
circleGui.ResetOnSpawn = false
circleGui.DisplayOrder = 1001
circleGui.Parent = PG

autoCircle = Instance.new("TextButton", circleGui)
autoCircle.Size = UDim2.new(0, 52, 0, 52)
autoCircle.Position = UDim2.new(0, 20, 0.5, -26)
autoCircle.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- ✅ dark black
autoCircle.Text = "Auto"
autoCircle.Font = Enum.Font.GothamBold
autoCircle.TextSize = 10
autoCircle.TextColor3 = Color3.fromRGB(200, 200, 210)
autoCircle.BorderSizePixel = 0
autoCircle.AutoButtonColor = false
Instance.new("UICorner", autoCircle).CornerRadius = UDim.new(1, 0)

autoStroke = Instance.new("UIStroke", autoCircle)
autoStroke.Color = Color3.fromRGB(80, 80, 90)
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
            autoCircle.Text = "ON"
            autoCircle.TextColor3 = Color3.fromRGB(100, 255, 180)
            autoStroke.Color = Color3.fromRGB(100, 255, 180)
        else
            autoCircle.Text = "Auto"
            autoCircle.TextColor3 = Color3.fromRGB(200, 200, 210)
            autoStroke.Color = Color3.fromRGB(80, 80, 90)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoFollowOn then
            pcall(function()
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
            end)
        end
    end
end)

print(">>> Timebomb v28 PRO loaded!")
