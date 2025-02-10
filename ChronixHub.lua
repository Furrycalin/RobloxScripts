local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

_G.ChronixHubisNightVisiton = false
_G.ChronixHubisChuanQiang = false

local SoundService = game:GetService("SoundService")

local notifications = {}

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
    textLabel.TextSize = 14
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

-- 配置常量
local CONFIG = {
    ARROW_SIZE = UDim2.new(0.5, 0, 0.03, 0), -- 更小的箭头
    ARROW_POSITION_HIDDEN = UDim2.new(0.5, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    ARROW_POSITION_VISIBLE = UDim2.new(0.5, 0, 0.97, 0), -- 贴近屏幕底部
    MENU_SIZE = UDim2.new(0.4, 0, 0.5, 0),
    MENU_POSITION_HIDDEN = UDim2.new(0.3, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    MENU_POSITION_VISIBLE = UDim2.new(0.3, 0, 0.4, 0), -- 点击箭头后弹出
    BACKGROUND_COLOR = Color3.fromRGB(40, 40, 40),
    BUTTON_COLOR = Color3.fromRGB(60, 60, 60),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    ARROW_TRANSPARENCY = 0.5, -- 半透明箭头
    TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Quad),
    CATEGORY_BUTTON_SIZE = UDim2.new(0.15, 0, 1, 0), -- 更大的分类按钮
    CATEGORY_BUTTON_SPACING = 10, -- 按钮之间的间距
    CATEGORY_BUTTON_INSET = 10 -- 按钮向内偏移
}

-- 创建箭头按钮
local arrowButton = Instance.new("TextButton")
arrowButton.Size = CONFIG.ARROW_SIZE
arrowButton.Position = CONFIG.ARROW_POSITION_HIDDEN
arrowButton.AnchorPoint = Vector2.new(0.5, 0.5)
arrowButton.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
arrowButton.BackgroundTransparency = CONFIG.ARROW_TRANSPARENCY
arrowButton.Text = "▲"
arrowButton.TextColor3 = CONFIG.TEXT_COLOR
arrowButton.TextSize = 14
arrowButton.ZIndex = 2
arrowButton.Parent = Gui

-- 创建菜单
local menuFrame = Instance.new("Frame")
menuFrame.Size = CONFIG.MENU_SIZE
menuFrame.Position = CONFIG.MENU_POSITION_HIDDEN
menuFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
menuFrame.ZIndex = 1
menuFrame.Parent = Gui

-- 圆角
local uiCorner = Instance.new("UICorner", menuFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- 创建菜单标题
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0.02, 0) -- 左上角
titleLabel.Text = "ChronixHub"
titleLabel.TextColor3 = CONFIG.TEXT_COLOR
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = menuFrame

-- 创建分类按钮区域
local categoryButtonsFrame = Instance.new("Frame")
categoryButtonsFrame.Size = UDim2.new(1, 0, 0.1, 0) -- 占菜单高度的 10%
categoryButtonsFrame.Position = UDim2.new(0, 0, 0.1, 0) -- 在标题下方
categoryButtonsFrame.BackgroundTransparency = 1 -- 透明背景
categoryButtonsFrame.Parent = menuFrame

-- 创建内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.8, 0) -- 占菜单高度的 80%
contentFrame.Position = UDim2.new(0, 0, 0.2, 0) -- 在分类按钮下方
contentFrame.BackgroundTransparency = 1 -- 透明背景
contentFrame.Parent = menuFrame

