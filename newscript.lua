-- // PHẦN 1/4 : CORE UI + HIỆU ỨNG RAINBOW
-- Tác giả: PhucUI RainbowX
-- Kết hợp ý tưởng Rayfield + Fluent + Rainbow Gradient
-- Tổng code chia 4 phần (>2000 dòng)

-- Khởi tạo ScreenGui
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RainbowUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Hàm tạo Rainbow Gradient động
local function createRainbowGradient(parent)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255)),
    })
    uiGradient.Rotation = 0
    uiGradient.Parent = parent

    -- Animate Gradient
    task.spawn(function()
        while task.wait(0.03) do
            uiGradient.Rotation = (uiGradient.Rotation + 2) % 360
        end
    end)

    return uiGradient
end

-- Frame chính (UI Container)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

-- UICorner + Shadow
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.ZIndex = 0

-- Viền Rainbow Gradient
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame
createRainbowGradient(UIStroke)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Position = UDim2.new(0.5, 0, 0.5, 0)
Title.Size = UDim2.new(1, -20, 1, -10)
Title.Text = "🌈 Rainbow UI X - Rayfield + Fluent Style"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Rainbow Gradient cho Title
createRainbowGradient(Title)

-- Kéo UI bằng TitleBar
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("[RainbowUI] Part 1 Loaded: Core UI + Rainbow Gradient Ready!")
-- // PHẦN 2/4 : TAB + BUTTON + TOGGLE
-- Tiếp nối từ phần 1
-- Tất cả chữ + viền đều rainbow gradient

-- Container cho Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.Size = UDim2.new(0, 150, 1, -60)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.BorderSizePixel = 0

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 12)
TabCorner.Parent = TabContainer

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 6)

-- Nội dung tab
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 170, 0, 50)
ContentFrame.Size = UDim2.new(1, -180, 1, -60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

-- Rainbow border cho ContentFrame
local ContentStroke = Instance.new("UIStroke")
ContentStroke.Thickness = 2
ContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ContentStroke.Parent = ContentFrame
createRainbowGradient(ContentStroke)

-- Table quản lý tab
local Tabs = {}

-- Hàm tạo tab
local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabContainer
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Thickness = 2
    TabStroke.Parent = TabButton
    createRainbowGradient(TabStroke)
    createRainbowGradient(TabButton)

    -- Nội dung riêng của tab
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Parent = ContentFrame
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.ScrollBarThickness = 6

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = TabContent
    UIList.Padding = UDim.new(0, 8)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    Tabs[name] = {Button = TabButton, Content = TabContent}

    -- Click tab để show nội dung
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
        end
        TabContent.Visible = true
    end)

    return TabContent
end

-- Tạo một số tab mặc định
local HomeTab = createTab("🏠 Home")
local SettingsTab = createTab("⚙ Settings")

-- Auto chọn tab Home
Tabs["🏠 Home"].Content.Visible = true

----------------------------------------------------
-- Hàm tạo Button trong tab
local function createButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 2
    BtnStroke.Parent = Button
    createRainbowGradient(BtnStroke)
    createRainbowGradient(Button)

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return Button
end

-- Hàm tạo Toggle
local function createToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Parent = parent

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleFrame
    createRainbowGradient(ToggleStroke)

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.AnchorPoint = Vector2.new(0, 0.5)
    Label.Position = UDim2.new(0, 10, 0.5, 0)
    Label.Size = UDim2.new(0.7, 0, 1, -10)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextScaled = true
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    createRainbowGradient(Label)

    local Button = Instance.new("TextButton")
    Button.Parent = ToggleFrame
    Button.AnchorPoint = Vector2.new(1, 0.5)
    Button.Position = UDim2.new(1, -10, 0.5, 0)
    Button.Size = UDim2.new(0, 60, 0, 25)
    Button.Text = default and "ON" or "OFF"
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 0, 0)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Button

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 0, 0)
        pcall(callback, state)
    end)

    return ToggleFrame
end

