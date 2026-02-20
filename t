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
        ["Health"] = 3000,
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
        ["C"] = {["Enable"] = true, ["HoldTime"] = 1.25},
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
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")

print("[Auto Bounty] Iniciando...")

--- Join Team (suporta Main e Main (minimal))
do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local lp = Players.LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")

    -- espera um pouco pro GUI de time abrir
    task.wait(5)

    local mainGui = pg:FindFirstChild("Main") or pg:FindFirstChild("Main (minimal)")
    if mainGui and mainGui:FindFirstChild("ChooseTeam") then
        repeat
            task.wait()
            local choose = mainGui:FindFirstChild("ChooseTeam")
            if choose and choose.Visible then
                local desiredTeam = (getgenv().Setting and getgenv().Setting.Hunt and getgenv().Setting.Hunt.Team) or "Pirates"
                if desiredTeam == "Pirates" or desiredTeam == "Marines" then
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", desiredTeam)
                    end)
                end
            end
        until lp.Team ~= nil and game:IsLoaded()
    end
end

--- Check World/Tween + Bypass
if game.PlaceId == 7449423635 or 100117331123089 then
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
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
_G.Seriality = true

-- Helper para pegar o GUI principal (Main ou Main (minimal))
local function GetMainGui()
    local lp = Players.LocalPlayer
    if not lp then return nil end
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return nil end
    return pg:FindFirstChild("Main") or pg:FindFirstChild("Main (minimal)")
end

-- Quando o personagem renascer (reset/morte), limpar estados e voltar a caçar
pcall(function()
    lp.CharacterAdded:Connect(function(char)
        task.spawn(function()
            -- espera humanoid e HRP carregarem
            pcall(function()
                char:WaitForChild("Humanoid")
                char:WaitForChild("HumanoidRootPart")
            end)

            -- reseta estados de combate/safe
            getgenv().SafeMode = false
            getgenv().ForceSafe = false
            getgenv().targ = nil
            getgenv().LastTargetHealth = nil
            getgenv().TargetStartTime = nil
            getgenv().NoTargetCount = 0
            getgenv().HpSnapshot = nil
            getgenv().HpSnapshotTime = nil

            -- pequena espera rápida só pra garantir carregamento e volta a procurar alvo
            task.wait(0.25)
            pcall(function()
                target()
            end)
        end)
    end)
end)

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
getgenv().LastTargetHealth = nil
getgenv().LastDamageTime = tick()
getgenv().NoTargetCount = 0
getgenv().SafeMode = false
getgenv().ForceSafe = false
getgenv().UsedServers = getgenv().UsedServers or {}
getgenv().LastAttackTime = 0
getgenv().EnvDamageCount = 0
getgenv().OurDamageCount = 0
getgenv().TargetStartTime = nil
getgenv().LastTeleportTime = getgenv().LastTeleportTime or 0
getgenv().HpSnapshot = nil
getgenv().HpSnapshotTime = nil
local ScriptStartTime = tick()
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

