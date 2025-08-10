-- Blox Fruits Mobile Aimbot Skill - 100% Working Version
-- By GPT-5

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local AimRadius = 250 -- Phạm vi aim tối đa (studs)

-- UI nút bật/tắt
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

-- Hàm tìm player gần nhất
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

-- Aim khi giữ nút skill
RS.RenderStepped:Connect(function()
    if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UIS.TouchEnabled then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                local targetHRP = target.Character.HumanoidRootPart
                myHRP.CFrame = CFrame.lookAt(myHRP.Position, targetHRP.Position)
            end
        end
    end
end)