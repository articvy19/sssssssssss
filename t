-- Desabilitar todos os sons do jogo
for _, sound in pairs(game:GetDescendants()) do
    if sound:IsA("Sound") then
        sound.Volume = 0
        sound:Stop()
    end
end

-- Monitorar novos sons
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Sound") then
        descendant.Volume = 0
        descendant:Stop()
    end
end)

-- Configurações
getgenv().Setting = {
    ["Hunt"] = {
        ["Team"] = "Pirates",
        ["Min"] = 0,
        ["Max"] = 30000000,
    },
    ["Webhook"] = {
        ["Enabled"] = true, 
        ["Url"] = "https://discord.com/api/webhooks/1155320797867561091/98jhEvNhwKwihhk9OUM_k16YkQAPyg83aKapZnozkxyL5dATYtM98Iw_GRuypc3u9zk1"
    },
    ["Skip"] = {
        ["V4"] = true,
        ["Fruit"] = true,
        ["FruitList"] = {
            "Leopard",
            "Venom",
            "Dough",
            "Portal"
        }
    },
    ["Chat"] = {
        ["Enabled"] = false,
        ["List"] = {""},
    },
    ["Click"] = {
        ["AlwaysClick"] = true,
        ["FastClick"] = false
    },
    ["Another"] = {
        ["V3"] = true,
        ["CustomHealth"] = true,
        ["Health"] = 12000,
        ["V4"] = true,
        ["LockCamera"] = true,
        ["FPSBoots"] = false,
        ["WhiteScreen"] = false,
        ["BypassTp"] = true
    },
    ["SafeHealth"] = {
        ["Health"] = 4000,
        ["HighY"] = 1200
    },
    ["Melee"] = {
        ["Enable"] = true,
        ["Delay"] = 2.5,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0}
    },
    ["Fruit"] = {
        ["Enable"] = true,
        ["Delay"] = 1,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 1,25},
        ["V"] = {["Enable"] = true, ["HoldTime"] = 1.25},
        ["F"] = {["Enable"] = false, ["HoldTime"] = 0}
    },
    ["Sword"] = {
        ["Enable"] = true,
        ["Delay"] = 1,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 1.2},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0}
    },
    ["Gun"] = {
        ["Enable"] = true,
        ["GunMode"] = false, 
        ["Delay"] = 1.75,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 1.2},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0}
    }
}

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

print("[Auto Bounty] Iniciando...")

--- Join Team
if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
    repeat wait()
        if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible == true then
            if getgenv().Setting.Hunt.Team == "Marines" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
            else
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
            end
        end
    until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()
end

--- Check World/Tween + Bypass
if game.PlaceId == 7449423635 then
    World3 = true
else
    game.Players.LocalPlayer:Kick("Only Support BF Sea 3")
end 

if World3 then 
    distbyp = 5000
    island = {
        ["Port Town"] = CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375),
        ["Hydra Island"] = CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531),
        ["Mansion"] = CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375),
        ["Castle On The Sea"] = CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375),
        ["Haunted Island"] = CFrame.new(-9547.5703125, 141.0137481689453, 5535.16162109375),
        ["Great Tree"] = CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625),
        ["Candy Island"] = CFrame.new(-1106.076416015625, 13.016114234924316, -14231.9990234375),
        ["Cake Island"] = CFrame.new(-1903.6856689453125, 36.70722579956055, -11857.265625),
        ["Loaf Island"] = CFrame.new(-889.8325805664062, 64.72842407226562, -10895.8876953125),
        ["Peanut Island"] = CFrame.new(-1943.59716796875, 37.012996673583984, -10288.01171875),
        ["Cocoa Island"] = CFrame.new(147.35205078125, 23.642955780029297, -12030.5498046875),
        ["Tiki Outpost"] = CFrame.new(-16234,9,416)
    } 
end

