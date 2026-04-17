-- Modül: Jarvis Ana Kontrol Menüsü V3 (Üstün Sürüm)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local fare = oyuncu:GetMouse()

local playerGui = oyuncu:WaitForChild("PlayerGui")

-- Eski menüyü temizle
if playerGui:FindFirstChild("JarvisMenu") then
    playerGui.JarvisMenu:Destroy()
end

-- Ana Ekran
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

-- Sade ve Modern Arka Plan Çerçevesi (Boyutu uzattık)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 420) 
frame.Position = UDim2.new(0.8, 0, 0.4, -150) 
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
frame.BorderSizePixel = 0 
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Şık Bir Üst Çizgi (Vurgu)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 5)
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255) 
topBar.BorderSizePixel = 0
topBar.Parent = frame
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

-- Menü Başlığı
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "JARVIS V3 KONTROL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.Parent = frame

-- Butonları Otomatik Hizalayacak Alan (Modern UI Mantığı)
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -45)
buttonContainer.Position = UDim2.new(0, 0, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = buttonContainer
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8) -- Butonlar arası boşluk
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Buton Oluşturma Fonksiyonu
local function ButonOlustur(isim)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Text = isim .. ": KAPALI"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

-- Buton Görünüm Güncelleme
local function ButonGuncelle(btn, durum, isim)
    if durum then
        btn.Text = isim .. ": AÇIK"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = isim .. ": KAPALI"
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

---------------------------------------------------
-- PROTOKOLLER VE BUTON BAĞLANTILARI
---------------------------------------------------

-- 1. UÇUŞ
local btnFly = ButonOlustur("UÇUŞ (F)")
local ucan_mi = false
local iticiGuc = nil
btnFly.MouseButton1Click:Connect(function()
    ucan_mi = not ucan_mi
    ButonGuncelle(btnFly, ucan_mi, "UÇUŞ (F)")
    local kok = oyuncu.Character and oyuncu.Character:FindFirstChild("HumanoidRootPart")
    if ucan_mi and kok then
        iticiGuc = Instance.new("BodyVelocity")
        iticiGuc.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        iticiGuc.Velocity = Vector3.new(0, 0, 0)
        iticiGuc.Parent = kok
    else
        if iticiGuc then iticiGuc:Destroy() iticiGuc = nil end
    end
end)
RunService.RenderStepped:Connect(function()
    if ucan_mi and iticiGuc and oyuncu.Character and oyuncu.Character:FindFirstChild("Humanoid") then
        local hiz = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 1000 or 150
        if oyuncu.Character.Humanoid.MoveDirection.Magnitude > 0 then
            iticiGuc.Velocity = workspace.CurrentCamera.CFrame.LookVector * hiz
        else
            iticiGuc.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- 2. FLAŞ HIZI (KARADA)
local btnSpeed = ButonOlustur("FLAŞ HIZI")
local hiz_aktif = false
btnSpeed.MouseButton1Click:Connect(function()
    hiz_aktif = not hiz_aktif
    ButonGuncelle(btnSpeed, hiz_aktif, "FLAŞ HIZI")
    local humanoid = oyuncu.Character and oyuncu.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = hiz_aktif and 100 or 16
    end
end)

-- 3. SONSUZ ZIPLAMA
local btnJump = ButonOlustur("SONSUZ ZIPLAMA")
local ziplama_aktif = false
btnJump.MouseButton1Click:Connect(function()
    ziplama_aktif = not ziplama_aktif
    ButonGuncelle(btnJump, ziplama_aktif, "SONSUZ ZIPLAMA")
end)
UIS.JumpRequest:Connect(function()
    if ziplama_aktif and oyuncu.Character and oyuncu.Character:FindFirstChild("Humanoid") then
        oyuncu.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. KUANTUM SIÇRAMASI (CTRL + TIKLA IŞINLAN)
local btnClickTP = ButonOlustur("KUANTUM SIÇRAMASI")
local tp_aktif = false
btnClickTP.MouseButton1Click:Connect(function()
    tp_aktif = not tp_aktif
    ButonGuncelle(btnClickTP, tp_aktif, "KUANTUM SIÇRAMASI")
end)
fare.Button1Down:Connect(function()
    if tp_aktif and UIS:IsKeyDown(Enum.KeyCode.LeftControl) and fare.Target then
        local kok = oyuncu.Character and oyuncu.Character:FindFirstChild("HumanoidRootPart")
        if kok then
            -- Tıklanan yerin biraz üstüne ışınla (yere saplanmamak için)
            kok.CFrame = CFrame.new(fare.Hit.X, fare.Hit.Y + 5, fare.Hit.Z)
        end
    end
end)

-- 5. OTOMATİK TIKLAYICI (AUTO-CLICKER)
local btnClicker = ButonOlustur("OTOMATİK TIKLAMA")
local clicker_aktif = false
btnClicker.MouseButton1Click:Connect(function()
    clicker_aktif = not clicker_aktif
    ButonGuncelle(btnClicker, clicker_aktif, "OTOMATİK TIKLAMA")
end)
task.spawn(function()
    while true do
        if clicker_aktif then
            -- Fare sol tuşuna sanal basış gönder
            VirtualUser:ClickButton1(Vector2.new())
        end
        task.wait(0.05) -- Saniyede 20 kere tıklar
    end
end)

-- 6. ANTİ-AFK
local btnAfk = ButonOlustur("ANTİ-AFK")
local afk_aktif = false
local afk_baglantisi = nil
btnAfk.MouseButton1Click:Connect(function()
    afk_aktif = not afk_aktif
    ButonGuncelle(btnAfk, afk_aktif, "ANTİ-AFK")
    if afk_aktif then
        afk_baglantisi = oyuncu.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    else
        if afk_baglantisi then afk_baglantisi:Disconnect() afk_baglantisi = nil end
    end
end)

-- 7. ANTİ-LAG (FPS)
local btnLag = ButonOlustur("ANTİ-LAG (FPS)")
local lag_aktif = false
btnLag.MouseButton1Click:Connect(function()
    lag_aktif = not lag_aktif
    ButonGuncelle(btnLag, lag_aktif, "ANTİ-LAG (FPS)")
    if lag_aktif then
        Lighting.GlobalShadows = false
        for _, obje in pairs(workspace:GetDescendants()) do
            if obje:IsA("BasePart") then obje.Material = Enum.Material.SmoothPlastic obje.CastShadow = false
            elseif obje:IsA("Decal") or obje:IsA("Texture") then obje.Transparency = 1
            elseif obje:IsA("ParticleEmitter") or obje:IsA("Trail") then obje.Enabled = false end
        end
    end
end)

-- 8. GECE GÖRÜŞÜ
local btnIsik = ButonOlustur("GECE GÖRÜŞÜ")
local isik_aktif = false
btnIsik.MouseButton1Click:Connect(function()
    isik_aktif = not isik_aktif
    ButonGuncelle(btnIsik, isik_aktif, "GECE GÖRÜŞÜ")
    if isik_aktif then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000 
        Lighting.Brightness = 2
        Lighting.ClockTime = 14 
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
    end
end)

print("Jarvis V3 Tüm Sistemleri Çevrimiçi.")
