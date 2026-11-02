-- Süper Kontrol Paneli v21 (Universal Simulator Master Edition - X / 99 Uyumlu)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Simülatör Otomasyon Değişkenleri
local autoHatchEnabled = false
local autoTeleportZoneEnabled = false
local autoBuyZoneEnabled = false
local autoClickOrbEnabled = false
local autoMagnetEnabled = false

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
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
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
Title.Text = "⚡ Universal Simulator Paneli v21 (X / Diğerleri)"
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

-- SIMÜLATÖR VE HAREKET BUTONLARI
local AutoHatchBtn = CreateMenuButton(1, "🥚 Her Yerde Otomatik Yumurta Aç: Kapalı", Color3.fromRGB(180, 100, 20))
local AutoTpZoneBtn = CreateMenuButton(2, "🗺️ En İyi Bölgeye Otomatik TP: Kapalı", Color3.fromRGB(40, 140, 90))
local AutoBuyZoneBtn = CreateMenuButton(3, "🛒 Sonraki Bölgeyi / Kilidi Aç: Kapalı", Color3.fromRGB(180, 120, 20))
local BestPetsBtn = CreateMenuButton(4, "✨ En İyi Petleri Otomatik Tak (Best Equip)", Color3.fromRGB(100, 80, 160))
local InfEquipBtn = CreateMenuButton(5, "🐾 Sınırsız Pet Takma Limiti (Inf Equip): Kapalı", Color3.fromRGB(100, 80, 160))
local AutoOrbBtn = CreateMenuButton(6, "✨ Etraftaki Orb/Coin'lere Otomatik Tıkla: Kapalı", Color3.fromRGB(50, 50, 65))
local AutoMagnetBtn = CreateMenuButton(7, "🧲 Düşen Orb/Coin'leri Kendine Çek: Kapalı", Color3.fromRGB(50, 50, 65))

local AirWalkBtn = CreateMenuButton(8, "👟 Havada Yürüme (AirWalk): Kapalı", Color3.fromRGB(200, 50, 50))
local FlyBtn = CreateMenuButton(9, "🕊️ Uçma (Flight): Kapalı", Color3.fromRGB(50, 50, 65))
local BridgeBtn = CreateMenuButton(10, "🧱 Insta-Bridge (Altına Köprü Ör): Kapalı", Color3.fromRGB(50, 50, 65))
local NoclipBtn = CreateMenuButton(11, "👻 Noclip (Duvar Geçme): Kapalı", Color3.fromRGB(140, 50, 50))
local TouchTpBtn = CreateMenuButton(12, "⚡ Dokunduğun Yere TP: Kapalı", Color3.fromRGB(50, 50, 65))

-- Hız Ayar Satırı
local SpeedRow = Instance.new("Frame")
SpeedRow.LayoutOrder = 13
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
FlySpeedRow.LayoutOrder = 14
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

local TurboBtn = CreateMenuButton(15, "🔥 Turbo Hız (Sol Shift basılı tut): Kapalı", Color3.fromRGB(50, 50, 65))

---------------------------------------------------------------------
-- SİMÜLATÖR FONKSİYONLARI (UNIVERSAL X & GENEL)
---------------------------------------------------------------------

-- 1. Nerede Olursan Ol Otomatik Yumurta Aç
AutoHatchBtn.MouseButton1Click:Connect(function()
    autoHatchEnabled = not autoHatchEnabled
    AutoHatchBtn.Text = autoHatchEnabled and "🥚 Otomatik Yumurta: Açık" or "🥚 Her Yerde Otomatik Yumurta Aç: Kapalı"
    AutoHatchBtn.BackgroundColor3 = autoHatchEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(180, 100, 20)

    task.spawn(function()
        while autoHatchEnabled do
            task.wait(0.4)
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = string.lower(remote.Name)
                        if string.find(name, "hatch") or string.find(name, "egg") or string.find(name, "open") then
                            remote:FireServer("BuyEgg", 1)
                            remote:FireServer("OpenEgg", "Best")
                            remote:FireServer(1, "E")
                        end
                    end
                end
            end)
        end
    end)
end)

-- 2. En İyi Bölgeye Otomatik TP (Zone/World Taraması)
AutoTpZoneBtn.MouseButton1Click:Connect(function()
    autoTeleportZoneEnabled = not autoTeleportZoneEnabled
    AutoTpZoneBtn.Text = autoTeleportZoneEnabled and "🗺️ En İyi Bölgeye TP: Açık" or "🗺️ En İyi Bölgeye Otomatik TP: Kapalı"
    AutoTpZoneBtn.BackgroundColor3 = autoTeleportZoneEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(40, 140, 90)

    task.spawn(function()
        while autoTeleportZoneEnabled do
            task.wait(2)
            pcall(function()
                local bestTarget = nil
                local maxVal = -1
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = string.lower(obj.Name)
                        if string.find(name, "zone") or string.find(name, "area") or string.find(name, "world") or string.find(name, "island") then
                            local num = tonumber(string.match(obj.Name, "%d+"))
                            if num and num > maxVal then
                                maxVal = num
                                bestTarget = obj
                            end
                        end
                    end
                end
                if bestTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = bestTarget.CFrame + Vector3.new(0, 5, 0)
                end
            end)
        end
    end)
end)