local p = game.Players
local lp = p.LocalPlayer
local rs = game.RunService
local hb = rs.Heartbeat
local rends = rs.RenderStepped

-- Sistema de ataque Seriality para Blox Fruit (sem cooldown)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
_G.Seriality = true

local function IsEntityAlive(entity)
    if not entity then return false end
    local humanoid = entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetEnemiesInRange(character, range)
    local targets = {}
    if not character then return targets end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return targets end
    
    local playerPos = root.Position
    
    if not Workspace:FindFirstChild("Enemies") then
        return targets
    end

    for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        if enemyRoot and IsEntityAlive(enemy) then
            if (enemyRoot.Position - playerPos).Magnitude <= range then
                table.insert(targets, enemy)
            end
        end
    end
    
    return targets
end

local function AttackNoCoolDown()
    local character = player.Character
    if not character then return end
    
    local equippedWeapon = character:FindFirstChildOfClass("Tool")
    if not equippedWeapon then return end
    
    local enemies = GetEnemiesInRange(character, 100)
    if #enemies == 0 then return end
    
    local modules = ReplicatedStorage:FindFirstChild("Modules")
    if not modules then return end
    
    local net = modules:FindFirstChild("Net")
    if not net then return end
    
    local registerAttack = net:FindFirstChild("RE/RegisterAttack")
    local registerHit = net:FindFirstChild("RE/RegisterHit")
    
    if not registerAttack or not registerHit then return end
    
    local targets = {}
    local mainTarget = nil
    
    for _, enemy in ipairs(enemies) do
        if not enemy:GetAttribute("IsBoat") then
            local part = enemy:FindFirstChild("Head") or enemy.PrimaryPart
            if part then
                table.insert(targets, {enemy, part})
                mainTarget = part
            end
        end
    end
    
    if not mainTarget then return end
    
    registerAttack:FireServer(0)
    registerHit:FireServer(mainTarget, targets)
end

task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not _G.Seriality then return end
        
        pcall(function()
            local character = player.Character
            if not character then return end
            
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then return end
            
            if tool:FindFirstChild("LeftClickRemote") then
                AttackNoCoolDown()
                
                tool.LeftClickRemote:FireServer(Vector3.new(0.01,-500,0.01),1,true)
                tool.LeftClickRemote:FireServer(false)
            end
        end)
    end)
end)

getgenv().weapon = nil
getgenv().targ = nil 
getgenv().lasttarrget = nil
getgenv().checked = {}
getgenv().pl = p:GetPlayers()
wait(1)

--- Funções principais ---
function bypass(Pos)   
    if not lp or not lp.Character then return end
    if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then return end
    
    dist = math.huge
    is = nil
    for i , v in pairs(island) do
        if (Pos.Position-v.Position).magnitude < dist then
            is = v 
            dist = (Pos.Position-v.Position).magnitude 
        end
    end 
    if is == nil then return; end
    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
            if tween then
                pcall(function() tween:Destroy() end)
            end
            if (is.X == 61163.8515625 and is.Y ==11.6796875 and is.Z == 1819.7841796875) or is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                if tween then
                   pcall(function() tween:Cancel() end)
                end
                repeat task.wait()
                    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = is
                    end
                until (lp and lp.Character and lp.Character:FindFirstChild("PrimaryPart") and lp.Character.PrimaryPart.CFrame == is)
                task.wait(0.1)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                end)
            else
                if not stopbypass then
                    if tween then
                       pcall(function() tween:Cancel() end)
                    end
                    repeat task.wait()
                        if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = is
                        end
                    until (lp and lp.Character and lp.Character:FindFirstChild("PrimaryPart") and lp.Character.PrimaryPart.CFrame == is)
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
                        lp.Character:SetPrimaryPartCFrame(is)
                        wait(0.1)
                        lp.Character.Head:Destroy()
                        wait(0.5)
                    end)
                    repeat task.wait()
                        if lp and lp.Character and lp.Character:FindFirstChild("PrimaryPart") then
                            lp.Character.PrimaryPart.CFrame = is
                        end
                    until (lp and lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("Humanoid").Health > 0)
                    task.wait(0.5)
                end 
            end
        end
    end
