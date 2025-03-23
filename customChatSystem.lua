local translateModuel = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/translateModuel.lua"))()
local chatControl = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/chat_test.lua"))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local colorCache = {}

-- 颜色表
local colortable = {
    Color3.fromRGB(152, 109, 216), -- 原颜色：紫色（中等饱和度）
    Color3.fromRGB(237, 39, 64),   -- 原颜色：红色（高饱和度）
    Color3.fromRGB(3, 173, 82),    -- 原颜色：绿色（中等饱和度）
    Color3.fromRGB(239, 200, 47),  -- 原颜色：黄色（中等饱和度）
    Color3.fromRGB(227, 182, 196), -- 原颜色：粉红色（低饱和度）
    Color3.fromRGB(3, 143, 225),   -- 原颜色：蓝色（中等饱和度）
    Color3.fromRGB(211, 193, 151), -- 原颜色：米黄色（低饱和度）
    Color3.fromRGB(207, 126, 62),  -- 原颜色：橙色（中等饱和度）

    -- 新增的 10 个亮色
    Color3.fromRGB(255, 105, 180), -- 亮粉色（高饱和度）
    Color3.fromRGB(255, 165, 0),   -- 亮橙色（高饱和度）
    Color3.fromRGB(255, 215, 0),   -- 亮金色（高饱和度）
    Color3.fromRGB(173, 216, 230), -- 亮天蓝色（低饱和度）
    Color3.fromRGB(144, 238, 144), -- 亮绿色（低饱和度）
    Color3.fromRGB(255, 182, 193), -- 亮粉红色（低饱和度）
    Color3.fromRGB(240, 230, 140), -- 亮卡其色（低饱和度）
    Color3.fromRGB(221, 160, 221), -- 亮紫色（低饱和度）
    Color3.fromRGB(152, 251, 152), -- 亮薄荷绿（低饱和度）
    Color3.fromRGB(255, 239, 213), -- 亮米白色（低饱和度）

    -- 新增的 10 个新颖亮色
    Color3.fromRGB(255, 127, 80),  -- 珊瑚色（高饱和度）
    Color3.fromRGB(255, 99, 71),   -- 番茄色（高饱和度）
    Color3.fromRGB(255, 218, 185), -- 桃色（低饱和度）
    Color3.fromRGB(240, 128, 128), -- 亮珊瑚色（中等饱和度）
    Color3.fromRGB(255, 160, 122), -- 浅橙红色（中等饱和度）
    Color3.fromRGB(255, 228, 181), -- 杏仁色（低饱和度）
    Color3.fromRGB(255, 222, 173), -- 玉米色（低饱和度）
    Color3.fromRGB(255, 239, 213), -- 蛋壳色（低饱和度）
    Color3.fromRGB(240, 248, 255), -- 天青蓝（低饱和度）
    Color3.fromRGB(245, 245, 220),  -- 米黄色（低饱和度）

    -- 季节
    Color3.fromRGB(173, 255, 47), -- 春绿色（明亮、清新）
    Color3.fromRGB(255, 182, 193), -- 樱花粉（柔和、浪漫）
    Color3.fromRGB(255, 223, 186), -- 春日阳光（温暖、明亮）
    Color3.fromRGB(255, 215, 0), -- 夏日金黄（热烈、活力）
    Color3.fromRGB(0, 255, 255), -- 海洋蓝（清凉、透明）
    Color3.fromRGB(255, 99, 71), -- 夏日番茄红（热情、活力）
    Color3.fromRGB(255, 165, 0), -- 秋叶橙（温暖、丰收）
    Color3.fromRGB(210, 105, 30), -- 棕色（沉稳、自然）
    Color3.fromRGB(255, 69, 0), -- 枫叶红（鲜艳、醒目）
    Color3.fromRGB(173, 216, 230), -- 冰雪蓝（冷静、纯净）
    Color3.fromRGB(240, 248, 255), -- 雪白色（明亮、干净）
    Color3.fromRGB(135, 206, 250), -- 冬日天空蓝（清新、宁静）

    -- 心情
    Color3.fromRGB(255, 223, 0), -- 阳光黄（明亮、愉悦）
    Color3.fromRGB(255, 105, 180), -- 快乐粉（活泼、可爱）
    Color3.fromRGB(173, 216, 230), -- 天空蓝（宁静、放松）
    Color3.fromRGB(152, 251, 152), -- 薄荷绿（清新、平和）
    Color3.fromRGB(255, 69, 0), -- 火焰红（激情、活力）
    Color3.fromRGB(255, 140, 0), -- 橙色（热烈、兴奋）
    Color3.fromRGB(135, 206, 250), -- 浅蓝（柔和、安静）
    Color3.fromRGB(221, 160, 221), -- 淡紫（温柔、内敛）

    -- 水果
    Color3.fromRGB(255, 59, 48), -- 苹果红（鲜艳、醒目）
    Color3.fromRGB(155, 255, 155), -- 青苹果绿（清新、自然）
    Color3.fromRGB(255, 255, 102), -- 柠檬黄（明亮、活力）
    Color3.fromRGB(255, 105, 180), -- 草莓粉（甜美、可爱）
    Color3.fromRGB(255, 165, 0), -- 橙子橙（温暖、活力）
    Color3.fromRGB(79, 134, 247), -- 蓝莓蓝（深邃、自然）

    -- 植物
    Color3.fromRGB(34, 139, 34), -- 森林绿（自然、沉稳）
    Color3.fromRGB(152, 251, 152), -- 嫩叶绿（清新、生机）
    Color3.fromRGB(255, 105, 180), -- 樱花粉（浪漫、柔和）
    Color3.fromRGB(255, 20, 147), -- 玫瑰红（热情、艳丽）
    Color3.fromRGB(124, 252, 0), -- 草地绿（明亮、自然）
    Color3.fromRGB(0, 128, 0) -- 深绿（沉稳、自然）
}

