-- Uçuş Kontrol Paneli (Temizlenmiş ve Modernize Edilmiş Sürüm)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Önceki menüyü temizle (Çakışmayı önler)
if PlayerGui:FindFirstChild("UcusArayuzGui") then
    PlayerGui.UcusArayuzGui:Destroy()
end

-- Değişkenler
local isFlying = false
local flySpeed = 50
local minSpeed = 10
local maxSpeed = 300
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

-- Ana Ekran Arayüzü (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UcusArayuzGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve (Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 190)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Başlık Çubuğu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Text = "Uçuş Kontrol Paneli"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Uçuş Başlat / Durdur Butonu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.85, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.075, 0, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 15
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Text = "Uçma: Kapalı (Başlat)"
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Hız Göstergesi Etiketi
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.85, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0.075, 0, 0, 105)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Uçma Hızı: " .. flySpeed
SpeedLabel.Parent = MainFrame

-- Hız Azaltma Butonu (-)
local DecreaseBtn = Instance.new("TextButton")
DecreaseBtn.Size = UDim2.new(0.4, 0, 0, 35)
DecreaseBtn.Position = UDim2.new(0.075, 0, 0, 135)
DecreaseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
DecreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseBtn.TextSize = 18
DecreaseBtn.Font = Enum.Font.GothamBold
DecreaseBtn.Text = "- 10"
DecreaseBtn.Parent = MainFrame

local DecCorner = Instance.new("UICorner")
DecCorner.CornerRadius = UDim.new(0, 8)
DecCorner.Parent = DecreaseBtn

-- Hız Artırma Butonu (+)
local IncreaseBtn = Instance.new("TextButton")
IncreaseBtn.Size = UDim2.new(0.4, 0, 0, 35)
IncreaseBtn.Position = UDim2.new(0.525, 0, 0, 135)
IncreaseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
IncreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseBtn.TextSize = 18
IncreaseBtn.Font = Enum.Font.GothamBold
IncreaseBtn.Text = "+ 10"
IncreaseBtn.Parent = MainFrame

local IncCorner = Instance.new("UICorner")
IncCorner.CornerRadius = UDim.new(0, 8)
IncCorner.Parent = IncreaseBtn

-- Uçuşu Durdurma Fonksiyonu
local function StopFlying()
    isFlying = false
    ToggleButton.Text = "Uçma: Kapalı (Başlat)"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

-- Uçuşu Başlatma Fonksiyonu
local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end

    isFlying = true
    ToggleButton.Text = "Uçma: Açık (Durdur)"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
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

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not LocalPlayer.Character or not rootPart.Parent then
            StopFlying()
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        -- Kontroller (W, A, S, D, Space, LeftControl)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        bodyVelocity.Velocity = moveDir * flySpeed
        bodyGyro.CFrame = cam.CFrame
    end)
end

-- Buton Etkileşimleri
ToggleButton.MouseButton1Click:Connect(function()
    if isFlying then
        StopFlying()
    else
        StartFlying()
    end
end)

DecreaseBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, minSpeed, maxSpeed)
    SpeedLabel.Text = "Uçma Hızı: " .. flySpeed
end)

IncreaseBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, minSpeed, maxSpeed)
    SpeedLabel.Text = "Uçma Hızı: " .. flySpeed
end)

-- Karakter yeniden doğduğunda (Respawn) uçuşu sıfırla
LocalPlayer.CharacterAdded:Connect(function()
    if isFlying then
        StopFlying()
    end
end)
