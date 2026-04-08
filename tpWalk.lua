local tpWalk = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 不再于模块加载时立即获取 character, humanoid, rootPart
-- 改为定义安全获取函数

local teleportDistance = 0.1 -- 每次传送的距离
local isTeleporting = false -- 是否正在传送

-- 安全获取当前有效角色及其核心部件的函数
local function getCharacterParts()
    local char = player.Character
    if not char then
        return nil, nil, nil
    end

    -- 额外检查：确保角色没有被销毁 (Parent 不为 nil)
    if not char.Parent then
        return nil, nil, nil
    end

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then
        return nil, nil, nil
    end

    return char, hum, hrp
end

-- 禁用所有与移动相关的状态 (现在需要传入 humanoid)
local function DisableDefaultMovement(humanoid)
    if not humanoid then return end
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

-- 启用所有与移动相关的状态 (现在需要传入 humanoid)
local function EnableDefaultMovement(humanoid)
    if not humanoid then return end
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

-- 自定义传送函数
local function Teleport()
    if not isTeleporting then
        return
    end

    -- 每次传送前动态获取最新的角色部件
    local character, humanoid, rootPart = getCharacterParts()
    
    -- 如果任一核心部件无效，则安全退出
    if not character or not humanoid or not rootPart then
        return
    end

    -- 获取移动方向
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude == 0 then
        return -- 如果没有移动方向，则停止传送
    end

    -- 计算传送向量
    local teleportVector = moveDirection * teleportDistance

    -- 检测前方是否有障碍物
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = Workspace:Raycast(rootPart.Position, teleportVector, raycastParams)

    if raycastResult then
        -- 如果有障碍物，调整传送向量
        teleportVector = (raycastResult.Position - rootPart.Position).Unit * teleportDistance
    end

    -- 更新位置
    rootPart.CFrame = rootPart.CFrame + teleportVector
end

-- 控制开关函数
function tpWalk:Enabled(enabled)
    isTeleporting = enabled
    
    -- 在开关状态改变时，获取一次角色部件以设置/重置状态
    local _, humanoid = getCharacterParts()
    
    if enabled then
        DisableDefaultMovement(humanoid)
    else
        EnableDefaultMovement(humanoid)
    end
end

function tpWalk:GetEnabled()
    return isTeleporting
end

function tpWalk:SetSpeed(speed)
    teleportDistance = speed or 0.1
end

function tpWalk:GetSpeed()
    return teleportDistance
end

-- 每帧更新传送
RunService.Heartbeat:Connect(function()
    if isTeleporting then
        Teleport()
    end
end)

return tpWalk