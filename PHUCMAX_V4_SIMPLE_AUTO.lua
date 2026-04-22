
getgenv().team = "Pirates" -- Marines

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        wait()
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes")
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end

repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
	

-- >>> PHUCMAX V4 SIMPLE AUTO UI <<<
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local bountyLabel = nil
local timeLabel = nil
local statusValueLabel = nil
local screenGui = nil
local containerFrame = nil
local startTime = tick()
local tween = nil

local function pxMakeLabel(parent, posY, sizeY, text, font, textSize)
    local lb = Instance.new("TextLabel")
    lb.BackgroundTransparency = 1
    lb.Size = UDim2.new(1, -20, 0, sizeY)
    lb.Position = UDim2.new(0, 10, 0, posY)
    lb.Font = font or Enum.Font.GothamSemibold
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.TextWrapped = true
    lb.Text = text
    lb.TextColor3 = Color3.fromRGB(235, 245, 255)
    lb.TextSize = textSize or 18
    lb.Parent = parent
    return lb
end

local function pxMakeButton(parent, text, size, pos)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(27, 88, 190)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 248, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = btn
    return btn
end

pcall(function()
    local oldGui = playerGui:FindFirstChild("PHUCMAX_UI")
    if oldGui then oldGui:Destroy() end
end)

screenGui = Instance.new("ScreenGui")
screenGui.Name = "PHUCMAX_UI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

containerFrame = Instance.new("Frame")
containerFrame.Name = "MainCard"
containerFrame.Size = UDim2.new(0, 365, 0, 320)
containerFrame.Position = UDim2.new(1, -382, 0.5, -160)
containerFrame.BackgroundColor3 = Color3.fromRGB(15, 34, 82)
containerFrame.BorderSizePixel = 0
containerFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = containerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -20, 0, 42)
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "PHUCMAX"
titleLabel.TextColor3 = Color3.fromRGB(235, 245, 255)
titleLabel.TextScaled = true
titleLabel.Parent = containerFrame

bountyLabel = pxMakeLabel(containerFrame, 54, 24, "Bounty: 0", Enum.Font.GothamBold, 20)
timeLabel = pxMakeLabel(containerFrame, 82, 22, "Runtime: 00:00:00", Enum.Font.GothamSemibold, 16)
statusValueLabel = pxMakeLabel(containerFrame, 108, 38, "Status: Booting", Enum.Font.GothamMedium, 15)
statusValueLabel.TextYAlignment = Enum.TextYAlignment.Top

local teamText = pxMakeLabel(containerFrame, 154, 22, "Team", Enum.Font.GothamBold, 17)
local skillText = pxMakeLabel(containerFrame, 220, 22, "Skill", Enum.Font.GothamBold, 17)

local teamButton = pxMakeButton(containerFrame, "Pirates", UDim2.new(0, 160, 0, 40), UDim2.new(0, 12, 0, 178))
local uiButton = pxMakeButton(screenGui, "UI", UDim2.new(0, 56, 0, 56), UDim2.new(0, 18, 0.5, -28))
uiButton.TextSize = 22

local zBtn = pxMakeButton(containerFrame, "Z: ON", UDim2.new(0, 64, 0, 38), UDim2.new(0, 12, 0, 246))
local xBtn = pxMakeButton(containerFrame, "X: ON", UDim2.new(0, 64, 0, 38), UDim2.new(0, 82, 0, 246))
local cBtn = pxMakeButton(containerFrame, "C: ON", UDim2.new(0, 64, 0, 38), UDim2.new(0, 152, 0, 246))
local vBtn = pxMakeButton(containerFrame, "V: OFF", UDim2.new(0, 64, 0, 38), UDim2.new(0, 222, 0, 246))
local fBtn = pxMakeButton(containerFrame, "F: ON", UDim2.new(0, 64, 0, 38), UDim2.new(0, 292, 0, 246))

local uiVisible = true
local function setUiVisible(state)
    uiVisible = state
    containerFrame.Visible = state
    uiButton.Text = state and "UI" or ">"
end

uiButton.MouseButton1Click:Connect(function()
    setUiVisible(not uiVisible)
end)

pcall(function()
    tween = TweenService:Create(containerFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -382, 0.5, -160)
    })
    if tween then tween:Play() end
end)

-- Khởi tạo cài đặt cơ bản nếu chưa tồn tại
if not getgenv().Setting then
    getgenv().Setting = {
        ["YOU"] = {
            ["Team"] = getgenv().team or "Pirates",
        },
        ["Webhook"] = {
            ["Enabled"] = false,
            ["Url"] = ""
        },
        ["Chat"] = {
            ["Enabled"] = false,
            ["List"] = {"Zynex hub [Skid]"},
        }
    }
end

if not getgenv().Setting.Melee then
    getgenv().Setting.Melee = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1.5
    }
end

if not getgenv().Setting.Sword then
    getgenv().Setting.Sword = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    }
end

if not getgenv().Setting.Gun then
    getgenv().Setting.Gun = {
        ["Enable"] = false,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1,
        ["GunMode"] = false
    }
end

if not getgenv().Setting.Fruit then
    getgenv().Setting.Fruit = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0.1},
        ["F"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    }
end

if not getgenv().Setting.Click then
    getgenv().Setting.Click = {
        ["FastClick"] = true,
        ["AlwaysClick"] = true
    }
end

if not getgenv().Setting.Hunt then
    getgenv().Setting.Hunt = {
        ["Min"] = 2500000,
        ["Max"] = 30000000
    }
end

if not getgenv().Setting.Skip then
    getgenv().Setting.Skip = {
        ["V4"] = true,
        ["Fruit"] = false,
        ["FruitList"] = {"Buddha", "Leopard", "T-Rex"},
        ["SafeZone"] = true,
        ["NoHaki"] = true,
        ["NoPvP"] = true
    }