end

-- Sistema de tween baseado no hj.lua, usando bypass de ilha mais próxima
function TweenService2(...)
    local RealtargetPos = {...}
    local targetPos = RealtargetPos[1]
    local RealTarget

    if typeof(targetPos) == "Vector3" then
        RealTarget = CFrame.new(targetPos)
    elseif typeof(targetPos) == "CFrame" then
        RealTarget = targetPos
    elseif type(targetPos) == "number" then
        RealTarget = CFrame.new(unpack(RealtargetPos))
    else
        return
    end

    if not lp or not lp.Character then return end

    -- Garante que o personagem está vivo antes de mover (para voltar pro PVP após morrer/resetar)
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        repeat
            task.wait()
        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
        task.wait(0.75)
    end

    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local Distance = (root.Position - RealTarget.Position).Magnitude

    -- Se estiver muito perto, apenas teleporta direto
    if Distance <= 150 then
        pcall(function()
            root.CFrame = RealTarget
        end)
        return
    end

    -- Teleporte para ilha mais próxima usando o sistema existente de bypass
    if Distance > distbyp then
        pcall(function()
            bypass(RealTarget)
        end)
    end

    local info = TweenInfo.new(Distance / 315, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(root, info, {CFrame = RealTarget})
    tween:Play()

    local tweenfunc = {}

    function tweenfunc:Cancel()
        if tween then
            tween:Cancel()
        end
    end

    function tweenfunc:Wait()
        if tween then
            tween.Completed:Wait()
        end
    end

    function tweenfunc:Pause()
        if tween then
            tween:Pause()
        end
    end

    return tweenfunc
end

function to(Pos)
    pcall(function()
        if lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid").Health > 0 then
            Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if not game.Players.LocalPlayer.Character.PrimaryPart:FindFirstChild("Hold") then
                local Hold = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.PrimaryPart)
                Hold.Name = "Hold"
                Hold.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Hold.Velocity = Vector3.new(0, 0, 0)
            end
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            if Distance < 250 then
                Speed = 400
            elseif Distance < 1000 then
                Speed = 375
            elseif Distance >= 1000 then
                Speed = 350
            end
            pcall(function()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),{CFrame = Pos})
                    if tween then
                        tween:Play()
                    end
                end
            end)
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.InCombat.Visible then
                if not string.find(string.lower(game:GetService("Players").LocalPlayer.PlayerGui.Main.InCombat.Text), "risk") then
                    bypass(Pos)
                end
            else
                bypass(Pos)
            end
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, Pos.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
        end
    end)
end

function buso()
    if (not (game.Players.LocalPlayer.Character:FindFirstChild("HasBuso"))) then
        local rel = game.ReplicatedStorage
        rel.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Ativar buso automaticamente ao iniciar o script
pcall(function()
    buso()
end)

function Ken()
    if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
        buoi = true
    else
        game:service("VirtualUser"):CaptureController()
        game:service("VirtualUser"):SetKeyDown("0x65")
        game:service("VirtualUser"):SetKeyUp("0x65")
    end
end

function down(use)
    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true,use,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
        task.wait(l)
        game:GetService("VirtualInputManager"):SendKeyEvent(false,use,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
    end)
end

function equip(tooltip)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait()
    if not character or not character:FindFirstChildOfClass("Humanoid") then return false end
    
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item and item:IsA("Tool") and item.ToolTip == tooltip then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                end)
                return true
            end
        end
    end
    return false
end

function EquipWeapon(Tool)
    pcall(function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild(Tool) then
            local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(Tool)
            if ToolHumanoid and game.Players.LocalPlayer.Character then
                ToolHumanoid.Parent = game.Players.LocalPlayer.Character
            end
        end
    end)
