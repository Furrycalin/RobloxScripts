local LoadAnimationModule = {}

function LoadAnimationModule:LoadAnimation(duration, config)
    local loadingSound = Instance.new("Sound", game:GetService("SoundService"))
    loadingSound.SoundId = "rbxassetid://1837581587"
    loadingSound.Volume = 0.3
    loadingSound:Play()
    
    -- 默认配置
    local defaultConfig = {
        titleText = "ChronixHub V3",
        loadingText = "加载中... ",
        backgroundColor = Color3.new(0, 0, 0), -- 纯黑色
        textColor = Color3.new(1, 1, 1),
        language = "zh", -- 默认语言
        onComplete = function() end, -- 动画完成回调
        showCancelButton = true -- 是否显示取消按钮
    }

    -- 合并用户配置
    config = config or {}
    for k, v in pairs(defaultConfig) do
        if config[k] == nil then
            config[k] = v
        end
    end

    -- 多语言支持
    local translations = {
        en = { title = "ChronixHub V3", loading = "Loading... ", cancel = "Cancel" },
        zh = { title = "ChronixHub V3", loading = "加载中... ", cancel = "取消" }
    }
    config.titleText = translations[config.language].title
    config.loadingText = translations[config.language].loading
    local cancelText = translations[config.language].cancel

    -- 错误处理：防止重复调用
    if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("LoadAnimationGui") then
        return
    end

    -- 创建界面
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadAnimationGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- 创建主框架 - 修改为纯黑不透明
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.6, 0, 0.45, 0)
    -- 初始位置在屏幕外（右侧）
    frame.Position = UDim2.new(2, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0) -- 纯黑色
    frame.BackgroundTransparency = 0 -- 完全不透明
    frame.Parent = screenGui

    -- 添加圆角 - 小圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0) -- 小圆角
    corner.Parent = frame

    -- 添加暗色渐变背景
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 45 -- 对角线渐变
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), -- 纯黑
        ColorSequenceKeypoint.new(0.5, Color3.new(0.1, 0.1, 0.1)), -- 深灰
        ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)) -- 纯黑
    })
    gradient.Parent = frame

    -- 创建标题文本 - 分开显示 ChronixHub 和 V3
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(0.8, 0, 0.3, 0)
    titleFrame.Position = UDim2.new(0.1, 0, 0.1, 0) -- 直接显示在最终位置
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = frame

    -- ChronixHub 文本 (纯白色)
    local chronixText = Instance.new("TextLabel")
    chronixText.Text = "ChronixHub"
    chronixText.Size = UDim2.new(0.7, 0, 1, 0)
    chronixText.Position = UDim2.new(0, 0, 0, 0)
    chronixText.TextColor3 = Color3.new(1, 1, 1) -- 纯白色
    chronixText.BackgroundTransparency = 1
    chronixText.Font = Enum.Font.SourceSansBold
    chronixText.TextSize = 44
    chronixText.Parent = titleFrame

    -- V3 文本 (黄绿色)
    local v3Text = Instance.new("TextLabel")
    v3Text.Text = "V3"
    v3Text.Size = UDim2.new(0.3, 0, 1, 0)
    v3Text.Position = UDim2.new(0.7, 0, 0, 0)
    v3Text.TextColor3 = Color3.new(1, 1, 0.5) -- 黄绿色
    v3Text.BackgroundTransparency = 1
    v3Text.Font = Enum.Font.SourceSansBold
    v3Text.TextSize = 44
    v3Text.Parent = titleFrame

    -- 加载文本 - 直接显示在最终位置
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = config.loadingText .. "0%"
    loadingText.Size = UDim2.new(0.8, 0, 0.2, 0)
    loadingText.Position = UDim2.new(0.1, 0, 0.5, 0) -- 直接显示在最终位置
    loadingText.TextColor3 = config.textColor
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 23
    loadingText.Parent = frame

    -- 创建进度条背景 - 直接显示在最终位置
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Size = UDim2.new(0.8, 0, 0.04, 0)
    progressBarBackground.Position = UDim2.new(0.1, 0, 0.8, 0) -- 直接显示在最终位置
    progressBarBackground.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    progressBarBackground.BackgroundTransparency = 0
    progressBarBackground.ClipsDescendants = true
    progressBarBackground.Parent = frame

    -- 进度条背景圆角
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0)
    progressCorner.Parent = progressBarBackground

    -- 进度条背景边框
    local progressBorder = Instance.new("UIStroke")
    progressBorder.Color = Color3.new(0.5, 0.5, 0.5)
    progressBorder.Thickness = 1
    progressBorder.Parent = progressBarBackground

    -- 创建进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0) -- 初始宽度为 0
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.new(1, 1, 0)
    progressBar.Parent = progressBarBackground

    -- 进度条圆角
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0.5, 0)
    barCorner.Parent = progressBar

    -- 进度条横向渐变
    local barGradient = Instance.new("UIGradient")
    barGradient.Rotation = 0 -- 横向渐变
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.157, 0.498, 0.278)), -- 墨绿
        ColorSequenceKeypoint.new(1, Color3.new(0, 0.063, 0.69))  -- 墨蓝
    })
    barGradient.Parent = progressBar

    -- 创建取消按钮 - 移到右上角
    local cancelButton
    if config.showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = cancelText
        cancelButton.Size = UDim2.new(0.15, 0, 0.1, 0) -- 调整大小
        cancelButton.Position = UDim2.new(0.8, 0, 0.05, 0) -- 右上角位置
        cancelButton.TextColor3 = Color3.new(1, 1, 1) -- 白色文本
        cancelButton.BackgroundTransparency = 0.8 -- 半透明背景
        cancelButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 深色背景
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.TextSize = 16
        cancelButton.Parent = frame

        -- 取消按钮圆角
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0.2, 0)
        cancelCorner.Parent = cancelButton

        -- 取消按钮悬停效果
        cancelButton.MouseEnter:Connect(function()
            cancelButton.BackgroundTransparency = 0.6
            cancelButton.TextColor3 = Color3.new(1, 1, 0.5) -- 悬停时变黄绿色
        end)

        cancelButton.MouseLeave:Connect(function()
            cancelButton.BackgroundTransparency = 0.8
            cancelButton.TextColor3 = Color3.new(1, 1, 1) -- 恢复白色
        end)
    end

    -- 使用 coroutine 管理动画
    local function playAnimationAsync()
        -- 主动画：整个界面从屏幕右侧划入中间
        local slideIn = game:GetService("TweenService"):Create(
            frame, 
            TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {Position = UDim2.new(0.2, 0, 0.3, 0)} -- 最终位置
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        -- 模拟加载进度
        local startTime = tick()
        local isCancelled = false

        if config.showCancelButton then
            cancelButton.MouseButton1Click:Connect(function()
                isCancelled = true
                -- 取消时的动画：界面滑出屏幕
                local slideOut = game:GetService("TweenService"):Create(
                    frame, 
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad), 
                    {Position = UDim2.new(2, 0, 0.3, 0)}
                )
                slideOut:Play()
                slideOut.Completed:Wait()
                screenGui:Destroy()
                config.onComplete(true) -- 传入 true 表示加载被取消
            end)
        end

        -- 使用 RenderStepped 更新进度条
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if isCancelled then
                connection:Disconnect()
                return
            end

            local progress = (tick() - startTime) / duration
            if progress >= 1 then
                progress = 1
                connection:Disconnect()
            end

            loadingText.Text = config.loadingText .. math.floor(progress * 100) .. "%"
            progressBar.Size = UDim2.new(progress, 0, 1, 0)
        end)

        -- 等待加载完成
        while tick() - startTime < duration and not isCancelled do
            wait(0.1)
        end

        if not isCancelled then
            loadingText.Text = "加载完毕!"
            if config.showCancelButton then cancelButton.Parent = nil end
            loadingSound.TimePosition = 128
            wait(0.5)

            loadingText.Text = config.loadingText .. "100%"
            progressBar.Size = UDim2.new(1, 0, 1, 0)
            
            -- 完成时的动画：界面滑出屏幕
            local slideOut = game:GetService("TweenService"):Create(
                frame, 
                TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                {Position = UDim2.new(-1, 0, 0.3, 0)} -- 向左滑出
            )
            slideOut:Play()
            slideOut.Completed:Wait()

            -- 清除所有实例
            screenGui:Destroy()

            -- 调用完成回调
            config.onComplete(false) -- 传入 false 表示加载完成
        end
    end

    -- 启动动画协程
    coroutine.wrap(playAnimationAsync)()
end

return LoadAnimationModule