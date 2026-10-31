-- Süper Kontrol Paneli v7 (Otomatik Boyutlandırılan Kaydırma Alanı + Tüm Özellikler)
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
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
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
Title.Text = "⚡ Süper Kontrol Paneli v7 (Ultimate)"
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

-- ÖNEMLİ: Butonlar eklendikçe kaydırma alanını otomatik büyütür (Hiçbir özellik kaybolmaz!)
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

-- TÜM MENÜ ELEMANLARI (Sırasıyla Eksiksiz)
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

-- Tüm Uçuk Kaçık Özellik Butonları
local TouchTpBtn = CreateMenuButton(5, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))
local GiveTpToolBtn = CreateMenuButton(6, "🎒 Envantere 'TP Eşyası' Ver", Color3.fromRGB(85, 60, 150))
local FlingBtn = CreateMenuButton(7, "🌪️ Kasırga / Fling Modu: Kapalı", Color3.fromRGB(50, 50, 65))
local MoonGravBtn = CreateMenuButton(8, "🪐 Ay Yerçekimi (Moon): Kapalı", Color3.fromRGB(50, 50, 65))
local GrappleBtn = CreateMenuButton(9, "🕸️ Örümcek Adam Kancası Ver", Color3.fromRGB(85, 60, 150))
local XRayBtn = CreateMenuButton(10, "👁️ X-Ray (Duvarları Şeffaf Yap): Kapalı", Color3.fromRGB(50, 50, 65))
local RgbBtn = CreateMenuButton(11, "🌈 RGB Neon Karakter: Kapalı", Color3.fromRGB(50, 50, 65))
local FullbrightBtn = CreateMenuButton(12, "☀️ Fullbright (Gece Görüşü): Kapalı", Color3.fromRGB(50, 50, 65))
local FreecamBtn = CreateMenuButton(13, "👻 Hayalet Kamera (Freecam): Kapalı", Color3.fromRGB(50, 50, 65))
local AutoPromptBtn = CreateMenuButton(14, "⚡ Otomatik Etkileşim (Auto-Prompt): Kapalı", Color3.fromRGB(50, 50, 65))
local InfMoneyBtn = CreateMenuButton(15, "💸 Sınırsız Para / Coin Bas (999M)", Color3.fromRGB(200, 140, 20))
local InfJumpBtn = CreateMenuButton(16, "🚀 Havada Sınırsız Zıplama: Kapalı", Color3.fromRGB(50, 50, 65))
local MagnetBtn = CreateMenuButton(17, "🧲 Eşya / Coin Mıknatısı: Kapalı", Color3.fromRGB(50, 50, 65))

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
-- UÇUK KAÇIK ÖZELLİKLERİN ÇALIŞMA MEKANİZMALARI
---------------------------------------------------------------------

-- 1. Kasırga / F
