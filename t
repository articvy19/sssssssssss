if not CombatFrameworkR then
    CombatFrameworkR = {activeController = nil}
end
_G.Setting = {
    ["Webhook"] = {
        ["Enabled"] = false,
        ["Url Webhook"] = "Webhook Here",
    },
    ["Misc"] = {
        ["AutoBuyRandomandStoreFruit"] = true,
        ["AutoBuySurprise"] = true,
    },
    ["Click"] = {
        ["Enable"] = true,
        ["Click Gun"] = true,
        ["OnLowHealthDisable"] = true,
        ["LowHealth"] = 4500,
    },
    ["SafeZone"] = {
        ["Enable"] = true,
        ["LowHealth"] = 4500,
        ["MaxHealth"] = 5000,
        ["Teleport Y"] = 200
    },
    ["Race V4"] = {
        ["Enable"] = true,
    },
    ["Invisible"] = false,
    ["White Screen"] = false,
    ["GunMethod"] = true, --Support Only Melee And Gun,Not Invisible, Turn On Enabled Gun and Melee Please
    ["SpamSkill"] = false, -- Will use all skills as fast as possbile ignore holding skills
    ["Weapons"] = {
        ["Melee"] = {
            ["Enable"] = true,
            ["Delay"] = 3,
            ["Skills"] = {
                ["Z"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },

                ["C"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },
            },
        },
        ["Blox Fruit"] = {
            ["Enable"] = false,
            ["Delay"] = 1,
            ["Skills"] = {
                ["Z"] = {
                    ["Enable"] = false,
                    ["HoldTime"] = 0,
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },

                ["C"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },
                ["V"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },
                ["F"] = {
                    ["Enable"] = false,
                    ["HoldTime"] = 0,
                },
            },
        },
        ["Gun"] = {
            ["Enable"] = true,
            ["Delay"] = 2,
            ["Skills"] = {
                ["Z"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0.7,
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0.7,
                },
            },
        },
        ["Sword"] = {
            ["Enable"] = false,
            ["Delay"] = 1,
            ["Skills"] = {
                ["Z"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 1,
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["HoldTime"] = 0,
                },
            },
        },
    }
}

local meleePath = _G.Setting["Weapons"].Melee
local meleeSkills = meleePath["Skills"]

local bfPath = _G.Setting["Weapons"]["Blox Fruit"]
local bfSkills = bfPath["Skills"]

local gunPath = _G.Setting["Weapons"]["Gun"]
local gunSkills = gunPath["Skills"]

local swordPath = _G.Setting["Weapons"]["Sword"]
local swordSkills = swordPath["Skills"]

local weaponTypes = {"Melee", "Sword", "Gun", "Blox Fruit"}

-- Hàm tính khoảng cách giữa hai Vector3

function GetDistance(position1, position2)
    print("Entrou em GetDistance")
    return (position1 - position2).Magnitude
end

function GetNearestPlayer()
    print("Entrou em GetNearestPlayer")
    local Playerss = game:GetService("Players")
    local Client = Playerss.LocalPlayer
    local nearestObject = nil
    blacklistedCount = 0

    for _, object in pairs(Playerss:GetPlayers()) do
        if object ~= Client and object.Character then
            if object.Team ~= nil then
                if not Players.IsPlayerBlacklisted(object.Name) then
                    if PlayerTracker.IsPlayerDead(object) then
                        Players.AddToBlacklist(object.Name)
                        blacklistedCount = blacklistedCount + 1
                    elseif PlayerTracker.IsPlayerLeavingGame(object) then
                        Players.AddToBlacklist(object.Name)
                        blacklistedCount = blacklistedCount + 1
                    else
                        local playerHRP = object.Character:FindFirstChild("HumanoidRootPart")
                        local clientHRP = Client.Character:FindFirstChild("HumanoidRootPart")

                        if playerHRP and clientHRP then
                            local distance = GetDistance(playerHRP.Position, clientHRP.Position)
                            if distance < 15000 then
                                nearestObject = object
                            end
                        end
                    end
                else
                    blacklistedCount = blacklistedCount + 1
                end
            end
        end

        if blacklistedCount == #Playerss:GetPlayers() then
            Players.RemoveFromBlacklist(object)
        end
    end

    return nearestObject
end

function listAllPlayers(mode)
    print("Entrou em listAllPlayers")
    local names = {}
    
    if mode == "Player" then
        for _, player in ipairs(Playerss:GetPlayers()) do
            if player ~= Client and player.Character then
                table.insert(names, player.Name)
            end
        end
    elseif mode == "NPC" then
        local replicatedStorage = game:GetService("ReplicatedStorage")
        
        for _, npc in pairs(replicatedStorage:GetChildren()) do
            if npc:IsA("Model") and npc.Name ~= "BusoTemplate" then
                table.insert(names, npc.Name)
            end
        end
    end
    
    return names
end

function markTargets(mode)
    print("Entrou em markTargets")
    if mode == "Player" and Options.TargetPPL then
        local markedObject = nil
        local minDistance = math.huge
        local blacklistedCount = 0

        local selectedPlayers = {}
        for key, _ in pairs(Options.TargetPPL.Value) do
            table.insert(selectedPlayers, key)
        end

        for i, value in ipairs(selectedPlayers) do
            local object = Playerss:FindFirstChild(value)
            if object and not Players.IsPlayerBlacklisted(object.Name) then
                if PlayerTracker.IsPlayerDead(object) then
                    Players.AddToBlacklist(object.Name)
                    blacklistedCount = blacklistedCount + 1
                elseif PlayerTracker.IsPlayerLeavingGame(object) then
                    Players.AddToBlacklist(object.Name)
                    blacklistedCount = blacklistedCount + 1
                else
                    local distance = GetDistance(Client.Character.HumanoidRootPart.Position, object.Character.HumanoidRootPart.Position)
                    if not markedObject or distance < minDistance then
                        markedObject = object
                        minDistance = distance
                    end
                end
            else
                blacklistedCount = blacklistedCount + 1
            end
        end

        if blacklistedCount == #selectedPlayers then
            for _, player in ipairs(selectedPlayers) do
                Players.RemoveFromBlacklist(player)
            end
        end

        return markedObject
    elseif mode == "NPC" and Options.TargetNPC.Value then
        local markedObject = nil
        local minDistance = math.huge
    
        for i, value in pairs(game.ReplicatedStorage:GetChildren()) do
            if value:IsA("Model") and value.Name ~= "BusoTemplate" and value.Name == Options.TargetNPC.Value then 
                local distance = GetDistance(Client.Character.HumanoidRootPart.Position, value.HumanoidRootPart.Position)
                if not markedObject or distance < minDistance then
                    markedObject = value
                    minDistance = distance
                end
            end
        end

        return markedObject
    end
end

local Module = {}
function Module.Invisible(bool)
    print("Entrou em Module.Invisible")
    
    local function CheckRig()
        if Client.Character then
            local Humanoid = Client.Character:WaitForChild("Humanoid")
            if Humanoid.RigType == Enum.HumanoidRigType.R15 then
                return "R15"
            else
                return "R6"
            end
        end
    end

    local function InitiateInvis()
        local StoredCF = Client.Character.PrimaryPart.CFrame
    
        if CheckRig() == "R6" then
            Client.Character.HumanoidRootPart:Destroy()
            else
                if Client.Character:FindFirstChild("LowerTorso") and Client.Character.LowerTorso:FindFirstChild("Root") then
                    Client.Character.LowerTorso.Root:Destroy()
                else
                    print("LowerTorso ou Root não encontrado!")
                end
        end
    
    end

    local function Invisible(bool)
        if bool then
            if Client.Character:WaitForChild("Humanoid").Health == 0 then 
                repeat wait() 
                until Client.Character:WaitForChild("Humanoid").Health > 0; 
                wait(0.2) 
            end
        
            if Client.Character:FindFirstChild("CharacterReady") then
                Client.Character.CharacterReady:Destroy()
                Client.Character.HumanoidRootPart.InfoBBG.Frame:Destroy()
            end
            
            if Client.Character.UpperTorso:FindFirstChild("BuddhaBillboard") then
                Client.Character.UpperTorso.BuddhaBillboard:Destroy()
            end
            
            local cframeold = Client.Character.HumanoidRootPart.CFrame
            
            Client.Character.HumanoidRootPart.CFrame = Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10000000, 0)
            wait(0.65)
            InitiateInvis()
            Client.Character.HumanoidRootPart.CFrame = cframeold
        end
    end

    Invisible(bool)
