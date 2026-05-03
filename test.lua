--[[
    [destroyerr1558 Advanced Code Creator]
    Project: Moon Universe - Elite UI System 2035
    Theme: Neon Amethyst / Dark Mode
    Features: Draggable, Animated, X-Close, Responsive Toggles
]]--

-- UI Kütüphanesi (Fluent - En modern ve şık kütüphanedir)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Moon Universe VIP 🌙 [2035 Edition]",
    SubTitle = "by destroyerr1558",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Arka plan bulanıklığı (Glass effect)
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl -- Menüyü gizleme tuşu
})

-- // SEKMELER //
local Tabs = {
    Main = Window:AddTab({ Title = "Dashboard", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Ayarlar & X", Icon = "settings" })
}

local Options = Fluent.Options

-- // ANA ÖZELLİKLER //
Tabs.Main:AddParagraph({
    Title = "Hoş Geldin, " .. game.Players.LocalPlayer.Name,
    Content = "Moon evreninin en gelişmiş PS99 hilesini kullanıyorsun."
})

local MultiToggle = Tabs.Main:AddToggle("InfinitePets", {Title = "Sınırsız Pet Slotu (Visual)", Default = false })
local CollectToggle = Tabs.Main:AddToggle("AutoCollect", {Title = "Otomatik Orb Toplama", Default = false })
local FlightToggle = Tabs.Main:AddToggle("Flight", {Title = "Uçma Modu (Fly)", Default = false })

Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Yürüme Hızı",
    Description = "Karakter hızını ayarlar.",
    Default = 50,
    Min = 16,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- // LOGIC (KODUN ÇALIŞMA KISMI) //

-- Pet Slot Logic
MultiToggle:OnChanged(function()
    _G.InfPets = Options.InfinitePets.Value
    task.spawn(function()
        while _G.InfPets do
            pcall(function()
                local lib = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get()
                lib.MaxEquipped = 999
            end)
            task.wait(1)
        end
    end)
end)

-- Orb Collect Logic
CollectToggle:OnChanged(function()
    _G.CollectOrbs = Options.AutoCollect.Value
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
end)

-- Flight Logic
FlightToggle:OnChanged(function()
    _G.Flying = Options.Flight.Value
    local char = game.Players.LocalPlayer.Character
    if _G.Flying then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "MoonFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while _G.Flying do
                bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- // AYARLAR VE X BUTONU //
Tabs.Settings:AddButton({
    Title = "Menüyü Tamamen Kapat (X)",
    Description = "Scripti ve arayüzü yok eder.",
    Callback = function()
        Window:Destroy()
    end
})

Tabs.Settings:AddButton({
    Title = "Konfigürasyonu Kaydet",
    Callback = function()
        SaveManager:Save(Window.Id)
        Fluent:Notify({
            Title = "Sistem",
            Content = "Ayarlar başarıyla kaydedildi!",
            Duration = 5
        })
    end
})

-- Bildirim Gönder
Fluent:Notify({
    Title = "Moon Universe Aktif",
    Content = "Gelişmiş tasarım başarıyla yüklendi.",
    Duration = 8
})

Window:SelectTab(1)