-- 函数：从颜色表中随机选择一个颜色
local function getRandomColor(colortable)
    -- 获取颜色表的长度
    local length = #colortable

    -- 生成随机索引
    local randomIndex = math.random(1, length)

    -- 返回随机颜色
    return colortable[randomIndex]
end

-- 封装函数：根据文本生成固定颜色
local function getColorForText(text)
    -- 检查输入是否为 nil 或非字符串
    if not text or type(text) ~= "string" then
        warn("输入文本无效，必须是一个字符串。")
        return Color3.new(1, 1, 1) -- 返回默认颜色（白色）
    end

    -- 如果颜色已缓存，直接返回
    if colorCache[text] then
        return colorCache[text]
    end
    
    -- 生成颜色
    local color = getRandomColor(colortable)

    -- 缓存颜色
    colorCache[text] = color

    return color
end

-- 函数：将字改变颜色
local function setTextColor(text, startIndex, endIndex, color)
    -- 提取需要改变颜色的部分
    local coloredText = text:sub(startIndex, endIndex)
    -- 使用 <font> 标签包裹
    local coloredTextWithTag = string.format('<font color="#%s">%s</font>', color:ToHex(), coloredText)
    -- 拼接最终文本
    local finalText = text:sub(1, startIndex - 1) .. coloredTextWithTag .. text:sub(endIndex + 1)

    return finalText
end

