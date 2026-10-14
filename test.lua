-- Ana Arayüz Scripti
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Güvenli Frame Kontrolü (Eğer arayüz henüz yüklenmediyse hata vermez)
local Frame = PlayerGui:WaitForChild("Frame1", 5)
if not Frame then
    warn("Frame1 bulunamadı! Lütfen arayüzün yüklü olduğundan emin olun.")
    return
end

local UçmaHızıSlider = Frame:FindFirstChild("UçmaHızıSlider")
local DuvarlardanGeçmeToggle = Frame:FindFirstChild("DuvarlardanGeçmeToggle")
local EggAçmaButonu = Frame:FindFirstChild("EggAçmaButonu")
local CoinSpawnButonu = Frame:FindFirstChild("CoinSpawnButonu")
local TradeDolandırıcılığıButonu = Frame:FindFirstChild("TradeDolandırıcılığıButonu")

-- Oyun Verisi (Örnek)
local EggSayısı = 10
local CoinSpawnHızı = 60 -- Saniyede kaç kez coin spawn olsun
local UçmaHızı = 50 -- Başlangıç uçma hızı

-- Pet Verisi (Örnek)
local Pets = {
    "Kedi",
    "Köpek",
    "Tavşan"
}

-- Oyun Verisi Getirme (Executor'lar için game:HttpGet kullanarak harici script çalıştırma/çekme)
local function GetGameData()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/calzzeyy/PS99/main/KaitunEggWars")
    end)
    
    if success and response then
        print("Oyun verisi başarıyla indirildi!")
        -- İsteğe bağlı olarak çekilen kodu çalıştırmak için:
        -- loadstring(response)()
    else
        warn("Oyun verisi indirilemedi.")
    end
end

GetGameData()

-- Uçma Hızı Ayarlama (Slider yapısına göre 'Changed' veya 'GetPropertyChangedSignal' kullanılır)
if UçmaHızıSlider then
    UçmaHızıSlider.Changed:Connect(function(value)
        UçmaHızı = value
    end)
end

-- Duvarlardan Geçme Ayarlama
if DuvarlardanGeçmeToggle then
    DuvarlardanGeçmeToggle.Activated:Connect(function()
        -- Duvarlardan geçme mekaniği buraya eklenecek (Noclip)
    end)
end

-- Egg Açma
if EggAçmaButonu then
    EggAçmaButonu.Activated:Connect(function()
        EggSayısı = EggSayısı + 1
        print("Egg açıldı. Kalan Egg: " .. EggSayısı)
    end)
end

-- Coin Spawn
if CoinSpawnButonu then
    CoinSpawnButonu.Activated:Connect(function()
        -- Coin spawn mantığı buraya eklenecek
    end)
end

-- Trade Dolandırıcılığı
if TradeDolandırıcılığıButonu then
    TradeDolandırıcılığıButonu.Activated:Connect(function()
        -- Trade dolandırıcılığı kontrolü buraya eklenecek
    end)
end

-- Etkinlik Bölgesi Teleport
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
        end
    end
end

-- 10 Dakika Arada Teleport (Task kütüphanesi ile modern ve donmayan döngü)
task.spawn(function()
    while true do
        task.wait(600) -- 10 dakika = 600 saniye
        TeleportToEventArea()
    end
end)
