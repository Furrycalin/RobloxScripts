-- DoorsNotificationModule.lua
-- 模块化的消息框组件，支持外部传参调用

local DoorsNotification = {}
DoorsNotification.__index = DoorsNotification

-- 创建新消息框的函数
-- 参数:
--   parent - 父容器
--   text - 消息文本
--   duration - 显示时长(秒)，可选，默认5秒
--   textColor - 文本颜色，可选，默认白色
--   bgColor - 背景颜色，可选，默认深灰色
function DoorsNotification.new(parent, text, duration, textColor, bgColor)
    local self = setmetatable({}, DoorsNotification)
    
    -- 设置默认值
    duration = duration or 5
    textColor = textColor or Color3.new(1, 1, 1)
    bgColor = bgColor or Color3.new(0.15, 0.15, 0.15)
    
    -- 创建主框架
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "NotificationFrame"
    self.Frame.Parent = parent
    self.Frame.BackgroundColor3 = bgColor
    self.Frame.BorderSizePixel = 0
    self.Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.Size = UDim2.new(0, 300, 0, 60)
    self.Frame.ClipsDescendants = true
    self.Frame.ZIndex = 100
    
    -- 添加圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Frame
    
    -- 添加阴影
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.new(0, 0, 0)
    shadow.Transparency = 0.5
    shadow.Thickness = 2
    shadow.Parent = self.Frame
    
    -- 创建文本标签
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Name = "NotificationText"
    self.TextLabel.Parent = self.Frame
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
    self.TextLabel.Position = UDim2.new(0, 0, 0, 0)
    self.TextLabel.Text = text
    self.TextLabel.TextColor3 = textColor
    self.TextLabel.TextScaled = true
    self.TextLabel.TextWrapped = true
    self.TextLabel.Font = Enum.Font.SourceSans
    self.TextLabel.ZIndex = 101
    
    -- 设置动画
    self.Frame.Visible = false
    self.Frame.Position = UDim2.new(0.5, 0, 1, 0)
    
    -- 播放显示动画
    self:show()
    
    -- 设置自动消失
    task.delay(duration, function()
        self:hide()
    end)
    
    return self
end

-- 显示消息框的动画
function DoorsNotification:show()
    self.Frame.Visible = true
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = tweenService:Create(
        self.Frame,
        tweenInfo,
        {Position = UDim2.new(0.5, 0, 0.8, 0)}
    )
    tween:Play()
end

-- 隐藏消息框的动画并销毁
function DoorsNotification:hide()
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
    local tween = tweenService:Create(
        self.Frame,
        tweenInfo,
        {Position = UDim2.new(0.5, 0, 1, 0), Transparency = 1}
    )
    tween:Play()
    tween.Completed:Wait()
    self.Frame:Destroy()
end

-- 快捷创建消息框的函数
-- 无需手动管理实例，直接创建并显示
function DoorsNotification.Show(parent, text, duration, textColor, bgColor)
    return DoorsNotification.new(parent, text, duration, textColor, bgColor)
end

return DoorsNotification
