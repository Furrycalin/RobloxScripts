local tpWalk = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 状态变量
local teleportDistance = 0.1
local isTeleporting = false

-- 运行时变量（功能启用时才赋值）
local currentCharacter = nil
local currentHumanoid = nil
local currentRootPart = nil
local heartbeatConnection = nil
local characterAddedConnection = nil

-- 安全获取有效角色（真正需要时才调用）
local function getValidCharacter()
    local char = player.Character
    
    -- 等待一个真正有效的角色
    while not (char and char.Parent) do
        char = player.CharacterAdded:Wait()
    end
    
    return char
end

-- 安全获取 Humanoid 和 RootPart
local function getCharacterParts(char)
    if not char then return nil, nil, nil end
    
    -- 使用 FindFirstChild 而不是 WaitForChild，避免阻塞
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- 如果找不到，等待一小段时间再试
    local attempts = 0
    while (not hum or not hrp) and attempts < 10 do
        task.wait(0.1)
        hum = char:FindFirstChild("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
        attempts = attempts + 1
    end
    
    return hum, hrp
end

-- 禁用默认移动
local function disableMovement()
    if not currentHumanoid then return end
    
    local states = {
        "Climbing", "FallingDown", "Flying", "Freefall", "GettingUp",
        "Jumping", "Landed", "Physics", "PlatformStanding", "Ragdoll",
        "Running", "RunningNoPhysics", "Seated", "StrafingNoPhysics", "Swimming"
    }
    
    for _, state in ipairs(states) do
        pcall(function()
            currentHumanoid:SetStateEnabled(Enum.HumanoidStateType[state], false)
        end)
    end
end

-- 启用默认移动
local function enableMovement()
    if not currentHumanoid then return end
    
    local states = {
        "Climbing", "FallingDown", "Flying", "Freefall", "GettingUp",
        "Jumping", "Landed", "Physics", "PlatformStanding", "Ragdoll",
        "Running", "RunningNoPhysics", "Seated", "StrafingNoPhysics", "Swimming"
    }
    
    for _, state in ipairs(states) do
        pcall(function()
            currentHumanoid:SetStateEnabled(Enum.HumanoidStateType[state], true)
        end)
    end
end

-- 传送逻辑
local function teleport()
    -- 每次传送前检查部件是否有效
    if not currentCharacter or not currentHumanoid or not currentRootPart then
        return
    end
    
    -- 额外检查：确保部件没有被销毁
    if not currentCharacter.Parent or not currentHumanoid.Parent or not currentRootPart.Parent then
        return
    end
    
    local moveDirection = currentHumanoid.MoveDirection
    if moveDirection.Magnitude == 0 then
        return
    end
    
    local teleportVector = moveDirection * teleportDistance
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {currentCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = Workspace:Raycast(currentRootPart.Position, teleportVector, raycastParams)
    
    if raycastResult then
        teleportVector = (raycastResult.Position - currentRootPart.Position).Unit * teleportDistance
    end
    
    pcall(function()
        currentRootPart.CFrame = currentRootPart.CFrame + teleportVector
    end)
end

-- 心跳循环
local function onHeartbeat()
    if isTeleporting and currentCharacter and currentHumanoid and currentRootPart then
        teleport()
    end
end

-- 初始化功能（只在第一次启用时调用）
local function initialize()
    if currentCharacter then return true end
    
    -- 等待并获取有效角色
    currentCharacter = getValidCharacter()
    currentHumanoid, currentRootPart = getCharacterParts(currentCharacter)
    
    if not currentHumanoid or not currentRootPart then
        currentCharacter = nil
        return false
    end
    
    -- 监听角色重生
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
    end
    
    characterAddedConnection = player.CharacterAdded:Connect(function(newChar)
        currentCharacter = newChar
        currentHumanoid, currentRootPart = getCharacterParts(newChar)
        
        if isTeleporting and currentHumanoid then
            disableMovement()
        end
    end)
    
    return true
end

-- 清理功能
local function cleanup()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end
    
    if currentHumanoid then
        pcall(enableMovement)
    end
    
    currentCharacter = nil
    currentHumanoid = nil
    currentRootPart = nil
end

-- 启用 TPWalk
function tpWalk:Enabled(enabled)
    if enabled == isTeleporting then return end
    
    isTeleporting = enabled
    
    if enabled then
        -- 延迟初始化：只在真正启用时才获取角色
        if not initialize() then
            isTeleporting = false
            return
        end
        
        disableMovement()
        
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
        end
    else
        enableMovement()
        -- 不断开心跳，但保留角色引用以便下次快速启用
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
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

-- 完全卸载
function tpWalk:Destroy()
    cleanup()
end

return tpWalk