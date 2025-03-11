local tpWalk = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local teleportDistance = 0.1 -- 每次传送的距离
local isTeleporting = false -- 是否正在传送

-- 自定义传送函数
local function Teleport()
    if not isTeleporting or not rootPart or not humanoid then
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

    local raycastResult = workspace:Raycast(rootPart.Position, teleportVector, raycastParams)

    if raycastResult then
        -- 如果有障碍物，调整传送向量
        teleportVector = (raycastResult.Position - rootPart.Position).Unit * teleportDistance
    end

    -- 更新位置
    rootPart.CFrame = rootPart.CFrame + teleportVector
end

-- 控制开关函数
function tpWalk:SetTeleportEnabled(enabled)
    isTeleporting = enabled
end

function tpWalk:SetSpeed(speed)
    teleportDistance = speed or 0.1
end

-- 处理按键按下
local function HandleInputBegan(input, gameProcessed)
    if gameProcessed then return end

    -- 键盘输入
    if input.KeyCode == Enum.KeyCode.E then
        SetTeleportEnabled(true)
    end
end

-- 处理按键松开
local function HandleInputEnded(input, gameProcessed)
    if gameProcessed then return end

    -- 键盘输入
    if input.KeyCode == Enum.KeyCode.E then
        SetTeleportEnabled(false)
    end
end

-- 绑定输入事件
UserInputService.InputBegan:Connect(HandleInputBegan)
UserInputService.InputEnded:Connect(HandleInputEnded)

-- 每帧更新传送
RunService.Heartbeat:Connect(function()
    if isTeleporting then
        Teleport()
    end
end)