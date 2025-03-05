if not game:IsLoaded() then
	game.Loaded:Wait()
end

if _G.ChronixHubisLoaded then
    warn("⛔ ChronixHub Already loaded! Please do not repeat the execution.")
    return
end

_G.ChronixHubisLoaded = true

local bb = game:service'VirtualUser'
local cc = game:service'Players'.LocalPlayer.Idled:connect(function()bb:CaptureController()bb:ClickButton2(Vector2.new())end)

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


local function CreateTextBox(text, textSize, size, position)
    local textBox = Instance.new("TextBox")
    textBox.Size = size -- 输入框大小
    textBox.Position = position -- 输入框位置
    textBox.BackgroundColor3 = Color3.fromRGB(100, 100, 170)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.TextSize = textSize
    textBox.Font = Enum.Font.SourceSans
    textBox.Text = text
    textBox.Parent = contentArea
    return textBox
end

local function CreateList(size, position)
    -- 创建滚动列表
    local list = Instance.new("ScrollingFrame")
    list.Size = size
    list.Position = position
    list.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 5
    list.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 170) -- 浅墨蓝色
    list.Parent = contentArea

    -- 创建 UIListLayout 用于自动排列按钮
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5) -- 按钮间距
    uiListLayout.Parent = list

    -- 更新滚动区域大小
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        list.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    -- 定义 add 方法
    local function addButton(text, callback)
        -- 创建按钮
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(1, -10, 0, 30) -- 宽度减去 10 以留出边距
        button.Position = UDim2.new(0, 5, 0, 0) -- 左边距 5
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = list

        -- 绑定点击事件
        if callback then
            button.MouseButton1Click:Connect(function()
                uiclicker:Play()
                callback(button)
            end)
        end
    end

    -- 返回包含 add 方法的表
    return {
        add = addButton
    }
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
            callback(button)
        end
    end)
    return button
end

-- 创建滑块的函数
local function createSlider(size, position, minValue, maxValue, defaultValue, callback)
    -- 创建滑块容器
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = size
    sliderContainer.Position = position
    sliderContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 滑块背景色
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = contentArea

    -- 创建滑块的滑动条
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 1, 0) -- 滑动条高度为 5
    sliderTrack.Position = UDim2.new(0, 0, 0, 0) -- 垂直居中
    sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 滑动条颜色
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer

    local sliderTrack2 = Instance.new("Frame")
    sliderTrack2.Size = UDim2.new(1.1, 0, 1, 0) -- 滑动条高度为 5
    sliderTrack2.Position = UDim2.new(0, 0, 0, 0) -- 垂直居中
    sliderTrack2.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 滑动条颜色
    sliderTrack2.BorderSizePixel = 0
    sliderTrack2.Parent = sliderContainer

    -- 创建滑块的滑动按钮
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0.1, 0, 1, 0)
    sliderButton.Position = UDim2.new(0, 0, 0, 0) -- 初始位置在左侧
    sliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 170) -- 按钮颜色
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderContainer

    -- 滑块的当前值
    local currentValue = defaultValue or minValue

    -- 更新滑块按钮的位置和值显示
    local function updateSlider(value)
        -- 限制值在 minValue 和 maxValue 之间
        value = math.clamp(value, minValue, maxValue)

        -- 计算滑块按钮的位置
        local sliderWidth = sliderTrack.AbsoluteSize.X
        local normalizedValue = (value - minValue) / (maxValue - minValue)
        local buttonOffset = normalizedValue * sliderWidth

        -- 更新按钮位置
        sliderButton.Position = UDim2.new(0, buttonOffset, 0.5, -10)

        -- 更新值
        currentValue = value

        -- 调用回调函数
        if callback then
            callback(value)
        end
    end

    -- 绑定滑块按钮的拖动事件
    local isDragging = false
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            -- 计算滑块的值
            local mousePos = input.Position.X
            local sliderPos = sliderTrack.AbsolutePosition.X
            local sliderWidth = sliderTrack.AbsoluteSize.X
            local normalizedValue = (mousePos - sliderPos) / sliderWidth
            local value = minValue + normalizedValue * (maxValue - minValue)

            -- 更新滑块
            updateSlider(value)
        end
    end)

    -- 初始化滑块
    updateSlider(currentValue)

    -- 返回滑块对象
    return {
        getValue = function()
            return currentValue
        end,
        setValue = function(value)
            updateSlider(value)
        end
    }
