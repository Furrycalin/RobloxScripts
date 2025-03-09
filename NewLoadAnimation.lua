local function LoadAnimation(duration, config)
    -- 默认配置
    local defaultConfig = {
        titleText = "ChronixHub V2",
        loadingText = "加载中... ",
        backgroundColor = Color3.new(0, 0, 0),
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
        en = { title = "ChronixHub V2", loading = "Loading... ", cancel = "Cancel" },
        zh = { title = "ChronixHub V2", loading = "加载中... ", cancel = "取消" }
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

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0.1, 0)
    frame.Position = UDim2.new(0, 0, 0.45, 0)
    frame.BackgroundColor3 = config.backgroundColor
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Text = config.titleText
    title.Size = UDim2.new(0.8, 0, 0.3, 0)
    title.Position = UDim2.new(-1, 0, 0.1, 0) -- 初始位置在左侧
    title.TextColor3 = config.textColor
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = frame

    local loadingText = Instance.new("TextLabel")
    loadingText.Text = config.loadingText .. "0%"
    loadingText.Size = UDim2.new(0.8, 0, 0.3, 0)
    loadingText.Position = UDim2.new(2, 0, 0.6, 0) -- 初始位置在右侧
    loadingText.TextColor3 = config.textColor
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 20
    loadingText.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0.05, 0)
    progressBar.Position = UDim2.new(0.1, 0, 0.8, 0)
    progressBar.BackgroundColor3 = Color3.new(0, 1, 0)
    progressBar.Parent = frame

    local cancelButton
    if config.showCancelButton then
        cancelButton = Instance.new("TextButton")
        cancelButton.Text = cancelText
        cancelButton.Size = UDim2.new(0.1, 0, 0.3, 0)
        cancelButton.Position = UDim2.new(0.8, 0, 0.1, 0)
        cancelButton.TextColor3 = config.textColor
        cancelButton.BackgroundTransparency = 1
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.TextSize = 18
        cancelButton.Parent = frame
    end

    -- 动画：框从隐形变成半透明
    local fadeIn = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
    fadeIn:Play()

    -- 动画：标题从左侧划入
    local titleSlideIn = game:GetService("TweenService"):Create(title, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(0.1, 0, 0.1, 0)})
    titleSlideIn:Play()

    -- 动画：加载文字从右侧划入
    local loadingSlideIn = game:GetService("TweenService"):Create(loadingText, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(0.1, 0, 0.6, 0)})
    loadingSlideIn:Play()

    -- 性能优化：使用 Completed 事件替代 wait
    fadeIn.Completed:Wait()
    titleSlideIn.Completed:Wait()
    loadingSlideIn.Completed:Wait()

    -- 模拟加载进度
    local startTime = tick()
    local isCancelled = false

    if config.showCancelButton then
        cancelButton.MouseButton1Click:Connect(function()
            isCancelled = true
            screenGui:Destroy()
            config.onComplete(true) -- 传入 true 表示加载被取消
        end)
    end

    while tick() - startTime < duration and not isCancelled do
        local progress = (tick() - startTime) / duration
        loadingText.Text = config.loadingText .. math.floor(progress * 100) .. "%"
        progressBar.Size = UDim2.new(progress, 0, 0.05, 0)
        wait(0.01)
    end

    if not isCancelled then
        loadingText.Text = config.loadingText .. "100%"
        progressBar.Size = UDim2.new(1, 0, 0.05, 0)

        -- 动画：标题和加载文字反方向划出
        local titleSlideOut = game:GetService("TweenService"):Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(-1, 0, 0.1, 0)})
        local loadingSlideOut = game:GetService("TweenService"):Create(loadingText, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(2, 0, 0.6, 0)})
        titleSlideOut:Play()
        loadingSlideOut:Play()

        -- 动画：框消失
        local fadeOut = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        fadeOut:Play()

        -- 等待动画完成
        fadeOut.Completed:Wait()

        -- 清除所有实例
        screenGui:Destroy()

        -- 调用完成回调
        config.onComplete(false) -- 传入 false 表示加载完成
    end
end

-- 示例调用
LoadAnimation(5, {
    titleText = "ChronixHub V2",
    loadingText = "加载中... ",
    backgroundColor = Color3.new(0, 0, 0),
    textColor = Color3.new(1, 1, 1),
    language = "zh",
    onComplete = function(isCancelled)
        if isCancelled then
            print("加载被取消")
        else
            print("加载完成")
        end
    end,
    showCancelButton = true
})