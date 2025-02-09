local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 配置常量
local CONFIG = {
    ARROW_SIZE = UDim2.new(0.03, 0, 0.03, 0), -- 更小的箭头
    ARROW_POSITION_HIDDEN = UDim2.new(0.5, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    ARROW_POSITION_VISIBLE = UDim2.new(0.5, 0, 0.97, 0), -- 贴近屏幕底部
    MENU_SIZE = UDim2.new(0.3, 0, 0.4, 0),
    MENU_POSITION_HIDDEN = UDim2.new(0.35, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    MENU_POSITION_VISIBLE = UDim2.new(0.35, 0, 0.6, 0), -- 点击箭头后弹出
    BACKGROUND_COLOR = Color3.fromRGB(40, 40, 40),
    BUTTON_COLOR = Color3.fromRGB(60, 60, 60),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    ARROW_TRANSPARENCY = 0.5, -- 半透明箭头
    TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
}

-- 创建箭头按钮
local arrowButton = Instance.new("TextButton")
arrowButton.Size = CONFIG.ARROW_SIZE
arrowButton.Position = CONFIG.ARROW_POSITION_HIDDEN
arrowButton.AnchorPoint = Vector2.new(0.5, 0.5)
arrowButton.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
arrowButton.BackgroundTransparency = CONFIG.ARROW_TRANSPARENCY
arrowButton.Text = "▲"
arrowButton.TextColor3 = CONFIG.TEXT_COLOR
arrowButton.TextSize = 14
arrowButton.ZIndex = 2
arrowButton.Parent = Gui

-- 创建菜单
local menuFrame = Instance.new("Frame")
menuFrame.Size = CONFIG.MENU_SIZE
menuFrame.Position = CONFIG.MENU_POSITION_HIDDEN
menuFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
menuFrame.ZIndex = 1
menuFrame.Parent = Gui

-- 圆角
local uiCorner = Instance.new("UICorner", menuFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- 添加菜单内容
local function AddMenuContent(category)
    -- 清空菜单内容
    for _, child in ipairs(menuFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    -- 添加分类按钮
    local categories = {"设置", "工具", "帮助"}
    for i, cat in ipairs(categories) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.8, 0, 0.1, 0)
        button.Position = UDim2.new(0.1, 0, 0.1 + (i - 1) * 0.15, 0)
        button.BackgroundColor3 = CONFIG.BUTTON_COLOR
        button.Text = cat
        button.TextColor3 = CONFIG.TEXT_COLOR
        button.TextSize = 18
        button.Parent = menuFrame

        button.MouseButton1Click:Connect(function()
            AddMenuContent(cat) -- 切换菜单内容
        end)
    end

    -- 根据分类添加内容
    if category == "设置" then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 0.1, 0)
        label.Position = UDim2.new(0.1, 0, 0.6, 0)
        label.BackgroundTransparency = 1
        label.Text = "设置内容"
        label.TextColor3 = CONFIG.TEXT_COLOR
        label.TextSize = 18
        label.Parent = menuFrame
    elseif category == "工具" then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 0.1, 0)
        label.Position = UDim2.new(0.1, 0, 0.6, 0)
        label.BackgroundTransparency = 1
        label.Text = "工具内容"
        label.TextColor3 = CONFIG.TEXT_COLOR
        label.TextSize = 18
        label.Parent = menuFrame
    elseif category == "帮助" then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 0.1, 0)
        label.Position = UDim2.new(0.1, 0, 0.6, 0)
        label.BackgroundTransparency = 1
        label.Text = "帮助内容"
        label.TextColor3 = CONFIG.TEXT_COLOR
        label.TextSize = 18
        label.Parent = menuFrame
    end
end

-- 箭头按钮滑入滑出逻辑
local function ToggleArrow(visible)
    local targetPosition = visible and CONFIG.ARROW_POSITION_VISIBLE or CONFIG.ARROW_POSITION_HIDDEN
    local tween = TweenService:Create(arrowButton, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
end

-- 菜单弹出逻辑
local function ToggleMenu(visible)
    local targetPosition = visible and CONFIG.MENU_POSITION_VISIBLE or CONFIG.MENU_POSITION_HIDDEN
    local tween = TweenService:Create(menuFrame, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
    if visible then
        ToggleArrow(false) -- 弹出菜单后隐藏箭头
    end
end

-- 鼠标移动检测
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseY = input.Position.Y
        local screenHeight = Gui.AbsoluteSize.Y
        if mouseY > screenHeight * 0.95 then -- 鼠标在屏幕底部 5% 区域
            ToggleArrow(true)
        else
            ToggleArrow(false)
        end
    end
end)

-- 点击菜单外部关闭菜单
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePosition = input.Position
        local menuPosition = menuFrame.AbsolutePosition
        local menuSize = menuFrame.AbsoluteSize
        if not (mousePosition.X >= menuPosition.X and mousePosition.X <= menuPosition.X + menuSize.X and
                mousePosition.Y >= menuPosition.Y and mousePosition.Y <= menuPosition.Y + menuSize.Y) then
            ToggleMenu(false)
        end
    end
end)

-- 点击箭头按钮弹出菜单
arrowButton.MouseButton1Click:Connect(function()
    ToggleMenu(true)
    AddMenuContent("设置") -- 默认显示“设置”分类
end)

-- 按下 Delete 键卸载菜单
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        Gui:Destroy() -- 卸载整个菜单系统
    end
end)