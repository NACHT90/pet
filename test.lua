-- Süper Kontrol Paneli v10 (Pet Spawn + Ordu + Auto-Farm + Tüm Çılgın Özellikler)
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
local timeFreezeEnabled = false
local bridgeEnabled = false
local rgbSkyEnabled = false
local trailEnabled = false
local autoChatEnabled = false
local autoFarmEnabled = false
local petArmyEnabled = false

local airPlatform = nil
local airWalkConnection = nil
local noclipConnection = nil
local flingConnection = nil
local rgbConnection = nil
local promptConnection = nil
local timeConnection = nil
local bridgeConnection = nil
local rgbSkyConnection = nil
local trailConnection = nil
local chatConnection = nil
local autoFarmConnection = nil
local petArmyConnection = nil
local currentYLevel = nil

local originalGravity = Workspace.Gravity
local originalClockTime = Lighting.ClockTime

-- Ana Ekran Arayüzü
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperKontrolGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 460)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -230)
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
Title.Text = "⚡ Süper Kontrol Paneli v10 (Pet & God)"
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

-- TÜM MENÜ ELEMANLARI (Pet Odaklı + Önceki Çılgınlıklar)
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

-- Yeni Pet & Farm Butonları + Tüm Özellikler
local SpawnEggBtn = CreateMenuButton(5, "🥚 Olduğun Yere 'Pet Egg/Chest' Spawnla", Color3.fromRGB(180, 100, 20))
local PetArmyBtn = CreateMenuButton(6, "🐾 Pet Takip Ordusu (Pet Swarm): Kapalı", Color3.fromRGB(50, 50, 65))
local AutoFarmBtn = CreateMenuButton(7, "⚡ Otomatik Farm / Coin Kırıcı: Kapalı", Color3.fromRGB(40, 140, 90))
local MaxPetsBtn = CreateMenuButton(8, "✨ Petleri Rainbow / Max Yap (Visual)", Color3.fromRGB(200, 140, 20))
local TouchTpBtn = CreateMenuButton(9, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))
local GiveTpToolBtn = CreateMenuButton(10, "🎒 Envantere 'TP Eşyası' Ver", Color3.fromRGB(85, 60, 150))
local FlingBtn = CreateMenuButton(11, "🌪️ Kasırga / Fling Modu: Kapalı", Color3.fromRGB(50, 50, 65))
local MoonGravBtn = CreateMenuButton(12, "🪐 Ay Yerçekimi (Moon): Kapalı", Color3.fromRGB(50, 50, 65))
local PulseBtn = CreateMenuButton(13, "💥 Yerçekimi Patlaması (Pulse At)", Color3.fromRGB(180, 50, 50))
local GrappleBtn = CreateMenuButton(14, "🕸️ Örümcek Adam Kancası Ver", Color3.fromRGB(85, 60, 150))
local SurfBtn = CreateMenuButton(15, "🚗 Görünmez Sörf Modu: Kapalı", Color3.fromRGB(50, 50, 65))
local BridgeBtn = CreateMenuButton(16, "🧱 Insta-Bridge (Altına Köprü Ör): Kapalı", Color3.fromRGB(50, 50, 65))
local GiantBtn = CreateMenuButton(17, "🧍 Dev Adam Modu (Boyut Büyüt)", Color3.fromRGB(100, 50, 150))
local MiniBtn = CreateMenuButton(18, "👶 Cüce Modu (Boyut Küçült)", Color3.fromRGB(100, 50, 150))
local XRayBtn = CreateMenuButton(19, "👁️ X-Ray (Duvarları Şeffaf Yap): Kapalı", Color3.fromRGB(50, 50, 65))
local RgbBtn = CreateMenuButton(20, "🌈 RGB Neon Karakter: Kapalı", Color3.fromRGB(50, 50, 65))
local RgbSkyBtn = CreateMenuButton(21, "🎨 Gökkuşağı Gökyüzü (RGB Sky): Kapalı", Color3.fromRGB(50, 50, 65))
local TrailBtn = CreateMenuButton(22, "👥 Hayalet Kopya İzi (Ghost Trail): Kapalı", Color3.fromRGB(50, 50, 65))
local FullbrightBtn = CreateMenuButton(23, "☀️ Fullbright (Gece Görüşü): Kapalı", Color3.fromRGB(50, 50, 65))
local TimeFreezeBtn = CreateMenuButton(24, "⏰ Dünya Zamanını Dondur: Kapalı", Color3.fromRGB(50, 50, 65))
local FreecamBtn = CreateMenuButton(25, "👻 Hayalet Kamera (Freecam): Kapalı", Color3.fromRGB(50, 50, 65))
local AutoPromptBtn = CreateMenuButton(26, "⚡ Otomatik Etkileşim (Auto-Prompt): Kapalı", Color3.fromRGB(50, 50, 65))
local AutoChatBtn = CreateMenuButton(27, "💬 Otomatik Sohbet Spammer: Kapalı", Color3.fromRGB(50, 50, 65))
local TeleportPlayerBtn = CreateMenuButton(28, "🎯 Rastgele Oyuncuya Işınlan", Color3.fromRGB(150, 80, 50))
local InfMoneyBtn = CreateMenuButton(29, "💸 Sınırsız Para / Coin Bas (999M)", Color3.fromRGB(200, 140, 20))
local InfJumpBtn = CreateMenuButton(30, "🚀 Havada Sınırsız Zıplama: Kapalı", Color3.fromRGB(50, 50, 65))
local MagnetBtn = CreateMenuButton(31, "🧲 Eşya / Coin Mıknatısı: Kapalı", Color3.fromRGB(50, 50, 65))

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
-- YENİ PET VE FARM ÖZELLİKLERİ
---------------------------------------------------------------------