end

local function createCheckbox(size, position, defaultState, callback)
    local checkboxContainer = Instance.new("TextButton")
    checkboxContainer.Size = size
    checkboxContainer.Position = position
    checkboxContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    checkboxContainer.BorderSizePixel = 0
    checkboxContainer.Text = ""
    checkboxContainer.AutoButtonColor = false
    checkboxContainer.Parent = contentArea

    local checkIcon = Instance.new("ImageLabel")
    checkIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
    checkIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = "rbxassetid://11772672161"
    checkIcon.Parent = checkboxContainer

    local isChecked = defaultState or false

    local function updateCheckbox()
        checkIcon.Image = isChecked and "rbxassetid://11772695039" or "rbxassetid://11772672161"
        if callback then
            callback(isChecked)
        end
    end

    checkboxContainer.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        updateCheckbox()
    end)

    updateCheckbox()

    return {
        getState = function()
            return isChecked
        end,
        setState = function(state)
            isChecked = state
            updateCheckbox()
        end
    }
end

local data = {
    tools = {
        nightvision = false,
        noclip = false,
        infjump = false,
        airwalk = false,
        playeresp = false,
        antifall = false,
        antidead = false,
        fly = false,
        flyspeeds = 1,
        floorY = nil
    },
    playercontrol = {
        lockspeed = false,
        lockjump = false,
        lockmaxhealth = false,
        lockhealth = false,
        lockgravity = false
    },
    playerattr = {
        speed = LocalPlayer.Character.Humanoid.WalkSpeed,
        jump = LocalPlayer.Character.Humanoid.JumpPower,
        maxhealth = LocalPlayer.Character.Humanoid.MaxHealth,
        health = LocalPlayer.Character.Humanoid.Health,
        gravity = game.Workspace.Gravity
    },
    pt = {
        esp = false,
        modelsToHighlight = {
            {
                name = "__BasicSmallSafe",
                text = "小保险箱",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "__BasicLargeSafe",
                text = "大保险箱",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "__LargeGoldenSafe",
                text = "金保险箱",
                color = Color3.fromRGB(255, 215, 0), -- 金色
                enabled = false
            },
            {
                name = "Surplus Crate",
                text = "武器盒",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "Military Crate",
                text = "武器盒",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "SupplyDrop",
                text = "空投",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false -- 默认不高亮
            },
            {
                name = "Bot",
                text = "人机",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            }
        },
        highlights = {},
        labels = {}
    }
}

-- 定义白天和黑夜的光照属性
local daySettings = {
    ClockTime = 14, -- 白天时间（14:00）
    GeographicLatitude = 41.73, -- 纬度（影响太阳高度）
    -- Ambient = Color3.new(0.5, 0.5, 0.5), -- 环境光
    -- OutdoorAmbient = Color3.new(0.5, 0.5, 0.5), -- 室外环境光
    -- Brightness = 2, -- 亮度
    -- FogColor = Color3.new(0.8, 0.8, 0.8), -- 雾颜色
    -- FogEnd = 1000 -- 雾结束距离
}

local nightSettings = {
    ClockTime = 2, -- 黑夜时间（02:00）
    GeographicLatitude = 41.73, -- 纬度
    -- Ambient = Color3.new(0.1, 0.1, 0.1), -- 环境光
    -- OutdoorAmbient = Color3.new(0.1, 0.1, 0.1), -- 室外环境光
    -- Brightness = 0.2, -- 亮度
    -- FogColor = Color3.new(0.1, 0.1, 0.1), -- 雾颜色
    -- FogEnd = 500 -- 雾结束距离
}