-- Sistema alternativo de teleporte para o lugar mais próximo + tween normal
function CheckNearestTeleporter(aI)
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    local vcspos = aI.Position
    local min = math.huge
    local min2 = math.huge
    local y = game.PlaceId
    local World1, World2, World3
    if y == 2753915549 then
        World1 = true
    elseif y == 4442272183 then
        World2 = true
    elseif y == 7449423635 or y == 100117331123089 then
        World3 = true
    end
    local TableLocations = {}
    if World3 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-12471, 374, -7551),
            ["Hydra"] = Vector3.new(5659, 1013, -341),
            ["Caslte On The Sea"] = Vector3.new(-5092, 315, -3130),
            ["Floating Turtle"] = Vector3.new(-12001, 332, -8861),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Temple Of Time"] = Vector3.new(28286, 14897, 103)
        }
    elseif World2 then
        TableLocations = {
            ["Flamingo Mansion"] = Vector3.new(-317, 331, 597),
            ["Flamingo Room"] = Vector3.new(2283, 15, 867),
            ["Cursed Ship"] = Vector3.new(923, 125, 32853),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif World1 then
        TableLocations = {
            ["Sky Island 1"] = Vector3.new(-4652, 873, -1754),
            ["Sky Island 2"] = Vector3.new(-7895, 5547, -380),
            ["Under Water Island"] = Vector3.new(61164, 5, 1820),
            ["Under Water Island Entrace"] = Vector3.new(3865, 5, -1926)
        }
    end
    -- Se o inimigo estiver claramente em uma dessas ilhas, force usar o teleporte da própria ilha
    if World3 then
        local function near(pos, center, radius)
            return (pos - center).Magnitude <= radius
        end

        local turtlePos = TableLocations["Floating Turtle"]
        if turtlePos and near(vcspos, turtlePos, 4000) then
            return turtlePos
        end

        local mansionPos = TableLocations["Mansion"]
        if mansionPos and near(vcspos, mansionPos, 3500) then
            return mansionPos
        end

        local castlePos = TableLocations["Caslte On The Sea"]
        if castlePos and near(vcspos, castlePos, 3500) then
            return castlePos
        end

        local hydraPos = TableLocations["Hydra"]
        if hydraPos and near(vcspos, hydraPos, 3500) then
            return hydraPos
        end
    end

    local TableLocations2 = {}
    for r, v in pairs(TableLocations) do
        TableLocations2[r] = (v - vcspos).Magnitude
    end
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    local choose
    for r, v in pairs(TableLocations2) do
        if v <= min then
            choose = TableLocations[r]
        end
    end
    local min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

    -- Só usa teleporte se realmente for mais curto do que ir voando.
    -- (No 3º mar, Turtle/Hydra/Mansion/Castle já são forçados lá em cima
    -- pelo bloco "near", então essa comparação aqui cuida do resto.)
    if min2 <= min3 then
        return choose
    end
end    

function requestEntrance(aJ)
    local args = {"requestEntrance", aJ}
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))    
    local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local char = game.Players.LocalPlayer.Character.HumanoidRootPart
    char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)    
    task.wait(0.5)
end   

function topos(Tween_Pos)
    pcall(function()
        if game:GetService("Players").LocalPlayer 
            and game:GetService("Players").LocalPlayer.Character 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
            and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 
            and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart then
            if not TweenSpeed then
                TweenSpeed = 350
            end
            -- manter voo em altura segura para não bater na água
            local MinFlyY = 50
            local DefualtY = math.max(Tween_Pos.Y, MinFlyY)
            local TargetY = Tween_Pos.Y
            local targetCFrameWithDefualtY = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
            local targetPos = Tween_Pos.Position
            local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local Distance = (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
            if Distance <= 300 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Tween_Pos
                return
            end
            local aM = CheckNearestTeleporter(Tween_Pos)
            -- Usa teleporte só de tempos em tempos para evitar spam
            if aM and (tick() - (getgenv().LastTeleportTime or 0) > 5) then
                getgenv().LastTeleportTime = tick()
                pcall(function()
                    if tween then tween:Cancel() end
                end)
                requestEntrance(aM)
            end
            local b1 = CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                DefualtY,
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
            )
            local IngoreY = true
            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                -- Cancela tween antigo para atualizar sempre para a posição mais recente do alvo
                if tween then
                    pcall(function() tween:Cancel() end)
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    DefualtY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = targetCFrameWithDefualtY}
                )
                tween:Play()
            else
                if tween then
                    pcall(function() tween:Cancel() end)
                end
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = Tween_Pos}
                )
                tween:Play()
            end
        end
    end)
end

