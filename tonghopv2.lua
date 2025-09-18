-- PHUCMAX UI MENU (giữ nguyên UI cũ, thêm tab info + blox fruit)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- clear old
if game.CoreGui:FindFirstChild("PHUCMAX_MAINUI") then
    game.CoreGui.PHUCMAX_MAINUI:Destroy()
end
if game.CoreGui:FindFirstChild("PHUCMAX_TOGGLE") then
    game.CoreGui.PHUCMAX_TOGGLE:Destroy()
end

-- Toggle button
local toggleGui = Instance.new("ScreenGui", game.CoreGui)
toggleGui.Name = "PHUCMAX_TOGGLE"
toggleGui.ResetOnSpawn = false

local toggleBtn = Instance.new("ImageButton", toggleGui)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0,45,0,45)
toggleBtn.Position = UDim2.new(0,20,0.5,-22)
toggleBtn.AnchorPoint = Vector2.new(0,0.5)
toggleBtn.Image = "rbxassetid://70869581156112"
toggleBtn.BackgroundTransparency = 0.6

local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(0,12)
local uiStroke = Instance.new("UIStroke", toggleBtn)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(135,206,250)

-- draggable toggle
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    toggleBtn.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Main UI
local mainGui = Instance.new("ScreenGui", game.CoreGui)
mainGui.Name = "PHUCMAX_MAINUI"
mainGui.ResetOnSpawn = false
mainGui.Enabled = false

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,450,0,300)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BackgroundTransparency = 0.1

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0,15)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(135,206,250)
stroke.Thickness = 2

-- Tab buttons
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(0,120,1,0)
tabFrame.BackgroundTransparency = 0.2
tabFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local tabList = Instance.new("UIListLayout", tabFrame)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0,5)

-- Content
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1,-130,1,-20)
contentFrame.Position = UDim2.new(0,130,0,10)
contentFrame.BackgroundTransparency = 1

-- notify
local function notify(msg)
    local note = Instance.new("TextLabel", mainGui)
    note.Size = UDim2.new(0, 250, 0, 40)
    note.Position = UDim2.new(1, -260, 1, -60)
    note.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    note.BackgroundTransparency = 0.2
    note.Text = msg
    note.TextColor3 = Color3.fromRGB(255,255,255)
    note.Font = Enum.Font.Gotham
    note.TextSize = 16
    note.ZIndex = 10
    Instance.new("UICorner", note).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", note).Color = Color3.fromRGB(135,206,250)
    game:GetService("Debris"):AddItem(note, 3)
end

-- tab create
local currentTab
local function createTab(name)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local tabContent = Instance.new("ScrollingFrame", contentFrame)
    tabContent.Visible = false
    tabContent.Size = UDim2.new(1,0,1,0)
    tabContent.CanvasSize = UDim2.new(0,0,0,0)
    tabContent.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        tabContent.Visible = true
        currentTab = tabContent
    end)
    return tabContent
end

-- button create
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0,5,0,0)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BackgroundTransparency = 0.2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(135,206,250)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- Tab Info
local infoTab = createTab("info")
createButton(infoTab, "Thông tin: PHUCMAX Script Hub", function()
    notify("Bạn đang dùng PHUCMAX Hub")
end)
createButton(infoTab, "Copy Discord Link", function()
    setclipboard("https://discord.gg/yourlink")
    notify("Đã copy link Discord!")
end)

-- Tab Blox Fruit
local bfTab = createTab("blox fruit")
createButton(bfTab, "Run Kaitun Script", function()
    notify("Đang chạy script Kaitun...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Phucmaxdepzai/refs/heads/main/nhattrai91.lua"))()
end)

-- Toggle UI
toggleBtn.MouseButton1Click:Connect(function()
    mainGui.Enabled = not mainGui.Enabled
end)