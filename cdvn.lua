-- KIỂM TRA ĐÃ LOAD UI CHƯA
if getgenv then
	if getgenv()._phucmax_ui_loaded then return end
	getgenv()._phucmax_ui_loaded = true
end

-- DỊCH VỤ
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- GUI CHÍNH
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PhucmaxRainbowUI"
gui.ResetOnSpawn = false

-- VIỀN RAINBOW
local function createRainbowFrame(parent)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.new(1, 0, 0)
	task.spawn(function()
		local hue = 0
		while parent.Parent do
			hue = (hue + 1) % 255
			stroke.Color = Color3.fromHSV(hue / 255, 1, 1)
			task.wait(0.03)
		end
	end)
end

-- FRAME CHÍNH
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 340)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
createRainbowFrame(main)

-- HIỆN MENU (có animation)
local function toggleMenu()
	main.Visible = true
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.Size = UDim2.new(0, 0, 0, 0)
	local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 280, 0, 340)
	})
	tween:Play()
end

-- THANH TAB
local tabBar = Instance.new("ScrollingFrame", main)
tabBar.Size = UDim2.new(1, -20, 0, 36)
tabBar.Position = UDim2.new(0, 10, 0, 10)
tabBar.ScrollBarThickness = 4
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- TỰ ĐỘNG CẬP NHẬT TAB SCROLL
local function updateTabCanvas()
	task.wait()
	local totalWidth = 0
	for _, child in pairs(tabBar:GetChildren()) do
		if child:IsA("TextButton") then
			totalWidth += child.Size.X.Offset + tabLayout.Padding.Offset
		end
	end
	tabBar.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
end

-- KHUNG NỘI DUNG TAB
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, -20, 1, -60)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundTransparency = 1

-- TẠO TAB
local tabs, currentTab = {}, nil
local function switchTab(name)
	for i, v in pairs(tabs) do
		v.Visible = (i == name)
	end
end

local function createTab(name)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(0, 80, 1, 0)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local page = Instance.new("ScrollingFrame", tabContainer)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 4
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.BackgroundTransparency = 1
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	tabs[name] = page
	page.Visible = false

	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	if not currentTab then
		currentTab = name
		page.Visible = true
	end

	updateTabCanvas()
	return page
end

-- NÚT TOGGLE
local function createToggle(text, parent, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(0.9, 0, 0, 32)
	holder.BackgroundTransparency = 1
	local box = Instance.new("TextButton", holder)
	box.Size = UDim2.new(0, 28, 0, 28)
	box.Position = UDim2.new(0, 0, 0.5, -14)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.Text = ""
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	createRainbowFrame(box)
	local lbl = Instance.new("TextLabel", holder)
	lbl.Position = UDim2.new(0, 35, 0, 0)
	lbl.Size = UDim2.new(1, -35, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local state = false
	box.MouseButton1Click:Connect(function()
		state = not state
		box.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
		callback(state)
	end)
end

-- NÚT BÌNH THƯỜNG
local function createButton(text, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.9, 0, 0, 32)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- NÚT BẬT/TẮT MENU
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.new(0, 48, 0, 48)
logo.Position = UDim2.new(0, 10, 0.5, -24)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.Image = "rbxassetid://113632547593752"
logo.Draggable = true
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
createRainbowFrame(logo)

logo.MouseButton1Click:Connect(function()
	if main.Visible then
		local tween = TweenService:Create(main, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tween:Play()
		tween.Completed:Wait()
		main.Visible = false
	else
		toggleMenu()
	end
end)

-- TẠO CÁC TAB
local tabMain = createTab("INFO")
local tabMain = createTab("PVP")
local tabESP = createTab("ESP")
--------------------------------------------------------------------
createButton("📋 COPY LINK DISCORD", tabs["INFO"], function()
    local setClipboard = setclipboard or toclipboard or function() end
    setClipboard("https://discord.gg/RzN6vzeP") 
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "PHUCMAX",
            Text = "✅ copy link Discord!",
            Duration = 3
        })
    end)
end)

createButton("📋 COPY LINK facebook", tabs["INFO"], function()
    local setClipboard = setclipboard or toclipboard or function() end
    setClipboard("https://www.facebook.com/rHnewp7") 
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "PHUCMAX",
            Text = "✅ copy link Facebook!",
            Duration = 3
        })
    end)
end)

createButton("📋 COPY LINK tiktok", tabs["INFO"], function()
    local setClipboard = setclipboard or toclipboard or function() end
    setClipboard("phucmaxxxxxxxxx") 
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "PHUCMAX",
            Text = "✅ copy link TikTok!",
            Duration = 3
        })
    end)
end)

    

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local espList = {} -- lưu thông tin ESP mỗi player
local rainbowCycle = 0

-- Hàm tạo ESP cho 1 player
local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end
	if espList[player] then return end

	local head = player.Character:FindFirstChild("Head")

	-- BillboardGui chính
	local gui = Instance.new("BillboardGui")
	gui.Name = "PhucmaxESP"
	gui.Size = UDim2.new(0, 120, 0, 40)
	gui.Adornee = head
	gui.AlwaysOnTop = true
	gui.Parent = head

	-- Tên player
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextScaled = true
	nameLabel.TextStrokeTransparency = 0
	nameLabel.Text = player.Name
	nameLabel.Parent = gui

	-- Thanh máu
	local healthBar = Instance.new("Frame")
	healthBar.Size = UDim2.new(1, -4, 0, 5)
	healthBar.Position = UDim2.new(0, 2, 0.5, 5)
	healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = gui

	espList[player] = {gui = gui, nameLabel = nameLabel, healthBar = healthBar, character = player.Character}