function StopTween(target)
    pcall(function()
        if not target then
            getgenv().StopTween = true            
            if tween then
                tween:Cancel()
                tween = nil
            end            
            local player = game:GetService("Players").LocalPlayer
            local character = player and character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = true
                task.wait(0.1)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame
                humanoidRootPart.Anchored = false
            end
            local bodyClip = humanoidRootPart and humanoidRootPart:FindFirstChild("BodyClip")
            if bodyClip then
                bodyClip:Destroy()
            end
            getgenv().StopTween = false
            getgenv().Clip = false
        end
    end)
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
                Speed = 400
            elseif Distance >= 1000 then
                Speed = 400
            end
            pcall(function()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    -- tween em altura constante e segura para evitar água
                    local MinFlyY = 50
                    local targetPos = Pos.Position
                    local flyY = math.max(targetPos.Y, MinFlyY)
                    local flyCFrame = CFrame.new(targetPos.X, flyY, targetPos.Z)
                    tween = game:GetService("TweenService"):Create(
                        game.Players.LocalPlayer.Character.HumanoidRootPart,
                        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
                        {CFrame = flyCFrame}
                    )
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

-- Controle de bounty risk (cooldown antes de permitir hop)
getgenv().LastRiskTime = getgenv().LastRiskTime or 0
local RISK_HOP_COOLDOWN = 25 -- segundos após o último "risk" antes de liberar hop

-- Função genérica para detectar se há algum aviso de bounty risk visível na tela
local function IsRiskActive()
    local lp = game.Players.LocalPlayer
    if not lp then return false end
    local gui = lp:FindFirstChild("PlayerGui")
    if not gui then return false end

    for _, inst in ipairs(gui:GetDescendants()) do
        if inst:IsA("TextLabel") or inst:IsA("TextButton") then
            local text = string.lower(inst.Text or "")
            if text ~= "" and (string.find(text, "bounty") and string.find(text, "risk") or string.find(text, "bounty at risk") or string.find(text, "risk")) then
                -- Verifica se esse texto realmente está visível (todos os pais visíveis)
                local visible = inst.Visible
                local parent = inst.Parent
                while visible and parent and parent ~= gui do
                    if parent:IsA("GuiObject") and not parent.Visible then
                        visible = false
                        break
                    end
                    parent = parent.Parent
                end
                if visible then
                    return true
                end
            end
        end
    end
    return false
end

-- Monitor global do texto de InCombat para registrar quando há "risk"
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if IsRiskActive() then
                getgenv().LastRiskTime = tick()
            end
        end)
    end
end)

-- SafeMode: se o HP ficar abaixo do limite, sobe 200 de altura;
-- quando o HP volta ao normal, desativa o modo seguro para voltar a caçar.
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = lp.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                local safeHp = (getgenv().Setting.SafeHealth and getgenv().Setting.SafeHealth.Health) or 3000
                local safeY = (getgenv().Setting.SafeHealth and getgenv().Setting.SafeHealth.HighY) or 1200

                local shouldSafe = getgenv().ForceSafe or humanoid.Health < safeHp

                if shouldSafe then
                    -- Ativa modo seguro (por HP baixo ou por hop) e mantém o boneco alto (Y = HighY)
                    getgenv().SafeMode = true
                    if hrp.Position.Y < safeY then
                        hrp.CFrame = CFrame.new(hrp.Position.X, safeY, hrp.Position.Z)
                    end
                else
                    -- Nenhum motivo pra ficar em safe: desativa
                    getgenv().SafeMode = false
                end
            end
        end)
    end
end)

function hasValue(array, targetString)
    for _, value in ipairs(array) do
        if value == targetString then
            return true
        end
    end
    return false
end

-- Verifica se o player ainda é um alvo válido (no jogo, com personagem vivo)
local function IsValidPlayerTarget(plr)
    if not plr then return false end
    if plr.Parent ~= game:GetService("Players") then return false end
    local char = plr.Character
    if not char then return false end
    -- Demais checagens (Humanoid, HRP, Health) são feitas nos loops
    -- para evitar ficar sem alvo por causa de delay de spawn/carregamento.
    return true
end