end

function Module.Spectate(enabled, object)
    print("Entrou em Module.Spectate")
    -- Hàm để bật/tắt chế độ xem người chơi khác
    local function SetViewPlayerMode(enabled, object)
        if enabled and Options["InMode"].Value == "Reality" then
            if not Players.IsPlayerBlacklisted(object.Name) then
                if object and object.Character then
                    -- Đặt camera vào object
                    workspace.CurrentCamera.CameraSubject = object.Character.Humanoid
                end
            else
                workspace.CurrentCamera.CameraSubject = Client.Character["Humanoid"]
            end
        else
            if Client.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = Client.Character["Humanoid"]
            end
        end
    end
    -- Gọi hàm SetViewPlayerMode với giá trị enabled là true để bật xem người chơi và object là người chơi cần xem
    SetViewPlayerMode(enabled, object)
end

function IsInCombat(mode)
    print("Entrou em IsInCombat")
    local text = Client.PlayerGui.Main.InCombat.Text
    local Notifications = Client.PlayerGui.Notifications

    if mode == "Honor/BountyAtRisk" and string.find(text, "risk") then
        return Client.PlayerGui.Main.InCombat.Visible
    elseif mode == "InCombat" and not string.find(text, "risk") then
        return Client.PlayerGui.Main.InCombat.Visible
    elseif mode == "CannotAttack" and Notifications:FindFirstChild("NotificationTemplate") then
        return string.find(Notifications.NotificationTemplate.Text, "died")
    end

    return false
end

function checkHealthChange(object, duration)
    print("Entrou em checkHealthChange")
    local humanoid = object and object:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end
    
    local initialHealth = humanoid.Health
    
    local startTime = os.time()
    
    while os.time() - startTime < duration do
        if not humanoid.Parent or humanoid.Health ~= initialHealth then
            return true
        end
        
        wait(1)
    end
    return false
end

function AutoBlacklistPlayer(object, seconds, distance)
    print("Entrou em AutoBlacklistPlayer")
    local startTime = tick()
    
    repeat
        if (object.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= distance then
            if Toggles.ClickEnabled.Value then
                if checkHealthChange(object, 5) then
                    if IsInCombat("CannotAttack") then
                        Players.AddToBlacklist(object.Name) -- Thêm người chơi vào danh sách đen
                        UI:Notify("Added object to blacklist: " .. object.Name .. ".", 2)
                        break
                    else
                        local elapsedTime = tick() - startTime
                        local remainingTime = seconds - elapsedTime
                        UI:Notify("Ended Combat In: " .. remainingTime .. ".", 1.25)
        
                        if remainingTime <= 0 then
                            Players.AddToBlacklist(object.Name) -- Thêm người chơi vào danh sách đen
                            UI:Notify("Added object to blacklist: " .. object.Name .. ".", 2)
                            break
                        end
                    end
                end
            else
                if checkHealthChange(object, 15) then
                    Players.AddToBlacklist(object.Name) -- Thêm người chơi vào danh sách đen
                    UI:Notify("Added object to blacklist: " .. object.Name .. ".", 2)
                    break
                end
            end
        
        end
        wait(1)
    until PlayerTracker.IsPlayerDead(object) or PlayerTracker.IsPlayerLeavingGame(object) or not (Toggles["AutoBounty"].Value or Toggles.Spectate.Value)
end

function SendKey(Key, Hold)
    print("Entrou em SendKey")
    coroutine.resume(coroutine.create(function()
        VIM:SendKeyEvent(true, Key, false, nil)
        wait(Hold)
        VIM:SendKeyEvent(false, Key, false, nil)
    end))
end

function DisableCollisions(object, enable)
    print("Entrou em DisableCollisions")
    local parts = object.Character:GetDescendants()

    -- Tạo danh sách batch chứa các BasePart cần được thay đổi
    local batch = {}
    local batchSize = 0

    for _, v in ipairs(parts) do
        if v:IsA("BasePart") then
            table.insert(batch, v)
            batchSize = batchSize + 1

            -- Bắt đầu batch khi kích thước đạt ngưỡng
            if batchSize >= 100 then
                for _, part in ipairs(batch) do
                    part.CanCollide = enable
                end
                batch = {}
                batchSize = 0
            end
        end
    end

    -- Xử lý các thành phần trong batch cuối cùng (nếu còn)
    for _, part in ipairs(batch) do
        part.CanCollide = enable
    end
end

function CheckHeight(part)
    print("Entrou em CheckHeight")
    local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")

    if part and hrp then
        local distanceThreshold = 50

        local distance = hrp.Position.Y - part.Position.Y
        if distance <= distanceThreshold then
            hrp.CFrame = hrp.CFrame * CFrame.new(0,100,0)
        end
    end
end

function GetIsLand(...)
    print("Entrou em GetIsLand")
	local RealtargetPos = {...}
	local targetPos = RealtargetPos[1]
	local RealTarget
	if type(targetPos) == "vector" then
		RealTarget = targetPos
	elseif type(targetPos) == "userdata" then
		RealTarget = targetPos.Position
	elseif type(targetPos) == "number" then
		RealTarget = CFrame.new(unpack(RealtargetPos))
		RealTarget = RealTarget.p
	end

	local ReturnValue
	local CheckInOut = math.huge;
	if Client.Team then
		for i,v in pairs(workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(Client.Team)):GetChildren()) do 
			local ReMagnitude = (RealTarget - v:GetModelCFrame().p).Magnitude;
			if ReMagnitude < CheckInOut then
				CheckInOut = ReMagnitude;
				ReturnValue = v.Name
			end
		end
		if ReturnValue then
			return ReturnValue
		end 
	end
end

function selectSpawnPoint(object)
    print("Entrou em selectSpawnPoint")
    local closestSpawn = nil
    local closestDistance = math.huge
    
    for _, model in pairs(workspace["_WorldOrigin"].PlayerSpawns[tostring(Client.Team)]:GetChildren()) do
        if model:IsA("Model") then
            for _, spawn in pairs(model:GetChildren()) do
                if spawn:IsA("Part") then
                    if object and spawn then
                        local distance = (spawn.Position - object.Position).Magnitude
                    
                        if distance < closestDistance then
                            closestSpawn = spawn
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestSpawn
end

function bypassTeleport(tween, object, distance, distanceValue)
    print("Entrou em bypassTeleport")
    if Toggles.AutoBounty.Value and Toggles["BypassTP"].Value then
        if not IsInCombat("Honor/BountyAtRisk") then
            if distance <= distanceValue then
                if tween then
                    tween:Play()
                end
            else
                if tween then
                    tween:Cancel()
                end
                fkwarp = false
                if Client.Data:FindFirstChild("LastSpawnPoint").Value == tostring(GetIsLand(object)) then
                    Client.Character:WaitForChild("Humanoid"):ChangeState(15)
                    wait(0.1)
                    repeat wait() until Client.Character:WaitForChild("Humanoid").Health > 0
                else
                    if Client.Character:WaitForChild("Humanoid").Health > 0 then
                        local elapsedTime = 0

                        local heartbeatConnection
                        local function onUpdate(deltaTime)
                            elapsedTime = elapsedTime + deltaTime
                            Client.Character.HumanoidRootPart.CFrame = selectSpawnPoint(object).CFrame
                            Com("F_", "SetSpawnPoint")
                            if (Options.CompareElapsedTime and elapsedTime >= tonumber(Options.CompareElapsedTime.Value)) or fkwarp == true then
                                heartbeatConnection:Disconnect()
                            end
                        end
                        
                        heartbeatConnection = runService.Heartbeat:Connect(onUpdate)

                        fkwarp = true
                    end
                    wait(tonumber(Options["Reset Time"].Value))
                    Client.Character:WaitForChild("Humanoid"):ChangeState(15)
                    repeat wait() until Client.Character:WaitForChild("Humanoid").Health > 0
                    wait(0.1)
                    Com("F_", "SetSpawnPoint")
                end
            end
            wait(0.2)

            return
        end
    end
end

