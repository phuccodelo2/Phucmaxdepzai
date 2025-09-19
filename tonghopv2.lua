-- PHUCMAX UI PRO FIX (ANIMATION + CLIP FIX + BUTTON/TAB ANIM)
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

-- Draggable system
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
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
toggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- MAIN UI
local mainGui = Instance.new("ScreenGui", game.CoreGui)
mainGui.Name = "PHUCMAX_MAINUI"
mainGui.ResetOnSpawn = false
mainGui.Enabled = false

local mainFrame = Instance.new("ImageLabel", mainGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,400,0,250)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Image = "rbxassetid://112536373654055"
mainFrame.BackgroundTransparency = 1
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0,20)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(180,220,255)

-- TAB area
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

-- CONTENT area
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

-- NOTIFY system góc phải dưới
local function notify(msg)
    local note = Instance.new("TextLabel", mainGui)
    note.Size = UDim2.new(0,250,0,40)
    note.Position = UDim2.new(1,-260,1,-60)
    note.BackgroundColor3 = Color3.fromRGB(30,30,30)
    note.BackgroundTransparency = 0.2
    note.Text = msg
    note.Font = Enum.Font.GothamBold
    note.TextSize = 16
    note.TextColor3 = Color3.fromRGB(255,255,255)
    note.AnchorPoint = Vector2.new(0,0)
    local c = Instance.new("UICorner", note)
    c.CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", note)
    s.Thickness = 1.5
    s.Color = Color3.fromRGB(135,206,250)
    task.delay(3,function() note:Destroy() end)
end

-- Helper: create tab
local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0,120,1,0)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.TextColor3 = Color3.fromRGB(0,50,150) 
    tabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BackgroundTransparency = 0.35
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", tabBtn).Color = Color3.fromRGB(180,220,255)

    -- animation click
    tabBtn.MouseButton1Click:Connect(function()
        local t1 = TweenService:Create(tabBtn,TweenInfo.new(0.08),{Size=UDim2.new(0,115,1,0)})
        local t2 = TweenService:Create(tabBtn,TweenInfo.new(0.1),{Size=UDim2.new(0,120,1,0)})
        t1:Play() t1.Completed:Connect(function() t2:Play() end)
    end)
    return tabBtn
end

-- Helper: create button
local function createButton(text, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(0,50,150) 
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.35
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(135,206,250)

    -- animation + callback
    btn.MouseButton1Click:Connect(function()
        local t1 = TweenService:Create(btn,TweenInfo.new(0.08),{Size=UDim2.new(1,0,0,35)})
        local t2 = TweenService:Create(btn,TweenInfo.new(0.1),{Size=UDim2.new(1,0,0,40)})
        t1:Play() t1.Completed:Connect(function() t2:Play() end)
        if callback then callback() end
    end)
    return btn
end

-- quản lý tab + content
local tabs = {}

-- Helper: create tab
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

    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(180,220,255)
    stroke.Transparency = 0.3

    -- tạo content frame riêng cho tab
    local thisContent = Instance.new("ScrollingFrame", mainFrame)
    thisContent.Name = name .. "_Content"
    thisContent.Size = UDim2.new(1, -20, 1, -70)
    thisContent.Position = UDim2.new(0,10,0,50)
    thisContent.BackgroundTransparency = 1
    thisContent.ScrollBarThickness = 8
    thisContent.ClipsDescendants = true
    thisContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    thisContent.ScrollingDirection = Enum.ScrollingDirection.Y
    thisContent.Visible = false

    local list = Instance.new("UIListLayout", thisContent)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0,10)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center

    tabs[name] = {btn = tabBtn, frame = thisContent}

    -- animation + switch tab
    tabBtn.MouseButton1Click:Connect(function()
        for n, data in pairs(tabs) do
            data.frame.Visible = false
        end
        thisContent.Visible = true
        -- animation click
        local t1 = TweenService:Create(tabBtn, TweenInfo.new(0.08), {Size = UDim2.new(0,115,1,0)})
        local t2 = TweenService:Create(tabBtn, TweenInfo.new(0.1), {Size = UDim2.new(0,120,1,0)})
        t1:Play()
        t1.Completed:Connect(function() t2:Play() end)
    end)

    return thisContent
end

-- Helper: create button
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.35
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(135,206,250)
    stroke.Transparency = 0.3

    btn.MouseButton1Click:Connect(function()
        local t1 = TweenService:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(1,0,0,35)})
        local t2 = TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1,0,0,40)})
        t1:Play()
        t1.Completed:Connect(function() t2:Play() end)
        if callback then callback() end
    end)

    return btn
end

