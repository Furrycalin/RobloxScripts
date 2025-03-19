local chatControl = 

-- 创建自定义聊天栏
local function createCustomChat()
    -- 创建 ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomChat"
    screenGui.Parent = player.PlayerGui

    -- 创建聊天栏背景
    local chatFrame = Instance.new("Frame")
    chatFrame.Name = "ChatFrame"
    chatFrame.Size = UDim2.new(0.3, 0, 0.4, 0) -- 宽度 30%，高度 40%
    chatFrame.Position = UDim2.new(0, 10, 0, 10) -- 左上角
    chatFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- 背景颜色
    chatFrame.BackgroundTransparency = 0.5 -- 背景透明度
    chatFrame.Parent = screenGui

    -- 创建消息滚动区域
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "MessageScroll"
    scrollingFrame.Size = UDim2.new(1, 0, 0.9, 0) -- 宽度 100%，高度 90%
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1 -- 背景透明
    scrollingFrame.ScrollBarThickness = 5 -- 滚动条宽度
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始内容大小
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- 自动调整内容高度
    scrollingFrame.Parent = chatFrame

    -- 创建消息布局
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5) -- 消息间距
    uiListLayout.Parent = scrollingFrame

    -- 创建输入栏
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(1, 0, 0.1, 0) -- 宽度 100%，高度 10%
    inputBox.Position = UDim2.new(0, 0, 0.9, 0) -- 底部
    inputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    inputBox.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    inputBox.PlaceholderText = "输入消息..." -- 提示文字
    inputBox.Parent = chatFrame

    -- 发送消息的逻辑
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local message = inputBox.Text
            if message ~= "" then
                chatControl:chat(message) -- 发送消息
                inputBox.Text = "" -- 清空输入框
            end
        end
    end)

    -- 接收消息并显示
    chatControl:MessageReceiver(function(msgData)
        -- 创建消息文本
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "MessageLabel"
        messageLabel.Size = UDim2.new(1, 0, 0, 20) -- 宽度 100%，高度 20
        messageLabel.BackgroundTransparency = 1 -- 背景透明
        messageLabel.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        messageLabel.Text = msgData.sender .. ": " .. msgData.text -- 消息内容
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
        messageLabel.Parent = scrollingFrame
    end)
end

-- 初始化自定义聊天栏
createCustomChat()