end

if not getgenv().Setting.SafeHealth then
    getgenv().Setting.SafeHealth = {
        ["Health"] = 7000,
        ["Mask"] = false,
        ["MaskType"] = "Mask",
        ["RaceV4"] = false
    }
end

if not getgenv().Setting.Another then
    getgenv().Setting.Another = {
        ["V3"] = true,
        ["V4"] = true,
        ["CustomHealth"] = true,
        ["Health"] = 7000,
        ["WhiteScreen"] = false,
        ["FPSBoots"] = true,
        ["LockCamera"] = false,
        ["AutoServerHop"] = true,
        ["HopWhenNoBounty"] = true,
        ["BountyLock"] = false,
        ["BountyLockAt"] = 30000000,
        ["ServerHopAfterTime"] = false,
        ["ServerHopTime"] = 900,
        ["CheckCombatBeforeHop"] = true,
        ["MaxPlayersInServer"] = 8
    }

local function pxApplySkillToggle(keyName, enabled)
    if getgenv().Setting.Melee[keyName] then getgenv().Setting.Melee[keyName].Enable = enabled end
    if getgenv().Setting.Sword[keyName] then getgenv().Setting.Sword[keyName].Enable = enabled end
    if getgenv().Setting.Gun[keyName] then getgenv().Setting.Gun[keyName].Enable = enabled end
    if getgenv().Setting.Fruit[keyName] then getgenv().Setting.Fruit[keyName].Enable = enabled end
end

local skillState = {
    Z = getgenv().Setting.Fruit.Z.Enable,
    X = getgenv().Setting.Fruit.X.Enable,
    C = getgenv().Setting.Fruit.C.Enable,
    V = getgenv().Setting.Fruit.V.Enable,
    F = getgenv().Setting.Fruit.F.Enable,
}

local function pxRefreshConfigUi()
    if teamButton then
        teamButton.Text = "Team: " .. tostring(getgenv().team)
    end
    if zBtn then zBtn.Text = "Z: " .. (skillState.Z and "ON" or "OFF") end
    if xBtn then xBtn.Text = "X: " .. (skillState.X and "ON" or "OFF") end
    if cBtn then cBtn.Text = "C: " .. (skillState.C and "ON" or "OFF") end
    if vBtn then vBtn.Text = "V: " .. (skillState.V and "ON" or "OFF") end
    if fBtn then fBtn.Text = "F: " .. (skillState.F and "ON" or "OFF") end
end

if teamButton then
    teamButton.MouseButton1Click:Connect(function()
        getgenv().team = (getgenv().team == "Pirates" and "Marines" or "Pirates")
        getgenv().Setting.YOU.Team = getgenv().team
        pxRefreshConfigUi()
    end)
end

if zBtn then
    zBtn.MouseButton1Click:Connect(function()
        skillState.Z = not skillState.Z
        pxApplySkillToggle("Z", skillState.Z)
        pxRefreshConfigUi()
    end)
end
if xBtn then
    xBtn.MouseButton1Click:Connect(function()
        skillState.X = not skillState.X
        pxApplySkillToggle("X", skillState.X)
        pxRefreshConfigUi()
    end)
end
if cBtn then
    cBtn.MouseButton1Click:Connect(function()
        skillState.C = not skillState.C
        pxApplySkillToggle("C", skillState.C)
        pxRefreshConfigUi()
    end)
end
if vBtn then
    vBtn.MouseButton1Click:Connect(function()
        skillState.V = not skillState.V
        pxApplySkillToggle("V", skillState.V)
        pxRefreshConfigUi()
    end)
end
if fBtn then
    fBtn.MouseButton1Click:Connect(function()
        skillState.F = not skillState.F
        pxApplySkillToggle("F", skillState.F)
        pxRefreshConfigUi()
    end)
end

pxRefreshConfigUi()

-- Khởi tạo biến toàn cục
getgenv().weapon = nil
getgenv().targ = nil 
getgenv().lasttarrget = nil
getgenv().checked = {}
getgenv().pl = game.Players:GetPlayers()
getgenv().killed = nil


-- Định nghĩa thế giới và cấu hình đảo
local placeId = game.PlaceId
local worldMap = {
    [2753915549] = true,
    [4442272183] = true,
    [100117331123089] = true
}
if worldMap[placeId] then
    if placeId == 2753915549 then
        World1 = true
    elseif placeId == 4442272183 then
        World2 = true
    elseif placeId == 100117331123089 then
        World3 = true
    end
else
    game:GetService("Players").LocalPlayer:Kick("Not Support Game")
			end
-- Cấu hình đảo dựa trên thế giới
local distbyp, island
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
elseif World2 then 
    distbyp = 3500
    island = { 
        a = CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938),
        b = CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094),
        c = CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375),
        d = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344),
        e = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828), 
        f = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875),
        g = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188),
        h = CFrame.new(923.40197753906, 125.05712890625, 32885.875),
        i = CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125),
    }
elseif World1 then 
    distbyp = 1500
    island = { 
        a = CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594), 
        b = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156), 
        c = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688), 
        d = CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969), 
        e = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754), 
        f = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094),
        g = CFrame.new(-4607.82275, 872.54248, -1667.55688), 
        h = CFrame.new(-7952.31006, 5545.52832, -320.704956),
        i = CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313),
        j = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969),
        k = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469),
        l = CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813),
        m = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875),
        n = CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875),
        o = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),
        p = CFrame.new(-4813.0249, 903.708557, -1912.69055),
        q = CFrame.new(-4970.21875, 717.707275, -2622.35449),
    } 
end

-- Định nghĩa biến cục bộ
local p = game.Players
local lp = p.LocalPlayer

