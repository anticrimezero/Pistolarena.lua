-- A.C.Z PISTOL HUB (FINAL ESP + DEATH EFFECT)
-- Delta Executor

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera
local tweenService = game:GetService("TweenService")

-- ID ДЛЯ ESP
local ESP_IMAGE_ID = "rbxassetid://10942997895"

-- ГУИ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ACZPistolHub"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 180)
mainFrame.Position = UDim2.new(0.5, -70, 0.5, -90)
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
titleBar.Size = UDim2.new(1, 0, 0, 22)
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
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- КНОПКА ЗАКРЫТИЯ
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 16, 0, 16)
closeBtn.Position = UDim2.new(1, -20, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 10
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- КНОПКА ОТКРЫТИЯ
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 22, 0, 22)
openBtn.Position = UDim2.new(1, -26, 0, 5)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
openBtn.Text = "🕸️"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 13
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
btnContainer.Size = UDim2.new(1, -10, 1, -28)
btnContainer.Position = UDim2.new(0, 5, 0, 26)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = mainFrame

local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(55, 0, 95)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 170, 255)
    btn.TextSize = 11
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

-- ============ ESP С КРУТЯЩИМСЯ ИЗОБРАЖЕНИЕМ ============
local espEnabled = false
local espObjects = {}

local function createESPForPlayer(targetChar)
    local head = targetChar:FindFirstChild("Head")
    if not head then return end
    
    local plr = game.Players:GetPlayerFromCharacter(targetChar)
    if not plr or plr == player then return end
    
    -- Биллборд
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Image"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 55, 0, 55)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    -- Изображение (крутящееся)
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.Image = ESP_IMAGE_ID
    image.ImageColor3 = Color3.fromRGB(180, 50, 255)
    image.Parent = billboard
    
    -- Имя игрока
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Position = UDim2.new(0, 0, 1, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.Bodoni
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(100, 0, 50)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = billboard
    
    -- Дистанция
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 1, 16)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0s"
    distLabel.TextColor3 = Color3.fromRGB(200, 50, 150)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Bodoni
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(50, 0, 50)
    distLabel.TextXAlignment = Enum.TextXAlignment.Center
    distLabel.Parent = billboard
    
    local data = {
        billboard = billboard,
        image = image,
        nameLabel = nameLabel,
        distLabel = distLabel,
        plr = plr,
        head = head,
        angle = 0
    }
    
    table.insert(espObjects, data)
    return data
end

-- ============ ВИЗУАЛ СМЕРТИ ============
local deathVisualEnabled = true

local function createDeathEffect(position)
    -- Сфера
    local sphere = Instance.new("Part")
    sphere.Name = "DeathSphere"
    sphere.Size = Vector3.new(1, 1, 1)
    sphere.Position = position + Vector3.new(0, 1, 0)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.BrickColor = BrickColor.new("Bright purple")
    sphere.Material = Enum.Material.Neon
    sphere.Transparency = 0.3
    sphere.Shape = Enum.PartType.Ball
    sphere.Parent = game.Workspace
    
    -- Круг на земле
    local circle = Instance.new("Part")
    circle.Name = "DeathCircle"
    circle.Size = Vector3.new(0.5, 0.1, 0.5)
    circle.Position = position + Vector3.new(0, 0.1, 0)
    circle.Anchored = true
    circle.CanCollide = false
    circle.BrickColor = BrickColor.new("Bright purple")
    circle.Material = Enum.Material.Neon
    circle.Transparency = 0.2
    circle.Parent = game.Workspace
    
    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = circle
    
    -- Анимация сферы
    local sphereTween = tweenService:Create(sphere, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(8, 8, 8),
        Transparency = 1
    })
    sphereTween:Play()
    
    -- Анимация круга
    local circleTween = tweenService:Create(circle, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(20, 0.1, 20),
        Transparency = 1
    })
    circleTween:Play()
    
    task.wait(3.5)
    sphere:Destroy()
    circle:Destroy()
end

-- Отслеживание смерти ДРУГИХ игроков
local function setupDeathDetection()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            plr.CharacterAdded:Connect(function(char)
                local humanoid = char:WaitForChild("Humanoid", 10)
                if humanoid then
                    humanoid.Died:Connect(function()
                        if deathVisualEnabled then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                createDeathEffect(hrp.Position)
                            end
                        end
                    end)
                end
            end)
        end
    end
end

-- ============ ОБНОВЛЕНИЕ ESP ============
local function updateESP()
    -- Удаляем старый ESP
    for _, data in pairs(espObjects) do
        pcall(function() 
            if data.billboard then data.billboard:Destroy() end
        end)
    end
    espObjects = {}
    
    if not espEnabled then return end
    if not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            local targetHrp = char:FindFirstChild("HumanoidRootPart")
            
            if head and targetHrp then
                local pos = targetHrp.Position
                local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                
                if onScreen then
                    local dist = (hrp.Position - pos).Magnitude
                    local espData = createESPForPlayer(char)
                    
                    if espData and espData.distLabel then
                        espData.distLabel.Text = math.floor(dist) .. "s"
                    end
                end
            end
        end
    end
end

-- Вращение изображений
runService.RenderStepped:Connect(function()
    for _, data in pairs(espObjects) do
        if data.image and data.image.Parent then
            data.angle = (data.angle or 0) + 2
            data.image.Rotation = data.angle
        end
    end
end)

-- ============ КНОПКИ ============
createButton("ESP", 2, function(state)
    espEnabled = state
    if not state then
        for _, data in pairs(espObjects) do
            pcall(function() 
                if data.billboard then data.billboard:Destroy() end
            end)
        end
        espObjects = {}
    end
end)

createButton("DeathFX", 26, function(state)
    deathVisualEnabled = state
end)

-- FLY
local flyEnabled = false
local flyConnection = nil

createButton("Fly", 50, function(state)
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

-- DODGE
createButton("Dodge", 74, function(state)
    if state and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, -800, 0)
        end
    end
end)

-- AIMBOT
local aimbotEnabled = false

createButton("Aim", 98, function(state)
    aimbotEnabled = state
end)

-- АВТО-АИМ
runService.Heartbeat:Connect(function()
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = nil
    local targetDist = math.huge
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local toPlayer = (hrp.Position - head.Position).Unit
            local lookDir = head.CFrame.LookVector
            local dotProduct = toPlayer:Dot(lookDir)
            
            if dotProduct > 0.3 then
                local dist = (hrp.Position - head.Position).Magnitude
                if dist < targetDist then
                    targetDist = dist
                    target = head
                end
            end
        end
    end
    
    if target then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
    end
    
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

-- ============ ЗАПУСК ============
runService.Heartbeat:Connect(updateESP)

task.spawn(function()
    wait(1)
    setupDeathDetection()
end)

-- ОЧИСТКА
player.CharacterAdded:Connect(function()
    for _, data in pairs(espObjects) do
        pcall(function() 
            if data.billboard then data.billboard:Destroy() end
        end)
    end
    espObjects = {}
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end)

print("✦ A.C.Z PISTOL HUB LOADED!")
print("✦ ESP: КРУТЯЩЕЕСЯ ИЗОБРАЖЕНИЕ (10942997895)")
print("✦ С ИМЕНЕМ И ДИСТАНЦИЕЙ")
print("✦ DEATH FX: СФЕРА + КРУГ НА ЗЕМЛЕ")
