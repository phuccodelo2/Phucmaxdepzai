

-- BloxF-Aimbot v1 (safer, per-tool filtering + projectile tracking)
-- Ghi chú: chạy trong executor (Fluxus/Delta/...) - test kĩ trước khi dùng

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cấu hình
local CONFIG = {
    AimRadius = 30000,                -- phạm vi mục tiêu
    ProjectileCheckRadius = 3550,    -- kiểm tra projectile quanh người chơi
    RemoteNamePatterns = {          -- chỉ hook remote có tên/parent match 1 trong này
        "Shoot", "Fire", "Cast", "Skill", "Activate", "Use", "Remote", "Hit", "Attack"
    },
    ToolNamePatterns = {            -- ưu tiên hook khi player đang cầm tool match patterns
        "Gun", "Pistol", "Rifle", "Sword", "Katana", "Melee", "Fruit", "Blox", "Tool"
    },
    PredictionFactor = 0.18,        -- sửa cho projectile (tùy tune)
    ToggleKey = nil,                -- bỏ nếu dùng mobile UI
    AutoLockPreferLowHP = true,     -- ưu tiên target máu thấp
    Debug = false,
}

-- UI đơn giản (mobile-friendly)
local function createToggle()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BF_AimbotGui"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0,140,0,48)
    btn.Position = UDim2.new(0.5,-70,0.86,0)
    btn.TextScaled = true
    btn.Text = "Aimbot: OFF"
    btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
    return gui, btn
end

local Gui, ToggleBtn = createToggle()
local Enabled = false
ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Aimbot: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,160,0)
    else
        ToggleBtn.Text = "Aimbot: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
    end
end)

-- Helpers
local function debugLog(...)
    if CONFIG.Debug then print("[AIMBOT]", ...) end
end

local function isNameMatch(name, patterns)
    if not name then return false end
    local lower = tostring(name):lower()
    for _, pat in ipairs(patterns) do
        if string.find(lower, tostring(pat):lower()) then return true end
    end
    return false
end

local function getClosestTarget()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local best, bestHp, bestDist = nil, math.huge, CONFIG.AimRadius
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos = p.Character.HumanoidRootPart.Position
                local dist = (myPos - pos).Magnitude
                if dist <= CONFIG.AimRadius then
                    if CONFIG.AutoLockPreferLowHP then
                        if hum.Health < bestHp or (hum.Health == bestHp and dist < bestDist) then
                            best, bestHp, bestDist = p, hum.Health, dist
                        end
                    else
                        if dist < bestDist then best, bestHp, bestDist = p, hum.Health, dist end
                    end
                end
            end
        end
    end
    return best
end

