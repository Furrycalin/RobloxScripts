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
    return colortable[math.random(1, #colortable)]
end

-- 封装函数：根据文本生成固定颜色
local function getColorForText(text)
    if not text or type(text) ~= "string" then
        warn("输入文本无效，必须是一个字符串。")
        return Color3.new(1, 1, 1) -- 返回默认颜色（白色）
    end

    if colorCache[text] then
        return colorCache[text]
    end

    local color = getRandomColor(colortable)
    colorCache[text] = color
    return color
end

-- 函数：将字改变颜色
local function setTextColor(text, startIndex, endIndex, color)
    local coloredText = text:sub(startIndex, endIndex)
    local coloredTextWithTag = string.format('<font color="#%s">%s</font>', color:ToHex(), coloredText)
    return text:sub(1, startIndex - 1) .. coloredTextWithTag .. text:sub(endIndex + 1)
end

-- 创建自定义聊天栏
local function createCustomChat()
    local translateAPI = "YouDao"
    local autotranslate = false
    local chatlog = {}

    -- 创建 ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomChat"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    -- 创建聊天栏背景
    local chatFrame = Instance.new("Frame")
    chatFrame.Name = "ChatFrame"
    chatFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    chatFrame.Position = UDim2.new(0, 10, 0, 10)
    chatFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    chatFrame.BackgroundTransparency = 0.5
    chatFrame.Parent = screenGui

    -- 创建消息滚动区域
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "MessageScroll"
    scrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = chatFrame

    -- 创建消息布局
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scrollingFrame

    -- 创建输入栏容器
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(1, 0, 0.1, 0)
    inputContainer.Position = UDim2.new(0, 0, 0.9, 0)
    inputContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    inputContainer.BackgroundTransparency = 0.5
    inputContainer.Parent = chatFrame

    -- 创建输入栏
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(0.9, 0, 1, 0)
    inputBox.Position = UDim2.new(0, 0, 0, 0)
    inputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.PlaceholderText = "输入消息..."
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Text = ""
    inputBox.TextSize = 12
    inputBox.Parent = inputContainer

    -- 创建发送按钮
    local sendButton = Instance.new("TextButton")
    sendButton.Name = "SendButton"
    sendButton.Size = UDim2.new(0.1, 0, 1, 0)
    sendButton.Position = UDim2.new(0.9, 0, 0, 0)
    sendButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sendButton.TextColor3 = Color3.new(1, 1, 1)
    sendButton.Text = "▶"
    sendButton.TextSize = 12
    sendButton.Parent = inputContainer

    -- 发送消息的逻辑
    local function sendMessage()
        local message = inputBox.Text
        if message ~= "" then
            chatControl:chat(message)
            inputBox.Text = ""
        end
    end

    sendButton.MouseButton1Click:Connect(sendMessage)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            sendMessage()
        end
    end)

    -- 创建侧边栏
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
    sideBar.Size = UDim2.new(0.1, 0, 1, 0)
    sideBar.Position = UDim2.new(1, 0, 0, 0)
    sideBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    sideBar.BackgroundTransparency = 0.5
    sideBar.Parent = chatFrame

    -- 创建侧边栏标题
    local sideBarTitle = Instance.new("TextLabel")
    sideBarTitle.Name = "SideBarTitle"
    sideBarTitle.Size = UDim2.new(1, 0, 0.1, 0)
    sideBarTitle.Position = UDim2.new(0, 0, 0, 0)
    sideBarTitle.BackgroundTransparency = 1
    sideBarTitle.TextColor3 = Color3.new(1, 1, 1)
    sideBarTitle.Text = "翻译器"
    sideBarTitle.TextSize = 12
    sideBarTitle.TextXAlignment = Enum.TextXAlignment.Center
    sideBarTitle.Parent = sideBar

    -- 创建按钮容器
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, 0, 0.9, 0)
    buttonContainer.Position = UDim2.new(0, 0, 0.1, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = sideBar

    -- 创建按钮布局
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.Padding = UDim.new(0, 5)
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Parent = buttonContainer

    -- 添加按钮的函数
    local buttonIndex = 0
    local function addButtonToSideBar(buttonName, onClick)
        buttonIndex = buttonIndex + 1

        local button = Instance.new("TextButton")
        button.Name = buttonName
        button.Size = UDim2.new(1, 0, 0.1, 0)
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Text = buttonName
        button.TextSize = 10
        button.LayoutOrder = buttonIndex
        button.Parent = buttonContainer

        button.MouseButton1Click:Connect(function()
            onClick(button)
        end)

        if buttonName == "有道翻译" then
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        end
    end

    local function highlightButton(button)
        for _, child in ipairs(buttonContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end

    -- 添加按钮
    addButtonToSideBar(autotranslate and "自动(开)" or "自动(关)", function(button)
        autotranslate = not autotranslate
        button.Text = autotranslate and "自动(开)" or "自动(关)"
    end)

    addButtonToSideBar("复制日志", function()
        setclipboard(table.concat(chatlog, "\n"))
    end)

    addButtonToSideBar("原文", function(button)
        highlightButton(button)
        translateAPI = "Roblox"
    end)

    addButtonToSideBar("有道翻译", function(button)
        highlightButton(button)
        translateAPI = "YouDao"
    end)

    addButtonToSideBar("AI翻译", function(button)
        highlightButton(button)
        translateAPI = "AI"
    end)

    addButtonToSideBar("必应翻译", function(button)
        highlightButton(button)
        translateAPI = "Bing"
    end)

    addButtonToSideBar("搜狗翻译", function(button)
        highlightButton(button)
        translateAPI = "SoGou"
    end)

    addButtonToSideBar("QQ翻译", function(button)
        highlightButton(button)
        translateAPI = "QQ"
    end)

    -- 处理消息文本
    local function HandleText(Data)
        local sourcemsghand = Data.nickname .. ":"
        local msghand = setTextColor(sourcemsghand, 1, #sourcemsghand, getColorForText(Data.sender))
        local msgtail = Data.text
        local iscmd = Data.text:sub(1, 1) == "/" or Data.text:sub(1, 1) == ";"
        if not iscmd and autotranslate then
            msgtail = translateModuel:translateText(Data.text, translateAPI)
        end
        if player.name == Data.sender then
            msgtail = setTextColor(msgtail, 1, #msgtail, Color3.fromRGB(204, 255, 204))
        end
        return msghand .. " " .. msgtail
    end

    -- 获取当前日期时间
    local function getCurrentDateTime()
        return os.date("%Y-%m-%d %H:%M:%S")
    end

    -- 复制属性
    local function copyProperties(source, target)
        for property, _ in pairs(source:GetProperties()) do
            if pcall(function()
                return target[property]
            end) then
                target[property] = source[property]
            end
        end
    end

    -- 函数：根据玩家 ID 或玩家名生成私聊格式
    local function getPrivateMessageTag(playerIdentifier)
        -- 如果传入的是玩家 ID
        if type(playerIdentifier) == "number" then
            local player = Players:GetPlayerByUserId(playerIdentifier)
            if player then
                return "[@" .. player.Name .. "]: "
            else
                warn("未找到玩家 ID: " .. playerIdentifier)
                return nil
            end
        -- 如果传入的是玩家名
        elseif type(playerIdentifier) == "string" then
            local player = Players:FindFirstChild(playerIdentifier)
            if player then
                return "[@" .. player.Name .. "]: "
            else
                warn("未找到玩家名: " .. playerIdentifier)
                return nil
            end
        else
            warn("无效的玩家标识符类型")
            return nil
        end
    end

    -- 创建消息框
    local function createMessageBox(title, content)
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Parent = game.CoreGui
        screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui2.ResetOnSpawn = false
        screenGui2.Name = "MessageBoxGui"

        local background = Instance.new("Frame")
        background.Name = "Background"
        background.Size = UDim2.new(1, 0, 1, 0)
        background.Position = UDim2.new(0, 0, 0, 0)
        background.BackgroundColor3 = Color3.new(0, 0, 0)
        background.BackgroundTransparency = 0.5
        background.Parent = screenGui2

        local messageBox = Instance.new("Frame")
        messageBox.Name = "MessageBox"
        messageBox.Size = UDim2.new(0, 300, 0, 200)
        messageBox.Position = UDim2.new(0.5, -150, 0.5, -100)
        messageBox.AnchorPoint = Vector2.new(0.5, 0.5)
        messageBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        messageBox.BackgroundTransparency = 0.2
        messageBox.BorderSizePixel = 0
        messageBox.Parent = screenGui2

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = messageBox

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.new(1, 1, 1)
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = messageBox

        local contentLabel = Instance.new("TextLabel")
        contentLabel.Name = "Content"
        contentLabel.Size = UDim2.new(1, -20, 1, -100)
        contentLabel.Position = UDim2.new(0, 10, 0, 50)
        contentLabel.Text = content
        contentLabel.TextColor3 = Color3.new(1, 1, 1)
        contentLabel.TextSize = 14
        contentLabel.Font = Enum.Font.SourceSans
        contentLabel.TextWrapped = true
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.BackgroundTransparency = 1
        contentLabel.Parent = messageBox

        local confirmButton = Instance.new("TextButton")
        confirmButton.Name = "ConfirmButton"
        confirmButton.Size = UDim2.new(0, 120, 0, 40)
        confirmButton.Position = UDim2.new(0.5, -130, 1, -50)
        confirmButton.Text = "确认"
        confirmButton.TextColor3 = Color3.new(1, 1, 1)
        confirmButton.TextSize = 14
        confirmButton.Font = Enum.Font.SourceSans
        confirmButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
        confirmButton.AutoButtonColor = true
        confirmButton.Parent = messageBox

        local confirmCorner = Instance.new("UICorner")
        confirmCorner.CornerRadius = UDim.new(0, 8)
        confirmCorner.Parent = confirmButton

        local cancelButton = Instance.new("TextButton")
        cancelButton.Name = "CancelButton"
        cancelButton.Size = UDim2.new(0, 120, 0, 40)
        cancelButton.Position = UDim2.new(0.5, 10, 1, -50)
        cancelButton.Text = "取消"
        cancelButton.TextColor3 = Color3.new(1, 1, 1)
        cancelButton.TextSize = 14
        cancelButton.Font = Enum.Font.SourceSans
        cancelButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
        cancelButton.AutoButtonColor = true
        cancelButton.Parent = messageBox

        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 8)
        cancelCorner.Parent = cancelButton

        local messageBoxInstance = {
            ScreenGui = screenGui2,
            OnConfirm = function(callback)
                confirmButton.MouseButton1Click:Connect(callback)
            end,
            OnCancel = function(callback)
                cancelButton.MouseButton1Click:Connect(callback)
            end,
            Destroy = function()
                screenGui2:Destroy()
            end
        }

        return messageBoxInstance
    end

    -- 查找链接
    local function findLink(text)
        local pattern = "https?://[%w-_%.%?%.:/%+=&]+"
        local link = string.match(text, pattern)
        return link and { islink = true, link = link } or { islink = false, link = nil }
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
    searchContainer.Size = UDim2.new(0.3, 0, 0.07, 0)
    searchContainer.Position = UDim2.new(0.7, 0, -0.1, 0)
    searchContainer.BackgroundTransparency = 1
    searchContainer.Parent = chatFrame

    -- 创建搜索框
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0.7, 0, 1, 0)
    searchBox.Position = UDim2.new(0, 0, 0, 0)
    searchBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    searchBox.BackgroundTransparency = 0.5
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.PlaceholderText = "搜索昵称..."
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Text = ""
    searchBox.TextSize = 12
    searchBox.Parent = searchContainer

    -- 创建搜索按钮
    local searchButton = Instance.new("TextButton")
    searchButton.Name = "SearchButton"
    searchButton.Size = UDim2.new(0.25, 0, 1, 0)
    searchButton.Position = UDim2.new(0.75, 0, 0, 0)
    searchButton.BackgroundColor3 = Color3.new(0, 0, 0)
    searchButton.BackgroundTransparency = 0.2
    searchButton.TextColor3 = Color3.new(1, 1, 1)
    searchButton.Text = "🔍"
    searchButton.TextSize = 12
    searchButton.Parent = searchContainer

    -- 搜索功能
    local function searchMessages(keyword)
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        if keyword == "" then
            for _, msgData in ipairs(messageTable) do
                createMessageUI(msgData)
            end
            return
        end

        for _, msgData in ipairs(messageTable) do
            if string.find(msgData.nickname:lower(), keyword:lower()) then
                createMessageUI(msgData)
            end
        end
    end

    -- 创建消息 UI
    local function createMessageUI(msgData)
        local findl = findLink(msgData.text)

        local messageContainer = Instance.new("Frame")
        messageContainer.Name = "MessageContainer"
        messageContainer.Size = UDim2.new(1, 0, 0, 20)
        messageContainer.BackgroundTransparency = 1
        messageContainer.AutomaticSize = Enum.AutomaticSize.Y
        messageContainer.Parent = scrollingFrame

        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "MessageImage"
        imageLabel.Size = UDim2.new(0, 20, 0, 20)
        imageLabel.Position = UDim2.new(0, 0, 0, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = msgData.head
        imageLabel.Parent = messageContainer

        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "MessageLabel"
        messageLabel.Size = UDim2.new(findl.islink and 0.75 or 0.8, 0, 1, 0)
        messageLabel.Position = UDim2.new(0, 25, 0, 0)
        messageLabel.BackgroundTransparency = 1
        messageLabel.TextColor3 = Color3.new(1, 1, 1)
        messageLabel.Text = HandleText(msgData)
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextSize = 12
        messageLabel.RichText = true
        messageLabel.TextWrapped = true
        messageLabel.AutomaticSize = Enum.AutomaticSize.Y
        messageLabel.Parent = messageContainer

        local privateMsgButton = Instance.new("TextButton")
        copyProperties(messageLabel, privateMsgButton)
        privateMsgButton.Visible = false

        privateMsgButton.MouseButton1Click:Connect(function()
            inputBox.Text = getPrivateMessageTag(msgData.sender)
            inputBox:CaptureFocus()
        end)

        if findl.islink then
            local superlinkButton = Instance.new("TextButton")
            superlinkButton.Name = "超链接"
            superlinkButton.Size = UDim2.new(0.05, 0, 1, 0)
            superlinkButton.Position = UDim2.new(0.85, 0, 0, 0)
            superlinkButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            superlinkButton.TextColor3 = Color3.new(1, 1, 1)
            superlinkButton.Text = "🔗"
            superlinkButton.TextSize = 12
            superlinkButton.Parent = messageContainer

            superlinkButton.MouseButton1Click:Connect(function()
                local messageBox = createMessageBox("这是一段链接，是否将其复制吗？", findl.link)

                messageBox.OnConfirm(function()
                    setclipboard(findl.link)
                    messageBox.Destroy()
                end)

                messageBox.OnCancel(function()
                    messageBox.Destroy()
                end)
            end)
        end

        local transleButton = Instance.new("TextButton")
        transleButton.Name = "翻译"
        transleButton.Size = UDim2.new(0.05, 0, 1, 0)
        transleButton.Position = UDim2.new(0.9, 0, 0, 0)
        transleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        transleButton.TextColor3 = Color3.new(1, 1, 1)
        transleButton.Text = "🌐"
        transleButton.TextSize = 12
        transleButton.Parent = messageContainer

        transleButton.MouseButton1Click:Connect(function()
            local linshiData = msgData
            linshiData.text = translateModuel:translateText(msgData.text, translateAPI)
            messageLabel.Text = HandleText(linshiData)
        end)

        local copyButton = Instance.new("TextButton")
        copyButton.Name = "复制"
        copyButton.Size = UDim2.new(0.05, 0, 1, 0)
        copyButton.Position = UDim2.new(0.95, 0, 0, 0)
        copyButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        copyButton.TextColor3 = Color3.new(1, 1, 1)
        copyButton.Text = "📋"
        copyButton.TextSize = 12
        copyButton.Parent = messageContainer

        copyButton.MouseButton1Click:Connect(function()
            setclipboard(msgData.text)
        end)
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

        createMessageUI(msgData)

        if autoscroll then
            scrollingFrame.CanvasPosition = Vector2.new(0, 99999999)
            maxbottom = scrollingFrame.CanvasPosition.Y
        end
    end)

    -- 创建切换按钮
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleChatButton"
    toggleButton.Size = UDim2.new(0, 45, 0, 45)
    toggleButton.Position = UDim2.new(0.17, 0, -0.065, 0)
    toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.Text = "💬"
    toggleButton.TextSize = 14
    toggleButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        chatFrame.Visible = not chatFrame.Visible
    end)

    -- 添加卸载按钮
    local uninstallButton = Instance.new("TextButton")
    uninstallButton.Name = "UninstallButton"
    uninstallButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    uninstallButton.Position = UDim2.new(0.95, 0, 0.95, 0)
    uninstallButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    uninstallButton.TextColor3 = Color3.new(1, 1, 1)
    uninstallButton.Text = "卸载"
    uninstallButton.TextSize = 12
    uninstallButton.Parent = screenGui

    -- 卸载功能
    local function uninstallScript()
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

        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end

        colorCache = {}
        chatlog = {}
        translateModuel = nil
        chatControl = nil

        print("脚本已完全卸载！")
    end

    uninstallButton.MouseButton1Click:Connect(uninstallScript)
end

-- 初始化自定义聊天栏
createCustomChat()