-- Safezones: se o inimigo estiver dentro de uma dessas áreas,
-- ele não será escolhido como NOVO alvo. Se já for o alvo atual,
-- o script continua atacando normalmente.
local SAFEZONE_RADIUS = 150 -- raio em studs ao redor do centro da safezone

local SafeZones = {
    CFrame.new(-5097.72656, 311.696777, -2189.77832, 0.374604106, 0, -0.92718488, 0, 1, 0, 0.92718488, 0, 0.374604106),
    CFrame.new(-265.647003, 3.42700195, 5223.68799, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(-5012.70996, 398.437012, -3007.46411, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(-16173.8379, 7.90499878, 453.493988, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(-5238.39697, 311.619934, -2132.94409, 0.374604106, 0, -0.92718488, 0, 1, 0, 0.92718488, 0, 0.374604106),
    CFrame.new(-12547.71, 290.139008, -7487.06494, 1, 0, 0, 0, 1, 0, 0, 0, 1),
}

local function IsInSafeZone(pos)
    for _, cf in ipairs(SafeZones) do
        if (pos - cf.Position).Magnitude <= SAFEZONE_RADIUS then
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
    getgenv().TargetStartTime = nil
    getgenv().HpSnapshot = nil
    getgenv().HpSnapshotTime = nil
    getgenv().OurDamageCount = 0
    getgenv().EnvDamageCount = 0
    target()
end

-- Hop de servidor: chamado quando não há mais players válidos
function HopServer()
    if getgenv().IsHopping then return end

    -- Bloqueios de hop relacionados a combate/risk:
    -- 1) Se houver qualquer aviso de bounty/risk visível, nunca hopa.
    -- 2) Mesmo depois que o aviso some, espera um cooldown antes de permitir hop,
    --    para não trocar de servidor logo após um PVP recente.
    if IsRiskActive() then
        getgenv().LastRiskTime = tick()
        return
    end

    local lastRisk = getgenv().LastRiskTime or 0
    if tick() - lastRisk < RISK_HOP_COOLDOWN then
        return
    end

    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local currentJobId = game.JobId

    -- Marca o servidor atual como já usado ANTES de qualquer coisa,
    -- assim ele nunca será escolhido como destino (corrige o hop para o mesmo servidor)
    getgenv().UsedServers[currentJobId] = true

    -- Antes de hopar, ativa safe e sobe para a altura segura
    getgenv().ForceSafe = true
    pcall(function()
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local safeY = (getgenv().Setting.SafeHealth and getgenv().Setting.SafeHealth.HighY) or 1200
        if hrp and hrp.Position.Y < safeY then
            hrp.CFrame = CFrame.new(hrp.Position.X, safeY, hrp.Position.Z)
        end
    end)

    -- Busca lista de servidores públicos e tenta achar um JobId diferente.
    -- Se o executor bloquear HTTP, cai no Teleport normal.
    local cursor = nil
    local foundServerId = nil

    for _ = 1, 5 do -- até 5 páginas, só pra garantir
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor and ("&cursor=" .. cursor) or "")

        local okHttp, response = pcall(function()
            return game:HttpGet(url)
        end)
        if not okHttp then
            break
        end

        local okJson, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if not okJson then
            break
        end

        if data and data.data then
            for _, server in ipairs(data.data) do
                if type(server) == "table" and server.id then
                    local playing    = tonumber(server.playing or 0)
                    local maxPlayers = tonumber(server.maxPlayers or 0)

                    -- Ignora: servidor atual, servidores já visitados e servidores cheios/vazios
                    if server.id ~= currentJobId
                       and not getgenv().UsedServers[server.id]
                       and maxPlayers > playing
                       and playing >= 8 then

                        -- Notificação
                        pcall(function()
                            game.StarterGui:SetCore("SendNotification", {
                                Title = "Hop Low Server",
                                Text = "Players : " .. tostring(playing),
                                Icon = "http://www.roblox.com/asset/?id=9606070311",
                                Duration = 1.5
                            })
                        end)

                        foundServerId = server.id
                        break
                    end
                end
            end
        end

        if foundServerId then break end
        if data and data.nextPageCursor then
            cursor = data.nextPageCursor
        else
            break
        end
    end

    getgenv().IsHopping = true
    if foundServerId then
        -- Marca o destino como já visitado para evitar loop de volta
        getgenv().UsedServers[foundServerId] = true
        TeleportService:TeleportToPlaceInstance(placeId, foundServerId, lp)
    else
        -- Fallback: se não achou nenhum servidor válido ou HTTP falhou
        -- Limpa a lista de usados para não ficar sem opções na próxima vez
        getgenv().UsedServers = { [currentJobId] = true }
        TeleportService:Teleport(placeId, lp)
    end
