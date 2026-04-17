-- Modül: Jarvis Ana Kontrol Menüsü V9 (Keskin Nişancı & Pano Kopyalayıcı)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisMenu") then playerGui.JarvisMenu:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 680) 
frame.Position = UDim2.new(0.8, 0, 0.3, -150) 
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame") topBar.Size = UDim2.new(1, 0, 0, 5) topBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100) topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "JARVIS V9 [SNIPER]"
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

local listLayout = Instance.new("UIListLayout") listLayout.Parent = buttonContainer listLayout.SortOrder = Enum.SortOrder.LayoutOrder listLayout.Padding = UDim.new(0, 6) listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function ButonOlustur(isim, renk)
    local btn = Instance.new("TextButton") btn.Size = UDim2.new(0.9, 0, 0, 32) btn.Text = isim btn.BackgroundColor3 = renk or Color3.fromRGB(40, 40, 40) btn.TextColor3 = Color3.fromRGB(200, 200, 200) btn.Font = Enum.Font.GothamSemibold btn.TextSize = 11 btn.BorderSizePixel = 0 btn.Parent = buttonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) return btn
end

-- 1. AŞAMA: AĞ TARAYICISI
local lblTarayici = Instance.new("TextLabel") lblTarayici.Size = UDim2.new(0.9, 0, 0, 20) lblTarayici.BackgroundTransparency = 1 lblTarayici.Text = "HEDEF BULUCU RADAR" lblTarayici.TextColor3 = Color3.fromRGB(0, 255, 100) lblTarayici.Font = Enum.Font.GothamBold lblTarayici.TextSize = 12 lblTarayici.Parent = buttonContainer
local txtHedef = Instance.new("TextBox") txtHedef.Size = UDim2.new(0.9, 0, 0, 30) txtHedef.BackgroundColor3 = Color3.fromRGB(10, 10, 10) txtHedef.TextColor3 = Color3.fromRGB(0, 255, 255) txtHedef.Text = "Hedef Bekleniyor..." txtHedef.Font = Enum.Font.Code txtHedef.TextSize = 11 txtHedef.TextEditable = false txtHedef.Parent = buttonContainer

local secilenHedefObjesi = nil

-- YENİ BUTON: LİSTEYİ KOPYALA
local btnKopyala = ButonOlustur("📋 TÜM KÖPRÜLERİ KOPYALA", Color3.fromRGB(0, 100, 150))
btnKopyala.MouseButton1Click:Connect(function()
    btnKopyala.Text = "KOPYALANIYOR..."
    local liste = ""
    local bulunan = 0
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") then
            bulunan = bulunan + 1
            liste = liste .. obje.Name .. "\n"
        end
    end
    
    -- Exploit'in panoya kopyalama yeteneği (setclipboard) varsa kullan
    if setclipboard then
        setclipboard(liste)
        btnKopyala.Text = "KOPYALANDI! (CTRL+V YAPIN)"
        btnKopyala.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    else
        -- Eğer executor desteklemiyorsa F9 konsoluna yazdır
        warn("Jarvis Köprü Listesi:\n" .. liste)
        btnKopyala.Text = "F9 KONSOLUNA YAZDIRILDI!"
    end
    
    task.wait(3)
    btnKopyala.Text = "📋 TÜM KÖPRÜLERİ KOPYALA"
    btnKopyala.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
end)

Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)

-- 2. AŞAMA: SALDIRILAR (Eski menüler, hedefi buraya kodlayacağız)
local lblSaldiri = Instance.new("TextLabel") lblSaldiri.Size = UDim2.new(0.9, 0, 0, 20) lblSaldiri.BackgroundTransparency = 1 lblSaldiri.Text = "NOKTA ATIŞI SALDIRI" lblSaldiri.TextColor3 = Color3.fromRGB(255, 50, 50) lblSaldiri.Font = Enum.Font.GothamBold lblSaldiri.TextSize = 12 lblSaldiri.Parent = buttonContainer

local btnNegatif = ButonOlustur("[TEST 1] NEGATİF GÖNDER", Color3.fromRGB(150, 80, 0))
local btnKirli = ButonOlustur("[TEST 2] KİRLİ VERİ GÖNDER", Color3.fromRGB(150, 80, 0))
local btnSpam = ButonOlustur("[TEST 3] DDoS SPAM", Color3.fromRGB(150, 30, 30))

-- Canlı Gözlemci Modülü
Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)
local lblGozlem = Instance.new("TextLabel") lblGozlem.Size = UDim2.new(0.9, 0, 0, 20) lblGozlem.BackgroundTransparency = 1 lblGozlem.Text = "CÜZDAN CANLI DİNLEME" lblGozlem.TextColor3 = Color3.fromRGB(0, 255, 100) lblGozlem.Font = Enum.Font.GothamBold lblGozlem.TextSize = 12 lblGozlem.Parent = buttonContainer
local txtAnaliz = Instance.new("TextLabel") txtAnaliz.Size = UDim2.new(0.9, 0, 0, 60) txtAnaliz.BackgroundColor3 = Color3.fromRGB(10, 10, 10) txtAnaliz.TextColor3 = Color3.fromRGB(100, 100, 100) txtAnaliz.Text = "Saldırı başlatıldığında burayı izleyin." txtAnaliz.Font = Enum.Font.Code txtAnaliz.TextSize = 10 txtAnaliz.TextWrapped = true txtAnaliz.Parent = buttonContainer
Instance.new("UICorner", txtAnaliz).CornerRadius = UDim.new(0, 4)

if oyuncu:WaitForChild("leaderstats", 5) then
    for _, stat in pairs(oyuncu.leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            stat.Changed:Connect(function(yeniDeger)
                txtAnaliz.TextColor3 = Color3.fromRGB(0, 255, 0)
                txtAnaliz.Text = "⚠️ AÇIK BULUNDU! " .. stat.Name .. " değişti!\nYeni Değer: " .. tostring(yeniDeger)
                frame.BackgroundColor3 = Color3.fromRGB(20, 50, 20) task.wait(0.2) frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            end)
        end
    end
end

print("Jarvis V9: Keskin Nişancı Modu Devrede.")
