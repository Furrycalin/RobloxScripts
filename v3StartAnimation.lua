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

    -- 计算1030*605的比例 (605/1030 ≈ 0.587)
    local aspectRatio = 605 / 1030 -- 约0.587
    local frameWidth = 0.4 -- 保持宽度为屏幕的40%
    local frameHeight = frameWidth * aspectRatio -- 根据比例计算高度

    -- 创建主框架 - 1030*605比例，背景色#1a191a
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(frameWidth, 0, frameHeight, 0)
    frame.Position = UDim2.new(1.5, 0, 0.5 - frameHeight/2, 0) -- 垂直居中
    frame.BackgroundColor3 = config.backgroundColor -- #1a191a
    frame.BackgroundTransparency = 0
    frame.Parent = screenGui

    -- 添加圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.03, 0)
    corner.Parent = frame

    -- 创建波浪形嵌入效果 - 左上角
    local topLeftWave = Instance.new("ImageLabel")
    topLeftWave.Name = "TopLeftWave"
    topLeftWave.Size = UDim2.new(0.3, 0, 0.3, 0)
    topLeftWave.Position = UDim2.new(-0.15, 0, -0.15, 0)
    topLeftWave.BackgroundTransparency = 1
    topLeftWave.Image = "rbxassetid://154967018" -- 波浪形图片（需要替换为合适的图片ID）
    topLeftWave.ImageColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    topLeftWave.Rotation = 180
    topLeftWave.Parent = frame

    -- 创建波浪形嵌入效果 - 右下角
    local bottomRightWave = Instance.new("ImageLabel")
    bottomRightWave.Name = "BottomRightWave"
    bottomRightWave.Size = UDim2.new(0.3, 0, 0.3, 0)
    bottomRightWave.Position = UDim2.new(0.85, 0, 0.85, 0)
    bottomRightWave.BackgroundTransparency = 1
    bottomRightWave.Image = "rbxassetid://154967018" -- 波浪形图片（需要替换为合适的图片ID）
    bottomRightWave.ImageColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    bottomRightWave.Parent = frame

    -- 创建标题文本 - 更小的字体，中间偏上位置
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(0.8, 0, 0.2, 0) -- 更小的高度
    titleFrame.Position = UDim2.new(0.1, 0, 0.2, 0) -- 中间偏上位置
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = frame

    -- ChronixHub 文本 (纯白色) - 更小的字体
    local chronixText = Instance.new("TextLabel")
    chronixText.Text = "ChronixHub"
    chronixText.Size = UDim2.new(0.8, 0, 1, 0)
    chronixText.Position = UDim2.new(0, 0, 0, 0)
    chronixText.TextColor3 = Color3.new(1, 1, 1) -- 纯白色
    chronixText.BackgroundTransparency = 1
    chronixText.Font = Enum.Font.SourceSansBold
    chronixText.TextSize = 32 -- 更小的字体
    chronixText.TextScaled = false
    chronixText.Parent = titleFrame

    -- V3 文本 (更偏绿的黄绿色) - 更小的字体
    local v3Text = Instance.new("TextLabel")
    v3Text.Text = "V3"
    v3Text.Size = UDim2.new(0.2, 0, 1, 0)
    v3Text.Position = UDim2.new(0.78, -5, 0, 0) -- 贴近ChronixHub
    v3Text.TextColor3 = Color3.new(0.8, 1, 0.5) -- 更偏绿的黄绿色
    v3Text.BackgroundTransparency = 1
    v3Text.Font = Enum.Font.SourceSansBold
    v3Text.TextSize = 32 -- 更小的字体
    v3Text.TextScaled = false
    v3Text.Parent = titleFrame

    -- 加载文本 - 更小的字体，中间偏下位置，与标题对称
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = config.loadingText .. "0%"
    loadingText.Size = UDim2.new(0.8, 0, 0.15, 0) -- 更小的高度
    loadingText.Position = UDim2.new(0.1, 0, 0.6, 0) -- 中间偏下位置，与标题对称
    loadingText.TextColor3 = config.textColor
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 18 -- 更小的字体
    loadingText.Parent = frame

    -- 创建进度条背景 - 更细，透明背景，黑色边框
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Size = UDim2.new(0.8, 0, 0.02, 0) -- 更细的进度条
    progressBarBackground.Position = UDim2.new(0.1, 0, 0.75, 0) -- 位置调整
    progressBarBackground.BackgroundTransparency = 1 -- 透明背景
    progressBarBackground.ClipsDescendants = true
    progressBarBackground.Parent = frame

    -- 进度条背景黑色边框
    local progressBorder = Instance.new("UIStroke")
    progressBorder.Color = Color3.new(0, 0, 0) -- 纯黑色边框
    progressBorder.Thickness = 1
    progressBorder.Parent = progressBarBackground

    -- 创建进度条 - 与V3相同颜色，更细
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0) -- 初始宽度为 0
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.new(0.8, 1, 0.5) -- 与V3相同颜色
    progressBar.Parent = progressBarBackground

    -- 进度条缓动效果用的初始值
    local currentProgress = 0

    -- 创建取消按钮 - 保持原样
    local cancelButton
    if config.showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = "✕" -- 叉号符号
        cancelButton.Size = UDim2.new(0.08, 0, 0.08, 0)
        cancelButton.Position = UDim2.new(0.88, 0, 0.03, 0)
        cancelButton.TextColor3 = Color3.new(1, 1, 1)
        cancelButton.BackgroundTransparency = 0.8
        cancelButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.TextSize = 18
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
            {Position = UDim2.new(0.5 - frameWidth/2, 0, 0.5 - frameHeight/2, 0)} -- 居中显示
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        -- 模拟加载进度 - 改进版：不同时长的定点卡顿
        local startTime = tick()
        local isCancelled = false
        
        -- 定点卡顿配置 - 不同的卡顿时间
        local pausePoints = {0.2, 0.5, 0.9} -- 20%, 50%, 90% 处卡顿
        local pauseDurations = {2.0, 3.0, 5.0} -- 2秒, 3秒, 5秒
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
                    {Position = UDim2.new(1.5, 0, 0.5 - frameHeight/2, 0)}
                )
                slideOut:Play()
                slideOut.Completed:Wait()
                screenGui:Destroy()
                config.onComplete(true) -- 传入 true 表示加载被取消
            end)
        end

        -- 使用 RenderStepped 更新进度条 - 带缓动效果
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
                    startTime = currentTime - (currentProgress * duration) -- 调整开始时间
                else
                    return -- 停顿期间不更新进度
                end
            end

            -- 计算目标进度
            local targetProgress = (currentTime - startTime) / duration
            targetProgress = math.min(targetProgress, 1)

            -- 检查是否到达下一个卡顿点
            if not isPaused and pauseIndex <= #pausePoints and targetProgress >= pausePoints[pauseIndex] then
                isPaused = true
                pauseEndTime = currentTime + pauseDurations[pauseIndex]
                pauseIndex = pauseIndex + 1
                return
            end

            -- 进度条缓动效果 - 使用平滑插值
            local easingFactor = 0.1 -- 缓动系数，越小越平滑
            currentProgress = currentProgress + (targetProgress - currentProgress) * easingFactor

            -- 更新UI
            local displayProgress = math.floor(currentProgress * 100)
            loadingText.Text = config.loadingText .. displayProgress .. "%"
            
            -- 应用缓动后的进度到进度条
            progressBar.Size = UDim2.new(currentProgress, 0, 1, 0)
            
            -- 当进度达到100%时断开连接
            if currentProgress >= 0.999 then
                connection:Disconnect()
            end
        end)

        -- 等待加载完成
        while (tick() - startTime) < (duration + 10) and not isCancelled do -- 增加额外等待时间
            wait(0.1)
        end

        if not isCancelled then
            -- 确保进度条显示100%
            currentProgress = 1
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
                {Position = UDim2.new(-0.5, 0, 0.5 - frameHeight/2, 0)}
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