end

-- Xóa tất cả ESP
local function clearAllESP()
	for player, data in pairs(espList) do
		if data.gui and data.gui.Parent then
			data.gui:Destroy()
		end
	end
	espList = {}
end

-- Toggle ESP
createToggle("ESP Player", tabESP, function(state)
	espEnabled = state
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			createESP(p)
		end
	else
		clearAllESP()
	end
end)

-- Khi player join game
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if espEnabled then task.wait(1) createESP(p) end
	end)
end)

-- Update rainbow và thanh máu
RunService.RenderStepped:Connect(function()
	if not espEnabled then return end
	rainbowCycle = (rainbowCycle + 0.005) % 1

	for player, data in pairs(espList) do
		local char = data.character
		if char and char:FindFirstChild("Humanoid") then
			local hum = char:FindFirstChild("Humanoid")
			-- Cập nhật màu cầu vồng
			data.nameLabel.TextColor3 = Color3.fromHSV(rainbowCycle, 1, 1)
			-- Cập nhật thanh máu
			local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
			data.healthBar.Size = UDim2.new(healthPercent, -4, 0, 5)
			-- Màu thanh máu từ đỏ -> xanh
			data.healthBar.BackgroundColor3 = Color3.fromHSV(healthPercent/3, 1, 1)
		end
	end
end)


createButton("FIXLAG", tabPVP, function()
    -- Xoá toàn bộ hiệu ứng, particles, trails, smoke, fire, sparkles...
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
            v:Destroy()
        end
    end

    -- Xoá toàn bộ Decals & Textures
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Xoá tất cả Lighting Effects (bóng đổ, blur, color correction...)
    local lighting = game:GetService("Lighting")
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
            v:Destroy()
        end
    end

    -- Giảm tối đa chất lượng vật thể
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        end
    end

    -- Xoá tất cả các tường (Wall = Part lớn đứng thẳng)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Size.Y > v.Size.X and v.Size.Y > v.Size.Z and v.Anchored and v.Position.Y > 10 then
            v:Destroy()
        end
    end

    -- Tắt các chi tiết phụ của bản đồ (Meshes & các part trang trí nhỏ)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v:Destroy()
        end
    end

    -- Tắt Terrain nếu có
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace.Terrain:Clear()
    end

    -- Tắt Water nếu có
    workspace.FallenPartsDestroyHeight = -50000
    if lighting:FindFirstChild("Atmosphere") then
        lighting.Atmosphere:Destroy()
    end

    -- Bật FPS cao nhất (nếu dùng Trigon hoặc Synapse có thể dùng setfpscap)
    pcall(function()
        setfpscap(999999)
    end)

    -- Tắt Shadows và Global Shadows
    lighting.GlobalShadows = false
    lighting.FogEnd = 1000000000

    -- Xoá Sky nếu có
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("Sky") then
            v:Destroy()
        end
    end

    print("✅ Đã fix lag tối đa.")
end)

-- Biến lưu connection xoay
local rotateConnection

createToggle("xoay", tabPVP, function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")

    -- Tắt tự động xoay theo hướng chạy
    Humanoid.AutoRotate = false

    if state then
        -- Bật xoay
        if not rotateConnection then
            rotateConnection = RunService.RenderStepped:Connect(function()
                RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(60), 0) 
                -- 20° mỗi frame, vừa nhìn
            end)
        end
    else
        -- Tắt xoay
        if rotateConnection then
            rotateConnection:Disconnect()
            rotateConnection = nil
        end
    end
end)

local canUse = true -- Biến kiểm soát thời gian chờ

createButton("Lấy băng gạc", tabPVP, function()
    if not canUse then
        -- Nếu đang trong thời gian chờ 6s thì không làm gì
        return
    end

    canUse = false -- khóa nút

    -- Chạy script lấy băng gạc
    local InventoryService = game:GetService("ReplicatedStorage")
        .KnitPackages._Index["sleitnick_knit@1.7.0"]
        .knit.Services.InventoryService.RE

    -- Lấy băng gạc
    InventoryService.updateInventory:FireServer("eue", "băng gạc")
    -- Refresh để sync với server
    InventoryService.updateInventory:FireServer("refresh")

    -- Bắt đầu đếm ngược 6 giây mới được bấm lại
    task.delay(6, function()
        canUse = true
    end)
end)

local canBuy = true -- Biến kiểm soát cooldown 6s

createButton("Mua 5 băng gạc", tabPVP, function()
    if not canBuy then
        return -- Nếu đang cooldown thì không làm gì
    end

    canBuy = false -- khóa nút

    -- Chuẩn bị arguments
    local args = {
        "băng gạc",
        5
    }

    -- Lấy service mua item
    local ShopService = game:GetService("ReplicatedStorage")
        :WaitForChild("KnitPackages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.7.0")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("ShopService")
        :WaitForChild("RE")

    -- Gửi request mua item
    ShopService.buyItem:FireServer(unpack(args))

    -- Bắt đầu đếm ngược 6 giây mới được bấm lại
    task.delay(3, function()
        canBuy = true
    end)
end)