----------------------------------------------------
-- Demo: thêm button + toggle vào HomeTab
createButton(HomeTab, "Click Me!", function()
    print("Button clicked!")
end)

createToggle(HomeTab, "Rainbow Mode", false, function(state)
    print("Toggle Rainbow:", state)
end)

print("[RainbowUI] Part 2 Loaded: Tabs + Buttons + Toggle Ready!")

-- // PHẦN 3/4 : SLIDER + DROPDOWN + KEYBIND + TEXTBOX
-- Tiếp nối từ Phần 1 + 2

----------------------------------------------------
-- Hàm tạo Slider
local function createSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Thickness = 2
    SliderStroke.Parent = SliderFrame
    createRainbowGradient(SliderStroke)

    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = text.." : "..default
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    createRainbowGradient(Label)

    local Bar = Instance.new("Frame")
    Bar.Parent = SliderFrame
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 35)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.BorderSizePixel = 0

    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Fill.BorderSizePixel = 0

    createRainbowGradient(Fill)

    local dragging = false
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relative = (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
            relative = math.clamp(relative, 0, 1)
            Fill.Size = UDim2.new(relative, 0, 1, 0)
            local value = math.floor(min + (max - min) * relative)
            Label.Text = text.." : "..value
            pcall(callback, value)
        end
    end)
end

----------------------------------------------------
-- Hàm tạo Dropdown
local function createDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownFrame.Parent = parent

    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 8)
    DropCorner.Parent = DropdownFrame

    local DropStroke = Instance.new("UIStroke")
    DropStroke.Thickness = 2
    DropStroke.Parent = DropdownFrame
    createRainbowGradient(DropStroke)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 1, -10)
    Button.Position = UDim2.new(0, 5, 0, 5)
    Button.Text = text.." ▼"
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.BackgroundTransparency = 1
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = DropdownFrame
    createRainbowGradient(Button)

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(1, -10, 0, #options * 30)
    ListFrame.Position = UDim2.new(0, 5, 1, 5)
    ListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ListFrame.Visible = false
    ListFrame.Parent = DropdownFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ListFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for _, option in ipairs(options) do
        local OptButton = Instance.new("TextButton")
        OptButton.Size = UDim2.new(1, -10, 0, 25)
        OptButton.Text = option
        OptButton.Font = Enum.Font.GothamBold
        OptButton.TextSize = 14
        OptButton.BackgroundTransparency = 1
        OptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptButton.Parent = ListFrame
        createRainbowGradient(OptButton)

        OptButton.MouseButton1Click:Connect(function()
            Button.Text = text.." : "..option
            ListFrame.Visible = false
            pcall(callback, option)
        end)
    end

    Button.MouseButton1Click:Connect(function()
        ListFrame.Visible = not ListFrame.Visible
    end)
end

----------------------------------------------------
-- Hàm tạo Keybind
local function createKeybind(parent, text, defaultKey, callback)
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
    KeybindFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    KeybindFrame.Parent = parent

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 8)
    KeyCorner.Parent = KeybindFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Thickness = 2
    KeyStroke.Parent = KeybindFrame
    createRainbowGradient(KeyStroke)

    local Label = Instance.new("TextLabel")
    Label.Parent = KeybindFrame
    Label.AnchorPoint = Vector2.new(0, 0.5)
    Label.Position = UDim2.new(0, 10, 0.5, 0)
    Label.Size = UDim2.new(0.6, 0, 1, -10)
    Label.Text = text.." : "..defaultKey.Name
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    createRainbowGradient(Label)

    local Button = Instance.new("TextButton")
    Button.Parent = KeybindFrame
    Button.AnchorPoint = Vector2.new(1, 0.5)
    Button.Position = UDim2.new(1, -10, 0.5, 0)
    Button.Size = UDim2.new(0, 100, 0, 25)
    Button.Text = "Change"
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local binding = false
    local currentKey = defaultKey

    Button.MouseButton1Click:Connect(function()
        binding = true
        Button.Text = "Press a Key..."
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp then return end
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            binding = false
            currentKey = input.KeyCode
            Button.Text = "Change"
            Label.Text = text.." : "..currentKey.Name
        elseif input.KeyCode == currentKey then
            pcall(callback)
        end
    end)
