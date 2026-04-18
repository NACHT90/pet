-- JARVIS: ELMAS YAĞMURU (DIAMOND DUPE) SALDIRISI
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local elmasKoprusu = ReplicatedStorage:FindFirstChild("DiamondParty_Claim", true)

if elmasKoprusu then
    print("Jarvis: Sınırsız Elmas Sömürüsü Başladı!")
    
    _G.ElmasSpam = true -- Durdurmak isterseniz bunu false yapın
    
    task.spawn(function()
        while _G.ElmasSpam do
            -- Çaldığımız o benzersiz şifreyi kullanarak sürekli "Ödülü ver" diyoruz
            elmasKoprusu:FireServer("6f23f3267891467ebaa644ebeaa2f352", nil)
            task.wait(0.01) -- Saniyede 100 kere talep et
        end
    end)
else
    warn("Jarvis: DiamondParty_Claim köprüsü bulunamadı!")
end
