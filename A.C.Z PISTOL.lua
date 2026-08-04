-- A.C.Z PISTOL HUB (С АВТО-АИМОТОМ)
-- Delta Executor

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera

-- ГУИ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ACZPistolHub"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 200)
mainFrame.Position = UDim2.new(0.5, -80, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "A.C.Z"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- КНОПКА ЗАКРЫТИЯ
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -22, 0, 3.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- КНОПКА ОТКРЫТИЯ (С ПАУТИНОЙ 🕸️)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 25, 0, 25)
openBtn.Position = UDim2.new(1, -30, 0, 5)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
openBtn.Text = "🕸️"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.BorderSizePixel = 0
openBtn.Parent = screenGui
openBtn.Visible = false

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

-- ПЕРЕТАСКИВАНИЕ
local dragToggle = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = false
    end
end)

runService.RenderStepped:Connect(function()
    if dragToggle then
        local delta = mouse.X - dragStart.X
        local deltaY = mouse.Y - dragStart.Y
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta,
            startPos.Y.Scale,
            startPos.Y.Offset + deltaY
        )
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- КНОПКИ
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -10, 1, -32)
btnContainer.Position = UDim2.new(0, 5, 0, 30)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = mainFrame

local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(55, 0, 95)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 170, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = btnContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local isActive = false
    btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        btn.BackgroundColor3 = isActive and Color3.fromRGB(120, 0, 200) or Color3.fromRGB(55, 0, 95)
        callback(isActive)
    end)

    return btn
end

-- ESP
local espEnabled = false
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    if not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local targetHrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            if targetHrp and head then
                local pos = targetHrp.Position
                local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                
                if onScreen then
                    local dist = (hrp.Position - pos).Magnitude
                    
                    local top = Instance.new("Frame")
                    top.Size = UDim2.new(0, 30, 0, 2)
                    top.Position = UDim2.new(0, screenPos.X - 15, 0, screenPos.Y - 30)
                    top.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
                    top.BorderSizePixel = 0
                    top.Parent = screenGui
                    table.insert(espObjects, top)
                    
                    local bottom = Instance.new("Frame")
                    bottom.Size = UDim2.new(0, 30, 0, 2)
                    bottom.Position = UDim2.new(0, screenPos.X - 15, 0, screenPos.Y + 30)
                    bottom.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
                    bottom.BorderSizePixel = 0
                    bottom.Parent = screenGui
                    table.insert(espObjects, bottom)
                    
                    local left = Instance.new("Frame")
                    left.Size = UDim2.new(0, 2, 0, 60)
                    left.Position = UDim2.new(0, screenPos.X - 15, 0, screenPos.Y - 30)
                    left.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
                    left.BorderSizePixel = 0
                    left.Parent = screenGui
                    table.insert(espObjects, left)
                    
                    local right = Instance.new("Frame")
                    right.Size = UDim2.new(0, 2, 0, 60)
                    right.Position = UDim2.new(0, screenPos.X + 13, 0, screenPos.Y - 30)
                    right.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
                    right.BorderSizePixel = 0
                    right.Parent = screenGui
                    table.insert(espObjects, right)
                    
                    local nameText = Instance.new("TextLabel")
                    nameText.Size = UDim2.new(0, 80, 0, 14)
                    nameText.Position = UDim2.new(0, screenPos.X - 40, 0, screenPos.Y - 45)
                    nameText.BackgroundTransparency = 1
                    nameText.Text = plr.Name
                    nameText.TextColor3 = Color3.fromRGB(180, 100, 255)
                    nameText.TextSize = 10
                    nameText.Font = Enum.Font.GothamBold
                    nameText.TextStrokeTransparency = 0.5
                    nameText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    nameText.Parent = screenGui
                    table.insert(espObjects, nameText)
                    
                    local distText = Instance.new("TextLabel")
                    distText.Size = UDim2.new(0, 50, 0, 14)
                    distText.Position = UDim2.new(0, screenPos.X - 25, 0, screenPos.Y + 35)
                    distText.BackgroundTransparency = 1
                    distText.Text = tostring(math.floor(dist)) .. "s"
                    distText.TextColor3 = Color3.fromRGB(200, 130, 255)
                    distText.TextSize = 10
                    distText.Font = Enum.Font.GothamBold
                    distText.TextStrokeTransparency = 0.5
                    distText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    distText.Parent = screenGui
                    table.insert(espObjects, distText)
                end
            end
        end
    end
end

createButton("ESP", 2, function(state)
    espEnabled = state
    if not state then clearESP() end
end)

-- FLY
local flyEnabled = false
local flyConnection = nil

createButton("Fly", 28, function(state)
    flyEnabled = state
    if state then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            flyConnection = runService.RenderStepped:Connect(function()
                if flyEnabled and hrp and hrp.Parent then
                    hrp.Velocity = Vector3.new(0, 10, 0)
                end
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- AFK (DODGE)
createButton("Dodge", 54, function(state)
    if state and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, -800, 0)
        end
    end
end)

-- AIMBOT (РУЧНОЙ)
local aimbotEnabled = false

createButton("Aim", 80, function(state)
    aimbotEnabled = state
end)

-- АВТО-АИМОТ (КОГДА СМОТРЯТ НА ТЕБЯ)
local autoAimEnabled = true -- ВСЕГДА ВКЛЮЧЕН

runService.Heartbeat:Connect(function()
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = nil
    local targetDist = math.huge
    local isLookedAt = false
    
    -- Ищем кто смотрит на нас
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local toPlayer = (hrp.Position - head.Position).Unit
            local lookDir = head.CFrame.LookVector
            local dotProduct = toPlayer:Dot(lookDir)
            
            -- Если смотрит на нас (dot > 0.3)
            if dotProduct > 0.3 then
                isLookedAt = true
                local dist = (hrp.Position - head.Position).Magnitude
                if dist < targetDist then
                    targetDist = dist
                    target = head
                end
            end
        end
    end
    
    -- Если на нас смотрят - наводимся на обидчика (даже если аимбот выключен)
    if isLookedAt and target then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
    end
    
    -- Обычный аимбот (если включен)
    if aimbotEnabled then
        local bestTarget = nil
        local bestDist = math.huge
        
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local dist = (head.Position - hrp.Position).Magnitude
                if dist < bestDist and dist < 250 then
                    bestDist = dist
                    bestTarget = head
                end
            end
        end
        
        if bestTarget then
            camera.CFrame = CFrame.new(camera.CFrame.Position, bestTarget.Position)
        end
    end
end)

-- ЗВУК
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://81408592202455"
sound.Volume = 0.5
sound.Looped = true
sound.Parent = game.Workspace
pcall(function() sound:Play() end)

-- ESP UPDATE
runService.Heartbeat:Connect(updateESP)

-- ОЧИСТКА
player.CharacterAdded:Connect(function()
    clearESP()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end)

print("✦ A.C.Z PISTOL HUB LOADED!")
print("✦ AUTO-AIM: ВКЛЮЧЕН (когда смотрят на тебя)")