-- 切换为白天
local function setDay()
    for property, value in pairs(daySettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

-- 切换为黑夜
local function setNight()
    for property, value in pairs(nightSettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

local floorPart = nil

-- 创建地板
local function createFloor()
    if floorPart then return end -- 如果地板已存在，则不重复创建
    
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 创建地板
    floorPart = Instance.new("Part")
    floorPart.Size = Vector3.new(10, 1, 10) -- 地板大小
    floorPart.Transparency = 1 -- 完全透明
    floorPart.Anchored = true -- 固定位置
    floorPart.CanCollide = true -- 允许碰撞
    floorPart.Parent = workspace

    -- 添加发光特效
    local glow = Instance.new("SurfaceGui", floorPart)
    glow.Face = Enum.NormalId.Top
    local frame = Instance.new("Frame", glow)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 1, 0) -- 白色发光
    frame.BackgroundTransparency = 0.4 -- 半透明
    frame.BorderSizePixel = 0

    -- 记录当前地板的 Y 轴高度
    data.tools.floorY = HumanoidRootPart.Position.Y - HumanoidRootPart.Size.Y / 2 - floorPart.Size.Y / 2 - 1.8
    floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, data.tools.floorY, HumanoidRootPart.Position.Z)
end

-- 删除地板
local function destroyFloor()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
        data.tools.floorY = nil
    end
end

-- 切换空中行走状态
local function toggleAirWalk()
    data.tools.airwalk = not data.tools.airwalk
    if data.tools.airwalk then
        createFloor() -- 启用时创建地板
    else
        destroyFloor() -- 禁用时删除地板
    end
end

-- 更新地板位置
RunService.Heartbeat:Connect(function()
    if data.tools.airwalk and floorPart and data.tools.floorY then
        -- 将地板的 X 和 Z 轴与玩家对齐，Y 轴固定
        floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, data.tools.floorY, HumanoidRootPart.Position.Z)
    end
end)

-- 监听状态变化
Humanoid.StateChanged:Connect(function(oldState, newState)
    if data.tools.antifall then
        if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- 强制恢复站立状态
            CreateNotification("提示", "检测到被击倒，已恢复站立状态", 5, true)
        end
    end
end)

-- 监听玩家死亡事件
local function onCharacterDied()
    if data.tools.airwalk then
        data.tools.airwalk = false
        destroyFloor()
    end
end

-- 监听角色变化
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 重新绑定死亡事件
    Humanoid.Died:Connect(onCharacterDied)
end)

-- 初始绑定死亡事件
Humanoid.Died:Connect(onCharacterDied)

-- 存储高亮和用户名标签
local highlights = {}
local usernameLabels = {}

-- 为玩家添加高亮
local function addHighlight(player)
    if player == LocalPlayer then return end -- 排除自己和未启用时

    local character = player.Character
    if character then
        -- 创建 Highlight 对象
        local phighlight = Instance.new("Highlight")
        phighlight.Adornee = character
        phighlight.FillColor = Color3.new(1, 0, 0)
        phighlight.FillTransparency = 0.8
        phighlight.OutlineColor = Color3.new(1, 0, 0)
        phighlight.OutlineTransparency = 0
        phighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- 隔墙显示
        phighlight.Parent = character

        -- 如果只描边，则隐藏整体覆盖颜色
        if onlyOutline then
            phighlight.FillTransparency = 1
        end

        -- 存储高亮对象
        highlights[player] = phighlight
    end
end