-- === PHUCMAX V3 CORE ===
local PHUCMAX = rawget(getgenv(), "PHUCMAX") or {}
getgenv().PHUCMAX = PHUCMAX
PHUCMAX.Version = "V3.2"
PHUCMAX.CreatedAt = os.time()
PHUCMAX.Status = "Booting"
PHUCMAX.TargetName = "None"
PHUCMAX.LastError = ""
PHUCMAX.LastAction = "Idle"
PHUCMAX.Runtime = 0
PHUCMAX.Logs = PHUCMAX.Logs or {}
PHUCMAX.Connections = PHUCMAX.Connections or {}
PHUCMAX.Theme = {
    Accent = Color3.fromRGB(102, 180, 255),
    Accent2 = Color3.fromRGB(80, 145, 255),
    Text = Color3.fromRGB(240, 244, 255),
    Muted = Color3.fromRGB(175, 185, 210),
    Success = Color3.fromRGB(90, 255, 150),
    Warning = Color3.fromRGB(255, 212, 90),
    Danger = Color3.fromRGB(255, 106, 106)
}

local function pxLog(msg, kind)
    local line = "[PHUCMAX/" .. tostring(kind or "INFO") .. "] " .. tostring(msg)
    table.insert(PHUCMAX.Logs, 1, line)
    if #PHUCMAX.Logs > 40 then
        table.remove(PHUCMAX.Logs)
    end
    print(line)
end

local function pxSafeCall(tag, fn, ...)
    local args = {...}
    local ok, result = pcall(function()
        return fn(unpack(args))
    end)
    if not ok then
        PHUCMAX.LastError = tostring(result)
        pxLog(tag .. " failed: " .. tostring(result), "ERROR")
    end
    return ok, result
end

local function pxBind(signal, fn)
    local ok, conn = pcall(function()
        return signal:Connect(fn)
    end)
    if ok and conn then
        table.insert(PHUCMAX.Connections, conn)
        return conn
    end
end

local function pxSetStatus(status, action)
    PHUCMAX.Status = tostring(status or PHUCMAX.Status)
    if action ~= nil then
        PHUCMAX.LastAction = tostring(action)
    end
end

local function pxCharacter()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function pxHumanoidRootPart(model)
    if model and model:FindFirstChild("HumanoidRootPart") then
        return model.HumanoidRootPart
    end
    return nil
end

local function pxHumanoid(model)
    if model then
        return model:FindFirstChildOfClass("Humanoid") or model:FindFirstChild("Humanoid")
    end
    return nil
end

local function pxAlive(model)
    local hum = pxHumanoid(model)
    return hum and hum.Health > 0
end

local function pxFindToolByTooltip(tooltip)
    for _, item in ipairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltip then
            return item
        end
    end
    local ch = lp.Character
    if ch then
        for _, item in ipairs(ch:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip == tooltip then
                return item
            end
        end
    end
    return nil
end

local function pxFormatRuntime(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function refreshMainCard()
    local bountyValue = 0
    local leaderstats = lp:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Bounty/Honor") then
        bountyValue = leaderstats["Bounty/Honor"].Value
    end

    bountyLabel.Text = "Bounty: " .. tostring(bountyValue)
    timeLabel.Text = "Runtime: " .. pxFormatRuntime(PHUCMAX.Runtime)

    local actionText = tostring(PHUCMAX.Status)
    if PHUCMAX.LastAction and PHUCMAX.LastAction ~= "" then
        actionText = actionText .. " | " .. tostring(PHUCMAX.LastAction)
    end
    if PHUCMAX.TargetName and PHUCMAX.TargetName ~= "None" then
        actionText = actionText .. "
Target: " .. tostring(PHUCMAX.TargetName)
    end

    statusValueLabel.Text = actionText
end

pxBind(game:GetService("RunService").Heartbeat, function()
    PHUCMAX.Runtime = math.floor(tick() - startTime)
    refreshMainCard()
end)

pxBind(lp.CharacterAdded, function(char)
    task.delay(1, function()
        pxSafeCall("character setup", function()
            local hold = char:FindFirstChild("Hold", true)
            if hold then
                hold:Destroy()
            end
        end)
    end)
end)

pxLog("PHUCMAX V3.1 core loaded", "BOOT")

local rs = game:GetService("RunService")
local hb = rs.Heartbeat
local rends = rs.RenderStepped
local webhook = {} 

-- === CÁC HÀM TIỆN ÍCH ===
-- Hàm vượt qua chướng ngại
function bypass(Pos)   
    if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local dist = math.huge
    local is = nil
    
    for i, v in pairs(island) do
        if (Pos.Position-v.Position).magnitude < dist then
            is = v 
            dist = (Pos.Position-v.Position).magnitude 
        end
    end 
    
    if is == nil then return end
    
    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
            if tween then
                pcall(function() tween:Destroy() end)
            end
            
            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                
                if tween then
                   pcall(function() tween:Cancel() end)
                end
                
                repeat task.wait()
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = is  
                    else
                        break
                    end
                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is   
                
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            else
                if not stopbypass then
                    if tween then
                       pcall(function() tween:Cancel() end)
                    end
                    
                    repeat task.wait()
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = is  
                        else
                            break
                        end
                    until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is  
                    
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
                        lp.Character:SetPrimaryPartCFrame(is)
                        wait(0.1)
                        if lp.Character and lp.Character:FindFirstChild("Head") then
                            lp.Character.Head:Destroy()
                        end
                        wait(0.5)
                        
                        repeat task.wait()
                            if lp.Character and lp.Character:FindFirstChild("PrimaryPart") then
                                lp.Character.PrimaryPart.CFrame = is  
                            else
                                break
                            end
                        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                        
                        task.wait(0.5)
                    end)
                end 
            end
        end
    end
end

function to(Pos)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
            local Distance = (Pos.Position - lp.Character.HumanoidRootPart.Position).Magnitude

            if not lp.Character.PrimaryPart:FindFirstChild("Hold") then
                local Hold = Instance.new("BodyVelocity", lp.Character.PrimaryPart)
                Hold.Name = "Hold"
                Hold.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Hold.Velocity = Vector3.new(0,0,0)
            end

            if lp.Character.Humanoid.Sit then
                lp.Character.Humanoid.Sit = false
            end

            -- TP thẳng thay vì tween
            lp.Character.HumanoidRootPart.CFrame = Pos

            if lp.PlayerGui:FindFirstChild("Main") and 
               lp.PlayerGui.Main:FindFirstChild("InCombat") and
               lp.PlayerGui.Main.InCombat.Visible then

                if string.find(string.lower(lp.PlayerGui.Main.InCombat.Text),"risk") then
                    local dist = math.huge
                    local is = nil

                    for i,v in pairs(island) do
                        local d = (Pos.Position - v.Position).Magnitude
                        if d < dist then
                            dist = d
                            is = v
                        end
                    end

                    if is == nil then return end

                    if lp:DistanceFromCharacter(Pos.Position) > distbyp then
                        if (lp.Character.Head.Position-Pos.Position).Magnitude > (is.Position-Pos.Position).Magnitude then

                            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
                               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
                               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
                               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then

                                repeat task.wait()
                                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                        lp.Character.HumanoidRootPart.CFrame = is
                                    else
                                        break
                                    end
                                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is

                                task.wait(0.1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            end
                        end
                    end
                end
            end

            if lp.Character.Humanoid.Sit then
                lp.Character.Humanoid.Sit = false
            end

            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = lp.Character.HumanoidRootPart
                hrp.CFrame = CFrame.new(hrp.CFrame.X, Pos.Y, hrp.CFrame.Z)
            end
        end
    end)
end

-- Hàm sử dụng Buso (Haki)
function buso()
    if lp.Character and not lp.Character:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Hàm sử dụng Ken (Observation Haki)
function Ken()
    if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and 
       game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and 
       game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
        return true
    else
        game:service("VirtualUser"):CaptureController()
        game:service("VirtualUser"):SetKeyDown("0x65")
        game:service("VirtualUser"):SetKeyUp("0x65")
        return false
    end
end

-- Hàm nhấn phím
function down(use, wait)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, use, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
            task.wait((wait or 0.1))
            game:GetService("VirtualInputManager"):SendKeyEvent(false, use, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
        end
    end)
end

-- Hàm trang bị vũ khí
function equip(tooltip)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    local item = pxFindToolByTooltip(tooltip)
    if item and item.Parent ~= character then
        humanoid:EquipTool(item)
        pxSetStatus("Equipping", tooltip)
        return true
    end

    return item ~= nil
end

function EquipWeapon(Tool)
    pcall(function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild(Tool) then
            local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(Tool)
            if ToolHumanoid then
                ToolHumanoid.Parent = game.Players.LocalPlayer.Character
            end
        end
    end)
end

-- Hàm click
function Click()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait()
        vu:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        pxSetStatus("Attacking", "Virtual click")
    end)