-- 3. Sonraki Bölgeyi Otomatik Satın Al / Kilidini Aç
AutoBuyZoneBtn.MouseButton1Click:Connect(function()
    autoBuyZoneEnabled = not autoBuyZoneEnabled
    AutoBuyZoneBtn.Text = autoBuyZoneEnabled and "🛒 Bölge Satın Alma: Açık" or "🛒 Sonraki Bölgeyi / Kilidi Aç: Kapalı"
    AutoBuyZoneBtn.BackgroundColor3 = autoBuyZoneEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(180, 120, 20)

    task.spawn(function()
        while autoBuyZoneEnabled do
            task.wait(1)
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = string.lower(remote.Name)
                        if string.find(name, "buy") or string.find(name, "unlock") or string.find(name, "area") or string.find(name, "zone") then
                            remote:FireServer()
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. En İyi Petleri Otomatik Tak (Best Equip)
BestPetsBtn.MouseButton1Click:Connect(function()
    pcall(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if string.find(name, "best") or string.find(name, "equip") then
                    remote:FireServer("BestEquip")
                    remote:FireServer("EquipBest")
                    remote:FireServer(true)
                end
            end
        end
    end)
    BestPetsBtn.Text = "✨ En İyi Petler Takıldı!"
    task.wait(1.5)
    BestPetsBtn.Text = "✨ En İyi Petleri Otomatik Tak (Best Equip)"
end)

-- 5. Sınırsız Pet Takma Limiti (Inf Equip)
InfEquipBtn.MouseButton1Click:Connect(function()
    infEquipEnabled = not infEquipEnabled
    InfEquipBtn.Text = infEquipEnabled and "🐾 Inf Equip: Açık" or "🐾 Sınırsız Pet Takma Limiti (Inf Equip): Kapalı"
    InfEquipBtn.BackgroundColor3 = infEquipEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(100, 80, 160)

    task.spawn(function()
        while infEquipEnabled do
            task.wait(1)
            pcall(function()
                for _, obj in pairs(LocalPlayer:GetDescendants()) do
                    if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                        if string.find(string.lower(obj.Name), "equip") or string.find(string.lower(obj.Name), "pets") then
                            obj.Value = 999
                        end
                    end
                end
            end)
        end
    end)
end)

-- 6. Etraftaki Orb'lara Otomatik Tıklama
AutoOrbBtn.MouseButton1Click:Connect(function()
    autoClickOrbEnabled = not autoClickOrbEnabled
    AutoOrbBtn.Text = autoClickOrbEnabled and "✨ Auto Orb Tıklama: Açık" or "✨ Etraftaki Orb/Coin'lere Otomatik Tıkla: Kapalı"
    AutoOrbBtn.BackgroundColor3 = autoClickOrbEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(50, 50, 65)

    task.spawn(function()
        while autoClickOrbEnabled do
            task.wait(0.3)
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = string.lower(obj.Name)
                        if string.find(name, "orb") or string.find(name, "coin") or string.find(name, "gem") or string.find(name, "diamond") then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

-- 7. Kırılan Orb/Coin'leri Kendine Çekme (Mıknatıs)
AutoMagnetBtn.MouseButton1Click:Connect(function()
    autoMagnetEnabled = not autoMagnetEnabled
    AutoMagnetBtn.Text = autoMagnetEnabled and "🧲 Mıknatıs: Açık" or "🧲 Düşen Orb/Coin'leri Kendine Çek: Kapalı"
    AutoMagnetBtn.BackgroundColor3 = autoMagnetEnabled and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(50, 50, 65)

    task.spawn(function()
        while autoMagnetEnabled do
            task.wait(0.2)
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                    for _, item in pairs(Workspace:GetDescendants()) do
                        if item:IsA("BasePart") and not item.Anchored then
                            local name = string.lower(item.Name)
                            if string.find(name, "coin") or string.find(name, "gem") or string.find(name, "orb") or string.find(name, "drop") or string.find(name, "diamond") then
                                item.CFrame = rootPos
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

---------------------------------------------------------------------
-- TEMEL KONTROL FONKSİYONLARI (Hız, Uçuş, TP, vb.)
---------------------------------------------------------------------

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

TurboBtn.MouseButton1Click:Connect(function()
    turboEnabled = not turboEnabled
    TurboBtn.Text = turboEnabled and "🔥 Turbo Hız: Açık" or "🔥 Turbo Hız (Sol Shift basılı tut): Kapalı"
    TurboBtn.BackgroundColor3 = turboEnabled and Color3.fromRGB(220, 100, 30) or Color3.fromRGB(50, 50, 65)
end)

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
