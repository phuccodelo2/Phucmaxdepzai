-- PHUCMAX VIP Loading UI with Rainbow Effect
local logoAssetId = "rbxassetid://109511081682777" -- Thay logo nếu muốn
local scriptLink1 = "https://raw.githubusercontent.com/phuccodelo2/Phucmaxdepzai/refs/heads/main/ScriptEnglish.lua"

-- Destroy old UI if exists
pcall(function() game.CoreGui:FindFirstChild("PhucmaxLoadingUI"):Destroy() end)

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Create UI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhucmaxLoadingUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", ScreenGui)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 400, 0, 220)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.BackgroundTransparency = 0
Main.Name = "Main"
Main.Active = true
Main.Draggable = true
Main.AutomaticSize = Enum.AutomaticSize.None
Main.ZIndex = 10
Main.BorderMode = Enum.BorderMode.Inset

-- Rainbow UI Stroke
local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round

-- Rainbow effect loop
task.spawn(function()
	while ScreenGui and ScreenGui.Parent do
		local t = tick()
		local hue = t % 5 / 5
		local color = Color3.fromHSV(hue, 1, 1)
		stroke.Color = color
		task.wait(0.03)
	end
end)

-- Round corner
local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(0, 16)

-- Logo Image
local Logo = Instance.new("ImageLabel", Main)
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0.5, -40, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Image = logoAssetId
local logoCorner = Instance.new("UICorner", Logo)
logoCorner.CornerRadius = UDim.new(1, 0)

-- Text Label
local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(1, -40, 0, 30)
Label.Position = UDim2.new(0, 20, 0, 110)
Label.BackgroundTransparency = 1
Label.Text = "PHUCMAX LOADING..."
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.Font = Enum.Font.GothamBold
Label.TextScaled = true

-- Progress Bar Background
local barBack = Instance.new("Frame", Main)
barBack.Size = UDim2.new(0.8, 0, 0, 15)
barBack.Position = UDim2.new(0.1, 0, 1, -40)
barBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", barBack).CornerRadius = UDim.new(1,0)

-- Progress Fill
local fill = Instance.new("Frame", barBack)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.Position = UDim2.new(0,0,0,0)
fill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

-- Animate Loading
TweenService:Create(fill, TweenInfo.new(3, Enum.EasingStyle.Linear), {
	Size = UDim2.new(1, 0, 1, 0)
}):Play()

-- Wait and Load Script + Select Marines team
task.delay(3.1, function()
	ScreenGui:Destroy()

	-- Load farmboss.lua script
	local s1 = loadstring(game:HttpGet(scriptLink1))
	pcall(s1)

	-- Select Marines team
	pcall(function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	end)

end)



