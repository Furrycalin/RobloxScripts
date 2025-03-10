local CustomMovementModule = {}

-- 依赖服务
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 默认配置
local moveSpeed = 16 -- 默认移动速度
local isCustomMovementEnabled = false -- 控制开关
local moveDirection = Vector3.zero -- 当前移动方向

-- 玩家角色相关
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 自定义移动函数
local function CustomMovement()
    if not isCustomMovementEnabled or not rootPart or not humanoid then
        return
    end

    -- 计算移动向量
    local moveVector = moveDirection * moveSpeed * RunService.Heartbeat:Wait()

    -- 碰撞检测
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(rootPart.Position, moveVector, raycastParams)

    if raycastResult then
        -- 如果有碰撞，调整移动向量
        moveVector = (raycastResult.Position - rootPart.Position).Unit * moveSpeed * RunService.Heartbeat:Wait()
    end

    -- 更新位置
    rootPart.CFrame = rootPart.CFrame + moveVector
end

-- 处理输入
local function HandleInput(input, gameProcessed)
    if gameProcessed then return end

    -- 键盘输入
    if input.KeyCode == Enum.KeyCode.W then
        moveDirection = Vector3.new(0, 0, -1) -- 向前移动
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDirection = Vector3.new(0, 0, 1) -- 向后移动
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDirection = Vector3.new(-1, 0, 0) -- 向左移动
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDirection = Vector3.new(1, 0, 0) -- 向右移动
    end
end

-- 处理触摸屏输入（虚拟摇杆）
local function HandleTouchInput(input, gameProcessed)
    if gameProcessed then return end

    -- 检测虚拟摇杆输入
    if input.UserInputType == Enum.UserInputType.Touch then
        local touchPosition = input.Position
        -- 这里可以根据虚拟摇杆的逻辑计算移动方向
        -- 例如：moveDirection = CalculateJoystickDirection(touchPosition)
    end
end

-- 处理游戏手柄输入
local function HandleGamepadInput(input, gameProcessed)
    if gameProcessed then return end

    -- 检测游戏手柄摇杆输入
    if input.UserInputType == Enum.UserInputType.Gamepad1 then
        local thumbstick = input.Position
        moveDirection = Vector3.new(thumbstick.X, 0, -thumbstick.Y) -- 根据摇杆输入计算方向
    end
end

-- 绑定输入事件
UserInputService.InputBegan:Connect(HandleInput)
UserInputService.InputChanged:Connect(HandleTouchInput)
UserInputService.InputChanged:Connect(HandleGamepadInput)

-- 每帧更新移动
RunService.Heartbeat:Connect(function()
    if moveDirection.Magnitude > 0 then
        CustomMovement()
    end
end)

-- 控制开关函数
function CustomMovementModule:SetCustomMovementEnabled(enabled)
    isCustomMovementEnabled = enabled
    if enabled then
        -- 禁用原版移动逻辑
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    else
        -- 启用原版移动逻辑
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    end
end

-- 设置移动速度
function CustomMovementModule:SetSpeed(speed)
    moveSpeed = speed
end

-- 初始化函数（可选）
function CustomMovementModule:Init()
    -- 可以在这里添加初始化逻辑
    print("Custom Movement Module Initialized")
end

return CustomMovementModule