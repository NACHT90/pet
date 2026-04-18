-- Modül: Jarvis V15 [FINAL SHIELD] (Sniffer + Payload + Close)
local oyuncu = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local playerGui = oyuncu:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("JarvisMenu") then playerGui.JarvisMenu:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JarvisMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 500) -- Daha kompakt boyut
frame.Position = UDim2.new(0.5, -130, 0.5, -250) 
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) 
frame.BorderSizePixel = 0 
frame.Active = true frame.Draggable = true frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame") 
topBar.Size = UDim2.new(1, 0, 0, 30) 
topBar.BackgroundColor3 = Color3.fromRGB(150, 0, 255) 
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Text = "JARVIS V15"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 12
title.Parent = topBar

-- ❌ KAPATMA BUTONU
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -40)
container.Position = UDim2.new(0, 5, 0, 35)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 4
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.Parent = frame
local listLayout = Instance.new("UIListLayout") 
listLayout.Parent = container 
listLayout.Padding = UDim.new(0, 5) 
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function Buton(txt, col)
    local b = Instance.new("TextButton") b.Size = UDim2.new(0.9, 0, 0, 35) b.Text = txt b.BackgroundColor3 = col b.TextColor3 = Color3.fromRGB(255, 255, 255) b.Font = Enum.Font.GothamSemibold b.TextSize = 10 b.Parent = container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) return b
end

local function Kutu(ph)
    local k = Instance.new("TextBox") k.Size = UDim2.new(0.9, 0, 0, 30) k.PlaceholderText = ph k.Text = "" k.BackgroundColor3 = Color3.fromRGB(30, 30, 35) k.TextColor3 = Color3.fromRGB(0, 255, 150) k.Font = Enum.Font.Code k.TextSize = 10 k.Parent = container
    Instance.new("UICorner", k).CornerRadius = UDim.new(0, 4) return k
end

-- SNIFFER BÖLÜMÜ
local stat = Instance.new("TextLabel") stat.Size = UDim2.new(0.9, 0, 0, 40) stat.Text = "Kayıt: 0 | Durum: Beklemede" stat.BackgroundColor3 = Color3.fromRGB(20, 20, 25) stat.TextColor3 = Color3.fromRGB(200, 200, 200) stat.Parent = container

local logs = {} local active = false
local btnStart = Buton("🟢 KAYDI BAŞLAT", Color3.fromRGB(0, 120, 60))
local btnCopy = Buton("📋 TÜMÜNÜ KOPYALA", Color3.fromRGB(0, 100, 200))

if hookmetamethod then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        if active and not checkcaller() and m == "FireServer" and self:IsA("RemoteEvent") then
            table.insert(logs, {R = self.Name, A = {...}})
            stat.Text = "Kayıt: " .. #logs .. "\nSon: " .. self.Name
        end
        return old(self, ...)
    end)
end

btnStart.MouseButton1Click:Connect(function()
    active = not active
    btnStart.Text = active and "🔴 KAYIT DEVAM EDİYOR..." or "🟢 KAYDI BAŞLAT"
    btnStart.BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 120, 60)
end)

btnCopy.MouseButton1Click:Connect(function()
    local s = "--- JARVIS DATA ---\n"
    for i, v in ipairs(logs) do
        s = s .. "[" .. i .. "] " .. v.R .. "\nArgs: " .. game:GetService("HttpService"):JSONEncode(v.A) .. "\n"
    end
    if setclipboard then setclipboard(s) btnCopy.Text = "✅ KOPYALANDI" task.wait(1) btnCopy.Text = "📋 TÜMÜNÜ KOPYALA" end
end)

-- ENJEKTÖR BÖLÜMÜ
Instance.new("Frame", container).Size = UDim2.new(0.9, 0, 0, 2)
local h_in = Kutu("Hedef Remote")
local p1_in = Kutu("Parametre 1")
local p2_in = Kutu("Parametre 2")
local fireBtn = Buton("🎯 ENJEKTE ET", Color3.fromRGB(150, 0, 255))

fireBtn.MouseButton1Click:Connect(function()
    local target = game:GetService("ReplicatedStorage"):FindFirstChild(h_in.Text, true)
    if target and target:IsA("RemoteEvent") then
        local p1 = tonumber(p1_in.Text) or p1_in.Text
        local p2 = tonumber(p2_in.Text) or p2_in.Text
        target:FireServer(p1, p2)
    end
end)