-- ======================
-- Tạo tab & nút riêng
-- ======================
-- TAB: Info
local infoContent = createTab("Info")
createButton(infoContent, "Thông tin", function()
    notify("by PHUCMAX tonghop hơn 50 script ")
end)
createButton(infoContent, "Copy Discord", function()
    setclipboard("https://discord.gg/yourlink")
    notify("Đã copy link Discord!")
end)


-- TAB: Blox Fruit
local bfContent = createTab("Blox Fruit")

createButton(bfContent, "nhattrai của ad", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Phucmaxdepzai/refs/heads/main/nhattrai91.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Redz", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Astral", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Main/refs/heads/main/BloxFruits_25.html"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Maru", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/KimP/refs/heads/main/MaruHub"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "nhatruong", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletgojo/Haidepzai/refs/heads/main/Autochest-Akgamingez"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Turbo Lite", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Main.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Turbo Lite Nhặt Trái", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/TraiCay.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Turbo Lite Fiy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/Fly.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Đạt THG V2", function()
    getgenv().Team = "Marines"
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/DatThg/refs/heads/main/DatThgV2"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Banana Cat", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kimprobloxdz/Banana-Free/refs/heads/main/Protected_5609200582002947.lua.txt"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, " OMG Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "HNC Auto Chest", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hnc-roblox/HNC_Hub.Super.Chest/refs/heads/main/ChestBypass.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, " Zee Hub", function()
    loadstring(game:HttpGet("https://zuwz.me/Ls-Zee-Hub"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, " Lion Auto Bounty", function()
    loadstring(game:HttpGet("https://pastefy.app/l1siGJS1/raw"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, " Ganteng Hub", function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/516a5669fc39b4945cd0609a08264505.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "Văn Thành Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VanThanhIOS/OniiChanVanThanhIOS/refs/heads/main/VanThanhIOS2027Online"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "nhatruong", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletgojo/Haidepzai/refs/heads/main/Autochest-Akgamingez"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "andepzai", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/AnDepZaiHubNewUpdated.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "minxredz", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinCE"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "bapred", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/BapRed/main/BapRedHub"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "cuttay", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/diemquy/CutTayHub/main/Cuttayhubreal.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "master", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jebblox/scriptdatabase2/main/scripts/masterhub.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "bluex", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "skull", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xxhumggxx/SkullHub/refs/heads/main/ChestV2.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "rise", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TrashLua/BloxFruits/main/FreeScripts.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "royxkaitun", function()
    loadstring(game:HttpGet("https://api.realaya.xyz/v1/files/l/73mkp0aqyfo4ypy8hvl0nz10lq49fey5.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "xero", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/verudous/Xero-Hub/main/main.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "min", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zunes-Bypassed/NOPE/main/Min.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(bfContent, "ngocbong", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ngocbonggaming/script/refs/heads/main/NgocBongVn.lua"))()
    notify("Script đã chạy thành công!")
end)


-- TAB: Steal a Brainrot
local stContent = createTab("Steal a Brainrot")

createButton(stContent, "chillhub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "moondiety", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/m00ndiety/Moondiety/refs/heads/main/Loader"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "airhub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/og2xn/AirHubs/refs/heads/main/Protected_3429231241525986.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "utopia", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/steal_a_brainrot.lua", true))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "arbix", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brainrot-op/refs/heads/main/Arbixhub-obfuscated.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "ronix", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/HFx6faQY"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "timmy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/WinzeTim/timmyhack2/refs/heads/main/stealabrainrot.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "inkx", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GuizzyisbackV2LOL/Inkxsteal/refs/heads/main/.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "lurk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/egor2078f/lurkhackv4/refs/heads/main/main.lua", true))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "prim", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/q8Q3Ff8F"))()
    notify("Script đã chạy thành công!")
end)

createButton(stContent, "vth", function()
    loadstring(game:HttpGet("https://get-avth-ontop.netlify.app/my-paste/script.lua"))()
    notify("Script đã chạy thành công!")
end)


-- TAB: 99 Nights
local kkContent = createTab("99 Nights")

createButton(kkContent, "pulsehub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Chavels123/Loader/refs/heads/main/loader.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "phongbac", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "Vexop", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "rez", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/newbie0z-lol/preprt/refs/heads/main/preprt.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "Voidware", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "H4x", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", true))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "Kenniel", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-Forest/refs/heads/main/99%20Nights%20in%20the%20Forest"))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "ronix", function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/7d8a2a1a9a562a403b52532e58a14065.lua"))()
    notify("Script đã chạy thành công!")
end)

createButton(kkContent, "Farmdiamond", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameFarmdiamond.lua"))()
    notify("Script đã chạy thành công!")
end)

