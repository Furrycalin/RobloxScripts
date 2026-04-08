local tpWalk = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 安全获取有效角色的函数
local function getValidCharacter()
    local char = player.Character
    -- 关键：检查角色是否有效（Parent 不为 nil）
    while not (char and char.Parent) do
        char = player.CharacterAdded:Wait()
    end
    return char
end

local character = getValidCharacter()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local teleportDistance = 0.1
local isTeleporting = false

-- 禁用所有与移动相关的状态
local function DisableDefaultMovement()
    -- 重新获取 humanoid，确保它有效
    local hum = character and character:FindFirstChild("Humanoid")
    if not hum then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
end

-- 启用所有与移动相关的状态
local function EnableDefaultMovement()
    local hum = character and character:FindFirstChild("Humanoid")
    if not hum then return end
    
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
end

-- 自定义传送函数
local function Teleport()
    if not isTeleporting then return end
    
    -- 重新获取最新的 rootPart，确保它有效
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local moveDirection = hum.MoveDirection
    if moveDirection.Magnitude == 0 then return end

    local teleportVector = moveDirection * teleportDistance

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = Workspace:Raycast(hrp.Position, teleportVector, raycastParams)

    if raycastResult then
        teleportVector = (raycastResult.Position - hrp.Position).Unit * teleportDistance
    end

    hrp.CFrame = hrp.CFrame + teleportVector
end

-- 控制开关函数
function tpWalk:Enabled(enabled)
    isTeleporting = enabled
    if enabled then 
        DisableDefaultMovement() 
    else 
        EnableDefaultMovement() 
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

-- 监听角色重生，更新引用
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    if isTeleporting then
        DisableDefaultMovement()
    end
end)

-- 每帧更新传送
RunService.Heartbeat:Connect(function()
    if isTeleporting then
        Teleport()
    end
end)

return tpWalk