end

-- === CHUẨN BỊ GAME ===
-- No Clip
spawn(function()
    while game:GetService("RunService").Stepped:wait() do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Boots FPS
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
    
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and removedecals then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end
    
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end

-- Loại bỏ đối tượng
function ObjectRemove()
    for i, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name,"Tree") or string.find(v.Name,"House") then
            pcall(function() v:Destroy() end)
        end
    end
end

-- Đối tượng vô hình
function InvisibleObject()
    for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if (v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart")) and v.Transparency then
            v.Transparency = 1
        end
    end
    
    spawn(function()
        pcall(function()
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Death") then
                game.ReplicatedStorage.Effect.Container.Death:Destroy()
            end
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Respawn") then
                game.ReplicatedStorage.Effect.Container.Respawn:Destroy()
            end
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Hit") then
                game.ReplicatedStorage.Effect.Container.Hit:Destroy()
            end
        end)
    end)
end

ObjectRemove()
InvisibleObject()

-- White Screen
if getgenv().Setting.Another.WhiteScreen then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end	

-- === HÀM CHÍNH AUTO BOUNTY ===
-- Kiểm tra fruit
function hasValue(array, targetString)
    if not array then return false end
    for _, value in ipairs(array) do
        if value == targetString then
            return true
        end
    end
    return false
end

-- Fast Attack
if getgenv().Setting.Click.FastClick then
    local fastattack = true
    local y = nil
    
    -- Cố gắng lấy CombatFramework
    pcall(function()
        local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
        if CameraShaker then
            CameraShaker:Stop()
        end
        
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts") then
            local success, result = pcall(function()
                return require(game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework"))
            end)
            
            if success and result then
                local getCombatFramework = result
                local getCombatFrameworkR = debug.getupvalues(getCombatFramework)[2]
                y = getCombatFrameworkR
            end
        end
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if fastattack and y and typeof(y) == "table" then
                pcall(function()
                    if y.activeController then
                        y.activeController.timeToNextAttack = 0
                        y.activeController.hitboxMagnitude = 60
                        y.activeController.active = false
                        y.activeController.timeToNextBlock = 0
                        y.activeController.focusStart = 1655503339.0980349
                        y.activeController.increment = 1
                        y.activeController.blocking = false
                        y.activeController.attacking = false
                        if y.activeController.humanoid then
                            y.activeController.humanoid.AutoRotate = true
                        end
                    end
                end)
            end
        end)
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if fastattack == true and lp and lp.Character then
                if lp.Character:FindFirstChild("Stun") then
                    lp.Character.Stun.Value = 0
                end
                if lp.Character:FindFirstChild("Busy") then
                    lp.Character.Busy.Value = false 
                end
            end
        end)
    end)