-- 创建自定义聊天栏
local function createCustomChat()
    local translateAPI = "YouDao"
    local autotranslate = false
    local chatlog = {}

    -- 创建 ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomChat"
    -- screenGui.Parent = player.PlayerGui
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

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

    -- 创建输入栏容器
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(1, 0, 0.1, 0) -- 宽度 100%，高度 10%
    inputContainer.Position = UDim2.new(0, 0, 0.9, 0) -- 底部
    inputContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    inputContainer.BackgroundTransparency = 0.5 -- 背景半透明
    inputContainer.Parent = chatFrame

    -- 创建输入栏
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(0.9, 0, 1, 0) -- 宽度 85%，高度 100%
    inputBox.Position = UDim2.new(0, 0, 0, 0)
    inputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    inputBox.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    inputBox.PlaceholderText = "输入消息..." -- 提示文字
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputContainer.BackgroundTransparency = 1
    inputBox.ClearTextOnFocus = false
    inputBox.Text = ""
    inputBox.TextSize = 12
    inputBox.Parent = inputContainer

    -- 创建发送按钮
    local sendButton = Instance.new("TextButton")
    sendButton.Name = "SendButton"
    sendButton.Size = UDim2.new(0.1, 0, 1, 0) -- 宽度 15%，高度 100%
    sendButton.Position = UDim2.new(0.9, 0, 0, 0) -- 右侧
    sendButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- 背景颜色
    sendButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    sendButton.Text = "▶" -- 使用箭头图标代替文字
    sendButton.TextSize = 12
    sendButton.Parent = inputContainer

    -- 发送消息的逻辑
    local function sendMessage()
        local message = inputBox.Text
        if message ~= "" then
            chatControl:chat(message) -- 发送消息
            inputBox.Text = "" -- 清空输入框
        end
    end

    -- 绑定发送按钮点击事件
    sendButton.MouseButton1Click:Connect(sendMessage)

    -- 绑定输入栏回车事件
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            sendMessage()
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
    sideBarTitle.TextSize = 12
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
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder -- 按 LayoutOrder 排序
    buttonLayout.Parent = buttonContainer

    -- 添加按钮的函数
    local buttonIndex = 0 -- 用于记录按钮的顺序
    local function addButtonToSideBar(buttonName, onClick)
        buttonIndex = buttonIndex + 1 -- 递增顺序索引

        local button = Instance.new("TextButton")
        button.Name = buttonName
        button.Size = UDim2.new(1, 0, 0.1, 0) -- 宽度 100%，高度 10%
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
        button.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        button.Text = buttonName -- 按钮文字
        button.TextSize = 10
        button.LayoutOrder = buttonIndex -- 设置 LayoutOrder
        button.Parent = buttonContainer

        -- 点击按钮时高亮
        button.MouseButton1Click:Connect(function()
            -- 执行点击事件
            onClick(button)
        end)

        -- 默认高亮第一个按钮
        if buttonName == "有道翻译" then
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        end
    end

    local function highlightme(button)
        -- 取消所有按钮的高亮
        for _, child in ipairs(buttonContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        -- 高亮当前按钮
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end

    -- 添加示例按钮

    addButtonToSideBar(autotranslate and "自动(开)" or "自动(关)", function(button)
        autotranslate = not autotranslate
        button.Text = autotranslate and "自动(开)" or "自动(关)"
    end)

    addButtonToSideBar("复制日志", function()
        setclipboard(table.concat(chatlog, "\n"))
    end)

    addButtonToSideBar("原文", function(button)
        highlightme(button)
        translateAPI = "Roblox"
    end)

    addButtonToSideBar("有道翻译", function(button)
        highlightme(button)
        translateAPI = "YouDao"
    end)

    addButtonToSideBar("AI翻译", function(button)
        highlightme(button)
        translateAPI = "AI"
    end)

    addButtonToSideBar("必应翻译", function(button)
        highlightme(button)
        translateAPI = "Bing"
    end)

    addButtonToSideBar("搜狗翻译", function(button)
        highlightme(button)
        translateAPI = "SoGou"
    end)

    addButtonToSideBar("QQ翻译", function(button)
        highlightme(button)
        translateAPI = "QQ"
    end)

    local function HandleText(Data)
        local sourcemsghand = Data.nickname .. ":"
        local msghand = setTextColor(sourcemsghand, 1, #sourcemsghand, getColorForText(Data.sender))
        local msgtail = Data.text
        local iscmd = Data.text:sub(1, 1) == "/" or Data.text:sub(1, 1) == ";"
        if not iscmd and autotranslate then msgtail = translateModuel:translateText(Data.text, translateAPI) end
        if player.name == Data.sender then
            msgtail = setTextColor(msgtail, 1, #msgtail, Color3.fromRGB(204, 255, 204))
        end
        return msghand .. " " .. msgtail
    end

    local function getCurrentDateTime()
        -- 格式化日期和时间
        local dateTime = os.date("%Y-%m-%d %H:%M:%S")
        return dateTime
    end

    local maxbottom = 0
    local autoscroll = false

    RunService.Heartbeat:Connect(function()
        if maxbottom <= scrollingFrame.CanvasPosition.Y then
            maxbottom = scrollingFrame.CanvasPosition.Y
            autoscroll = true
        elseif maxbottom > scrollingFrame.CanvasPosition.Y then
            autoscroll = false
        end
    end)

    -- 存储消息的表
    local messageTable = {}

    -- 创建搜索框容器
    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "SearchContainer"
    searchContainer.Size = UDim2.new(0.3, 0, 0.07, 0) -- 宽度 20%，高度 4%
    searchContainer.Position = UDim2.new(0.7, 0, -0.1, 0) -- 紧贴聊天栏外侧右上角
    searchContainer.BackgroundTransparency = 1 -- 背景透明
    searchContainer.Parent = chatFrame

    -- 创建搜索框
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0.7, 0, 1, 0) -- 宽度 70%，高度 100%
    searchBox.Position = UDim2.new(0, 0, 0, 0)
    searchBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    searchBox.BackgroundTransparency = 0.5 -- 半透明
    searchBox.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    searchBox.PlaceholderText = "搜索昵称..." -- 提示文字
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Text = ""
    searchBox.TextSize = 12
    searchBox.Parent = searchContainer

    -- 创建搜索按钮
    local searchButton = Instance.new("TextButton")
    searchButton.Name = "SearchButton"
    searchButton.Size = UDim2.new(0.25, 0, 1, 0) -- 宽度 25%，高度 100%
    searchButton.Position = UDim2.new(0.75, 0, 0, 0) -- 右侧
    searchButton.BackgroundColor3 = Color3.new(0, 0, 0) -- 背景颜色
    searchButton.BackgroundTransparency = 0.2 -- 半透明
    searchButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    searchButton.Text = "🔍" -- 使用放大镜图标
    searchButton.TextSize = 12
    searchButton.Parent = searchContainer

    -- 搜索功能
    local function searchMessages(keyword)
        -- 清空当前消息显示
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        -- 如果关键字为空，还原原本的聊天栏
        if keyword == "" then
            for _, msgData in ipairs(messageTable) do
                -- 创建消息容器
                local messageContainer = Instance.new("Frame")
                messageContainer.Name = "MessageContainer"
                messageContainer.Size = UDim2.new(1, 0, 0, 20) -- 宽度 100%，高度 20
                messageContainer.BackgroundTransparency = 1 -- 背景透明
                messageContainer.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
                messageContainer.Parent = scrollingFrame

                -- 创建图片框
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "MessageImage"
                imageLabel.Size = UDim2.new(0, 20, 0, 20) -- 正方形图片，大小 20x20
                imageLabel.Position = UDim2.new(0, 0, 0, 0)
                imageLabel.BackgroundTransparency = 1 -- 背景透明
                imageLabel.Image = msgData.head -- 替换为实际的图片ID
                imageLabel.Parent = messageContainer

                -- 创建消息文本
                local messageLabel = Instance.new("TextLabel")
                messageLabel.Name = "MessageLabel"
                messageLabel.Size = UDim2.new(0.8, 0, 1, 0) -- 宽度 80%，高度 100%
                messageLabel.Position = UDim2.new(0, 25, 0, 0)
                messageLabel.BackgroundTransparency = 1 -- 背景透明
                messageLabel.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
                messageLabel.Text = HandleText(msgData)
                messageLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
                messageLabel.TextSize = 12
                messageLabel.RichText = true -- 启用 RichText
                messageLabel.TextWrapped = true -- 启用自动换行
                messageLabel.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
                messageLabel.Parent = messageContainer

                -- 创建按钮
                local editButton = Instance.new("TextButton")
                editButton.Name = "翻译"
                editButton.Size = UDim2.new(0.1, 0, 1, 0) -- 宽度 20%，高度 100%
                editButton.Position = UDim2.new(0.9, 0, 0, 0)
                editButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
                editButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
                editButton.Text = "翻译" -- 按钮文字
                editButton.TextSize = 12
                editButton.Parent = messageContainer

                -- 点击按钮触发代码
                editButton.MouseButton1Click:Connect(function()
                    local linshiData = msgData
                    linshiData.text = translateModuel:translateText(msgData.text, translateAPI)
                    messageLabel.Text = HandleText(linshiData)
                end)
            end
            return
        end

        -- 遍历 messageTable，筛选出包含关键字的 nickname 消息
        for _, msgData in ipairs(messageTable) do
            if string.find(msgData.nickname:lower(), keyword:lower()) then
                -- 创建消息容器
                local messageContainer = Instance.new("Frame")
                messageContainer.Name = "MessageContainer"
                messageContainer.Size = UDim2.new(1, 0, 0, 20) -- 宽度 100%，高度 20
                messageContainer.BackgroundTransparency = 1 -- 背景透明
                messageContainer.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
                messageContainer.Parent = scrollingFrame

                -- 创建图片框
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "MessageImage"
                imageLabel.Size = UDim2.new(0, 20, 0, 20) -- 正方形图片，大小 20x20
                imageLabel.Position = UDim2.new(0, 0, 0, 0)
                imageLabel.BackgroundTransparency = 1 -- 背景透明
                imageLabel.Image = msgData.head -- 替换为实际的图片ID
                imageLabel.Parent = messageContainer

                -- 创建消息文本
                local messageLabel = Instance.new("TextLabel")
                messageLabel.Name = "MessageLabel"
                messageLabel.Size = UDim2.new(0.8, 0, 1, 0) -- 宽度 80%，高度 100%
                messageLabel.Position = UDim2.new(0, 25, 0, 0)
                messageLabel.BackgroundTransparency = 1 -- 背景透明
                messageLabel.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
                messageLabel.Text = HandleText(msgData)
                messageLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
                messageLabel.TextSize = 12
                messageLabel.RichText = true -- 启用 RichText
                messageLabel.TextWrapped = true -- 启用自动换行
                messageLabel.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
                messageLabel.Parent = messageContainer

                -- 创建按钮
                local editButton = Instance.new("TextButton")
                editButton.Name = "翻译"
                editButton.Size = UDim2.new(0.1, 0, 1, 0) -- 宽度 20%，高度 100%
                editButton.Position = UDim2.new(0.9, 0, 0, 0)
                editButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
                editButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
                editButton.Text = "翻译" -- 按钮文字
                editButton.TextSize = 12
                editButton.Parent = messageContainer

                -- 点击按钮触发代码
                editButton.MouseButton1Click:Connect(function()
                    local linshiData = msgData
                    linshiData.text = translateModuel:translateText(msgData.text, translateAPI)
                    messageLabel.Text = HandleText(linshiData)
                end)
            end
        end
    end

    -- 绑定搜索按钮点击事件
    searchButton.MouseButton1Click:Connect(function()
        local keyword = searchBox.Text
        searchMessages(keyword)
        scrollingFrame.CanvasPosition = Vector2.new(0, 99999999)
        maxbottom = scrollingFrame.CanvasPosition.Y
        autoscroll = true
    end)

    -- 绑定搜索框回车事件
    searchBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local keyword = searchBox.Text
            searchMessages(keyword)
        end
    end)

    chatControl:MessageReceiver(function(msgData)
        table.insert(messageTable, msgData)
        table.insert(chatlog, "[" .. getCurrentDateTime() .. "] " .. msgData.nickname .. "(@" .. msgData.sender .. ") : " .. msgData.text)
        if searchBox.Text ~= "" and not string.find(msgData.nickname:lower(), searchBox.Text:lower()) then return end

        -- 创建消息容器
        local messageContainer = Instance.new("Frame")
        messageContainer.Name = "MessageContainer"
        messageContainer.Size = UDim2.new(1, 0, 0, 20) -- 宽度 100%，高度 20
        messageContainer.BackgroundTransparency = 1 -- 背景透明
        messageContainer.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
        messageContainer.Parent = scrollingFrame

        -- 创建图片框
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "MessageImage"
        imageLabel.Size = UDim2.new(0, 20, 0, 20) -- 正方形图片，大小 20x20
        imageLabel.Position = UDim2.new(0, 0, 0, 0)
        imageLabel.BackgroundTransparency = 1 -- 背景透明
        imageLabel.Image = msgData.head -- 替换为实际的图片ID
        imageLabel.Parent = messageContainer

        -- 创建消息文本
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "MessageLabel"
        messageLabel.Size = UDim2.new(0.8, 0, 1, 0) -- 宽度 80%，高度 100%
        messageLabel.Position = UDim2.new(0, 25, 0, 0)
        messageLabel.BackgroundTransparency = 1 -- 背景透明
        messageLabel.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        messageLabel.Text = HandleText(msgData)
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
        messageLabel.TextSize = 12
        messageLabel.RichText = true -- 启用 RichText
        messageLabel.TextWrapped = true -- 启用自动换行
        messageLabel.AutomaticSize = Enum.AutomaticSize.Y -- 自动调整高度
        messageLabel.Parent = messageContainer

        -- 创建按钮
        local editButton = Instance.new("TextButton")
        editButton.Name = "翻译"
        editButton.Size = UDim2.new(0.1, 0, 1, 0) -- 宽度 20%，高度 100%
        editButton.Position = UDim2.new(0.9, 0, 0, 0)
        editButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
        editButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
        editButton.Text = "翻译" -- 按钮文字
        editButton.TextSize = 12
        editButton.Parent = messageContainer

        -- 点击按钮触发代码
        editButton.MouseButton1Click:Connect(function()
            local linshiData = msgData
            linshiData.text = translateModuel:translateText(msgData.text, translateAPI)
            messageLabel.Text = HandleText(linshiData)
        end)
        
        -- 如果滚动条在最下方，自动滚动到最下方
        if autoscroll then
            scrollingFrame.CanvasPosition = Vector2.new(0, 99999999)
            maxbottom = scrollingFrame.CanvasPosition.Y
        end
    end)

    -- 创建切换按钮
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleChatButton"
    toggleButton.Size = UDim2.new(0, 45, 0, 45) -- 按钮大小
    toggleButton.Position = UDim2.new(0.17, 0, -0.065, 0)
    toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    toggleButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.Text = "💬" -- 按钮文字
    toggleButton.TextSize = 14
    toggleButton.Parent = screenGui

    -- 圆角效果
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- 完全圆形
    corner.Parent = toggleButton

    -- 切换聊天栏显示/隐藏
    toggleButton.MouseButton1Click:Connect(function()
        chatFrame.Visible = not chatFrame.Visible
    end)

    -- 添加卸载按钮
    local uninstallButton = Instance.new("TextButton")
    uninstallButton.Name = "UninstallButton"
    uninstallButton.Size = UDim2.new(0.05, 0, 0.05, 0) -- 按钮大小
    uninstallButton.Position = UDim2.new(0.95, 0, 0.95, 0) -- 放置在切换按钮上方
    uninstallButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
    uninstallButton.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
    uninstallButton.Text = "卸载" -- 按钮文字
    uninstallButton.TextSize = 12
    uninstallButton.Parent = screenGui

    -- 卸载功能
    local function uninstallScript()
        -- 断开所有事件监听
        for _, connection in ipairs(getconnections(sendButton.MouseButton1Click)) do
            connection:Disconnect()
        end
        for _, connection in ipairs(getconnections(inputBox.FocusLost)) do
            connection:Disconnect()
        end
        for _, connection in ipairs(getconnections(toggleButton.MouseButton1Click)) do
            connection:Disconnect()
        end
        for _, connection in ipairs(getconnections(uninstallButton.MouseButton1Click)) do
            connection:Disconnect()
        end

        -- 移除所有实例
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end

        -- 清理缓存和全局变量
        colorCache = {}
        chatlog = {}
        translateModuel = nil
        chatControl = nil

        -- 打印卸载成功信息
        print("脚本已完全卸载！")
    end

    -- 绑定卸载按钮点击事件
    uninstallButton.MouseButton1Click:Connect(uninstallScript)
end

-- 初始化自定义聊天栏
createCustomChat()