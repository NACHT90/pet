--[[
    [destroyerr1558 Advanced Code Creator]
    Project: Moon Universe - Pet Simulator 99 VIP
    Version: 2035.1 (Optimized for NACHT90 GitHub)
]]--

-- UI Kütüphanesini Yükle (Daha stabil bir sürüm)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Pencere Oluşturma
local Window = OrionLib:MakeWindow({
    Name = "🌙 Moon Universe | PS99 Advanced Creator", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "MoonConfig",
    IntroText = "destroyerr1558 Başlatılıyor..."
})

-- // Değişkenler //
_G.AutoFarm = false
_G.InfPets = false
_G.CollectOrbs = false
local WalkSpeed = 50

-- // ANA MENÜ TAB //
local MainTab = Window:MakeTab({
    Name = "Ana Hileler",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Tümünü Aktif Et (Ultra Mode)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        _G.InfPets = Value
        _G.CollectOrbs = Value
        OrionLib:MakeNotification({
            Name = "Moon System",
            Content = "Tüm özellikler " .. (Value and "AÇILDI" or "KAPATILDI"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MainTab:AddToggle({
    Name = "Sınırsız Pet Takma (Visual Bypass)",
    Default = false,
    Callback = function(Value)
        _G.InfPets = Value
        task.spawn(function()
            while _G.InfPets do
                pcall(function()
                    local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get()
                    Save.MaxEquipped = 999
                end)
                task.wait(1)
            end
        end)
    end
})

MainTab:AddToggle({
    Name = "Otomatik Orb Toplama",
    Default = false,
    Callback = function(Value)
        _G.CollectOrbs = Value
        task.spawn(function()
            while _G.CollectOrbs do
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace").Scene.Orbs:GetChildren()) do
                        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- // HAREKET TAB //
local MoveTab = Window:MakeTab({
    Name = "Hız & Uçma",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MoveTab:AddSlider({
    Name = "Yürüme Hızı",
    Min = 16,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 136),
    Increment = 1,
    ValueName = "Hız",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- // KAPATMA VE AYARLAR //
local ExitTab = Window:MakeTab({
    Name = "Kapat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ExitTab:AddButton({
    Name = "❌ MENÜYÜ İMHA ET (X)",
    Callback = function()
        OrionLib:Destroy() -- GUI'yi tamamen siler
    end    
})

-- Başlatma Bildirimi
OrionLib:Init()
print("[destroyerr1558] Gelişmiş kod yüklendi. Moon evrenine hoş geldin!")