else
    local y = nil
    
    -- Cố gắng lấy CombatFramework
    pcall(function()
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts") then
            local success, result = pcall(function()
                return require(game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework"))
            end)
            
            if success and result then
                local getCombatFramework = result
                local getCombatFrameworkR = debug.getupvalues(getCombatFramework)[2]
                y = getCombatFrameworkR
            end
        end
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if y and typeof(y) == "table" then
                pcall(function()
                    if y.activeController then
                        y.activeController.hitboxMagnitude = 60
                        y.activeController.active = false
                        y.activeController.timeToNextBlock = 0
                        y.activeController.focusStart = 1655503339.0980349
                        y.activeController.increment = 1
                        y.activeController.blocking = false
                        y.activeController.attacking = false
                        if y.activeController.humanoid then
                            y.activeController.humanoid.AutoRotate = true
                        end
                    end
                end)
            end
        end)
    end)
end

-- Circle
local radius = 25
local speedCircle = 30
local angle = 0
local yTween = 5
local function getNextPosition(center)
    angle = angle + speedCircle
    return center + Vector3.new(math.sin(math.rad(angle)) * radius, yTween, math.cos(math.rad(angle)) * radius)
end

-- Hop Server
local hopserver = false
local starthop = false
local stopbypass = false

spawn(function()
    while task.wait() do
        if hopserver then
            stopbypass = true
            starthop = true
        end
    end
end)

spawn(function()
    while task.wait() do
        if starthop then
            repeat task.wait()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    to(lp.Character.HumanoidRootPart.CFrame*CFrame.new(0, math.random(500, 10000), 0))
                end
            until (lp.PlayerGui and lp.PlayerGui:FindFirstChild("Main") and 
                  lp.PlayerGui.Main:FindFirstChild("InCombat") and
                  lp.PlayerGui.Main.InCombat.Visible and 
                  not string.find(string.lower(lp.PlayerGui.Main.InCombat.Text), "risk")) or 
                  (lp.PlayerGui and lp.PlayerGui:FindFirstChild("Main") and
                  lp.PlayerGui.Main:FindFirstChild("InCombat") and 
                  not lp.PlayerGui.Main.InCombat.Visible)
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                to(CFrame.new(0, 10000, 0))
            end
            
            HopServer()
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                to(lp.Character.HumanoidRootPart.CFrame*CFrame.new(0, math.random(500, 10000), 0))
            end
        end
    end
end)

-- Hàm chuyển server
function CheckInComBat()
    local ok, value = pcall(function()
        local hud = game.Players.LocalPlayer.PlayerGui.Main.BottomHUDList.InCombat
        return hud.Visible and hud.Text and string.find(string.lower(hud.Text), "risk")
    end)
    return ok and value or false
end 
function HopServer(counts)
    pxSetStatus("ServerHop", "Searching low population server")
    if counts == nil then
        counts = 10
    end
    local function handleTeleportPrompt(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible then
                if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                    v.Visible = false
                end
            end
            v:GetPropertyChangedSignal("Visible"):Connect(
                function()
                    if v.Visible then
                        if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                            v.Visible = false
                        end
                    end
                end
            )
        end
    end
    for i, v in game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren() do
        handleTeleportPrompt(v)
    end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(handleTeleportPrompt)
    game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = "Singapore"
    while wait() do
        if not CheckInComBat() then
            for r = 1, math.huge do
                for k, v in game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) do
                    if k ~= game.JobId and v["Count"] <= counts then
                        game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k)
                    end
                end
            end
        end
    end
end

-- Đăng ký hàm HopServer cho UI
getgenv().HopServer = HopServer

-- Skip Player
function SkipPlayer()
    pxLog("Đã bỏ qua mục tiêu hiện tại", "WARN")
    getgenv().killed = getgenv().targ
    if getgenv().targ then
        table.insert(getgenv().checked, getgenv().targ)
    end
    getgenv().targ = nil
    PHUCMAX.TargetName = "None"
    pxSetStatus("Searching", "Skip target")
    target()
end

-- Đăng ký hàm SkipPlayer cho UI
getgenv().SkipPlayer = SkipPlayer

function CheckSafeZone(nitga)
    if not nitga then
        return false
    end

    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    local safeZones = worldOrigin and worldOrigin:FindFirstChild("SafeZones")
    if not safeZones then
        return false
    end

    for _, v in ipairs(safeZones:GetChildren()) do
        if v and v:IsA("BasePart") then
            local extra = math.max(v.Size.X, v.Size.Z) * 0.5
            if (v.Position - nitga.Position).Magnitude <= (extra + 20) then
                return true
            end
        end
    end
    return false
end

local function IsTargetEligible(v, myRoot)
    if not v or v == lp or hasValue(getgenv().checked, v) then
        return false
    end

    local validTeam = v.Team ~= nil and (tostring(lp.Team) == "Pirates" or (tostring(v.Team) == "Pirates" and tostring(lp.Team) ~= "Pirates"))
    if not validTeam then
        return false
    end

    local data = v:FindFirstChild("Data")
    local char = v.Character
    local root = pxHumanoidRootPart(char)
    local hum = pxHumanoid(char)
    local leaderstats = v:FindFirstChild("leaderstats")
    local bountyStat = leaderstats and leaderstats:FindFirstChild("Bounty/Honor")
    if not (data and root and hum and hum.Health > 0 and bountyStat and not hopserver) then
        return false
    end

    if root.Position.Y > 12000 or CheckSafeZone(root) then
        return false
    end

    local fruitOk = true
    if getgenv().Setting.Skip.Fruit then
        fruitOk = data:FindFirstChild("DevilFruit") and not hasValue(getgenv().Setting.Skip.FruitList, data.DevilFruit.Value)
    end
    if not fruitOk then
        return false
    end

    local levelStat = data:FindFirstChild("Level")
    local levelOk = levelStat and lp:FindFirstChild("Data") and lp.Data:FindFirstChild("Level") and (tonumber(lp.Data.Level.Value) - 250) < levelStat.Value
    local bountyOk = bountyStat.Value >= getgenv().Setting.Hunt.Min and bountyStat.Value <= getgenv().Setting.Hunt.Max
    local v4Ok = (getgenv().Setting.Skip.V4 and not char:FindFirstChild("RaceTransformed")) or not getgenv().Setting.Skip.V4
    if not (levelOk and bountyOk and v4Ok) then
        return false
    end

    local distance = (root.Position - myRoot.Position).Magnitude
    return true, distance
