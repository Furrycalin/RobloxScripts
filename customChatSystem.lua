local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local module = {}

-- 内部状态
local enabled = false          -- 功能开关
local moveDistance = 10        -- 默认平移距离
local connection = nil         -- 输入事件连接

-- 获取玩家角色的根部件（HumanoidRootPart 或 PrimaryPart）
local function getRootPart(character)
    return character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
end

-- 方向键按下时的处理函数
local function onInputBegan(input, gameProcessed)
    -- 如果已被其他输入处理（如聊天框）或功能未开启，则忽略
    if gameProcessed or not enabled then return end
    -- 如果玩家正在输入文字，也忽略
    if UserInputService:GetFocusedTextBox() then return end

    local keyCode = input.KeyCode
    -- 仅响应方向键
    if not (keyCode == Enum.KeyCode.Up or keyCode == Enum.KeyCode.Down or
            keyCode == Enum.KeyCode.Left or keyCode == Enum.KeyCode.Right) then
        return
    end

    -- 获取当前角色和根部件
    local character = localPlayer.Character
    if not character then return end
    local rootPart = getRootPart(character)
    if not rootPart then return end

    -- 根据方向键计算位移向量
    local moveVec
    if keyCode == Enum.KeyCode.Up then
        moveVec = rootPart.CFrame.LookVector * moveDistance      -- 前
    elseif keyCode == Enum.KeyCode.Down then
        moveVec = -rootPart.CFrame.LookVector * moveDistance     -- 后
    elseif keyCode == Enum.KeyCode.Left then
        moveVec = -rootPart.CFrame.RightVector * moveDistance    -- 左
    elseif keyCode == Enum.KeyCode.Right then
        moveVec = rootPart.CFrame.RightVector * moveDistance     -- 右
    end

    -- 保持 Y 轴高度不变
    moveVec = Vector3.new(moveVec.X, 0, moveVec.Z)

    -- 移动根部件（瞬间平移）
    rootPart.CFrame = rootPart.CFrame + moveVec
end

-- 启用平移功能
function module.Enable()
    if enabled then return end
    enabled = true
    if not connection then
        connection = UserInputService.InputBegan:Connect(onInputBegan)
    end
end

-- 禁用平移功能
function module.Disable()
    enabled = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- 设置每次平移的距离（必须为非负数）
function module.SetDistance(distance)
    assert(type(distance) == "number" and distance >= 0, "Distance must be a non-negative number")
    moveDistance = distance
end

-- 获取当前平移距离
function module.GetDistance()
    return moveDistance
end

return module