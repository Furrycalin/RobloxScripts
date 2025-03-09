local function LoadAnimation(duration)
    -- 获取屏幕的尺寸
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0.1, 0) -- 长度是屏幕的长度，宽度稍微宽一点
    frame.Position = UDim2.new(0, 0, 0.45, 0) -- 屏幕正中央
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 1 -- 初始完全透明
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Text = "ChronixHub V2"
    title.Size = UDim2.new(0.8, 0, 0.3, 0)
    title.Position = UDim2.new(0.1, 0, 0.1, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = frame

    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "加载中... 0%"
    loadingText.Size = UDim2.new(0.8, 0, 0.3, 0)
    loadingText.Position = UDim2.new(0.1, 0, 0.6, 0)
    loadingText.TextColor3 = Color3.new(1, 1, 1)
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 20
    loadingText.Parent = frame

    -- 动画：框从隐形变成半透明
    local fadeIn = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.5})
    fadeIn:Play()

    -- 动画：标题从左侧划入
    local titleSlideIn = game:GetService("TweenService"):Create(title, TweenInfo.new(0.1), {Position = UDim2.new(0.1, 0, 0.1, 0)})
    titleSlideIn:Play()

    -- 动画：加载文字从右侧划入
    local loadingSlideIn = game:GetService("TweenService"):Create(loadingText, TweenInfo.new(0.1), {Position = UDim2.new(0.1, 0, 0.6, 0)})
    loadingSlideIn:Play()

    -- 等待所有动画完成
    wait(0.6)

    -- 模拟加载进度
    local startTime = tick()
    while tick() - startTime < duration do
        local progress = (tick() - startTime) / duration
        loadingText.Text = "加载中... " .. math.floor(progress * 100) .. "%"
        wait(0.01)
    end
    loadingText.Text = "加载中... 100%"

    -- 动画：标题和加载文字反方向划出
    local titleSlideOut = game:GetService("TweenService"):Create(title, TweenInfo.new(0.5), {Position = UDim2.new(-1, 0, 0.1, 0)})
    local loadingSlideOut = game:GetService("TweenService"):Create(loadingText, TweenInfo.new(0.5), {Position = UDim2.new(2, 0, 0.6, 0)})
    titleSlideOut:Play()
    loadingSlideOut:Play()

    -- 等待划出动画完成
    wait(0.5)

    -- 动画：框消失
    local fadeOut = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fadeOut:Play()

    -- 等待框消失动画完成
    wait(0.5)

    -- 清除所有实例
    screenGui:Destroy()
end

-- 示例调用：加载动画持续5秒
LoadAnimation(5)