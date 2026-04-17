-- Modül: Jarvis Ana Kontrol Menüsü V5 (Fuzzer / Sızma Testi Sürümü)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local playerGui = oyuncu:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("JarvisMenu") then
    playerGui.JarvisMenu:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

-- Menü boyutunu Fuzzer araçları için biraz daha büyüttük
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 580) 
frame.Position = UDim2.new(0.8, 0, 0.3, -150) 
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
frame.BorderSizePixel = 0 
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 5)
topBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Fuzzer (Saldırı) sürümü için Kırmızı!
topBar.BorderSizePixel = 0
topBar.Parent = frame
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "JARVIS V5 [FUZZER]"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.Parent = frame

local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, 0, 1, -45)
buttonContainer.Position = UDim2.new(0, 0, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 4
buttonContainer.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = buttonContainer
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6) 
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Yardımcı Fonksiyonlar
local function ButonOlustur(isim, renk)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Text = isim
    btn.BackgroundColor3 = renk or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    return btn
end

local function ButonGuncelle(btn, durum, isim)
    if durum then
        btn.Text = isim .. ": AÇIK"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = isim .. ": KAPALI"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

---------------------------------------------------
-- TEMEL SİSTEMLER (Kısaltılmış)
---------------------------------------------------
local btnFly = ButonOlustur("UÇUŞ (F): KAPALI")
local ucan_mi = false local iticiGuc = nil
btnFly.MouseButton1Click:Connect(function()
    ucan_mi = not ucan_mi ButonGuncelle(btnFly, ucan_mi, "UÇUŞ (F)")
    local kok = oyuncu.Character and oyuncu.Character:FindFirstChild("HumanoidRootPart")
    if ucan_mi and kok then
        iticiGuc = Instance.new("BodyVelocity") iticiGuc.MaxForce = Vector3.new(math.huge, math.huge, math.huge) iticiGuc.Parent = kok
    else if iticiGuc then iticiGuc:Destroy() iticiGuc = nil end end
end)
RunService.RenderStepped:Connect(function()
    if ucan_mi and iticiGuc and oyuncu.Character and oyuncu.Character:FindFirstChild("Humanoid") then
        local hiz = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 1000 or 150
        if oyuncu.Character.Humanoid.MoveDirection.Magnitude > 0 then
            iticiGuc.Velocity = workspace.CurrentCamera.CFrame.LookVector * hiz
        else iticiGuc.Velocity = Vector3.new(0,0,0) end
    end
end)

local btnESP = ButonOlustur("OYUNCU GÖRÜŞÜ (ESP): KAPALI")
local esp_aktif = false
btnESP.MouseButton1Click:Connect(function()
    esp_aktif = not esp_aktif ButonGuncelle(btnESP, esp_aktif, "OYUNCU GÖRÜŞÜ")
    if esp_aktif then
        for _, o in pairs(game.Players:GetPlayers()) do
            if o ~= oyuncu and o.Character then
                local hl = Instance.new("Highlight") hl.Name="JarvisESP" hl.FillColor=Color3.fromRGB(255,0,50) hl.Parent=o.Character
            end
        end
    else
        for _, o in pairs(game.Players:GetPlayers()) do
            if o.Character and o.Character:FindFirstChild("JarvisESP") then o.Character.JarvisESP:Destroy() end
        end
    end
end)

-- Araya çizgi çekmek için boşluk
local ayrac = Instance.new("Frame") ayrac.Size = UDim2.new(0.9, 0, 0, 2) ayrac.BackgroundColor3 = Color3.fromRGB(100, 100, 100) ayrac.Parent = buttonContainer

---------------------------------------------------
-- 🔴 JARVIS FUZZER (AĞ DENETÇİSİ) 🔴
---------------------------------------------------
local fuzzerBaslik = Instance.new("TextLabel")
fuzzerBaslik.Size = UDim2.new(0.9, 0, 0, 20)
fuzzerBaslik.BackgroundTransparency = 1
fuzzerBaslik.Text = "AĞ SIZMA TESTİ (FUZZER)"
fuzzerBaslik.TextColor3 = Color3.fromRGB(255, 50, 50)
fuzzerBaslik.Font = Enum.Font.GothamBold
fuzzerBaslik.TextSize = 12
fuzzerBaslik.Parent = buttonContainer

