-- Süper Kontrol Paneli v8 (Tüm Uçuk Kaçık ve Görsel Özellikler Eksiksiz)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski menülerin hepsini temizle
for _, guiName in pairs({"TestArayuzGui", "UcusArayuzGui", "SuperKontrolGui"}) do
    if PlayerGui:FindFirstChild(guiName) then
        PlayerGui[guiName]:Destroy()
    end
end

-- Değişkenler
local isAirWalking = false
local turboEnabled = false
local turboMultiplier = 2.5
local customSpeed = 16
local minSpeed = 16
local maxSpeed = 250

local autoNoclip = false
local infJumpEnabled = false
local magnetEnabled = false
local touchTpEnabled = false

local flingEnabled = false
local moonGravityEnabled = false
local surfEnabled = false
local xrayEnabled = false
local rgbEnabled = false
local fullbrightEnabled = false
local freecamEnabled = false
local autoPromptEnabled = false

local airPlatform = nil
local airWalkConnection = nil
local noclipConnection = nil
local flingConnection = nil
local rgbConnection = nil
local promptConnection = nil
local currentYLevel = nil

local originalGravity = Workspace.Gravity

-- Ana Ekran Arayüzü
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperKontrolGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 450)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Başlık Çubuğu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Süper Kontrol Paneli v8 (Ultimate)"
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 14)

-- Kaydırılabilir İçerik Alanı
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -52)
ScrollFrame.Position = UDim2.new(0, 5, 0, 46)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Otomatik Boyutlandırma
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
end)

-- Otomatik Buton Oluşturucu
local function CreateMenuButton(order, text, color)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.Size = UDim2.new(0.94, 0, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 58)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.Parent = ScrollFrame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- TÜM MENÜ ELEMANLARI (Eksiksiz Sıralama)
local ToggleAirWalkBtn = CreateMenuButton(1, "👟 Havada Yürüme (AirWalk): Kapalı", Color3.fromRGB(200, 50, 50))
local TurboBtn = CreateMenuButton(2, "🔥 Turbo Hız (Sol Shift): Kapalı", Color3.fromRGB(50, 50, 65))
local NoclipBtn = CreateMenuButton(3, "👻 Noclip (Duvar Geçme): Kapalı", Color3.fromRGB(140, 50, 50))

-- Hız Ayar Satırı
local SpeedRow = Instance.new("Frame")
SpeedRow.LayoutOrder = 4
SpeedRow.Size = UDim2.new(0.94, 0, 0, 64)
SpeedRow.BackgroundColor3 = Color3.fromRGB(30, 38, 35)
SpeedRow.Parent = ScrollFrame
Instance.new("UICorner", SpeedRow).CornerRadius = UDim.new(0, 8)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 24)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(180, 255, 200)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "🏃 Hız: 16 | Turbo: 40"
SpeedLabel.Parent = SpeedRow

local DecSpeedBtn = Instance.new("TextButton")
DecSpeedBtn.Size = UDim2.new(0.28, 0, 0, 32)
DecSpeedBtn.Position = UDim2.new(0.04, 0, 0, 27)
DecSpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
DecSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecSpeedBtn.TextSize = 14
DecSpeedBtn.Font = Enum.Font.GothamBold
DecSpeedBtn.Text = "- 10"
DecSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", DecSpeedBtn).CornerRadius = UDim.new(0, 6)

local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Size = UDim2.new(0.30, 0, 0, 32)
ResetSpeedBtn.Position = UDim2.new(0.35, 0, 0, 27)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
ResetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetSpeedBtn.TextSize = 12
ResetSpeedBtn.Font = Enum.Font.GothamSemibold
ResetSpeedBtn.Text = "Sıfırla (16)"
ResetSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", ResetSpeedBtn).CornerRadius = UDim.new(0, 6)

