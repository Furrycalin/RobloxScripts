-- 持续获取目标实例的模块
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- 目标实例变量
local targetPart = nil

-- 寻找目标实例的函数（根据名称"Part"查找BasePart）
local function findBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "Part" and child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

-- 更新目标实例的引用
local function updateTargetPart()
    targetPart = findBall()
end

-- 初始获取一次
updateTargetPart()

-- 监听新实例添加到Workspace（当目标出现时立即捕获）
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Part" and child:IsA("BasePart") then
        targetPart = child
    end
end)

-- 监听实例从Workspace移除（当目标消失时清空引用）
Workspace.ChildRemoved:Connect(function(child)
    if child == targetPart then
        targetPart = nil
    end
end)

RunService.Heartbeat:Connect(updateTargetPart)

-- 获取玩家角色和人类对象
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 用于存储原始位置和朝向
local originalCFrame = nil

-- 按下R键的执行函数
local function onRAction()
    -- 如果目标实例无效，则报错并返回
    if not targetPart or not targetPart:IsDescendantOf(workspace) then
        warn("目标实例不存在！")
        return
    end

    -- 保存原始位置和朝向
    originalCFrame = rootPart.CFrame

    -- 第一步：模拟按下F键（触发装备动作，例如举起工具）
    local virtualInput = game:GetService("VirtualInputManager")
    virtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)

    -- 第二步：立即传送到目标实例的位置（保持角色朝向不变）
    local targetCFrame
    if targetPart:IsA("BasePart") then
        targetCFrame = targetPart.CFrame
    else
        targetCFrame = CFrame.new(targetPart:GetPivot().Position)
    end
    -- 保持原始朝向，只改变位置
    local newCFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + originalCFrame.LookVector)
    rootPart.CFrame = newCFrame

    -- 第三步：立即传送回原始位置和朝向
    rootPart.CFrame = originalCFrame
end

-- 绑定R键按下事件
local contextActionService = game:GetService("ContextActionService")
local BIND_ACTION_NAME = "QuickTeleportAndF"

-- 定义绑定动作的处理函数
local function handleAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        onRAction()
        return Enum.ContextActionResult.Pass
    end
    return Enum.ContextActionResult.Pass
end

-- 绑定R键，优先级较高以确保快速响应
contextActionService:BindAction(BIND_ACTION_NAME, handleAction, false, Enum.KeyCode.R)

-- 当角色重生时重新获取引用
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)