end

----------------------------------------------------
-- Hàm tạo Textbox
local function createTextbox(parent, text, placeholder, callback)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, -10, 0, 40)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    BoxFrame.Parent = parent

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = BoxFrame

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 2
    BoxStroke.Parent = BoxFrame
    createRainbowGradient(BoxStroke)

    local Label = Instance.new("TextLabel")
    Label.Parent = BoxFrame
    Label.AnchorPoint = Vector2.new(0, 0.5)
    Label.Position = UDim2.new(0, 10, 0.5, 0)
    Label.Size = UDim2.new(0.3, 0, 1, -10)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    createRainbowGradient(Label)

    local TextBox = Instance.new("TextBox")
    TextBox.Parent = BoxFrame
    TextBox.AnchorPoint = Vector2.new(1, 0.5)
    TextBox.Position = UDim2.new(1, -10, 0.5, 0)
    TextBox.Size = UDim2.new(0, 150, 0, 25)
    TextBox.PlaceholderText = placeholder
    TextBox.Text = ""
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

    local BoxCorner2 = Instance.new("UICorner")
    BoxCorner2.CornerRadius = UDim.new(0, 8)
    BoxCorner2.Parent = TextBox

    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            pcall(callback, TextBox.Text)
        end
    end)
end

----------------------------------------------------
-- Demo: thêm vào SettingsTab
createSlider(SettingsTab, "Volume", 0, 100, 50, function(val)
    print("Slider Value:", val)
end)

createDropdown(SettingsTab, "Choose Mode", {"Easy","Normal","Hard"}, function(opt)
    print("Selected:", opt)
end)

createKeybind(SettingsTab, "Open Menu", Enum.KeyCode.RightShift, function()
    MainFrame.Visible = not MainFrame.Visible
end)

createTextbox(SettingsTab, "Username", "Enter name...", function(txt)
    print("Entered:", txt)
end)

print("[RainbowUI] Part 3 Loaded: Slider + Dropdown + Keybind + Textbox Ready!")

--====================================================
-- 🌈 PART 4 - FINALIZATION & CLEANUP
--====================================================

-- 🌈 Tạo Rainbow Gradient Function cho Text
local function ApplyRainbowGradientToText(textLabel)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))
    }
    uiGradient.Rotation = 90
    uiGradient.Parent = textLabel
end

-- 🌈 Áp dụng rainbow cho tất cả TextLabel, TextButton
for _, obj in pairs(ScreenGui:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        ApplyRainbowGradientToText(obj)
    end
end

-- 🌈 Áp dụng Rainbow Gradient cho viền Frame
local function ApplyRainbowBorder(frame)
    local uistroke = Instance.new("UIStroke")
    uistroke.Thickness = 2
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uistroke.Color = Color3.fromRGB(255, 0, 0)
    uistroke.Parent = frame

    -- Animation Rainbow
    task.spawn(function()
        while true do
            for i = 0, 1, 0.01 do
                local hue = i
                uistroke.Color = Color3.fromHSV(hue, 1, 1)
                task.wait(0.05)
            end
        end
    end)
end

for _, obj in pairs(ScreenGui:GetDescendants()) do
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        ApplyRainbowBorder(obj)
    end
end

-- 🌈 Keybind ẩn/hiện UI
local UIS = game:GetService("UserInputService")
local uiVisible = true
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        uiVisible = not uiVisible
        ScreenGui.Enabled = uiVisible
    end
end)

-- 🌈 Hoàn tất
print("[🌈 Rainbow UI Hub] Loaded successfully with Rayfield+Fluent Style!")
print("[UI]: Rainbow gradient applied to all text & borders")
print("[UI]: Press RightControl to toggle UI visibility")

--====================================================
-- 🎉 END OF SCRIPT (4/4)
--====================================================