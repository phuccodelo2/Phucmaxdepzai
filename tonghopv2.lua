-- PHUCMAX UI PRO FIX
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ
if game.CoreGui:FindFirstChild("PHUCMAX_MAINUI") then
    game.CoreGui.PHUCMAX_MAINUI:Destroy()
end
if game.CoreGui:FindFirstChild("PHUCMAX_TOGGLE") then
    game.CoreGui.PHUCMAX_TOGGLE:Destroy()
end

-- Tạo toggle button
local toggleGui = Instance.new("ScreenGui", game.CoreGui)
toggleGui.Name = "PHUCMAX_TOGGLE"

local toggleBtn = Instance.new("ImageButton", toggleGui)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0,45,0,45) -- nhỏ gọn hơn
toggleBtn.Position = UDim2.new(0,20,0.5,-22) -- giữa bên trái
toggleBtn.AnchorPoint = Vector2.new(0,0.5) -- căn giữa theo chiều dọc
toggleBtn.Image = "rbxassetid://86753621306939"
toggleBtn.BackgroundTransparency = 0.5
toggleBtn.BorderSizePixel = 0

-- Bo góc + viền
local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(0,12)

local uiStroke = Instance.new("UIStroke", toggleBtn)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(135,206,250) -- xanh da trời

-- Làm toggle kéo được
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- UI chính
local mainGui = Instance.new("ScreenGui", game.CoreGui)
mainGui.Name = "PHUCMAX_MAINUI"
mainGui.Enabled = false

local mainFrame = Instance.new("ImageLabel", mainGui)
mainFrame.Size = UDim2.new(0,500,0,350)
mainFrame.Position = UDim2.new(0.5,0,0.5,0) -- đúng giữa màn hình
mainFrame.AnchorPoint = Vector2.new(0.5,0.5) -- căn giữa chuẩn
mainFrame.Image = "rbxassetid://86753621306939"
mainFrame.BackgroundTransparency = 1
mainFrame.ScaleType = Enum.ScaleType.Crop

-- Bo góc + viền
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0,20)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(180,220,255)

-- Animation bật/tắt
local function toggleUI()
    if mainGui.Enabled then
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), Transparency = 1})
        tween:Play()
        tween.Completed:Wait()
        mainGui.Enabled = false
    else
        mainGui.Enabled = true
        mainFrame.Size = UDim2.new(0,0,0,0)
        mainFrame.Transparency = 1
        mainFrame.Position = UDim2.new(0.5,0,0.5,0) -- reset về giữa khi bật
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,500,0,350), Transparency = 0})
        tween:Play()
    end
end

toggleBtn.MouseButton1Click:Connect(toggleUI)
-- PHẦN TAB + NÚT
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0,10,0,10)
tabFrame.BackgroundTransparency = 1

local tabList = Instance.new("UIListLayout", tabFrame)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0,10)

-- Tạo hàm làm tab kính mờ
local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0,120,1,0)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BackgroundTransparency = 0.3 -- trong suốt như kính
    tabBtn.AutoButtonColor = false

    local corner = Instance.new("UICorner", tabBtn)
    corner.CornerRadius = UDim.new(0,8)

    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(180,220,255)
    stroke.Transparency = 0.3

    return tabBtn
end

-- Content area
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,-20,1,-60)
contentFrame.Position = UDim2.new(0,10,0,50)
contentFrame.BackgroundTransparency = 1

-- Hàm tạo nút chức năng kính mờ
local function createButton(text)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(0,180,0,40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(135,206,250)
    stroke.Transparency = 0.3

    return btn
end

-- Tạo tab và nút mẫu
local tab1 = createTab("Tab 1")
local tab2 = createTab("Tab 2")

-- Demo vài nút
local btn1 = createButton("Chức năng 1")
btn1.Position = UDim2.new(0,20,0,20)

local btn2 = createButton("Chức năng 2")
btn2.Position = UDim2.new(0,20,0,70)