end

-- Target Selection
function target()
    pxSafeCall("target", function()
        pxSetStatus("Searching", "Scanning players outside safe zone")
        local closestDistance = math.huge
        local picked = nil
        getgenv().targ = nil

        local myCharacter = lp.Character
        local myRoot = pxHumanoidRootPart(myCharacter)
        if not myRoot then
            return
        end

        for _, v in ipairs(game.Players:GetPlayers()) do
            local ok, distance = IsTargetEligible(v, myRoot)
            if ok and distance < closestDistance then
                picked = v
                closestDistance = distance
            end
        end

        getgenv().targ = picked
        if picked then
            PHUCMAX.TargetName = picked.Name
            pxSetStatus("TargetLocked", "Target = " .. picked.Name)
            if getgenv().Setting.Chat.Enabled and getgenv().Setting.Chat.List and #getgenv().Setting.Chat.List > 0 then
                local chatMsg = getgenv().Setting.Chat.List[math.random(1, #getgenv().Setting.Chat.List)]
                if chatMsg then
                    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(chatMsg, "All")
                end
            end
            pxLog("Đã khóa mục tiêu: " .. picked.Name, "OK")
        else
            PHUCMAX.TargetName = "None"
            pxSetStatus("ServerHop", "Không có mục tiêu ngoài safe zone")
            pxLog("Không có mục tiêu hợp lệ ở ngoài safe zone, chuyển server", "WARN")
            HopServer()
        end
    end)
end

spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") then
                if CheckSafeZone(getgenv().targ.Character.HumanoidRootPart) then
                    pxSetStatus("Searching", getgenv().targ.Name .. " đang ở safe zone")
                    SkipPlayer()
                else
                    PHUCMAX.TargetName = getgenv().targ.Name
                end
            elseif not hopserver then
                target()
            end
        end)
    end
end)

-- Kết nối Ken khi gần với mục tiêu
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and lp.Character and
               (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                Ken()
            end
        end)
    end
end)

-- Logic xoay vòng vũ khí
local gunmethod = getgenv().Setting.Gun.GunMode
local weaponOrder = {"Blox Fruit", "Sword", "Melee", "Gun"}
local weaponSettingsMap = {
    ["Blox Fruit"] = getgenv().Setting.Fruit,
    ["Sword"] = getgenv().Setting.Sword,
    ["Melee"] = getgenv().Setting.Melee,
    ["Gun"] = getgenv().Setting.Gun,
}
local weaponSkillMap = {
    ["Blox Fruit"] = {"Z", "X", "C", "V", "F"},
    ["Sword"] = {"Z", "X"},
    ["Melee"] = {"Z", "X", "C"},
    ["Gun"] = {"Z", "X"},
}
local currentWeaponName = nil
local lastWeaponSwitch = 0

local function isWeaponEnabled(name)
    local cfg = weaponSettingsMap[name]
    return cfg and cfg.Enable
end

local function ensureCurrentWeapon()
    if currentWeaponName and isWeaponEnabled(currentWeaponName) then
        return currentWeaponName, weaponSettingsMap[currentWeaponName]
    end
    for _, name in ipairs(weaponOrder) do
        if isWeaponEnabled(name) then
            currentWeaponName = name
            return currentWeaponName, weaponSettingsMap[currentWeaponName]
        end
    end
    currentWeaponName = "Melee"
    return currentWeaponName, getgenv().Setting.Melee
end

local function getSkillContainer(tool)
    if not tool or not lp.PlayerGui:FindFirstChild("Main") or not lp.PlayerGui.Main:FindFirstChild("Skills") then
        return nil
    end
    return lp.PlayerGui.Main.Skills:FindFirstChild(tool.Name)
end

local function isSkillReady(skillRoot, keyName, cfg)
    if not skillRoot or not cfg or not cfg.Enable then
        return false
    end
    local slot = skillRoot:FindFirstChild(keyName)
    if not slot then
        return false
    end
    local cooldown = slot:FindFirstChild("Cooldown")
    if not cooldown then
        return true
    end
    return cooldown.AbsoluteSize.X <= 0
end

local function tryUseSkill(skillRoot, keyName, cfg)
    if isSkillReady(skillRoot, keyName, cfg) then
        down(keyName, cfg.HoldTime or 0.1)
        return true
    end
    return false
end

local function getEquippedOrRequestedTool(tooltip)
    equip(tooltip)
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == tooltip then
        return tool
    end
    return pxFindToolByTooltip(tooltip)
end

local function getReadySkillForWeapon(tooltip)
    local cfg = weaponSettingsMap[tooltip]
    if not (cfg and cfg.Enable) then
        return nil, nil
    end

    local tool = getEquippedOrRequestedTool(tooltip)
    if not tool then
        return nil, nil
    end

    local skillRoot = getSkillContainer(tool)
    for _, keyName in ipairs(weaponSkillMap[tooltip] or {}) do
        if isSkillReady(skillRoot, keyName, cfg[keyName]) then
            return keyName, skillRoot
        end
    end
    return nil, skillRoot
end