function TweenService2(...)
    print("Entrou em TweenService2")
    local tweenfunc = {}
    local RealtargetPos = {...}
    local targetPos = RealtargetPos[1]
    local RealTarget

    if type(targetPos) == "vector" then
        RealTarget = CFrame.new(targetPos)
    elseif type(targetPos) == "userdata" then
        RealTarget = targetPos
    elseif type(targetPos) == "number" then
        RealTarget = CFrame.new(unpack(RealtargetPos))
    end

    if PlayerTracker.IsPlayerDead(Client) then 
        if tween then tween:Cancel() end 
        repeat wait() until Client.Character:WaitForChild("Humanoid").Health > 0 
        wait(0.75)
    end

    local Distance = GetDistance(Client.Character:WaitForChild("HumanoidRootPart").Position, RealTarget.Position)

    if Distance <= 150 then
        pcall(function()
            if tween then
                tween:Cancel()
            end
            Client.Character.HumanoidRootPart.CFrame = RealTarget
            return
        end)
    end

    bypassTeleport(tween, RealTarget, Distance, 500)

    local cameraPart = game:GetService("Workspace").Camera.Part
    if Distance > 1000 then
        CheckHeight(cameraPart)
    end

    DisableCollisions(Client, false)

    local info = TweenInfo.new(Distance / 315, Enum.EasingStyle.Linear)

    local tween = game:GetService("TweenService"):Create(Client.Character.HumanoidRootPart, info, {CFrame = RealTarget})
    tween:Play()

    function tweenfunc:Cancel()
        if tween then
            tween:Cancel()
        end
        
        DisableCollisions(Client, true)
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

function GetCurrentHealth(object, compareValue)
    print("Entrou em GetCurrentHealth")
    local character = object
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            if compareValue then
                return currentHealth <= compareValue
            else
                return currentHealth
            end
        end
    end
    return false -- Trả về false nếu không tìm thấy người chơi hoặc humanoid
end

function CheckHealthChange(tween)
    print("Entrou em CheckHealthChange (tween)")
    if Client.Character then
        local hrp = Client.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = Client.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            local healthLimited = 13095

            local previousHealth = humanoid.Health

            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                local currentHealth = humanoid.Health

                if (previousHealth - currentHealth) < healthLimited then
                    local targetY = 650 -- Giá trị Y mục tiêu
                    if tween then
                        tween:Pause()
                        while hrp.Position.Y < targetY and Toggles.AutoBounty.Value do
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 100, 0)
                            task.wait()
                        end

                        if hrp.Position.Y >= targetY then
                            if type(tween) == "table" and tween.Play then
                                tween:Play()
                            end
                        end

                        wait(5)
                    end
                end

                previousHealth = currentHealth
            end)
        end
    end
end

function Com(com,...)
    print("Entrou em Com")
	local Remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Comm"..com)
	if Remote:IsA("RemoteEvent") then
		Remote:FireServer(...)
	elseif Remote:IsA("RemoteFunction") then
		Remote:InvokeServer(...)
	end
end

function AutoBuso()
    print("Entrou em AutoBuso")
	if not Client.Character:FindFirstChild("HasBuso") then
        Com("F_", "Buso")
	end
end

function Race(Option, object)
    print("Entrou em Race")
    if Option == "V3" then
        if not PlayerTracker.IsPlayerLeavingGame(object) and PlayerTracker.IsPlayerDead(object) and (Client.Character and object) then
            local clientHRP = Client.Character:WaitForChild("HumanoidRootPart")
            local targetHRP = object:WaitForChild("HumanoidRootPart")

            local distance = (clientHRP.Position - targetHRP.Position).Magnitude

            if distance <= 50 then
                Com("E", "ActivateAbility")
            end
        end
    elseif Option == "V4" then
        local raceEnergy = Client.Character:FindFirstChild("RaceEnergy")
        local raceTransformed = Client.Character:FindFirstChild("RaceTransformed")
        local awakening = Client.Backpack:FindFirstChild("Awakening")
    
        if raceEnergy and raceEnergy.Value == 1 then
            if raceTransformed and not raceTransformed.Value then
                local bool = true
                if awakening and awakening:IsA("RemoteFunction") then
                    awakening:InvokeServer(bool)
                end
            end
        end
    end
end

local Main = {
    ["Melee"] = {
        Cooldown = {Z = nil, X = nil, C = nil}
    },
    ["Blox Fruit"] = {
        Cooldown = {Z = nil, X = nil, C = nil, V = nil}
    },
    ["Gun"] = {
        Cooldown = {Z = nil, X = nil}
    },
    ["Sword"] = {
        Cooldown = {Z = nil, X = nil}
    },
}

