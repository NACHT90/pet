-- Ana Arayüz Scripti (Executor Uyumlu Tam Sürüm)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önce varsa eski menüyü temizle (Çakışmayı önler)
if PlayerGui:FindFirstChild("TestArayuzGui") then
    PlayerGui.TestArayuzGui:Destroy()
end

-- Otomatik Şık Bir Menü (UI) Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestArayuzGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame1 = Instance.new("Frame")
Frame1.Name = "Frame1"
Frame1.Size = UDim2.new(0, 280, 0, 340)
Frame1.Position = UDim2.new(0.5, -140, 0.5, -170)
Frame1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame1.BorderSizePixel = 0
Frame1.Active = true
Frame1.Draggable = true -- Fareyle ekranda sürüklenebilir!
Frame1.Parent = ScreenGui

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Pet & Farm Kontrol Paneli"
Title.Parent = Frame1

-- Fonksiyon: Şık Buton Oluşturucu
local function CreateButton(name, text, positionY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.Parent = Frame1
    return btn
end

-- Butonları Oluştur
local DuvarlardanGeçmeToggle = CreateButton("DuvarlardanGeçmeToggle", "Duvarlardan Geçme (Noclip): Kapalı", 55)
local EggAçmaButonu = CreateButton("EggAçmaButonu", "Egg Aç", 100)
local CoinSpawnButonu = CreateButton("CoinSpawnButonu", "Coin Spawn Tetikle", 145)
local TradeDolandırıcılığıButonu = CreateButton("TradeDolandırıcılığıButonu", "Trade İşlemi", 190)

-- Slider / Bilgi Alanı (Uçma Hızı)
local UçmaHızıLabel = Instance.new("TextLabel")
UçmaHızıLabel.Size = UDim2.new(0.9, 0, 0, 30)
UçmaHızıLabel.Position = UDim2.new(0.05, 0, 0, 235)
UçmaHızıLabel.BackgroundTransparency = 1
UçmaHızıLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UçmaHızıLabel.TextSize = 14
UçmaHızıLabel.Font = Enum.Font.SourceSans
UçmaHızıLabel.Text = "Uçma Hızı: 50"
UçmaHızıLabel.Parent = Frame1

-- Değişkenler
local EggSayısı = 10
local UçmaHızı = 50
local noclipEnabled = false

-- Duvarlardan Geçme (Noclip) Mekaniği
DuvarlardanGeçmeToggle.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        DuvarlardanGeçmeToggle.Text = "Duvarlardan Geçme (Noclip): Açık"
        DuvarlardanGeçmeToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        DuvarlardanGeçmeToggle.Text = "Duvarlardan Geçme (Noclip): Kapalı"
        DuvarlardanGeçmeToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Egg Açma
EggAçmaButonu.MouseButton1Click:Connect(function()
    EggSayısı = EggSayısı + 1
    print("Egg açıldı. Kalan Egg: " .. EggSayısı)
end)

-- Coin Spawn
CoinSpawnButonu.MouseButton1Click:Connect(function()
    print("Coin spawn tetiklendi!")
end)

-- Trade Dolandırıcılığı
TradeDolandırıcılığıButonu.MouseButton1Click:Connect(function()
    print("Trade kontrolü çalıştırıldı.")
end)

-- Etkinlik Bölgesi Teleport (10 Dakikada bir)
local function TeleportToEventArea()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
        local humanoid = character.Humanoid
        local rootPart = character.HumanoidRootPart
        
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 100
        
        local EtkinlikBölgesi = workspace:FindFirstChild("EtkinlikBölgesi")
        if EtkinlikBölgesi then
            rootPart.CFrame = EtkinlikBölgesi.CFrame
            print("Etkinlik bölgesine ışınlanıldı!")
        else
        	warn("Workspace içinde 'EtkinlikBölgesi' bulunamadı!")
        end
    end
end

task.spawn(function()
    while true do
        task.wait(600) -- 10 dakika = 600 saniye
        TeleportToEventArea()
    end
end)

print("Arayüz ve script başarıyla yüklendi!")