local function switchWeapon(name, reason)
    if not name then
        return false
    end
    if currentWeaponName ~= name and tick() - lastWeaponSwitch >= 0.2 then
        currentWeaponName = name
        lastWeaponSwitch = tick()
        pxSetStatus("WeaponSwitch", reason or ("Switch to " .. name))
    end
    getgenv().weapon = currentWeaponName
    return equip(currentWeaponName)
end

local function findNextReadyWeapon()
    local startName = ensureCurrentWeapon()
    local startIndex = 1
    for index, name in ipairs(weaponOrder) do
        if name == startName then
            startIndex = index
            break
        end
    end

    for offset = 0, #weaponOrder - 1 do
        local idx = ((startIndex - 1 + offset) % #weaponOrder) + 1
        local name = weaponOrder[idx]
        if isWeaponEnabled(name) then
            local readyKey = getReadySkillForWeapon(name)
            if readyKey then
                return name, readyKey
            end
        end
    end
    return nil, nil
end

local function useCurrentWeapon()
    local tooltip, cfg = ensureCurrentWeapon()
    getgenv().weapon = tooltip

    local readyKey, skillRoot = getReadySkillForWeapon(tooltip)
    if readyKey then
        pxSetStatus("Combat", tooltip .. " > " .. readyKey)
        tryUseSkill(skillRoot, readyKey, cfg[readyKey])
        return
    end

    local nextWeapon, nextKey = findNextReadyWeapon()
    if nextWeapon and nextKey and nextWeapon ~= tooltip then
        switchWeapon(nextWeapon, "All skills cooldown on " .. tooltip)
        task.wait(0.05)
        local nextCfg = weaponSettingsMap[nextWeapon]
        local actualKey, actualSkillRoot = getReadySkillForWeapon(nextWeapon)
        if actualKey then
            pxSetStatus("Combat", nextWeapon .. " > " .. actualKey)
            tryUseSkill(actualSkillRoot, actualKey, nextCfg[actualKey])
            return
        end
    end

    pxSetStatus("Combat", tooltip .. " waiting cooldown")
    if getgenv().Setting.Click.AlwaysClick then
        Click()
    end
end

-- PvP và khả năng đặc biệt
spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main:FindFirstChild("PvpDisabled") and lp.PlayerGui.Main.PvpDisabled.Visible then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end

            if getgenv().targ and getgenv().targ.Character and lp.Character and
               getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("HumanoidRootPart") and
               (getgenv().targ.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 50 then
                buso()

                if getgenv().Setting.Another.V3 and getgenv().Setting.Another.CustomHealth and
                   lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= getgenv().Setting.Another.Health then
                    down("T", 0.1)
                end

                if getgenv().Setting.Another.V4 then
                    down("Y", 0.1)
                end
            end
        end)
    end
end)

