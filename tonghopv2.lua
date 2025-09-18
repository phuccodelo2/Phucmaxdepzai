-- PHUCMAX UI PRO FIX (ANIMATION + CLIP FIX)
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

-- Toggle button (draggable)
local toggleGui = Instance.new("ScreenGui", game.CoreGui)
toggleGui.Name = "PHUCMAX_TOGGLE"
toggleGui.ResetOnSpawn = false

local toggleBtn = Instance.new("ImageButton", toggleGui)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0,45,0,45)
toggleBtn.Position = UDim2.new(0,20,0.5,-22)
toggleBtn.AnchorPoint = Vector2.new(0,0.5)
toggleBtn.Image = "rbxassetid://86753621306939"
toggleBtn.BackgroundTransparency = 0.6
toggleBtn.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(0,12)
local uiStroke = Instance.new("UIStroke", toggleBtn)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(135,206,250)

-- draggable
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

-- MAIN UI
local mainGui = Instance.new("ScreenGui", game.CoreGui)
mainGui.Name = "PHUCMAX_MAINUI"
mainGui.ResetOnSpawn = false
mainGui.Enabled = false

local mainFrame = Instance.new("ImageLabel", mainGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,500,0,350)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Image = "rbxassetid://86753621306939"
mainFrame.BackgroundTransparency = 1
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ClipsDescendants = true  -- CRITICAL: cắt nội dung khi tween

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0,20)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(180,220,255)

-- TAB area (horizontal scroll) - trong suốt như kính
local tabFrame = Instance.new("ScrollingFrame", mainFrame)
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0,10,0,10)
tabFrame.BackgroundTransparency = 1
tabFrame.ScrollBarThickness = 6
tabFrame.ClipsDescendants = true
tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
tabFrame.ScrollingDirection = Enum.ScrollingDirection.X

local tabList = Instance.new("UIListLayout", tabFrame)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0,10)

-- CONTENT area (vertical scroll)
local contentFrame = Instance.new("ScrollingFrame", mainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0,10,0,50)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 8
contentFrame.ClipsDescendants = true
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local contentList = Instance.new("UIListLayout", contentFrame)
contentList.SortOrder = Enum.SortOrder.LayoutOrder
contentList.Padding = UDim.new(0,10)
contentList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper: create tab (glass)
local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0,120,1,0)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BackgroundTransparency = 0.35
    tabBtn.AutoButtonColor = false

    local corner = Instance.new("UICorner", tabBtn)
    corner.CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(180,220,255)
    stroke.Transparency = 0.3

    return tabBtn
end

-- Helper: create button full width (glass)
local function createButton(text)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, 0, 0, 40) -- full width
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.35
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(135,206,250)
    stroke.Transparency = 0.3

    return btn
end

-- demo items
local t1 = createTab("Demo")
local t2 = createTab("Main")
local b1 = createButton("Demo nút 1")
local b2 = createButton("Demo nút 2")
local b3 = createButton("Demo nút 3")
local b4 = createButton("Demo nút 4")
-- ensure contentFrame canvas updates nicely (prevents jitter)
local function refreshCanvasSizes()
    -- tabFrame X canvas
    local totalX = tabList.AbsoluteContentSize.X + 16
    tabFrame.CanvasSize = UDim2.new(0, math.max(totalX, tabFrame.Size.X.Offset), 0, 0)
    -- contentFrame Y canvas
    local totalY = contentList.AbsoluteContentSize.Y + 16
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalY, contentFrame.Size.Y.Offset))
end

tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvasSizes)
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvasSizes)
-- initial refresh
task.spawn(function() task.wait(0.05); refreshCanvasSizes() end)

-- SMOOTH toggle UI (fixed: clip + tween ImageTransparency)
local OPEN_SIZE = UDim2.new(0,500,0,350)
local CLOSED_SIZE = UDim2.new(0,0,0,0)
local ANIM_TIME = 0.28

local animPlaying = false
local function toggleUI()
    if animPlaying then return end
    animPlaying = true

    if mainGui.Enabled then
        -- closing: animate smaller + fade image, then disable gui
        mainFrame.Active = false
        mainFrame.ClipsDescendants = true
        -- hide scrollbar input while animating
        tabFrame.Active = false
        contentFrame.Active = false

        local goals = { Size = CLOSED_SIZE, Position = UDim2.new(0.5,0,0.5,0), ImageTransparency = 1 }
        local tw = TweenService:Create(mainFrame, TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In), goals)
        tw:Play()
        tw.Completed:Wait()
        mainGui.Enabled = false
        -- re-enable small delay
        tabFrame.Active = true
        contentFrame.Active = true
    else
        -- opening: set small, visible, then tween to full
        mainGui.Enabled = true
        mainFrame.Size = CLOSED_SIZE
        mainFrame.Position = UDim2.new(0.5,0,0.5,0)
        mainFrame.ImageTransparency = 1
        mainFrame.ClipsDescendants = true

        -- ensure canvas sizes are correct before showing
        refreshCanvasSizes()

        local goals = { Size = OPEN_SIZE, Position = UDim2.new(0.5,0,0.5,0), ImageTransparency = 0 }
        local tw = TweenService:Create(mainFrame, TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
        tw:Play()
        tw.Completed:Wait()
    end

    animPlaying = false
end

toggleBtn.MouseButton1Click:Connect(toggleUI)

-- ensure Main is centered on screen resize (optional)
local function centerUI()
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end
game:GetService("GuiService"):GetPropertyChangedSignal("ScreenSize"):Connect(centerUI) -- fallback for some executors

-- done
print("[PHUCMAX UI] Fixed: animation & clipping applied.")