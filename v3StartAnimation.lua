local LoadAnimationModule = {}

function LoadAnimationModule:LoadAnimation(duration, config)
    -- 创建音效
    local loadingSound = Instance.new("Sound", game:GetService("SoundService"))
    loadingSound.SoundId = "rbxassetid://1837581587"
    loadingSound.Volume = 0.3
    loadingSound:Play()
    
    -- 默认配置
    local defaultConfig = {
        titleText = "ChronixHub V3",
        loadingText = "加载中... ",
        backgroundColor = Color3.new(0.102, 0.098, 0.102), -- #1a191a
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

    -- 使用固定的1030*605像素大小，总共缩小20%
    local uiScale = 0.8 -- 总共缩小20%
    local uiWidth = 1030 * uiScale
    local uiHeight = 605 * uiScale

    -- 创建主框架 - 固定像素大小
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, uiWidth, 0, uiHeight) -- 固定像素大小
    frame.Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2) -- 屏幕居中
    frame.BackgroundColor3 = config.backgroundColor -- #1a191a
    frame.BackgroundTransparency = 0
    frame.ClipsDescendants = true -- 超出部分不显示
    frame.Parent = screenGui

    -- 添加圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.03, 0)
    corner.Parent = frame

    -- 创建左上角圆形嵌入 - 颜色#141414，大小为竖边的1/3
    local circleSize = uiHeight / 3
    local topLeftCircle = Instance.new("Frame")
    topLeftCircle.Name = "TopLeftCircle"
    topLeftCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    topLeftCircle.Position = UDim2.new(0, -circleSize/2, 0, -circleSize/2) -- 左上角嵌入
    topLeftCircle.BackgroundColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    topLeftCircle.BackgroundTransparency = 0
    topLeftCircle.Parent = frame

    -- 圆形圆角
    local topLeftCircleCorner = Instance.new("UICorner")
    topLeftCircleCorner.CornerRadius = UDim.new(0.5, 0) -- 圆形
    topLeftCircleCorner.Parent = topLeftCircle

    -- 创建右下角圆形嵌入 - 颜色#141414，大小为竖边的1/3
    local bottomRightCircle = Instance.new("Frame")
    bottomRightCircle.Name = "BottomRightCircle"
    bottomRightCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    bottomRightCircle.Position = UDim2.new(0, uiWidth - circleSize/2, 0, uiHeight - circleSize/2) -- 右下角嵌入
    bottomRightCircle.BackgroundColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    bottomRightCircle.BackgroundTransparency = 0
    bottomRightCircle.Parent = frame

    -- 圆形圆角
    local bottomRightCircleCorner = Instance.new("UICorner")
    bottomRightCircleCorner.CornerRadius = UDim.new(0.5, 0) -- 圆形
    bottomRightCircleCorner.Parent = bottomRightCircle

    -- 创建标题文本
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(0, 350, 0, 50) -- 缩小标题大小
    titleFrame.Position = UDim2.new(0, uiWidth/2 - 175, 0, uiHeight*0.2) -- 中间偏上位置
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = frame

    -- ChronixHub 文本 (纯白色)
    local chronixText = Instance.new("TextLabel")
    chronixText.Text = "ChronixHub"
    chronixText.Size = UDim2.new(0, 240, 0, 50) -- 缩小文本大小
    chronixText.Position = UDim2.new(0, 0, 0, 0)
    chronixText.TextColor3 = Color3.new(1, 1, 1) -- 纯白色
    chronixText.BackgroundTransparency = 1
    chronixText.Font = Enum.Font.SourceSansBold
    chronixText.TextSize = 32 -- 缩小字体
    chronixText.TextScaled = false
    chronixText.Parent = titleFrame

    -- V3 文本 (更偏绿的黄绿色)
    local v3Text = Instance.new("TextLabel")
    v3Text.Text = "V3"
    v3Text.Size = UDim2.new(0, 70, 0, 50) -- 缩小文本大小
    v3Text.Position = UDim2.new(0, 230, 0, 0) -- 贴近ChronixHub
    v3Text.TextColor3 = Color3.new(0.8, 1, 0.5) -- 更偏绿的黄绿色
    v3Text.BackgroundTransparency = 1
    v3Text.Font = Enum.Font.SourceSansBold
    v3Text.TextSize = 32 -- 缩小字体
    v3Text.TextScaled = false
    v3Text.Parent = titleFrame

    -- 加载文本
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = config.loadingText .. "0%"
    loadingText.Size = UDim2.new(0, 250, 0, 35) -- 缩小文本大小
    loadingText.Position = UDim2.new(0, uiWidth/2 - 125, 0, uiHeight*0.6) -- 中间偏下位置
    loadingText.TextColor3 = config.textColor
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 18 -- 缩小字体
    loadingText.Parent = frame

    -- 创建进度条背景 - 更细，透明背景，黑色边框，带圆角
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Size = UDim2.new(0, uiWidth*0.8, 0, 6) -- 更细的进度条
    progressBarBackground.Position = UDim2.new(0, uiWidth*0.1, 0, uiHeight*0.75) -- 位置调整
    progressBarBackground.BackgroundTransparency = 1 -- 透明背景
    progressBarBackground.ClipsDescendants = true
    progressBarBackground.Parent = frame

    -- 进度条背景圆角
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0.5, 0) -- 圆形边角
    progressBgCorner.Parent = progressBarBackground

    -- 进度条背景黑色边框
    local progressBorder = Instance.new("UIStroke")
    progressBorder.Color = Color3.new(0, 0, 0) -- 纯黑色边框
    progressBorder.Thickness = 1
    progressBorder.Parent = progressBarBackground

    -- 创建进度条 - 与V3相同颜色，更细，带圆角
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 6) -- 初始宽度为 0，更细
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.new(0.8, 1, 0.5) -- 与V3相同颜色
    progressBar.Parent = progressBarBackground

    -- 进度条圆角
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0) -- 圆形边角
    progressCorner.Parent = progressBar

    -- 进度条缓动效果用的变量
    local currentProgress = 0
    local targetProgress = 0
    local progressSteps = {0, 0.2, 0.5, 0.9, 1} -- 跳跃式进度：0% → 20% → 50% → 90% → 100%
    local currentStep = 1

    -- 创建取消按钮
    local cancelButton
    if config.showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = "✕" -- 叉号符号
        cancelButton.Size = UDim2.new(0, 30, 0, 30) -- 缩小按钮大小
        cancelButton.Position = UDim2.new(0, uiWidth - 40, 0, 10) -- 右上角位置
        cancelButton.TextColor3 = Color3.new(1, 1, 1)
        cancelButton.BackgroundTransparency = 0.8
        cancelButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
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
            cancelButton.TextColor3 = Color3.new(0.8, 1, 0.5)
        end)

        cancelButton.MouseLeave:Connect(function()
            cancelButton.BackgroundTransparency = 0.8
            cancelButton.TextColor3 = Color3.new(1, 1, 1)
        end)
    end

    -- 使用 coroutine 管理动画
    local function playAnimationAsync()
        -- 主动画：整个界面从屏幕右侧划入中间
        local slideIn = game:GetService("TweenService"):Create(
            frame, 
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2)} -- 屏幕居中
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        -- 模拟加载进度 - 跳跃式更新，明显的缓动效果
        local isCancelled = false
        local stepDurations = {1.5, 2.0, 2.5, 2.0} -- 每个步骤的持续时间（秒）
        
        if config.showCancelButton and cancelButton then
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
                    {Position = UDim2.new(1.5, 0, 0.5, -uiHeight/2)}
                )
                slideOut:Play()
                slideOut.Completed:Wait()
                if screenGui then
                    screenGui:Destroy()
                end
                if type(config.onComplete) == "function" then
                    config.onComplete(true) -- 传入 true 表示加载被取消
                end
            end)
        end

        -- 跳跃式进度更新
        while currentStep < #progressSteps and not isCancelled do
            -- 设置下一个目标进度
            targetProgress = progressSteps[currentStep + 1]
            
            -- 记录开始时间
            local stepStartTime = tick()
            
            -- 使用TweenService实现平滑的进度条动画
            local progressTween = game:GetService("TweenService"):Create(
                progressBar,
                TweenInfo.new(stepDurations[currentStep], Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, targetProgress * uiWidth * 0.8, 0, 6)}
            )
            progressTween:Play()
            
            -- 更新文本显示
            while tick() - stepStartTime < stepDurations[currentStep] and not isCancelled do
                local elapsed = tick() - stepStartTime
                local tweenProgress = elapsed / stepDurations[currentStep]
                currentProgress = progressSteps[currentStep] + (targetProgress - progressSteps[currentStep]) * tweenProgress
                
                local displayProgress = math.floor(currentProgress * 100)
                loadingText.Text = config.loadingText .. displayProgress .. "%"
                
                wait(0.05)
            end
            
            -- 更新到下一个步骤
            currentProgress = targetProgress
            currentStep = currentStep + 1
            
            -- 在20%、50%、90%处添加卡顿效果
            if currentStep <= 4 then -- 只在20%、50%、90%处卡顿
                local pauseDuration = {2.0, 3.0, 5.0}[currentStep - 1] -- 2秒, 3秒, 5秒
                local pauseEndTime = tick() + pauseDuration
                
                -- 更新为准确的进度文本
                local displayProgress = math.floor(currentProgress * 100)
                loadingText.Text = config.loadingText .. displayProgress .. "%"
                
                -- 等待卡顿结束
                while tick() < pauseEndTime and not isCancelled do
                    wait(0.1)
                end
            end
        end

        if not isCancelled then
            -- 确保进度条显示100%
            loadingText.Text = "加载完毕!"
            progressBar.Size = UDim2.new(0, uiWidth * 0.8, 0, 6)
            
            if config.showCancelButton and cancelButton then
                cancelButton.Parent = nil
            end
            
            -- 当进度条跑满之后音乐跳到某个阶段 (128秒处)
            if loadingSound then
                loadingSound.TimePosition = 128
            end
            
            wait(0.5)

            loadingText.Text = config.loadingText .. "100%"
            
            -- 完成时的动画：界面滑出屏幕
            local slideOut = game:GetService("TweenService"):Create(
                frame, 
                TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(-0.5, 0, 0.5, -uiHeight/2)}
            )
            slideOut:Play()
            slideOut.Completed:Wait()

            -- 清除所有实例，但不停止音乐
            if screenGui then
                screenGui:Destroy()
            end

            -- 调用完成回调
            if type(config.onComplete) == "function" then
                config.onComplete(false) -- 传入 false 表示加载完成
            end
        end
    end

    -- 启动动画协程
    coroutine.wrap(playAnimationAsync)()
end

return LoadAnimationModule