-- 添加菜单内容
local function AddMenuContent(category)
    -- 清空内容区域
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    -- 根据分类添加内容
    if category == "基础" then
        -- 添加“更改移速”标签
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 0.1, 0)
        label.Position = UDim2.new(0.1, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "更改移速"
        label.TextColor3 = CONFIG.TEXT_COLOR
        label.TextSize = 15
        label.Parent = contentFrame

        local label2 = Instance.new("TextLabel")
        label2.Size = UDim2.new(0.8, 0, 0.1, 0)
        label2.Position = UDim2.new(0.1, 0, 0.2, 0)
        label2.BackgroundTransparency = 1
        label2.Text = "更改跳跃高度"
        label2.TextColor3 = CONFIG.TEXT_COLOR
        label2.TextSize = 15
        label2.Parent = contentFrame

        local label3 = Instance.new("TextLabel")
        label3.Size = UDim2.new(0.8, 0, 0.1, 0)
        label3.Position = UDim2.new(0.1, 0, 0.4, 0)
        label3.BackgroundTransparency = 1
        label3.Text = "更改最大血量"
        label3.TextColor3 = CONFIG.TEXT_COLOR
        label3.TextSize = 15
        label3.Parent = contentFrame

        local label4 = Instance.new("TextLabel")
        label4.Size = UDim2.new(0.8, 0, 0.1, 0)
        label4.Position = UDim2.new(0.1, 0, 0.6, 0)
        label4.BackgroundTransparency = 1
        label4.Text = "更改当前血量"
        label4.TextColor3 = CONFIG.TEXT_COLOR
        label4.TextSize = 15
        label4.Parent = contentFrame

        local label5 = Instance.new("TextLabel")
        label5.Size = UDim2.new(0.8, 0, 0.1, 0)
        label5.Position = UDim2.new(0.1, 0, 0.8, 0)
        label5.BackgroundTransparency = 1
        label5.Text = "更改重力"
        label5.TextColor3 = CONFIG.TEXT_COLOR
        label5.TextSize = 15
        label5.Parent = contentFrame

        -- 添加按钮
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button.Position = UDim2.new(0.1, 0, 0.1, 0) -- 按钮位置
        button.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button.Text = "设置"
        button.TextColor3 = CONFIG.TEXT_COLOR
        button.TextSize = 14
        button.Parent = contentFrame

        local button2 = Instance.new("TextButton")
        button2.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button2.Position = UDim2.new(0.1, 0, 0.3, 0) -- 按钮位置
        button2.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button2.Text = "设置"
        button2.TextColor3 = CONFIG.TEXT_COLOR
        button2.TextSize = 14
        button2.Parent = contentFrame

        local button3 = Instance.new("TextButton")
        button3.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button3.Position = UDim2.new(0.1, 0, 0.5, 0) -- 按钮位置
        button3.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button3.Text = "设置"
        button3.TextColor3 = CONFIG.TEXT_COLOR
        button3.TextSize = 14
        button3.Parent = contentFrame

        local button4 = Instance.new("TextButton")
        button4.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button4.Position = UDim2.new(0.1, 0, 0.7, 0) -- 按钮位置
        button4.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button4.Text = "设置"
        button4.TextColor3 = CONFIG.TEXT_COLOR
        button4.TextSize = 14
        button4.Parent = contentFrame

        local button5 = Instance.new("TextButton")
        button5.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button5.Position = UDim2.new(0.1, 0, 0.9, 0) -- 按钮位置
        button5.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button5.Text = "设置"
        button5.TextColor3 = CONFIG.TEXT_COLOR
        button5.TextSize = 14
        button5.Parent = contentFrame

        -- 添加输入框
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.2, 0, 0.1, 0) -- 输入框大小
        textBox.Position = UDim2.new(0.35, 0, 0.1, 0) -- 输入框位置
        textBox.BackgroundColor3 = CONFIG.BUTTON_COLOR
        textBox.TextColor3 = CONFIG.TEXT_COLOR
        textBox.TextSize = 14
        textBox.Text = LocalPlayer.Character.Humanoid.WalkSpeed
        textBox.Parent = contentFrame

        local textBox2 = Instance.new("TextBox")
        textBox2.Size = UDim2.new(0.2, 0, 0.1, 0) -- 输入框大小
        textBox2.Position = UDim2.new(0.35, 0, 0.3, 0) -- 输入框位置
        textBox2.BackgroundColor3 = CONFIG.BUTTON_COLOR
        textBox2.TextColor3 = CONFIG.TEXT_COLOR
        textBox2.TextSize = 14
        textBox2.Text = LocalPlayer.Character.Humanoid.JumpPower
        textBox2.Parent = contentFrame

        local textBox3 = Instance.new("TextBox")
        textBox3.Size = UDim2.new(0.2, 0, 0.1, 0) -- 输入框大小
        textBox3.Position = UDim2.new(0.35, 0, 0.5, 0) -- 输入框位置
        textBox3.BackgroundColor3 = CONFIG.BUTTON_COLOR
        textBox3.TextColor3 = CONFIG.TEXT_COLOR
        textBox3.TextSize = 14
        textBox3.Text = LocalPlayer.Character.Humanoid.MaxHealth
        textBox3.Parent = contentFrame

        local textBox4 = Instance.new("TextBox")
        textBox4.Size = UDim2.new(0.2, 0, 0.1, 0) -- 输入框大小
        textBox4.Position = UDim2.new(0.35, 0, 0.7, 0) -- 输入框位置
        textBox4.BackgroundColor3 = CONFIG.BUTTON_COLOR
        textBox4.TextColor3 = CONFIG.TEXT_COLOR
        textBox4.TextSize = 14
        textBox4.Text = LocalPlayer.Character.Humanoid.Health
        textBox4.Parent = contentFrame

        local textBox5 = Instance.new("TextBox")
        textBox5.Size = UDim2.new(0.2, 0, 0.1, 0) -- 输入框大小
        textBox5.Position = UDim2.new(0.35, 0, 0.9, 0) -- 输入框位置
        textBox5.BackgroundColor3 = CONFIG.BUTTON_COLOR
        textBox5.TextColor3 = CONFIG.TEXT_COLOR
        textBox5.TextSize = 14
        textBox5.Text = game.Workspace.Gravity
        textBox5.Parent = contentFrame

        -- 添加滑轮
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.3, 0, 0.05, 0) -- 滑轮背景大小
        slider.Position = UDim2.new(0.6, 0, 0.125, 0) -- 滑轮背景位置
        slider.BackgroundColor3 = CONFIG.BUTTON_COLOR
        slider.Parent = contentFrame

        local slider2 = Instance.new("Frame")
        slider2.Size = UDim2.new(0.3, 0, 0.05, 0) -- 滑轮背景大小
        slider2.Position = UDim2.new(0.6, 0, 0.325, 0) -- 滑轮背景位置
        slider2.BackgroundColor3 = CONFIG.BUTTON_COLOR
        slider2.Parent = contentFrame

        local slider3 = Instance.new("Frame")
        slider3.Size = UDim2.new(0.3, 0, 0.05, 0) -- 滑轮背景大小
        slider3.Position = UDim2.new(0.6, 0, 0.525, 0) -- 滑轮背景位置
        slider3.BackgroundColor3 = CONFIG.BUTTON_COLOR
        slider3.Parent = contentFrame

        local slider4 = Instance.new("Frame")
        slider4.Size = UDim2.new(0.3, 0, 0.05, 0) -- 滑轮背景大小
        slider4.Position = UDim2.new(0.6, 0, 0.725, 0) -- 滑轮背景位置
        slider4.BackgroundColor3 = CONFIG.BUTTON_COLOR
        slider4.Parent = contentFrame

        local slider5 = Instance.new("Frame")
        slider5.Size = UDim2.new(0.3, 0, 0.05, 0) -- 滑轮背景大小
        slider5.Position = UDim2.new(0.6, 0, 0.925, 0) -- 滑轮背景位置
        slider5.BackgroundColor3 = CONFIG.BUTTON_COLOR
        slider5.Parent = contentFrame

        -- 滑轮滑块
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0.1, 0, 1, 0) -- 滑块大小
        sliderButton.Position = UDim2.new(LocalPlayer.Character.Humanoid.WalkSpeed / 100 or 0, 0, 0, 0) -- 滑块初始位置
        sliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton.Text = ""
        sliderButton.Parent = slider

        local sliderButton2 = Instance.new("TextButton")
        sliderButton2.Size = UDim2.new(0.1, 0, 1, 0) -- 滑块大小
        sliderButton2.Position = UDim2.new(LocalPlayer.Character.Humanoid.JumpPower / 100 or 0, 0, 0, 0) -- 滑块初始位置
        sliderButton2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton2.Text = ""
        sliderButton2.Parent = slider2

        local sliderButton3 = Instance.new("TextButton")
        sliderButton3.Size = UDim2.new(0.1, 0, 1, 0) -- 滑块大小
        sliderButton3.Position = UDim2.new(LocalPlayer.Character.Humanoid.MaxHealth / 1000 or 0, 0, 0, 0) -- 滑块初始位置
        sliderButton3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton3.Text = ""
        sliderButton3.Parent = slider3

        local sliderButton4 = Instance.new("TextButton")
        sliderButton4.Size = UDim2.new(0.1, 0, 1, 0) -- 滑块大小
        sliderButton4.Position = UDim2.new(LocalPlayer.Character.Humanoid.Health / textBox3.Text or 0, 0, 0, 0) -- 滑块初始位置
        sliderButton4.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton4.Text = ""
        sliderButton4.Parent = slider4

        local sliderButton5 = Instance.new("TextButton")
        sliderButton5.Size = UDim2.new(0.1, 0, 1, 0) -- 滑块大小
        sliderButton5.Position = UDim2.new(game.Workspace.Gravity / 500 or 0, 0, 0, 0) -- 滑块初始位置
        sliderButton5.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton5.Text = ""
        sliderButton5.Parent = slider5

        -- 滑轮逻辑
        local isDragging = false
        local function updateSlider(input)
            local sliderSize = slider.AbsoluteSize.X
            local sliderPosition = math.clamp((input.Position.X - slider.AbsolutePosition.X) / sliderSize, 0, 1)
            sliderButton.Position = UDim2.new(sliderPosition, 0, 0, 0)
            local speed = math.floor(sliderPosition * 100) -- 将滑轮值映射到 0-100
            textBox.Text = tostring(speed) -- 更新输入框的值
        end

        local isDragging2 = false
        local function updateSlider2(input)
            local sliderSize2 = slider2.AbsoluteSize.X
            local sliderPosition2 = math.clamp((input.Position.X - slider2.AbsolutePosition.X) / sliderSize2, 0, 1)
            sliderButton2.Position = UDim2.new(sliderPosition2, 0, 0, 0)
            local jump = math.floor(sliderPosition2 * 100) -- 将滑轮值映射到 0-100
            textBox2.Text = tostring(jump) -- 更新输入框的值
        end

        local isDragging3 = false
        local function updateSlider3(input)
            local sliderSize3 = slider3.AbsoluteSize.X
            local sliderPosition3 = math.clamp((input.Position.X - slider3.AbsolutePosition.X) / sliderSize3, 0, 1)
            sliderButton3.Position = UDim2.new(sliderPosition3, 0, 0, 0)
            local mh = math.floor(sliderPosition3 * 1000) -- 将滑轮值映射到 0-100
            textBox3.Text = tostring(mh) -- 更新输入框的值
        end

        local isDragging4 = false
        local function updateSlider4(input)
            local sliderSize4 = slider4.AbsoluteSize.X
            local sliderPosition4 = math.clamp((input.Position.X - slider4.AbsolutePosition.X) / sliderSize4, 0, 1)
            sliderButton4.Position = UDim2.new(sliderPosition4, 0, 0, 0)
            local heal = math.floor(sliderPosition4 * textBox3.Text) -- 将滑轮值映射到 0-100
            textBox4.Text = tostring(heal) -- 更新输入框的值
        end

        local isDragging5 = false
        local function updateSlider5(input)
            local sliderSize5 = slider5.AbsoluteSize.X
            local sliderPosition5 = math.clamp((input.Position.X - slider5.AbsolutePosition.X) / sliderSize5, 0, 1)
            sliderButton5.Position = UDim2.new(sliderPosition5, 0, 0, 0)
            local grav = math.floor(sliderPosition5 * 500) -- 将滑轮值映射到 0-100
            textBox5.Text = tostring(grav) -- 更新输入框的值
        end

        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
            end
        end)

        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        sliderButton2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging2 = true
            end
        end)

        sliderButton2.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging2 = false
            end
        end)

        sliderButton3.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging3 = true
            end
        end)

        sliderButton3.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging3 = false
            end
        end)

        sliderButton4.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging4 = true
            end
        end)

        sliderButton4.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging4 = false
            end
        end)

        sliderButton5.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging5 = true
            end
        end)

        sliderButton5.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging5 = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end

            if isDragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider2(input)
            end

            if isDragging3 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider3(input)
            end

            if isDragging4 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider4(input)
            end

            if isDragging5 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider5(input)
            end
        end)

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            local speed = tonumber(textBox.Text)
            if speed then
                LocalPlayer.Character.Humanoid.WalkSpeed = speed
            end
        end)

        button2.MouseButton1Click:Connect(function()
            local JumpPower = tonumber(textBox2.Text)
            if JumpPower then
                LocalPlayer.Character.Humanoid.JumpPower = JumpPower
            end
        end)

        button3.MouseButton1Click:Connect(function()
            local mh = tonumber(textBox3.Text)
            if mh then
                LocalPlayer.Character.Humanoid.MaxHealth = mh
            end
        end)

        button4.MouseButton1Click:Connect(function()
            local heal = tonumber(textBox4.Text)
            if heal then
                LocalPlayer.Character.Humanoid.Health = heal
            end
        end)

        button5.MouseButton1Click:Connect(function()
            local grav = tonumber(textBox5.Text)
            if grav then
                game.Workspace.Gravity = grav
            end
        end)

        -- 滑轮值改变时执行命令
        sliderButton:GetPropertyChangedSignal("Position"):Connect(function()
            local speed = tonumber(textBox.Text)
            if speed then
                LocalPlayer.Character.Humanoid.WalkSpeed = speed
            end
        end)

        sliderButton2:GetPropertyChangedSignal("Position"):Connect(function()
            local JumpPower = tonumber(textBox2.Text)
            if JumpPower then
                LocalPlayer.Character.Humanoid.JumpPower = JumpPower
            end
        end)

        sliderButton3:GetPropertyChangedSignal("Position"):Connect(function()
            local mh = tonumber(textBox3.Text)
            if mh then
                LocalPlayer.Character.Humanoid.MaxHealth = mh
            end
        end)

        sliderButton4:GetPropertyChangedSignal("Position"):Connect(function()
            local heal = tonumber(textBox4.Text)
            if heal then
                LocalPlayer.Character.Humanoid.Health = heal
            end
        end)

        sliderButton5:GetPropertyChangedSignal("Position"):Connect(function()
            local grav = tonumber(textBox5.Text)
            if grav then
                game.Workspace.Gravity = grav
            end
        end)
    elseif category == "工具" then
        -- 添加按钮
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button.Position = UDim2.new(0.1, 0, 0.1, 0) -- 按钮位置
        button.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button.Text = "回满血"
        button.TextColor3 = CONFIG.TEXT_COLOR
        button.TextSize = 14
        button.Parent = contentFrame

        local button2 = Instance.new("TextButton")
        button2.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button2.Position = UDim2.new(0.35, 0, 0.1, 0) -- 按钮位置
        button2.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button2.Text = "自杀"
        button2.TextColor3 = CONFIG.TEXT_COLOR
        button2.TextSize = 14
        button2.Parent = contentFrame

        local button3 = Instance.new("TextButton")
        button3.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button3.Position = UDim2.new(0.6, 0, 0.1, 0) -- 按钮位置
        button3.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button3.Text = _G.ChronixHubisNightVisiton and "夜视(开)" or "夜视(关)"
        button3.TextColor3 = CONFIG.TEXT_COLOR
        button3.TextSize = 14
        button3.Parent = contentFrame

        local button4 = Instance.new("TextButton")
        button4.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button4.Position = UDim2.new(0.1, 0, 0.3, 0) -- 按钮位置
        button4.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button4.Text = "点击传送工具"
        button4.TextColor3 = CONFIG.TEXT_COLOR
        button4.TextSize = 14
        button4.Parent = contentFrame

        local button5 = Instance.new("TextButton")
        button5.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button5.Position = UDim2.new(0.35, 0, 0.3, 0) -- 按钮位置
        button5.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button5.Text = _G.ChronixHubisChuanQiang and "穿墙(开)" or "穿墙(关)"
        button5.TextColor3 = CONFIG.TEXT_COLOR
        button5.TextSize = 14
        button5.Parent = contentFrame

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth 
        end)

        button2.MouseButton1Click:Connect(function()
            LocalPlayer.Character.Humanoid.Health = 0
            HumanDied = true
        end)

        button3.MouseButton1Click:Connect(function()
            if _G.ChronixHubisNightVisiton then
                game.Lighting.Ambient = Color3.new(0, 0, 0)
                button3.Text = "夜视(关)"
                _G.ChronixHubisNightVisiton = false
            else
                game.Lighting.Ambient = Color3.new(1, 1, 1)
                button3.Text = "夜视(开)"
                _G.ChronixHubisNightVisiton = true
            end
        end)

        button4.MouseButton1Click:Connect(function()
            mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "手持点击传送" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
        end)

        button5.MouseButton1Click:Connect(function()
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            _G.ChronixHubisChuanQiang = not _G.ChronixHubisChuanQiang
            button5.Text = _G.ChronixHubisChuanQiang and "穿墙(开)" or "穿墙(关)"
            Stepped = game:GetService("RunService").Stepped:Connect(function()
	            if not _G.ChronixHubisChuanQiang == false then
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
    elseif category == "脚本中心" then
        -- 添加按钮
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button.Position = UDim2.new(0.1, 0, 0.1, 0) -- 按钮位置
        button.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button.Text = "飞行 V3"
        button.TextColor3 = CONFIG.TEXT_COLOR
        button.TextSize = 14
        button.Parent = contentFrame

        local button2 = Instance.new("TextButton")
        button2.Size = UDim2.new(0.2, 0, 0.1, 0) -- 按钮大小
        button2.Position = UDim2.new(0.35, 0, 0.1, 0) -- 按钮位置
        button2.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button2.Text = "反挂机被踢"
        button2.TextColor3 = CONFIG.TEXT_COLOR
        button2.TextSize = 14
        button2.Parent = contentFrame

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/flyv3.lua"))()
            CreateNotification("正在启动", "飞行 V3", 5, true)
        end)

        button.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/AntiAFKKick.lua"))()
            CreateNotification("正在启动", "反挂机被踢", 5, true)
        end)
    end
