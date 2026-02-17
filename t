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
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
_G.Seriality = true

local function CanHopServer()
    local gui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if gui then
        local main = gui:FindFirstChild("Main")
        if main and main:FindFirstChild("InCombat") then
            local inCombat = main.InCombat
            if inCombat.Visible then
                local txt = string.lower(inCombat.Text or "")
                if string.find(txt, "risk") then
                    -- Quando está com Bounty Risk na tela, não pode hopar
                    return false
                end
            end
        end
    end
    return true
end

local function HopServer()
    pcall(function()
        local placeId = game.PlaceId
        local currentJobId = game.JobId
        local cursor = nil
        for _ = 1, 5 do
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor and ("&cursor=" .. cursor) or "")
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            if not success or not result or not result.data then break end

            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                    return
                end
            end

            if result.nextPageCursor then
                cursor = result.nextPageCursor
            else
                break
            end
        end
    end)
end

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
getgenv().NoTargetTime = nil
getgenv().DashEnabled = true
getgenv().Status = "Iniciando..."
wait(1)

-- Painel simples de debug na tela para ver o estado do script
task.spawn(function()
    pcall(function()
        local player = game.Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")
        local gui = pg:FindFirstChild("AutoBountyDebug")
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "AutoBountyDebug"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.Parent = pg
        end

        local label = gui:FindFirstChild("StatusLabel")
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "StatusLabel"
            label.Size = UDim2.new(0, 350, 0, 22)
            label.Position = UDim2.new(0, 10, 0, 10)
            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.BackgroundTransparency = 0.4
            label.BorderSizePixel = 0
            label.TextColor3 = Color3.fromRGB(0, 255, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.SourceSans
            label.TextSize = 16
            label.Parent = gui
        end

        while task.wait(0.3) do
            pcall(function()
                label.Text = "[Auto Bounty] " .. (getgenv().Status or "Sem status")
            end)
        end
    end)
end)

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
    elseif y == 7449423635 then
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
            -- Temple Of Time existe, mas não deve ser usado para alvos no chão
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
            -- Cancela qualquer tween antigo para permitir atualização em tempo real
            if tween then
                pcall(function() tween:Cancel() end)
            end
            if not TweenSpeed then
                TweenSpeed = 200 -- velocidade base mais baixa para evitar kick
            end
            local DefualtY = Tween_Pos.Y
            local TargetY = Tween_Pos.Y
            local targetCFrameWithDefualtY = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
            local targetPos = Tween_Pos.Position
            local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local Distance = (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude

            -- Se estiver longe do alvo, tenta usar teleporte mais próximo antes do tween
            if Distance > 1500 then
                local aM = CheckNearestTeleporter(Tween_Pos)
                if aM then
                    pcall(function()
                        if tween then tween:Cancel() end
                    end)
                    requestEntrance(aM)
                    -- Recalcula posição e distância após o teleporte
                    targetPos = Tween_Pos.Position
                    Distance = (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
                end
            end
            local b1 = CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                DefualtY,
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
            )
            local IngoreY = true
            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    DefualtY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local travelTime = math.clamp(Distance / TweenSpeed, 0.5, 3)
                local aO = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = targetCFrameWithDefualtY}
                )
                tween:Play()
                -- Enquanto estiver usando o tween, ficar apertando Q para dash (apenas se DashEnabled)
                local thisTween = tween
                task.spawn(function()
                    while thisTween and thisTween.PlaybackState == Enum.PlaybackState.Playing do
                        if getgenv().DashEnabled ~= false then
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
                            end)
                        end
                        task.wait(0.25)
                    end
                end)
                function tweenfunc:Stop()
                    tween:Cancel()
                end
            else
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local travelTime = math.clamp(Distance / TweenSpeed, 0.5, 3)
                local aO = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = Tween_Pos}
                )
                tween:Play()
                -- Enquanto estiver usando o tween, ficar apertando Q para dash (apenas se DashEnabled)
                local thisTween = tween
                task.spawn(function()
                    while thisTween and thisTween.PlaybackState == Enum.PlaybackState.Playing do
                        if getgenv().DashEnabled ~= false then
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
                            end)
                        end
                        task.wait(0.25)
                    end
                end)
                function tweenfunc:Stop()
                    tween:Cancel()
                end
            end
        end
    end)
end

