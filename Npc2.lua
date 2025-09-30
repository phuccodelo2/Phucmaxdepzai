-- PHUCMAX Camlock + Teleport + Vòng quanh NPC2 + Auto Click + UI Hiển thị máu Quái
-- Đã chỉnh sửa: Farm sẽ teleport lên đầu quái (NPC2), bám trên đầu 3 giây, quái không đánh được.
-- Sau 3s mới bắt đầu xoay quanh boss (orbit), chân chạm mặt đất.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local function notify(t, tx)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = t; Text = tx; Duration = 4})
    end)
end

local function getNPC()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "NPC2" and obj:FindFirstChild("HumanoidRootPart") then
            return obj
        end
    end
    return nil
end

-- UI Main
local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_UI"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(250, 110)
frame.Position = UDim2.new(0.07, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2.5

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.fromOffset(10, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "PHUCMAX  FARM BOSS"
title.TextColor3 = Color3.fromRGB(255,255,255)

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(1, -20, 0, 48)
btn.Position = UDim2.fromOffset(10, 52)
btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
btn.AutoButtonColor = true
btn.Text = "Farm BOSS: OFF"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Thickness = 1.8

-- UI Hiển thị máu Quái (NPC2) ở trên giữa màn hình
local hpGUI = Instance.new("ScreenGui")
hpGUI.Name = "PHUCMAX_HP_GUI"
hpGUI.ResetOnSpawn = false
hpGUI.Parent = gui.Parent

local hpFrame = Instance.new("Frame")
hpFrame.Parent = hpGUI
hpFrame.BackgroundTransparency = 0.35
hpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
hpFrame.BorderSizePixel = 0
hpFrame.Size = UDim2.new(0, 210, 0, 38)
hpFrame.Position = UDim2.new(0.5, -105, 0, 2)
Instance.new("UICorner", hpFrame).CornerRadius = UDim.new(0, 14)
local hpStroke = Instance.new("UIStroke", hpFrame)
hpStroke.Thickness = 2

local hpBar = Instance.new("Frame")
hpBar.Parent = hpFrame
hpBar.BackgroundColor3 = Color3.fromRGB(255,70,70)
hpBar.BorderSizePixel = 0
hpBar.Position = UDim2.new(0,8,0,22)
hpBar.Size = UDim2.new(0.95, -16,0,10)
Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 8)

local hpText = Instance.new("TextLabel")
hpText.Parent = hpFrame
hpText.Size = UDim2.new(1, -16, 0, 20)
hpText.Position = UDim2.fromOffset(8, 2)
hpText.BackgroundTransparency = 1
hpText.Font = Enum.Font.GothamBold
hpText.TextScaled = true
hpText.Text = "Máu BOSS: --/--"
hpText.TextColor3 = Color3.fromRGB(255,255,255)
hpText.TextStrokeTransparency = 0.7

-- Drag UI
do
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Rainbow hiệu ứng UI
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt*0.15) % 1
    local col = Color3.fromHSV(hue, 1, 1)
    stroke.Color = col
    btnStroke.Color = col
    title.TextColor3 = col
    hpStroke.Color = col
end)

-- Camlock & Farm Logic
local farming = false
local farmLoop = nil
local autoClickLoop = nil

local orbitConnection = nil

-- Bám trên đầu quái 3 giây (quái không đánh được)
local function stickToHeadFor3s(char, npc)
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    local targetHRP = npc:FindFirstChild("HumanoidRootPart")
    if not myHRP or not targetHRP then return end
    local start = tick()
    while farming and tick() - start < 3 do
        local posAbove = targetHRP.Position + Vector3.new(0,9.5,0)
        myHRP.CFrame = CFrame.new(posAbove, targetHRP.Position)
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetHRP.Position)
        task.wait(0.03)
    end
end

-- Orbit quanh NPC2, chân chạm đất
local function startOrbitOnGround()
    if orbitConnection then orbitConnection:Disconnect() end
    orbitConnection = RunService.RenderStepped:Connect(function()
        if not farming then return end
        local char = lp.Character
        local npc = getNPC()
        if not char or not npc then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        local targetHRP = npc:FindFirstChild("HumanoidRootPart")
        if not myHRP or not targetHRP or not targetHRP.Parent then return end

        local radius = 18.5
        local speed = 32
        local angle = tick() * speed
        local offset = Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
        
        -- Sửa chỗ này: lấy vị trí Y của boss hiện tại
        local npcY = targetHRP.Position.Y
        local pos = Vector3.new(targetHRP.Position.X + offset.X, npcY, targetHRP.Position.Z + offset.Z)
        
        myHRP.CFrame = CFrame.new(pos, targetHRP.Position)
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetHRP.Position)
    end)
end

local function stopOrbit()
    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end
end

-- Farm chính: dán đầu 3s rồi orbit quanh boss
local function farmMainLoop()
    while farming do
        local npc = getNPC()
        local char = lp.Character
        if npc and char then
            stickToHeadFor3s(char, npc) -- bám trên đầu quái 3s
            if farming then
                startOrbitOnGround() -- bắt đầu xoay quanh quái, chân chạm đất
                break -- orbit chỉ cần khởi động 1 lần
            end
        end
        task.wait(0.1)
    end
end

-- Auto Click liên tục khi farm
local function autoClick()
    while farming do
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0,0), cam.CFrame)
            task.wait(0.007)
            VirtualUser:Button1Up(Vector2.new(0,0), cam.CFrame)
        end)
        task.wait(0.009)
    end
end

-- Hiển thị máu quái (NPC2) realtime
RunService.RenderStepped:Connect(function()
    local npc = getNPC()
    if npc and npc:FindFirstChildOfClass("Humanoid") then
        local hum = npc:FindFirstChildOfClass("Humanoid")
        local hp = math.floor(hum.Health)
        local maxHp = math.floor(hum.MaxHealth)
        hpText.Text = ("Máu BOSS: %d / %d"):format(hp,maxHp)
        local pct = maxHp > 0 and hp / maxHp or 0
        hpBar.Size = UDim2.new(math.clamp(pct,0,1)*0.95, -16, 0, 10)
        hpBar.BackgroundColor3 = Color3.fromRGB(255,70,70):Lerp(Color3.fromRGB(55,255,70), pct)
    else
        hpText.Text = "Máu BOSS: --/--"
        hpBar.Size = UDim2.new(0,0,0,10)
        hpBar.BackgroundColor3 = Color3.fromRGB(255,70,70)
    end
end)

local function turnOn()
    farming = true
    btn.Text = "Farm BOSS: ON"
    cam.CameraType = Enum.CameraType.Scriptable
    farmLoop = task.spawn(farmMainLoop)
    autoClickLoop = task.spawn(autoClick)
    notify("PHUCMAX", "Farm Boss ON")
end

local function turnOff()
    farming = false
    btn.Text = "Farm BOSS: OFF"
    cam.CameraType = Enum.CameraType.Custom
    stopOrbit()
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
    if autoClickLoop then
        task.cancel(autoClickLoop)
        autoClickLoop = nil
    end
    notify("PHUCMAX", "Farm BOSS OFF")
end

btn.MouseButton1Click:Connect(function()
    if farming then turnOff() else turnOn() end
end)

notify("PHUCMAX", "tới gần quái bật lên 3s rồi mới dùng tool.nhớ bật fixlagmax và noclip ")
