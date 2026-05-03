--[[
    [destroyerr1558 Advanced Code Creator]
    Project: Moon Universe - PS99 Hardcoded UI
    Status: Absolute Stability (No External Links)
    Features: Draggable, Toggle System, Speed, Fly, X Button
]]--

-- Mevcut menü varsa sil (Üst üste binmemesi için)
local oldUI = game.CoreGui:FindFirstChild("MoonUniverseVIP")
if oldUI then oldUI:Destroy() end

-- // ANA GUI OLUŞTURMA //
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "MoonUniverseVIP"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Ana Panel Tasarımı
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true -- Paneli sürükleyebilirsin

-- Başlık Çubuğu
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 40)

TitleLabel.Parent = TitleBar
TitleLabel.Text = " 🌙 MOON UNIVERSE VIP [2035]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- X Butonu (Kapatma)
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- İçerik Alanı
Container.Parent = MainFrame
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 10)

-- // FONKSİYON OLUŞTURUCULAR //
local function CreateToggle(text, callback)
    local Button = Instance.new("TextButton")
    local state = false
    
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text .. " : OFF"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Container
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = text .. (state and " : ON" or " : OFF")
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

-- // HİLELERİ EKLE //

-- 1. Infinite Pets
CreateToggle("Sınırsız Pet Slotu", function(v)
    _G.InfPets = v
    task.spawn(function()
        while _G.InfPets do
            pcall(function()
                local save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get()
                save.MaxEquipped = 999
            end)
            task.wait(1)
        end
    end)
end)

-- 2. Auto Orb
CreateToggle("Otomatik Orb Toplama", function(v)
    _G.CollectOrbs = v
    task.spawn(function()
        while _G.CollectOrbs do
            pcall(function()
                for _, orb in pairs(game:GetService("Workspace").Scene.Orbs:GetChildren()) do
                    orb.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- 3. Flight
CreateToggle("Uçma Modu (Fly)", function(v)
    _G.Flying = v
    local char = game.Players.LocalPlayer.Character
    if _G.Flying then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "MoonFly"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Flying do
                bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    else
        if char.HumanoidRootPart:FindFirstChild("MoonFly") then
            char.HumanoidRootPart.MoonFly:Destroy()
        end
    end
end)

-- 4. Speed
CreateToggle("Süper Hız (250)", function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 250 or 16
end)

print("[destroyerr1558 Advanced Code Creator] UI Başarıyla Oluşturuldu!")