-- Sistema ÚNICO de movimento: teleporta para o local mais próximo
-- (quando muito longe) e usa tween para seguir e ficar em cima/do lado do alvo
function MoveToTarget(targetPlayer)
    local success, result = pcall(function()
        if not targetPlayer then return end

        local lp = game.Players.LocalPlayer
        if not lp or not lp.Character then return end

        local myHum = lp.Character:FindFirstChild("Humanoid")
        local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
        if not myHum or not myRoot or myHum.Health <= 0 then return end

        if not targetPlayer.Character then return end
        local enemyHum = targetPlayer.Character:FindFirstChild("Humanoid")
        local enemyRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not enemyHum or not enemyRoot or enemyHum.Health <= 0 then return end

        local distance = (enemyRoot.Position - myRoot.Position).Magnitude

        -- Se estiver bem longe do alvo, usar teleporte para o local mais próximo
        if distance > 1500 then
            local tpPos = CheckNearestTeleporter(enemyRoot.CFrame)
            if tpPos then
                if tween then
                    pcall(function() tween:Cancel() end)
                end
                requestEntrance(tpPos)
                task.wait(0.2)

                -- Atualiza referências após teleporte
                if not lp.Character then return end
                myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                enemyRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot or not enemyRoot then return end
                distance = (enemyRoot.Position - myRoot.Position).Magnitude
            end
        end

        -- Define posição alvo: sempre acima do inimigo, mudando só a altura
        local goalCFrame
        local isNear = false

        if distance < 40 then
            -- Perto: posiciona logo acima do inimigo
            isNear = true
            getgenv().DashEnabled = false
            local offsetPos = enemyRoot.Position + Vector3.new(0, 7, 0)
            goalCFrame = CFrame.new(offsetPos, enemyRoot.Position)
        else
            -- Longe: fica um pouco mais alto acima do inimigo
            isNear = false
            getgenv().DashEnabled = true
            goalCFrame = enemyRoot.CFrame * CFrame.new(0, 12, 0)
        end

        -- Cancela tween antigo e cria um novo para ir até a posição escolhida
        if tween then
            pcall(function() tween:Cancel() end)
        end

        if not TweenSpeed then
            TweenSpeed = 200 -- mais baixo para reduzir velocidade
        end

        local travelTime = math.clamp(distance / TweenSpeed, 0.5, 3)
        local tweenService = game:GetService("TweenService")
        local info = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)

        tween = tweenService:Create(myRoot, info, {CFrame = goalCFrame})
        tween:Play()

        -- Enquanto o tween estiver rodando, ficar spammando Q (dash) se habilitado
        local thisTween = tween
        task.spawn(function()
            while thisTween and thisTween.PlaybackState == Enum.PlaybackState.Playing do
                    -- Dash desativado temporariamente para evitar kick por velocidade
                    task.wait(0.4)
                end
        end)

        return distance, isNear
    end)

    if success then
        return result
    end
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
    if getgenv().targ and getgenv().targ.Name then
        getgenv().Status = "Pulando alvo: " .. tostring(getgenv().targ.Name)
    else
        getgenv().Status = "Pulando alvo atual"
    end
    getgenv().targ = nil
    target()
end

function target() 
    pcall(function()
        d = math.huge
        p = nil
        getgenv().targ = nil
        getgenv().Status = "Buscando alvo..."
        for i, v in pairs(game.Players:GetPlayers()) do 
            if v.Team ~= nil and (tostring(lp.Team) == "Pirates" or (tostring(v.Team) == "Pirates" and tostring(lp.Team) ~= "Pirates")) then
                if v and v:FindFirstChild("Data") and ((getgenv().Setting.Skip.Fruit and hasValue(getgenv().Setting.Skip.FruitList, v.Data.DevilFruit.Value) == false) or not getgenv().Setting.Skip.Fruit) then
                    if v ~= lp and v ~= getgenv().targ and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position).Magnitude < d and hasValue(getgenv().checked, v) == false and v.Character.HumanoidRootPart.CFrame.Y <= 12000 then
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
            -- Nenhum alvo: zera lista e começa a contar tempo sem alvo
            getgenv().checked = {}
            getgenv().targ = nil
            if not getgenv().NoTargetTime then
                getgenv().NoTargetTime = tick()
            end
            local elapsed = tick() - (getgenv().NoTargetTime or tick())
            getgenv().Status = string.format("Sem alvo (%.0fs)", elapsed)
            if tick() - getgenv().NoTargetTime > 20 then
                if CanHopServer() then
                    print("[Auto Bounty] Nenhum alvo por muito tempo, trocando de servidor...")
                    HopServer()
                end
            end
        else
            getgenv().targ = p

            -- Resetar contador de tempo sem alvo
            getgenv().NoTargetTime = nil

            if getgenv().targ and getgenv().targ.Name then
                getgenv().Status = "Alvo: " .. tostring(getgenv().targ.Name)
            else
                getgenv().Status = "Alvo definido"
            end

            -- Quando escolhe um novo alvo, inicia controle básico de HP
            if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("Humanoid") then
                getgenv().LastTargetHealth = getgenv().targ.Character.Humanoid.Health
                getgenv().LastDamageTime = tick()
            else
                getgenv().LastTargetHealth = nil
            end
        end
    end)
