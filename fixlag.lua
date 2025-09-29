-- PHUCMAX SUPER FIXLAG ULTIMATE (v2)
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- UI FPS/Ping
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PHUCMAX_FPS_PING"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

local infoFrame = Instance.new("Frame", screenGui)
infoFrame.BackgroundTransparency = 0.3
infoFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
infoFrame.Size = UDim2.new(0, 160, 0, 55)
infoFrame.Position = UDim2.new(1, -170, 0, 10)
infoFrame.AnchorPoint = Vector2.new(0,0)
Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 12)

local fpsLabel = Instance.new("TextLabel", infoFrame)
fpsLabel.Size = UDim2.new(1, -12, 0, 25)
fpsLabel.Position = UDim2.new(0, 6, 0, 2)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 18
fpsLabel.TextColor3 = Color3.fromRGB(220,255,220)
fpsLabel.Text = "FPS: --"

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1, -12, 0, 22)
pingLabel.Position = UDim2.new(0, 6, 0, 28)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 16
pingLabel.TextColor3 = Color3.fromRGB(220,220,255)
pingLabel.Text = "PING: --"

-- FPS + Ping update
local lastTime, frameCount = tick(), 0
RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(frameCount)
        frameCount = 0
        lastTime = tick()
    end
    -- Ping
    local ping = math.floor(Players:GetNetworkPing() * 1000)
    pingLabel.Text = "PING: " .. tostring(ping) .. " ms"
end)

-- XÓA CÂY, BÓNG, NƯỚC, HIỆU ỨNG, TEXTURE, giảm chi tiết, chuyển màu xám
local function fixObjects()
    -- Xóa cây
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("tree") or obj.Parent.Name:lower():find("tree")) then
            obj:Destroy()
        end
    end
    -- Xóa bóng
    Lighting.GlobalShadows = false
    -- Giảm ánh sáng mặt trời
    Lighting.Brightness = Lighting.Brightness * 0.5
    Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
    Lighting.Ambient = Color3.fromRGB(100,100,100)
    -- Xóa nước
    if Workspace:FindFirstChildOfClass("Terrain") then
        Workspace.Terrain.WaterTransparency = 1
        Workspace.Terrain.WaterReflectance = 0
    end
    -- Xóa hiệu ứng skill
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj:Destroy()
        end
    end
    -- Xóa Texture
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
    -- Giảm chi tiết: LOWER LOD, vật thể màu xám, vô hình các vật đứng (trụ, cột)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(128,128,128)
            obj.Reflectance = 0
            obj.Transparency = math.clamp(obj.Transparency, 0, 0.6)
            -- Nếu là trụ/cột/stand
            if obj.Name:lower():find("stand") or obj.Name:lower():find("pillar") or obj.Name:lower():find("statue") then
                obj.Transparency = 1
                obj.CanCollide = false
            end
        end
    end
end

-- XÓA ANIMATION QUÁI, CHỈ GIỮ NGƯỜI CHƠI, HIỆN QUÁI VÀ NGƯỜI
local function fixAnimations()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                for _, anim in ipairs(char:GetDescendants()) do
                    if anim:IsA("Animator") then
                        -- giữ nguyên
                    elseif anim:IsA("Animation") then
                        -- giữ nguyên
                    end
                end
            end
        end
    end
    -- Xóa animation quái
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("npc") or obj.Name:lower():find("enemy")) then
            for _, anim in ipairs(obj:GetDescendants()) do
                if anim:IsA("Animator") or anim:IsA("AnimationController") then
                    anim:Destroy()
                end
            end
        end
    end
end

-- AUTO NOCLIP CỰC XA, TỰ BẬT LẠI
local noclipOn = true
local function enableNoclip()
    noclipOn = true
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RunService.Stepped:Connect(function()
        if noclipOn and char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function checkNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            enableNoclip()
            break
        end
    end
end

enableNoclip()
RunService.Stepped:Connect(checkNoclip)

-- VÒNG LẶP FIXLAG CỰC ĐẠI
fixObjects()
fixAnimations()
RunService.RenderStepped:Connect(function()
    pcall(fixObjects)
    pcall(fixAnimations)
end)