function GetCooldown()
    print("Entrou em GetCooldown")
    for _, v in pairs(Client.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Blox Fruit" or v.ToolTip == "Gun" or v.ToolTip == "Sword") then
            local cdreq = require(v.Data)
            local toolType = Main[v.ToolTip]

            if toolType then
                for k, v1 in pairs(cdreq.Cooldown) do
                    toolType.Cooldown[k] = v1
                end
            end
        end
    end
end

function FastLoadW()
    print("Entrou em FastLoadW")
    local cooldowns = {
        ["Melee"] = Main.Melee.Cooldown,
        ["Blox Fruit"] = Main["Blox Fruit"].Cooldown,
        ["Gun"] = Main.Gun.Cooldown,
        ["Sword"] = Main.Sword.Cooldown
    }

    for _, v in ipairs(Client.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            local tooltip = v.ToolTip
            if cooldowns[tooltip] then
                local cdreq = require(v.Data)
                local cd1 = cdreq.Cooldown
                for k, v1 in pairs(cd1) do
                    cooldowns[tooltip][k] = v1
                end
            end

            local ToolHumanoid = Client.Backpack:FindFirstChild(v.Name)
            if ToolHumanoid then
                Client.Character:WaitForChild("Humanoid"):EquipTool(ToolHumanoid)
                v.Parent = Client.Backpack
            end
        end
    end
end

function CheckCooldown(mode, key)
    print("Entrou em CheckCooldown")
    local weaponSkills = {
        Melee = {"Z", "X", "C"},
        ["Blox Fruit"] = {"Z", "X", "C", "V"},
        Gun = {"Z", "X"},
        Sword = {"Z", "X"},
    }

    local weapons = {}
    for _, v1 in ipairs(Client.Character:GetChildren()) do
        if v1:IsA("Tool") and (v1.ToolTip == mode or mode == "All") then
            table.insert(weapons, v1)
        end
    end

    for _, v1 in ipairs(Client.Backpack:GetChildren()) do
        if v1:IsA("Tool") and (v1.ToolTip == mode or mode == "All") then
            table.insert(weapons, v1)
        end
    end

    for _, v1 in ipairs(weapons) do
        local skills = weaponSkills[v1.ToolTip]
        for i = 1, #skills do
            if key == skills[i] or key == "All" then
                local skillButton = Client.PlayerGui.Main.Skills:FindFirstChild(v1.Name):FindFirstChild(skills[i])
                if skillButton then
                    local cooldownSize = skillButton.Cooldown.AbsoluteSize.X
                    if cooldownSize > 0 then
                        return true -- Trả về true nếu có kỹ năng đang trong cooldown
                    end
                end
            end
        end
    end
    
    return false -- Trả về false nếu không tìm thấy kỹ năng hoặc vũ khí
end

local debounce = false
function EquipWeapon(toolName)
    print("Entrou em EquipWeapon")
    if debounce then
        return
    end
    debounce = true
    if not Client or not Client.Backpack or not Client.Character then
        print("Client, Backpack ou Character não existem!")
        debounce = false
        return
    end
    local backpack = Client.Backpack
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == toolName then
            if Toggles["AutoBounty"].Value then
                wait(0.1)
                Client.Character:WaitForChild("Humanoid"):EquipTool(tool)
            end
        end
    end
    wait(0.25)
    debounce = false
end

function Click()
    print("Entrou em Click")
    local bc = game:GetService("VirtualUser")
    bc:CaptureController()
    bc:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
end
    
    local function getAllBladeHits(Mode, Sizes)
        print("Entrou em getAllBladeHits")
        local Hits = {}
        local Client = Players.LocalPlayer
        local Characters
        
        if Mode == "Player" then
            Characters = game:GetService("Workspace").Characters:GetChildren()
        elseif Mode == "NPC" then
            Characters = game:GetService("Workspace").Enemies:GetChildren()
        end
        
        for i = 1, #Characters do
            local v = Characters[i]
            local Human = v:FindFirstChildOfClass("Humanoid")
            
            if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes + 5 then
                table.insert(Hits, Human.RootPart)
            end
        end
        
        return Hits
    end
    
    local function AttackFunction(Mode, Sizes)
        print("Entrou em AttackFunction")
        local ac = CombatFrameworkR.activeController
        
        if ac and ac.equipped then
            for indexincrement = 1, 1 do
                local bladehit
                
                if Mode == "Player" then
                    bladehit = getAllBladeHits("Player", Sizes)
                elseif Mode == "NPC" then
                    bladehit = getAllBladeHits("NPC", Sizes)
                end
                
                if #bladehit > 0 then
                    local AcAttack8 = debug.getupvalue(ac.attack, 5)
                    local AcAttack9 = debug.getupvalue(ac.attack, 6)
                    local AcAttack7 = debug.getupvalue(ac.attack, 4)
                    local AcAttack10 = debug.getupvalue(ac.attack, 7)
                    local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                    local NumberAc13 = AcAttack7 * 798405
                    
                    NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                    AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                    AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
    
                    AcAttack10 = AcAttack10 + 1
                    debug.setupvalue(ac.attack, 5, AcAttack8)
                    debug.setupvalue(ac.attack, 6, AcAttack9)
                    debug.setupvalue(ac.attack, 4, AcAttack7)
                    debug.setupvalue(ac.attack, 7, AcAttack10)
    
                    for k, v in pairs(ac.animator.anims.basic) do
                        v:Play(0.01, 0.01, 0.01)
                    end
    
                    if Client.Character:FindFirstChildOfClass("Tool") and ac.blades and ac.blades[1] then 
                        ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(CurrentWeapon()))
                        ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                        ReplicatedStorage.RigControllerEvent:FireServer("hit", bladehit, 2, "") 
                    end
                end
            end
        end
    end

    local ac = CombatFrameworkR.activeController
    if ac and ac.equipped then

        local Distance = GetDistance(Client.Character:WaitForChild("HumanoidRootPart").Position, object:WaitForChild("HumanoidRootPart").Position)

        if Toggles.ClickEnabled.Value and not Toggles.FastClickEnabled.Value then
            local foundMeleeTool = false
            for _, tool in ipairs(Client.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                    foundMeleeTool = true
                    break
                end
            end

            if foundMeleeTool then
                local shouldAttack = not Toggles["OnLowHealthDisable"].Value
                
                if Toggles["OnLowHealthDisable"].Value and GetCurrentHealth(object, compareValue) then
                    shouldAttack = Distance < Sizes
                end
                
                if shouldAttack then
                    if ac.hitboxMagnitude ~= Sizes then
                        ac.hitboxMagnitude = Sizes
                    end
            
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    wait(0.2)
                end
            else
                EquipWeapon("Melee")
            end

        elseif Toggles.ClickEnabled.Value and Toggles.FastClickEnabled.Value then
            local foundMeleeTool = false
            for _, tool in ipairs(Client.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                    foundMeleeTool = true
                    break
                end
            end
            
            if foundMeleeTool then
                if Distance < Sizes then
                    AttackFunction(Mode, Sizes)
            
                    local fastAttackType = Options.ModeFastClick.Value
            
                    local cooldownInterval -- Thời gian chờ giữa các lần tấn công
            
                    if fastAttackType == "Normal" then
                        cooldownInterval = 0.9
                    elseif fastAttackType == "Fast" then
                        cooldownInterval = 1.5
                    elseif fastAttackType == "Slow" then
                        cooldownInterval = 0.3
                    end
            
                    if tick() - cooldownfastattack > cooldownInterval then
                        if fastAttackType == "Slow" then
                            wait(0.7)
                        else
                            wait(0.1)
                        end
                        cooldownfastattack = tick()
                    end
                end
            else
                EquipWeapon("Melee")
            end
        end
    else
        EquipWeapon("Melee")
    end


function FightingStyle(object, mode, meleeSkills, bfSkills, gunSkills, swordSkills)
    print("Entrou em FightingStyle")
    local playerPosition = Client.Character.HumanoidRootPart.Position
    local objectPosition = object:FindFirstChild("HumanoidRootPart").Position
    local distance = GetDistance(playerPosition, objectPosition)

    if distance < 150 then
        if mode == "Melee" or mode == "Blox Fruit" or mode == "Gun" or mode == "Sword" then
            EquipWeapon(mode)

            local usedSkill = false
            local currentWeapon = nil

            for _, tool in ipairs(Client.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == mode then
                    currentWeapon = tool.Name
                    local skills
                    if mode == "Melee" then
                        skills = meleeSkills
                    elseif mode == "Blox Fruit" then
                        skills = bfSkills
                    elseif mode == "Gun" then
                        skills = gunSkills
                    elseif mode == "Sword" then
                        skills = swordSkills
                    end

                    if Toggles.AutoBounty and Toggles.AutoBounty.Value and Toggles[mode .. "Enabled"] and
                        Toggles[mode .. "Enabled"].Value then
                        local selectedSkills = {}
                        for key, _ in next, Options["Abilities" .. mode].Value do
                            table.insert(selectedSkills, key)
                        end

                        local allSkillsCooldown = true
                        for _, skillKey in ipairs(selectedSkills) do
                            if not CheckCooldown(mode, skillKey) then
                                allSkillsCooldown = false
                                break
                            end
                        end

                        if allSkillsCooldown and not usedSkill then
                            local keysToPress = {}

                            for key, value in pairs(skills) do
                                if table.find(selectedSkills, key) and not CheckCooldown(mode, key) then
                                    local ht = value
                                    local skillButton = Client.PlayerGui.Main.Skills:FindFirstChild(tool.Name)
                                        :FindFirstChild(key)

                                    if skillButton then
                                        table.insert(keysToPress, {
                                            key = key,
                                            holdTime = ht.HoldTime
                                        })
                                    end
                                end
                            end

                            for _, skill in ipairs(keysToPress) do
                                SendKey(skill.key, skill.holdTime)
                                usedSkill = true
                                wait()
                            end
                        else
                            local keysToPress = {}

                            for key, value in pairs(skills) do
                                if table.find(selectedSkills, key) and not CheckCooldown(mode, key) then
                                    local ht = value
                                    local skillButton = Client.PlayerGui.Main.Skills:FindFirstChild(tool.Name)
                                        :FindFirstChild(key)
                                    if skillButton then
                                        table.insert(keysToPress, {
                                            key = key,
                                            holdTime = ht.HoldTime
                                        })
                                    end
                                end
                            end

                            for _, skill in ipairs(keysToPress) do
                                SendKey(skill.key, skill.holdTime)
                                wait()
                            end
                        end
                    end
                end
            end

            if not usedSkill then
                local function ProcessAltMode(altMode)
                    EquipWeapon(altMode)
                    FightingStyle(object, altMode, meleeSkills, bfSkills, gunSkills, swordSkills)
                end
            
                local allSkillsUsed = true
                local selectedSkills = {}
            
                if Toggles.AutoBounty and Toggles.AutoBounty.Value then
                    for key, _ in next, Options["Abilities" .. mode].Value do
                        table.insert(selectedSkills, key)
                    end
            
                    for _, skillKey in ipairs(selectedSkills) do
                        if not CheckCooldown(mode, skillKey) then
                            allSkillsUsed = false
                            break
                        end
                    end
                end
            
                if allSkillsUsed then
                    local weaponChanged = false
                    for _, altMode in ipairs(weaponTypes) do
                        if Toggles.AutoBounty and Toggles.AutoBounty.Value and altMode ~= mode and
                            Toggles[altMode .. "Enabled"] and Toggles[altMode .. "Enabled"].Value then
                            spawn(function()
                                ProcessAltMode(altMode)
                            end)
                            weaponChanged = true
                            break
                        end
                    end

                    if not weaponChanged and Toggles.ClickEnabled and Toggles.ClickEnabled.Value then
                        Click("Player", tonumber(Options.Hitbox.Value), object, tonumber(Options.LowHealth.Value))
                    end
                end
            end
        end
    end
end

function TeleportBetweenServers(PlaceID, mode)
    print("Entrou em TeleportBetweenServers")
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    
    local File = pcall(function()
        AllIDs = game:GetService("HttpService"):JSONDecode(readfile("NotSameServers.json"))
    end)
    
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
    end
    
    while true do
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything))
        end
        
        local ID = ""
        
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        if Site.data then -- Kiểm tra xem Site.data có tồn tại hay không
            for i,v in pairs(Site.data) do
                local Possible = true
                ID = tostring(v.id)
                
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    for _,Existing in pairs(AllIDs) do
                        if num ~= 0 then
                            if ID == tostring(Existing) then
                                Possible = false
                            end
                        else
                            if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                    delfile("NotSameServers.json")
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end)
                            end
                        end
                        num = num + 1
                    end
                    
                    if Possible == true then
                        if mode == "Lowest" then
                            if tonumber(v.playing) <= 12 then
                                table.insert(AllIDs, ID)
                                wait()
                                pcall(function()
                                    writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
                                    wait()
                                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, Playerss.LocalPlayer)
                                    return -- Thoát khỏi vòng lặp sau khi tham gia vào máy chủ phù hợp
                                end)
                                wait(4)
                            end
                        elseif type(mode) == "number" then
                            if tonumber(v.playing) <= tonumber(mode) then
                                table.insert(AllIDs, ID)
                                wait()
                                pcall(function()
                                    writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
                                    wait()
                                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, Playerss.LocalPlayer)
                                    return -- Thoát khỏi vòng lặp sau khi tham gia vào máy chủ phù hợp
                                end)
                                wait(4)
                            end
                        end
                    end
                end
            end
        end
    end
