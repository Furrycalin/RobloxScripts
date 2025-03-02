local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 传送玩家
local function teleportPlayer(player, targetPlayer)
    local playerCharacter = player.Character
    local targetCharacter = targetPlayer.Character
    if playerCharacter and targetCharacter then
        local playerRoot = playerCharacter:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        if playerRoot and targetRoot then
            playerRoot.CFrame = targetRoot.CFrame
            log("已将玩家 " .. player.Name .. " 传送到玩家 " .. targetPlayer.Name, "info")
        else
            log("传送失败：玩家或目标玩家没有 HumanoidRootPart！", "error")
        end
    else
        log("传送失败：玩家或目标玩家没有角色！", "error")
    end
end

-- 根据 ID、玩家名或昵称获取玩家
local function getPlayerByIdOrName(identifier)
    -- 尝试按玩家名查找
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == identifier then
            return p
        end
    end

    -- 尝试按昵称查找
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName == identifier then
            return p
        end
    end

    -- 最后尝试按 ID 查找
    local playerId = tonumber(identifier)
    if playerId then
        return Players:GetPlayerByUserId(playerId)
    end

    return nil -- 未找到玩家
end

-- 处理指令
local function handleCommand(commandParts)
    local command = commandParts[1] -- 第一个部分是指令
    if command == "tp" then
        if #commandParts == 2 then
            -- 只有一个参数：将自己传送到目标玩家
            local target = commandParts[2]
            local targetPlayer = getPlayerByIdOrName(target)
            if targetPlayer then
                teleportPlayer(LocalPlayer, targetPlayer)
            else
                log("未找到玩家" .. target, "error")
            end
        elseif #commandParts == 3 then
            -- 有两个参数：将第一个玩家传送到第二个玩家
            local player1 = getPlayerByIdOrName(commandParts[2])
            local player2 = getPlayerByIdOrName(commandParts[3])
            if player1 and player2 then
                teleportPlayer(player1, player2)
            else
                log("未找到双方玩家.", "error")
            end
        elseif #commandParts == 4 then
            local x, y, z = tonumber(commandParts[2]), tonumber(commandParts[3]), tonumber(commandParts[4])
            if x and y and z then
                LocalPlayer.Character:MoveTo(Vector3.new(x, y, z))
                print("已传送到:", x, y, z)
            else
                log("错误的坐标.", "error")
            end
        else
            log("无效的参数数量.", "warning")
        end
    else
        log("未知指令.", "warning")
    end
end

-- 创建 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- 创建日志框
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(0.29, 0, 0.2, 0) -- 设置大小
logFrame.Position = UDim2.new(0.005, 0, 0.95, 0) -- 设置位置（聊天框上方）
logFrame.AnchorPoint = Vector2.new(0, 1) -- 锚点左下角
logFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
logFrame.BackgroundTransparency = 0.5 -- 半透明
logFrame.BorderSizePixel = 0 -- 无边框
logFrame.ScrollBarThickness = 6 -- 滚动条宽度
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- 自动调整内容高度
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始内容大小
logFrame.Parent = nil

-- 创建日志内容的 UIListLayout
local logLayout = Instance.new("UIListLayout")
logLayout.SortOrder = Enum.SortOrder.LayoutOrder -- 按顺序排列
logLayout.Parent = logFrame

-- 创建日志内容的 Padding
local logPadding = Instance.new("UIPadding")
logPadding.PaddingLeft = UDim.new(0, 5) -- 左边距
logPadding.PaddingTop = UDim.new(0, 5) -- 上边距
logPadding.Parent = logFrame

