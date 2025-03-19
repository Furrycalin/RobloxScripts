local chatControl = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/chat_test.lua"))()
local translateModuel = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/translateModuel.lua"))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 创建自定义聊天栏
local function createCustomChat()
    local translateAPI = "YouDao"
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

    -- 创建侧边栏
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
    sideBar.Size = UDim2.new(0.1, 0, 1, 0) -- 宽度 10%，高度 100%
    sideBar.Position = UDim2.new(1, 0, 0, 0) -- 右侧
    sideBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- 背景颜色
    sideBar.BackgroundTransparency = 0.5 -- 背景透明度
    sideBar.Parent = chatFrame

    -- 创建侧边栏标题
    local sideBarTitle = Instance.new("TextLabel")
    sideBarTitle.Name = "SideBarTitle"
    sideBarTitle.Size = UDim2.new(1, 0, 0.1, 0) -- 宽度 100%，高度 10%
    sideBarTitle.Position = UDim2.new(0, 0, 0, 0)
    sideBarTitle.BackgroundTransparency = 1 -- 背景透明
    sideBarTitle.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    sideBarTitle.Text = "翻译器" -- 标题文字
    sideBarTitle.TextXAlignment = Enum.TextXAlignment.Center -- 文字居中
    sideBarTitle.Parent = sideBar

    -- 创建按钮容器
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, 0, 0.9, 0) -- 宽度 100%，高度 90%
    buttonContainer.Position = UDim2.new(0, 0, 0.1, 0)
    buttonContainer.BackgroundTransparency = 1 -- 背景透明
    buttonContainer.Parent = sideBar

    -- 创建按钮布局
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.Padding = UDim.new(0, 5) -- 按钮间距
    buttonLayout.Parent = buttonContainer

    -- 添加按钮的函数
    local function addButtonToSideBar(buttonName, onClick)
        local button = Instance.new("TextButton")
        button.Name = buttonName
        button.Size = UDim2.new(1, 0, 0.1, 0) -- 宽度 100%，高度 10%
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
        button.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        button.Text = buttonName -- 按钮文字
        button.Parent = buttonContainer

        -- 点击按钮时高亮
        button.MouseButton1Click:Connect(function()
            -- 取消所有按钮的高亮
            for _, child in ipairs(buttonContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                end
            end
            -- 高亮当前按钮
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            -- 执行点击事件
            onClick()
        end)
    end

    -- 默认高亮第一个按钮
    local firstButton = nil

    -- 添加示例按钮
    addButtonToSideBar("有道翻译", function()
        translateAPI = "YouDao"
    end)

    addButtonToSideBar("AI翻译", function()
        translateAPI = "AI"
    end)

    -- 默认高亮第一个按钮
    firstButton = buttonContainer:FindFirstChildOfClass("TextButton")
    if firstButton then
        firstButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end

    -- 接收消息并显示
    chatControl:MessageReceiver(function(msgData)
        local msgtext = translateModuel:translateText(msgData.text, translateAPI)

        -- 创建消息容器
        local messageContainer = Instance.new("Frame")
        messageContainer.Name = "MessageContainer"
        messageContainer.Size = UDim2.new(1, 0, 0, 20) -- 宽度 100%，高度 20
        messageContainer.BackgroundTransparency = 1 -- 背景透明
        messageContainer.Parent = scrollingFrame

        -- 创建消息文本
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "MessageLabel"
        messageLabel.Size = UDim2.new(0.8, 0, 1, 0) -- 宽度 80%，高度 100%
        messageLabel.Position = UDim2.new(0, 0, 0, 0)
        messageLabel.BackgroundTransparency = 1 -- 背景透明
        messageLabel.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        messageLabel.Text = msgData.sender .. ": " .. msgtext -- 消息内容
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
        messageLabel.Parent = messageContainer

        -- 创建按钮
        local editButton = Instance.new("TextButton")
        editButton.Name = "翻译"
        editButton.Size = UDim2.new(0.2, 0, 1, 0) -- 宽度 20%，高度 100%
        editButton.Position = UDim2.new(0.8, 0, 0, 0)
        editButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
        editButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        editButton.Text = "翻译" -- 按钮文字
        editButton.Parent = messageContainer

        -- 点击按钮触发代码
        editButton.MouseButton1Click:Connect(function()
            messageLabel.Text = msgData.sender .. ": " .. translateModuel:translateText(msgData.text, translateAPI)
        end)

        -- 滚动到最下面
        -- scrollingFrame.CanvasPosition = Vector2.new(0, 9999999)
    end)

    -- 创建切换按钮
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleChatButton"
    toggleButton.Size = UDim2.new(0.05, 0, 0.05, 0) -- 按钮大小
    toggleButton.Position = UDim2.new(0.95, 0, 0.95, 0) -- 放置在右下角
    toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    toggleButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    toggleButton.Text = "切换" -- 按钮文字
    toggleButton.Parent = screenGui

    -- 切换聊天栏显示/隐藏
    toggleButton.MouseButton1Click:Connect(function()
        chatFrame.Visible = not chatFrame.Visible
    end)
end

-- 初始化自定义聊天栏
createCustomChat()