-- Hedef RemoteEvent'in adını gireceğimiz kutu
local txtRemoteAd = Instance.new("TextBox")
txtRemoteAd.Size = UDim2.new(0.9, 0, 0, 35)
txtRemoteAd.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
txtRemoteAd.TextColor3 = Color3.fromRGB(0, 255, 255)
txtRemoteAd.PlaceholderText = "Hedef RemoteEvent Adını Gir..."
txtRemoteAd.Font = Enum.Font.Code
txtRemoteAd.TextSize = 12
txtRemoteAd.Parent = buttonContainer
local txtCorner = Instance.new("UICorner") txtCorner.CornerRadius = UDim.new(0, 4) txtCorner.Parent = txtRemoteAd

-- Hedef Bulucu Fonksiyon
local function HedefBul()
    local hedefAd = txtRemoteAd.Text
    local bulundu = nil
    -- Genellikle RemoteEvent'ler ReplicatedStorage içinde tutulur
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") and obje.Name == hedefAd then
            bulundu = obje
            break
        end
    end
    return bulundu
end

-- SALDIRI 1: NEGATİF VE BÜYÜK DEĞER SALDIRISI
local btnNegatif = ButonOlustur("[TEST 1] NEGATİF DEĞER GÖNDER", Color3.fromRGB(150, 80, 0))
btnNegatif.MouseButton1Click:Connect(function()
    local hedef = HedefBul()
    if hedef then
        print("Jarvis: Negatif ve sonsuz değerler " .. hedef.Name .. " köprüsüne gönderiliyor!")
        hedef:FireServer(-99999999) -- Eksi bakiye sömürüsü
        hedef:FireServer(math.huge) -- Sonsuz sayı (Oyun motorunu çökertmeyi dener)
    else
        warn("Jarvis: Hedef RemoteEvent bulunamadı!")
    end
end)

-- SALDIRI 2: KİRLİ VERİ (TİP UYUŞMAZLIĞI) SALDIRISI
local btnKirli = ButonOlustur("[TEST 2] KİRLİ VERİ GÖNDER", Color3.fromRGB(150, 80, 0))
btnKirli.MouseButton1Click:Connect(function()
    local hedef = HedefBul()
    if hedef then
        print("Jarvis: Sunucunun kafa karışıklığı test ediliyor...")
        -- Sunucu sayı beklerken biz yazı, obje veya nil (boşluk) gönderiyoruz
        hedef:FireServer("ZEHİRLİ_VERİ_123")
        hedef:FireServer(nil)
        hedef:FireServer(workspace) 
    else
        warn("Jarvis: Hedef RemoteEvent bulunamadı!")
    end
end)

-- SALDIRI 3: DDoS SPAM SALDIRISI (Yarış Durumu / Dupe Testi)
local btnSpam = ButonOlustur("[TEST 3] DDoS SPAM (AÇIK/KAPALI)", Color3.fromRGB(150, 30, 30))
local spam_aktif = false

btnSpam.MouseButton1Click:Connect(function()
    spam_aktif = not spam_aktif
    local hedef = HedefBul()
    
    if spam_aktif and hedef then
        btnSpam.Text = "[TEST 3] DDoS SPAM: AKTİF!"
        btnSpam.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("Jarvis: Sunucuya saniyede 1000 sinyal gönderiliyor. Yükleniliyor...")
        
        task.spawn(function()
            while spam_aktif do
                hedef:FireServer(1) -- Sürekli 1 birimlik komut yolla
                task.wait() -- Milisaniyelik bekleme
            end
        end)
    else
        spam_aktif = false
        btnSpam.Text = "[TEST 3] DDoS SPAM (AÇIK/KAPALI)"
        btnSpam.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        print("Jarvis: Spam saldırısı durduruldu.")
    end
end)

print("Jarvis V5 Fuzzer Aktif. Sızma testine hazırız efendim.")
