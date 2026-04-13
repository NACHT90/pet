-- Modül: Elmas Yağdırma Paneli
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Eski paneli temizle (Kodu tekrar tekrar test edebilmen için)
if playerGui:FindFirstChild("GemSpawnerMod") then
    playerGui.GemSpawnerMod:Destroy()
end

-- Ana Ekran (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GemSpawnerMod"
screenGui.Parent = playerGui

-- Sürüklenebilir Kontrol Paneli (Frame)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.5, -125, 0.5, -80) -- Ekranın ortası
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true -- Paneli mouse ile sağa sola çekebilirsin!
frame.Parent = screenGui

-- Başlık Yazısı
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "💎 Elmas Modu 💎"
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Sayı Girme Kutusu (TextBox)
local input = Instance.new("TextBox")
input.Size = UDim2.new(0.8, 0, 0, 40)
input.Position = UDim2.new(0.1, 0, 0.3, 0)
input.PlaceholderText = "Kaç elmas istiyorsun?"
input.Text = "10" -- Varsayılan sayı
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Font = Enum.Font.Gotham
input.ClearTextOnFocus = false
input.Parent = frame

-- Üretme Butonu (TextButton)
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "Elmasları Yağdır!"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.Parent = frame

-- Butona Tıklandığında Çalışacak Asıl Sistem
button.MouseButton1Click:Connect(function()
    -- Kutudaki yazıyı gerçek bir sayıya (matematiksel) çevir
    local amount = tonumber(input.Text)
    
    -- Eğer adam harf girdiyse işlemi durdur
    if not amount then
        input.Text = "Sayı girmelisin!"
        return 
    end
    
    -- Karakterin dünyadaki yerini bul
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Girdiğin sayı kadar (amount) çalışan bir döngü başlat
    for i = 1, amount do
        -- Yeni bir obje (Part) yarat
        local gem = Instance.new("Part")
        gem.Size = Vector3.new(1.5, 1.5, 1.5)
        gem.Material = Enum.Material.Neon -- Parlak neon efekti
        gem.Color = Color3.fromRGB(0, 255, 255) -- Elmas mavisi rengi
        gem.Shape = Enum.PartType.Block
        
        -- Karakterin kafasının üstünde, rastgele X ve Z koordinatlarında belirsin
        local randomX = math.random(-15, 15)
        local randomZ = math.random(-15, 15)
        gem.CFrame = rootPart.CFrame * CFrame.new(randomX, 20, randomZ)
        
        -- Doğal durması için rastgele açılarla döndür
        gem.Orientation = Vector3.new(math.random(0,360), math.random(0,360), math.random(0,360))
        
        -- Elması dünyaya (workspace) ekle ki görünür olsun
        gem.Parent = workspace
        
        -- Bilgisayar kasmasın diye her elmas arası çok küçük bir süre bekle
        task.wait(0.05)
    end
end)
