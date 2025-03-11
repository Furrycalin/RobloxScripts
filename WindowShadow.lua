local WindowShadowModule = {}

-- 依赖服务
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 默认配置
local shadowTransparency = 0.8 -- 阴影透明度
local shadowThickness = 2 -- 阴影厚度
local shadowColor = Color3.fromRGB(0, 0, 0) -- 阴影颜色

-- 创建阴影
local function CreateShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 0, 0, 0)
    shadow.ZIndex = -1
    shadow.Parent = parent

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadow

    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Rotation = 90
    shadowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, shadowTransparency),
        NumberSequenceKeypoint.new(1, 1)
    })
    shadowGradient.Parent = shadow

    return shadow
end

-- 更新阴影
local function UpdateShadow(shadow, thickness)
    shadow.Size = UDim2.new(1, thickness * 2, 1, thickness * 2)
    shadow.Position = UDim2.new(0, -thickness, 0, -thickness)
end

-- 初始化阴影
function WindowShadowModule:Init(parent, thickness, color)
    local shadow = CreateShadow(parent)
    shadowThickness = thickness or shadowThickness
    shadowColor = color or shadowColor

    -- 更新阴影样式
    shadow.BackgroundColor3 = shadowColor
    UpdateShadow(shadow, shadowThickness)

    -- 每帧更新阴影
    RunService.RenderStepped:Connect(function()
        UpdateShadow(shadow, shadowThickness)
    end)

    return shadow
end

return WindowShadowModule