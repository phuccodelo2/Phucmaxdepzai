-- PHUCMAX UI - Rainbow Gradient "rợn sống" cho text + FPS & Ping + Notifications
-- Dán vào LocalScript / executor. Không tạo nhiều lần (có guard).

if getgenv and getgenv().PHUCMAX_UI_LOADED then
    return
end
if getgenv then getgenv().PHUCMAX_UI_LOADED = true end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove old if exists
local existing = playerGui:FindFirstChild("PHUCMAX_UI")
if existing then existing:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "PHUCMAX_UI"
screen.ResetOnSpawn = false
screen.Parent = playerGui

-- Helpers
local function color3ToHex(c)
    local r = math.clamp(math.floor(c.R * 255), 0, 255)
    local g = math.clamp(math.floor(c.G * 255), 0, 255)
    local b = math.clamp(math.floor(c.B * 255), 0, 255)
    return string.format("#%02x%02x%02x", r, g, b)
end

-- Build richtext gradient for a string (per-char colors, animated by baseHue)
local function buildGradientRichText(text, baseHue, spread, brightnessWave)
    -- text: string, baseHue: number 0..1, spread: hue offset between chars, brightnessWave: function(index, t) -> brightness
    local out = {}
    local len = utf8.len(text)
    -- iterate by byte-safe char
    local i = 0
    for _, ch in utf8.codes(text) do
        i = i + 1
        local char = utf8.char(ch)
        local hue = (baseHue + (i-1) * spread) % 1
        local bright = 1
        if brightnessWave then
            bright = brightnessWave(i, tick()) -- 0..1
            bright = math.clamp(bright, 0.2, 1)
        end
        local col = Color3.fromHSV(hue, 1, bright)
        local hex = color3ToHex(col)
        -- escape < and >
        if char == "<" then char = "&lt;" end
        if char == ">" then char = "&gt;" end
        table.insert(out, string.format('<font color="%s">%s</font>', hex, char))
    end
    return table.concat(out)
end

-- Gradient-managed labels registry
local gradientLabels = {} -- { {label=TextLabel, text="PHUCMAX", spread=..., speed=..., brightnessWave=fn}, ... }

