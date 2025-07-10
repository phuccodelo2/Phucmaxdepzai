-- ✅ Phần UI như bạn gửi, thêm đủ chức năng: Godmode, Anti-Hit, Infinite Jump, ESP Player, Fall, Sky, Ascend Floor, ESP Base

if getgenv then
	if getgenv()._phucmax_ui_loaded then return end
	getgenv()._phucmax_ui_loaded = true
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucmaxUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 300)
main.Position = UDim2.new(0.5, -130, 0.4, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "phucmax"
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)

-- Rainbow Title
local rainbowColors = {
	Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0),
	Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(139, 0, 255)
}
task.spawn(function()
	while true do
		for _, color in ipairs(rainbowColors) do
			title.TextColor3 = color
			task.wait(0.1)
		end
	end
end)

-- Scroll area
local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, 0, 1, -45)
contentHolder.Position = UDim2.new(0, 0, 0, 45)
contentHolder.BackgroundTransparency = 1
contentHolder.ClipsDescendants = true

local scroller = Instance.new("ScrollingFrame", contentHolder)
scroller.Size = UDim2.new(1, 0, 1, 0)
scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
scroller.BackgroundTransparency = 1
scroller.ScrollBarThickness = 6
scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scroller)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Nút bật/tắt menu
local logo = Instance.new("ImageButton")
logo.Name = "ToggleButton"
logo.Parent = gui
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0.5, -25)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.Image = "rbxassetid://113632547593752"
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)
logo.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Notification
local function showNotification(msg)
	local notify = Instance.new("TextLabel")
	notify.Parent = gui
	notify.Size = UDim2.new(0, 300, 0, 40)
	notify.Position = UDim2.new(1, -310, 1, -60)
	notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notify.TextColor3 = Color3.fromRGB(255, 255, 255)
	notify.Font = Enum.Font.GothamBold
	notify.TextSize = 18
	notify.Text = msg
	notify.BackgroundTransparency = 0.2
	Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	wait(2.5)
	game:GetService("TweenService"):Create(notify, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	wait(0.6)
	notify:Destroy()
end

showNotification("✅ PHUCMAX UI LOADED")

-- Tạo nút toggle
local function createButton(text, callback)
	local btn = Instance.new("TextButton", scroller)
	btn.Size = UDim2.new(0.85, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
		callback(state)
	end)
end

-- ✅ Chức năng

-- Ascend
createButton("Ascend to Floor 1", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/main/tungtung.txt"))()
end)

createButton("Ascend to Floor 2", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/main/phucmax_ui.lua"))()
end)

-- Fall Down
createButton("Fall Down", function(state)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 100, 0) end
end)

-- Teleport Sky
createButton("Teleport Sky", function(state)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0) end
end)

-- Godmode
local godConn
createButton("Godmode", function(state)
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	if state then
		if godConn then godConn:Disconnect() end
		godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health < 100 then hum.Health = 100 end
		end)
	else
		if godConn then godConn:Disconnect() godConn = nil end
	end
end)

-- Anti-Hit
local dodgeFly = false
createButton("Anti-Hit", function(state)
	dodgeFly = state
end)

task.spawn(function()
	while task.wait(0.02) do
		if dodgeFly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myHRP = LocalPlayer.Character.HumanoidRootPart
			for _, other in pairs(Players:GetPlayers()) do
				if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
					local theirHRP = other.Character.HumanoidRootPart
					if (myHRP.Position - theirHRP.Position).Magnitude < 7 then
						myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 10, 0)
						break
					end
				end
			end
		end
	end
end)

-- Infinite Jump
local jumpConn
createButton("Infinite Jump", function(state)
	if state then
		jumpConn = UserInputService.JumpRequest:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char:FindFirstChild("Humanoid"):ChangeState("Jumping")
			end
		end)
	else
		if jumpConn then jumpConn:Disconnect() jumpConn = nil end
	end
end)