-- 定义 log 函数
local function log(message, color)
    -- 默认颜色为白色
    local textColor = Color3.new(1, 1, 1) -- 白色

    -- 根据传入的 color 参数设置颜色
    if type(color) == "string" then
        if color == "warning" then
            textColor = Color3.new(1, 1, 0) -- 黄色
        elseif color == "error" then
            textColor = Color3.new(1, 0, 0) -- 红色
        elseif color == "info" then
            textColor = Color3.new(0.5, 0.8, 1) -- 淡蓝色
        end
    elseif type(color) == "table" and #color == 3 then
        -- 如果传入的是 RGB 色值
        textColor = Color3.new(color[1], color[2], color[3])
    end

    -- 创建日志标签
    local logLabel = Instance.new("TextLabel")
    logLabel.Text = message
    logLabel.TextColor3 = textColor -- 设置文字颜色
    logLabel.BackgroundTransparency = 1 -- 透明背景
    logLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
    logLabel.Font = Enum.Font.GothamBold -- 字体
    logLabel.TextSize = 14 -- 文字大小
    logLabel.Size = UDim2.new(1, -10, 0, 20) -- 设置大小（减去滚动条宽度）
    logLabel.LayoutOrder = #logFrame:GetChildren() -- 按顺序排列
    logLabel.Parent = logFrame

    -- 滚动到最下方
    logFrame.CanvasPosition = Vector2.new(0, logFrame.CanvasSize.Y.Offset)
end

-- 创建聊天输入框
local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.99, 0, 0.03, 0) -- 设置大小
chatBox.Position = UDim2.new(0.005, 0, 0.99, 0) -- 设置位置（屏幕下方）
chatBox.AnchorPoint = Vector2.new(0, 1) -- 锚点左下角
chatBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
chatBox.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
chatBox.BackgroundTransparency = 0.5
chatBox.TextXAlignment = Enum.TextXAlignment.Left
chatBox.Font = Enum.Font.GothamBold -- 字体
chatBox.TextSize = 18 -- 文字大小
chatBox.PlaceholderText = "输入指令（例如：tp 玩家ID/玩家名/昵称）..." -- 提示文字
chatBox.Visible = false -- 初始隐藏
chatBox.ClearTextOnFocus = false -- 点击输入框时不自动清空内容
chatBox.Parent = screenGui
chatBox.Text = ""

-- 监听按键输入
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- 忽略游戏内输入

    -- 按下 T 键显示或隐藏输入框
    if input.KeyCode == Enum.KeyCode.T then
        chatBox.Visible = not chatBox.Visible -- 切换输入框的可见性
		logFrame.Parent = chatBox.Visible and screenGui or nil
    end

    -- 按下 Delete 键卸载脚本
    if input.KeyCode == Enum.KeyCode.Delete then
        screenGui:Destroy() -- 销毁 ScreenGui
        script:Destroy() -- 卸载脚本
    end

    -- 按下回车键返回输入内容并隐藏输入框
    if input.KeyCode == Enum.KeyCode.Return and chatBox.Visible then
        local message = chatBox.Text -- 获取输入内容
        chatBox.Text = ""
        chatBox.Visible = false -- 隐藏输入框
		logFrame.Parent = nil
        chatBox:ReleaseFocus() -- 释放焦点

        -- 处理输入内容
        if message ~= "" then
            -- 以空格为分隔符返回一个集合
            local messageParts = {}
            for part in string.gmatch(message, "%S+") do
                table.insert(messageParts, part)
            end
            handleCommand(messageParts) -- 处理指令
            log("> " .. message) -- 将输入内容记录到日志
        end
    end
end)

-- 监听输入框的焦点变化
chatBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local message = chatBox.Text -- 获取输入内容
        chatBox.Text = "" -- 清空输入框内容
        chatBox.Visible = false -- 隐藏输入框
		logFrame.Parent = nil

        -- 处理输入内容
        if message ~= "" then
            -- 以空格为分隔符返回一个集合
            local messageParts = {}
            for part in string.gmatch(message, "%S+") do
                table.insert(messageParts, part)
            end
            handleCommand(messageParts) -- 处理指令
            log("> " .. message) -- 将输入内容记录到日志
        end
    end
end)