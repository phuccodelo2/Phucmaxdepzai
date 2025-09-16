-- LocalScript: Rainbow UI (rebuild từ đầu) - nhẹ, draggable, nút chuẩn, toàn UI rainbow gradient
-- Ghi chú: dán vào StarterPlayerScripts hoặc chạy client-side

-- Tránh load 2 lần
if getgenv and getgenv()._rainbow_ui_loaded then return end
if getgenv then getgenv()._rainbow_ui_loaded = true end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===== helper: tạo rainbow ColorSequence chung =====
local RAINBOW_SEQUENCE = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,165,0)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,255)),
}

local gradients = {} -- table lưu UIGradient để animate chung

local function attachRainbowGradient(parent)
	local g = Instance.new("UIGradient")
	g.Color = RAINBOW_SEQUENCE
	g.Rotation = 0
	g.Parent = parent
	table.insert(gradients, g)
	return g
end

-- ===== GUI base =====
local screen = Instance.new("ScreenGui")
screen.Name = "Phuc_RainbowUI"
screen.ResetOnSpawn = false
screen.Parent = PlayerGui

-- Main frame: nhỏ gọn, tỉ lệ hợp lý
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 260) -- kích thước nhỏ gọn
main.Position = UDim2.new(0.35, 0, 0.35, 0)
main.AnchorPoint = Vector2.new(0,0)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.BorderSizePixel = 0
main.Parent = screen

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

-- shadow (subtle)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = main
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.Position = UDim2.new(0.5,0,0.5,0)
shadow.Size = UDim2.new(1,30,1,30)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.BackgroundTransparency = 1
shadow.ZIndex = main.ZIndex - 1
shadow.ImageTransparency = 0.75

-- rainbow border stroke cho main
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
attachRainbowGradient(mainStroke)

-- Titlebar (dùng để kéo)
local titleBar = Instance.new("Frame", main)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌈 Rainbow Hub — Lean & Clean"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
attachRainbowGradient(titleLabel)

-- container nội dung
local leftCol = Instance.new("Frame", main)
leftCol.Name = "LeftCol"
leftCol.Position = UDim2.new(0, 8, 0, 46)
leftCol.Size = UDim2.new(0, 120, 0, 200)
leftCol.BackgroundTransparency = 1

local rightCol = Instance.new("Frame", main)
rightCol.Name = "RightCol"
rightCol.Position = UDim2.new(0, 136, 0, 46)
rightCol.Size = UDim2.new(0, 276, 0, 200)
rightCol.BackgroundColor3 = Color3.fromRGB(28,28,28)
rightCol.BorderSizePixel = 0
local rightCorner = Instance.new("UICorner", rightCol)
rightCorner.CornerRadius = UDim.new(0,8)
local rightStroke = Instance.new("UIStroke", rightCol)
rightStroke.Thickness = 1
attachRainbowGradient(rightStroke)

-- tab list (left)
local tabList = Instance.new("UIListLayout", leftCol)
tabList.Padding = UDim.new(0,6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder

-- content scrolling area
local contentScroll = Instance.new("ScrollingFrame", rightCol)
contentScroll.Size = UDim2.new(1, -12, 1, -12)
contentScroll.Position = UDim2.new(0, 6, 0, 6)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ScrollBarThickness = 6
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.BackgroundTransparency = 1

local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0,8)

-- ===== helpers tạo controls =====
local tabs = {}
local currentTab = nil

local function makeTab(name)
	local btn = Instance.new("TextButton", leftCol)
	btn.Name = name .. "_TabBtn"
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(36,36,36)
	btn.BorderSizePixel = 0
	btn.Text = "  "..name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(240,240,240)
	local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", btn); s.Thickness = 1; attachRainbowGradient(s)
	attachRainbowGradient(btn)
	local page = Instance.new("Frame", contentScroll)
	page.Size = UDim2.new(1, -12, 0, 10) -- will resize by AutomaticCanvasSize
	page.BackgroundTransparency = 1
	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,8)

	tabs[name] = {btn = btn, page = page}
	btn.MouseButton1Click:Connect(function()
		-- hide others
		for k,v in pairs(tabs) do
			v.page.Visible = false
		end
		page.Visible = true
		currentTab = name
	end)
	-- default select first
	if not currentTab then
		currentTab = name
		page.Visible = true
	else
		page.Visible = false
	end
	return page
end

-- Button factory (compact)
local function makeButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -12, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(46,46,46)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(245,245,245)
	local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", btn); s.Thickness = 1; attachRainbowGradient(s)
	attachRainbowGradient(btn)
	btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
	return btn
end

-- Toggle (compact switch)
local function makeToggle(parent, text, default, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -12, 0, 34)
	holder.BackgroundColor3 = Color3.fromRGB(42,42,42)
	holder.BorderSizePixel = 0
	local c = Instance.new("UICorner", holder); c.CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", holder); s.Thickness = 1; attachRainbowGradient(s)

	local lbl = Instance.new("TextLabel", holder)
	lbl.Size = UDim2.new(0.7, 0, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = text
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(245,245,245)
	attachRainbowGradient(lbl)

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0, 60, 0, 24)
	btn.Position = UDim2.new(1, -70, 0.5, -12)
	btn.AnchorPoint = Vector2.new(0,0)
	btn.BackgroundColor3 = default and Color3.fromRGB(0,180,80) or Color3.fromRGB(160,40,40)
	btn.Text = default and "ON" or "OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.TextColor3 = Color3.fromRGB(245,245,245)
	local bc = Instance.new("UICorner", btn); bc.CornerRadius = UDim.new(0,6)
	local bs = Instance.new("UIStroke", btn); bs.Thickness = 1; attachRainbowGradient(bs)

	local state = default
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		btn.BackgroundColor3 = state and Color3.fromRGB(0,180,80) or Color3.fromRGB(160,40,40)
		pcall(callback, state)
	end)
	return holder, function() return state end