local IncSpeedBtn = Instance.new("TextButton")
IncSpeedBtn.Size = UDim2.new(0.28, 0, 0, 32)
IncSpeedBtn.Position = UDim2.new(0.68, 0, 0, 27)
IncSpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
IncSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncSpeedBtn.TextSize = 14
IncSpeedBtn.Font = Enum.Font.GothamBold
IncSpeedBtn.Text = "+ 10"
IncSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", IncSpeedBtn).CornerRadius = UDim.new(0, 6)

-- Tüm Yeni ve İstediğin Özel Özellik Butonları
local TouchTpBtn = CreateMenuButton(5, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))
local GiveTpToolBtn = CreateMenuButton(6, "🎒 Envantere 'TP Eşyası' Ver", Color3.fromRGB(85, 60, 150))
local FlingBtn = CreateMenuButton(7, "🌪️ Kasırga / Fling Modu: Kapalı", Color3.fromRGB(50, 50, 65))
local MoonGravBtn = CreateMenuButton(8, "🪐 Ay Yerçekimi (Moon): Kapalı", Color3.fromRGB(50, 50, 65))
local GrappleBtn = CreateMenuButton(9, "🕸️ Örümcek Adam Kancası Ver", Color3.fromRGB(85, 60, 150))
local SurfBtn = CreateMenuButton(10, "🚗 Görünmez Araba / Sörf Modu: Kapalı", Color3.fromRGB(50, 50, 65))
local XRayBtn = CreateMenuButton(11, "👁️ X-Ray (Duvarları Şeffaf Yap): Kapalı", Color3.fromRGB(50, 50, 65))
local RgbBtn = CreateMenuButton(12, "🌈 RGB Neon Karakter: Kapalı", Color3.fromRGB(50, 50, 65))
local FullbrightBtn = CreateMenuButton(13, "☀️ Fullbright (Gece Görüşü): Kapalı", Color3.fromRGB(50, 50, 65))
local FreecamBtn = CreateMenuButton(14, "👻 Hayalet Kamera (Freecam): Kapalı", Color3.fromRGB(50, 50, 65))
local AutoPromptBtn = CreateMenuButton(15, "⚡ Otomatik Etkileşim (Auto-Prompt): Kapalı", Color3.fromRGB(50, 50, 65))
local TeleportPlayerBtn = CreateMenuButton(16, "🎯 Rastgele Oyuncuya Işınlan", Color3.fromRGB(150, 80, 50))
local InfMoneyBtn = CreateMenuButton(17, "💸 Sınırsız Para / Coin Bas (999M)", Color3.fromRGB(200, 140, 20))
local InfJumpBtn = CreateMenuButton(18, "🚀 Havada Sınırsız Zıplama: Kapalı", Color3.fromRGB(50, 50, 65))
local MagnetBtn = CreateMenuButton(19, "🧲 Eşya / Coin Mıknatısı: Kapalı", Color3.fromRGB(50, 50, 65))

---------------------------------------------------------------------
-- HIZ VE TEMEL FONKSİYONLAR
---------------------------------------------------------------------

local function UpdateSpeedUI()
    local turboVal = math.floor(customSpeed * turboMultiplier)
    SpeedLabel.Text = "🏃 Hız: " .. customSpeed .. " | Turbo: " .. turboVal
end

DecSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed - 10, minSpeed, maxSpeed)
    UpdateSpeedUI()
end)

ResetSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = 16
    UpdateSpeedUI()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

IncSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed + 10, minSpeed, maxSpeed)
    UpdateSpeedUI()
end)

RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not hum then return end

    local activeSpeed = customSpeed
    if turboEnabled or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        activeSpeed = customSpeed * turboMultiplier
    end

    hum.WalkSpeed = activeSpeed

    if hum.MoveDirection.Magnitude > 0 and activeSpeed > 16 then
        local extraSpeed = activeSpeed - 16
        rootPart.CFrame = rootPart.CFrame + (hum.MoveDirection * extraSpeed * dt)
    end