end

function target() 
    pcall(function()
        d = math.huge
        p = nil
        getgenv().targ = nil
        for i, v in pairs(game.Players:GetPlayers()) do 
            if v.Team ~= nil and (tostring(lp.Team) == "Pirates" or (tostring(v.Team) == "Pirates" and tostring(lp.Team) ~= "Pirates")) then
                if v and v:FindFirstChild("Data") and ((getgenv().Setting.Skip.Fruit and hasValue(getgenv().Setting.Skip.FruitList, v.Data.DevilFruit.Value) == false) or not getgenv().Setting.Skip.Fruit) then
                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    local myHrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if v ~= lp and v ~= getgenv().targ and IsValidPlayerTarget(v)
                       and hrp and myHrp
                       and not IsInSafeZone(hrp.Position)
                       and (hrp.Position - myHrp.Position).Magnitude < d
                       and hasValue(getgenv().checked, v) == false
                       and hrp.Position.Y <= 12000 then
                        if (tonumber(game.Players.LocalPlayer.Data.Level.Value) - 250) < v.Data.Level.Value  then
                            if v.leaderstats["Bounty/Honor"].Value >= getgenv().Setting.Hunt.Min and v.leaderstats["Bounty/Honor"].Value <= getgenv().Setting.Hunt.Max then 
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
                        if p == nil then
            -- Nada encontrado nesta varredura.
            getgenv().targ = nil
            getgenv().TargetStartTime = nil

            -- Conta quantas vezes seguidas não achamos alvo.
            getgenv().NoTargetCount = (getgenv().NoTargetCount or 0) + 1

            -- Só faz hop se:
            -- 1) o script já está rodando há alguns segundos (evita hop logo ao entrar)
            -- 2) muitas tentativas seguidas sem achar alvo.
            -- HopServer em si checa IsRiskActive e o cooldown pós-combate.
            if tick() - ScriptStartTime > 19 and getgenv().NoTargetCount >= 10 then
                HopServer()
            end
        else
            -- Achou alvo: reseta contador de falhas
            getgenv().NoTargetCount = 0
            getgenv().targ = p
            getgenv().TargetStartTime = tick()

            -- Quando escolhe um novo alvo, inicia controle básico de HP
            if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("Humanoid") then
                getgenv().LastTargetHealth = getgenv().targ.Character.Humanoid.Health
                getgenv().LastDamageTime = tick()
                getgenv().EnvDamageCount = 0
                getgenv().OurDamageCount = 0
            else
                getgenv().LastTargetHealth = nil
            end
        end
    end)
end

-- Se o alvo sair do jogo, limpa e procura outro
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == getgenv().targ then
        print("[Auto Bounty] Alvo saiu do servidor, procurando novo...")
        getgenv().targ = nil
        target()
    end
    for i, v in ipairs(getgenv().checked) do
        if v == plr then
            table.remove(getgenv().checked, i)
            break
        end
    end
end)

