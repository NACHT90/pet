--[[
    [destroyerr1558 Advanced Code Creator]
    Pet Simulator 99 - Advanced Multi-Tool Script
    Target: Roblox Executor (Fluxus, Delta, Hydrogen, etc.)
    Features: Flight, Walkspeed, Infinite Pet Slots (Visual/Logic), Auto-Collect
]]--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/70860555776/Visual-UI-Library/main/Source.lua"))()
local Window = Library:CreateWindow("Moon Universe PS99 VIP", "PS99", 10044538000)

local Tab = Window:CreateTab("Main Cheats")
local PlayerTab = Window:CreateTab("Movement")

-- Global Variables
local Flying = false
local FlySpeed = 50
local InfinitePets = false

-- Section: Pet Management
Tab:CreateSection("Pet Controls")

Tab:CreateToggle("Infinite Pet Slots Bypass", function(state)
    InfinitePets = state
    if InfinitePets then
        task.spawn(function()
            while InfinitePets do
                -- Logic to manipulate local pet equip limit
                local PlayerData = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save").Get()
                if PlayerData then
                    PlayerData.MaxEquipped = 999 -- Visual & Logic Attempt
                end
                task.wait(1)
            end
        end)
    end
end)

Tab:CreateButton("Equip All Best Pets", function()
    local args = { [1] = "Equip Best" }
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Pets_EquipBest"):FireServer(unpack(args))
end)

-- Section: Movement & Flight
PlayerTab:CreateSection("Character Physics")

PlayerTab:CreateSlider("WalkSpeed", 16, 250, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

PlayerTab:CreateToggle("Flight Mode", function(state)
    Flying = state
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local char = player.Character
    local bp = Instance.new("BodyVelocity", char.HumanoidRootPart)
    local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
    
    bp.MaxForce = Vector3.new(0,0,0)
    bg.MaxTorque = Vector3.new(0,0,0)

    if Flying then
        bp.MaxForce = Vector3.new(400000, 400000, 400000)
        bg.MaxTorque = Vector3.new(400000, 400000, 400000)
        while Flying do
            char.Humanoid.PlatformStand = true
            bp.Velocity = mouse.Hit.LookVector * FlySpeed
            bg.CFrame = mouse.Hit
            task.wait()
        end
    else
        char.Humanoid.PlatformStand = false
        bp:Destroy()
        bg:Destroy()
    end
end)

-- Section: Automation
Tab:CreateSection("Auto-Farming")

Tab:CreateToggle("Auto-Collect Orbs", function(state)
    _G.AutoCollect = state
    while _G.AutoCollect do
        for _, v in pairs(game:GetService("Workspace").Scene.Orbs:GetChildren()) do
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
        task.wait(0.1)
    end
end)

-- UI Styling
Library:SetTheme("Dark")
print("[destroyerr1558] Script Loaded Successfully in Moon Universe!")