end)

---------------------------------------------------------------------
-- HAVADA YÜRÜME (AIR WALK)
---------------------------------------------------------------------

local function StopAirWalk()
    isAirWalking = false
    ToggleAirWalkBtn.Text = "👟 Havada Yürüme (AirWalk): Kapalı"
    ToggleAirWalkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    if airWalkConnection then airWalkConnection:Disconnect() airWalkConnection = nil end
    if airPlatform then airPlatform:Destroy() airPlatform = nil end
end

local function StartAirWalk()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    isAirWalking = true
    ToggleAirWalkBtn.Text = "👟 Havada Yürüme (AirWalk): Açık"
    ToggleAirWalkBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)

    airPlatform = Instance.new("Part")
    airPlatform.Name = "AirWalkPlatform"
    airPlatform.Size = Vector3.new(14, 1, 14)
    airPlatform.Anchored = true
    airPlatform.CanCollide = true
    airPlatform.Transparency = 0.65
    airPlatform.Material = Enum.Material.ForceField
    airPlatform.Color = Color3.fromRGB(0, 200, 255)
    airPlatform.Parent = Workspace

    local hipOffset = humanoid.HipHeight + (rootPart.Size.Y / 2) + (airPlatform.Size.Y / 2)
    currentYLevel = rootPart.Position.Y - hipOffset

    airWalkConnection = RunService.RenderStepped:Connect(function(dt)
        if not isAirWalking or not LocalPlayer.Character or not rootPart.Parent then
            StopAirWalk()
            return
        end

        local vSpeed = math.clamp(customSpeed * 0.8, 25, 150)
        if turboEnabled or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vSpeed = vSpeed * 2
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            currentYLevel = currentYLevel + (vSpeed * dt)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            currentYLevel = currentYLevel - (vSpeed * dt)
        end

        airPlatform.CFrame = CFrame.new(rootPart.Position.X, currentYLevel, rootPart.Position.Z)

        if rootPart.Position.Y < currentYLevel + hipOffset - 0.4 then
            rootPart.CFrame = CFrame.new(rootPart.Position.X, currentYLevel + hipOffset, rootPart.Position.Z) * rootPart.CFrame.Rotation
            rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z)
        end
    end)
end

ToggleAirWalkBtn.MouseButton1Click:Connect(function()
    if isAirWalking then StopAirWalk() else StartAirWalk() end
end)

TurboBtn.MouseButton1Click:Connect(function()
    turboEnabled = not turboEnabled
    if turboEnabled then
        TurboBtn.Text = "🔥 Turbo Hız (Sol Shift): Açık"
        TurboBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 30)
    else
        TurboBtn.Text = "🔥 Turbo Hız (Sol Shift): Kapalı"
        TurboBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    autoNoclip = not autoNoclip
    if autoNoclip then
        NoclipBtn.Text = "👻 Noclip (Duvar Geçme): Açık"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        noclipConnection = RunService.Stepped:Connect(function()
            if autoNoclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipBtn.Text = "👻 Noclip (Duvar Geçme): Kapalı"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
end)

---------------------------------------------------------------------
-- YENİ EKLENEN ÖZELLİKLERİN ÇALIŞMA MEKANİZMALARI
---------------------------------------------------------------------

-- 1. Kasırga / Fling Modu
FlingBtn.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    if flingEnabled then
        FlingBtn.Text = "🌪️ Kasırga / Fling Modu: Açık"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        flingConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
            end
        end)
    else
        FlingBtn.Text = "🌪️ Kasırga / Fling Modu: Kapalı"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if flingConnection then flingConnection:Disconnect() flingConnection = nil end
    end
end)