end

-- Monitor global: se estivermos PERTO do alvo e o HP dele não mudar
-- por alguns segundos, pula para o próximo inimigo
spawn(function()
    while task.wait(1) do
        pcall(function()
            local t = getgenv().targ
            local me = game.Players.LocalPlayer
            if t and t.Character and t.Character:FindFirstChild("Humanoid")
               and me.Character and me.Character:FindFirstChild("HumanoidRootPart")
               and t.Character:FindFirstChild("HumanoidRootPart") then

                local currentHealth = t.Character.Humanoid.Health
                local distance = (t.Character.HumanoidRootPart.Position - me.Character.HumanoidRootPart.Position).Magnitude

                -- Só conta "sem dano" quando estamos relativamente perto do alvo
                if distance > 80 then
                    getgenv().LastTargetHealth = currentHealth
                    getgenv().LastDamageTime = tick()
                    return
                end

                if getgenv().LastTargetHealth == nil then
                    getgenv().LastTargetHealth = currentHealth
                    getgenv().LastDamageTime = tick()
                else
                    if currentHealth ~= getgenv().LastTargetHealth then
                        -- Qualquer mudança de HP (mesmo pequena) reseta o timer
                        getgenv().LastTargetHealth = currentHealth
                        getgenv().LastDamageTime = tick()
                    else
                        -- HP parado e estamos perto: se passou muito tempo, troca alvo
                        if tick() - (getgenv().LastDamageTime or 0) > 5 then
                            print("[Auto Bounty] Sem dano recente no alvo (perto), trocando de inimigo...")
                            getgenv().Status = "Sem dano no alvo, trocando..."
                            SkipPlayer()
                        end
                    end
                end
            else
                getgenv().LastTargetHealth = nil
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
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 60 then 
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
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 60 then 
                    spawn(function()
                        if not gunmethod then
                            equip(getgenv().weapon)
                            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
                                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                                    if getgenv().Setting.Fruit.Enable then
                                        local skillsGui = game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Skills")
                                        if skillsGui and skillsGui:FindFirstChild(v.Name) and skillsGui[v.Name]:FindFirstChild("C") and skillsGui[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and getgenv().Setting.Fruit.C.Enable then
                                            l = getgenv().Setting.Fruit.C.HoldTime
                                            down("C")
                                        else
                                            Click()
                                        end
                                    end
                                end
                            end
                        else
                            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                                    local skillsGui = game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Skills")
                                    if skillsGui and skillsGui:FindFirstChild(v.Name) and skillsGui[v.Name]:FindFirstChild("C") and skillsGui[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and getgenv().Setting.Fruit.C.Enable then
                                        l = getgenv().Setting.Fruit.C.HoldTime
                                        down("C")
                                    else
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
        if getgenv().targ == nil then target() end
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > getgenv().Setting.SafeHealth.Health then
                    if getgenv().targ.Character.Humanoid.Health > 0 then
                        local distance, isNear = MoveToTarget(getgenv().targ)
                        if getgenv().targ and getgenv().targ.Name and distance then
                            if isNear then
                                getgenv().Status = string.format("Atacando: %s (%.0f)", getgenv().targ.Name, distance)
                            else
                                getgenv().Status = string.format("Indo até: %s (%.0f)", getgenv().targ.Name, distance)
                            end
                        end
                    else
                        print("[Auto Bounty] Alvo morreu, procurando novo...")
                        getgenv().Status = "Alvo morreu, trocando..."
                        SkipPlayer()
                    end
                else
                    -- Health baixa: apenas troca de alvo, sem subir para o céu
                    print("[Auto Bounty] Health baixa, trocando de alvo...")
                    getgenv().Status = "HP baixo, trocando alvo"
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
