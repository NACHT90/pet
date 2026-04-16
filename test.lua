-- Modül: Jarvis Işınlanma ve Dikey Tırmanış Sistemi
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ucan_mi = false
local dikey_tirmanis_mi = false -- P tuşu için yeni mod
local temel_hiz = 150 
local turbo_hiz = 5000 -- Işınlanıyormuş hissi verecek devasa hız!
local guncel_hiz = temel_hiz
local iticiGuc = nil

-- Tuşlara basıldığında
UIS.InputBegan:Connect(function(tus, isleniyor)
    if isleniyor then return end 
    
    -- F Tuşu: Ana Motorları Aç/Kapat
    if tus.KeyCode == Enum.KeyCode.F then
        ucan_mi = not ucan_mi
        dikey_tirmanis_mi = false -- Kapatıp açınca asansör modunu sıfırla
        local karakter = oyuncu.Character
        local kok = karakter and karakter:FindFirstChild("HumanoidRootPart")

        if ucan_mi and kok then
            iticiGuc = Instance.new("BodyVelocity")
            iticiGuc.Name = "JarvisUcusMotoru"
            iticiGuc.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            iticiGuc.Velocity = Vector3.new(0, 0, 0)
            iticiGuc.Parent = kok
            print("Jarvis: Ana uçuş motorları devrede.")
        else
            if iticiGuc then 
                iticiGuc:Destroy() 
                iticiGuc = nil
            end
            print("Jarvis: Motorlar kapatıldı.")
        end
    end
    
    -- Sol Shift Tuşu: Işınlanma (Turbo) Modunu Aç
    if tus.KeyCode == Enum.KeyCode.LeftShift then
        guncel_hiz = turbo_hiz
        print("Jarvis: Işınlanma hızı aktif!")
    end

    -- P Tuşu: Sadece yukarı doğru fırlama (Asansör Modu)
    if tus.KeyCode == Enum.KeyCode.P and ucan_mi then
        dikey_tirmanis_mi = not dikey_tirmanis_mi
        if dikey_tirmanis_mi then
            print("Jarvis: Dikey tırmanış protokolü başlatıldı. Dümdüz yukarı çıkılıyor!")
        else
            print("Jarvis: Dikey tırmanış durduruldu. Manuel uçuşa dönüldü.")
        end
    end
end)

-- Tuş bırakıldığında
UIS.InputEnded:Connect(function(tus, isleniyor)
    -- Sol Shift Tuşu Bırakıldığında: Turbo'yu Kapat, normal hıza dön
    if tus.KeyCode == Enum.KeyCode.LeftShift then
        guncel_hiz = temel_hiz
    end
end)

-- Hareket motoru (Fizik motoru ile saniyede onlarca kez güncellenir)
RunService.RenderStepped:Connect(function()
    if ucan_mi and iticiGuc then
        if dikey_tirmanis_mi then
            -- P tuşu aktifse: Kameraya bakma, sadece Y ekseninde (yukarı) uç
            iticiGuc.Velocity = Vector3.new(0, guncel_hiz, 0)
        else
            -- Normal uçuş: Kameranın baktığı yöne uç
            local karakter = oyuncu.Character
            local humanoid = karakter and karakter:FindFirstChild("Humanoid")
            local kamera = workspace.CurrentCamera
            
            if humanoid then
                local hareketYonu = humanoid.MoveDirection
                if hareketYonu.Magnitude > 0 then
                    iticiGuc.Velocity = kamera.CFrame.LookVector * guncel_hiz
                else
                    iticiGuc.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end)
