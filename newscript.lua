

-- Dịch vụ
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraRainbowHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Hiệu ứng blur nền
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game.Lighting

-- Hàm tạo gradient rainbow
local function RainbowGradient(obj)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
    }
    grad.Parent = obj
    return grad
end

-- Hàm xoay gradient
local function AnimateGradient(grad)
    task.spawn(function()
        while task.wait(0.03) do
            grad.Rotation = (grad.Rotation + 2) % 360
        end
    end)
end

-- Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 380)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Viền rainbow cho MainFrame
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 3
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local StrokeGradient = RainbowGradient(MainStroke)
AnimateGradient(StrokeGradient)

-- Tiêu đề
local TitleBar = Instance.new("TextLabel", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "🌈 Ultra Rainbow Hub 🌈"
TitleBar.TextSize = 24
TitleBar.TextColor3 = Color3.new(1,1,1)

local TitleGrad = RainbowGradient(TitleBar)
AnimateGradient(TitleGrad)

-- Tabs container
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 140, 1, -50)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local TabCorner = Instance.new("UICorner", TabFrame)
TabCorner.CornerRadius = UDim.new(0, 8)

local TabStroke = Instance.new("UIStroke", TabFrame)
TabStroke.Thickness = 2
local TabGrad = RainbowGradient(TabStroke)
AnimateGradient(TabGrad)

local TabList = Instance.new("UIListLayout", TabFrame)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 8)

-- Nội dung tab
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -160, 1, -60)
ContentFrame.Position = UDim2.new(0, 150, 0, 55)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BackgroundTransparency = 0.1
local ContentCorner = Instance.new("UICorner", ContentFrame)
ContentCorner.CornerRadius = UDim.new(0, 8)

local ContentStroke = Instance.new("UIStroke", ContentFrame)
ContentStroke.Thickness = 2
local ContentGrad = RainbowGradient(ContentStroke)
AnimateGradient(ContentGrad)

-- Lưu tab
local Tabs = {}
local CurrentTab = nil

-- Hàm tạo tab
local function CreateTab(name, iconId)
    local Btn = Instance.new("TextButton", TabFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = "  " .. name
    Btn.TextSize = 16
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold

    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 8)

    local BtnStroke = Instance.new("UIStroke", Btn)
    BtnStroke.Thickness = 1.5
    local BtnGrad = RainbowGradient(BtnStroke)
    AnimateGradient(BtnGrad)

    local BtnTxtGrad = RainbowGradient(Btn)
    AnimateGradient(BtnTxtGrad)

    -- Tab content
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 4
    Page.BackgroundTransparency = 1

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    Tabs[name] = Page

    Btn.MouseButton1Click:Connect(function()
        if CurrentTab then Tabs[CurrentTab].Visible = false end
        CurrentTab = name
        Page.Visible = true
    end)

    if not CurrentTab then
        CurrentTab = name
        Page.Visible = true
    end

    return Page
end

-- Hàm tạo Toggle
local function CreateToggle(text, parent, callback)
    local Holder = Instance.new("Frame", parent)
    Holder.Size = UDim2.new(0.9, 0, 0, 40)
    Holder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    local HC = Instance.new("UICorner", Holder)
    HC.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Holder)
    Stroke.Thickness = 2
    local Grad = RainbowGradient(Stroke)
    AnimateGradient(Grad)

    local Label = Instance.new("TextLabel", Holder)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextSize = 16
    Label.TextColor3 = Color3.new(1,1,1)
    local TxtGrad = RainbowGradient(Label)
    AnimateGradient(TxtGrad)

    local Btn = Instance.new("TextButton", Holder)
    Btn.Size = UDim2.new(0.25, -5, 0.7, 0)
    Btn.Position = UDim2.new(0.75, 0, 0.15, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Text = "OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextColor3 = Color3.new(1,1,1)
    local BC = Instance.new("UICorner", Btn)
    BC.CornerRadius = UDim.new(0, 6)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(60,60,60)
        callback(state)
    end)
end

-- Tạo Tabs mẫu
local MainTab = CreateTab("Main")
local FarmTab = CreateTab("Farm")
local VisualTab = CreateTab("Visual")
local SettingsTab = CreateTab("Settings")

-- Thêm Toggle vào MainTab
CreateToggle("God Mode", MainTab, function(on) print("God Mode:",on) end)
CreateToggle("Noclip", MainTab, function(on) print("Noclip:",on) end)
CreateToggle("Auto Farm", FarmTab, function(on) print("Farm:",on) end)

-- Nút bật/tắt UI
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://3926305904"
ToggleBtn.ImageRectOffset = Vector2.new(324, 524)
ToggleBtn.ImageRectSize = Vector2.new(36, 36)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Thickness = 2
local ToggleGrad = RainbowGradient(ToggleStroke)
AnimateGradient(ToggleGrad)

local uiOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    if uiOpen then
        MainFrame.Visible = true
        TweenService:Create(blur, TweenInfo.new(0.4), {Size = 12}):Play()
    else
        MainFrame.Visible = false
        TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
    end
end)