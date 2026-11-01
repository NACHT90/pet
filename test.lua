-- Süper Kontrol Paneli v19 (Sadece Seçilen Temel ve Etkili Özellikler)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski menüleri temizle
for _, guiName in pairs({"TestArayuzGui", "UcusArayuzGui", "SuperKontrolGui"}) do
    if PlayerGui:FindFirstChild(guiName) then
        PlayerGui[guiName]:Destroy()
    end
end

-- Değişkenler
local isAirWalking = false
local autoNoclip = false
local flyingEnabled = false
local bridgeEnabled = false
local turboEnabled = false

local customSpeed = 16
local flightSpeed = 50
local minSpeed = 16
local maxSpeed = 250

local airPlatform = nil
local airWalkConnection = nil
local noclipConnection = nil
local flightConnection = nil
local bridgeConnection = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperKontrolGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 335, 0, 440)
MainFrame.Position = UDim2.new(0.5, -167, 0.5, -220)
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
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Temel Kontrol Paneli v19 (Squid Game Dostu)"
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

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
end)

local function CreateMenuButton(order, text, color)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.Size = UDim2.new(0.94, 0, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 58)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.Parent = ScrollFrame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- SEÇİLEN ÖZELLİK BUTONLARI
local AirWalkBtn = CreateMenuButton(1, "👟 Havada Yürüme (AirWalk): Kapalı", Color3.fromRGB(200, 50, 50))
local FlyBtn = CreateMenuButton(2, "🕊️ Uçma (Flight): Kapalı", Color3.fromRGB(50, 50, 65))
local BridgeBtn = CreateMenuButton(3, "🧱 Insta-Bridge (Altına Köprü Ör): Kapalı", Color3.fromRGB(50, 50, 65))
local NoclipBtn = CreateMenuButton(4, "👻 Noclip (Duvar Geçme): Kapalı", Color3.fromRGB(140, 50, 50))
local TouchTpBtn = CreateMenuButton(5, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))

-- Hız Ayar Satırı
local SpeedRow = Instance.new("Frame")
SpeedRow.LayoutOrder = 6
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
SpeedLabel.Text = "🏃 Hız: 16 | Uçma Hızı: 50"
SpeedLabel.Parent = SpeedRow

local DecSpeedBtn = Instance.new("TextButton")
DecSpeedBtn.Size = UDim2.new(0.28, 0, 0, 32)
DecSpeedBtn.Position = UDim2.new(0.04, 0, 0, 27)
DecSpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
DecSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecSpeedBtn.TextSize = 13
DecSpeedBtn.Font = Enum.Font.GothamBold
DecSpeedBtn.Text = "Hız -"
DecSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", DecSpeedBtn).CornerRadius = UDim.new(0, 6)

local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Size = UDim2.new(0.30, 0, 0, 32)
ResetSpeedBtn.Position = UDim2.new(0.35, 0, 0, 27)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
ResetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetSpeedBtn.TextSize = 11
ResetSpeedBtn.Font = Enum.Font.GothamSemibold
ResetSpeedBtn.Text = "Sıfırla (16)"
ResetSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", ResetSpeedBtn).CornerRadius = UDim.new(0, 6)

local IncSpeedBtn = Instance.new("TextButton")
IncSpeedBtn.Size = UDim2.new(0.28, 0, 0, 32)
IncSpeedBtn.Position = UDim2.new(0.68, 0, 0, 27)
IncSpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 55)
IncSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncSpeedBtn.TextSize = 13
IncSpeedBtn.Font = Enum.Font.GothamBold
IncSpeedBtn.Text = "Hız +"
IncSpeedBtn.Parent = SpeedRow
Instance.new("UICorner", IncSpeedBtn).CornerRadius = UDim.new(0, 6)

-- Uçma Hızı Ayar Satırı
local FlySpeedRow = Instance.new("Frame")
FlySpeedRow.LayoutOrder = 7
FlySpeedRow.Size = UDim2.new(0.94, 0, 0, 50)
FlySpeedRow.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
FlySpeedRow.Parent = ScrollFrame
Instance.new("UICorner", FlySpeedRow).CornerRadius = UDim.new(0, 8)

local DecFlyBtn = Instance.new("TextButton")
DecFlyBtn.Size = UDim2.new(0.44, 0, 0, 34)
DecFlyBtn.Position = UDim2.new(0.04, 0, 0, 8)
DecFlyBtn.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
DecFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecFlyBtn.TextSize = 12
DecFlyBtn.Font = Enum.Font.GothamBold
DecFlyBtn.Text = "Uçma Hızı - 10"
DecFlyBtn.Parent = FlySpeedRow
Instance.new("UICorner", DecFlyBtn).CornerRadius = UDim.new(0, 6)

local IncFlyBtn = Instance.new("TextButton")
IncFlyBtn.Size = UDim2.new(0.44, 0, 0, 34)
IncFlyBtn.Position = UDim2.new(0.52, 0, 0, 8)
IncFlyBtn.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
IncFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncFlyBtn.TextSize = 12
IncFlyBtn.Font = Enum.Font.GothamBold
IncFlyBtn.Text = "Uçma Hızı + 10"
IncFlyBtn.Parent = FlySpeedRow
Instance.new("UICorner", IncFlyBtn).CornerRadius = UDim.new(0, 6)

local TurboBtn = CreateMenuButton(8, "🔥 Turbo Hız (Sol Shift basılı tut): Kapalı", Color3.fromRGB(50, 50, 65))

