-- 备注：实现透明渐变效果

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local screenGui = player:FindFirstChild("PlayerGui"):FindFirstChild("GradientScreenGui")

-- 创建 ScreenGui
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GradientScreenGui"
    screenGui.Parent = player.PlayerGui
end

-- 创建 Frame
local frame = Instance.new("Frame")
frame.Name = "GradientFrame"
frame.Size = UDim2.new(0, 300, 0, 200) -- 设置大小
frame.Position = UDim2.new(0.5, -150, 0.5, -100) -- 居中
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 1 -- 设置背景透明
frame.Parent = screenGui

-- 添加 UIGradient
local gradient = Instance.new("UIGradient")
gradient.Name = "Gradient"
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))  -- 红色
})
gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0), -- 完全不透明
    NumberSequenceKeypoint.new(1, 1)  -- 完全透明
})
gradient.Rotation = 0 -- 设置渐变方向（水平）
gradient.Parent = frame

-- 设置 Frame 的背景颜色为透明，以便显示渐变
frame.BackgroundTransparency = 0










-- 高级按钮实例

-- 创建高级按钮的函数
local function createAdvancedButton(text, size, position, callback)
    -- 创建按钮
    local button = Instance.new("TextButton")
    button.Name = "AdvancedButton"
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundTransparency = 1
    button.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
    button.TextScaled = true
    button.Font = Enum.Font.FredokaOne -- 卡通字体
    button.Parent = contentArea

    -- 圆角效果
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = button

    -- 白色边框
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1) -- 白色
    stroke.Thickness = 2
    stroke.Parent = button

    -- 渐变填充
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.8, 1)), -- 浅蓝色
        ColorSequenceKeypoint.new(1, Color3.new(1, 0.5, 0.2))  -- 橙色
    })
    gradient.Rotation = 45 -- 斜向渐变
    gradient.Parent = button

    -- 鼠标悬停效果
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), { Size = size + UDim2.new(0, 10, 0, 10) })
        tween:Play()
    end)

    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), { Size = size })
        tween:Play()
    end)

    -- 点击果冻弹动效果
    button.MouseButton1Click:Connect(function()
        local tween1 = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = size - UDim2.new(0, 10, 0, 10) })
        local tween2 = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = size })
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()

        -- 粒子效果
        for i = 1, 10 do
            local particle = Instance.new("Frame")
            particle.Name = "Particle"
            particle.Size = UDim2.new(0, 10, 0, 10)
            particle.Position = UDim2.new(0.5, -5, 0.5, -5)
            particle.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()) -- 随机颜色
            particle.BackgroundTransparency = 0
            particle.Parent = button

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle

            local tween = TweenService:Create(particle, TweenInfo.new(0.5)), {
                Position = UDim2.new(math.random(), -5, math.random(), -5),
                BackgroundTransparency = 1
            })
            tween:Play()

            tween.Completed:Connect(function()
                particle:Destroy()
            end)
        end

        uiclicker:Play()

        if callback then
            callback()
        end
    end)

    return button
end

-- 示例：创建一个高级按钮
local button = createAdvancedButton(
    "Click Me!", -- 按钮文本
    UDim2.new(0, 200, 0, 50), -- 按钮大小
    UDim2.new(0.5, -100, 0.5, -25) -- 按钮位置
)