local grContent = createTab("Grow a garden ")

createButton(grContent, "ZusumeeHub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vanthang512/ZusumeeHub/refs/heads/main/UpdateZyysume"))()
    notify("Script đã chạy thành công!")
end)

createButton(grContent, "DarkSpawner", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/BestScript-cmd/GrowAGarden-Dark/refs/heads/main/DarkSpawner-Updated"))()
    notify("Script đã chạy thành công!")
end)

createButton(grContent, "speed", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    notify("Script đã chạy thành công!")
end)

-- TAB FIX LAG
local fixContent = createTab("Fix Lag")

-- Hàm biến tất cả vật thể thành màu xám + plastic
local function grayMap()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(150,150,150)
            v.Reflectance = 0
            v.CastShadow = false
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    game.Lighting.GlobalShadows = false
    game.Lighting.Brightness = 1
    game.Lighting.FogEnd = 1e9
end

-- Fix Lag X1
createButton(fixContent, "Fix Lag X1", function()
    grayMap()
    notify("Đã bật Fix Lag X1 (biến map thành màu xám, tối ưu nhẹ).")
end)

-- Fix Lag X2
createButton(fixContent, "Fix Lag X2", function()
    grayMap()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    notify("Đã bật Fix Lag X2 (xóa hiệu ứng nhỏ + map xám).")
end)

-- Fix Lag X3
createButton(fixContent, "Fix Lag X3", function()
    grayMap()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Explosion") then
            v:Destroy()
        end
    end
    notify("Đã bật Fix Lag X3 (xóa hiệu ứng + bóng + map xám).")
end)

-- Fix Lag X4
createButton(fixContent, "Fix Lag X4", function()
    grayMap()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(120,120,120)
            v.TextureID = ""
        end
        if v:IsA("SpecialMesh") then
            v.TextureId = ""
        end
    end
    game.Lighting.Brightness = 0
    notify("Đã bật Fix Lag X4 (ẩn mesh + map xám).")
end)

-- Fix Lag X5
createButton(fixContent, "Fix Lag X5", function()
    grayMap()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.6
        end
    end
    local ter = game:GetService("Terrain")
    ter.WaterReflectance = 0
    ter.WaterTransparency = 1
    ter.WaterWaveSize = 0
    ter.WaterWaveSpeed = 0
    notify("Đã bật Fix Lag X5 (ẩn 60% map + map xám).")
end)

-- Fix Lag X6 (Cực Đại)
createButton(fixContent, "Fix Lag X6 (Cực Đại)", function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 1
            v.CanCollide = false
        end
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Explosion") then
            v:Destroy()
        end
    end
    game:GetService("Lighting"):ClearAllChildren()
    game:GetService("Lighting").Brightness = 0
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    game:GetService("Terrain"):Clear()
    notify("Đã bật Fix Lag X6 (ẩn toàn bộ map, fix cực đại).")
end)

-- Khôi phục map
createButton(fixContent, "Khôi phục Map", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    notify("Đang khôi phục map, vui lòng chờ (rejoin).")
end)

-- Mặc định bật tab Info
tabs["Info"].frame.Visible = true

-- refresh canvas
local function refreshCanvasSizes()
    tabFrame.CanvasSize = UDim2.new(0, math.max(tabList.AbsoluteContentSize.X+16, tabFrame.Size.X.Offset), 0, 0)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(contentList.AbsoluteContentSize.Y+16, contentFrame.Size.Y.Offset))
end
tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvasSizes)
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvasSizes)
task.defer(refreshCanvasSizes)


local OPEN_SIZE, CLOSED_SIZE, ANIM_TIME = UDim2.new(0,500,0,350), UDim2.new(0,0,0,0), 0.28
local animPlaying = false
local function toggleUI()
    if animPlaying then return end
    animPlaying = true
    if mainGui.Enabled then
        local tw = TweenService:Create(mainFrame, TweenInfo.new(ANIM_TIME,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size = CLOSED_SIZE, ImageTransparency = 1})
        tw:Play() tw.Completed:Wait() mainGui.Enabled=false
    else
        mainGui.Enabled=true
        mainFrame.Size=CLOSED_SIZE mainFrame.ImageTransparency=1
        refreshCanvasSizes()
        local tw = TweenService:Create(mainFrame,TweenInfo.new(ANIM_TIME,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {Size=OPEN_SIZE, ImageTransparency=0})
        tw:Play() tw.Completed:Wait()
    end
    animPlaying=false
end
toggleBtn.MouseButton1Click:Connect(toggleUI)

print("[PHUCMAX UI] Hoàn tất với Info + BloxFruit tab.")