-- 为玩家添加用户名标签
local function addUsernameLabel(player)
    if player == LocalPlayer then return end -- 排除自己和未启用时

    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            -- 创建 BillboardGui
            local pbillboard = Instance.new("BillboardGui")
            pbillboard.Adornee = head
            pbillboard.Size = UDim2.new(0, 200, 0, 50)
            pbillboard.StudsOffset = Vector3.new(0, 3, 0) -- 在头顶上方显示
            pbillboard.AlwaysOnTop = true
            pbillboard.Parent = head

            -- 创建 TextLabel
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            if player.DisplayName == player.Name then label.Text = player.DisplayName else label.Text = player.DisplayName .. " (@" .. player.Name .. ")" end -- 显示用户名
            label.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
            label.BackgroundTransparency = 1 -- 透明背景
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 18
            label.Parent = pbillboard

            -- 存储用户名标签
            usernameLabels[player] = pbillboard
        end
    end
end

-- 移除玩家的高亮和用户名标签
local function removePlayerEffects(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
    if usernameLabels[player] then
        usernameLabels[player]:Destroy()
        usernameLabels[player] = nil
    end
end

-- 监听玩家加入
Players.PlayerAdded:Connect(function(player)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    if data.tools.playeresp then
        for _, player in ipairs(Players:GetPlayers()) do
            removePlayerEffects(player)
            addHighlight(player)
            addUsernameLabel(player)
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        removePlayerEffects(player)
                        addHighlight(player)
                        addUsernameLabel(player)
                    end)
                end
            end
        end
        -- 监听玩家角色加载
        player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                removePlayerEffects(player)
                addHighlight(player)
                addUsernameLabel(player)
            end)
        end)
    end
end)

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
    data.pt.highlights[model] = highlight
    data.pt.labels[model] = textLabel
end

-- 更新高亮和文字标签
local function updateHighlightAndLabel(model)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if model.Name == modelInfo.name then
            if modelInfo.enabled then
                data.pt.highlights[model].FillColor = modelInfo.color
                data.pt.labels[model].Text = modelInfo.text
                data.pt.highlights[model].Enabled = true -- 启用高亮
            else
                data.pt.highlights[model].Enabled = false -- 禁用高亮
                data.pt.labels[model].Text = "" -- 清空文字
            end
            break
        end
    end
end

-- 删除高亮和文字标签
local function removeHighlightAndLabel(model)
    if data.pt.highlights[model] then
        data.pt.highlights[model]:Destroy()
        data.pt.highlights[model] = nil
    end
    if data.pt.labels[model] then
        data.pt.labels[model].Parent:Destroy()
        data.pt.labels[model] = nil
    end
end

-- 动态更新高亮状态
local function updateHighlights()
    for model in pairs(data.pt.highlights) do
        updateHighlightAndLabel(model)
    end
end

-- 开关功能
local function toggleFeature(offon)
    if offon then
        data.pt.esp = true
        -- 遍历 Workspace，查找需要高亮的模型
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") then
                for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
                    if model.Name == modelInfo.name then
                        if not data.pt.highlights[model] then
                            createHighlightAndLabel(model)
                        end
                        updateHighlightAndLabel(model)
                        break
                    end
                end
            end
        end
    else
        data.pt.esp = false
        -- 删除所有高亮和文字标签
        for model in pairs(data.pt.highlights) do
            removeHighlightAndLabel(model)
        end
    end
end

-- 动态添加新模型到高亮列表
local function addModelToHighlight(name, text, color, enabled)
    table.insert(data.pt.modelsToHighlight, {
        name = name,
        text = text,
        color = color,
        enabled = enabled
    })

    -- 如果功能已开启，立即应用高亮
    if data.pt.esp then
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == name then
                if not data.pt.highlights[model] then
                    createHighlightAndLabel(model)
                end
                updateHighlightAndLabel(model)
                break
            end
        end
    end
end

-- 切换某个模型的高亮状态
local function toggleModelHighlight(name)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            modelInfo.enabled = not modelInfo.enabled -- 切换高亮状态
            break
        end
    end

    -- 如果功能已开启，立即更新高亮
    if data.pt.esp then
        for model in pairs(data.pt.highlights) do
            if model.Name == name then
                updateHighlightAndLabel(model)
                break
            end
        end
        toggleFeature(false)
        toggleFeature(true)
    end