-- 2. Ay Yerçekimi (Moon Gravity)
MoonGravBtn.MouseButton1Click:Connect(function()
    moonGravityEnabled = not moonGravityEnabled
    if moonGravityEnabled then
        MoonGravBtn.Text = "🪐 Ay Yerçekimi (Moon): Açık"
        MoonGravBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        Workspace.Gravity = 30
    else
        MoonGravBtn.Text = "🪐 Ay Yerçekimi (Moon): Kapalı"
        MoonGravBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        Workspace.Gravity = originalGravity
    end
end)

-- 3. Örümcek Adam Kancası
GrappleBtn.MouseButton1Click:Connect(function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    if backpack:FindFirstChild("Örümcek Kancası") then backpack["Örümcek Kancası"]:Destroy() end

    local tool = Instance.new("Tool")
    tool.Name = "Örümcek Kancası"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    local mouse = LocalPlayer:GetMouse()
    tool.Activated:Connect(function()
        if mouse.Target then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local targetPos = mouse.Hit.Position
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = (targetPos - hrp.Position).Unit * 120
                bv.Parent = hrp
                task.wait(0.4)
                bv:Destroy()
            end
        end
    end)
    tool.Parent = backpack
    GrappleBtn.Text = "✅ Kanca Envantere Eklendi!"
    task.wait(1.5)
    GrappleBtn.Text = "🕸️ Örümcek Adam Kancası Ver"
end)

-- 4. Görünmez Araba / Sörf Modu
SurfBtn.MouseButton1Click:Connect(function()
    surfEnabled = not surfEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if surfEnabled then
            SurfBtn.Text = "🚗 Görünmez Sörf Modu: Açık"
            SurfBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
            hum.Sit = true
        else
            SurfBtn.Text = "🚗 Görünmez Araba / Sörf Modu: Kapalı"
            SurfBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            hum.Sit = false
        end
    end
end)

-- 5. X-Ray
XRayBtn.MouseButton1Click:Connect(function()
    xrayEnabled = not xrayEnabled
    if xrayEnabled then
        XRayBtn.Text = "👁️ X-Ray: Açık"
        XRayBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
                obj.LocalTransparencyModifier = 0.5
            end
        end
    else
        XRayBtn.Text = "👁️ X-Ray: Kapalı"
        XRayBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- 6. RGB Neon Karakter
RgbBtn.MouseButton1Click:Connect(function()
    rgbEnabled = not rgbEnabled
    if rgbEnabled then
        RgbBtn.Text = "🌈 RGB Neon Karakter: Açık"
        RgbBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        rgbConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Neon
                        part.Color = color
                    end
                end
            end
        end)
    else
        RgbBtn.Text = "🌈 RGB Neon Karakter: Kapalı"
        RgbBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if rgbConnection then rgbConnection:Disconnect() rgbConnection = nil end
    end
end)

-- 7. Fullbright
FullbrightBtn.MouseButton1Click:Connect(function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        FullbrightBtn.Text = "☀️ Fullbright: Açık"
        FullbrightBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false
    else
        FullbrightBtn.Text = "☀️ Fullbright: Kapalı"
        FullbrightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
    end
end)

-- 8. Hayalet Kamera (Freecam)
FreecamBtn.MouseButton1Click:Connect(function()
    freecamEnabled = not freecamEnabled
    local cam = Workspace.CurrentCamera
    if freecamEnabled then
        FreecamBtn.Text = "👻 Hayalet Kamera: Açık"
        FreecamBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        cam.CameraType = Enum.CameraType.Scriptable
    else
        FreecamBtn.Text = "👻 Hayalet Kamera: Kapalı"
        FreecamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        cam.CameraType = Enum.CameraType.Custom
    end
end)

-- 9. Otomatik Etkileşim (Auto-Prompt)
AutoPromptBtn.MouseButton1Click:Connect(function()
    autoPromptEnabled = not autoPromptEnabled
    if autoPromptEnabled then
        AutoPromptBtn.Text = "⚡ Auto-Prompt: Açık"
        AutoPromptBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        promptConnection = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    fireproximityprompt(obj)
                end
            end
        end)
    else
        AutoPromptBtn.Text = "⚡ Auto-Prompt: Kapalı"
        AutoPromptBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if promptConnection then promptConnection:Disconnect() promptConnection = nil end
    end