---------------------------------------------------------------------
-- FONKSİYONLAR
---------------------------------------------------------------------

-- Hız Kontrolleri
DecSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed - 10, minSpeed, maxSpeed)
    SpeedLabel.Text = "🏃 Hız: " .. customSpeed .. " | Uçma Hızı: " .. flightSpeed
end)

ResetSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = 16
    SpeedLabel.Text = "🏃 Hız: 16 | Uçma Hızı: " .. flightSpeed
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

IncSpeedBtn.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed + 10, minSpeed, maxSpeed)
    SpeedLabel.Text = "🏃 Hız: " .. customSpeed .. " | Uçma Hızı: " .. flightSpeed
end)

DecFlyBtn.MouseButton1Click:Connect(function()
    flightSpeed = math.clamp(flightSpeed - 10, 10, 300)
    SpeedLabel.Text = "🏃 Hız: " .. customSpeed .. " | Uçma Hızı: " .. flightSpeed
end)

IncFlyBtn.MouseButton1Click:Connect(function()
    flightSpeed = math.clamp(flightSpeed + 10, 10, 300)
    SpeedLabel.Text = "🏃 Hız: " .. customSpeed .. " | Uçma Hızı: " .. flightSpeed
end)

RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not hum then return end

    local activeSpeed = customSpeed
    if turboEnabled or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        activeSpeed = customSpeed * 2.5
    end

    hum.WalkSpeed = activeSpeed

    if hum.MoveDirection.Magnitude > 0 and activeSpeed > 16 then
        local extraSpeed = activeSpeed - 16
        rootPart.CFrame = rootPart.CFrame + (hum.MoveDirection * extraSpeed * dt)
    end
end)

-- Turbo Toggle
TurboBtn.MouseButton1Click:Connect(function()
    turboEnabled = not turboEnabled
    TurboBtn.Text = turboEnabled and "🔥 Turbo Hız: Açık" or "🔥 Turbo Hız (Sol Shift basılı tut): Kapalı"
    TurboBtn.BackgroundColor3 = turboEnabled and Color3.fromRGB(220, 100, 30) or Color3.fromRGB(50, 50, 65)
end)

-- 1. Havada Yürüme (AirWalk)
AirWalkBtn.MouseButton1Click:Connect(function()
    isAirWalking = not isAirWalking
    if isAirWalking then
        AirWalkBtn.Text = "👟 Havada Yürüme: Açık"
        AirWalkBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        
        airPlatform = Instance.new("Part")
        airPlatform.Size = Vector3.new(10, 1, 10)
        airPlatform.Anchored = true
        airPlatform.CanCollide = true
        airPlatform.Transparency = 0.5
        airPlatform.Material = Enum.Material.ForceField
        airPlatform.Color = Color3.fromRGB(0, 200, 255)
        airPlatform.Parent = Workspace

        airWalkConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                airPlatform.CFrame = hrp.CFrame - Vector3.new(0, 3.5, 0)
            end
        end)
    else
        AirWalkBtn.Text = "👟 Havada Yürüme (AirWalk): Kapalı"
        AirWalkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if airWalkConnection then airWalkConnection:Disconnect() airWalkConnection = nil end
        if airPlatform then airPlatform:Destroy() airPlatform = nil end
    end
end)

-- 2. Uçma (Flight & Hız Ayarı)
FlyBtn.MouseButton1Click:Connect(function()
    flyingEnabled = not flyingEnabled
    if flyingEnabled then
        FlyBtn.Text = "🕊️ Uçma: Açık"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        
        flightConnection = RunService.RenderStepped:Connect(function(dt)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local cam = Workspace.CurrentCamera
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDir.Unit * flightSpeed * dt)
                end
            end
        end)
    else
        FlyBtn.Text = "🕊️ Uçma (Flight): Kapalı"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if flightConnection then flightConnection:Disconnect() flightConnection = nil end
    end
end)

-- 3. Insta-Bridge (Altına Köprü Örme)
BridgeBtn.MouseButton1Click:Connect(function()
    bridgeEnabled = not bridgeEnabled
    if bridgeEnabled then
        BridgeBtn.Text = "🧱 Insta-Bridge: Açık"
        BridgeBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        bridgeConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local p = Instance.new("Part")
                p.Size = Vector3.new(4, 0.6, 4)
                p.Position = hrp.Position - Vector3.new(0, 3.5, 0)
                p.Anchored = true
                p.CanCollide = true
                p.BrickColor = BrickColor.random()
                p.Parent = Workspace
                game:GetService("Debris"):AddItem(p, 3)
            end
        end)
    else
        BridgeBtn.Text = "🧱 Insta-Bridge (Altına Köprü Ör): Kapalı"
        BridgeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if bridgeConnection then bridgeConnection:Disconnect() bridgeConnection = nil end
    end
end)

-- 4. Noclip (Duvar Geçme)
NoclipBtn.MouseButton1Click:Connect(function()
    autoNoclip = not autoNoclip
    NoclipBtn.Text = autoNoclip and "👻 Noclip: Açık" or "👻 Noclip (Duvar Geçme): Kapalı"
    NoclipBtn.BackgroundColor3 = autoNoclip and Color3.fromRGB(40, 140, 90) or Color3.fromRGB(140, 50, 50)
    
    if autoNoclip then
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
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    end
end)

-- 5. Dokunduğun Yere TP
local touchTpEnabled = false
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
                char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3.5, 0))
            end
        end
    end
end)