end

-- 读取某个模型的高亮状态
local function getModelHighlight(name)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            return modelInfo.enabled
        end
    end
end

-- 动态修改模型的高亮状态
local function setModelHighlightEnabled(name, enabled)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            modelInfo.enabled = enabled
            break
        end
    end

    -- 如果功能已开启，立即更新高亮
    if data.pt.esp then
        for model in pairs(data.pt.highlights) do
            if model.Name == name then
                updateHighlightAndLabel(model)
                break
            end
        end
    end
end

local function togglefly()
	if data.tools.fly == true then
		data.tools.fly = false
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		data.tools.fly = true
		for i = 1, data.tools.flyspeeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat	
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end
	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0
		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if data.tools.fly == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while data.tools.fly == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0
		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if enable == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while enable == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	end
end

local gsr = game:GetService("RunService").Stepped:Connect(function()
    if data.playercontrol.lockspeed then LocalPlayer.Character.Humanoid.WalkSpeed = data.playerattr.speed end
    if data.playercontrol.lockjump then LocalPlayer.Character.Humanoid.JumpPower = data.playerattr.jump end
    if data.playercontrol.lockmaxhealth then LocalPlayer.Character.Humanoid.MaxHealth = data.playerattr.maxhealth end
    if data.playercontrol.lockhealth then LocalPlayer.Character.Humanoid.Health = data.playerattr.health end
    if data.playercontrol.lockgravity then game.Workspace.Gravity = data.playerattr.gravity end
    if data.tools.antidead then Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
end)