-- ESP Player
createButton("ESP Player", function(state)
	if state then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				if not p.Character:FindFirstChild("ESP") then
					local esp = Instance.new("BillboardGui", p.Character.Head)
					esp.Name = "ESP"
					esp.Size = UDim2.new(0, 100, 0, 40)
					esp.AlwaysOnTop = true
					local label = Instance.new("TextLabel", esp)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.Text = "👤 " .. p.Name
					label.TextColor3 = Color3.fromRGB(255, 0, 0)
					label.BackgroundTransparency = 1
					label.TextStrokeTransparency = 0
				end
			end
		end
	else
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("Head") then
				local e = p.Character.Head:FindFirstChild("ESP")
				if e then e:Destroy() end
			end
		end
	end
end)
-- 📍 ESP Base gần nhất
createButton("ESP Base Gần Nhất", function(state)
	local basePositions = {
		Vector3.new(-469.1, -6.6, -99.3), Vector3.new(-348.4, -6.6, 7.1),
		Vector3.new(-469.1, -6.5, 8.2), Vector3.new(-348.0, -6.6, -100.0),
		Vector3.new(-469.2, -6.6, 114.7), Vector3.new(-348.5, -6.6, 111.3),
		Vector3.new(-470.4, -6.6, 221.0), Vector3.new(-348.4, -6.6, 219.3),
	}

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local closestPos = nil
	local closestDist = math.huge

	for _, pos in pairs(basePositions) do
		local dist = (hrp.Position - pos).Magnitude
		if dist < closestDist then
			closestDist = dist
			closestPos = pos
		end
	end

	if closestPos then
		if not workspace:FindFirstChild("ESPBase") then
			local part = Instance.new("Part", workspace)
			part.Name = "ESPBase"
			part.Anchored = true
			part.CanCollide = false
			part.Size = Vector3.new(2, 2, 2)
			part.Position = closestPos
			part.Transparency = 0.2
			part.BrickColor = BrickColor.new("Bright violet")

			local bill = Instance.new("BillboardGui", part)
			bill.Size = UDim2.new(0, 100, 0, 40)
			bill.AlwaysOnTop = true

			local text = Instance.new("TextLabel", bill)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.Text = " BASE"
			text.TextColor3 = Color3.fromRGB(255, 85, 255)
			text.BackgroundTransparency = 1
			text.TextStrokeTransparency = 0
		else
			workspace.ESPBase.Position = closestPos
		end
		print("✅ Đã lưu base tại:", tostring(closestPos))
	end
end)
local lockedMain = nil
local isLockingBase = false

--  T�m "Main" cha ESPBase
local function findMainContainingESP()
    local esp = workspace:FindFirstChild("ESPBase")
    if not esp then return nil end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("^main") then
            local size = obj.Size
            local pos = obj.Position
            local range = Vector3.new(size.X/2, size.Y/2, size.Z/2)

            -- Nu ESPBase nm trong v�ng Part
            if (esp.Position.X >= pos.X - range.X and esp.Position.X <= pos.X + range.X) and
               (esp.Position.Y >= pos.Y - range.Y and esp.Position.Y <= pos.Y + range.Y) and
               (esp.Position.Z >= pos.Z - range.Z and esp.Position.Z <= pos.Z + range.Z) then
                return obj
            end
        end
    end
    return nil
end

--  LOCK BASE
createButton(scroller, " Lock Base", function(state)
    if state then
        local target = findMainContainingESP()
        if target then
            lockedMain = target
            isLockingBase = true

            -- reset player
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char:FindFirstChild("Humanoid"):BreakJoints()
            end

            showNotification(" Lock v�o Main cha ESP Base...")
        else
            showNotification(" Kh�ng t�m thy 'Main' n�o cha ESPBase!")
        end
    else
        isLockingBase = false
        lockedMain = nil
        showNotification(" Lock Base � tt")
    end
end)

--  Tele li�n tc v�o Main � lock khi cha hi sinh
task.spawn(function()
    while task.wait(0.2) do
        if isLockingBase and lockedMain then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                -- nh�n vt cha hi sinh
                local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local newHRP = c:WaitForChild("HumanoidRootPart", 5)
                if newHRP then
                    newHRP.CFrame = lockedMain.CFrame + Vector3.new(0, 5, 0)
                end
            else
                isLockingBase = false
                showNotification(" � teleport v�o Main cha ESPBase!")
            end
        end
    end
end)