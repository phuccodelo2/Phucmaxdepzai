--// UI Glass Effect with Toggle + Demo Tab/Button
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Nút Toggle (trong suốt kiểu kính)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0.05, 0, 0.5, -30)
ToggleButton.Text = "☰"
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BorderSizePixel = 0
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = ScreenGui

-- Bo góc + hiệu ứng kính
local cornerBtn = Instance.new("UICorner", ToggleButton)
cornerBtn.CornerRadius = UDim.new(0, 12)
local strokeBtn = Instance.new("UIStroke", ToggleButton)
strokeBtn.Color = Color3.fromRGB(255, 255, 255)
strokeBtn.Thickness = 1.5
strokeBtn.Transparency = 0.3

-- Làm draggable cho nút toggle
local dragging, dragInput, dragStart, startPos
ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		ToggleButton.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Frame chính (xuất hiện giữa màn hình)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Bo góc + viền
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- Animation mở UI
local function ShowUI()
	MainFrame.Visible = true
	MainFrame.BackgroundTransparency = 1
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.2,
		Size = UDim2.new(0, 300, 0, 200)
	}):Play()
end

-- Animation đóng UI
local function HideUI()
	TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	wait(0.3)
	MainFrame.Visible = false
end

-- Toggle UI
local open = false
ToggleButton.MouseButton1Click:Connect(function()
	if open then
		HideUI()
	else
		ShowUI()
	end
	open = not open
end)

-- Demo Tab
local DemoTab = Instance.new("TextLabel")
DemoTab.Size = UDim2.new(1, -20, 0, 30)
DemoTab.Position = UDim2.new(0, 10, 0, 10)
DemoTab.BackgroundTransparency = 0.4
DemoTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DemoTab.Text = "Demo Tab"
DemoTab.TextSize = 18
DemoTab.TextColor3 = Color3.fromRGB(0, 0, 0)
DemoTab.Parent = MainFrame
Instance.new("UICorner", DemoTab).CornerRadius = UDim.new(0, 10)

-- Demo Button
local DemoButton = Instance.new("TextButton")
DemoButton.Size = UDim2.new(0.8, 0, 0, 40)
DemoButton.Position = UDim2.new(0.1, 0, 0.4, 0)
DemoButton.BackgroundTransparency = 0.4
DemoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DemoButton.Text = "Demo Button"
DemoButton.TextSize = 20
DemoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
DemoButton.Parent = MainFrame
Instance.new("UICorner", DemoButton).CornerRadius = UDim.new(0, 10)