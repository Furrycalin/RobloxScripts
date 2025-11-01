-- 极简稳定版加载动画模块
local LoadAnimationModule = {}

function LoadAnimationModule:LoadAnimation(duration, config)
    -- 基础检查
    if not duration then return end
    
    -- 创建音效（简化版）
    local loadingSound
    local success = pcall(function()
        loadingSound = Instance.new("Sound")
        loadingSound.SoundId = "rbxassetid://1837581587"
        loadingSound.Volume = 0.3
        loadingSound.Parent = game.SoundService
        loadingSound:Play()
    end)
    
    -- 默认配置
    config = config or {}
    local onComplete = config.onComplete or function() end
    local showCancelButton = config.showCancelButton ~= false
    
    -- 错误处理：防止重复调用
    local player = game.Players.LocalPlayer
    if not player or not player.PlayerGui then return end
    if player.PlayerGui:FindFirstChild("LoadAnimationGui") then return end

    -- 创建界面
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadAnimationGui"
    screenGui.Parent = player.PlayerGui

    -- 使用固定大小，总共缩小25%
    local uiWidth = 772
    local uiHeight = 454

    -- 创建主框架
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    frame.Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2)
    frame.BackgroundColor3 = Color3.new(0.102, 0.098, 0.102) -- #1a191a
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    -- 添加圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0)
    corner.Parent = frame

    -- 创建嵌入式圆形装饰
    local circleSize = uiHeight / 3
    
    -- 左上角圆形
    local topLeftCircle = Instance.new("Frame")
    topLeftCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    topLeftCircle.Position = UDim2.new(0, -circleSize/2, 0, -circleSize/2)
    topLeftCircle.BackgroundColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    topLeftCircle.Parent = frame
    
    local topLeftCorner = Instance.new("UICorner")
    topLeftCorner.CornerRadius = UDim.new(0.5, 0)
    topLeftCorner.Parent = topLeftCircle

    -- 右下角圆形
    local bottomRightCircle = Instance.new("Frame")
    bottomRightCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    bottomRightCircle.Position = UDim2.new(0, uiWidth - circleSize/2, 0, uiHeight - circleSize/2)
    bottomRightCircle.BackgroundColor3 = Color3.new(0.078, 0.078, 0.078) -- #141414
    bottomRightCircle.Parent = frame
    
    local bottomRightCorner = Instance.new("UICorner")
    bottomRightCorner.CornerRadius = UDim.new(0.5, 0)
    bottomRightCorner.Parent = bottomRightCircle

    -- 创建标题文本
    local chronixText = Instance.new("TextLabel")
    chronixText.Text = "ChronixHub"
    chronixText.Size = UDim2.new(0, 220, 0, 45)
    chronixText.Position = UDim2.new(0, uiWidth/2 - 145, 0, uiHeight*0.2)
    chronixText.TextColor3 = Color3.new(1, 1, 1)
    chronixText.BackgroundTransparency = 1
    chronixText.Font = Enum.Font.SourceSansBold
    chronixText.TextSize = 28
    chronixText.Parent = frame

    -- V3 文本
    local v3Text = Instance.new("TextLabel")
    v3Text.Text = "V3"
    v3Text.Size = UDim2.new(0, 65, 0, 45)
    v3Text.Position = UDim2.new(0, uiWidth/2 + 75, 0, uiHeight*0.2)
    v3Text.TextColor3 = Color3.new(0.8, 1, 0.5)
    v3Text.BackgroundTransparency = 1
    v3Text.Font = Enum.Font.SourceSansBold
    v3Text.TextSize = 28
    v3Text.Parent = frame

    -- 加载文本
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "加载中... 0%"
    loadingText.Size = UDim2.new(0, 230, 0, 32)
    loadingText.Position = UDim2.new(0, uiWidth/2 - 115, 0, uiHeight*0.6)
    loadingText.TextColor3 = Color3.new(1, 1, 1)
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 16
    loadingText.Parent = frame

    -- 创建进度条
    local progressBarBackground = Instance.new("Frame")
    progressBarBackground.Size = UDim2.new(0, uiWidth*0.8, 0, 5)
    progressBarBackground.Position = UDim2.new(0, uiWidth*0.1, 0, uiHeight*0.75)
    progressBarBackground.BackgroundTransparency = 1
    progressBarBackground.Parent = frame

    -- 进度条背景边框
    local progressBorder = Instance.new("UIStroke")
    progressBorder.Color = Color3.new(0, 0, 0)
    progressBorder.Thickness = 1
    progressBorder.Parent = progressBarBackground

    -- 进度条背景圆角
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0.5, 0)
    progressBgCorner.Parent = progressBarBackground

    -- 进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 5)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.new(0.8, 1, 0.5)
    progressBar.Parent = progressBarBackground

    -- 进度条圆角
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0)
    progressCorner.Parent = progressBar

    -- 创建取消按钮
    local cancelButton
    if showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = "✕"
        cancelButton.Size = UDim2.new(0, 28, 0, 28)
        cancelButton.Position = UDim2.new(0, uiWidth - 38, 0, 8)
        cancelButton.TextColor3 = Color3.new(1, 1, 1)
        cancelButton.BackgroundTransparency = 0.8
        cancelButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.TextSize = 15
        cancelButton.Parent = frame

        -- 取消按钮圆角
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0.2, 0)
        cancelCorner.Parent = cancelButton
    end

    -- 动画协程
    coroutine.wrap(function()
        -- 界面划入动画
        local TweenService = game:GetService("TweenService")
        local slideIn = TweenService:Create(
            frame, 
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        -- 进度更新
        local isCancelled = false
        local progressSteps = {0, 0.2, 0.5, 0.9, 1}
        local stepDurations = {1.0, 1.0, 1.0, 1.0}
        local pauseDurations = {2.0, 1.0, 1.0}

        -- 取消按钮事件
        if cancelButton then
            cancelButton.MouseButton1Click:Connect(function()
                isCancelled = true
                -- 停止音乐
                if loadingSound then
                    loadingSound:Stop()
                    loadingSound:Destroy()
                end
                -- 界面滑出
                local slideOut = TweenService:Create(
                    frame, 
                    TweenInfo.new(0.4, Enum.EasingStyle.Quad),
                    {Position = UDim2.new(1.5, 0, 0.5, -uiHeight/2)}
                )
                slideOut:Play()
                slideOut.Completed:Wait()
                screenGui:Destroy()
                onComplete(true)
            end)
        end

        -- 悬停效果
        if cancelButton then
            cancelButton.MouseEnter:Connect(function()
                cancelButton.BackgroundTransparency = 0.6
                cancelButton.TextColor3 = Color3.new(0.8, 1, 0.5)
            end)
            cancelButton.MouseLeave:Connect(function()
                cancelButton.BackgroundTransparency = 0.8
                cancelButton.TextColor3 = Color3.new(1, 1, 1)
            end)
        end

        -- 进度条动画
        for i = 1, #progressSteps - 1 do
            if isCancelled then break end
            
            local startProgress = progressSteps[i]
            local endProgress = progressSteps[i + 1]
            local targetWidth = endProgress * uiWidth * 0.8

            -- 进度条动画
            local progressTween = TweenService:Create(
                progressBar,
                TweenInfo.new(stepDurations[i], Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, targetWidth, 0, 5)}
            )
            progressTween:Play()

            -- 更新文本
            local startTime = tick()
            while tick() - startTime < stepDurations[i] and not isCancelled do
                local elapsed = tick() - startTime
                local tweenProgress = elapsed / stepDurations[i]
                local currentProgress = startProgress + (endProgress - startProgress) * tweenProgress
                local displayProgress = math.floor(currentProgress * 100)
                loadingText.Text = "加载中... " .. displayProgress .. "%"
                wait(0.05)
            end

            -- 卡顿
            if i < #pauseDurations and not isCancelled then
                local displayProgress = math.floor(endProgress * 100)
                loadingText.Text = "加载中... " .. displayProgress .. "%"
                wait(pauseDurations[i])
            end
        end

        -- 完成
        if not isCancelled then
            loadingText.Text = "加载完毕!"
            progressBar.Size = UDim2.new(0, uiWidth * 0.8, 0, 5)
            if cancelButton then
                cancelButton.Parent = nil
            end

            -- 音乐跳转
            if loadingSound then
                loadingSound.TimePosition = 128
            end

            wait(0.5)
            loadingText.Text = "加载中... 100%"

            -- 界面滑出
            local slideOut = TweenService:Create(
                frame, 
                TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(-0.5, 0, 0.5, -uiHeight/2)}
            )
            slideOut:Play()
            slideOut.Completed:Wait()

            screenGui:Destroy()
            onComplete(false)
        end
    end)()
end

return LoadAnimationModule