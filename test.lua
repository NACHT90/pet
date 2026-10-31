-- Süper Kontrol Paneli v4 (Havada Yürüme / Görünmez Zemin Modu)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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
local verticalSpeed = 35 -- Space ve Ctrl ile yükselme/alçalma hızı
local turboEnabled = false
local turboMultiplier = 2.5

local walkSpeed = 16
local minWalkSpeed = 16
local maxWalkSpeed = 300

local autoNoclip = false
local infJumpEnabled = false
local magnetEnabled = false
local touchTpEnabled = false

local airPlatform = nil
local airWalkConnection = nil
local noclipConnection = nil
local currentYLevel = nil

-- Ana Ekran Arayüzü
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperKontrolGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 315, 0, 410)
MainFrame.Position = UDim2.new(0.5, -157, 0.5, -205)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Başlık Çubuğu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Süper Kontrol Paneli v4 (AirWalk)"
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- Kaydırılabilir İçerik Alanı
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -12, 1, -52)
ScrollFrame.Position = UDim2.new(0, 6, 0, 46)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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

-- MENÜ ELEMANLARI
local ToggleAirWalkBtn = CreateMenuButton(1, "👟 Havada Yürüme (AirWalk): Kapalı", Color3.fromRGB(200, 50, 50))
local TurboBtn = CreateMenuButton(2, "🔥 Turbo Koşu (Sol Shift): Kapalı", Color3.fromRGB(50, 50, 65))
local NoclipBtn = CreateMenuButton(3, "👻 Noclip (Duvar Geçme): Kapalı", Color3.fromRGB(140, 50, 50))

-- Koşma Hızı (WalkSpeed) Ayar Satırı
local WalkSpeedRow = Instance.new("Frame")
WalkSpeedRow.LayoutOrder = 4
WalkSpeedRow.Size = UDim2.new(0.94, 0, 0, 62)
WalkSpeedRow.BackgroundColor3 = Color3.fromRGB(30, 38, 35)
WalkSpeedRow.Parent = ScrollFrame
Instance.new("UICorner", WalkSpeedRow).CornerRadius = UDim.new(0, 8)

local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Size = UDim2.new(1, 0, 0, 24)
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.TextColor3 = Color3.fromRGB(180, 255, 200)
WalkSpeedLabel.TextSize = 12
WalkSpeedLabel.Font = Enum.Font.GothamSemibold
WalkSpeedLabel.Text = "🏃 Yürüme / Uçuş Hızı: " .. walkSpeed
WalkSpeedLabel.Parent = WalkSpeedRow

local DecWalkBtn = Instance.new("TextButton")
DecWalkBtn.Size = UDim2.new(0.28, 0, 0, 30)
DecWalkBtn.Position = UDim2.new(0.04, 0, 0, 27)
DecWalkBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
DecWalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecWalkBtn.TextSize = 14
DecWalkBtn.Font = Enum.Font.GothamBold
DecWalkBtn.Text = "- 5"
DecWalkBtn.Parent = WalkSpeedRow
Instance.new("UICorner", DecWalkBtn).CornerRadius = UDim.new(0, 6)

local ResetWalkBtn = Instance.new("TextButton")
ResetWalkBtn.Size = UDim2.new(0.30, 0, 0, 30)
ResetWalkBtn.Position = UDim2.new(0.35, 0, 0, 27)
ResetWalkBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
ResetWalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetWalkBtn.TextSize = 12
ResetWalkBtn.Font = Enum.Font.GothamSemibold
ResetWalkBtn.Text = "Sıfırla (16)"
ResetWalkBtn.Parent = WalkSpeedRow
Instance.new("UICorner", ResetWalkBtn).CornerRadius = UDim.new(0, 6)

local IncWalkBtn = Instance.new("TextButton")
IncWalkBtn.Size = UDim2.new(0.28, 0, 0, 30)
IncWalkBtn.Position = UDim2.new(0.68, 0, 0, 27)
IncWalkBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
IncWalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncWalkBtn.TextSize = 14
IncWalkBtn.Font = Enum.Font.GothamBold
IncWalkBtn.Text = "+ 5"
IncWalkBtn.Parent = WalkSpeedRow
Instance.new("UICorner", IncWalkBtn).CornerRadius = UDim.new(0, 6)

-- Diğer Özel Butonlar
local TouchTpBtn = CreateMenuButton(5, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))
local GiveTpToolBtn = CreateMenuButton(6, "🎒 Envantere 'TP Eşyası' Ver", Color3.fromRGB(85, 60, 150))
local InfMoneyBtn = CreateMenuButton(7, "💸 Sınırsız Para / Coin Bas (999M)", Color3.fromRGB(200, 140, 20))
local InfJumpBtn = CreateMenuButton(8, "🚀 Havada Sınırsız Zıplama: Kapalı", Color3.fromRGB(50, 50, 65))
local MagnetBtn = CreateMenuButton(9, "🧲 Eşya / Coin Mıknatısı: Kapalı", Color3.fromRGB(50, 50, 65))

---------------------------------------------------------------------
-- HAVADA YÜRÜME (AIR WALK) VE MEKANİKLER
---------------------------------------------------------------------

local function ApplyWalkSpeed()
    WalkSpeedLabel.Text = "🏃 Yürüme / Uçuş Hızı: " .. walkSpeed
end

DecWalkBtn.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed - 5, minWalkSpeed, maxWalkSpeed)
    ApplyWalkSpeed()
end)

ResetWalkBtn.MouseButton1Click:Connect(function()
    walkSpeed = 16
    ApplyWalkSpeed()
end)

IncWalkBtn.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed + 5, minWalkSpeed, maxWalkSpeed)
    ApplyWalkSpeed()
end)

