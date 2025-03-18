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