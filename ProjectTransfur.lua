local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local notifications = {}

_G.ChronixGraceMenuisMin = false
_G.ChronixPTESP = false

-- 获取本地玩家
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 定义需要高亮的模型名称和对应的文字
local modelsToHighlight = {
    {
        name = "__BasicSmallSafe",
        text = "小保险箱",
        color = Color3.new(1, 1, 1) -- 白色
    },
    {
        name = "__BasicLargeSafe",
        text = "大保险箱",
        color = Color3.new(1, 1, 1) -- 白色
    },
    {
        name = "__LargeGoldenSafe",
        text =  "金保险箱",
        color = Color3.fromRGB(255, 215, 0) -- 金色
    },
    {
        name = "Surplus Crate",
        text = "武器盒",
        color = Color3.new(1, 1, 1) -- 白色
    },
    {
        name = "Military Crate",
        text = "武器盒",
        color = Color3.new(1, 1, 1) -- 白色
    },
    {
        name = "SupplyDrop",
        text = "空投",
        color = Color3.new(1, 1, 1) -- 白色
    },
    {
        name = "Bot",
        text = "人机",
        color = Color3.new(1, 1, 1) -- 白色
    }
}

-- 存储高亮和文字标签的表
local highlights = {}
local labels = {}

-- 创建高亮和文字标签
local function createHighlightAndLabel(model)
    -- 创建高亮
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5 -- 透视效果
    highlight.OutlineTransparency = 0
    highlight.Parent = model

    -- 创建文字标签
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = model
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0) -- 文字在模型上方
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = ""
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.Parent = billboard

    billboard.Parent = model

    -- 存储高亮和标签
    highlights[model] = highlight
    labels[model] = textLabel
end

-- 更新高亮和文字标签
local function updateHighlightAndLabel(model)
    for _, modelInfo in ipairs(modelsToHighlight) do
        if model.Name == modelInfo.name then
            highlights[model].FillColor = modelInfo.color
            labels[model].Text = modelInfo.text
            break
        end
    end
end

-- 删除高亮和文字标签
local function removeHighlightAndLabel(model)
    if highlights[model] then
        highlights[model]:Destroy()
        highlights[model] = nil
    end
    if labels[model] then
        labels[model].Parent:Destroy()
        labels[model] = nil
    end
end

-- 开关功能
local function toggleFeature(offon)
    if offon then
        _G.ChronixPTESP = true
        -- 遍历 Workspace，查找需要高亮的模型
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") then
                for _, modelInfo in ipairs(modelsToHighlight) do
                    if model.Name == modelInfo.name then
                        createHighlightAndLabel(model)
                        updateHighlightAndLabel(model)
                        break
                    end
                end
            end
        end
    else
        _G.ChronixPTESP = false
        -- 删除所有高亮和文字标签
        for model in pairs(highlights) do
            removeHighlightAndLabel(model)
        end
    end
end

local Gui = Instance.new("ScreenGui")
Gui.Parent = game.CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://4590662766" -- 替换为你的音频ID
achievementSound.Volume = 0.5 -- 音量大小
achievementSound.Parent = SoundService

local function UpdatePositions()
    for index, frame in ipairs(notifications) do
        local targetPosition = UDim2.new(0.8, 0, 0.1 + (index - 1) * 0.11, 0)
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = targetPosition
        })
        tween:Play()
    end
end

local function CreateNotification(title, text, duration, isAchievement)
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0.2, 0, 0.1, 0)
    notificationFrame.Position = UDim2.new(1, 0, 0.1 + #notifications * 0.11, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- 背景颜色
    notificationFrame.BackgroundTransparency = 0.8 -- 背景透明度降低
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = Gui

    local uiCorner = Instance.new("UICorner", notificationFrame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    -- 标题
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 标题文字颜色
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 分隔线
    local divider = Instance.new("Frame", notificationFrame)
    divider.Size = UDim2.new(0.95, 0, 0, 1)
    divider.Position = UDim2.new(0.025, 0, 0.35, 0)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.8
    divider.BorderSizePixel = 0

    -- 正文
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Size = UDim2.new(0.95, 0, 0.6, 0)
    textLabel.Position = UDim2.new(0.025, 0, 0.3, 0)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- 正文文字颜色
    textLabel.TextSize = 18
    textLabel.BackgroundTransparency = 1
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(notifications, notificationFrame)

    -- 如果是成就通知，播放音效
    if isAchievement then
        achievementSound:Play()
    end

    -- 滑入动画
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.8, 0, notificationFrame.Position.Y.Scale, 0)
    })
    tweenIn:Play()

    -- 独立协程处理通知生命周期
    coroutine.wrap(function()
        wait(duration)
        
        -- 滑出动画
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, notificationFrame.Position.Y.Scale, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()

        -- 移除元素并更新队列
        local index = table.find(notifications, notificationFrame)
        if index then
            table.remove(notifications, index)
            notificationFrame:Destroy()
            UpdatePositions()
        end
    end)()
end

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 190, 0, 15)
window.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
window.BackgroundColor3 = Color3.new(1, 1, 1)
window.BackgroundTransparency = 0.8
window.BorderSizePixel = 0
window.ZIndex = 10
window.Parent = Gui
window.Draggable = true

local uiCorner = Instance.new("UICorner", window)
uiCorner.CornerRadius = UDim.new(0, 5)