-- Hız ve Turbo Kontrol Döngüsü
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local targetSpeed = walkSpeed
            if turboEnabled or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                targetSpeed = walkSpeed * turboMultiplier
            end
            if hum.WalkSpeed ~= targetSpeed then
                hum.WalkSpeed = targetSpeed
            end
        end
    end
end)

local function SetCharacterCollision(state)
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = state
            end
        end
    end
end

-- Havada Yürümeyi Durdurma
local function StopAirWalk()
    isAirWalking = false
    ToggleAirWalkBtn.Text = "👟 Havada Yürüme (AirWalk): Kapalı"
    ToggleAirWalkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    if airWalkConnection then
        airWalkConnection:Disconnect()
        airWalkConnection = nil
    end
    if airPlatform then
        airPlatform:Destroy()
        airPlatform = nil
    end
end

-- Havada Yürümeyi Başlatma (Görünmez Platform Sistemi)
local function StartAirWalk()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    isAirWalking = true
    ToggleAirWalkBtn.Text = "👟 Havada Yürüme (AirWalk): Açık"
    ToggleAirWalkBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)

    -- Karakterin ayaklarının altına görünmez bir zemin oluştur
    airPlatform = Instance.new("Part")
    airPlatform.Name = "AirWalkPlatform"
    airPlatform.Size = Vector3.new(12, 1, 12)
    airPlatform.Anchored = true
    airPlatform.CanCollide = true
    airPlatform.Transparency = 0.7 -- Hafif görünür (Tamamen görünmez yapmak için 1 yapabilirsin)
    airPlatform.Material = Enum.Material.ForceField
    airPlatform.Color = Color3.fromRGB(0, 200, 255)
    airPlatform.Parent = Workspace

    -- Karakterin bacak yüksekliğini hesapla
    local hipOffset = humanoid.HipHeight + (rootPart.Size.Y / 2) + (airPlatform.Size.Y / 2)
    currentYLevel = rootPart.Position.Y - hipOffset

    airWalkConnection = RunService.RenderStepped:Connect(function(dt)
        if not isAirWalking or not LocalPlayer.Character or not rootPart.Parent then
            StopAirWalk()
            return
        end

        -- Space basılıysa zemini yukarı kaldır, Sol Ctrl basılıysa aşağı indir
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            currentYLevel = currentYLevel + (verticalSpeed * dt)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            currentYLevel = currentYLevel - (verticalSpeed * dt)
        end

        -- Platformu sürekli karakterin X ve Z konumunun altında tut
        airPlatform.CFrame = CFrame.new(rootPart.Position.X, currentYLevel, rootPart.Position.Z)

        -- Aşağı inerken veya yukarı çıkarken karakterin platformdan kopmaması için dikey hızı dengeler
        if rootPart.Position.Y < currentYLevel + hipOffset - 0.5 then
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
        TurboBtn.Text = "🔥 Turbo Koşu (Sol Shift): Açık"
        TurboBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 30)
    else
        TurboBtn.Text = "🔥 Turbo Koşu (Sol Shift): Kapalı"
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
        SetCharacterCollision(true)
    end
end)

-- Dokunduğun / Tıkladığın Yere TP
local mouse = LocalPlayer:GetMouse()

TouchTpBtn.MouseButton1Click:Connect(function()
    touchTpEnabled = not touchTpEnabled
    if touchTpEnabled then
        TouchTpBtn.Text = "⚡ Dokunduğun Yere TP: Açık"
        TouchTpBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    else
        TouchTpBtn.Text = "⚡ Dokunduğun Yere TP: Kapalı"
        TouchTpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if touchTpEnabled then
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if mouse.Target then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local targetPos = mouse.Hit.Position + Vector3.new(0, 3.5, 0)
                    char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                    if isAirWalking and currentYLevel then
                        currentYLevel = targetPos.Y - 3.5
                    end
                end
            end
        end
    end
end)

-- Envantere TP Eşyası Verme
GiveTpToolBtn.MouseButton1Click:Connect(function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    if backpack:FindFirstChild("Işınlanma Aleti") then
        backpack["Işınlanma Aleti"]:Destroy()
    end

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
                if isAirWalking and currentYLevel then
                    currentYLevel = targetPos.Y - 3.5
                end
            end
        end
    end)

    tool.Parent = backpack
    GiveTpToolBtn.Text = "✅ Envantere Eklendi!"
    task.wait(1.5)
    GiveTpToolBtn.Text = "🎒 Envantere 'TP Eşyası' Ver"
end)

-- Sınırsız Para / Coin Basıcı
InfMoneyBtn.MouseButton1Click:Connect(function()
    local changedCount = 0
    for _, obj in pairs(LocalPlayer:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            obj.Value = 999999999
            changedCount = changedCount + 1
        end
    end
    if changedCount > 0 then
        InfMoneyBtn.Text = "✅ " .. changedCount .. " Değer 999M Yapıldı!"
    else
        InfMoneyBtn.Text = "⚠️ Para Değeri Bulunamadı!"
    end
    task.wait(2)
    InfMoneyBtn.Text = "💸 Sınırsız Para / Coin Bas (999M)"
end)

-- Havada Sınırsız Zıplama
InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        InfJumpBtn.Text = "🚀 Havada Sınırsız Zıplama: Açık"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    else
        InfJumpBtn.Text = "🚀 Havada Sınırsız Zıplama: Kapalı"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Eşya ve Coin Mıknatısı
MagnetBtn.MouseButton1Click:Connect(function()
    magnetEnabled = not magnetEnabled
    if magnetEnabled then
        MagnetBtn.Text = "🧲 Eşya / Coin Mıknatısı: Açık"
        MagnetBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    else
        MagnetBtn.Text = "🧲 Eşya / Coin Mıknatısı: Kapalı"
        MagnetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
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
