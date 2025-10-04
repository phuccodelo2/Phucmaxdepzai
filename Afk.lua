--// PHUC FIX LAG MAX FULL
-- by ChatGPT (GPT-5)
-- Copy chạy được luôn

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- ⚡ Config
local TeleportPos = Vector3.new(1658.0, 19.3, -224.0)

-- 🖼️ UI Tạo lại nếu mất
local function CreateUI()
    if game.CoreGui:FindFirstChild("PhucFixLagMax") then
        game.CoreGui:FindFirstChild("PhucFixLagMax"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "PhucFixLagMax"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 220, 0, 90)
    Frame.Position = UDim2.new(0.7, 0, 0.05, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 3

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Text = "PHUCMAX ANTI AFK"
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true

    local FPSLabel = Instance.new("TextLabel", Frame)
    FPSLabel.Size = UDim2.new(1, 0, 0, 25)
    FPSLabel.Position = UDim2.new(0,0,0.35,0)
    FPSLabel.Text = "FPS: ..."
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.Code
    FPSLabel.TextScaled = true

    local PingLabel = Instance.new("TextLabel", Frame)
    PingLabel.Size = UDim2.new(1, 0, 0, 25)
    PingLabel.Position = UDim2.new(0,0,0.65,0)
    PingLabel.Text = "Ping: ..."
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.Code
    PingLabel.TextScaled = true

    -- 🌈 Rainbow Effect
    task.spawn(function()
        while task.wait(0.1) do
            local col = Color3.fromHSV(tick()%5/5,1,1)
            Stroke.Color = col
            Title.TextColor3 = col
            FPSLabel.TextColor3 = col
            PingLabel.TextColor3 = col
        end
    end)

    -- FPS + Ping Update
    local last = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - last >= 1 then
            FPSLabel.Text = "FPS: "..frameCount
            frameCount = 0
            last = tick()
        end
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        PingLabel.Text = "Ping: "..ping
    end)
end

-- 🚀 Fix Lag
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- 📌 Tọa độ Tele
local TeleportPos = Vector3.new(1658.0, 19.3, -224.0)

-- 📌 FixLag tối đa: tàng hình tất cả vật thể nhưng vẫn đứng được
local function FixLagMax()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Giữ collision để đứng được
            obj.Transparency = 1
            obj.CanCollide = true
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj.Enabled = false
        end
    end
    
    -- 📌 Giảm ánh sáng 50%
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(80,80,80)
end

-- 📌 Tele + FixLag
local function TeleAndFix()
    task.wait(2)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(TeleportPos)
        task.wait(1)
        FixLagMax()
    end
end

-- 📌 Auto chạy khi load lại nhân vật
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    TeleAndFix()
end)

-- 📌 Chạy ngay lần đầu
TeleAndFix()

-- ⛔ Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 🔁 Auto Reset mỗi 10 phút
task.spawn(function()
    while task.wait(300) do -- 600s = 10 phút
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character:BreakJoints()
            task.wait(12)
            TeleAndFix()
        end
    end
end)

-- Khi respawn → giữ UI + Tele lại
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    CreateUI()
    TeleAndFix()
end)

-- 🌟 Chạy lần đầu
CreateUI()
TeleAndFix()