-- 添加菜单内容
local function AddMenuContent(category)
    -- 清空内容区域
    for _, child in ipairs(contentArea:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    -- 根据分类添加内容
    if category == "脚本中心" then
        local scriptList = CreateList(UDim2.new(1, 0, 1, 0), UDim2.new(0.01, 0, 0.01, 0))
        scriptList.add("飞行V4", function(button)
            CreateNotification("提示", "正在启动 飞行 V4 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/FlyV4.lua"))()
            CreateNotification("提示", "飞行 V4 已经成功启动!", 10, true)
        end)
        scriptList.add("通用自瞄", function(button)
            CreateNotification("提示", "正在启动 通用自瞄 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/Zimiao.lua"))()
            CreateNotification("提示", "通用自瞄 已经成功启动!", 10, true)
        end)
        scriptList.add("Doors扫描器", function(button)
            CreateNotification("提示", "正在启动 Doors扫描器 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/DoorsNVC3000.lua"))()
            CreateNotification("提示", "Doors扫描器 已经成功启动!", 10, true)
        end)
        scriptList.add("通用ESP", function(button)
            CreateNotification("提示", "正在启动 通用ESP 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/ESP.lua"))()
            CreateNotification("提示", "通用ESP 已经成功启动!", 10, true)
        end)
        scriptList.add("冬凌中心", function(button)
            CreateNotification("提示", "正在启动 冬凌中心 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/DongLingLobby.lua"))()
            CreateNotification("提示", "冬凌中心 已经成功启动!", 10, true)
        end)
        scriptList.add("OldMSPaint", function(button)
            CreateNotification("提示", "正在启动 OldMSPaint 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/mspaint/main/main.lua"))()
            CreateNotification("提示", "OldMSPaint 已经成功启动!", 10, true)
        end)
        scriptList.add("玩家控制", function(button)
            CreateNotification("提示", "正在启动 玩家控制 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/PlayerControl.lua"))()
            CreateNotification("提示", "玩家控制 已经成功启动!", 10, true)
        end)
        scriptList.add("情云中心", function(button)
            CreateNotification("提示", "正在启动 情云中心 脚本，请耐心等待.", 10, true)
            loadstring(utf8.char((function() return table.unpack({108,111,97,100,115,116,114,105,110,103,40,103,97,109,101,58,72,116,116,112,71,101,116,40,34,104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,67,104,105,110,97,81,89,47,45,47,109,97,105,110,47,37,69,54,37,56,51,37,56,53,37,69,52,37,66,65,37,57,49,34,41,41,40,41})end)()))()
            CreateNotification("提示", "情云中心 已经成功启动!", 10, true)
        end)
        scriptList.add("Dex", function(button)
            CreateNotification("提示", "正在启动 DEX 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
            CreateNotification("提示", "DEX 已经成功启动!", 10, true)
        end)
    elseif category == "工具" then
        local toolList = CreateList(UDim2.new(1, 0, 1, 0), UDim2.new(0.01, 0, 0.01, 0))
        toolList.add("回满血", function(button)
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
        end)
        toolList.add("自杀", function(button)
            LocalPlayer.Character.Humanoid.Health = 0
        end)
        toolList.add("获得点击传送工具", function(button)
            mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "手持点击传送" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
        end)
        toolList.add(data.tools.fly and "飞行(开)" or "飞行(关)", function(button)
            togglefly()
            button.Text = data.tools.fly and "飞行(开)" or "飞行(关)"
        end)
        toolList.add(data.tools.nightvision and "夜视(开)" or "夜视(关)", function(button)
            data.tools.nightvision = not data.tools.nightvision
            game.Lighting.Ambient = data.tools.nightvision and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
            button.Text = data.tools.nightvision and "夜视(开)" or "夜视(关)"
        end)
        toolList.add(data.tools.noclip and "穿墙(开)" or "穿墙(关)", function(button)
            data.tools.noclip = not data.tools.noclip
            button.Text = data.tools.noclip and "穿墙(开)" or "穿墙(关)"
            Stepped = game:GetService("RunService").Stepped:Connect(function()
	            if not data.tools.noclip == false then
		            for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end end end end
	            else
                    for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = true
                                end end end end
		        Stepped:Disconnect()
	            end
            end)
        end)
        toolList.add(data.tools.infjump and "连跳(开)" or "连跳(关)", function(button)
            data.tools.infjump = not data.tools.infjump
            button.Text = data.tools.infjump and "连跳(开)" or "连跳(关)"
            JR = game:GetService("UserInputService").JumpRequest:Connect(function()
                if not data.tools.infjump then
                    JR:Disconnect()
                end
                if data.tools.infjump then
                    local c = LocalPlayer.Character
                    if c and c.Parent then
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:ChangeState("Jumping")
                        end
                    end
                end
            end)
        end)
        toolList.add(data.tools.playeresp and "玩家透视(开)" or "玩家透视(关)", function(button)
            data.tools.playeresp = not data.tools.playeresp
            button.Text = data.tools.playeresp and "玩家透视(开)" or "玩家透视(关)"
            if not data.tools.playeresp then
                -- 关闭功能时移除所有高亮和用户名标签
                for _, player in ipairs(Players:GetPlayers()) do
                    removePlayerEffects(player)
                end
                for player, highlight in pairs(highlights) do
                    phighlight:Destroy()
                end
                for player, label in pairs(usernameLabels) do
                    pbillboard:Destroy()
                end
                highlights = {}
                usernameLabels = {}
            else
                for _, player in ipairs(Players:GetPlayers()) do
                    addHighlight(player)
                    addUsernameLabel(player)
                end
            end
        end)
        toolList.add(data.tools.airwalk and "空中移动(开)" or "空中移动(关)", function(button)
            toggleAirWalk()
            button.Text = data.tools.airwalkn and "空中移动(开)" or "空中移动(关)"
        end)
        toolList.add(data.tools.antifall and "防击倒(开)" or "防击倒(关)", function(button)
            data.tools.antifall = not data.tools.antifall
            button.Text = data.tools.antifall and "防击倒(开)" or "防击倒(关)"
        end)
        toolList.add(data.tools.antidead and "防死亡(开)" or "防死亡(关)", function(button)
            data.tools.antidead = not data.tools.antidead
            button.Text = data.tools.antidead and "防死亡(开)" or "防死亡(关)"
        end)
        toolList.add("切换时间为白天", function(button)
            setDay()
        end)
        toolList.add("切换时间为黑夜", function(button)
            setNight()
        end)
    elseif category == "基础" then
        CreateLabel("移速", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.05, 0))
        local speedtb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.WalkSpeed), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.04, 0))
        local slider1 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.04, 0),
            0, -- minValue
            100, -- maxValue
            LocalPlayer.Character.Humanoid.WalkSpeed, -- defaultValue
            function(value) -- callback
                speedtb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.WalkSpeed = value
                data.playerattr.speed = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.04, 0), function()
            s = tonumber(speedtb.Text)
            LocalPlayer.Character.Humanoid.WalkSpeed = s and speedtb.Text or "18"
            slider1.setValue(s and speedtb.Text or 18)
            data.playerattr.speed = s and speedtb.Text or 18
        end)
        
        createCheckbox(UDim2.new(0.06, 0, 0.09, 0), UDim2.new(0.92, 0, 0.031, 0), data.playercontrol.lockspeed, function(isChecked)
            data.playercontrol.lockspeed = isChecked
        end)

        CreateLabel("跳跃", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.15, 0))
        local jumptb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.JumpPower), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.14, 0))
        local slider2 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.14, 0),
            0, -- minValue
            100, -- maxValue
            LocalPlayer.Character.Humanoid.JumpPower, -- defaultValue
            function(value) -- callback
                jumptb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.JumpPower = value
                data.playerattr.jump = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.14, 0), function()
            m = tonumber(jumptb.Text)
            LocalPlayer.Character.Humanoid.JumpPower = m and jumptb.Text or 50
            slider2.setValue(m and jumptb.Text or 50)
            data.playerattr.jump = m and jumptb.Text or 50
        end)
        
        createCheckbox(UDim2.new(0.06, 0, 0.09, 0), UDim2.new(0.92, 0, 0.131, 0), data.playercontrol.lockjump, function(isChecked)
            data.playercontrol.lockjump = isChecked
        end)

        CreateLabel("最大血量", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.25, 0))
        local mhtb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.MaxHealth), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.24, 0))
        local slider3 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.24, 0),
            1, -- minValue
            1000, -- maxValue
            LocalPlayer.Character.Humanoid.MaxHealth, -- defaultValue
            function(value) -- callback
                mhtb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.MaxHealth = value
                data.playerattr.maxhealth = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.24, 0), function()
            k = tonumber(mhtb.Text)
            LocalPlayer.Character.Humanoid.MaxHealth = k and mhtb.Text or 100
            slider3.setValue(k and mhtb.Text or 100)
            data.playerattr.maxhealth = k and mhtb.Text or 100
        end)
        
        createCheckbox(UDim2.new(0.06, 0, 0.09, 0), UDim2.new(0.92, 0, 0.231, 0), data.playercontrol.lockmaxhealth, function(isChecked)
            data.playercontrol.lockmaxhealth = isChecked
        end)

        CreateLabel("血量", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.35, 0))
        local htb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.Health), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.34, 0))
        local slider4 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.34, 0),
            0, -- minValue
            tonumber(mhtb.Text), -- maxValue
            LocalPlayer.Character.Humanoid.Health, -- defaultValue
            function(value) -- callback
                htb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.Health = value
                data.playerattr.health = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.34, 0), function()
            p = tonumber(htb.Text)
            LocalPlayer.Character.Humanoid.Health = p and htb.Text or 100
            slider4.setValue(p and htb.Text or 100)
            data.playerattr.health = p and htb.Text or 100
        end)
        
        createCheckbox(UDim2.new(0.06, 0, 0.09, 0), UDim2.new(0.92, 0, 0.331, 0), data.playercontrol.lockhealth, function(isChecked)
            data.playercontrol.lockhealth = isChecked
        end)

        CreateLabel("重力", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.45, 0))
        local gtb = CreateTextBox(string.format("%.2f", game.Workspace.Gravity), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.44, 0))
        local slider5 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.44, 0),
            0, -- minValue
            500, -- maxValue
            game.Workspace.Gravity, -- defaultValue
            function(value) -- callback
                gtb.Text = string.format("%.2f", value)
                game.Workspace.Gravity = value
                data.playerattr.gravity = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.44, 0), function()
            z = tonumber(gtb.Text)
            game.Workspace.Gravity = z and gtb.Text or 196.2
            slider5.setValue(z and gtb.Text or 196.2)
            data.playerattr.gravity = z and gtb.Text or 196.2
        end)
        
        createCheckbox(UDim2.new(0.06, 0, 0.09, 0), UDim2.new(0.92, 0, 0.431, 0), data.playercontrol.lockgravity, function(isChecked)
            data.playercontrol.lockgravity = isChecked
        end)
    elseif category == "Project Transfur" then
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
        CreateButton(data.pt.esp and "透视(开)" or "透视(关)", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.31, 0, 0.1, 0), function(button)
            toggleFeature(not data.pt.esp)
            button.Text = data.pt.esp and "透视(开)" or "透视(关)"
        end)
        CreateLabel("透视列表", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.23, 0))
        local espList = CreateList(UDim2.new(0, 100, 0.645, 0), UDim2.new(0.30, 0, 0.3, 0))
        espList.add(getModelHighlight("Bot") and "Bot兽(开)" or "Bot兽(关)", function(button)
            toggleModelHighlight("Bot")
            button.Text = getModelHighlight("Bot") and "Bot兽(开)" or "Bot兽(关)"
        end)
        espList.add(getModelHighlight("__BasicSmallSafe") and "小保险箱(开)" or "小保险箱(关)", function(button)
            toggleModelHighlight("__BasicSmallSafe")
            button.Text = getModelHighlight("__BasicSmallSafe") and "小保险箱(开)" or "小保险箱(关)"
        end)
        espList.add(getModelHighlight("__BasicLargeSafe") and "大保险箱(开)" or "大保险箱(关)", function(button)
            toggleModelHighlight("__BasicLargeSafe")
            button.Text = getModelHighlight("__BasicLargeSafe") and "大保险箱(开)" or "大保险箱(关)"
        end)
        espList.add(getModelHighlight("__LargeGoldenSafe") and "金保险箱(开)" or "金保险箱(关)", function(button)
            toggleModelHighlight("__LargeGoldenSafe")
            button.Text = getModelHighlight("__LargeGoldenSafe") and "金保险箱(开)" or "金保险箱(关)"
        end)
        espList.add(getModelHighlight("Surplus Crate") and "武器盒(开)" or "武器盒(关)", function(button)
            toggleModelHighlight("Surplus Crate")
            toggleModelHighlight("Military Crate")
            button.Text = getModelHighlight("Military Crate") and "武器盒(开)" or "武器盒(关)"
        end)
        espList.add(getModelHighlight("SupplyDrop") and "空投(开)" or "空投(关)", function(button)
            toggleModelHighlight("SupplyDrop")
            button.Text = getModelHighlight("SupplyDrop") and "空投(开)" or "空投(关)"
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
        uiclicker:Play()
        AddMenuContent(menutext) -- 切换菜单内容
    end)
end

-- 添加功能列表
addMenu("基础")
addMenu("工具")
addMenu("脚本中心")
if game.GameId == 2162087722 then addMenu("Project Transfur") end

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
    data.tools.noclip = false
    data.tools.infjump = false
    cc:Disconnect()
    gsr:Disconnect()
    toggleFeature(false)
    mainFrame:Destroy()
end

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    unloadchronixhub()
end)