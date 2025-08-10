-- 📌 Blox Fruits Aimbot Skill Tracking (Mobile) - by GPT-5

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local AimRadius = 30000 -- khoảng cách aim tối đa

-- UI bật/tắt
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.85, 0)
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.Text = "Aimbot: OFF"
Button.TextScaled = true

Button.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        Button.Text = "Aimbot: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        Button.Text = "Aimbot: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Tìm mục tiêu gần nhất
local function GetClosestPlayer()
    local closest = nil
    local shortestDist = AimRadius
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < shortestDist and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                shortestDist = dist
                closest = player
            end
        end
    end
    return closest
end

-- Tracking liên tục
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            -- Xoay camera và nhân vật về phía mục tiêu
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, targetPos)
        end
    end
end)