end

-- Slider (compact)
local function makeSlider(parent, text, min, max, default, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -12, 0, 48)
	holder.BackgroundColor3 = Color3.fromRGB(42,42,42)
	local c = Instance.new("UICorner", holder); c.CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", holder); s.Thickness = 1; attachRainbowGradient(s)

	local lbl = Instance.new("TextLabel", holder)
	lbl.Position = UDim2.new(0,8,0,4); lbl.Size = UDim2.new(1,-16,0,18)
	lbl.BackgroundTransparency = 1; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
	lbl.Text = text.." : "..tostring(default); lbl.TextColor3 = Color3.fromRGB(245,245,245)
	attachRainbowGradient(lbl)

	local bar = Instance.new("Frame", holder)
	bar.Position = UDim2.new(0,8,0,28); bar.Size = UDim2.new(1,-16,0,8)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	attachRainbowGradient(fill)

	local dragging = false
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	bar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
			rel = math.clamp(rel, 0, 1)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			local val = math.floor(min + (max-min)*rel)
			lbl.Text = text.." : "..tostring(val)
			pcall(callback, val)
		end
	end)

	return holder
end

-- Textbox (compact)
local function makeTextbox(parent, labelText, placeholder, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -12, 0, 36)
	holder.BackgroundColor3 = Color3.fromRGB(42,42,42)
	local c = Instance.new("UICorner", holder); c.CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", holder); s.Thickness = 1; attachRainbowGradient(s)

	local lbl = Instance.new("TextLabel", holder)
	lbl.Size = UDim2.new(0.45, 0, 1, 0)
	lbl.Position = UDim2.new(0,8,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = labelText
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.fromRGB(245,245,245)
	attachRainbowGradient(lbl)

	local box = Instance.new("TextBox", holder)
	box.Size = UDim2.new(0.5, -12, 0, 24)
	box.Position = UDim2.new(1, -box.AbsoluteSize.X - 10, 0.5, -12)
	box.AnchorPoint = Vector2.new(1,0.5)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.BackgroundColor3 = Color3.fromRGB(60,60,60)
	box.TextColor3 = Color3.fromRGB(245,245,245)
	local bc = Instance.new("UICorner", box); bc.CornerRadius = UDim.new(0,6)

	box.FocusLost:Connect(function(enter)
		if enter then pcall(callback, box.Text) end
	end)
	return holder
end

-- ===== demo content =====
local t1 = makeTab("Main")
local t2 = makeTab("Utility")
local t3 = makeTab("Settings")

-- Fill Main tab
makeButton(t1, "Hello", function() print("Hello pressed") end)
makeButton(t1, "Small Action", function() print("Action") end)
makeToggle(t1, "Enable Rainbow", true, function(s) print("Rainbow:", s) end)
makeSlider(t1, "Speed", 1, 200, 16, function(v) print("Speed:", v) end)

-- Utility tab
makeButton(t2, "Teleport to Spawn", function() pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame end) end)
makeTextbox(t2, "Note", "Type note...", function(txt) print("Note:", txt) end)

-- Settings tab
makeToggle(t3, "Auto Save", false, function(s) print("AutoSave:", s) end)
makeSlider(t3, "Volume", 0, 100, 50, function(v) print("Volume:", v) end)

-- ===== Floating toggle button để ẩn/hiện UI =====
local floatBtn = Instance.new("ImageButton", screen)
floatBtn.Name = "FloatToggle"
floatBtn.Size = UDim2.new(0,44,0,44)
floatBtn.Position = UDim2.new(0, 12, 0.5, -22)
floatBtn.AnchorPoint = Vector2.new(0,0)
floatBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
floatBtn.Image = "" -- để trống hoặc cho icon id
local fcorner = Instance.new("UICorner", floatBtn); fcorner.CornerRadius = UDim.new(1,0)
local fstroke = Instance.new("UIStroke", floatBtn); fstroke.Thickness = 2; attachRainbowGradient(fstroke)
attachRainbowGradient(floatBtn)

local isOpen = true
floatBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	main.Visible = isOpen
end)

-- ===== draggable bằng TitleBar (chuẩn, mượt) =====
do
	local dragging = false
	local dragStart
	local startPos
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			-- store movement
			UserInputService.InputChanged:Connect(function()
				-- noop (prevent leak)
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local x = startPos.X.Offset + delta.X
			local y = startPos.Y.Offset + delta.Y
			main.Position = UDim2.new(startPos.X.Scale, x, startPos.Y.Scale, y)
		end
	end)
end

-- ===== animate all gradients (shared loop) =====
task.spawn(function()
	local rot = 0
	while task.wait(0.03) do
		rot = (rot + 1.5) % 360
		for _, g in ipairs(gradients) do
			if g and g.Parent then
				g.Rotation = rot
			end
		end
	end
end)

-- Done
print("[Phuc_RainbowUI] Built fresh UI (compact, draggable, rainbow).")