end

function processAim(nearestObject)
    print("Entrou em processAim")
    local Configuration = {
        Method = "Hit",
    
        MethodResolve = {
            -- // __index methods
            target = {
                Real = "Target",
                Metamethod = "__index",
                Aliases = {"target"}
            },
            hit = {
                Real = "Hit",
                Metamethod = "__index",
                Aliases = {"hit"}
            }
        },
    
        ExpectedArguments = {
            Raycast = {
                ArgCountRequired = 3,
                Args = {
                    "Instance", "Vector3", "Vector3", "RaycastParams"
                }
            }
        }
    }
    
    local function CalculateDirection(Origin, Destination, Length)
        return (Destination - Origin).Unit * Length
    end
    
    function Configuration.AdditionalCheck(metamethod, method, callingscript, ...)
        return true
    end

    local function IsMethodEnabled(Method, Given, PossibleMethods)
        -- // Split it all up
        PossibleMethods = PossibleMethods or string.split(Configuration.Method, ",")
        Given = Given or Method
    
        -- // Vars
        local LoweredMethod = string.lower(Method)
        local MethodData = Configuration.MethodResolve[LoweredMethod]
        if not MethodData then
            return false, nil
        end
    
        -- //
        local Matches = LoweredMethod == string.lower(Given)
        local RealMethod = MethodData.Real
        local Found = table.find(PossibleMethods, RealMethod)
    
        -- // Return
        return (Matches and Found), RealMethod
    end
    
    local function ValidateArguments(Args, Method)
        -- // Get Type Information from Method
        local TypeInformation = Configuration.ExpectedArguments[Method]
        if not TypeInformation then
            return false
        end
    
        -- // Make new table for successful matches
        local Matches = 0
    
        -- // Go through every argument passed
        for ArgumentPosition, Argument in pairs(Args) do
            -- // Check if argument type is a certain type
            if typeof(Argument) == TypeInformation.Args[ArgumentPosition] then
                Matches = Matches + 1
            end
        end
    
        -- // Get information
        local ExpectedValid = #Args
        local GotValid = Matches
    
        -- // Return whether or not arguments are valid
        return ExpectedValid == GotValid
    end
    
    local __index
    __index = hookmetamethod(game, "__index", function(t, k)
        -- // Vars
        local callingscript = getcallingscript()
    
        -- // Make sure everything is in order
        if t:IsA("Mouse") and not checkcaller() and (Toggles.AutoBounty and Toggles.AutoBounty.Value) then
            if nearestObject and nearestObject:FindFirstChild("HumanoidRootPart") then
                local HitPart = nearestObject:FindFirstChild("HumanoidRootPart")
    
                -- // Vars
                local MethodEnabled, RealMethod = IsMethodEnabled(k)
    
                -- // Make sure everything is in order 2
                if not MethodEnabled or not Configuration.AdditionalCheck("__index", nil, callingscript, t, RealMethod) then
                    return __index(t, k)
                end
    
                if RealMethod == "Target" or RealMethod == "Hit" then
                    return ((HitPart.CFrame + (HitPart.Velocity * 0.1)) or HitPart.CFrame)
                end
    
            end
        end
    
        -- // Return
        return __index(t, k)
    end)

    local __namecall
    local aimingMethod = "Raycast"
    __namecall = hookmetamethod(game, "__namecall", function(...)
        -- // Vars
        local args = {...}
        local self = args[1]
        local method = getnamecallmethod()
        local callingscript = getcallingscript()
    
        -- // Make sure everything is in order
        if self == workspace and not checkcaller() and (Toggles.AutoBounty and Toggles.AutoBounty.Value) then
            
            -- // Vars
            local MethodEnabled, RealMethod = IsMethodEnabled(method)
    
            -- // Make sure all is in order 2
            if not MethodEnabled or not ValidateArguments(args, RealMethod) or not Configuration.AdditionalCheck("__namecall", RealMethod, callingscript, ...) then
                return __namecall(...)
            end
    
            if nearestObject then
                local HitPart = nearestObject:FindFirstChild("HumanoidRootPart")
                -- // Raycast
                if RealMethod == "Raycast" and aimingMethod == RealMethod then
            
                    -- // Modify args
                    args[3] = CalculateDirection(args[2], HitPart.Position, 1000)
            
                    -- // Return
                    return __namecall(unpack(args))
                end
    
                -- // The rest pretty much, modify args
                local Origin = args[2].Origin
                local Direction = CalculateDirection(Origin, HitPart.Position, 1000)
                args[2] = Ray.new(Origin, Direction)
            
                -- // Return
                return __namecall(unpack(args))
            end
        end
    
        -- //
        return __namecall(...)
    end)
    
end

function Camera_Settings(bool)
    print("Entrou em Camera_Settings")
    local Module = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
    if bool then
        Module:Stop()
    else
        Module:Start()
    end
end

function CalculateDirection(Origin, Destination, Length)
    print("Entrou em CalculateDirection")
    return (Destination - Origin).Unit * Length
end

local mode = 1
function AttackNearestPlayer(object)
    print("Entrou em AttackNearestPlayer")
    local toggleValues = {
        Melee = Toggles.MeleeEnabled,
        Sword = Toggles.SwordEnabled,
        Gun = Toggles.GunEnabled,
        ["Blox Fruit"] = Toggles.BloxFruitEnabled
    }

    if object then 
        local HRP = object.HumanoidRootPart
        Farming = TweenService2(HRP.CFrame * CFrame.new(0,5.4,5.5))

        spawn(function()
            if Toggles.ClickEnabled and Toggles.ClickEnabled.Value then
                Click("Player", tonumber(Options.Hitbox.Value), object, tonumber(Options.LowHealth.Value))
            end
        end)

        spawn(function()
            for _, weaponType in ipairs(weaponTypes) do
                if toggleValues[weaponType] and toggleValues[weaponType].Value then
                    spawn(function()
                        FightingStyle(object, weaponType, meleeSkills, bfSkills, gunSkills, swordSkills)
                    end)
                end
            end
        end)
        --CheckHealthChange(Farming)
    else
        --[[if Farming then Farming:Cancel() end
        local targetY = 20000 -- Giá trị Y mục tiêu
        local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")

        while hrp.Position.Y < targetY do
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 150, 0)
            do
                if hrp.Position.Y >= 1000  then
                    TeleportBetweenServers(game.PlaceId, mode)
                    mode = mode + 1
                end
            end
            task.wait()
        end]]
    end
end

function addRichText(label, hexColor)
    print("Entrou em addRichText")
    label.TextLabel.RichText = true
    label.TextLabel.TextColor3 = Color3.fromRGB(
        tonumber(hexColor:sub(2, 3), 16),
        tonumber(hexColor:sub(4, 5), 16),
        tonumber(hexColor:sub(6, 7), 16)
    )