end

-- 添加分类按钮
local categories = {"基础", "工具", "脚本中心"}
for i, cat in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Size = CONFIG.CATEGORY_BUTTON_SIZE
    button.Position = UDim2.new(
        (i - 1) * (CONFIG.CATEGORY_BUTTON_SIZE.X.Scale + CONFIG.CATEGORY_BUTTON_SPACING / menuFrame.AbsoluteSize.X) + CONFIG.CATEGORY_BUTTON_INSET / menuFrame.AbsoluteSize.X, 
        0, 
        0, 
        0
    )
    button.BackgroundColor3 = CONFIG.BUTTON_COLOR
    button.Text = cat
    button.TextColor3 = CONFIG.TEXT_COLOR
    button.TextSize = 18
    button.Parent = categoryButtonsFrame

    button.MouseButton1Click:Connect(function()
        AddMenuContent(cat) -- 切换菜单内容
    end)
end

-- 箭头按钮滑入滑出逻辑
local function ToggleArrow(visible)
    local targetPosition = visible and CONFIG.ARROW_POSITION_VISIBLE or CONFIG.ARROW_POSITION_HIDDEN
    local tween = TweenService:Create(arrowButton, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
end

-- 菜单弹出逻辑
local function ToggleMenu(visible)
    local targetPosition = visible and CONFIG.MENU_POSITION_VISIBLE or CONFIG.MENU_POSITION_HIDDEN
    local tween = TweenService:Create(menuFrame, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
    if visible then
        ToggleArrow(false) -- 弹出菜单后隐藏箭头
    end
end

-- 鼠标移动检测
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseY = input.Position.Y
        local screenHeight = Gui.AbsoluteSize.Y
        if mouseY > screenHeight * 0.95 then -- 鼠标在屏幕底部 5% 区域
            ToggleArrow(true)
        else
            ToggleArrow(false)
        end
    end
end)

-- 点击菜单外部关闭菜单
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePosition = input.Position
        local menuPosition = menuFrame.AbsolutePosition
        local menuSize = menuFrame.AbsoluteSize
        if not (mousePosition.X >= menuPosition.X and mousePosition.X <= menuPosition.X + menuSize.X and
                mousePosition.Y >= menuPosition.Y and mousePosition.Y <= menuPosition.Y + menuSize.Y) then
            ToggleMenu(false)
        end
    end
end)

-- 点击箭头按钮弹出菜单
arrowButton.MouseButton1Click:Connect(function()
    ToggleMenu(true)
    AddMenuContent("基础")
end)

-- 按下 Delete 键卸载菜单
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        Gui:Destroy() -- 卸载整个菜单系统
    end
end)

CreateNotification("欢迎使用", "Chronix已启动!", 10, true)