-- ============================================================
-- Monitor de dano em PLAYER: detecta se estamos causando dano
-- Usa snapshot de HP antes/depois do ataque + threshold de regen
-- para distinguir dano nosso de regen ou dano de terceiros
-- ============================================================
local REGEN_RATE      = 2    -- HP/s que o jogo pode regenerar naturalmente
local ATTACK_WINDOW   = 0.25 -- segundos após LastAttackTime para considerar "janela do ataque"
local NO_DAMAGE_LIMIT = 4    -- segundos sem causar dano próximo antes de trocar alvo
local ENV_SKIP_COUNT  = 3    -- qtd de mudanças de HP "externas" antes de pular (sem nenhum dano nosso)

-- Variáveis de controle do snapshot
getgenv().HpSnapshot       = nil  -- HP registrado no momento do ataque
getgenv().HpSnapshotTime   = nil  -- tick() do snapshot

-- Sempre que um ataque é disparado, registra o HP do alvo naquele momento
-- (isso é chamado internamente sempre que LastAttackTime é atualizado)
local function TakeHpSnapshot()
    local t = getgenv().targ
    if not t or not t.Character then return end
    local hum = t.Character:FindFirstChild("Humanoid")
    if not hum then return end
    getgenv().HpSnapshot     = hum.Health
    getgenv().HpSnapshotTime = tick()
end

-- Hook: toda vez que LastAttackTime é atualizado em qualquer parte do script,
-- automaticamente tira o snapshot. Fazemos isso sobrescrevendo a variável
-- via um proxy simples no getgenv().
local _origLastAttackTime = getgenv().LastAttackTime or 0
local _snapshotProxy = {}
setmetatable(_snapshotProxy, {
    __newindex = function(_, k, v)
        rawset(_snapshotProxy, k, v)
        if k == "LastAttackTime" then
            TakeHpSnapshot()
        end
    end,
    __index = function(_, k)
        return rawget(_snapshotProxy, k)
    end
})

-- Como getgenv() é uma tabela global do executor, não podemos usar proxy direto,
-- então usamos um spawn que observa mudanças em LastAttackTime continuamente.
local _lastObservedAttackTime = getgenv().LastAttackTime or 0
spawn(function()
    while task.wait(0.05) do
        local cur = getgenv().LastAttackTime or 0
        if cur ~= _lastObservedAttackTime then
            _lastObservedAttackTime = cur
            TakeHpSnapshot()
        end
    end
end)

-- Verifica se o player alvo é realmente um player (não mob)
local function IsRealPlayer(plr)
    if not plr then return false end
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p == plr then return true end
    end
    return false
end

-- Retorna true se causamos dano: compara snapshot tirado no ataque com HP atual
local function DidWeDamageTarget()
    local t = getgenv().targ
    if not IsRealPlayer(t) then return false end
    if not t.Character then return false end
    local hum = t.Character:FindFirstChild("Humanoid")
    if not hum then return false end

    local snap     = getgenv().HpSnapshot
    local snapTime = getgenv().HpSnapshotTime
    if not snap or not snapTime then return false end

    local elapsed   = tick() - snapTime
    local maxRegen  = REGEN_RATE * elapsed     -- HP que poderia ter regenerado
    local hpNow     = hum.Health
    local netDrop   = snap - hpNow             -- positivo = HP caiu

    -- HP caiu mais do que a regen possível nesse intervalo = nós causamos dano
    return netDrop > maxRegen
end

