-- Modül: Jarvis Süpersonik Uçuş Sistemi
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ucan_mi = false
local temel_hiz = 150 -- Yeni normal hızımız (Eskisi 50'ydi, şu an 3 kat hızlı)
local turbo_hiz = 500 -- Sınırları zorlayan süpersonik hız!
local guncel_hiz = temel_hiz
local iticiGuc = nil

-- Tuşlara basıldığında
UIS.InputBegan:Connect(function(tus, isleniyor)
    if isleniyor then return end 
    
    -- F Tuşu: Uçuşu Aç/Kapat
    if tus.KeyCode == Enum.KeyCode.F then
        ucan_mi = not ucan_mi
        local karakter = oyuncu.Character
        local kok = karakter and karakter:FindFirstChild("HumanoidRootPart")

        if ucan_mi and kok then
            iticiGuc = Instance.new("BodyVelocity")
            iticiGuc.Name = "JarvisUcusMotoru"
            iticiGuc.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            iticiGuc.Velocity = Vector3.new(0, 0, 0)
            iticiGuc.Parent = kok
            print("Jarvis: Uçuş motorları devrede. Sistem stabil.")
        else
            if iticiGuc then 
                iticiGuc:Destroy() 
                iticiGuc = nil
            end
            print("Jarvis: Motorlar kapatıldı.")
        end
    end
    
    -- Sol Shift Tuşu: Turbo'yu Aç
    if tus.KeyCode == Enum.KeyCode.LeftShift then
        guncel_hiz = turbo_hiz
        print("Jarvis: Turbo motorlar aktif! Sıkı tutunun efendim.")
    end
end)

-- Tuş bırakıldığında
UIS.InputEnded:Connect(function(tus, isleniyor)
    -- Sol Shift Tuşu: Turbo'yu Kapat, normal hıza dön
    if tus.KeyCode == Enum.KeyCode.LeftShift then
        guncel_hiz = temel_hiz
    end
end)

-- Hareket motoru (Sürekli güncellenir)
RunService.RenderStepped:Connect(function()
    if ucan_mi and iticiGuc then
        local karakter = oyuncu.Character
        local humanoid = karakter and karakter:FindFirstChild("Humanoid")
        local kamera = workspace.CurrentCamera
        
        if humanoid then
            local hareketYonu = humanoid.MoveDirection
            
            if hareketYonu.Magnitude > 0 then
                -- Kameranın baktığı yöne doğru güncel hız ile fırla
                iticiGuc.Velocity = kamera.CFrame.LookVector * guncel_hiz
            else
                iticiGuc.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
