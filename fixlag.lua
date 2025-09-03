--// PHUC FIX LAG MAX
-- by ChatGPT (FPS + Ping + Fix Lag Max)
-- Copy chạy được luôn

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PhucFixLagMax"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Position = UDim2.new(0.7, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "PHUC FIX LAG MAX"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local FPSLabel = Instance.new("TextLabel", Frame)
FPSLabel.Size = UDim2.new(1, 0, 0, 25)
FPSLabel.Position = UDim2.new(0,0,0.35,0)
FPSLabel.Text = "FPS: ..."
FPSLabel.TextColor3 = Color3.fromRGB(0,255,0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextScaled = true

local PingLabel = Instance.new("TextLabel", Frame)
PingLabel.Size = UDim2.new(1, 0, 0, 25)
PingLabel.Position = UDim2.new(0,0,0.65,0)
PingLabel.Text = "Ping: ..."
PingLabel.TextColor3 = Color3.fromRGB(0,255,255)
PingLabel.BackgroundTransparency = 1
PingLabel.TextScaled = true

-- FPS + Ping update
local lastUpdate = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount += 1
    if tick() - lastUpdate >= 1 then
        FPSLabel.Text = "FPS: "..frameCount
        frameCount = 0
        lastUpdate = tick()
    end
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    PingLabel.Text = "Ping: "..ping
end)

-- Fix lag max
local function FixLagMax()
    -- Đổi tất cả vật thể về màu xám, giảm detail
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if obj.Anchored and (obj.Size.X > 10 or obj.Size.Z > 10) then
                -- giữ mặt đất (có kích thước lớn và nằm ngang)
                obj.Color = Color3.fromRGB(150, 150, 150)
                obj.Material = Enum.Material.SmoothPlastic
            else
                -- các vật thể đứng hoặc nghiên -> tàng hình
                obj.Transparency = 1
                obj.CanCollide = false
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj.Enabled = false
        end
    end

    -- Lighting giảm hiệu ứng
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(128,128,128)
end

-- Auto kích hoạt fix lag
FixLagMax()