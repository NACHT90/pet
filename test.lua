-- Modül: Jarvis Ana Kontrol Menüsü V8 (Kitle Saldırısı / Carpet Bombing)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisMenu") then playerGui.JarvisMenu:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 720)  -- Yeni buton için ekranı son kez uzattık
frame.Position = UDim2.new(0.8, 0, 0.3, -150) 
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame") topBar.Size = UDim2.new(1, 0, 0, 5) topBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "JARVIS V8 [DOOMSDAY]"
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
local lblTarayici = Instance.new("TextLabel") lblTarayici.Size = UDim2.new(0.9, 0, 0, 20) lblTarayici.BackgroundTransparency = 1 lblTarayici.Text = "HEDEF BULUCU RADAR" lblTarayici.TextColor3 = Color3.fromRGB(255, 150, 0) lblTarayici.Font = Enum.Font.GothamBold lblTarayici.TextSize = 12 lblTarayici.Parent = buttonContainer
local txtHedef = Instance.new("TextBox") txtHedef.Size = UDim2.new(0.9, 0, 0, 30) txtHedef.BackgroundColor3 = Color3.fromRGB(10, 10, 10) txtHedef.TextColor3 = Color3.fromRGB(0, 255, 255) txtHedef.Text = "Hedef Bekleniyor..." txtHedef.Font = Enum.Font.Code txtHedef.TextSize = 11 txtHedef.TextEditable = false txtHedef.Parent = buttonContainer
local frameTarama = Instance.new("ScrollingFrame") frameTarama.Size = UDim2.new(0.9, 0, 0, 100) frameTarama.BackgroundColor3 = Color3.fromRGB(15, 15, 15) frameTarama.ScrollBarThickness = 3 frameTarama.Parent = buttonContainer
local taramaLayout = Instance.new("UIListLayout") taramaLayout.Parent = frameTarama

local secilenHedefObjesi = nil
local btnTara = ButonOlustur("🔍 AĞI TARA VE BUL", Color3.fromRGB(0, 100, 150))
btnTara.MouseButton1Click:Connect(function()
    for _, child in pairs(frameTarama:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    local bulunan = 0
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") then
            bulunan = bulunan + 1
            local btnRemote = Instance.new("TextButton") btnRemote.Size = UDim2.new(1, 0, 0, 25) btnRemote.Text = "🎯 " .. obje.Name btnRemote.BackgroundColor3 = Color3.fromRGB(30, 30, 30) btnRemote.TextColor3 = Color3.fromRGB(200, 200, 200) btnRemote.Font = Enum.Font.Code btnRemote.TextSize = 10 btnRemote.Parent = frameTarama
            btnRemote.MouseButton1Click:Connect(function() secilenHedefObjesi = obje txtHedef.Text = obje.Name txtHedef.TextColor3 = Color3.fromRGB(0, 255, 0) end)
        end
    end
    frameTarama.CanvasSize = UDim2.new(0, 0, 0, bulunan * 25) btnTara.Text = bulunan .. " Köprü Bulundu (Listeden Seç)"
end)

Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)

-- 2. AŞAMA: TEKLİ SALDIRILAR
local btnNegatif = ButonOlustur("[TEST 1] NEGATİF GÖNDER", Color3.fromRGB(150, 80, 0))
btnNegatif.MouseButton1Click:Connect(function() if secilenHedefObjesi then secilenHedefObjesi:FireServer(-99999999) secilenHedefObjesi:FireServer(math.huge) end end)

local btnKirli = ButonOlustur("[TEST 2] KİRLİ VERİ GÖNDER", Color3.fromRGB(150, 80, 0))
btnKirli.MouseButton1Click:Connect(function() if secilenHedefObjesi then secilenHedefObjesi:FireServer("ZEHİRLİ") secilenHedefObjesi:FireServer(nil) end end)

local btnSpam = ButonOlustur("[TEST 3] DDoS SPAM", Color3.fromRGB(150, 30, 30))
local spam_aktif = false
btnSpam.MouseButton1Click:Connect(function()
    spam_aktif = not spam_aktif
    if spam_aktif and secilenHedefObjesi then
        btnSpam.Text = "SPAM: AKTİF!" btnSpam.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.spawn(function() while spam_aktif do secilenHedefObjesi:FireServer(1) task.wait() end end)
    else spam_aktif = false btnSpam.Text = "[TEST 3] DDoS SPAM" btnSpam.BackgroundColor3 = Color3.fromRGB(150, 30, 30) end
end)

Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)

---------------------------------------------------
-- ☢️ 4. AŞAMA: HALI BOMBARDIMANI (KİTLE SALDIRISI) ☢️
---------------------------------------------------
local btnDoomsday = ButonOlustur("💥 [TEST 4] TÜMÜNE AYNI ANDA SALDIR", Color3.fromRGB(150, 0, 0))

btnDoomsday.MouseButton1Click:Connect(function()
    print("Jarvis: HALI BOMBARDIMANI BAŞLADI! 328+ Köprü aynı anda vuruluyor...")
    btnDoomsday.Text = "BOMBARDIMAN DEVREDE! LÜTFEN BEKLEYİN..."
    btnDoomsday.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local tumKopruler = {}
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") then
            table.insert(tumKopruler, obje)
        end
    end
    
    task.spawn(function()
        for _, hedef in pairs(tumKopruler) do
            -- Oyun çökmesin diye hataları yoksayan güvenli çağrı (pcall) kullanıyoruz
            pcall(function()
                hedef:FireServer(-99999999) -- Negatif saldırı
                hedef:FireServer("JARVIS_ZEHİRLİ_VERİ") -- Tip uyuşmazlığı saldırısı
                hedef:FireServer(math.huge) -- Sonsuz sayı saldırısı
            end)
            task.wait(0.01) -- İstemcinin çökmemesi için mikrosaniyelik mola
        end
        print("Jarvis: Tüm köprülere saldırı tamamlandı.")
        btnDoomsday.Text = "💥 [TEST 4] TÜMÜNE AYNI ANDA SALDIR"
        btnDoomsday.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end)
end)

Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)

---------------------------------------------------
-- 🟢 5. AŞAMA: CANLI GÖZLEMCİ (OBSERVER) 🟢
---------------------------------------------------
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

print("Jarvis Doomsday Protokolü Devrede.")
