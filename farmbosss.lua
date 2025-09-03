--// Phuc AutoFarm NPC2 v3 (Fix Camera + LookAt Target)

-- Chạy updateInventory 1 lần
local args = {
    [1] = "eue",
    [2] = "PhongLon"
}
pcall(function()
    game:GetService("ReplicatedStorage")
        .KnitPackages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit
        .Services.InventoryService.RE.updateInventory:FireServer(unpack(args))
end)

-- Biến
getgenv().AutoFarm = false
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera

-- Hàm tìm NPC2
local function getTarget()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "NPC2" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

-- Hiển thị máu quái
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local HealthLabel = Instance.new("TextLabel", ScreenGui)
HealthLabel.Size = UDim2.new(0,200,0,50)
HealthLabel.Position = UDim2.new(1,-210,0,20) -- góc trên bên phải
HealthLabel.BackgroundTransparency = 0.5
HealthLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
HealthLabel.TextColor3 = Color3.fromRGB(255,0,0)
HealthLabel.TextScaled = true
HealthLabel.Text = "HP: ???"
HealthLabel.Visible = false

-- Nút bật/tắt
-- Nút bật/tắt AutoFarm đẹp hơn (bo tròn + viền rainbow)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,120,0,50)
ToggleBtn.Position = UDim2.new(0.5,-60,0,20)
ToggleBtn.Text = "Farm BOSS OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30) -- nền xám đậm
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true

-- Bo cong
local UICorner = Instance.new("UICorner", ToggleBtn)
UICorner.CornerRadius = UDim.new(0,15) -- bo 15px

-- Viền rainbow
local UIStroke = Instance.new("UIStroke", ToggleBtn)
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Rainbow effect
task.spawn(function()
    local hue = 0
    while ToggleBtn.Parent do
        hue = (hue + 1) % 360
        UIStroke.Color = Color3.fromHSV(hue/360, 1, 1)
        task.wait(0.03) -- tốc độ đổi màu mượt
    end
end)

-- Xử lý bật/tắt
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    if getgenv().AutoFarm then
        ToggleBtn.Text = "Farm BOSS ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,100,20)
        HealthLabel.Visible = true
        -- Nhấn phím 1 một lần
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.One, false, game)
        vim:SendKeyEvent(false, Enum.KeyCode.One, false, game)
    else
        ToggleBtn.Text = "Farm BOSS OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(100,20,20)
        HealthLabel.Visible = false
    end
end)

-- Auto farm loop
RunService.RenderStepped:Connect(function()
    if getgenv().AutoFarm then
        local target = getTarget()
        local char = LocalPlayer.Character
        if target and char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local targetRoot = target:FindFirstChild("HumanoidRootPart")

            if targetRoot then
                -- Tính orbit dưới đất
                local angle = tick() * 120
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * 17.5
                local orbitPos = targetRoot.Position + offset
                orbitPos = Vector3.new(orbitPos.X, root.Position.Y, orbitPos.Z)

                -- Noclip
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end

                -- Di chuyển nhân vật và luôn hướng về quái
                root.CFrame = CFrame.new(orbitPos, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))

                -- Auto click (chuột trái)
                VirtualUser:ClickButton1(Vector2.new())

                -- Camera chỉ nhìn vào quái (không xoay theo nhân vật)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)

                -- Update máu quái
                HealthLabel.Text = "HP: " .. math.floor(target.Humanoid.Health) .. " / " .. math.floor(target.Humanoid.MaxHealth)
            end
        end
    end
end)