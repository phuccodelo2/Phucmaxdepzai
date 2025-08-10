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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Hàm tìm player máu thấp + gần
local function GetTarget()
    local best, lowestHp, shortestDist = nil, math.huge, math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if hum.Health < lowestHp or (hum.Health == lowestHp and dist < shortestDist) then
                    lowestHp, shortestDist, best = hum.Health, dist, plr
                end
            end
        end
    end
    return best
end

-- Hook skill gửi server
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and typeof(self) == "Instance" then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos = target.Character.HumanoidRootPart.Position
            for i,v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = pos
                elseif typeof(v) == "CFrame" then
                    args[i] = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, pos)
                end
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- Tracking projectile
RunService.Heartbeat:Connect(function()
    local target = GetTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Velocity.Magnitude > 10 and (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 300 then
                obj.CFrame = CFrame.lookAt(obj.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end
end)