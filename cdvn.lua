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

    

-- ESP PLAYER
local espEnabled = false
local espConnections = {}
local rainbowCycle = 0

local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end
	if player.Character:FindFirstChild("PhucmaxESP") then return end

	local gui = Instance.new("BillboardGui", player.Character)
	gui.Name = "PhucmaxESP"
	gui.Size = UDim2.new(0, 100, 0, 30)
	gui.Adornee = player.Character:FindFirstChild("Head")
	gui.AlwaysOnTop = true

	local name = Instance.new("TextLabel", gui)
	name.Size = UDim2.new(1, 0, 1, 0)
	name.BackgroundTransparency = 1
	name.Font = Enum.Font.GothamBold
	name.TextScaled = true
	name.TextStrokeTransparency = 0
	name.Text = player.Name

	local hl = Instance.new("Highlight", player.Character)
	hl.Name = "PhucmaxHL"
	hl.FillTransparency = 1
	hl.OutlineTransparency = 0
	hl.OutlineColor = Color3.fromHSV(rainbowCycle, 1, 1)

	local conn = RunService.RenderStepped:Connect(function()
		rainbowCycle = (rainbowCycle + 0.005) % 1
		if name and name.Parent then
			name.TextColor3 = Color3.fromHSV(rainbowCycle, 1, 1)
		end
		if hl and hl.Parent then
			hl.OutlineColor = Color3.fromHSV(rainbowCycle, 1, 1)
		end
	end)

	table.insert(espConnections, conn)
end

local function clearAllESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("PhucmaxESP") then
			p.Character:FindFirstChild("PhucmaxESP"):Destroy()
		end
		if p.Character and p.Character:FindFirstChild("PhucmaxHL") then
			p.Character:FindFirstChild("PhucmaxHL"):Destroy()
		end
	end
	for _, c in pairs(espConnections) do
		if c then pcall(function() c:Disconnect() end) end
	end
	espConnections = {}
end

createToggle("ESP Player", tabESP, function(state)
	espEnabled = state
	if state then
		for _, p in pairs(Players:GetPlayers()) do
			createESP(p)
		end
	else
		clearAllESP()
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if espEnabled then task.wait(2) createESP(p) end
	end)
end)


--------------------------------------------------------------------
-- SHOP BUY
local items = {
	"Invisibility Cloak",
	"Medusa's Head",
	"Quantum Cloner",
	"All Seeing Sentry",
	"Body Swap Potion",
	"Rainbowrath Sword",
	"Trap",
	"Web Slinger"
}

for _, name in ipairs(items) do
	createButton("Buy: " .. name, tabShop, function()
		local remote = game.ReplicatedStorage:WaitForChild("Packages")
			:WaitForChild("Net")
			:WaitForChild("RF/CoinsShopService/RequestBuy")
		pcall(function() remote:InvokeServer(name) end)
	end)
end

-- 📌 Tạo ESP khối + dòng chữ dưới
local function createESPText(pos, text)
	local part = Instance.new("Part", workspace)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.8
	part.Size = Vector3.new(1.5, 1.5, 1.5)
	part.Position = pos
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 255, 255)
	part.Name = "ESP_"..text

	local gui = Instance.new("BillboardGui", part)
	gui.Size = UDim2.new(0, 100, 0, 30)
	gui.AlwaysOnTop = true
	gui.Adornee = part
	gui.StudsOffset = Vector3.new(0, -2, 0) -- Text nằm dưới Part

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextStrokeTransparency = 0.3
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.Text = text

	local h = 0
	game:GetService("RunService").RenderStepped:Connect(function()
		if label and label.Parent and label:IsDescendantOf(game) then
			h = (h + 0.01) % 1
			label.TextColor3 = Color3.fromHSV(h, 1, 1)
			part.Color = label.TextColor3
		end
	end)
end

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Tắt tự động xoay theo hướng chạy
Humanoid.AutoRotate = false

-- Xoay liên tục (như cánh quạt)
RunService.RenderStepped:Connect(function()
RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
-- 30 độ mỗi frame (cực nhanh), chỉnh lại số cho vừa ý (10-30-50)
end) code xoay nè



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Tắt tự động xoay theo hướng chạy
Humanoid.AutoRotate = false

-- Xoay liên tục (như cánh quạt)
RunService.RenderStepped:Connect(function()
    RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(60), 0) 
    -- 30 độ mỗi frame (cực nhanh), chỉnh lại số cho vừa ý (10-30-50)
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