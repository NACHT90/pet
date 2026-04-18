-- Modül: Jarvis Ana Kontrol Menüsü V14 (Otomatik Veri Kaydedici ve Kopyalayıcı)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisMenu") then playerGui.JarvisMenu:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 780) 
frame.Position = UDim2.new(0.75, 0, 0.2, 0) 
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame") 
topBar.Size = UDim2.new(1, 0, 0, 5) 
topBar.BackgroundColor3 = Color3.fromRGB(255, 150, 0) 
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "JARVIS V14 [DATA HARVEST]"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.Parent = frame

local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, 0, 1, -45)
buttonContainer.Position = UDim2.new(0, 0, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 3
buttonContainer.Parent = frame

local listLayout = Instance.new("UIListLayout") 
listLayout.Parent = buttonContainer 
listLayout.SortOrder = Enum.SortOrder.LayoutOrder 
listLayout.Padding = UDim.new(0, 8) 
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function ButonOlustur(isim, renk)
    local btn = Instance.new("TextButton") btn.Size = UDim2.new(0.9, 0, 0, 35) btn.Text = isim btn.BackgroundColor3 = renk or Color3.fromRGB(35, 35, 40) btn.TextColor3 = Color3.fromRGB(220, 220, 220) btn.Font = Enum.Font.GothamSemibold btn.TextSize = 11 btn.BorderSizePixel = 0 btn.Parent = buttonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) return btn
end

---------------------------------------------------
-- 📦 1. AŞAMA: VERİ KAYDEDİCİ (KARA KUTU)
---------------------------------------------------
local lblSniffer = Instance.new("TextLabel") lblSniffer.Size = UDim2.new(0.9, 0, 0, 20) lblSniffer.BackgroundTransparency = 1 lblSniffer.Text = "📡 AĞ DİNLEME VE KAYIT" lblSniffer.TextColor3 = Color3.fromRGB(255, 150, 0) lblSniffer.Font = Enum.Font.GothamBold lblSniffer.TextSize = 11 lblSniffer.Parent = buttonContainer

local txtDurum = Instance.new("TextLabel")
txtDurum.Size = UDim2.new(0.9, 0, 0, 40)
txtDurum.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
txtDurum.TextColor3 = Color3.fromRGB(150, 150, 150)
txtDurum.Text = "Kayıtlı Paket: 0\nDinleme Kapalı."
txtDurum.Font = Enum.Font.GothamBold
txtDurum.TextSize = 11
txtDurum.Parent = buttonContainer
Instance.new("UICorner", txtDurum).CornerRadius = UDim.new(0, 4)

-- Verilerin tutulacağı RAM (Tablo)
local yakalananVeriler = {}
local isSniffing = false

local btnSniffer = ButonOlustur("AĞI DİNLEMEYİ BAŞLAT", Color3.fromRGB(0, 100, 50))

-- Çekirdek Kanca (Hook)
if hookmetamethod then
    local OldNameCall
    OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if isSniffing and not checkcaller() and method == "FireServer" and self:IsA("RemoteEvent") then
            local args = {...}
            
            -- Veriyi tabloya kaydet
            local paket = {
                Remote = self.Name,
                Zaman = os.date("%X"),
                Argumanlar = args
            }
            table.insert(yakalananVeriler, paket)
            
            -- Arayüzü güncelle
            txtDurum.TextColor3 = Color3.fromRGB(0, 255, 100)
            txtDurum.Text = "Kayıtlı Paket: " .. #yakalananVeriler .. "\nSon Hedef: " .. self.Name
        end
        return OldNameCall(self, ...)
    end)
else
    txtDurum.Text = "HATA: 'hookmetamethod' desteklenmiyor!"
    txtDurum.TextColor3 = Color3.fromRGB(255, 0, 0)
end

btnSniffer.MouseButton1Click:Connect(function()
    isSniffing = not isSniffing
    if isSniffing then
        btnSniffer.Text = "DİNLENİYOR VE KAYDEDİLİYOR..."
        btnSniffer.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        txtDurum.Text = "Kayıtlı Paket: " .. #yakalananVeriler .. "\nPaketler Bekleniyor..."
    else
        btnSniffer.Text = "AĞI DİNLEMEYİ BAŞLAT"
        btnSniffer.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    end
end)

