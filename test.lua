-- Süper Kontrol Paneli v2 (Kaydırılabilir Tam Liste - Tüm Özellikler Aktif)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski menülerin hepsini temizle (Eski sürümün ekranda kalmasını önler)
for _, guiName in pairs({"TestArayuzGui", "UcusArayuzGui", "SuperKontrolGui"}) do
    if PlayerGui:FindFirstChild(guiName) then
        PlayerGui[guiName]:Destroy()
    end
end

-- Değişkenler
local isFlying = false
local flySpeed = 50
local turboEnabled = false -- Menüden veya Shift ile açılabilir
local turboMultiplier = 3
local minSpeed = 10
local maxSpeed = 300

local autoNoclip = true
local infJumpEnabled = false
local magnetEnabled = false
local touchTpEnabled = false

local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil
local noclipConnection = nil

-- Ana Ekran Arayüzü
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperKontrolGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 380)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -190)
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
Title.Text = "⚡ Süper Kontrol Paneli v2"
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- Kaydırılabilir İçerik Alanı (Hiçbir buton dışarı taşmaz!)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -12, 1, -52)
ScrollFrame.Position = UDim2.new(0, 6, 0, 46)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
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

-- MENÜ ELEMANLARI (Sırasıyla Hepsi Görünür)
local ToggleFlyBtn = CreateMenuButton(1, "✈️ Uçma: Kapalı (Başlat)", Color3.fromRGB(200, 50, 50))
local TurboBtn = CreateMenuButton(2, "🔥 Turbo Hız (3x / Sol Shift): Kapalı", Color3.fromRGB(50, 50, 65))
local NoclipBtn = CreateMenuButton(3, "👻 Oto-Noclip (Duvar Geçme): Açık", Color3.fromRGB(40, 140, 90))

-- Hız Ayar Satırı
local SpeedRow = Instance.new("Frame")
SpeedRow.LayoutOrder = 4
SpeedRow.Size = UDim2.new(0.94, 0, 0, 62)
SpeedRow.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SpeedRow.Parent = ScrollFrame
Instance.new("UICorner", SpeedRow).CornerRadius = UDim.new(0, 8)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 24)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(200, 210, 255)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "Normal Hız: 50 | Turbo Hız: 150"
SpeedLabel.Parent = SpeedRow

local DecreaseBtn = Instance.new("TextButton")
DecreaseBtn.Size = UDim2.new(0.44, 0, 0, 30)
DecreaseBtn.Position = UDim2.new(0.04, 0, 0, 27)
DecreaseBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
DecreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseBtn.TextSize = 15
DecreaseBtn.Font = Enum.Font.GothamBold
DecreaseBtn.Text = "- 10"
DecreaseBtn.Parent = SpeedRow
Instance.new("UICorner", DecreaseBtn).CornerRadius = UDim.new(0, 6)

local IncreaseBtn = Instance.new("TextButton")
IncreaseBtn.Size = UDim2.new(0.44, 0, 0, 30)
IncreaseBtn.Position = UDim2.new(0.52, 0, 0, 27)
IncreaseBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
IncreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseBtn.TextSize = 15
IncreaseBtn.Font = Enum.Font.GothamBold
IncreaseBtn.Text = "+ 10"
IncreaseBtn.Parent = SpeedRow
Instance.new("UICorner", IncreaseBtn).CornerRadius = UDim.new(0, 6)

-- Yeni Eklenen Özel Butonlar
local TouchTpBtn = CreateMenuButton(5, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))
local GiveTpToolBtn = CreateMenuButton(6, "🎒 Envantere 'TP Eşyası' Ver", Color3.fromRGB(85, 60, 150))
local InfMoneyBtn = CreateMenuButton(7, "💸 Sınırsız Para / Coin Bas (999M)", Color3.fromRGB(200, 140, 20))
local InfJumpBtn = CreateMenuButton(8, "🚀 Havada Sınırsız Zıplama: Kapalı", Color3.fromRGB(50, 50, 65))
local MagnetBtn = CreateMenuButton(9, "🧲 Eşya / Coin Mıknatısı: Kapalı", Color3.fromRGB(50, 50, 65))

---------------------------------------------------------------------
-- FONKSİYONLAR VE MEKANİKLER
---------------------------------------------------------------------

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

local function StopFlying()
    isFlying = false
    ToggleFlyBtn.Text = "✈️ Uçma: Kapalı (Başlat)"
    ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end

    local character = LocalPlayer.Character
    if character then
        if character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
        SetCharacterCollision(true)
    end
end

local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end

    isFlying = true
    ToggleFlyBtn.Text = "✈️ Uçma: Açık (Durdur)"
    ToggleFlyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    noclipConnection = RunService.Stepped:Connect(function()
        if isFlying and autoNoclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not LocalPlayer.Character or not rootPart.Parent then
            StopFlying()
            return
        end

        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        -- Menüden Turbo açıksa VEYA Sol Shift basılıysa 3x hız uygula
        local currentSpeed = flySpeed
        if turboEnabled or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            currentSpeed = flySpeed * turboMultiplier
        end

        bodyVelocity.Velocity = moveDir * currentSpeed
        bodyGyro.CFrame = cam.CFrame
    end)
end

-- Buton Bağlantıları
ToggleFlyBtn.MouseButton1Click:Connect(function()
    if isFlying then StopFlying() else StartFlying() end
end)

TurboBtn.MouseButton1Click:Connect(function()
    turboEnabled = not turboEnabled
    if turboEnabled then
        TurboBtn.Text = "🔥 Turbo Hız (3x / Sol Shift): Açık"
        TurboBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 30)
    else
        TurboBtn.Text = "🔥 Turbo Hız (3x / Sol Shift): Kapalı"
        TurboBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    autoNoclip = not autoNoclip
    if autoNoclip then
        NoclipBtn.Text = "👻 Oto-Noclip (Duvar Geçme): Açık"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    else
        NoclipBtn.Text = "👻 Oto-Noclip (Duvar Geçme): Kapalı"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
        SetCharacterCollision(true)
    end
end)

local function UpdateSpeedText()
    SpeedLabel.Text = "Normal Hız: " .. flySpeed .. " | Turbo Hız: " .. (flySpeed * turboMultiplier)
end

DecreaseBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, minSpeed, maxSpeed)
    UpdateSpeedText()
end)

IncreaseBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, minSpeed, maxSpeed)
    UpdateSpeedText()
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
                    char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3.5, 0))
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
                char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3.5, 0))
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
    if isFlying then StopFlying() end
end)
