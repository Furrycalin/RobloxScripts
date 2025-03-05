if not game:IsLoaded() then
	game.Loaded:Wait()
end

if _G.ChronixHubisLoaded then
    warn("⛔ ChronixHub Already loaded! Please do not repeat the execution.")
    return
end

_G.ChronixHubisLoaded = true

local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()bb:CaptureController()bb:ClickButton2(Vector2.new())end)

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 获取玩家信息
local playerName = LocalPlayer.Name -- 玩家名
local displayName = LocalPlayer.DisplayName -- 显示名
local userId = LocalPlayer.UserId -- 用户 ID
-- 获取玩家头像
local thumbnailType = Enum.ThumbnailType.HeadShot -- 头像类型
local thumbnailSize = Enum.ThumbnailSize.Size100x100 -- 头像尺寸
local success, thumbnailUrl = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbnailType, thumbnailSize)
end)
-- 获取玩家角色外观信息
local success, appearanceInfo = pcall(function()
    return Players:GetCharacterAppearanceInfoAsync(LocalPlayer.UserId)
end)

local function GetDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return "Mobile" -- 移动端
    elseif UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
        return "Desktop" -- 桌面端
    elseif UserInputService.GamepadEnabled then
        return "Console" -- 控制台
    else
        return "Unknown" -- 未知设备
    end
end

local notifications = {}

local uiclicker = Instance.new("Sound")
uiclicker.SoundId = "rbxassetid://535716488"
uiclicker.Volume = 0.3
uiclicker.Parent = SoundService

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://4590662766" -- 替换为你的音频ID
achievementSound.Volume = 0.5 -- 音量大小
achievementSound.Parent = SoundService

local Gui = Instance.new("ScreenGui")
Gui.Parent = game.CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

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

-- 创建主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300) -- 中等大小
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- 屏幕中央
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true -- 裁剪超出部分
mainFrame.Parent = Gui

-- 创建标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 36) -- 深墨蓝色
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- 标题栏拖动功能
local isDragging = false
local dragStartPos
local windowStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        windowStartPos = mainFrame.Position
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
        mainFrame.Position = UDim2.new(
            windowStartPos.X.Scale,
            windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale,
            windowStartPos.Y.Offset + delta.Y
        )
    end
end)

-- 标题栏文本
local titleText = Instance.new("TextLabel")
titleText.Text = "ChronixHub"
titleText.Size = UDim2.new(0, 100, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.TextColor3 = Color3.new(1, 1, 1) -- 白色
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 缩小按钮
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(0.98, -25, 0.5, 0)
minimizeButton.AnchorPoint = Vector2.new(1, 0.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.Parent = titleBar

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -5, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

-- 缩小功能
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 200, 0, 30)}):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 500, 0, 300)}):Play()
    end
end)

-- 创建内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- 左侧功能栏
local functionList = Instance.new("ScrollingFrame")
functionList.Size = UDim2.new(0, 100, 1, 0)
functionList.Position = UDim2.new(0, 0, 0, 0)
functionList.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
functionList.BorderSizePixel = 0
functionList.ScrollBarThickness = 5
functionList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 170) -- 浅墨蓝色
functionList.Parent = contentFrame

-- 右侧内容区域
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, 0)
contentArea.Position = UDim2.new(0, 100, 0, 0)
contentArea.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
contentArea.BorderSizePixel = 0
contentArea.Parent = contentFrame

local function CreateLabel(text, textsize, size, position)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1) -- 白色
    label.Font = Enum.Font.SourceSans
    label.TextSize = textsize
    label.Parent = contentArea
    return label
end

local function CreateButton(text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1) -- 白色
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = contentArea
    button.MouseButton1Click:Connect(function()
        uiclicker:Play()
        if callback then
            callback()
        end
    end)
    return button
end

local data = {
    pt = {
        esp = false
    }
}

-- 添加菜单内容
local function AddMenuContent(category)
    -- 清空内容区域
    for _, child in ipairs(contentArea:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    -- 根据分类添加内容
    if category == "Project Transfur" then
        CreateLabel("基础操作", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.01, 0, 0.03, 0))
        CreateButton("删除捕兽夹", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.1, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "__SnarePhysical" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个捕兽夹", 10, true)
        end)
        CreateButton("删除地雷", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.2, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "Landmine" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个地雷", 10, true)
        end)
        CreateButton("删除阔剑地雷", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.3, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "__ClaymorePhysical" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个阔剑地雷", 10, true)
        end)
        CreateLabel("透视功能", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.03, 0))
        CreateButton("透视(关)", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.31, 0, 0.1, 0), function()
            data.pt.esp = not data.pt.esp
            
        end)
    end
end

local function addMenu(menutext)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, #functionList:GetChildren() * 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
    button.BorderSizePixel = 0
    button.Text = menutext
    button.TextColor3 = Color3.new(1, 1, 1) -- 白色
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = functionList

    button.MouseButton1Click:Connect(function()
        AddMenuContent(menutext) -- 切换菜单内容
    end)
end

-- 添加功能列表
addMenu("Project Transfur")

-- 默认显示内容
AddMenuContent("")

-- 更新功能栏的滚动区域
functionList.CanvasSize = UDim2.new(0, 0, 0, #functionList:GetChildren() * 30)

if GetDeviceType() == "Desktop" then
    CreateNotification("欢迎使用，电脑用户" .. displayName, "ChronixHub v2已启动!\n反挂机系统已自动开启", 10, true)
elseif GetDeviceType() == "Mobile" then
    CreateNotification("欢迎使用，手机用户" .. displayName, "ChronixHub v2已启动!\n反挂机系统已自动开启", 10, true)
end

local function unloadchronixhub()
    _G.ChronixHubisLoaded = false
    mainFrame:Destroy()
end

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    unloadchronixhub()
end)