local titleBar = Instance.new("Frame", window)
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.ZIndex = window.ZIndex + 1

local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 5)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "ProjectTransfur by Chronix"
titleText.TextColor3 = Color3.new(0, 0, 0)
titleText.TextSize = 14
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Position = UDim2.new(0.05, 0, 0, 0)

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.new(0, 15, 0, 15)
close.Text = "×"
close.TextColor3 = Color3.new(1, 0, 0)
close.TextSize = 14
close.BackgroundTransparency = 1
close.TextXAlignment = Enum.TextXAlignment.Right
close.Position = UDim2.new(1, 0, 0, 0)

local min = Instance.new("TextButton", titleBar)
min.Size = UDim2.new(0, 15, 0, 15)
min.Text = "↑"
min.TextColor3 = Color3.new(0, 1, 0)
min.TextSize = 18
min.BackgroundTransparency = 1
min.TextXAlignment = Enum.TextXAlignment.Right
min.Position = UDim2.new(0.88, 0, 0, 0)

local button = Instance.new("TextButton", window)
button.Size = UDim2.new(0, 140, 0, 25)
button.Text = "删除所有陷阱"
button.TextColor3 = Color3.new(0, 0, 0)
button.TextSize = 14
button.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button.BorderSizePixel = 0
button.Position = UDim2.new(0, 22, 0, 53)

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 9)

local Text = Instance.new("TextLabel", window)
Text.Size = UDim2.new(0, 39, 0, 25)
Text.Text = "透视功能"
Text.TextColor3 = Color3.new(1, 1, 1)
Text.TextSize = 23
Text.Font = Enum.Font.GothamBold
Text.BackgroundTransparency = 1
Text.BorderSizePixel = 0
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.Position = UDim2.new(0, 22, 0, 82)

local Text2 = Instance.new("TextLabel", window)
Text2.Size = UDim2.new(0, 39, 0, 25)
Text2.Text = "基础控制"
Text2.TextColor3 = Color3.new(1, 1, 1)
Text2.TextSize = 23
Text2.Font = Enum.Font.GothamBold
Text2.BackgroundTransparency = 1
Text2.BorderSizePixel = 0
Text2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text2.Position = UDim2.new(0, 22, 0, 22)

local button2 = Instance.new("TextButton", window)
button2.Size = UDim2.new(0, 140, 0, 25)
button2.Text = "资源透视(关)"
button2.TextColor3 = Color3.new(0, 0, 0)
button2.TextSize = 14
button2.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button2.BorderSizePixel = 0
button2.Position = UDim2.new(0, 22, 0, 113)

local button2Corner = Instance.new("UICorner", button2)
button2Corner.CornerRadius = UDim.new(0, 9)

local isDragging = false
local dragStartPos
local windowStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        windowStartPos = window.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        window.Position = UDim2.new(
            windowStartPos.X.Scale,
            windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale,
            windowStartPos.Y.Offset + delta.Y
        )
    end
end)

button.MouseButton1Click:Connect(function()
    -- 定义需要删除的模型名称和对应的通知信息
    local modelsToDelete = {
        {
            name = "__SnarePhysical",
            notification = "已删除 %d 个捕兽夹"
        },
        {
            name = "__ClaymorePhysical",
            notification = "已删除 %d 个阔剑地雷"
        },
        {
            name = "Landmine",
            notification = "已删除 %d 个地雷"
        }
    }
    -- 删除模型并发送通知
    local function deleteModelsAndNotify()
        local deletedCounts = {} -- 存储每种模型的删除数量
        -- 初始化计数器
        for _, modelInfo in ipairs(modelsToDelete) do
            deletedCounts[modelInfo.name] = 0
        end
        -- 遍历 Workspace 一次
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") then
                for _, modelInfo in ipairs(modelsToDelete) do
                    if model.Name == modelInfo.name then
                        model:Destroy()
                        deletedCounts[modelInfo.name] = deletedCounts[modelInfo.name] + 1
                        break -- 找到匹配后跳出内层循环
                    end
                end
            end
        end
        -- 发送通知
        for _, modelInfo in ipairs(modelsToDelete) do
            local count = deletedCounts[modelInfo.name]
            if count > 0 then
                CreateNotification("Project Transfur", string.format(modelInfo.notification, count), 10, true)
            end
        end
    end
    -- 调用函数
    deleteModelsAndNotify()
end)

button2.MouseButton1Click:Connect(function()
    toggleFeature(not _G.ChronixPTESP)
    button2.Text = _G.ChronixPTESP and "资源透视(开)" or "资源透视(关)"
end)

min.MouseButton1Click:Connect(function()
    _G.ChronixGraceMenuisMin = not _G.ChronixGraceMenuisMin
    if _G.ChronixGraceMenuisMin then
        min.Text = "↓"
        Text.Parent = nil
        Text2.Parent = nil
        button.Parent = nil
        button2.Parent = nil
        window.Size = UDim2.new(0, 190, 0, 20)
    else
        min.Text = "↑"
        Text.Parent = window
        Text2.Parent = window
        button.Parent = window
        button2.Parent = window
        window.Size = UDim2.new(0, 190, 0, 157)
    end
end)

close.MouseButton1Click:Connect(function()
    toggleFeature(false)
    Gui:Destroy()
end)

CreateNotification("提示", "Project Transfur 辅助已启动\n作者: Chronix", 5, true)