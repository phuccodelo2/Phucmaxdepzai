-- PHẦN 1/2: KHUNG CHÍNH, TOGGLE, TAB CƠ BẢN

-- KIỂM TRA LOAD UI
if getgenv()._phucmax_ui_loaded then return end
getgenv()._phucmax_ui_loaded = true

-- DỊCH VỤ
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- HÀM RAINBOW GRADIENT CHO COLOR3
local function rainbowColor(t)
	local hue = tick()*t % 1
	return Color3.fromHSV(hue,1,1)
end

-- GUI CHÍNH
local gui = Instance.new("ScreenGui")
gui.Name = "PhucMaxUI_Rainbow"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5,0,0.5,0)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.ClipsDescendants = true
main.Visible = false
main.Active = true
main.Draggable = true
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,12)
main.Parent = gui

-- VIỀN RAINBOW
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
	while true do
		mainStroke.Color = rainbowColor(0.2)
		task.wait(0.03)
	end
end)

-- ANIMATION HIỆN / ẨN UI
local function toggleUI()
	if main.Visible then
		local tween = TweenService:Create(main, TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Size=UDim2.new(0,0,0,0)})
		tween:Play()
		tween.Completed:Wait()
		main.Visible=false
	else
		main.Visible=true
		main.Size=UDim2.new(0,0,0,0)
		local tween = TweenService:Create(main, TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Size=UDim2.new(0,320,0,400)})
		tween:Play()
	end
end

-- NÚT BẬT/TẮT UI
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0,48,0,48)
toggleBtn.Position = UDim2.new(0,10,0.5,-24)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.Image = "rbxassetid://131027676437850"
toggleBtn.Draggable = true
local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(1,0)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2
task.spawn(function()
	while true do
		toggleStroke.Color = rainbowColor(0.15)
		task.wait(0.03)
	end
end)

toggleBtn.MouseButton1Click:Connect(toggleUI)

-- THANH TAB
local tabBar = Instance.new("ScrollingFrame", main)
tabBar.Size=UDim2.new(1,-20,0,36)
tabBar.Position=UDim2.new(0,10,0,10)
tabBar.ScrollBarThickness=4
tabBar.ScrollingDirection=Enum.ScrollingDirection.X
tabBar.BackgroundTransparency=1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0,5)

-- TAB CONTAINER
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1,-20,1,-60)
tabContainer.Position = UDim2.new(0,10,0,50)
tabContainer.BackgroundTransparency = 1

-- TẠO TAB VỚI NÚT + PAGE
local tabs, currentTab = {}, nil
local function createTab(name)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size=UDim2.new(0,100,1,0)
	btn.Text=name
	btn.Font=Enum.Font.GothamBold
	btn.TextSize=14
	btn.TextColor3=rainbowColor(0.2)
	btn.BackgroundColor3=Color3.fromRGB(40,40,40)
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0,6)

	local page = Instance.new("ScrollingFrame", tabContainer)
	page.Size=UDim2.new(1,0,1,0)
	page.CanvasSize=UDim2.new(0,0,0,0)
	page.ScrollBarThickness=4
	page.AutomaticCanvasSize=Enum.AutomaticSize.Y
	page.BackgroundTransparency=1

	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0,6)

	tabs[name]=page
	page.Visible=false

	btn.MouseButton1Click:Connect(function()
		for k,v in pairs(tabs) do
			v.Visible=false
		end
		page.Visible=true
	end)

	if not currentTab then
		currentTab=name
		page.Visible=true
	end

	return page
end

-- RAINBOW CHO TAB CHỮ
task.spawn(function()
	while true do
		for _, btn in pairs(tabBar:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.TextColor3=rainbowColor(0.2)
			end
		end
		task.wait(0.03)
	end
end)

-- TẠO TAB MẪU
local exampleTab = createTab("Tab 1")
-- PHẦN 2/2: TOGGLE, BUTTON, RAINBOW ANIMATION, DRAG NỘI BỘ

-- HÀM TẠO NÚT TOGGLE RAINBOW
local function createToggle(text, parent, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(0.9,0,0,32)
	holder.BackgroundTransparency=1

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0,28,0,28)
	btn.Position = UDim2.new(0,0,0.5,-14)
	btn.Text=""
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius=UDim.new(0,6)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Thickness=2

	local lbl = Instance.new("TextLabel", holder)
	lbl.Size=UDim2.new(1,-35,1,0)
	lbl.Position=UDim2.new(0,35,0,0)
	lbl.BackgroundTransparency=1
	lbl.Text=text
	lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=14
	lbl.TextColor3=rainbowColor(0.2)
	lbl.TextXAlignment=Enum.TextXAlignment.Left

	local state=false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(40,40,40)
		callback(state)
	end)

	-- Rainbow stroke animation
	task.spawn(function()
		while true do
			stroke.Color = rainbowColor(0.15)
			lbl.TextColor3 = rainbowColor(0.15)
			task.wait(0.03)
		end
	end)
end

-- HÀM TẠO NÚT BÌNH THƯỜNG
local function createButton(text,parent,callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size=UDim2.new(0.9,0,0,32)
	btn.BackgroundColor3=Color3.fromRGB(170,0,0)
	btn.Font=Enum.Font.GothamBold
	btn.TextSize=14
	btn.TextColor3=rainbowColor(0.2)
	btn.Text=text
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius=UDim.new(0,6)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Thickness=2

	btn.MouseButton1Click:Connect(callback)

	-- Rainbow animation
	task.spawn(function()
		while true do
			stroke.Color=rainbowColor(0.15)
			btn.TextColor3=rainbowColor(0.15)
			task.wait(0.03)
		end
	end)
end

-- CHO NỘI DUNG TAB MẪU
for i=1,8 do
	createButton("Button "..i, exampleTab, function()
		print("Clicked Button "..i)
	end)

	createToggle("Toggle "..i, exampleTab, function(state)
		print("Toggle "..i.." state:", state)
	end)
end

-- HÀM KÉO NỘI BỘ CHO SCROLLABLE PAGE
local function makeDraggable(frame)
	local dragging=false
	local dragInput,mousePos,framePos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then
			dragging=true
			mousePos=input.Position
			framePos=frame.Position
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseMovement then
			dragInput=input
		end
	end)
	RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta=dragInput.Position - mousePos
			frame.Position=framePos+UDim2.new(0,delta.X,0,delta.Y)
		end
	end)
end

-- KÉO TOÀN BỘ UI
makeDraggable(main)

-- RAINBOW CHO TOÀN BỘ TAB NÚT
task.spawn(function()
	while true do
		for _, page in pairs(tabs) do
			for _, child in pairs(page:GetChildren()) do
				if child:IsA("TextButton") or child:IsA("TextLabel") then
					child.TextColor3 = rainbowColor(0.2)
				end
				if child:IsA("Frame") then
					for _, sub in pairs(child:GetChildren()) do
						if sub:IsA("TextButton") or sub:IsA("TextLabel") then
							sub.TextColor3 = rainbowColor(0.2)
						end
					end
				end
			end
		end
		task.wait(0.03)
	end
end)

-- SCROLL TAB RAINBOW
task.spawn(function()
	while true do
		for _, btn in pairs(tabBar:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.TextColor3 = rainbowColor(0.2)
			end
		end
		task.wait(0.03)
	end
end)

-- HOÀN THIỆN
print("PhucMax Rainbow UI loaded ✅")