local function registerGradientLabel(lbl, text, opts)
    opts = opts or {}
    local entry = {
        label = lbl,
        text = text or lbl.Text or "",
        spread = opts.spread or (1 / math.max(utf8.len(text or lbl.Text or ""), 1)) * 0.6,
        speed = opts.speed or 0.6,
        brightnessWave = opts.brightnessWave or function(i,t) return 0.85 + 0.12 * math.sin(t * 4 + i * 0.6) end
    }
    lbl.RichText = true
    lbl.Text = "" -- will be set by updater
    gradientLabels[#gradientLabels + 1] = entry
    return entry
end

-- UI elements & layout adjustments (more spacing)
-- Main big label (PHUCMAX)
local mainLabel = Instance.new("TextLabel")
mainLabel.Name = "MainLabel"
mainLabel.Size = UDim2.new(0.7, 0, 0, 80)
mainLabel.Position = UDim2.new(0.5, 0, 0.30, 0)
mainLabel.AnchorPoint = Vector2.new(0.5, 0.5)
mainLabel.BackgroundTransparency = 1
mainLabel.Font = Enum.Font.GothamBlack
mainLabel.TextScaled = true
mainLabel.Text = "PHUCMAX"
mainLabel.Parent = screen
mainLabel.TextStrokeTransparency = 0.4

-- Sub label under main (nhattrai)
local subLabel = Instance.new("TextLabel")
subLabel.Name = "SubLabel"
subLabel.Size = UDim2.new(0.45, 0, 0, 40)
subLabel.Position = UDim2.new(0.5, 0, 0.395, 0)
subLabel.AnchorPoint = Vector2.new(0.5, 0.5)
subLabel.BackgroundTransparency = 1
subLabel.Font = Enum.Font.GothamBold
subLabel.TextScaled = true
subLabel.Text = "nhattrai"
subLabel.Parent = screen
subLabel.TextStrokeTransparency = 0.5

-- Info label for FPS | Ping under sub (smaller)
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(0.35, 0, 0, 28)
infoLabel.Position = UDim2.new(0.5, 0, 0.455, 0)
infoLabel.AnchorPoint = Vector2.new(0.5, 0.5)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextScaled = true
infoLabel.Text = "FPS: 0 | Ping: 0 ms"
infoLabel.Parent = screen

-- Notification container (bottom-right, a bit above jump button area)
local notiContainer = Instance.new("Frame")
notiContainer.Name = "NotiContainer"
notiContainer.Size = UDim2.new(0.22, 0, 0.18, 0)
-- place slightly above typical mobile jump button area (approx)
notiContainer.Position = UDim2.new(0.78, 0, 0.72, 0)
notiContainer.AnchorPoint = Vector2.new(0, 0)
notiContainer.BackgroundTransparency = 1
notiContainer.Parent = screen

-- notification queue & show function
local notiQueue = {}
local showing = false

local function showNotification(text)
    table.insert(notiQueue, text)
    -- if not currently showing, start show loop
    if not showing then
        showing = true
        spawn(function()
            while #notiQueue > 0 do
                local msg = table.remove(notiQueue, 1)
                -- create noti label
                local noti = Instance.new("TextLabel")
                noti.Size = UDim2.new(1, -6, 0, 36)
                noti.Position = UDim2.new(0, 6, 0, 6)
                noti.AnchorPoint = Vector2.new(0, 0)
                noti.BackgroundTransparency = 0.25
                noti.BackgroundColor3 = Color3.fromRGB(20,20,20)
                noti.BorderSizePixel = 0
                noti.Parent = notiContainer
                noti.Font = Enum.Font.GothamBold
                noti.TextScaled = true
                noti.RichText = true
                noti.Text = msg
                noti.TextTransparency = 1
                noti.TextStrokeTransparency = 0.6
                noti.ClipsDescendants = true
                local corner = Instance.new("UICorner", noti); corner.CornerRadius = UDim.new(0,8)

                -- register gradient for this notification
                registerGradientLabel(noti, msg, { spread = 0.06, speed = 1.2, brightnessWave = function(i,t) return 0.9 + 0.08*math.sin(t*6 + i*0.35) end })

                -- tween appear
                TweenService:Create(noti, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
                -- show 2s
                task.wait(2)
                -- tween disappear
                TweenService:Create(noti, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
                task.wait(0.18)
                -- cleanup: remove from gradientLabels table
                for idx,entry in ipairs(gradientLabels) do
                    if entry.label == noti then
                        table.remove(gradientLabels, idx)
                        break
                    end
                end
                noti:Destroy()
                task.wait(0.1)
            end
            showing = false
        end)
    end
end

-- Register main & sub as gradient labels
registerGradientLabel(mainLabel, "PHUCMAX", { spread = 0.04, speed = 0.55, brightnessWave = function(i,t) return 0.9 + 0.07*math.sin(t*3 + i*0.35) end })
registerGradientLabel(subLabel, "nhattrai", { spread = 0.055, speed = 0.7, brightnessWave = function(i,t) return 0.9 + 0.06*math.sin(t*4 + i*0.4) end })

-- FPS & Ping updater variables
local frames = 0
local lastTime = tick()
local fps = 0

-- single RenderStepped updater for gradients + FPS/ping
local updaterConn
updaterConn = RunService.RenderStepped:Connect(function(dt)
    -- update gradient labels
    for _, entry in ipairs(gradientLabels) do
        local lbl = entry.label
        if lbl and lbl.Parent then
            local baseHue = (tick() * entry.speed) % 1
            -- build richText using entry.text
            local text = entry.text or lbl.Text or ""
            if text == "" then
                -- fallback: use current plain text
                text = lbl.Text
            end
            -- construct gradient richtext
            local rich = buildGradientRichText(text, baseHue, entry.spread, entry.brightnessWave)
            -- apply
            lbl.Text = rich
        end
    end

    -- fps
    frames = frames + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = now
    end

    -- ping (ms)
    local ping = math.floor(Players:GetStatus() and (LocalPlayer:GetNetworkPing() * 1000) or (LocalPlayer:GetNetworkPing() * 1000)) -- fallback safe
    infoLabel.Text = string.format("FPS: %d   |   Ping: %d ms", fps, ping)
    -- also color infoLabel by gradient quickly
    local h = (tick() * 0.6) % 1
    infoLabel.TextColor3 = Color3.fromHSV(h, 1, 1)
end)

-- Utility: expose ShowNotification
if getgenv then
    getgenv().PHUCMAX_ShowNotification = showNotification
end

-- Example usage (comment out or keep):
-- showNotification("✅ Auto Join Hải Quân Bật")
-- showNotification("🍏 Auto nhặt trái đang chạy")
-- showNotification("⚡ FixLag X2 applied")

print("PHUCMAX UI loaded (gradient 'rợn sống').")