-- Monitor global: perto do alvo, verifica continuamente se estamos causando dano
spawn(function()
    while task.wait(1) do
        pcall(function()
            local t  = getgenv().targ
            local me = game.Players.LocalPlayer

            -- Alvo inválido: limpa para forçar retarget
            if t and not IsValidPlayerTarget(t) then
                getgenv().targ            = nil
                getgenv().LastTargetHealth = nil
                getgenv().HpSnapshot      = nil
                getgenv().HpSnapshotTime  = nil
                return
            end

            if not t or not t.Character then return end
            local hum = t.Character:FindFirstChild("Humanoid")
            local hrp = t.Character:FindFirstChild("HumanoidRootPart")
            local myHrp = me.Character and me.Character:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp or not myHrp then return end

            local currentHealth = hum.Health
            local distance = (hrp.Position - myHrp.Position).Magnitude

            -- Longe do alvo: reseta contadores e aguarda chegar perto
            if distance > 80 then
                getgenv().LastTargetHealth = currentHealth
                getgenv().LastDamageTime   = tick()
                getgenv().OurDamageCount   = 0
                getgenv().EnvDamageCount   = 0
                return
            end

            -- Inicializa referência de HP
            if getgenv().LastTargetHealth == nil then
                getgenv().LastTargetHealth = currentHealth
                getgenv().LastDamageTime   = tick()
                return
            end

            local delta = currentHealth - getgenv().LastTargetHealth
            getgenv().LastTargetHealth = currentHealth

            if math.abs(delta) > 1 then
                getgenv().LastDamageTime = tick()

                -- Checagem precisa: usamos snapshot tirado no momento do ataque
                local weDidDamage = DidWeDamageTarget()

                -- Fallback: se snapshot não está disponível, usa janela de ataque clássica
                if not weDidDamage then
                    local attackWindow = tick() - (getgenv().LastAttackTime or 0)
                    weDidDamage = (delta < -1) and (attackWindow <= ATTACK_WINDOW) and (distance <= 25)
                end

                if weDidDamage then
                    -- Confirmado: nós causamos dano nesse player
                    getgenv().OurDamageCount = (getgenv().OurDamageCount or 0) + 1
                    getgenv().EnvDamageCount = 0
                    -- Reseta snapshot para o próximo ciclo
                    getgenv().HpSnapshot    = nil
                    getgenv().HpSnapshotTime = nil
                else
                    -- Caso especial: HP do alvo está SUBINDO e ainda não causamos
                    -- nenhum dano confirmado nele -> provavelmente está regenerando
                    -- de outra fonte (level up / cura / dano anterior). Troca direto.
                    if delta > 1 and (getgenv().OurDamageCount or 0) == 0 then
                        print("[Auto Bounty] HP do alvo subindo enquanto não causamos dano, trocando de player...")
                        getgenv().EnvDamageCount = 0
                        getgenv().HpSnapshot     = nil
                        getgenv().HpSnapshotTime  = nil
                        SkipPlayer()
                        return
                    end

                    -- HP mudou mas não foi dano nosso (regen, outro player, água, etc)
                    getgenv().EnvDamageCount = (getgenv().EnvDamageCount or 0) + 1

                    -- Se ainda não causamos NENHUM dano nesse player e já tivemos
                    -- várias mudanças de HP externas, é sinal que não estamos acertando
                    if (getgenv().OurDamageCount or 0) == 0 and getgenv().EnvDamageCount >= ENV_SKIP_COUNT then
                        print("[Auto Bounty] Alvo regenerando ou tomando dano externo sem dano nosso, pulando...")
                        getgenv().EnvDamageCount = 0
                        getgenv().HpSnapshot     = nil
                        getgenv().HpSnapshotTime  = nil
                        SkipPlayer()
                        return
                    end
                end
            else
                -- HP estável: se passou tempo demais perto sem causar dano, troca alvo
                if tick() - (getgenv().LastDamageTime or 0) > NO_DAMAGE_LIMIT then
                    print("[Auto Bounty] Sem dano no player por " .. NO_DAMAGE_LIMIT .. "s (perto), trocando...")
                    getgenv().HpSnapshot    = nil
                    getgenv().HpSnapshotTime = nil
                    SkipPlayer()
                end
            end
        end)
    end
end)

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
        if not IsValidPlayerTarget(getgenv().targ) then
            getgenv().targ = nil
        end
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
                                        local mainGui = GetMainGui()
                                        local skillsGui = mainGui and mainGui:FindFirstChild("Skills")
                                        local usedSkill = false
                                        if skillsGui and skillsGui:FindFirstChild(v.Name) then
                                            local skillFrame = skillsGui[v.Name]
                                            -- Skill X
                                            if getgenv().Setting.Fruit.X.Enable and skillFrame:FindFirstChild("X") and skillFrame.X.Cooldown.AbsoluteSize.X <= 0 then
                                                l = getgenv().Setting.Fruit.X.HoldTime
                                                getgenv().LastAttackTime = tick()
                                                down("X")
                                                usedSkill = true
                                            end
                                            -- Skill C
                                            if getgenv().Setting.Fruit.C.Enable and skillFrame:FindFirstChild("C") and skillFrame.C.Cooldown.AbsoluteSize.X <= 0 then
                                                l = getgenv().Setting.Fruit.C.HoldTime
                                                getgenv().LastAttackTime = tick()
                                                down("C")
                                                usedSkill = true
                                            end
                                        end
                                        if not usedSkill then
                                            getgenv().LastAttackTime = tick()
                                            Click()
                                        end
                                    end
                                end
                            end
                        else
                            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                                    local mainGui = GetMainGui()
                                    local skillsGui = mainGui and mainGui:FindFirstChild("Skills")
                                    local usedSkill = false
                                    if skillsGui and skillsGui:FindFirstChild(v.Name) then
                                        local skillFrame = skillsGui[v.Name]
                                        -- Skill X
                                        if getgenv().Setting.Fruit.X.Enable and skillFrame:FindFirstChild("X") and skillFrame.X.Cooldown.AbsoluteSize.X <= 0 then
                                            l = getgenv().Setting.Fruit.X.HoldTime
                                            getgenv().LastAttackTime = tick()
                                            down("X")
                                            usedSkill = true
                                        end
                                        -- Skill C
                                        if getgenv().Setting.Fruit.C.Enable and skillFrame:FindFirstChild("C") and skillFrame.C.Cooldown.AbsoluteSize.X <= 0 then
                                            l = getgenv().Setting.Fruit.C.HoldTime
                                            getgenv().LastAttackTime = tick()
                                            down("C")
                                            usedSkill = true
                                        end
                                    end
                                    if not usedSkill then
                                        getgenv().LastAttackTime = tick()
                                        Click()
                                    end
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
        if not IsValidPlayerTarget(getgenv().targ) then
            getgenv().targ = nil
        end
        if getgenv().targ == nil then target() end
        pcall(function()
            -- Se estiver perseguindo o mesmo alvo há mais de 30s e ainda longe, pula para outro
            if getgenv().targ and getgenv().TargetStartTime then
                local elapsed = tick() - getgenv().TargetStartTime
                if elapsed > 30 then
                    local myChar = game.Players.LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local tChar = getgenv().targ.Character
                    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    if myHrp and tHrp then
                        local dist = (tHrp.Position - myHrp.Position).Magnitude
                        -- Só considera "demorou demais para chegar" se ainda estiver relativamente longe
                        if dist > 60 then
                            print("[Auto Bounty] Demorou mais de 30s para chegar no alvo, pulando...")
                            SkipPlayer()
                            return
                        end
                    end
                end
            end

            -- Se estiver em modo seguro, não se move até o alvo
            if getgenv().SafeMode then
                return
            end
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > getgenv().Setting.SafeHealth.Health then
                    if getgenv().targ.Character.Humanoid.Health > 0 then
                        local distance = (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude
                        if distance < 40 then
                            topos(CFrame.new(getgenv().targ.Character.HumanoidRootPart.Position + getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 5, getgenv().targ.Character.HumanoidRootPart.Position))
                        else
                            topos(getgenv().targ.Character.HumanoidRootPart.CFrame*CFrame.new(0,10,0))
                        end
                    else
                        print("[Auto Bounty] Alvo morreu, procurando novo...")
                        SkipPlayer()
                    end
                end
            end
        end)
    end
end)

print("[Auto Bounty] Farm iniciado com sucesso!")
print("[Auto Bounty] Procurando alvos...")
print("[Auto Bounty] Sistema de combate ativado!")