-- 1. Egg / Chest Spawnla
SpawnEggBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local egg = Instance.new("Part")
        egg.Name = "SpawnedPetEgg"
        egg.Size = Vector3.new(4, 5, 4)
        egg.Position = hrp.Position + (hrp.CFrame.LookVector * 5) + Vector3.new(0, 2, 0)
        egg.Shape = Enum.PartType.Ball
        egg.Material = Enum.Material.Neon
        egg.BrickColor = BrickColor.random()
        egg.Anchored = false
        egg.Parent = Workspace
        SpawnEggBtn.Text = "✅ Pet Sandığı Oluşturuldu!"
        task.wait(1.5)
        SpawnEggBtn.Text = "🥚 Olduğun Yere 'Pet Egg/Chest' Spawnla"
    end
end)

-- 2. Pet Takip Ordusu (Pet Swarm)
PetArmyBtn.MouseButton1Click:Connect(function()
    petArmyEnabled = not petArmyEnabled
    if petArmyEnabled then
        PetArmyBtn.Text = "🐾 Pet Takip Ordusu: Açık"
        PetArmyBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        petArmyConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                for i, p in pairs(Workspace:GetChildren()) do
                    if p:IsA("Model") and p ~= char and p:FindFirstChild("HumanoidRootPart") and i <= 5 then
                        p.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(i * 3, 0, i * 3)
                    end
                end
            end
        end)
    else
        PetArmyBtn.Text = "🐾 Pet Takip Ordusu (Pet Swarm): Kapalı"
        PetArmyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if petArmyConnection then petArmyConnection:Disconnect() petArmyConnection = nil end
    end
end)

-- 3. Otomatik Farm / Coin Kırıcı
AutoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        AutoFarmBtn.Text = "⚡ Otomatik Farm: Açık"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        autoFarmConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Anchored then
                        local name = string.lower(obj.Name)
                        if string.find(name, "chest") or string.find(name, "box") or string.find(name, "break") then
                            hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end)
    else
        AutoFarmBtn.Text = "⚡ Otomatik Farm / Coin Kırıcı: Kapalı"
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        if autoFarmConnection then autoFarmConnection:Disconnect() autoFarmConnection = nil end
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    end
end)

-- 4. Petleri Rainbow / Max Yap
MaxPetsBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(LocalPlayer:GetDescendants()) do
        if obj:IsA("StringValue") or obj:IsA("IntValue") then
            local n = string