end)

-- 10. Rastgele Oyuncuya Işınlanma
TeleportPlayerBtn.MouseButton1Click:Connect(function()
    local playersList = Players:GetPlayers()
    local target = nil
    for _, p in pairs(playersList) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            target = p
            break
        end
    end

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            TeleportPlayerBtn.Text = "✅ Işınlanıldı: " .. target.Name
        end
    else
        TeleportPlayerBtn.Text = "⚠️ Başka Oyuncu Bulunamadı!"
    end
    task.wait(1.5)
    TeleportPlayerBtn.Text = "🎯 Rastgele Oyuncuya Işınlan"
end)

-- Diğer Standart Butonlar
local mouse = LocalPlayer:GetMouse()

TouchTpBtn.MouseButton1Click:Connect(function()
    touchTpEnabled = not touchTpEnabled
    TouchTpBtn.Text = touchTpEnabled and "⚡ Dokunduğun Yere TP: Açık" or "⚡ Dokunduğun Yere TP: Kapalı"
    TouchTpBtn.BackgroundColor3 = touchTpEnabled and Color3.fromRGB(40, 140, 90) or Color3.fromRGB(50, 50, 65)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if touchTpEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if mouse.Target then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetPos = mouse.Hit.Position + Vector3.new(0, 3.5, 0)
                char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                if isAirWalking and currentYLevel then currentYLevel = targetPos.Y - 3.5 end
            end
        end
    end
end)

GiveTpToolBtn.MouseButton1Click:Connect(function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    if backpack:FindFirstChild("Işınlanma Aleti") then backpack["Işınlanma Aleti"]:Destroy() end
    local tool = Instance.new("Tool")
    tool.Name = "Işınlanma Aleti"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Activated:Connect(function()
        if mouse.Target then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetPos = mouse.Hit.Position + Vector3.new(0, 3.5, 0)
                char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                if isAirWalking and currentYLevel then currentYLevel = targetPos.Y - 3.5 end
            end
        end
    end)
    tool.Parent = backpack
    GiveTpToolBtn.Text = "✅ Envantere Eklendi!"
    task.wait(1.5)
    GiveTpToolBtn.Text = "🎒 Envantere 'TP Eşyası' Ver"
end)

InfMoneyBtn.MouseButton1Click:Connect(function()
    local count = 0
    for _, obj in pairs(LocalPlayer:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then obj.Value = 999999999 count = count + 1 end
    end
    InfMoneyBtn.Text = count > 0 and ("✅ " .. count .. " Değer 999M!") or "⚠️ Değer Bulunamadı!"
    task.wait(2)
    InfMoneyBtn.Text = "💸 Sınırsız Para / Coin Bas (999M)"
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    InfJumpBtn.Text = infJumpEnabled and "🚀 Havada Sınırsız Zıplama: Açık" or "🚀 Havada Sınırsız Zıplama: Kapalı"
    InfJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(40, 140, 90) or Color3.fromRGB(50, 50, 65)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MagnetBtn.MouseButton1Click:Connect(function()
    magnetEnabled = not magnetEnabled
    MagnetBtn.Text = magnetEnabled and "🧲 Mıknatıs: Açık" or "🧲 Mıknatıs: Kapalı"
    MagnetBtn.BackgroundColor3 = magnetEnabled and Color3.fromRGB(40, 140, 90) or Color3.fromRGB(50, 50, 65)
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if magnetEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("BasePart") and not item.Anchored then
                    local name = string.lower(item.Name)
                    if string.find(name, "coin") or string.find(name, "gem") or string.find(name, "orb") or string.find(name, "drop") then
                        item.CFrame = rootPos
                    end
                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if isAirWalking then StopAirWalk() end
end)
