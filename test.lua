-- Modül: Jarvis Ana Kontrol Menüsü V13 (Nihai Sniffer + Payload Enjektörü)
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
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame") 
topBar.Size = UDim2.new(1, 0, 0, 5) 
topBar.BackgroundColor3 = Color3.fromRGB(150, 0, 255) 
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "JARVIS V13 [OMNISCIENT]"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
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

local function KutuOlustur(isim)
    local txt = Instance.new("TextBox") txt.Size = UDim2.new(0.9, 0, 0, 32) txt.BackgroundColor3 = Color3.fromRGB(25, 25, 30) txt.TextColor3 = Color3.fromRGB(0, 255, 150) txt.PlaceholderText = isim txt.Text = "" txt.Font = Enum.Font.Code txt.TextSize = 11 txt.ClearTextOnFocus = false txt.Parent = buttonContainer
    Instance.new("UICorner", txt).CornerRadius = UDim.new(0, 4) return txt
end

---------------------------------------------------
-- 🕵️‍♂️ 1. AŞAMA: CASUS AĞI (PACKET SNIFFER)
---------------------------------------------------
local lblSniffer = Instance.new("TextLabel") lblSniffer.Size = UDim2.new(0.9, 0, 0, 20) lblSniffer.BackgroundTransparency = 1 lblSniffer.Text = "📡 CASUS AĞI (SNIFFER)" lblSniffer.TextColor3 = Color3.fromRGB(150, 0, 255) lblSniffer.Font = Enum.Font.GothamBold lblSniffer.TextSize = 11 lblSniffer.Parent = buttonContainer

local txtSnifferLog = Instance.new("TextLabel")
txtSnifferLog.Size = UDim2.new(0.9, 0, 0, 90)
txtSnifferLog.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
txtSnifferLog.TextColor3 = Color3.fromRGB(200, 200, 200)
txtSnifferLog.Text = "Dinleme Kapalı.\nBaşlatmak için butona basın."
txtSnifferLog.Font = Enum.Font.Code
txtSnifferLog.TextSize = 10
txtSnifferLog.TextWrapped = true
txtSnifferLog.TextXAlignment = Enum.TextXAlignment.Left
txtSnifferLog.TextYAlignment = Enum.TextYAlignment.Top
txtSnifferLog.Parent = buttonContainer
Instance.new("UICorner", txtSnifferLog).CornerRadius = UDim.new(0, 4)

local isSniffing = false
local btnSniffer = ButonOlustur("AĞI DİNLEMEYİ BAŞLAT", Color3.fromRGB(50, 0, 100))

-- Hooking İşlemi (Çekirdeğe Kanca Atma)
if hookmetamethod then
    local OldNameCall
    OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        -- Eğer dinleme açıksa, oyunun kendisi (checkcaller false) paket yolluyorsa ve bu bir RemoteEvent ise
        if isSniffing and not checkcaller() and method == "FireServer" and self:IsA("RemoteEvent") then
            local args = {...}
            local logMetni = "🎯 HEDEF: " .. self.Name .. "\n"
            for i, v in ipairs(args) do
                logMetni = logMetni .. "P" .. i .. ": " .. tostring(v) .. " (" .. type(v) .. ")\n"
            end
            -- Ekrana yazdır
            txtSnifferLog.TextColor3 = Color3.fromRGB(0, 255, 100)
            txtSnifferLog.Text = logMetni
        end
        return OldNameCall(self, ...)
    end)
else
    txtSnifferLog.Text = "HATA: Executor'ınız 'hookmetamethod' desteklemiyor! Sniffer çalışamaz."
    txtSnifferLog.TextColor3 = Color3.fromRGB(255, 0, 0)
end

btnSniffer.MouseButton1Click:Connect(function()
    isSniffing = not isSniffing
    if isSniffing then
        btnSniffer.Text = "DİNLENİYOR... (DURDURMAK İÇİN BAS)"
        btnSniffer.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        txtSnifferLog.Text = "Paketler bekleniyor...\nOyunda bir eylem gerçekleştirin."
        txtSnifferLog.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        btnSniffer.Text = "AĞI DİNLEMEYİ BAŞLAT"
        btnSniffer.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    end
end)

Instance.new("Frame", buttonContainer).Size = UDim2.new(0.9, 0, 0, 2)

---------------------------------------------------
-- 🎯 2. AŞAMA: SAHTE VERİ (PAYLOAD) ÜRETİCİ
---------------------------------------------------
local lblPayload = Instance.new("TextLabel") lblPayload.Size = UDim2.new(0.9, 0, 0, 20) lblPayload.BackgroundTransparency = 1 lblPayload.Text = "SAHTE PAKET ENJEKTÖRÜ" lblPayload.TextColor3 = Color3.fromRGB(0, 210, 255) lblPayload.Font = Enum.Font.GothamBold lblPayload.TextSize = 11 lblPayload.Parent = buttonContainer

local txtHedef = KutuOlustur("Hedef Remote İsmi (Yukarıdan Kopyala)")
txtHedef.TextColor3 = Color3.fromRGB(255, 100, 100)

local txtArg1 = KutuOlustur("Parametre 1 (P1)")
local txtArg2 = KutuOlustur("Parametre 2 (P2)")
local txtArg3 = KutuOlustur("Parametre 3 (P3)")

local function VeriCevir(veri)
    if veri == "" or veri == "nil" then return nil end
    if veri == "math.huge" then return math.huge end
    if tonumber(veri) then return tonumber(veri) end 
    if veri:lower() == "true" then return true end
    if veri:lower() == "false" then return false end
    return veri 
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

print("Jarvis V13: Casus Ağı ve Enjektör Çevrimiçi.")