-- Logic chiến đấu
spawn(function()
    while task.wait(0.1) do
        if not getgenv().targ or not getgenv().targ.Character then
            target()
        end

        if not getgenv().targ then
            hopserver = true
        end

        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and
               getgenv().targ.Character:FindFirstChild("Humanoid") and
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then

                local distance = (getgenv().targ.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                if distance < 40 then
                    useCurrentWeapon()

                    if CheckSafeZone(getgenv().targ.Character.HumanoidRootPart) or
                       (lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main:FindFirstChild("[OLD]SafeZone") and lp.PlayerGui.Main["[OLD]SafeZone"].Visible) or
                       getgenv().targ.Character.Humanoid.Sit then
                        SkipPlayer()
                    end

                    if lp.PlayerGui:FindFirstChild("Notifications") then
                        for _, notification in pairs(lp.PlayerGui.Notifications:GetChildren()) do
                            if notification:IsA("TextLabel") then
                                local lowerText = string.lower(notification.Text)
                                if string.find(lowerText, "player") or string.find(lowerText, "người chơi") then
                                    SkipPlayer()
                                    pcall(function() notification:Destroy() end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Logic di chuyển và định vị
local a, b
local Nguvc = 5
local helloae = false
local safehealth = false

spawn(function()
    while task.wait(0.05) do
        if not getgenv().targ then target() end
        if not getgenv().targ then hopserver = true end 
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.BottomHUDList.PvpDisabled.Visible then
            pcall(function()
                if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and 
                lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
                lp.Character:FindFirstChild("Humanoid") then
                    
                    if lp.Character.Humanoid.Health > getgenv().Setting.SafeHealth.Health then
                        pcall(function()    
                            if not (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and 
                                getgenv().targ:DistanceFromCharacter(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").Position) < 10000) then
                                workspace.CurrentCamera.CameraSubject = getgenv().targ.Character
                                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.SafeZone.Visible == true then
                                        print("Safe Zone")
                                        SkipPlayer()
                                    end
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        if getgenv().Setting.Click.AlwaysClick then
                                            Click()
                                        end
                                        
                                        if helloae then
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        else
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        end
                                    else 
                                        print("Player Died")
                                        SkipPlayer()
                                    end
                                else
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                    else
                                        print("Player Died")
                                        SkipPlayer()
                                    end
                                end
                            else
                                print("Raid")
                                SkipPlayer()
                            end
                        end)
                        
                        a = getgenv().targ.Character.HumanoidRootPart.Position
                        
                        if a ~= b then
                            yTween = 0
                            b = a
                            
                            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                                Nguvc = 14
                            else
                                Nguvc = 15
                            end
                        else
                            yTween = 5
                            
                            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                                Nguvc = 3
                            else
                                Nguvc = 5
                            end
                        end
                        
                        if getgenv().targ.Character.HumanoidRootPart.CFrame.Y >= 10 then
                            helloae = true
                        else
                            helloae = false
                        end
                    else
                        safehealth = true
                        
                        if getgenv().targ.Character:FindFirstChild("HumanoidRootPart") then
                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, math.random(5000, 100000), 0))
                        end
                    end
                end
            end)
        else
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
        end
    end
end)

-- Logic nhắm
local aim = false
local CFrameHunt

spawn(function()
    while task.wait() do 
        if getgenv().targ and getgenv().targ.Character and 
           lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
           (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
            
            aim = true 
            
            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                CFrameHunt = CFrame.new(
                    getgenv().targ.Character.HumanoidRootPart.Position + 
                    getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 2, 
                    getgenv().targ.Character.HumanoidRootPart.Position
                )
            else
                CFrameHunt = CFrame.new(
                    getgenv().targ.Character.HumanoidRootPart.Position + 
                    getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 5, 
                    getgenv().targ.Character.HumanoidRootPart.Position
                )
            end
        else
            aim = false
        end
    end
end)

-- Remote hook cho nhắm
spawn(function()
    if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then
        pxLog("Executor không hỗ trợ namecall hook, bỏ qua aim hook", "WARN")
        return
    end

    local ok, err = pcall(function()
        local gg = getrawmetatable(game)
        local old = gg.__namecall
        setreadonly(gg, false)

        gg.__namecall = newcclosure(function(...)
            local method = getnamecallmethod()
            local args = {...}

            if tostring(method) == "FireServer" and tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if aim and CFrameHunt then
                        args[2] = CFrameHunt.Position
                        return old(unpack(args))
                    end
                end
            end

            return old(...)
        end)
        setreadonly(gg, true)
    end)

    if not ok then
        PHUCMAX.LastError = tostring(err)
        pxLog("Aim hook lỗi: " .. tostring(err), "ERROR")
    end
end)

-- Nhắm chuột
local Mouse = lp:GetMouse()

Mouse.Button1Down:Connect(function()
    pcall(function()
        if getgenv().targ and aim and CFrameHunt then
            local args = {
                [1] = CFrameHunt.Position,
                [2] = getgenv().targ.Character.HumanoidRootPart
            }
            
            local tool = lp.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("RemoteFunctionShoot") then
                tool.RemoteFunctionShoot:InvokeServer(unpack(args))
            end
        end
    end)
end)

-- Khóa camera
spawn(function()
    while task.wait() do
        if getgenv().Setting.Another.LockCamera then
            local targetPlayer = getgenv().targ
            
            if targetPlayer and targetPlayer.Character then
                local targetCharacter = targetPlayer.Character
                local camera = game.Workspace.CurrentCamera
                
                if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                    local lookAtPos = targetCharacter.HumanoidRootPart.Position
                    local cameraPos = camera.CFrame.Position
                    local newLookAt = CFrame.new(cameraPos, lookAtPos)
                    camera.CFrame = newLookAt
                end
            end
        end
    end
end)

-- Tự động tham gia lại khi mất kết nối
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if not hopserver and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        print("PHUCMAX | Đang vào lại!")
        print("Bị ngắt kết nối, đang vào lại...", "warning")
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

-- === PHUCMAX V3.1 MONITOR ===
spawn(function()
    while task.wait(1) do
        pxSafeCall("ui monitor", function()
            refreshMainCard()
            if getgenv().targ and getgenv().targ.Parent == game.Players then
                PHUCMAX.TargetName = getgenv().targ.Name
            else
                PHUCMAX.TargetName = "None"
            end
        end)
    end
end)

-- === WEBHOOK ===
local Urlsent = getgenv().Setting.Webhook.Url

function wSend(main)
    spawn(function()
        local success, error = pcall(function()
            local Data = game:GetService("HttpService"):JSONEncode(main)
            local Head = {["content-type"] = "application/json"}
            local Send = http_request or request or HttpPost or syn.request 
            
            if Send then 
                Send({Url = Urlsent, Body = Data, Method = "POST", Headers = Head})
            end
        end)
        
        if not success then
            print("Lỗi webhook: " .. tostring(error))
        end
    end)
end 

function wEarn(targ, earn, total) 
    if getgenv().Setting.Webhook.Enabled and getgenv().killed then
        local targetName = "Unknown"
        if targ and targ.Name then
            targetName = targ.Name
        end
        
        local data = {
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "**PHUCMAX | Auto Bounty**",
                    ["color"] = 3447003, -- Màu xanh dương Discord
                    ["fields"] = {
                        {
                            ["name"] = "Tài khoản: ",
                            ["value"] = "||"..game.Players.LocalPlayer.Name.."||",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Mục tiêu: ",
                            ["value"] = "```"..targetName.."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Bounty thu được: ",
                            ["value"] = "```Earned: "..tostring(earn).."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Tổng Bounty: ",
                            ["value"] = "```Earned: "..tostring(total).."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Bounty hiện tại: ",
                            ["value"] = "```"..(math.round((game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Value / 1000000)*100)/100).."M```",
                            ["inline"] = false,
                        }
                    },
                    ["thumbnail"] = {
                        ["url"] = "https://cdn.discordapp.com/attachments/1338107245983957013/1352284325386784850/Untitled524_20240705122146.png?ex=67dd746b&is=67dc22eb&hm=9271d0158ce1b078c61e2a5358ef80f1ff5e5619de9e159c2fe867a4a5ee734b&",
                    },
                    ["footer"] = {
                        ["text"] = "PHUCMAX",
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }
            }
        }
        
        wSend(data)
    end
end

-- PHUCMAX: đã vô hiệu hóa khối gửi thông tin tài khoản/HWID để tránh lộ dữ liệu người dùng.


-- === PHUCMAX V3.1 NOTES ===
-- V3.1 vá lỗi UI nil trên một số executor bằng cách bọc toàn bộ khối dựng giao diện trong pcall và có fallback UI đơn giản.
-- Giữ logic đổi tool chỉ khi skill của tool hiện tại đang cooldown hết, và tiếp tục kiểm tra safe zone liên tục.
-- Mục tiêu là tránh crash ngay lúc khởi tạo giao diện trên Delta / executor tương tự.