local btnKopyala = ButonOlustur("📋 TÜM KAYITLARI KOPYALA", Color3.fromRGB(0, 120, 200))
btnKopyala.MouseButton1Click:Connect(function()
    if #yakalananVeriler == 0 then
        btnKopyala.Text = "KAYIT YOK!"
        task.wait(1)
        btnKopyala.Text = "📋 TÜM KAYITLARI KOPYALA"
        return
    end

    btnKopyala.Text = "HAZIRLANIYOR..."
    local döküm = "--- JARVIS V14 SIZMA TESTİ VERİ DÖKÜMÜ ---\n"
    for i, veri in ipairs(yakalananVeriler) do
        döküm = döküm .. "\n[" .. veri.Zaman .. "] HEDEF: " .. veri.Remote .. "\n"
        if #veri.Argumanlar == 0 then
            döküm = döküm .. "  [Parametre Yok - Sadece Tetikleyici]\n"
        else
            for j, arg in ipairs(veri.Argumanlar) do
                local tip = type(arg)
                local deger = tostring(arg)
                if tip == "string" then deger = '"' .. deger .. '"' end
                döküm = döküm .. "  P" .. j .. ": " .. deger .. " (" .. tip .. ")\n"
            end
        end
        döküm = döküm .. "----------------------------------------"
    end

    if setclipboard then
        setclipboard(döküm)
        btnKopyala.Text = "KOPYALANDI! (CTRL+V YAPIN)"
        btnKopyala.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        warn(döküm)
        btnKopyala.Text = "F9 KONSOLUNA YAZILDI!"
    end

    task.wait(2)
    btnKopyala.Text = "📋 TÜM KAYITLARI KOPYALA"
    btnKopyala.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
end)

local btnTemizle = ButonOlustur("🗑️ KAYITLARI TEMİZLE", Color3.fromRGB(100, 30, 30))
btnTemizle.MouseButton1Click:Connect(function()
    yakalananVeriler = {}
    txtDurum.Text = "Kayıtlı Paket: 0\nKayıtlar Silindi."
    txtDurum.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

---------------------------------------------------
-- 🎯 2. AŞAMA: SAHTE PAKET ENJEKTÖRÜ (Değişmedi)
---------------------------------------------------
Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)
local lblPayload = Instance.new("TextLabel") lblPayload.Size = UDim2.new(0.9, 0, 0, 20) lblPayload.BackgroundTransparency = 1 lblPayload.Text = "SAHTE PAKET ENJEKTÖRÜ" lblPayload.TextColor3 = Color3.fromRGB(0, 210, 255) lblPayload.Font = Enum.Font.GothamBold lblPayload.TextSize = 11 lblPayload.Parent = buttonContainer

local function KutuOlustur(isim)
    local txt = Instance.new("TextBox") txt.Size = UDim2.new(0.9, 0, 0, 32) txt.BackgroundColor3 = Color3.fromRGB(25, 25, 30) txt.TextColor3 = Color3.fromRGB(0, 255, 150) txt.PlaceholderText = isim txt.Text = "" txt.Font = Enum.Font.Code txt.TextSize = 11 txt.ClearTextOnFocus = false txt.Parent = buttonContainer
    Instance.new("UICorner", txt).CornerRadius = UDim.new(0, 4) return txt
end

local txtHedef = KutuOlustur("Hedef Remote İsmi")
txtHedef.TextColor3 = Color3.fromRGB(255, 100, 100)
local txtArg1 = KutuOlustur("Parametre 1")
local txtArg2 = KutuOlustur("Parametre 2")
local txtArg3 = KutuOlustur("Parametre 3")

local function VeriCevir(veri)
    if veri == "" or veri == "nil" then return nil end
    if veri == "math.huge" then return math.huge end
    if tonumber(veri) then return tonumber(veri) end 
    if veri:lower() == "true" then return true end
    if veri:lower() == "false" then return false end return veri 
end

local function GecerliHedef()
    local isim = txtHedef.Text
    for _, obje in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obje:IsA("RemoteEvent") and obje.Name == isim then return obje end
    end return nil
end

local btnAtesle = ButonOlustur("🎯 TEK ATIMLIK ENJEKTE ET", Color3.fromRGB(0, 120, 200))
btnAtesle.MouseButton1Click:Connect(function()
    local h = GecerliHedef()
    if h then h:FireServer(VeriCevir(txtArg1.Text), VeriCevir(txtArg2.Text), VeriCevir(txtArg3.Text)) end
end)

local btnSpam = ButonOlustur("💥 DUPE / SPAM SALDIRISI", Color3.fromRGB(180, 40, 40))
local spam_aktif = false
btnSpam.MouseButton1Click:Connect(function()
    spam_aktif = not spam_aktif
    local h = GecerliHedef()
    if spam_aktif and h then
        btnSpam.Text = "SPAM AKTİF! (DURDURMAK İÇİN BAS)" btnSpam.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
        local p1, p2, p3 = VeriCevir(txtArg1.Text), VeriCevir(txtArg2.Text), VeriCevir(txtArg3.Text)
        task.spawn(function() while spam_aktif do h:FireServer(p1, p2, p3) task.wait(0.01) end end)
    else spam_aktif = false btnSpam.Text = "💥 DUPE / SPAM SALDIRISI" btnSpam.BackgroundColor3 = Color3.fromRGB(180, 40, 40) end
end)

print("Jarvis V14: Veri Hasadı Modülü Aktif.")
