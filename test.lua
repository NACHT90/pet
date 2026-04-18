-- Modül: Jarvis V16 [DIAMOND MATRIX] - Özel Elmas Sömürü Paneli
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Eski menü varsa temizle
local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisDiamondMenu") then playerGui.JarvisDiamondMenu:Destroy() end

-- Ana Arayüz (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisDiamondMenu"
screenGui.Parent = playerGui

-- Arka Plan Çerçevesi
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 280) 
frame.Position = UDim2.new(0.5, -150, 0.5, -140) 
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Üst Çizgi (Tema Rengi)
local topBar = Instance.new("Frame") 
topBar.Size = UDim2.new(1, 0, 0, 35) 
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255) 
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "💎 JARVIS V16 [DIAMOND MATRIX]"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Kapatma Butonu
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 35, 0, 35)
btnClose.Position = UDim2.new(1, -35, 0, 0)
btnClose.Text = "X"
btnClose.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
btnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
btnClose.Font = Enum.Font.GothamBold
btnClose.Parent = topBar
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 10)
btnClose.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Hedef Köprü Bulucu
local hedefKopru = ReplicatedStorage:FindFirstChild("DiamondParty_Claim", true)
local kopruDurumu = hedefKopru and "BAĞLANTI: BAŞARILI" or "BAĞLANTI: KÖPRÜ BULUNAMADI!"
local kopruRengi = hedefKopru and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)

-- Durum Paneli
local lblDurum = Instance.new("TextLabel")
lblDurum.Size = UDim2.new(0.9, 0, 0, 40)
lblDurum.Position = UDim2.new(0.05, 0, 0, 50)
lblDurum.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
lblDurum.Text = kopruDurumu .. "\nSİSTEM BEKLEMEDE."
lblDurum.TextColor3 = kopruRengi
lblDurum.Font = Enum.Font.Code
lblDurum.TextSize = 11
lblDurum.Parent = frame
Instance.new("UICorner", lblDurum).CornerRadius = UDim.new(0, 6)

-- Şifre Kutusu (Hash) - Önceden doldurulmuş
local txtHash = Instance.new("TextBox")
txtHash.Size = UDim2.new(0.9, 0, 0, 35)
txtHash.Position = UDim2.new(0.05, 0, 0, 100)
txtHash.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
txtHash.TextColor3 = Color3.fromRGB(200, 200, 200)
txtHash.Text = "6f23f3267891467ebaa644ebeaa2f352"
txtHash.Font = Enum.Font.Code
txtHash.TextSize = 10
txtHash.ClearTextOnFocus = false
txtHash.Parent = frame
Instance.new("UICorner", txtHash).CornerRadius = UDim.new(0, 6)

-- Animasyonlu Sayaç
local lblSayac = Instance.new("TextLabel")
lblSayac.Size = UDim2.new(0.9, 0, 0, 20)
lblSayac.Position = UDim2.new(0.05, 0, 0, 145)
lblSayac.BackgroundTransparency = 1
lblSayac.Text = "Gönderilen Paket: 0"
lblSayac.TextColor3 = Color3.fromRGB(150, 150, 150)
lblSayac.Font = Enum.Font.GothamSemibold
lblSayac.TextSize = 11
lblSayac.Parent = frame

-- Ateşleme Butonu
local btnAtes = Instance.new("TextButton")
btnAtes.Size = UDim2.new(0.9, 0, 0, 45)
btnAtes.Position = UDim2.new(0.05, 0, 0, 180)
btnAtes.Text = "🚀 SÖMÜRÜYÜ BAŞLAT"
btnAtes.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
btnAtes.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtes.Font = Enum.Font.GothamBlack
btnAtes.TextSize = 14
btnAtes.Parent = frame
Instance.new("UICorner", btnAtes).CornerRadius = UDim.new(0, 8)

-- Ana Sömürü Mantığı
local aktif = false
local gonderilen = 0

btnAtes.MouseButton1Click:Connect(function()
    if not hedefKopru then
        lblDurum.Text = "HATA: Elmas köprüsü (DiamondParty_Claim) bulunamadı!"
        return
    end

    aktif = not aktif
    if aktif then
        btnAtes.Text = "🛑 SÖMÜRÜYÜ DURDUR"
        btnAtes.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        lblDurum.Text = "DURUM: ELMASLAR ÇEKİLİYOR...\nSUNUCU MANİPÜLE EDİLİYOR."
        lblDurum.TextColor3 = Color3.fromRGB(0, 255, 255)
        
        -- Saldırı Döngüsü
        task.spawn(function()
            while aktif do
                local gecerliSifre = txtHash.Text
                hedefKopru:FireServer(gecerliSifre, nil)
                gonderilen = gonderilen + 1
                lblSayac.Text = "Gönderilen Paket (Dupe): " .. tostring(gonderilen)
                
                -- Sayaç Rengi Yanıp Sönme Efekti
                if gonderilen % 2 == 0 then
                    lblSayac.TextColor3 = Color3.fromRGB(0, 255, 100)
                else
                    lblSayac.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
                
                task.wait(0.01) -- Saniyede 100 Paket
            end
        end)
    else
        btnAtes.Text = "🚀 SÖMÜRÜYÜ BAŞLAT"
        btnAtes.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        lblDurum.Text = "DURUM: BEKLEMEDE\nOPERASYON DURDURULDU."
        lblDurum.TextColor3 = Color3.fromRGB(0, 255, 100)
        lblSayac.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

print("Jarvis V16 Matrix Paneli Hazır.")