end

function Click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,1,0,1))
end

-- No Clip
spawn(function()
    while game:GetService("RunService").Stepped:wait() do
        pcall(function()
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, v in pairs(character:GetChildren()) do
                    if v and v:IsA("BasePart") and v.Parent then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- FPS Boost
if getgenv().Setting.Another.FPSBoots then
    local removedecals = false
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
end

-- White Screen
if getgenv().Setting.Another.WhiteScreen then
    game.RunService:Set3dRenderingEnabled(false)
end

function hasValue(array, targetString)
    for _, value in ipairs(array) do
        if value == targetString then
            return true
        end
    end
    return false
end

-- Fast Attack
if getgenv().Setting.Click.FastClick then
    local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
    CameraShaker:Stop()
    fastattack = true
    CombatFrameworkR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
    y = debug.getupvalues(CombatFrameworkR)[2]
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if fastattack then
                if typeof(y) == "table" then
                    pcall(function()
                        y.activeController.timeToNextAttack = 0
                        y.activeController.hitboxMagnitude = 60
                        y.activeController.active = false
                        y.activeController.timeToNextBlock = 0
                        y.activeController.focusStart = 1655503339.0980349
                        y.activeController.increment = 1
                        y.activeController.blocking = false
                        y.activeController.attacking = false
                        y.activeController.humanoid.AutoRotate = true
                    end)
                end
            end
        end)
    end)
end

function SkipPlayer()
    getgenv().killed = getgenv().targ 
    table.insert(getgenv().checked, getgenv().targ)
    getgenv().targ = nil
    target()
end

