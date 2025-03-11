local CustomMovementModule = {}

-- 依赖服务
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 默认配置
local moveSpeed = 16 -- 默认移动速度
local isCustomMovementEnabled = false -- 控制开关
local isMoving = false -- 是否正在移动

-- 玩家角色相关
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 禁用所有与移动相关的状态
local function DisableDefaultMovement()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
end

-- 启用所有与移动相关的状态
local function EnableDefaultMovement()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
end

-- 处理按键按下
local function HandleInputBegan(input, gameProcessed)
    if gameProcessed then return end

    -- 键盘输入
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        isMoving = true -- 开始移动
    end
end

-- 处理按键松开
local function HandleInputEnded(input, gameProcessed)
    if gameProcessed then return end

    -- 键盘输入
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        isMoving = false -- 停止移动
    end
end

-- 绑定输入事件
UserInputService.InputBegan:Connect(HandleInputBegan)
UserInputService.InputEnded:Connect(HandleInputEnded)

-- 自定义移动函数
local function CustomMovement()
    if not isCustomMovementEnabled or not rootPart or not humanoid then
        return
    end

    -- 获取玩家的局部移动方向
    local localMoveDirection = humanoid.MoveDirection
    if localMoveDirection.Magnitude == 0 or not isMoving then
        return -- 如果没有移动方向或未按下移动键，则停止移动
    end

    -- 将局部移动方向转换为全局移动方向
    local globalMoveDirection = rootPart.CFrame:VectorToWorldSpace(localMoveDirection)

    -- 计算移动向量
    local moveVector = globalMoveDirection * moveSpeed * RunService.Heartbeat:Wait()

    -- 检测地面高度
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local groundRaycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0), raycastParams)

    if groundRaycastResult then
        -- 如果有地面，调整玩家高度
        local groundHeight = groundRaycastResult.Position.Y
        local currentHeight = rootPart.Position.Y
        if currentHeight > groundHeight + 1 then
            -- 如果玩家高于地面，应用重力
            moveVector = moveVector + Vector3.new(0, -1, 0) * RunService.Heartbeat:Wait()
        else
            -- 如果玩家接近地面，保持在地面上
            rootPart.Position = Vector3.new(rootPart.Position.X, groundHeight + 1, rootPart.Position.Z)
        end
    end

    -- 检测前方是否有障碍物
    local forwardRaycastResult = workspace:Raycast(rootPart.Position, moveVector, raycastParams)

    if forwardRaycastResult then
        -- 如果有障碍物，调整移动向量
        moveVector = (forwardRaycastResult.Position - rootPart.Position).Unit * moveSpeed * RunService.Heartbeat:Wait()
    end

    -- 更新位置
    rootPart.CFrame = rootPart.CFrame + moveVector
end

-- 每帧更新移动
RunService.Heartbeat:Connect(CustomMovement)

-- 控制开关函数
function CustomMovementModule:SetCustomMovementEnabled(enabled)
    isCustomMovementEnabled = enabled
    if enabled then
        DisableDefaultMovement()
    else
        EnableDefaultMovement()
    end
end

-- 设置移动速度
function CustomMovementModule:SetSpeed(speed)
    moveSpeed = speed
end

-- 初始化函数（可选）
function CustomMovementModule:Init()
    print("Custom Movement Module Initialized")
end

return CustomMovementModule