end

function CancelThreads(...)
    print("Entrou em CancelThreads")
    local threads = {...}
    
    for _, thread in ipairs(threads) do
        pcall(task.cancel, thread)
    end
end

function generateRandomString(length)
    print("Entrou em generateRandomString")
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomString = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end
    return randomString
end

function Speed(ws)
    print("Entrou em Speed")
    local hum = game.Players.LocalPlayer.Character.Humanoid
    local Velocity = Instance.new("BodyVelocity")
    Velocity.maxForce = Vector3.new(100000, 0, 100000)
    local Gyro = Instance.new("BodyGyro")
    Gyro.maxTorque = Vector3.new(100000, 0, 100000)
    local enbld = true

    Velocity.Parent = game.Players.LocalPlayer.Character.UpperTorso
    Velocity.velocity = (hum.MoveDirection) * ws
    Gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso

    while true do
        if Toggles.WalkSpeed.Value then
            Velocity.velocity = (hum.MoveDirection) * ws
            local refpos = Gyro.Parent.Position + (Gyro.Parent.Position - workspace.CurrentCamera.CoordinateFrame.p).unit * 5
            Gyro.cframe = CFrame.new(Gyro.Parent.Position, Vector3.new(refpos.x, Gyro.Parent.Position.y, refpos.z))
            wait(0.1)
        else
            Velocity:Destroy()
            Gyro:Destroy()
            break
        end
        wait()
    end
end

local BlockFireServerEnabled = false -- Biến để theo dõi trạng thái chặn FireServer
local OriginalNamecall -- Biến để lưu trữ hàm namecall gốc

local function BlockFireServer()
    print("Entrou em BlockFireServer")
    local gg = getrawmetatable(game)
    local caller = checkcaller
    local rindex = gg.__index
    local nindex = gg.__newindex
    OriginalNamecall = gg.__namecall -- Lưu trữ hàm namecall gốc

    setreadonly(gg, false)

    gg.__namecall = newcclosure(function(self, ...)
        if BlockFireServerEnabled then -- Kiểm tra trạng thái chặn FireServer
            local Method = getnamecallmethod()
            local Beans = {...}

            if Method == "FireServer" and (Beans[1] == "WalkSpeed" or Beans[1] == "JumpPower" or Beans[1] == "HipHeight") then
                return nil
            end
        end

        return OriginalNamecall(self, ...)
    end)

    setreadonly(gg, true)
end

local function EnableBlockFireServer()
    print("Entrou em EnableBlockFireServer")
    BlockFireServerEnabled = true
end

local function DisableBlockFireServer()
    print("Entrou em DisableBlockFireServer")
    BlockFireServerEnabled = false
end

--⚔️In Combat - Honor at risk!⚔️
--⚔️In Combat⚔️
--⚔️Player died rencently, you can"t attack them yet!⚔️
--No reward, Level difference is too high!
--Client.PlayerGui.Notifications.NotificationTemplate.Text
local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = workspace.CurrentCamera

local torso = nil
local flying = false
local keys = {
    a = false,
    d = false,
    w = false,
    s = false
}
local e1
local e2

local function Start(FlySpeed)
    print("Entrou em Start (Fly)")
    local pos = Instance.new("BodyPosition", torso)
    local gyro = Instance.new("BodyGyro", torso)
    pos.Name = "EPIXPOS"
    pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
    pos.position = torso.Position
    gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.cframe = torso.CFrame

    repeat
        wait()
        Client.Character:WaitForChild("Humanoid").PlatformStand = true
        local new = gyro.cframe - gyro.cframe.p + pos.position

       --[[ if not keys.w and not keys.s and not keys.a and not keys.d then
            FlySpeed = 5
        end]]

        if keys.w then
            new = new + Camera.CoordinateFrame.lookVector * FlySpeed
            FlySpeed = FlySpeed + 0
        end

        if keys.s then
            new = new - Camera.CoordinateFrame.lookVector * FlySpeed
            FlySpeed = FlySpeed + 0
        end

        if keys.d then
            new = new * CFrame.new(FlySpeed, 0, 0)
            FlySpeed = FlySpeed + 0
        end

        if keys.a then
            new = new * CFrame.new(-FlySpeed, 0, 0)
            FlySpeed = FlySpeed + 0
        end

        --[[if FlySpeed > 10 then
            FlySpeed = 5
        end]]

        pos.position = new.p

        if keys.w then
            gyro.cframe = Camera.CoordinateFrame * CFrame.Angles(-math.rad(FlySpeed * 0), 0, 0)
        elseif keys.s then
            gyro.cframe = Camera.CoordinateFrame * CFrame.Angles(math.rad(FlySpeed * 0), 0, 0)
        else
            gyro.cframe = Camera.CoordinateFrame
        end
    until not flying

    if gyro then
        gyro:Destroy()
    end

    if pos then
        pos:Destroy()
    end

    Client.Character:WaitForChild("Humanoid").PlatformStand = false
    FlySpeed = 10
end

local function toggleFly(FlySpeed)
    print("Entrou em toggleFly")
    flying = not flying
    if flying then
        Start(FlySpeed)
    end
end

local function onKeyPressed(key)
    print("Entrou em onKeyPressed")
    if not torso or not torso.Parent then
        flying = false
        e1:Disconnect()
        e2:Disconnect()
        return
    end

    if key == "w" then
        keys.w = true
    elseif key == "s" then
        keys.s = true
    elseif key == "a" then
        keys.a = true
    elseif key == "d" then
        keys.d = true
    end
end

local function onKeyReleased(key)
    print("Entrou em onKeyReleased")
    if key == "w" then
        keys.w = false
    elseif key == "s" then
        keys.s = false
    elseif key == "a" then
        keys.a = false
    elseif key == "d" then
        keys.d = false
    end
end

local function setup()
    print("Entrou em setup")
    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)

    spawn(function()
        Core.Parent = workspace
        local Weld = Instance.new("Weld", Core)
        Weld.Name = "weld"
        Weld.Part0 = Core
        Weld.Part1 = Client.Character.LowerTorso
        Weld.C0 = CFrame.new(0, 0, 0)
    end)

    workspace:WaitForChild("Core")
    torso = workspace.Core

    e1 = Mouse.KeyDown:Connect(onKeyPressed)
    e2 = Mouse.KeyUp:Connect(onKeyReleased)
end

