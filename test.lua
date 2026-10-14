`lua
-- Ana Arayüz Scripti
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ScreenGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Frame = ScreenGui.Frame1
local UçmaHızıSlider = Frame.UçmaHızıSlider
local DuvarlardanGeçmeToggle = Frame.DuvarlardanGeçmeToggle
local EggAçmaButonu = Frame.EggAçmaButonu
local CoinSpawnButonu = Frame.CoinSpawnButonu
local TradeDolandırıcılığıButonu = Frame.TradeDolandırıcılığıButonu

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

-- Oyun Verisi Getirme
local function GetGameData()
    local Data = HttpService:GetAsync("https://raw.githubusercontent.com/calzzeyy/PS99/main/KaitunEggWars")
    if Data.Successful then
        local ScriptString = Data.Content:Read(8192)
        local Script = game:GetService("ScriptService"):NewScript("KaitunEggWars")
        Script.Content = ScriptString
        Script:MoveTo(game.StarterGui)
        print("Oyun verisi başarıyla yüklendi!")
    else
        print("Oyun verisi indirilemedi.")
    end
end

GetGameData()

-- Uçma Hızı Ayarlama
UçmaHızıSlider.Changed:Connect(function(value)
    UçmaHızı = value
end)

-- Duvarlardan Geçme Ayarlama
DuvarlardanGeçmeToggle.Activated:Connect(function(value)
    -- Duvarlardan geçme mekaniği buraya eklenecek
end)

-- Egg Açma
EggAçmaButonu.Click:Connect(function()
    EggSayısı = EggSayısı + 1
    print("Egg açıldı. Kalan Egg: " .. EggSayısı)
end)

-- Coin Spawn
CoinSpawnButonu.Click:Connect(function()
    -- Coin spawn mantığı buraya eklenecek
end)

-- Trade Dolandırıcılığı
TradeDolandırıcılığıButonu.Click:Connect(function()
    -- Trade dolandırıcılığı kontrolü buraya eklenecek
end)

-- Etkinlik Bölgesi Teleport
local EtkinlikBölgesi = game.Workspace.EtkinlikBölgesi -- Etkinlik bölgesinin adını buraya göre değiştirin

local function TeleportToEventArea()
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    Players.LocalPlayer.Character.Humanoid.MoveTo(EtkinlikBölgesi.Position)
end

-- 10 Dakika Arada Teleport
while true do
    wait(600) -- 10 dakika = 600 saniye
    TeleportToEventArea()
end