function target() 
    pcall(function()
        d = math.huge
        p = nil
        getgenv().targ = nil
        for i, v in pairs(game.Players:GetPlayers()) do 
            if v.Team ~= nil and (tostring(lp.Team) == "Pirates" or (tostring(v.Team) == "Pirates" and tostring(lp.Team) ~= "Pirates")) then
                if v and v:FindFirstChild("Data") and ((getgenv().Setting.Skip.Fruit and hasValue(getgenv().Setting.Skip.FruitList, v.Data.DevilFruit.Value) == false) or not getgenv().Setting.Skip.Fruit) then
                    if v ~= lp and v ~= getgenv().targ and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position).Magnitude < d and hasValue(getgenv().checked, v) == false and v.Character.HumanoidRootPart.CFrame.Y <= 12000 then
                        if (tonumber(game.Players.LocalPlayer.Data.Level.Value) - 250) < v.Data.Level.Value  then
                            if v.leaderstats["Bounty/Honor"].Value >= getgenv().Setting.Hunt.Min and v.leaderstats["Bounty/Honor"].Value <= getgenv().Setting.Hunt.Max and not hopserver then 
                                if (getgenv().Setting.Skip.V4 and not v.Character:FindFirstChild("RaceTransformed")) or not getgenv().Setting.Skip.V4 then
                                    p = v 
                                    d = (v.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude 
                                    if getgenv().Setting.Chat.Enabled then
                                        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(getgenv().Setting.Chat.List[math.random(1, #getgenv().Setting.Chat.List)], "All")
                                    end
                                end
                            end
                        end
                    end 
                end
            end
        end 
        if p == nil then hopserver = true end 
        getgenv().targ = p
    end)
end

-- Sistema de armas
gunmethod = getgenv().Setting.Gun.GunMode
local melee, gun, sword, fruit

-- Loop de seleção de armas
spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                    if not gunmethod then
                        if getgenv().Setting.Fruit.Enable then
                            getgenv().weapon = "Blox Fruit"
                            wait(getgenv().Setting.Fruit.Delay)
                        end
                    else
                        EquipWeapon("Blox Fruit")
                    end
                end
            end
        end)
    end
end)

-- Loop de uso de habilidades e ataques
spawn(function()
    while task.wait() do
        if getgenv().targ == nil then target() end
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                    spawn(function()
                        if not gunmethod then
                            equip(getgenv().weapon)
                            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
                                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                                    if getgenv().Setting.Fruit.Enable then
                                        Click()
                                    end
                                end
                            end
                        else
                            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                                    Click()
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
end)

-- Ativar PvP e habilidades V3/V4
spawn(function()
    while task.wait() do 
        pcall(function()
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
            if getgenv().targ ~= nil and getgenv().targ.Character and (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude < 50 then
                buso()
                if getgenv().Setting.Another.V3 then
                    if getgenv().Setting.Another.CustomHealth and lp.Character.Humanoid.Health <= getgenv().Setting.Another.Health then
                        l = 0.1
                        down("T")
                    end
                end
                if getgenv().Setting.Another.V4 then
                    l = 0.1
                    down("Y")
                end   
            end
        end)
    end
end)

-- Ativar Ken Haki
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                Ken()
            end
        end)
    end
end)

-- Loop principal do farm (movimento)
spawn(function()
    while task.wait(0.05) do
        if getgenv().targ == nil then target() end
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > getgenv().Setting.SafeHealth.Health then
                    if getgenv().targ.Character.Humanoid.Health > 0 then
                        local distance = (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude
                        if distance < 40 then
                            TweenService2(CFrame.new(getgenv().targ.Character.HumanoidRootPart.Position + getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 5, getgenv().targ.Character.HumanoidRootPart.Position))
                        else
                            TweenService2(getgenv().targ.Character.HumanoidRootPart.CFrame*CFrame.new(0,10,0))
                        end
                    else
                        print("[Auto Bounty] Alvo morreu, procurando novo...")
                        SkipPlayer()
                    end
                else
                    -- Health baixa: apenas troca de alvo, sem subir para o céu
                    print("[Auto Bounty] Health baixa, trocando de alvo...")
                    SkipPlayer()
                end
            end
        end)
    end
end)

print("[Auto Bounty] Farm iniciado com sucesso!")
print("[Auto Bounty] Procurando alvos...")
print("[Auto Bounty] Sistema de combate ativado!")

-- =========================================
-- NOVO SISTEMA DE AIMBOT SKILL (SEMPRE ATIVO)
-- Substitui a função antiga de acerto por skill
-- =========================================

_G.AimMethod = true
ABmethod = "AimBots Skill"
_G.TpPly = false
_G.PlayersList = nil

-- Atualizar lista de players
PlrList = {}
for _,v in pairs(game:GetService("Players"):GetPlayers()) do
    table.insert(PlrList, v.Name)
end

game:GetService("Players").PlayerAdded:Connect(function(p)
    table.insert(PlrList, p.Name)
end)

game:GetService("Players").PlayerRemoving:Connect(function(p)
    for i,v in ipairs(PlrList) do
        if v == p.Name then
            table.remove(PlrList, i)
            break
        end
    end
end)

-- Aimbot Skill sempre ligado (mesma lógica do TXT)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "AimBots Skill" then
                if _G.PlayersList then
                    local v = game:GetService("Players"):FindFirstChild(_G.PlayersList)
                    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= lp.Team then
                        MousePos = v.Character.HumanoidRootPart.Position
                    end
                elseif getgenv().targ and getgenv().targ.Character then
                    MousePos = getgenv().targ.Character.HumanoidRootPart.Position
                end
            end
        end)
    end
end)

-- Auto Aimbot sempre ativo
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Auto Aimbots" then
                local MaxDistance = math.huge
                for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= lp and v.Team ~= lp.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                        if dist < MaxDistance then
                            MaxDistance = dist
                            MousePos = v.Character.HumanoidRootPart.Position
                        end
                    end
                end
            end
        end)
    end
end)

-- =========================================
-- FIM DO NOVO AIMBOT SKILL
-- =========================================