-- Tìm remote candidates trong game (ReplicatedStorage & workspace descendants)
local remoteCandidates = {}
local function scanRemotes()
    remoteCandidates = {}
    local function addIfMatch(inst)
        if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
            if isNameMatch(inst.Name, CONFIG.RemoteNamePatterns) or (inst.Parent and isNameMatch(inst.Parent.Name, CONFIG.RemoteNamePatterns)) then
                table.insert(remoteCandidates, inst)
            end
        end
    end
    -- scan ReplicatedStorage top-level and descendants
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do addIfMatch(v) end
    for _, v in ipairs(Workspace:GetDescendants()) do addIfMatch(v) end
    debugLog("Found remotes:", #remoteCandidates)
end

scanRemotes()
-- watch for new remotes added later
ReplicatedStorage.DescendantAdded:Connect(function(desc) if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then scanRemotes() end end)
Workspace.DescendantAdded:Connect(function(desc) if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then scanRemotes() end end)

-- Check if currently holding a tool that likely sends skill remotes
local function isHoldingRelevantTool()
    if not LocalPlayer.Character then return false end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return false end
    return isNameMatch(tool.Name, CONFIG.ToolNamePatterns)
end

-- Prediction: simple linear prediction
local function predictPosition(target, projectilePos, speed)
    -- if no velocity info or speed, fallback to direct pos
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = target.Character.HumanoidRootPart
    local targetPos = hrp.Position
    local vel = hrp.Velocity or Vector3.new(0,0,0)
    if speed and speed > 0 then
        local dir = (targetPos - projectilePos)
        local distance = dir.Magnitude
        local time = distance / speed
        return targetPos + vel * time * CONFIG.PredictionFactor
    else
        return targetPos
    end
end

-- Narrow hook: intercept FireServer only for candidate remotes while player holds relevant tool
local mt = getrawmetatable(game)
local oldReadOnly = false
local oldNamecall = nil
if mt and mt.__namecall then
    oldReadOnly = false
    pcall(function() oldReadOnly = debug.getupvalue and debug.getupvalue or false end)
end

local function safeSetReadonly(val) -- wrapper in case environment lacks setreadonly
    pcall(function() setreadonly(mt, not val) end)
end

safeSetReadonly(false)
oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    -- only handle FireServer and only if Enabled + holding relevant tool
    if Enabled and method == "FireServer" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        -- check this remote is in our candidate list (match by Instance equality or name)
        local isCandidate = false
        for _,r in ipairs(remoteCandidates) do
            if r == self then isCandidate = true; break end
        end
        -- also allow if remote name matches pattern (fallback)
        if not isCandidate and (isNameMatch(self.Name, CONFIG.RemoteNamePatterns) or (self.Parent and isNameMatch(self.Parent.Name, CONFIG.RemoteNamePatterns))) then
            isCandidate = true
        end

        if isCandidate and isHoldingRelevantTool() then
            -- choose target
            local target = getClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                -- modify args carefully: only replace Vector3/CFrame-looking values
                for i,v in ipairs(args) do
                    local t = typeof(v)
                    if t == "Vector3" then
                        args[i] = targetPos
                        debugLog("Replaced Vector3 arg with targetPos for", self.Name)
                    elseif t == "CFrame" then
                        -- keep original position but point at target
                        args[i] = CFrame.new(v.Position, targetPos)
                        debugLog("Replaced CFrame arg for", self.Name)
                    elseif t == "table" then
                        -- some remotes send complex tables; try to patch fields like position/dir/target
                        local copied = false
                        for key,val in pairs(v) do
                            if typeof(val) == "Vector3" and (string.find(string.lower(tostring(key)),"pos") or string.find(string.lower(tostring(key)),"position") or string.find(string.lower(tostring(key)),"target")) then
                                v[key] = targetPos; copied = true
                            elseif typeof(val) == "CFrame" and (string.find(string.lower(tostring(key)),"cframe") or string.find(string.lower(tostring(key)),"cf")) then
                                v[key] = CFrame.new(val.Position, targetPos); copied = true
                            end
                        end
                        if copied then args[i] = v; debugLog("Patched table arg for", self.Name) end
                    end
                end
            end
        end
    end

    return oldNamecall(self, unpack(args))
end)
safeSetReadonly(true)

-- Projectile tracking: every heartbeat, steer projectiles toward chosen target
RunService.Heartbeat:Connect(function()
    if not Enabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local target = getClosestTarget()
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and obj ~= LocalPlayer.Character.HumanoidRootPart then
            local vel = obj.Velocity
            if vel and vel.Magnitude > 12 then
                -- check within area
                if (obj.Position - myPos).Magnitude <= CONFIG.ProjectileCheckRadius then
                    -- steer by setting CFrame toward predicted position (non-ideal but works for many projectiles)
                    local predicted = predictPosition(target, obj.Position, vel.Magnitude) or target.Character.HumanoidRootPart.Position
                    pcall(function()
                        obj.CFrame = CFrame.new(obj.Position, predicted)
                        -- optional: nudge velocity direction (small tweak)
                        obj.Velocity = (predicted - obj.Position).Unit * vel.Magnitude
                    end)
                end
            end
        end
    end
end)

print("[BloxF-Aimbot] Loaded. Toggle with UI button. Scan remotes:", #remoteCandidates)