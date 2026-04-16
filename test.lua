-- Modül: Jarvis Uçuş Sistemi (Kişisel)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ucan_mi = false
local hiz = 50 -- Uçuş hızını buradan ayarlayabilirsiniz
local iticiGuc = nil

-- F Tuşuna basıldığında uçuşu aç/kapat
UIS.InputBegan:Connect(function(tus, isleniyor)
    if isleniyor then return end -- Eğer oyuncu chate yazı yazıyorsa iptal et
    
    if tus.KeyCode == Enum.KeyCode.F then
        ucan_mi = not ucan_mi
        local karakter = oyuncu.Character
        local kok = karakter and karakter:FindFirstChild("HumanoidRootPart")

        if ucan_mi and kok then
            -- Uçuş aktif: Yerçekimini yenen sanal motoru oluştur
            iticiGuc = Instance.new("BodyVelocity")
            iticiGuc.Name = "JarvisUcusMotoru"
            iticiGuc.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            iticiGuc.Velocity = Vector3.new(0, 0, 0)
            iticiGuc.Parent = kok
            
            print("Jarvis: Uçuş modülü AKTİF edildi, efendim.")
        else
            -- Uçuş kapalı: Motoru yok et ve yere düş
            if iticiGuc then 
                iticiGuc:Destroy() 
                iticiGuc = nil
            end
            print("Jarvis: Uçuş modülü KAPATILDI.")
        end
    end
end)

-- Her saniye karakterin yönünü kameraya göre güncelle
RunService.RenderStepped:Connect(function()
    if ucan_mi and iticiGuc then
        local karakter = oyuncu.Character
        local humanoid = karakter and karakter:FindFirstChild("Humanoid")
        local kamera = workspace.CurrentCamera
        
        if humanoid then
            -- Klavyedeki WASD tuşlarına basma yönünü al
            local hareketYonu = humanoid.MoveDirection
            
            -- Eğer oyuncu hareket ediyorsa, o yöne doğru hız ekle
            -- Yukarı/Aşağı gitmek için kameranın baktığı açıyı kullanıyoruz
            if hareketYonu.Magnitude > 0 then
                iticiGuc.Velocity = kamera.CFrame.LookVector * hiz
            else
                -- Tuşlara basılmıyorsa havada sabit asılı kal
                iticiGuc.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
