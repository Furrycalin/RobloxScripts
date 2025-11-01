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

    -- 创建主框架 - 修改为纯黑不透明，宽度更窄
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4, 0, 0.45, 0) -- 宽度从0.6改为0.4，更窄
    -- 初始位置在屏幕外（右侧），动作幅度更小
    frame.Position = UDim2.new(1.5, 0, 0.3, 0) -- 从2改为1.5，动作幅度更小
    frame.BackgroundColor3 = Color3.new(0, 0, 0) -- 纯黑色
    frame.BackgroundTransparency = 0 -- 完全不透明
    frame.Parent = screenGui

    -- 添加圆角 - 更小的圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.03, 0) -- 从0.05改为0.03，更小的圆角
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

    -- 创建标题文本 - 让ChronixHub和V3更贴近
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
    titleFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = frame

    -- ChronixHub 文本 (纯白色) - 调整尺寸让文字更贴近
    local chronixText = Instance.new("TextLabel")
    chronixText.Text = "ChronixHub"
    chronixText.Size = UDim2.new(0.8, 0, 1, 0) -- 增加宽度
    chronixText.Position = UDim2.new(0, 0, 0, 0)
    chronixText.TextColor3 = Color3.new(1, 1, 1) -- 纯白色
    chronixText.BackgroundTransparency = 1
    chronixText.Font = Enum.Font.SourceSansBold
    chronixText.TextSize = 44
    chronixText.TextScaled = false -- 确保文字大小固定
    chronixText.Parent = titleFrame

    -- V3 文本 (更偏绿的黄绿色) - 调整位置让文字更贴近
    local v3Text = Instance.new("TextLabel")
    v3Text.Text = "V3"
    v3Text.Size = UDim2.new(0.2, 0, 1, 0) -- 减小宽度
    v3Text.Position = UDim2.new(0.78, -5, 0, 0) -- 大幅向左偏移，几乎贴在一起
    v3Text.TextColor3 = Color3.new(0.8, 1, 0.5) -- 更偏绿的黄绿色
    v3Text.BackgroundTransparency = 1
    v3Text.Font = Enum.Font.SourceSansBold
    v3Text.TextSize = 44
    v3Text.TextScaled = false -- 确保文字大小固定
    v3Text.Parent = titleFrame

    -- 加载文本 - 直接显示在最终位置
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = config.loadingText .. "0%"
    loadingText.Size = UDim2.new(0.9, 0, 0.2, 0)
    loadingText.Position = UDim2.new(0.05, 0, 0.5, 0)
    loadingText.TextColor3 = config.textColor
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 23
    loadingText.Parent = frame

    -- 创建进度条背景 - 直接显示在最终位置
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Size = UDim2.new(0.9, 0, 0.04, 0)
    progressBarBackground.Position = UDim2.new(0.05, 0, 0.8, 0)
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

    -- 创建取消按钮 - 更窄，更靠近右上角，使用叉号
    local cancelButton
    if config.showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = "✕" -- 叉号符号
        cancelButton.Size = UDim2.new(0.08, 0, 0.08, 0) -- 更窄更小
        cancelButton.Position = UDim2.new(0.88, 0, 0.03, 0) -- 更靠近右上角
        cancelButton.TextColor3 = Color3.new(1, 1, 1) -- 白色文本
        cancelButton.BackgroundTransparency = 0.8 -- 半透明背景
        cancelButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 深色背景
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.TextSize = 18 -- 叉号更大一些
        cancelButton.Parent = frame

        -- 取消按钮圆角
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0.2, 0)
        cancelCorner.Parent = cancelButton

        -- 取消按钮悬停效果
        cancelButton.MouseEnter:Connect(function()
            cancelButton.BackgroundTransparency = 0.6
            cancelButton.TextColor3 = Color3.new(0.8, 1, 0.5) -- 悬停时变黄绿色
        end)

        cancelButton.MouseLeave:Connect(function()
            cancelButton.BackgroundTransparency = 0.8
            cancelButton.TextColor3 = Color3.new(1, 1, 1) -- 恢复白色
        end)
    end

    -- 使用 coroutine 管理动画
    local function playAnimationAsync()
        -- 主动画：整个界面从屏幕右侧划入中间，动作幅度更小
        local slideIn = game:GetService("TweenService"):Create(
            frame, 
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.3, 0, 0.3, 0)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        -- 模拟加载进度 - 改进版：定点卡顿效果
        local startTime = tick()
        local isCancelled = false
        local progress = 0
        
        -- 定点卡顿配置
        local pausePoints = {0.2, 0.5, 0.9} -- 20%, 50%, 90% 处卡顿
        local pauseDurations = {0.8, 1.2, 1.0} -- 每个点的卡顿时间
        local pauseIndex = 1 -- 当前该处理哪个卡顿点
        local isPaused = false
        local pauseEndTime = 0

        if config.showCancelButton then
            cancelButton.MouseButton1Click:Connect(function()
                isCancelled = true
                -- 停止音乐
                if loadingSound then
                    loadingSound:Stop()
                    loadingSound:Destroy()
                end
                -- 取消时的动画：界面滑出屏幕
                local slideOut = game:GetService("TweenService"):Create(
                    frame, 
                    TweenInfo.new(0.4, Enum.EasingStyle.Quad),
                    {Position = UDim2.new(1.5, 0, 0.3, 0)}
                )
                slideOut:Play()
                slideOut.Completed:Wait()
                screenGui:Destroy()
                config.onComplete(true) -- 传入 true 表示加载被取消
            end)
        end

        -- 使用 RenderStepped 更新进度条 - 定点卡顿版
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if isCancelled then
                connection:Disconnect()
                return
            end

            local currentTime = tick()
            
            -- 检查是否在停顿中
            if isPaused then
                if currentTime >= pauseEndTime then
                    isPaused = false
                    startTime = currentTime - (progress * duration) -- 调整开始时间，补偿停顿时间
                else
                    return -- 停顿期间不更新进度
                end
            end

            -- 计算进度
            progress = (currentTime - startTime) / duration
            progress = math.min(progress, 1)

            -- 检查是否到达下一个卡顿点
            if not isPaused and pauseIndex <= #pausePoints and progress >= pausePoints[pauseIndex] then
                isPaused = true
                pauseEndTime = currentTime + pauseDurations[pauseIndex]
                pauseIndex = pauseIndex + 1
                return
            end

            -- 更新UI
            loadingText.Text = config.loadingText .. math.floor(progress * 100) .. "%"
            progressBar.Size = UDim2.new(progress, 0, 1, 0)
            
            -- 当进度达到100%时断开连接
            if progress >= 1 then
                connection:Disconnect()
            end
        end)

        -- 等待加载完成
        while (tick() - startTime) < (duration + 3) and not isCancelled do -- 增加额外等待时间
            wait(0.1)
        end

        if not isCancelled then
            -- 确保进度条显示100%
            progress = 1
            loadingText.Text = "加载完毕!"
            progressBar.Size = UDim2.new(1, 0, 1, 0)
            
            if config.showCancelButton then cancelButton.Parent = nil end
            
            -- 停止音乐
            if loadingSound then
                loadingSound:Stop()
                loadingSound:Destroy()
            end
            
            wait(0.5)

            loadingText.Text = config.loadingText .. "100%"
            
            -- 完成时的动画：界面滑出屏幕
            local slideOut = game:GetService("TweenService"):Create(
                frame, 
                TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(-0.5, 0, 0.3, 0)}
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