spawn(function()
    local thread1 = task.spawn(function()
        local nearestObject = nil
        spawn(function()
            FastLoadW()
            BlockFireServer()
            spawn(function()
                while true do
                    if Toggles.AutoBounty and Toggles.AutoBounty.Value then
                        if Client.Character then
                            if Options["InMode"] and Options["InMode"].Value == "Experiment" then
                                if Options["ExParts"] then
                                    if Options["ExParts"].Value == "Non-object character" then
                                        nearestObject = markTargets("NPC")
                                    elseif Options["ExParts"].Value == "Dummy Character" then
                                        nearestObject = workspace.Characters:FindFirstChild(Client.Name.."-Clone")
                                    end
                                end
                            else
                                if Options["ReParts"] then
                                    if Options["ReParts"].Value == "Automatic" then
                                        nearestObject = GetNearestPlayer() and GetNearestPlayer().Character
                                    elseif Options["ReParts"].Value == "Manual" then
                                        nearestObject = markTargets("Player") and markTargets("Player").Character
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end)
        
        spawn(function()
            setup()
            repeat
                wait()
            until nearestObject
            
            print("ready")
            processAim(nearestObject)
        end)
        
        spawn(function()
            while wait() do
                pcall(function()
                    if Toggles.AutoBounty and Toggles.AutoBounty.Value then
                        if Client.Character:FindFirstChild("HumanoidRootPart") then
                            if not Client.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
                                local bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.Name = "BodyVelocity1"
                                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bodyVelocity.Parent = Client.Character.HumanoidRootPart
                            end
                        end
                    else
                        if Client.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1") then
                            Client.Character.HumanoidRootPart:FindFirstChild("BodyVelocity1"):Destroy();
                        end
                    end
                end)
            end
        end)

        spawn(function()
            while true do
                pcall(function()
                    if Toggles.AutoBounty and Toggles.AutoBounty.Value then
                        repeat AttackNearestPlayer(nearestObject)
                            task.wait()
                        until Players.IsPlayerBlacklisted(nearestObject.Name) or PlayerTracker.IsPlayerDead(Client) or PlayerTracker.IsPlayerDead(nearestObject) or PlayerTracker.IsPlayerLeavingGame(nearestObject) or not Toggles["AutoBounty"].Value
                    else
                        if Farming then 
                            Camera_Settings(false) 
                            Farming:Cancel() 
                        end
                    end

                    if (Toggles.Spectate and Toggles.Spectate.Value) or (Toggles.AutoBounty and Toggles.AutoBounty.Value) then
                        if nearestObject then
                            AutoBlacklistPlayer(nearestObject, 5, 75)
                        end
                    end

                    if Toggles.AutoBuso and Toggles.AutoBuso.Value then
                        AutoBuso()
                        wait(0.5)
                    end

                    if Toggles.AutoKen and Toggles.AutoKen.Value then
                        if Lighting.ColorCorrection.TintColor == Color3.fromRGB(255, 255, 255) then
                            VIM:SendKeyEvent(true, "E", false, game)
                            wait(.05)
                            Lighting.ColorCorrection.Enabled = false
                        end
                        wait(0.5)
                    else
                        Lighting.ColorCorrection.Enabled = true
                    end

                    if Toggles.Invisible and Toggles.Invisible.Value then
                        if Client.Character:FindFirstChild("CharacterReady") then
                            enabled = true
                            Module.Invisible(enabled)
                        elseif not Client.Character:FindFirstChild("CharacterReady") then
                            enabled = false
                        end
                    end

                    if Toggles.Spectate and Toggles.Spectate.Value then
                        if nearestObject then 
                            spectate = true
                            Module.Spectate(spectate, nearestObject)
                        else
                            spectate = false
                        end
                    else
                        spectate = false
                    end

                    if Toggles["Race V4"] and Toggles["Race V4"].Value then
                        Race("V4", nearestObject)
                    end
                
                    if Toggles["Race V3"] and Toggles["Race V3"].Value then
                        Race("V3", nearestObject)
                    end

                    if Toggles.CameraShake and Toggles.CameraShake.Value then
                        Camera_Settings(true)
                    else
                        Camera_Settings(false)
                    end
                    
                end)
                task.wait()
            end
        end)

    end)
    shared.CancelAllThreads = function()
        CancelThreads(thread1)
    end
end)

local Window = UI:CreateWindow({
    Title = string.format("Hunt Bounty - version %s | updated: %s", (metadata and metadata.version) or 'desconhecido', (metadata and metadata.updated) or 'desconhecido'),
    AutoShow = true,
    
    Center = true,
    Size = UDim2.fromOffset(550, 623),
})

local Tabs = {}
local Groups = {}

Tabs.Main = Window:AddTab("Main")
Tabs.Combat = Window:AddTab("Combat")
Tabs.Miscellaneous = Window:AddTab("Miscellaneous")

Groups.Enabled_Bounty = Tabs.Main:AddLeftGroupbox(generateRandomString(10))

Groups.Enabled_Bounty:AddToggle("AutoBounty", {
    Text = "Auto Bounty"
}):AddKeyPicker("AutoBounty_Bind", {
    Default = "End",
    NoUI = true,
    SyncToggleState = true
})

Groups.Enabled_Bounty:AddToggle("Spectate", {
    Text = "Spectate Target"
}):AddKeyPicker("Spectate_Bind", {
    Default = "Down",
    NoUI = true,
    SyncToggleState = true
})

Groups.Enabled_Bounty:AddButton("Skip Player", function()
    if Options["ReParts"] and Options["ReParts"].Value == "Automatic" then
        nearestObject = GetNearestPlayer()
    else
        nearestObject = markTargets("Player")
    end
    
    if nearestObject then
        Players.AddToBlacklist(nearestObject.Name)
        UI:Notify("Skipped object: " .. nearestObject.Name .. ".", 2)
    else
        UI:Notify("No object to skip.", 3)
    end
end)

addRichText(Groups.Enabled_Bounty:AddLabel(generateRandomString(10).." - Config"), "#F8B195")

Groups.Enabled_Bounty:AddToggle("BypassTP", {
    Text = "Teleport Bypass"
})

Groups.Enabled_Bounty:AddInput("CompareElapsedTime", {
    Default = "0.075",
    Numeric = false,
    Finished = false,
    Tooltip = "Only works for teleport bypasser",

    Text = "Compare Elapsed Time"
})

Groups.Enabled_Bounty:AddInput("Reset Time", {
    Default = "0.04",
    Numeric = false,
    Finished = false,
    Tooltip = "Only works for teleport bypasser",

    Text = "Reset Time"
})

Groups.Enabled_Bounty:AddSlider("HitChance", {
    Text = "Hit Chance",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0.1,
    Tooltip = "Align the trajectory of the skill",

    Compact = false,
})

local Servers = {["Main"] = "TravelMain", ["Dressrosa"] = "TravelDressrosa", ["Zou"] = "TravelZou"}
for i, v in pairs(Servers) do
    Groups.Enabled_Bounty:AddButton(tostring(i), function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer(v)
    end)
end

Groups.Enabled_Bounty2 = Tabs.Main:AddRightGroupbox(generateRandomString(10))

Groups.Enabled_Bounty2:AddDropdown("InMode", {
    Text = "Mode:",
    Default = 1,
    Values = {"Experiment", "Reality"},
    Multi = false,
})

addRichText(Groups.Enabled_Bounty2:AddLabel("Player: "), "#F67280")

Groups.Enabled_Bounty2:AddDropdown("ReParts", {
    Text = "Reality Parts:",
    Default = 2,
    Values = {"Automatic", "Manual"},
    Multi = false,
})

Groups.Enabled_Bounty2:AddDropdown("TargetPPL", {
    Text = "Player/s Choosing:",
    Default = 1,
    Values = listAllPlayers("Player"),
    Multi = true,
    Tooltip = "Only works when you use Manual function"
})

Options.TargetPPL:OnChanged(function()
    local playerList = listAllPlayers("Player")
    Options.TargetPPL:SetValues(playerList)
end)

addRichText(Groups.Enabled_Bounty2:AddLabel("NPC: "), "#F67280")

Groups.Enabled_Bounty2:AddDropdown("ExParts", {
    Text = "Experiment Parts:",
    Default = 2,
    Values = {"Non-object character", "Dummy Character"},
    Multi = false,
})

Groups.Enabled_Bounty2:AddDropdown("TargetNPC", {
    Text = "Non-object character:",
    Default = 1,
    Values = listAllPlayers("NPC"),
    Multi = false,
    Tooltip = "Only works when you use Non-object character function"
})

Options.TargetNPC:OnChanged(function()
    local npcList = listAllPlayers("NPC")
    Options.TargetNPC:SetValues(npcList)
end)

addRichText(Groups.Enabled_Bounty2:AddLabel("Dummy: "..Client.Name), "#F67280")

Groups.Enabled_Bounty2:AddButton("Spawn", function()
    local function cloneCharacter()
        if workspace.Characters:FindFirstChild(Client.Name.."-Clone") then
            workspace.Characters[Client.Name.."-Clone"]:Destroy()
        end
    
        if Client.Character then
            Client.Character.Archivable = true
            local dup = Client.Character:Clone()
            dup.Name = Client.Name.."-Clone"
            dup.Parent = workspace.Characters
        end
    end
    cloneCharacter()
end)

Groups.Enabled_Bounty2:AddButton("Delete", function()
    if workspace.Characters:FindFirstChild(Client.Name.."-Clone") then
        workspace.Characters[Client.Name.."-Clone"]:Destroy()
    end
end)

Groups.Combat1 = Tabs.Combat:AddLeftGroupbox(generateRandomString(10))

addRichText(Groups.Combat1:AddLabel("Screen: "), "#aef901")

Groups.Combat1:AddToggle("CameraShake", {
    Text = "Camera Shaking"
})

addRichText(Groups.Combat1:AddLabel("Haki: "), "#f901ec")

Groups.Combat1:AddToggle("AutoBuso", {
    Text = "Buso"
})

Groups.Combat1:AddToggle("AutoKen", {
    Text = "Ken"
})

addRichText(Groups.Combat1:AddLabel("Race: "), "#ff973d")

Groups.Combat1:AddToggle("Race V3", 
{ Text = "Race v3",
NoUI = true, 
SyncToggleState = true
})

Groups.Combat1:AddToggle("Race V4", 
{ Text = "Race V4",
NoUI = true, 
SyncToggleState = true
})

addRichText(Groups.Combat1:AddLabel("Click: "), "#0373fc")

Groups.Combat1:AddToggle("ClickEnabled", 
{ Text = "Click Enabled",
NoUI = true, 
Tooltip = "Only works for melee",
SyncToggleState = true
})

Groups.Combat1:AddToggle("FastClickEnabled", 
{ Text = "Fast Click Enabled",
NoUI = true, 
SyncToggleState = true
})

Groups.Combat1:AddDropdown("ModeFastClick", {
    Text = "Fast Click [Mode]",
    Default = 3,
    Values = {"Slow", "Normal", "Fast"},
    Multi = false,
})

Groups.Combat1:AddInput("Hitbox", {
    Default = "35",
    Numeric = false,
    Finished = false,

    Text = "Hitbox Extender"
})

Groups.Combat1:AddToggle("OnLowHealthDisable", 
{ Text = "LowestHealth Disable",
NoUI = true, 
SyncToggleState = true
})

Groups.Combat1:AddInput("LowHealth", {
    Default = "4500",
    Numeric = false,
    Finished = true,
    Tooltip = "Press enter after you,ve done",

    Text = "LowestHealth Disable"
})

addRichText(Groups.Combat1:AddLabel("Weapon: "), "#01cbf9")

local Weapons = {"BlackLeg", "Electro", "FishmanKarate", "Dragon Claw", "Superhuman", "DeathStep", "SharkmanKarate", "ElectricClaw", "DragonTalon", "Godhuman"}

Groups.Combat1:AddDropdown("MeleeSelected", {
    Text = "Melee Wanted: ",
    Default = 3,
    Values = Weapons,
    Multi = false,
})

local meleeButton = nil

Options.MeleeSelected:OnChanged(function()
    if meleeButton then
        meleeButton.Label.Text = tostring("Buy: "..Options.MeleeSelected.Value)
    else
        meleeButton = Groups.Combat1:AddButton({
            Text = tostring("Buy: "..Options.MeleeSelected.Value),
            Func = function()
                if Options.MeleeSelected.Value == "Dragon Claw" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
                else
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buy" .. tostring(Options.MeleeSelected.Value))
                end
            end,
            DoubleClick = false,
            Tooltip = "If you see this maybe you're trans"
        })
    end
end)

addRichText(Groups.Combat1:AddLabel("Local Player: "), "#D35400")

Groups.Combat1:AddInput("InputWS", {
    Default = "150",
    Numeric = false,
    Finished = false,

    Text = "Input your wanted FlySpeed: "
})

Groups.Combat1:AddToggle("WalkSpeed", {
    Text = "Walk Speed",
    NoUI = true,
    SyncToggleState = true
})

Toggles.WalkSpeed:OnChanged(function()
    if Toggles.WalkSpeed.Value then
        Speed(tonumber(Options.InputWS.Value))
    end
end)

Groups.Combat1:AddInput("InputJP", {
    Default = "150",
    Numeric = false,
    Finished = false,

    Text = "Input your wanted power: "
})

Groups.Combat1:AddToggle("JumpPower", {
    Text = "Jump Power",
    NoUI = true,
    SyncToggleState = true
})

Toggles.JumpPower:OnChanged(function()
    if Toggles.JumpPower.Value then
        EnableBlockFireServer()
        Client.Character:WaitForChild("Humanoid").JumpPower = tonumber(Options.InputJP.Value)
    else
        DisableBlockFireServer()
        Client.Character:WaitForChild("Humanoid").JumpPower = 50
    end
end)

Groups.Combat1:AddInput("InputFly", {
    Default = "150",
    Numeric = false,
    Finished = false,

    Text = "Input your wanted fly's FlySpeed: "
})

Groups.Combat1:AddToggle("Fly", {
    Text = "Fly",
    NoUI = false,
}):AddKeyPicker("FlyPicker", {
    Default = "Delete",
    SyncToggleState = true,

    Mode = "Toggle",

    Text = "??",
    NoUI = false,
})


Toggles.Fly:OnChanged(function()
    if Toggles.Fly.Value then
        if not flying then
            toggleFly(tonumber(Options.InputFly.Value))
        end
    else
        if flying then
            toggleFly(tonumber(Options.InputFly.Value))
        end
    end
end)

Groups.Combat2 = Tabs.Combat:AddRightGroupbox(generateRandomString(10))

addRichText(Groups.Combat2:AddLabel("Melee: "), "#de0404")

Groups.Combat2:AddToggle("MeleeEnabled", 
    { Text = "Enabled Melee",
      NoUI = true, 
      SyncToggleState = true
    })
    
local abilitiesValuesM = {"Z", "X", "C"}
    
Groups.Combat2:AddDropdown("AbilitiesMelee", {
    Text = "Use Abilities [Melee Style]",
    Default = "",
    Values = abilitiesValuesM,
    Multi = true,
})

for _, key in ipairs(abilitiesValuesM) do
    local value = meleeSkills[key]
    
    Groups.Combat2:AddSlider("Skill"..key, {
        Text = "Hold Time "..key, 
        Min = 0, 
        Max = 5, 
        Rounding = 1,
        Default = value.HoldTime,
        Compact = true 
    }):OnChanged(function(newValue)
        value.HoldTime = newValue
    end)
end

addRichText(Groups.Combat2:AddLabel("Blox Fruit: "), "#a103fc")

Groups.Combat2:AddToggle("Blox FruitEnabled", 
    { Text = "Enabled Blox Fruit",
      NoUI = true, 
      SyncToggleState = true
    })
    
local abilitiesValuesBF = {"Z", "X", "C", "V"}
    
Groups.Combat2:AddDropdown("AbilitiesBlox Fruit", {
    Text = "Use Abilities [Blox Fruit Style]",
    Default = "",
    Values = abilitiesValuesBF,
    Multi = true,
})

for _, key in ipairs(abilitiesValuesBF) do
    local value = bfSkills[key]
    
    Groups.Combat2:AddSlider("Skill"..key, {
        Text = "Hold Time "..key, 
        Min = 0, 
        Max = 5, 
        Rounding = 1,
        Default = value.HoldTime,
        Compact = true 
    }):OnChanged(function(newValue)
        value.HoldTime = newValue
    end)
end

addRichText(Groups.Combat2:AddLabel("Gun: "), "#e4fc05")

Groups.Combat2:AddToggle("GunEnabled", 
    { Text = "Enabled Gun",
      NoUI = true, 
      SyncToggleState = true
    })
    
local abilitiesValuesGun = {"Z", "X"}
    
Groups.Combat2:AddDropdown("AbilitiesGun", {
    Text = "Use Abilities [Gun Style]",
    Default = "",
    Values = abilitiesValuesGun,
    Multi = true,
})

for _, key in ipairs(abilitiesValuesGun) do
    local value = gunSkills[key]
    
    Groups.Combat2:AddSlider("Skill"..key, {
        Text = "Hold Time "..key, 
        Min = 0, 
        Max = 5, 
        Rounding = 1,
        Default = value.HoldTime,
        Compact = true 
    }):OnChanged(function(newValue)
        value.HoldTime = newValue
    end)
end

addRichText(Groups.Combat2:AddLabel("Sword: "), "#0cc221")

Groups.Combat2:AddToggle("SwordEnabled", 
    { Text = "Enabled Sword",
      NoUI = true, 
      SyncToggleState = true
    })
    
local abilitiesValuesSword = {"Z", "X"}
    
Groups.Combat2:AddDropdown("AbilitiesSword", {
    Text = "Use Abilities [Sword Style]",
    Default = "",
    Values = abilitiesValuesSword,
    Multi = true,
})

for _, key in ipairs(abilitiesValuesSword) do
    local value = swordSkills[key]
    
    Groups.Combat2:AddSlider("Skill"..key, {
        Text = "Hold Time "..key, 
        Min = 0, 
        Max = 5, 
        Rounding = 1,
        Default = value.HoldTime,
        Compact = true 
    }):OnChanged(function(newValue)
        value.HoldTime = newValue
    end)
end
    
print("Client is ready.")
