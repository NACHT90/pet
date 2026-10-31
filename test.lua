-- Gelişmiş Uçuş & Eğlence Kontrol Paneli (Dokunmatik/Tıklama TP + Turbo + Noclip)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki menüyü temizle
if PlayerGui:FindFirstChild("SuperKontrolGui") then
    PlayerGui.SuperKontrolGui:Destroy()
end

-- Değişkenler
local isFlying = false
local flySpeed = 50
local turboMultiplier = 3
local minSpeed = 10
local maxSpeed = 300

local autoNoclip = true
local infJumpEnabled = false
local magnetEnabled = false
local touchTpEnabled = false -- Dokunduğun yere TP durumu

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
MainFrame.Size = UDim2.new(0, 300, 0, 435)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -217)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Text = "Süper Kontrol Paneli"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Yardımcı Buton Oluşturma Fonksiyonu
local function CreateButton(name, text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.88, 0, 0, 36)
    btn.Position = UDim2.new(0.06, 0, 0, posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 62)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- 1. Uçuş ve Noclip Butonları
local ToggleFlyBtn = CreateButton("ToggleFlyBtn", "Uçma: Kapalı (Başlat)", 50, Color3.fromRGB(200, 50, 50))
local NoclipBtn = CreateButton("NoclipBtn", "Oto-Noclip (Duvar Geçme): Açık", 95, Color3.fromRGB(40, 140, 90))

-- 2. Hız Göstergesi ve Ayar Butonları
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.88, 0, 0, 22)
SpeedLabel.Position = UDim2.new(0.06, 0, 0, 138)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Normal Hız: " .. flySpeed .. " | Turbo (Shift): " .. (flySpeed * turboMultiplier)
SpeedLabel.Parent = MainFrame

local DecreaseBtn = Instance.new("TextButton")
DecreaseBtn.Size = UDim2.new(0.42, 0, 0, 32)
DecreaseBtn.Position = UDim2.new(0.06, 0, 0, 165)
DecreaseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
DecreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseBtn.TextSize = 16
DecreaseBtn.Font = Enum.Font.GothamBold
DecreaseBtn.Text = "- 10"
DecreaseBtn.Parent = MainFrame
Instance.new("UICorner", DecreaseBtn).CornerRadius = UDim.new(0, 8)

local IncreaseBtn = Instance.new("TextButton")
IncreaseBtn.Size = UDim2.new(0.42, 0, 0, 32)
IncreaseBtn.Position = UDim2.new(0.52, 0, 0, 165)
IncreaseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
IncreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseBtn.TextSize = 16
IncreaseBtn.Font = Enum.Font.GothamBold
IncreaseBtn.Text = "+ 10"
IncreaseBtn.Parent = MainFrame
Instance.new("UICorner", IncreaseBtn).CornerRadius = UDim.new(0
