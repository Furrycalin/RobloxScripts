if not game:IsLoaded() then
	game.Loaded:Wait()
end

if _G.ChronixHubisLoaded then
    warn("⛔ ChronixHub Already loaded! Please do not repeat the execution.")
    return
end

_G.ChronixHubisLoaded = true

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")
local TeleportService = game:GetService("TeleportService")

-- local LoadAnimationModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/NewLoadAnimation.lua"))()
local LoadAnimationModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/start_animation.lua"))()
local tpWalk = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/tpWalk.lua"))()
local StandRecovery = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/StandRecovery.lua"))()
local HighlightModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/HighlightModule.lua"))()
local PlayerLightModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerLightModule.lua"))()
local SpectatorModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SpectatorModule.lua"))()
local FreecamModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FreecamModule.lua"))()
local LandingEffect = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/LandingEffect.lua"))()
local NameTagModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/NameTagModule.lua"))()
local PlayerVisibleModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerVisibleModule.lua"))()
local movementModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovementModule.lua"))()
local MouseUnlockModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MouseUnlockModule.lua"))()
local DeathballScripts = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/DeathBallScripts.lua"))()
local ZoomModule = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/ZoomModule.lua"))()
local FlingDetector = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/FlingDetector.lua"))()
local SystemNotification = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SystemNotification.lua"))()
local PlayerESP = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/PlayerESP.lua"))()
local MovableHighlighter_NM = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/MovableHighlighter-NM.lua"))()
local GameTeleport = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/GameTeleport.lua"))()

local iscancel = false

LoadAnimationModule:LoadAnimation(2, {
    titleText = "ChronixHub V2",
    loadingText = "加载中... ",
    backgroundColor = Color3.new(0, 0, 0),
    textColor = Color3.new(1, 1, 1),
    language = "zh",
    onComplete = function(isCancelled)
        if isCancelled then
            iscancel = true
        end
    end,
    showCancelButton = true
})

if (_G.SA_FASTLOADING or false) == true then wait(2.1) else wait(15.1) end
if iscancel then
    _G.ChronixHubisLoaded = false
    return
end

local bb = game:service'VirtualUser'
local cc = game:service'Players'.LocalPlayer.Idled:connect(function()bb:CaptureController()bb:ClickButton2(Vector2.new())end)

local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- 获取玩家信息
local playerName = LocalPlayer.Name -- 玩家名
local displayName = LocalPlayer.DisplayName -- 显示名
local userId = LocalPlayer.UserId -- 用户 ID
local isPremium = (LocalPlayer.MembershipType == Enum.MembershipType.Premium)
-- 获取玩家头像
local thumbnailType = Enum.ThumbnailType.HeadShot -- 头像类型
local thumbnailSize = Enum.ThumbnailSize.Size100x100 -- 头像尺寸
local success, thumbnailUrl = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbnailType, thumbnailSize)
end)
-- 获取玩家角色外观信息
local success, appearanceInfo = pcall(function()
    return Players:GetCharacterAppearanceInfoAsync(LocalPlayer.UserId)
end)

local function GetDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return "Mobile" -- 移动端
    elseif UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
        return "Desktop" -- 桌面端
    elseif UserInputService.GamepadEnabled then
        return "Console" -- 控制台
    else
        return "Unknown" -- 未知设备
    end
end

-- 获取 UniverseId
local function getUniverseId(placeId)
    local url = "https://apis.roblox.com/universes/v1/places/" .. placeId .. "/universe"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        return data.universeId
    else
        warn("获取 UniverseId 失败:", response)
        return nil
    end
end

local getGameNameNotSuccess = false

-- 获取游戏名
local function getGameName(universeId)
    local url = "https://games.roblox.com/v1/games?universeIds=" .. universeId
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data.data and #data.data > 0 then
            return data.data[1]
        else
            warn("未找到游戏信息")
            print(data)
            getGameNameNotSuccess = true
            return nil
        end
    else
        warn("获取游戏名失败:", response)
        getGameNameNotSuccess = true
        return nil
    end
end

local notifications = {}

local musicbox = Instance.new("Sound")
musicbox.Parent = SoundService

local testbox = Instance.new("Sound")
testbox.Parent = SoundService

local uiclicker = Instance.new("Sound")
uiclicker.SoundId = "rbxassetid://535716488"
uiclicker.Volume = 0.3
uiclicker.Parent = SoundService

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://4590662766" -- 替换为你的音频ID
achievementSound.Volume = 0.5 -- 音量大小
achievementSound.Parent = SoundService

local Gui = Instance.new("ScreenGui")
Gui.Parent = game.CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

local function UpdatePositions()
    for index, frame in ipairs(notifications) do
        local targetPosition = UDim2.new(0.8, 0, 0.1 + (index - 1) * 0.11, 0)
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = targetPosition
        })
        tween:Play()
    end
end

local function CreateNotification(title, text, duration, isAchievement)
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0.2, 0, 0.1, 0)
    notificationFrame.Position = UDim2.new(1, 0, 0.1 + #notifications * 0.11, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- 背景颜色
    notificationFrame.BackgroundTransparency = 0.8 -- 背景透明度降低
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = Gui

    local uiCorner = Instance.new("UICorner", notificationFrame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    -- 标题
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 标题文字颜色
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 分隔线
    local divider = Instance.new("Frame", notificationFrame)
    divider.Size = UDim2.new(0.95, 0, 0, 1)
    divider.Position = UDim2.new(0.025, 0, 0.35, 0)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.8
    divider.BorderSizePixel = 0

    -- 正文
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Size = UDim2.new(0.95, 0, 0.6, 0)
    textLabel.Position = UDim2.new(0.025, 0, 0.3, 0)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- 正文文字颜色
    textLabel.TextSize = 18
    textLabel.BackgroundTransparency = 1
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(notifications, notificationFrame)

    -- 如果是成就通知，播放音效
    if isAchievement then
        achievementSound:Play()
    end

    -- 滑入动画
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.8, 0, notificationFrame.Position.Y.Scale, 0)
    })
    tweenIn:Play()

    -- 独立协程处理通知生命周期
    coroutine.wrap(function()
        wait(duration)
        
        -- 滑出动画
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, notificationFrame.Position.Y.Scale, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()

        -- 移除元素并更新队列
        local index = table.find(notifications, notificationFrame)
        if index then
            table.remove(notifications, index)
            notificationFrame:Destroy()
            UpdatePositions()
        end
    end)()
end

-- local function onScriptError(errorMessage, stackTrace, erroredScript)
--     CreateNotification("警告", "脚本在加载后续进程时出现错误\n按F9查看详细信息", 20, true)
--     warn("[ChronixHub] 警告！脚本在加载后续进程时出现错误，可能会导致脚本加载失败、无法卸载等问题，请重新加入游戏并等待开发者修复。")
--     print("==================== 脚本错误详情 ====================")
--     print("错误原因：", errorMessage)
--     print("错误位置：", stackTrace)
--     print("错误脚本：", erroredScript and erroredScript.Name or "未知脚本")
--     print("======================================================")
-- end

-- ScriptContext.Error:Connect(onScriptError)

-- 粒子效果函数
local function applyParticleEffect(button)
    button.MouseButton1Click:Connect(function()
        for i = 1, 10 do
            local particle = Instance.new("Frame")
            particle.Name = "Particle"
            particle.Size = UDim2.new(0, 10, 0, 10)
            particle.Position = UDim2.new(0.5, -5, 0.5, -5)
            particle.AnchorPoint = Vector2.new(0.5, 0.5) -- 以中心为基准
            particle.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()) -- 随机颜色
            particle.BackgroundTransparency = 0
            particle.Parent = button

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle

            -- 随机方向扩散
            local angle = math.rad(math.random(0, 360))
            local distance = math.random(50, 100)
            local targetPosition = UDim2.new(
                0.5, distance * math.cos(angle) - 5,
                0.5, distance * math.sin(angle) - 5
            )

            local tween = TweenService:Create(particle, TweenInfo.new(0.5), {
                Position = targetPosition,
                BackgroundTransparency = 1
            })
            tween:Play()

            tween.Completed:Connect(function()
                particle:Destroy()
            end)
        end
    end)
end

-- 创建主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300) -- 中等大小
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- 屏幕中央
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
mainFrame.BorderSizePixel = 0
mainFrame.Parent = Gui

-- 创建 UICorner 并设置圆角
local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 5)

-- 创建标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 36) -- 深墨蓝色
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local uiCorner2 = Instance.new("UICorner", titleBar)
uiCorner2.CornerRadius = UDim.new(0, 5)

-- 标题栏拖动功能
local isDragging = false
local dragStartPos
local windowStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        windowStartPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        mainFrame.Position = UDim2.new(
            windowStartPos.X.Scale,
            windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale,
            windowStartPos.Y.Offset + delta.Y
        )
    end
end)

-- 标题栏文本
local titleText = Instance.new("TextLabel")
titleText.Text = "ChronixHub v2"
titleText.Size = UDim2.new(0, 100, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.TextColor3 = Color3.new(1, 1, 1) -- 白色
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 缩小按钮
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -50, 0.2, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.Parent = titleBar
applyParticleEffect(minimizeButton)

local uiCorner3 = Instance.new("UICorner", minimizeButton)
uiCorner3.CornerRadius = UDim.new(0, 5)

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0.2, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

local uiCorner4 = Instance.new("UICorner", closeButton)
uiCorner4.CornerRadius = UDim.new(0, 5)

-- 创建内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -70)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local uiCorner5 = Instance.new("UICorner", contentFrame)
uiCorner5.CornerRadius = UDim.new(0, 5)

-- 创建信息栏
local infoBar = Instance.new("Frame")
infoBar.Size = UDim2.new(1, 0, 0, 40)
infoBar.Position = UDim2.new(0, 0, 1, -40)
infoBar.BackgroundColor3 = Color3.fromRGB(20, 20, 36)
infoBar.BorderSizePixel = 0
infoBar.Parent = mainFrame

local uiCorner2 = Instance.new("UICorner", infoBar)
uiCorner2.CornerRadius = UDim.new(0, 5)

-- 创建 ImageLabel 显示头像
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(0, 40, 0, 40) -- 头像大小
avatarImage.Position = UDim2.new(0, 10, -0.1, 0) -- 居中
avatarImage.BackgroundTransparency = 1
avatarImage.Image = thumbnailUrl -- 设置头像
avatarImage.ScaleType = Enum.ScaleType.Fit
avatarImage.Parent = infoBar

infotitle = ""

if GetDeviceType() == "Desktop" then
    infotitle = "电脑用户"
elseif GetDeviceType() == "Mobile" then
    infotitle = "手机用户"
end

local infotitleText = Instance.new("TextLabel")
infotitleText.Text = isPremium and "欢迎使用! " .. infotitle .. playerName .. " | ID:" .. userId .. " | 已开通会员" or "欢迎使用! " .. infotitle .. playerName .. " | ID:" .. userId
infotitleText.Size = UDim2.new(0, 100, 0.5, 0)
infotitleText.Position = UDim2.new(0, 60, 0.08, 0)
infotitleText.TextColor3 = Color3.new(1, 1, 1) -- 白色
infotitleText.BackgroundTransparency = 1
infotitleText.TextSize = 8
infotitleText.TextXAlignment = Enum.TextXAlignment.Left
infotitleText.Parent = infoBar

local gameInfo = getGameName(game.GameId)

-- 调试信息
if getGameNameNotSuccess then
    print("游戏ID: " .. game.GameId)
end

local infotitleText2 = Instance.new("TextLabel")
infotitleText2.Text = getGameNameNotSuccess and "未找到游戏信息, 未找到游戏ID | Debug: InConsole" or "在玩: " .. gameInfo.name .. " | ID: " .. game.GameId
infotitleText2.Size = UDim2.new(0, 100, 0.5, 0)
infotitleText2.Position = UDim2.new(0, 60, 0.42, 0)
infotitleText2.TextColor3 = Color3.new(1, 1, 1) -- 白色
infotitleText2.BackgroundTransparency = 1
infotitleText2.TextSize = 8
infotitleText2.TextXAlignment = Enum.TextXAlignment.Left
infotitleText2.Parent = infoBar

-- 缩小功能
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 200, 0, 30)}):Play()
        contentFrame.Visible = false
        infoBar.Visible = false
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 500, 0, 300)}):Play()
        contentFrame.Visible = true
        infoBar.Visible = true
    end
end)

-- 左侧功能栏
local functionList = Instance.new("ScrollingFrame")
functionList.Size = UDim2.new(0, 100, 1, 0)
functionList.Position = UDim2.new(0, 0, 0, 0)
functionList.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
functionList.BorderSizePixel = 0
functionList.ScrollBarThickness = 5
functionList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 170) -- 浅墨蓝色
functionList.Parent = contentFrame

local uiCorner5 = Instance.new("UICorner", functionList)
uiCorner5.CornerRadius = UDim.new(0, 5)

-- 创建 UIListLayout 自动排列项目
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = functionList
uiListLayout.Padding = UDim.new(0, 3) -- 设置项目间距

-- 右侧内容区域
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -100, 1, 0)
contentArea.Position = UDim2.new(0, 100, 0, 0)
contentArea.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
contentArea.BorderSizePixel = 0
contentArea.Parent = contentFrame

local uiCorner5 = Instance.new("UICorner", contentArea)
uiCorner5.CornerRadius = UDim.new(0, 5)

local function CreateLabel(text, textsize, size, position)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1) -- 白色
    label.Font = Enum.Font.SourceSans
    label.TextSize = textsize
    label.Parent = contentArea
    return label
end


local function CreateTextBox(text, textSize, size, position, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = size -- 输入框大小
    textBox.Position = position -- 输入框位置
    textBox.BackgroundColor3 = Color3.fromRGB(100, 100, 170)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.TextSize = textSize
    textBox.Font = Enum.Font.SourceSans
    textBox.Text = text
    textBox.Parent = contentArea
    textBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(textBox)
        end
    end)
    return textBox
end

local function CreateList(size, position)
    -- 创建滚动列表
    local list = Instance.new("ScrollingFrame")
    list.Size = size
    list.Position = position
    list.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 5
    list.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 170) -- 浅墨蓝色
    list.Parent = contentArea

    -- 创建 UIListLayout 用于自动排列按钮
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5) -- 按钮间距
    uiListLayout.Parent = list

    -- 更新滚动区域大小
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        list.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    -- 定义 add 方法
    local function addButton(text, callback)
        -- 创建按钮
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(1, -10, 0, 30) -- 宽度减去 10 以留出边距
        button.Position = UDim2.new(0, 5, 0, 0) -- 左边距 5
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = list
        applyParticleEffect(button)

        -- 绑定点击事件
        if callback then
            button.MouseButton1Click:Connect(function()
                uiclicker:Play()
                callback(button)
            end)
        end
    end

    -- 定义切换按钮方法
    local function addToogleButton(text, tooglevariable, enablecallback, disablecallback, callback)
        Invtooglevariable = tooglevariable
        local function setbuttonzt(text, tooglevariable, button)
            if tooglevariable then
                button.BackgroundColor3 = Color3.fromRGB(126, 126, 140)
                button.Text = text .. "(开)"
            else
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
                button.Text = text .. "(关)"
            end
        end

        -- 创建按钮
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(1, -10, 0, 30) -- 宽度减去 10 以留出边距
        button.Position = UDim2.new(0, 5, 0, 0) -- 左边距 5
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = list
        applyParticleEffect(button)

        setbuttonzt(text, tooglevariable, button)

        -- 绑定点击事件
        button.MouseButton1Click:Connect(function()
            tooglevariable = not tooglevariable
            uiclicker:Play()
            if callback then callback(button, tooglevariable) end
            if tooglevariable then
                if enablecallback then enablecallback(button, tooglevariable) end
            else
                if disablecallback then disablecallback(button, tooglevariable) end
            end
            setbuttonzt(text, tooglevariable, button)
        end)
    end

    -- 定义 removeButton 方法
    local function removeButton(text)
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") and child.Text == text then
                child:Destroy()
                break
            end
        end
    end

    -- 定义 clearAll 方法
    local function clearAll()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end

    -- 返回包含 add、removeButton 和 clearAll 方法的表
    return {
        add = addButton,
        addToogle = addToogleButton,
        removeButton = removeButton,
        clearAll = clearAll
    }
end

local function CreateButton(text, size, position, callback)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1) -- 白色
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = contentArea
    local uiCorner = Instance.new("UICorner", button)
    uiCorner.CornerRadius = UDim.new(0, 5)
    applyParticleEffect(button)
    button.MouseButton1Click:Connect(function()
        uiclicker:Play()
        if callback then
            callback(button)
        end
    end)
    return button
end

-- 创建滑块的函数
local function createSlider(size, position, minValue, maxValue, defaultValue, callback)
    -- 创建滑块容器
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = size
    sliderContainer.Position = position
    sliderContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 滑块背景色
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = contentArea

    -- 创建滑块的滑动条
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 1, 0) -- 滑动条高度为 5
    sliderTrack.Position = UDim2.new(0, 0, 0, 0) -- 垂直居中
    sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 滑动条颜色
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer

    local sliderTrack2 = Instance.new("Frame")
    sliderTrack2.Size = UDim2.new(1.1, 0, 1, 0) -- 滑动条高度为 5
    sliderTrack2.Position = UDim2.new(0, 0, 0, 0) -- 垂直居中
    sliderTrack2.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 滑动条颜色
    sliderTrack2.BorderSizePixel = 0
    sliderTrack2.Parent = sliderContainer

    -- 创建滑块的滑动按钮
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0.1, 0, 1, 0)
    sliderButton.Position = UDim2.new(0, 0, 0, 0) -- 初始位置在左侧
    sliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 170) -- 按钮颜色
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderContainer

    -- 滑块的当前值
    local currentValue = defaultValue or minValue

    -- 更新滑块按钮的位置和值显示
    local function updateSlider(value)
        -- 限制值在 minValue 和 maxValue 之间
        value = math.clamp(value, minValue, maxValue)

        -- 计算滑块按钮的位置
        local sliderWidth = sliderTrack.AbsoluteSize.X
        local normalizedValue = (value - minValue) / (maxValue - minValue)
        local buttonOffset = normalizedValue * sliderWidth

        -- 更新按钮位置
        sliderButton.Position = UDim2.new(0, buttonOffset, 0.5, -10)

        -- 更新值
        currentValue = value

        -- 调用回调函数
        if callback then
            callback(value)
        end
    end

    -- 绑定滑块按钮的拖动事件
    local isDragging = false
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            -- 计算滑块的值
            local mousePos = input.Position.X
            local sliderPos = sliderTrack.AbsolutePosition.X
            local sliderWidth = sliderTrack.AbsoluteSize.X
            local normalizedValue = (mousePos - sliderPos) / sliderWidth
            local value = minValue + normalizedValue * (maxValue - minValue)

            -- 更新滑块
            updateSlider(value)
        end
    end)

    -- 初始化滑块
    updateSlider(currentValue)

    -- 返回滑块对象
    return {
        getValue = function()
            return currentValue
        end,
        setValue = function(value)
            updateSlider(value)
        end
    }
end

local function createCheckbox(size, position, defaultState, callback)
    local checkboxContainer = Instance.new("TextButton")
    checkboxContainer.Size = size
    checkboxContainer.Position = position
    checkboxContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    checkboxContainer.BorderSizePixel = 0
    checkboxContainer.Text = ""
    checkboxContainer.AutoButtonColor = false
    checkboxContainer.Parent = contentArea

    local checkIcon = Instance.new("ImageLabel")
    checkIcon.Size = UDim2.new(1, 0, 1, 0)
    checkIcon.Position = UDim2.new(0, 0, 0, 0)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = "rbxassetid://11772672161"
    checkIcon.Parent = checkboxContainer

    local isChecked = defaultState or false

    local function updateCheckbox()
        checkIcon.Image = isChecked and "rbxassetid://11772695039" or "rbxassetid://11772672161"
        if callback then
            callback(isChecked)
        end
    end

    applyParticleEffect(checkboxContainer)

    checkboxContainer.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        uiclicker:Play()
        updateCheckbox()
    end)

    updateCheckbox()

    return {
        getState = function()
            return isChecked
        end,
        setState = function(state)
            isChecked = state
            updateCheckbox()
        end
    }
end

local function createDropdown(options, size, position, defaultText, callback)
    -- 创建 TextBox 作为输入框
    local textBox = CreateTextBox(defaultText, 18, size, position)
    textBox.PlaceholderText = defaultText

    -- 创建下拉菜单容器
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 200) -- 高度根据内容动态调整
    dropdownFrame.Position = UDim2.new(0, 0, size.Y.Scale, 20)
    dropdownFrame.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
    dropdownFrame.Visible = false -- 初始隐藏
    dropdownFrame.Parent = textBox

    -- 创建 ScrollingFrame 支持滚动
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46) -- 墨蓝色
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 170) -- 浅墨蓝色
    scrollingFrame.Parent = dropdownFrame

    -- 创建 UIListLayout 自动排列选项按钮
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = scrollingFrame

    -- 更新下拉菜单选项
    local function updateDropdownOptions(newOptions)
        -- 清空现有选项
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        -- 创建新的选项按钮
        for _, option in ipairs(newOptions) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
            optionButton.TextColor3 = Color3.new(1, 1, 1)
            optionButton.Text = option
            optionButton.Parent = scrollingFrame
            applyParticleEffect(optionButton)

            -- 点击选项后填充到 TextBox
            optionButton.MouseButton1Click:Connect(function()
                uiclicker:Play()
                textBox.Text = option
                dropdownFrame.Visible = false -- 隐藏下拉菜单
                if callback then
                    callback(option) -- 调用回调函数
                end
            end)
        end

        -- 动态调整下拉菜单高度
        local totalHeight = #newOptions * 30
        dropdownFrame.Size = UDim2.new(1, 0, 0, math.min(totalHeight, 550)) -- 最大高度为 150
    end

    -- 初始化下拉菜单选项
    updateDropdownOptions(options)

    -- 监听 TextBox 的点击事件
    textBox.Focused:Connect(function()
        dropdownFrame.Visible = true -- 显示下拉菜单
    end)

    textBox.FocusLost:Connect(function()
        task.wait(0.1) -- 延迟隐藏，避免点击选项时菜单立即消失
        dropdownFrame.Visible = false
    end)

    -- 监听 TextBox 的输入事件
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local input = textBox.Text:lower() -- 获取输入内容并转换为小写

        -- 过滤下拉菜单选项
        local filteredOptions = {}
        for _, option in ipairs(options) do
            if input == "" or option:lower():find(input) then
                table.insert(filteredOptions, option)
            end
        end

        -- 更新下拉菜单
        updateDropdownOptions(filteredOptions)
    end)

    -- 返回 TextBox 和更新选项的函数
    return {
        TextBox = textBox,
        UpdateOptions = function(newOptions)
            options = newOptions
            updateDropdownOptions(newOptions)
        end
    }
end

local pointsData = {}

-- 创建路径点列表的函数
local function createTeleportPointList(size, position)
    -- 创建主容器
    local container = Instance.new("Frame")
    container.Size = size
    container.Position = position
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
    container.Parent = contentArea

    -- 创建 ScrollingFrame 支持滚动
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0.87, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0.13, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = container

    -- 创建 UIListLayout 自动排列项目
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = scrollingFrame
    uiListLayout.Padding = UDim.new(0, 5) -- 设置项目间距

    -- 动态调整 ScrollingFrame 的 CanvasSize
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    -- 创建添加路径点的按钮
    local addButton = Instance.new("TextButton")
    addButton.Size = UDim2.new(1, 0, 0, 30)
    addButton.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
    addButton.TextColor3 = Color3.new(1, 1, 1)
    addButton.Text = "添加路径点"
    addButton.Parent = container
    addButton.TextSize = 14
    applyParticleEffect(addButton)

    -- 添加路径点的函数
    local isInitializing = true
    local function addPoint(position, note)

        -- 创建路径点项目
        local pointFrame = Instance.new("Frame")
        pointFrame.Size = UDim2.new(1, 0, 0, 30)
        pointFrame.BackgroundTransparency = 1 -- 透明背景
        pointFrame.Parent = scrollingFrame

        -- 创建备注文本框
        local noteBox = Instance.new("TextBox")
        noteBox.Size = UDim2.new(0.5, 0, 1, 0)
        noteBox.Position = UDim2.new(0, 0, 0, 0)
        noteBox.BackgroundColor3 = Color3.fromRGB(100, 100, 170)
        noteBox.TextColor3 = Color3.new(1, 1, 1)
        noteBox.PlaceholderText = "输入备注"
        noteBox.Text = note or "" -- 设置备注文本
        noteBox.Parent = pointFrame
        noteBox.TextSize = 14

        -- 创建传送按钮
        local teleportButton = Instance.new("TextButton")
        teleportButton.Size = UDim2.new(0.35, 0, 1, 0)
        teleportButton.Position = UDim2.new(0.5, 0, 0, 0)
        teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        teleportButton.TextColor3 = Color3.new(1, 1, 1)
        teleportButton.Text = "传送"
        teleportButton.Parent = pointFrame
        teleportButton.TextSize = 14
        applyParticleEffect(teleportButton)

        -- 创建删除按钮
        local deleteButton = Instance.new("TextButton")
        deleteButton.Size = UDim2.new(0.15, 0, 1, 0)
        deleteButton.Position = UDim2.new(0.85, 0, 0, 0)
        deleteButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- 红色背景
        deleteButton.TextColor3 = Color3.new(1, 1, 1)
        deleteButton.Text = "×"
        deleteButton.Parent = pointFrame
        deleteButton.TextSize = 14
        applyParticleEffect(deleteButton)

        -- 点击传送按钮的逻辑
        teleportButton.MouseButton1Click:Connect(function()
            uiclicker:Play()
            local character = game.Players.LocalPlayer.Character
            if character and character.PrimaryPart then
                character:SetPrimaryPartCFrame(CFrame.new(position))
            end
        end)

        -- 点击删除按钮的逻辑
        deleteButton.MouseButton1Click:Connect(function()
            uiclicker:Play()
            -- 从 pointsData 中移除当前路径点
            for i, point in ipairs(pointsData) do
                if point.position == position then
                    table.remove(pointsData, i)
                    break
                end
            end

            -- 销毁路径点项目
            pointFrame:Destroy()
        end)

        -- 如果不是初始化阶段，则将路径点信息存储到外部变量中
        if not isInitializing then
            local pointData = {
                position = position,
                note = noteBox.Text
            }
            table.insert(pointsData, pointData)

            -- 监听备注文本框的内容变化
            noteBox.FocusLost:Connect(function()
                pointData.note = noteBox.Text -- 更新备注内容
            end)
        end
    end

    -- 初始化时重新读取所有记录的数据
    for _, point in ipairs(pointsData) do
        addPoint(point.position, point.note)
    end
    isInitializing = false -- 初始化完成后，关闭标志变量

    -- 点击添加按钮的逻辑
    addButton.MouseButton1Click:Connect(function()
        uiclicker:Play()
        -- 获取玩家当前位置
        local character = game.Players.LocalPlayer.Character
        if character and character.PrimaryPart then
            local position = character.PrimaryPart.Position
            addPoint(position)
        end
    end)

    -- 返回路径点列表对象
    return {
        addPoint = addPoint
    }
end

-- 创建传送列表的函数
local function createTeleportList(size, position)
    -- 创建主容器
    local container = Instance.new("Frame")
    container.Size = size
    container.Position = position
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
    container.Parent = contentArea

    -- 创建 ScrollingFrame 支持滚动
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0.87, 0) -- 留出底部按钮的空间
    scrollingFrame.Position = UDim2.new(0, 0, 0.13, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = container

    -- 创建 UIListLayout 自动排列项目
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = scrollingFrame
    uiListLayout.Padding = UDim.new(0, 5) -- 设置项目间距

    -- 动态调整 ScrollingFrame 的 CanvasSize
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    -- 创建传送按钮
    local teleportButton = Instance.new("TextButton")
    teleportButton.Size = UDim2.new(1, 0, 0, 30)
    teleportButton.Position = UDim2.new(0, 0, 0, 0)
    teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
    teleportButton.TextColor3 = Color3.new(1, 1, 1)
    teleportButton.Text = "未选择玩家"
    teleportButton.Parent = container
    teleportButton.TextSize = 12
    applyParticleEffect(teleportButton)

    -- 存储选中的玩家
    local selectedPlayer = nil

    -- 更新传送按钮的文本
    local function updateTeleportButton()
        if selectedPlayer then
            teleportButton.Text = "传送到" .. selectedPlayer.Name
        else
            teleportButton.Text = "未选择玩家"
        end
    end

    -- 点击传送按钮的逻辑
    teleportButton.MouseButton1Click:Connect(function()
        uiclicker:Play()
        if selectedPlayer then
            local character = game.Players.LocalPlayer.Character
            if character and character.PrimaryPart then
                local targetCharacter = selectedPlayer.Character
                if targetCharacter and targetCharacter.PrimaryPart then
                    character:SetPrimaryPartCFrame(CFrame.new(targetCharacter.PrimaryPart.Position))
                else
                    warn("目标玩家角色不存在")
                end
            else
                warn("本地玩家角色不存在")
            end
        else
            warn("未选择玩家")
        end
    end)

    -- 创建玩家列表项的函数
    local function createPlayerListItem(player)
        local playerFrame = Instance.new("TextButton")
        playerFrame.Size = UDim2.new(1, 0, 0, 30)
        playerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        playerFrame.TextColor3 = Color3.new(1, 1, 1)
        playerFrame.Text = player.Name
        playerFrame.Parent = scrollingFrame
        playerFrame.TextSize = 12
        applyParticleEffect(playerFrame)

        -- 点击玩家名字的逻辑
        playerFrame.MouseButton1Click:Connect(function()
            uiclicker:Play()
            selectedPlayer = player
            updateTeleportButton()
        end)
    end

    -- 初始化玩家列表
    local function updatePlayerList()
        -- 清空现有玩家列表
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        -- 添加所有玩家到列表
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createPlayerListItem(player)
            end
        end
    end

    -- 监听玩家加入和离开事件
    game.Players.PlayerAdded:Connect(updatePlayerList)
    game.Players.PlayerRemoving:Connect(updatePlayerList)

    -- 初始化玩家列表
    updatePlayerList()

    -- 返回传送列表对象
    return {
        updatePlayerList = updatePlayerList
    }
end

local function applySyntaxHighlighting(codeBox)
    -- 定义语法元素及其颜色
    local syntaxRules = {
        { pattern = "\\b(function|local|if|then|else|end|for|while|do|return|repeat|until|break|nil|true|false)\\b", color = Color3.fromRGB(86, 156, 214) }, -- 关键字（蓝色）
        { pattern = "\"[^\"]*\"|\'[^\']*\'", color = Color3.fromRGB(152, 195, 121) }, -- 字符串（绿色）
        { pattern = "%-%-%[%[.*%]%]", color = Color3.fromRGB(128, 128, 128) }, -- 多行注释（灰色）
        { pattern = "%-%-[^\n]*", color = Color3.fromRGB(128, 128, 128) }, -- 单行注释（灰色）
        { pattern = "\\b\\d+\\.?\\d*\\b", color = Color3.fromRGB(255, 165, 0) }, -- 数字（橙色）
        { pattern = "\\+|-|\\*|/|%%|==|~=|<=|>=|<|>|and|or|not", color = Color3.fromRGB(255, 59, 48) }, -- 操作符（红色）
        { pattern = "\\b\\w+\\s*%(", color = Color3.fromRGB(198, 120, 221) }, -- 函数调用（紫色）
    }

    -- 获取原始文本
    local text = codeBox.Text

    -- 重置文本颜色
    codeBox.Text = text

    -- 应用语法高亮
    for _, rule in ipairs(syntaxRules) do
        text = string.gsub(text, rule.pattern, function(match)
            return "<font color='rgb(" .. math.floor(rule.color.R * 255) .. "," .. math.floor(rule.color.G * 255) .. "," .. math.floor(rule.color.B * 255) .. ")'>" .. match .. "</font>"
        end)
    end

    -- 更新文本框内容
    codeBox.Text = text
end

local function createCodeEditor(size, position)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = size
    ScrollingFrame.Position = position
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始 CanvasSize
    ScrollingFrame.Parent = contentArea

    local LineNumbers = Instance.new("TextLabel")
    LineNumbers.Size = UDim2.new(0.05, 0, 1, 0)
    LineNumbers.Position = UDim2.new(0, 0, 0, 0)
    LineNumbers.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LineNumbers.BorderSizePixel = 0
    LineNumbers.TextColor3 = Color3.fromRGB(200, 200, 200)
    LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
    LineNumbers.Text = "1"
    LineNumbers.Font = Enum.Font.Code -- 使用等宽字体
    LineNumbers.TextSize = 14 -- 调整字体大小
    LineNumbers.Parent = ScrollingFrame

    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(0.95, 0, 1, 0)
    CodeBox.Position = UDim2.new(0.05, 0, 0, 0)
    CodeBox.BackgroundTransparency = 1
    CodeBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.RichText = true -- 启用 RichText
    CodeBox.TextWrapped = true
    CodeBox.MultiLine = true
    CodeBox.ClearTextOnFocus = false
    CodeBox.Text = ""
    CodeBox.Font = Enum.Font.Code -- 使用等宽字体
    CodeBox.TextSize = 14 -- 调整字体大小
    CodeBox.Parent = ScrollingFrame

    -- 更新行号
    local function updateLineNumbers()
        local lines = #string.split(CodeBox.Text, "\n")
        local lineNumbersText = table.concat({}, "\n")
        for i = 1, lines do
            lineNumbersText = lineNumbersText .. tostring(i) .. "\n"
        end
        LineNumbers.Text = lineNumbersText

        -- 调整 CanvasSize
        local lineHeight = CodeBox.TextSize + 4 -- 每行高度
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, lines * lineHeight)
    end

    -- 监听输入
    CodeBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateLineNumbers()
        applySyntaxHighlighting(CodeBox)
    end)

    -- 同步滚动
    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        LineNumbers.Position = UDim2.new(0, 0, 0, -ScrollingFrame.CanvasPosition.Y)
    end)

    -- 返回接口
    return {
        get = function()
            return CodeBox.Text
        end,
        set = function(text)
            CodeBox.Text = text
            updateLineNumbers()
            applySyntaxHighlighting(CodeBox)
        end
    }
end

local PlayerMessage = {}
local pcrcreate = false

local function createPlayerChatReceiver(size, position)
    -- 创建主容器
    local container = Instance.new("Frame")
    container.Size = size
    container.Position = position
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
    container.Parent = contentArea

    -- 创建 ScrollingFrame 支持滚动
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0.87, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0.13, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = container

    -- 创建 UIListLayout 自动排列项目
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = scrollingFrame
    uiListLayout.Padding = UDim.new(0, 5) -- 设置项目间距

    -- 动态调整 ScrollingFrame 的 CanvasSize
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    -- 创建搜索框
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, 0, 0, 30)
    searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.Text = ""
    searchBox.Parent = container
    searchBox.TextSize = 14
    searchBox.PlaceholderText = "搜索玩家名"

    -- 存储所有聊天记录的容器
    local chatLogs = {}

    -- 添加聊天记录的函数
    local isInitializing = true
    local function addChatLog(playername, playermessage)
        -- 创建聊天记录项目
        local chatFrame = Instance.new("Frame")
        chatFrame.Size = UDim2.new(1, 0, 0, 30)
        chatFrame.BackgroundTransparency = 1 -- 透明背景
        chatFrame.Parent = scrollingFrame

        -- 玩家名显示
        local nameBox = Instance.new("TextLabel")
        nameBox.Size = UDim2.new(0.3, 0, 1, 0)
        nameBox.Position = UDim2.new(0, 0, 0, 0)
        nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
        nameBox.TextColor3 = Color3.new(1, 1, 1)
        nameBox.Text = playername
        nameBox.Parent = chatFrame
        nameBox.TextSize = 10

        -- 聊天内容显示
        local msgBox = Instance.new("TextLabel")
        msgBox.Size = UDim2.new(0.6, 0, 1, 0)
        msgBox.Position = UDim2.new(0.3, 0, 0, 0)
        msgBox.BackgroundColor3 = Color3.fromRGB(100, 100, 170)
        msgBox.TextColor3 = Color3.new(1, 1, 1)
        msgBox.Text = playermessage
        msgBox.TextXAlignment = Enum.TextXAlignment.Left
        msgBox.Parent = chatFrame
        msgBox.TextSize = 10

        -- 复制按钮
        local copyButton = Instance.new("TextButton")
        copyButton.Size = UDim2.new(0.1, 0, 1, 0)
        copyButton.Position = UDim2.new(0.9, 0, 0, 0)
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 238, 118)
        copyButton.TextColor3 = Color3.new(1, 1, 1)
        copyButton.Text = "📋"
        copyButton.Parent = chatFrame
        copyButton.TextSize = 14

        -- 点击复制按钮的逻辑
        copyButton.MouseButton1Click:Connect(function()
            uiclicker:Play()
            setclipboard(msgBox.Text)
            CreateNotification("复制到剪切板", "已将" .. msgBox.Text .. "复制到剪切板", 5, true)
        end)

        -- 如果不是初始化阶段，则将聊天记录存储到外部变量中
        if not isInitializing then
            local chatData = {
                name = playername,
                chat = playermessage,
                frame = chatFrame -- 存储聊天记录的 UI 对象
            }
            table.insert(chatLogs, chatData) -- 添加到聊天记录容器中
        else
            -- 如果是初始化阶段，直接添加到聊天记录容器中
            table.insert(chatLogs, {
                name = playername,
                chat = playermessage,
                frame = chatFrame
            })
        end
    end

    -- 过滤聊天记录的函数
    local function filterChatLogs(searchText)
        for _, chatData in ipairs(chatLogs) do
            -- 如果搜索文本为空或玩家名包含搜索文本，则显示聊天记录
            if searchText == "" or string.find(string.lower(chatData.name), string.lower(searchText)) then
                chatData.frame.Visible = true
            else
                chatData.frame.Visible = false
            end
        end
    end

    -- 监听搜索框输入
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        filterChatLogs(searchBox.Text)
    end)

    -- 初始化时重新读取所有记录的数据
    for _, msg in ipairs(PlayerMessage) do
        addChatLog(msg.name, msg.chat)
    end
    isInitializing = false -- 初始化完成后，关闭标志变量
    pcrcreate = true

    aaaa = TextChatService.MessageReceived:Connect(function(message)
        if not pcrcreate then
            aaaa:Disconnect()
        else
            if message.TextSource then
                local player = Players:GetPlayerByUserId(message.TextSource.UserId)
                if not player then return end
                addChatLog(player.Name, message.Text)
            end
        end
    end)

    return {
        addChatLog = addChatLog
    }
end

chatcheck = TextChatService.MessageReceived:Connect(function(message)
    if message.TextSource then
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        if not player then return end
        local chatData = {
            name = player.Name,
            chat = message.Text
        }
        table.insert(PlayerMessage, chatData)
    end
end)

local data = {
    sirenhead_legacy = {
        cratexray = false,
        berryxray = false,
        cratemodule = HighlightModule.new("crate", "other", "item"),
        cratenametagmodule = NameTagModule.new("crate", "模糊", 20, true, "盒子"),
        berrymodule = HighlightModule.new("berry", "other", "item"),
        berrynametagmodule = NameTagModule.new("berry", "模糊", 20, true, "浆果")
    },
    west_wood = {
        monster_xray = false,
        monster = NameTagModule.new("WendigoAI", "模糊", 20, true, "怪物")
    },
    nightmare_run = {
        highlightmonster = false,
        monster = MovableHighlighter_NM.new(),
        HLCheese = HighlightModule.new("Cheese", "other", "item"),
        Lantern = PlayerLightModule.new({ Brightness = 3, Range = 20, Color = Color3.fromRGB(255, 165, 0), Shadows = true }),
        SuperLighter = PlayerLightModule.new({ Brightness = 2, Range = 1000 }),
        LanternOffin = false,
        SuperLighterOffin = false
    },
    office = {
        entitywarning = false,
        tipotherplayer = false,
        auto013 = false
    },
    musictest = {
        enable = false,
        threshold = 10
    },
    setting = {
        BindKey = "RightShift"
    },
    musicbox = {
        id = "1837879082",
        isPlay = false,
        isPause = false,
        PlayLocation = nil
    },
    executer = {
        scripts = "print(\"Hello World\")"
    },
    tools = {
        nightvision = false,
        noclip = false,
        infjump = false,
        airwalk = false,
        playeresp = false,
        antifall = false,
        antifallplus = false,
        antidead = false,
        floorY = nil,
        Spectator = false,
        landingeffect = false,
        visible = false,
        translation = false,
        mouseisunlock = false,
        zoomenable = false,
        zoom = ZoomModule.new(),
        antifling = false
    },
    playercontrol = {
        lockspeed = false,
        lockjump = false,
        lockmaxhealth = false,
        lockhealth = false,
        lockgravity = false
    },
    playerattr = {
        speed = LocalPlayer.Character.Humanoid.WalkSpeed,
        jump = LocalPlayer.Character.Humanoid.JumpPower,
        maxhealth = LocalPlayer.Character.Humanoid.MaxHealth,
        health = LocalPlayer.Character.Humanoid.Health,
        gravity = game.Workspace.Gravity
    },
    grace = {
        autolever = false,
        deleteentite = false
    },
    pt = {
        esp = false,
        modelsToHighlight = {
            {
                name = "__BasicSmallSafe",
                text = "小保险箱",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "__BasicLargeSafe",
                text = "大保险箱",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "__LargeGoldenSafe",
                text = "金保险箱",
                color = Color3.fromRGB(255, 215, 0), -- 金色
                enabled = false
            },
            {
                name = "Surplus Crate",
                text = "武器盒",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "Military Crate",
                text = "武器盒",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            },
            {
                name = "SupplyDrop",
                text = "空投",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false -- 默认不高亮
            },
            {
                name = "Bot",
                text = "人机",
                color = Color3.new(1, 1, 1), -- 白色
                enabled = false
            }
        },
        highlights = {},
        labels = {}
    },
    deathball = {
        enable = false
    }
}

-- 定义白天和黑夜的光照属性
local daySettings = {
    ClockTime = 14, -- 白天时间（14:00）
    GeographicLatitude = 41.73, -- 纬度（影响太阳高度）
    -- Ambient = Color3.new(0.5, 0.5, 0.5), -- 环境光
    -- OutdoorAmbient = Color3.new(0.5, 0.5, 0.5), -- 室外环境光
    -- Brightness = 2, -- 亮度
    -- FogColor = Color3.new(0.8, 0.8, 0.8), -- 雾颜色
    -- FogEnd = 1000 -- 雾结束距离
}

local nightSettings = {
    ClockTime = 2, -- 黑夜时间（02:00）
    GeographicLatitude = 41.73, -- 纬度
    -- Ambient = Color3.new(0.1, 0.1, 0.1), -- 环境光
    -- OutdoorAmbient = Color3.new(0.1, 0.1, 0.1), -- 室外环境光
    -- Brightness = 0.2, -- 亮度
    -- FogColor = Color3.new(0.1, 0.1, 0.1), -- 雾颜色
    -- FogEnd = 500 -- 雾结束距离
}

-- 切换为白天
local function setDay()
    for property, value in pairs(daySettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

-- 切换为黑夜
local function setNight()
    for property, value in pairs(nightSettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

local floorPart = nil

-- 创建地板
local function createFloor()
    if floorPart then return end -- 如果地板已存在，则不重复创建
    
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 创建地板
    floorPart = Instance.new("Part")
    floorPart.Size = Vector3.new(10, 1, 10) -- 地板大小
    floorPart.Transparency = 1 -- 完全透明
    floorPart.Anchored = true -- 固定位置
    floorPart.CanCollide = true -- 允许碰撞
    floorPart.Parent = workspace

    -- 添加发光特效
    local glow = Instance.new("SurfaceGui", floorPart)
    glow.Face = Enum.NormalId.Top
    local frame = Instance.new("Frame", glow)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 1, 0) -- 白色发光
    frame.BackgroundTransparency = 0.4 -- 半透明
    frame.BorderSizePixel = 0

    -- 记录当前地板的 Y 轴高度
    data.tools.floorY = HumanoidRootPart.Position.Y - HumanoidRootPart.Size.Y / 2 - floorPart.Size.Y / 2 - 1.8
    floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, data.tools.floorY, HumanoidRootPart.Position.Z)
end

-- 删除地板
local function destroyFloor()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
        data.tools.floorY = nil
    end
end

-- 切换空中行走状态
local function toggleAirWalk()
    data.tools.airwalk = not data.tools.airwalk
    if data.tools.airwalk then
        createFloor() -- 启用时创建地板
    else
        destroyFloor() -- 禁用时删除地板
    end
end

-- 更新地板位置
RunService.Heartbeat:Connect(function()
    if data.tools.airwalk and floorPart and data.tools.floorY then
        -- 将地板的 X 和 Z 轴与玩家对齐，Y 轴固定
        floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, data.tools.floorY, HumanoidRootPart.Position.Z)
    end
end)

-- 监听状态变化
humanoid.StateChanged:Connect(function(oldState, newState)
    if data.tools.antifall then
        if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- 强制恢复站立状态
            CreateNotification("提示", "检测到被击倒，已恢复站立状态", 5, true)
        end
    end
end)

-- 监听玩家死亡事件
local function onCharacterDied()
    if data.tools.airwalk then
        data.tools.airwalk = false
        destroyFloor()
    end
end

-- 监听角色变化
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 重新绑定死亡事件
    humanoid.Died:Connect(onCharacterDied)
end)

-- 初始绑定死亡事件
humanoid.Died:Connect(onCharacterDied)

-- 创建高亮和文字标签
local function createHighlightAndLabel(model)
    -- 创建高亮
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5 -- 透视效果
    highlight.OutlineTransparency = 0
    highlight.Parent = model

    -- 创建文字标签
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = model
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0) -- 文字在模型上方
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = ""
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.Parent = billboard

    billboard.Parent = model

    -- 存储高亮和标签
    data.pt.highlights[model] = highlight
    data.pt.labels[model] = textLabel
end

-- 更新高亮和文字标签
local function updateHighlightAndLabel(model)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if model.Name == modelInfo.name then
            if modelInfo.enabled then
                data.pt.highlights[model].FillColor = modelInfo.color
                data.pt.labels[model].Text = modelInfo.text
                data.pt.highlights[model].Enabled = true -- 启用高亮
            else
                data.pt.highlights[model].Enabled = false -- 禁用高亮
                data.pt.labels[model].Text = "" -- 清空文字
            end
            break
        end
    end
end

-- 删除高亮和文字标签
local function removeHighlightAndLabel(model)
    if data.pt.highlights[model] then
        data.pt.highlights[model]:Destroy()
        data.pt.highlights[model] = nil
    end
    if data.pt.labels[model] then
        data.pt.labels[model].Parent:Destroy()
        data.pt.labels[model] = nil
    end
end

-- 动态更新高亮状态
local function updateHighlights()
    for model in pairs(data.pt.highlights) do
        updateHighlightAndLabel(model)
    end
end

-- 开关功能
local function toggleFeature(offon)
    if offon then
        data.pt.esp = true
        -- 遍历 Workspace，查找需要高亮的模型
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") then
                for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
                    if model.Name == modelInfo.name then
                        if not data.pt.highlights[model] then
                            createHighlightAndLabel(model)
                        end
                        updateHighlightAndLabel(model)
                        break
                    end
                end
            end
        end
    else
        data.pt.esp = false
        -- 删除所有高亮和文字标签
        for model in pairs(data.pt.highlights) do
            removeHighlightAndLabel(model)
        end
    end
end

-- 动态添加新模型到高亮列表
local function addModelToHighlight(name, text, color, enabled)
    table.insert(data.pt.modelsToHighlight, {
        name = name,
        text = text,
        color = color,
        enabled = enabled
    })

    -- 如果功能已开启，立即应用高亮
    if data.pt.esp then
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == name then
                if not data.pt.highlights[model] then
                    createHighlightAndLabel(model)
                end
                updateHighlightAndLabel(model)
                break
            end
        end
    end
end

local function refrishhighlight()
    toggleFeature(false)
    toggleFeature(true)
end

-- 切换某个模型的高亮状态
local function toggleModelHighlight(name)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            modelInfo.enabled = not modelInfo.enabled -- 切换高亮状态
            break
        end
    end

    -- 如果功能已开启，立即更新高亮
    if data.pt.esp then
        for model in pairs(data.pt.highlights) do
            if model.Name == name then
                updateHighlightAndLabel(model)
                break
            end
        end
        refrishhighlight()
    end
end

-- 读取某个模型的高亮状态
local function getModelHighlight(name)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            return modelInfo.enabled
        end
    end
end

-- 动态修改模型的高亮状态
local function setModelHighlightEnabled(name, enabled)
    for _, modelInfo in ipairs(data.pt.modelsToHighlight) do
        if modelInfo.name == name then
            modelInfo.enabled = enabled
            break
        end
    end

    -- 如果功能已开启，立即更新高亮
    if data.pt.esp then
        for model in pairs(data.pt.highlights) do
            if model.Name == name then
                updateHighlightAndLabel(model)
                break
            end
        end
    end
end

local GGcount = 0

al = workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "base" and descendant:IsA("BasePart") and data.grace.autolever then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            descendant.CFrame = player.Character.HumanoidRootPart.CFrame
            GGcount = GGcount + 1
            if GGcount >= 3 then
                CreateNotification("Grace", "全部拉杆已被激活\n门已打开", 5, true)
                GGcount = 0
            end
            task.wait(1)
            descendant.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end)

local processedCharacters = {}

ds = workspace.DescendantAdded:Connect(function(descendant)
    if data.grace.deleteentite then
        if descendant.Name == "eye" or descendant.Name == "elkman" or descendant.Name == "Rush" or descendant.Name == "Worm" or descendant.Name == "eyePrime" then
            descendant:Destroy()
        end
    end
    if data.pt.esp then
        if descendant:IsA("Model") and getModelHighlight("Bot") and descendant.Name == "Bot" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("__BasicSmallSafe") and descendant.Name == "__BasicSmallSafe" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("__BasicLargeSafe") and descendant.Name == "__BasicLargeSafe" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("__LargeGoldenSafe") and descendant.Name == "__LargeGoldenSafe" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("Surplus Crate") and descendant.Name == "Surplus Crate" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("Military Crate") and descendant.Name == "Military Crate" then refrishhighlight() end
        if descendant:IsA("Model") and getModelHighlight("SupplyDrop") and descendant.Name == "SupplyDrop" then refrishhighlight() end
    end
    if data.tools.playeresp then
        local player = Players:GetPlayerFromCharacter(descendant)
        if player and not processedCharacters[player] then
            processedCharacters[player] = true
            player.CharacterAdded:Connect(function(character)
                addHighlight(player)
                addUsernameLabel(player)
                -- 角色销毁时清理标记
                player.CharacterRemoving:Connect(function()
                    processedCharacters[player] = nil
                end)
            end)
        end
    end
end)

local function TeleportTo(x, y, z)
	-- 验证输入是否为数字
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		warn("[Teleport] 请传入三个数字：TeleportTo(x, y, z)")
		return false
	end

	local character = player.Character
	if not character then
		character = player.CharacterAdded:Wait()
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		warn("[Teleport] 未找到 HumanoidRootPart")
		return false
	end

	-- 执行传送
	rootPart.CFrame = CFrame.new(Vector3.new(x, y, z))

	CreateNotification("提示", string.format("✅ 已传送到 (%.1f, %.1f, %.1f)", x, y, z), 5, true)
	return true
end

local function TeleportToPresent(presentNumber)
	if type(presentNumber) ~= "number" then
		CreateNotification("错误", "请输入数字", 5, true)
		return false
	end

	-- 查找主模型（兼容带 % 和不带 %）
	local mainModel = Workspace:FindFirstChild("XMas_PresentHunt%") 
		or Workspace:FindFirstChild("XMas_PresentHunt")
	if not mainModel then
		CreateNotification("错误", "未找到XMas_PresentHunt%模型", 5, true)
		return false
	end

	local presents = mainModel:FindFirstChild("Presents")
	if not presents then
		CreateNotification("错误", "未找到Presents文件夹", 5, true)
		return false
	end

	local gift = presents:FindFirstChild(tostring(presentNumber))
	if not gift or not gift:IsA("Model") then
		CreateNotification("错误", string.format("[Teleport] 编号 %d 的礼物不存在", presentNumber), 5, true)
		return false
	end

	-- 获取礼物位置（使用 GetPivot 获取整体中心）
	local giftCFrame = gift:GetPivot()
	local character = player.Character
	if not character then
		CreateNotification("错误", "角色未加载", 5, true)
		return false
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		CreateNotification("错误", "未找到HumanoidRootPart", 5, true)
		return false
	end

	-- 传送到礼物正上方一点（避免卡进模型）
	local targetCFrame = CFrame.new(giftCFrame.Position + Vector3.new(0, 3, 0))
	rootPart.CFrame = targetCFrame

	CreateNotification("提示", string.format("✅ 已传送到礼物 #%d！", presentNumber), 5, true)
	return true
end

Stepped6 = game:GetService("RunService").Stepped:Connect(function()
    if data.grace.deleteentite then 
    local RS = game:GetService("ReplicatedStorage")
    RS.eyegui:Destroy()
    RS.smilegui:Destroy()
    RS.SendRush:Destroy()
    RS.SendWorm:Destroy()
    RS.SendSorrow:Destroy()
    RS.SendGoatman:Destroy()
    wait(0.1)
    RS.Worm:Destroy()
    RS.elkman:Destroy()
    wait(0.1)
    RS.QuickNotes.Eye:Destroy()
    RS.QuickNotes.Rush:Destroy()
    RS.QuickNotes.Sorrow:Destroy()
    RS.QuickNotes.elkman:Destroy()  
    RS.QuickNotes.EyePrime:Destroy()
    RS.QuickNotes.SlugFish:Destroy()
    RS.QuickNotes.FakeDoor:Destroy()
    RS.QuickNotes.SleepyHead:Destroy()
    local SmileGui = player:FindFirstChild("PlayerGui"):FindFirstChild("smilegui")
    if SmileGui then
        SmileGui:Destroy()
    end
    end
    if data.tools.nightvision then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

local gsr = game:GetService("RunService").Stepped:Connect(function()
    if data.playercontrol.lockspeed then LocalPlayer.Character.Humanoid.WalkSpeed = data.playerattr.speed end
    if data.playercontrol.lockjump then LocalPlayer.Character.Humanoid.JumpPower = data.playerattr.jump end
    if data.playercontrol.lockmaxhealth then LocalPlayer.Character.Humanoid.MaxHealth = data.playerattr.maxhealth end
    if data.playercontrol.lockhealth then LocalPlayer.Character.Humanoid.Health = data.playerattr.health end
    if data.playercontrol.lockgravity then game.Workspace.Gravity = data.playerattr.gravity end
    if data.tools.antidead then Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
end)

-- 获取当前游戏中所有的 Sound 实例
local function getAllSounds(parent)
    local sounds = {}
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("Sound") then
            table.insert(sounds, child)
        end
    end
    return sounds
end

-- 提取 SoundId 中的数字部分
local function extractSoundIdNumber(soundId)
    -- 使用正则表达式匹配数字部分
    local number = string.match(soundId, "rbxassetid://(%d+)")
    return number or soundId -- 如果没有匹配到数字，返回原 SoundId
end


-- 获取音量较大的音频列表
local function getLoudSounds(threshold)
    local loudSounds = {}
    local sounds = getAllSounds(game) -- 获取游戏中所有的 Sound 实例

    for _, sound in ipairs(sounds) do
        if sound.IsPlaying and sound.PlaybackLoudness > threshold then
            local cleanSoundId = extractSoundIdNumber(sound.SoundId)
            table.insert(loudSounds, {
                SoundId = cleanSoundId,
                Loudness = sound.PlaybackLoudness
            })
        end
    end

    return loudSounds
end

local entitys = {
    NormalEntity = { name = "EN-001", tip = "立刻躲在柜子中！" },
    NormalEntityType2 = { name = "EN-001-02", tip = "立刻躲在柜子中！" },
    SnakeEntity = { name = "EN-002", tip = "多待在柜子里一会！" },
    TrainEntity = { name = "EN-003", tip = "不要犹豫，立刻躲起来！" },
    LateEntity = { name = "EN-004", tip = "稍后躲在柜子中！" },
    ReboundingEntity = { name = "EN-005", tip = "把握住进柜子的时间，他会来回冲！" },
    PeaceEntity = { name = "EN-006", tip = "千万不要躲在柜子中！" },
    VisionEntity = { name = "EN-007", tip = "不要躲在墙壁后！" },
    FocusEntity = { name = "EN-008", tip = "躲在柜子中，记住钥匙的位置！" },
    ShadowEntity = { name = "EN-011", tip = "他在黑暗中，不要看他！" },
    GhostEntity = { name = "EN-012", tip = "注意他的规则！" },
    UnknownEntity = { name = "EN-013", tip = "快点输入 'staycalmstayfocused'"},
    ChaserEntity = { name = "EN-015", tip = "快跑！" },
    DelmonEntity = { name = "EN-0??", tip = "暂未收录该数据" },
    DoorcamperEntity = { name = "EN-017", tip = "多注意门后！" }
}

-- 检测新实例并匹配预定义列表
local function detectEntity(instance)
    if instance:IsA("BasePart") then
        for entityName, entityInfo in pairs(entitys) do
            if instance.Name == entityName then
                if data.office.entitywarning then
                    CreateNotification("！警告！", "实体" .. entityInfo.name .. "已生成！\n" .. entityInfo.tip, 5, true)
                    if data.office.tipotherplayer then chatMessage("警告！实体" .. entityInfo.name .. "已生成！" .. entityInfo.tip) end
                end
                if data.office.auto013 then
                    if instance.Name == "UnknownEntity" then
                        CreateNotification("自动EN-013", "正在自动键入'staycalmstayfocused'...", 5, true)
                        wait(2)
                        local str = "staycalmstayfocused"
                        for i = 1, #str do
                            local char = string.sub(str, i, i) -- 提取第 i 个字符
                            VirtualInputManager:SendKeyEvent(true, char, false, game)
                            wait(0.2)
                        end
                    end
                end
                break
            end
        end
    end
end

local offce = Workspace.DescendantAdded:Connect(detectEntity)

local function rejoinCurrentGame()
    local placeId1 = game.PlaceId          -- 当前游戏的地图ID
    local jobId1 = game.JobId              -- 当前游戏服务器的唯一ID

    if jobId1 and jobId1 ~= "" then
        -- 传送到同一实例
        TeleportService:TeleportToPlaceInstance(placeId1, jobId1, player)
    else
        -- 如果没有 JobId（极少情况），则退而求其次使用普通传送（可能随机分配到其他服务器）
        warn("无法获取 JobId，将使用普通传送，可能不会回到同一个房间。")
        TeleportService:Teleport(placeId1, player)
    end
end

--===========================================================================================--
--==========================================[主界面]==========================================--
--===========================================================================================--

local isProcessing = false
local isProcessing2 = false
local isProcessing3 = false
local selectcontent = "关于"
local Supported_Games = {
    { gameid = 2162087722, name = "兽化项目" },
    { gameid = 6508759464, name = "格蕾丝" },
    { gameid = 5166944221, name = "死亡球" },
    { gameid = 9161109257, name = "小屋角色扮演" },
    { gameid = 6352299542, name = "妄想办公室" },
    { gameid = 972475338,  name = "南极探险队" },
    { gameid = 6996099240, name = "噩梦之行" },
    { gameid = 5265348926, name = "西部森林" },
    { gameid = 5429450445, name = "警笛头:遗产" }
}

-- 添加菜单内容
local function AddMenuContent(category)
    if category == selectcontent then return end
    selectcontent = category
    -- 清空内容区域
    for _, child in ipairs(contentArea:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    -- 重置部分操作
    data.musictest.enable = false
    testbox:Stop()
    pcrcreate = false

    -- 根据分类添加内容
    if category == "妄想办公室" then
        local WXOList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        WXOList.addToogle("实体警告", data.office.entitywarning, _, _, function(_, newState) data.office.entitywarning = newState end)
        WXOList.addToogle("提醒他人", data.office.tipotherplayer, _, _, function(_, newState) data.office.tipotherplayer = newState end)
        WXOList.addToogle("自动EN-013", data.office.auto013, _, _, function(_, newState) data.office.auto013 = newState end)
    elseif category == "聊天接收器" then
        createPlayerChatReceiver(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
    elseif category == "音频检查器" then
        CreateLabel("筛选音量分贝", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.01, 0, 0.23, 0))
        CreateTextBox(data.musictest.threshold, 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.05, 0, 0.3, 0), function(textBox)
            data.musictest.threshold = tonumber(textBox.Text)
        end)
        local selectmsid = CreateLabel("当前选中", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.03, 0))
        local selectmusicida = nil
        local testmusicplay = false
        CreateButton("📋", UDim2.new(0.07, 0, 0.09, 0), UDim2.new(0.6, 0, 0.015, 0), function(button)
            if selectmusicida ~= nil then
                setclipboard(tostring(selectmusicida))
                CreateNotification("复制到剪切板", "已将" .. tostring(selectmusicida) .. "复制到剪切板", 5, true)
            end
        end)
        CreateButton(testmusicplay and "结束播放" or "尝试播放", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.31, 0, 0.1, 0), function(button)
            testmusicplay = not testmusicplay
            button.Text = testmusicplay and "结束播放" or "尝试播放"
            if testmusicplay then
                testbox.SoundId = "rbxassetid://" .. selectmusicida
                testbox:Play()
            else
                testbox:Stop()
            end
        end)
        CreateLabel("音频ID", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.23, 0))
        local musicidList = CreateList(UDim2.new(0, 100, 0.645, 0), UDim2.new(0.30, 0, 0.3, 0))
        CreateLabel("操作面板", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.01, 0, 0.03, 0))
        CreateButton(data.musictest.enable and "关闭检测" or "开始检测", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.1, 0), function(button)
            data.musictest.enable = not data.musictest.enable
            button.Text = data.musictest.enable and "关闭检测" or "开始检测"
            local lastExecutionTime = tick()
            llt = game:GetService("RunService").Stepped:Connect(function()
                if not data.musictest.enable then
                    llt:Disconnect()
                else
                    local currentTime = tick()
                    if currentTime - lastExecutionTime >= 0.5 then
                        lastExecutionTime = currentTime
                        musicidList.clearAll()
                        local loudSounds = getLoudSounds(data.musictest.threshold)
                        if #loudSounds > 0 then
                            for _, soundInfo in ipairs(loudSounds) do
                                musicidList.add(soundInfo.SoundId, function(button)
                                    selectmusicida = tonumber(button.Text)
                                    selectmsid.Text = "当前选中:" .. button.Text
                                end)
                            end
                        end
                    end
                end
            end)
        end)
    elseif category == "关于" then
        CreateLabel("欢迎使用", 18, UDim2.new(0.4, 0, 0.08, 0), UDim2.new(0.3, 0, 0.1, 0))
        CreateLabel("作者: Chronix", 18, UDim2.new(0.2, 0, 0.08, 0), UDim2.new(0.1, 0, 0.2, 0))
        CreateLabel("所有代码均由Chronix编写，允许参考学习，严禁照搬盗用", 16, UDim2.new(0.4, 0, 0.08, 0), UDim2.new(0.3, 0, 0.9, 0))
    elseif category == "设置" then
        CreateLabel("主界面", 18, UDim2.new(0.2, 0, 0.08, 0), UDim2.new(0.1, 0, 0.1, 0))
        CreateButton(data.setting.BindKey, UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.65, 0, 0.1, 0), function(button)
            isProcessing = true
            button.Text = "按下任意键..."
            -- 监听按键按下事件
            aa = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                local keyName = tostring(input.KeyCode):gsub("^Enum%.%w+%.", "")
                button.Text = keyName -- 将按键名称设置为文本框内容
                data.setting.BindKey = keyName
                achievementSound:Stop()
                aa:Disconnect()
            end)
        end)
        CreateLabel("灵魂出窍", 18, UDim2.new(0.2, 0, 0.08, 0), UDim2.new(0.1, 0, 0.25, 0))
        CreateButton(tostring(FreecamModule.getKeybind()):gsub("^Enum%.%w+%.", ""), UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.65, 0, 0.25, 0), function(button)
            isProcessing2 = true
            button.Text = "按下任意键..."
            -- 监听按键按下事件
            ap = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                local keyName = tostring(input.KeyCode):gsub("^Enum%.%w+%.", "")
                button.Text = keyName -- 将按键名称设置为文本框内容
                FreecamModule.setKeybind(input.KeyCode)
                achievementSound:Stop()
                ap:Disconnect()
            end)
        end)
        CreateLabel("望远镜", 18, UDim2.new(0.2, 0, 0.08, 0), UDim2.new(0.1, 0, 0.4, 0))
        CreateButton(tostring(data.tools.zoom:GetBindKey()):gsub("^Enum%.%w+%.", ""), UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.65, 0, 0.4, 0), function(button)
            isProcessing3 = true
            button.Text = "按下任意键..."
            -- 监听按键按下事件
            az = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                local keyName = tostring(input.KeyCode):gsub("^Enum%.%w+%.", "")
                button.Text = keyName -- 将按键名称设置为文本框内容
                data.tools.zoom:SetBindKey(input.KeyCode)
                achievementSound:Stop()
                az:Disconnect()
            end)
        end)
        CreateLabel("TPWalk距离", 18, UDim2.new(0.2, 0, 0.08, 0), UDim2.new(0.1, 0, 0.55, 0))
        CreateTextBox(tpWalk:GetSpeed(), 18, UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.65, 0, 0.55, 0), function(textBox)
            tpWalk:SetSpeed(tonumber(textBox.Text))
        end)
    elseif category == "传送器" then
        createTeleportPointList(
            UDim2.new(0.48, 0, 0.98, 0), -- 大小
            UDim2.new(0.01, 0, 0.01, 0) -- 位置
        )
        createTeleportList(
            UDim2.new(0.48, 0, 0.98, 0), -- 大小
            UDim2.new(0.5, 0, 0.01, 0) -- 位置
        )
    elseif category == "音乐播放器" then
        CreateLabel("请输入rbxassetid", 18, UDim2.new(0.4, 0, 0.08, 0), UDim2.new(0.3, 0, 0.1, 0))
        local musicidtb = createDropdown(
            {
                "142376088", "1846368080", "5409360995", "1848354536", "1841647093", "1837879082", "1837768517", "9041745502", "9048375035", "1840684208", "118939739460633", "1846999567", "1840434670", "9046863253", "1848028342", "1843404009", "1845756489", "1846862303", "1841998846", "122600689240179", "1837101327", "125793633964645", "1846088038", "1845554017", "1838635121", "16190757458", "1846442964", "1839703786", "1839444520", "1838028467", "7028518546", "121336636707861", "87540733242308", "1838667168", "1838667680", "1845179120", "136598811626191", "79451196298919", "1837769001", "103086632976213", "120817494107898", "5410084188", "104483584177040", "7024220835", "1842976958", "7023635858", "1835782117", "7029024726", "7029017448", "5410085694", "1843471292", "7029005367", "131020134622685", "7024340270", "1836057733", "9047104336", "9047104411", "1843324336", "1845215540"
            }, -- 初始选项
            UDim2.new(0.4, 0, 0.08, 0), -- 大小
            UDim2.new(0.3, 0, 0.2, 0), -- 位置
            data.musicbox.id, -- 默认文本
            function(selectedOption) -- 回调函数
            end
        )
        musicidtb.TextBox.ClearTextOnFocus = false
        musicidtb.TextBox.ZIndex = 10
        CreateButton(data.musicbox.isPlay and "停止" or "播放", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.07, 0, 0.7, 0), function(button)
            musicbox.SoundId = "rbxassetid://" .. musicidtb.TextBox.Text
            data.musicbox.isPlay = not data.musicbox.isPlay
            button.Text = data.musicbox.isPlay and "停止" or "播放"
            if data.musicbox.isPlay then
                local success, productInfo = pcall(function()
                    return MarketplaceService:GetProductInfo(musicidtb.TextBox.Text)
                end)
                if success then
                    data.musicbox.id = musicidtb.TextBox.Text
                    CreateNotification("正在播放...", productInfo.Name .. "\n" .. productInfo.Description, 20, true)
                    wait(1)
                    musicbox:play()
                else
                    data.musicbox.isPlay = false
                    button.Text = "播放"
                    pausebutton.Text = "暂停"
                    CreateNotification("播放失败", musicidtb.TextBox.Text .. "\n不是一个有效的rbxassetid", 20, true)
                end
            else
                musicbox:Stop()
                data.musicbox.isPause = false
            end
        end)
        CreateButton(musicbox.Looped and "不循环播放" or "循环播放", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.67, 0, 0.7, 0), function(button)
            musicbox.Looped = not musicbox.Looped
            button.Text = musicbox.Looped and "不循环播放" or "循环播放"
        end)
        CreateLabel("音量", 18, UDim2.new(0.3, 0, 0.1, 0), UDim2.new(0.1, 0, 0.35, 0))
        local volumetb = CreateLabel(string.format("%.0f", musicbox.Volume*100) .. "%", 18, UDim2.new(0.15, 0, 0.1, 0), UDim2.new(0.28, 0, 0.355, 0))
        CreateButton("+", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.55, 0, 0.355, 0), function()
            musicbox.Volume = musicbox.Volume + 0.1
            volumetb.Text = string.format("%.0f", musicbox.Volume*100) .. "%"
        end)
        CreateButton("-", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.67, 0, 0.355, 0), function()
            if musicbox.Volume ~= 0 then musicbox.Volume = musicbox.Volume - 0.1 end
            volumetb.Text = string.format("%.0f", musicbox.Volume*100) .. "%"
        end)
        local pausebutton = CreateButton(data.musicbox.isPause and "继续" or "暂停", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.37, 0, 0.7, 0), function(button)
            if data.musicbox.isPlay then
                data.musicbox.isPause = not data.musicbox.isPause
                button.Text = data.musicbox.isPause and "继续" or "暂停"
                if data.musicbox.isPause == true then
                    data.musicbox.PlayLocation = musicbox.TimePosition
                    musicbox:Stop()
                elseif data.musicbox.isPause == false then
                    musicbox.TimePosition = data.musicbox.PlayLocation
                    musicbox:Play()
                end
            end
        end)
        CreateLabel("音高", 18, UDim2.new(0.3, 0, 0.1, 0), UDim2.new(0.1, 0, 0.45, 0))
        local pitchtb = CreateLabel(string.format("%.1f", musicbox.Pitch), 18, UDim2.new(0.15, 0, 0.1, 0), UDim2.new(0.28, 0, 0.455, 0))
        CreateButton("+", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.55, 0, 0.455, 0), function()
            musicbox.Pitch = musicbox.Pitch + 0.1
            pitchtb.Text = string.format("%.1f", musicbox.Pitch)
        end)
        CreateButton("-", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.67, 0, 0.455, 0), function()
            if musicbox.Pitch ~= 0 then musicbox.Pitch = musicbox.Pitch - 0.1 end
            pitchtb.Text = string.format("%.1f", musicbox.Pitch)
        end)
    elseif category == "执行器" then
        local executescripts = createCodeEditor(UDim2.new(0.98, 0, 0.9, 0), UDim2.new(0.01, 0, 0.01, 0))
        executescripts.set(data.executer.scripts)
        CreateButton("保存", UDim2.new(0.49, 0, 0.09, 0), UDim2.new(0.01, 0, 0.91, 0), function()
            data.executer.scripts = executescripts.get()
        end)
        CreateButton("执行", UDim2.new(0.48, 0, 0.09, 0), UDim2.new(0.51, 0, 0.91, 0), function()
            local script = executescripts.get()
            if script and script ~= "" then
                -- 尝试执行脚本
                local success, errorMessage = pcall(function()
                    loadstring(script)()
                end)
                if not success then
                    CreateNotification("错误", "脚本执行失败: " .. errorMessage, 5, true)
                else
                    CreateNotification("提示", "脚本执行成功!", 5, true)
                end
            else
                CreateNotification("错误", "请输入有效的脚本!", 5, true)
            end
        end)
    elseif category == "脚本中心" then
        local scriptList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        local function addscripts(name, link)
            scriptList.add(name, function(button)
                CreateNotification("提示", "正在启动 " .. button.Text .. " 脚本，请耐心等待.", 10, true)
                loadstring(game:HttpGet(link))()
                CreateNotification("提示", button.Text .. " 已经成功启动!", 10, true)
            end)
        end
        addscripts("高级聊天系统", "https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/customChatSystem.lua")
        addscripts("飞行V4", "https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/FlyV4.lua")
        addscripts("超高画质", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/Graphics.lua")
        addscripts("光影", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/Shader.lua")
        addscripts("通用自瞄", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/Zimiao.lua")
        addscripts("IY5.5.9(指令挂)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
        addscripts("Dex", "https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt")
        addscripts("DexDark", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DexDark.lua")
        addscripts("OldMSPaint", "https://raw.githubusercontent.com/notpoiu/mspaint/main/main.lua")
        addscripts("Doors变身脚本", "https://raw.githubusercontent.com/ChronoAccelerator/Public-Scripts/main/Morphing/MorphScript.lua")
        addscripts("Doors扫描器", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DoorsNVC3000.lua")
        addscripts("Doors剪刀", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/shears_done.lua")
        addscripts("Doors紫色手电筒", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/PurpleFlashlightScript.lua")
        addscripts("Doors巧克力罐", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/ChocolateBar.lua")
        addscripts("通用ESP", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/ESP.lua")
        addscripts("冬凌中心", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/DongLingLobby.lua")
        addscripts("玩家控制", "https://raw.atomgit.com/Furrycalin/ScriptStorage/raw/main/PlayerControl.lua")
        addscripts("吃掉世界", "https://raw.githubusercontent.com/AppleScript001/Eat_World_Simulator/main/README.md")
        addscripts("收养我吧", "https://raw.githubusercontent.com/lf4d7/daphie/main/ame.lua")
        addscripts("动画中心", "https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui")
        addscripts("阿尔宙斯", "https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3")
        addscripts("VChine V2", "https://pastebin.com/raw/SuDKzFKD")
        scriptList.add("情云中心", function(button)
            CreateNotification("提示", "正在启动 " .. button.Text .. " 脚本，请耐心等待.", 10, true)
            loadstring(utf8.char((function() return table.unpack({108,111,97,100,115,116,114,105,110,103,40,103,97,109,101,58,72,116,116,112,71,101,116,40,34,104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,67,104,105,110,97,81,89,47,45,47,109,97,105,110,47,37,69,54,37,56,51,37,56,53,37,69,52,37,66,65,37,57,49,34,41,41,40,41})end)()))()
            CreateNotification("提示", button.Text .. " 已经成功启动!", 10, true)
        end)
    elseif category == "工具" then
        local toolList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        toolList.add("回满血", function(button)
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
        end)
        toolList.add("自杀", function(button)
            LocalPlayer.Character.Humanoid.Health = 0
        end)
        toolList.add("获得点击传送工具", function(button)
            mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "手持点击传送" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
        end)
        toolList.addToogle("TPWalk", tpWalk:GetEnabled(), _, _, function(_, newState) tpWalk:Enabled(newState) end)
        toolList.addToogle("鼠标解锁", data.tools.mouseisunlock, function()
            MouseUnlockModule.Enable()
            CreateNotification("提示", "按下K+L组合键开关鼠标解锁", 5, true)
        end, function()
            MouseUnlockModule.Disable()
        end, function(_, newState)
            data.tools.mouseisunlock = newState
        end)
        toolList.addToogle("望远镜", data.tools.zoomenable, function() data.tools.zoom:Enable() end, function() data.tools.zoom:Disable() end, function(_, newState) data.tools.zoomenable = newState end)
        toolList.addToogle("隐身", data.tools.visible, function() PlayerVisibleModule.enable() end, function() PlayerVisibleModule.disable() end, function(_, newState) data.tools.visible = newState end)
        toolList.addToogle("落地特效", data.tools.landingeffect, function() LandingEffect.enable() end, function() LandingEffect.disable() end, function(_, newState) data.tools.landingeffect = newState end)
        toolList.addToogle("随身灯笼", data.nightmare_run.LanternOffin, _, _, function(_, newState)
            data.nightmare_run.Lantern.enable = newState
            data.nightmare_run.LanternOffin = newState
        end)
        toolList.addToogle("夜视", data.tools.nightvision, function() game.Lighting.Ambient = Color3.new(1, 1, 1) end, function() game.Lighting.Ambient = Color3.new(0, 0, 0) end, function(_, newState) data.tools.nightvision = newState end)
        toolList.addToogle("超级光明", data.nightmare_run.SuperLighterOffin, _, _, function(_, newState)
            data.nightmare_run.SuperLighter.enable = newState
            data.nightmare_run.SuperLighterOffin = newState
        end)
        toolList.addToogle("灵魂出窍", FreecamModule.freecamenable, _, _, function(_, newState)
            FreecamModule.freecamenable = newState
            FreecamModule.enable = newState and FreecamModule.enable or false
        end)
        toolList.addToogle("平移", data.tools.translation, function()
            movementModule.Enable()
            CreateNotification("提示", "按下↑↓←→键进行平移", 5, true)
        end, function()
            movementModule.Disable()
        end, function(_, newState)
            data.tools.translation = newState
        end)
        toolList.addToogle("穿墙", data.tools.noclip, function()
            Stepped = game:GetService("RunService").Stepped:Connect(function()
	            if not data.tools.noclip == false then
		            for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end end end end
	            else
                    for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = true
                                end end end end
		        Stepped:Disconnect()
	            end
            end)
        end, _, function(_, newState)
            data.tools.noclip = newState
        end)
        toolList.addToogle("连跳", data.tools.infjump, function()
            JR = game:GetService("UserInputService").JumpRequest:Connect(function()
                if not data.tools.infjump then
                    JR:Disconnect()
                end
                if data.tools.infjump then
                    local c = LocalPlayer.Character
                    if c and c.Parent then
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:ChangeState("Jumping")
                        end
                    end
                end
            end)
        end, _, function(_, newState)
            data.tools.infjump = newState
        end)
        toolList.addToogle("玩家透视", data.tools.playeresp, function()
            PlayerESP.enable()
        end, function()
            PlayerESP.disable()
        end, function(_, newState)
            data.tools.playeresp = newState
        end)
        toolList.addToogle("旁观模式", data.tools.Spectator, function() SpectatorModule.start() end, function() SpectatorModule.close() end, function(_, newState) data.tools.Spectator = newState end)
        toolList.addToogle("空中移动", data.tools.airwalk, _, _, function(_, newState)
            toggleAirWalk()
            data.tools.airwalk = newState
        end)
        toolList.addToogle("防击倒", data.tools.antifall, _, _, function(_, newState) data.tools.antifall = newState end)
        toolList.addToogle("晕厥康复", data.tools.antifallplus, function() StandRecovery:enableDetection() end, function() StandRecovery:disableDetection() end, function(_, newState) data.tools.antifallplus = newState end)
        toolList.addToogle("防甩飞", data.tools.antifling, function() FlingDetector.enable() end, function() FlingDetector.disable() end, function(_, newState) data.tools.antifling = newState end)
        toolList.addToogle("防死亡", data.tools.antidead, _, _, function(_, newState) data.tools.antidead = newState end)
        toolList.add("重新加入当前房间(服务器)", function(button)
            rejoinCurrentGame()
        end)
        toolList.add("切换时间为白天", function(button)
            setDay()
        end)
        toolList.add("切换时间为黑夜", function(button)
            setNight()
        end)
        toolList.add("优化世界光效", function(button)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ChronixHub/raw/main/modules/WorldShader.lua"))()
        end)
        toolList.add("打印眼前实例名到控制台", function(button)
            -- 使用已有的 player 和 character，从 character 获取 head
            local head = character:WaitForChild("Head")

            -- 混淆变量名
            local _p = RaycastParams.new()
            _p.FilterDescendantsInstances = {character}
            _p.FilterType = Enum.RaycastFilterType.Blacklist

            local _o = head.Position
            local _d = head.CFrame.LookVector * 100

            local _r = workspace:Raycast(_o, _d, _p)

            if _r then
                local _h = _r.Instance
                print("面前实例名称：", _h.Name)
                print("完整路径：", _h:GetFullName())
            else
                print("面前没有检测到实例")
            end     
        end)
        toolList.add("打印当前玩家坐标到控制台", function(button)
            -- 防止跟现有的重复导致冲突
            local rootPart1 = character:WaitForChild("HumanoidRootPart")
            local position1 = rootPart1.Position
            print(string.format("玩家坐标: (%.2f, %.2f, %.2f)", position1.X, position1.Y, position1.Z))
        end)
    elseif category == "基础" then
        CreateLabel("移速", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.05, 0))
        local speedtb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.WalkSpeed), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.04, 0))
        local slider1 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.04, 0),
            0, -- minValue
            1000, -- maxValue
            LocalPlayer.Character.Humanoid.WalkSpeed, -- defaultValue
            function(value) -- callback
                speedtb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.WalkSpeed = value
                data.playerattr.speed = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.04, 0), function()
            s = tonumber(speedtb.Text)
            LocalPlayer.Character.Humanoid.WalkSpeed = s and speedtb.Text or "18"
            slider1.setValue(s and speedtb.Text or 18)
            data.playerattr.speed = s and speedtb.Text or 18
        end)
        
        createCheckbox(UDim2.new(0, 20, 0, 20), UDim2.new(0.93, 0, 0.031, 0), data.playercontrol.lockspeed, function(isChecked)
            data.playercontrol.lockspeed = isChecked
        end)

        CreateLabel("跳跃", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.15, 0))
        local jumptb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.JumpPower), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.14, 0))
        local slider2 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.14, 0),
            0, -- minValue
            100, -- maxValue
            LocalPlayer.Character.Humanoid.JumpPower, -- defaultValue
            function(value) -- callback
                jumptb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.JumpPower = value
                data.playerattr.jump = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.14, 0), function()
            m = tonumber(jumptb.Text)
            LocalPlayer.Character.Humanoid.JumpPower = m and jumptb.Text or 50
            slider2.setValue(m and jumptb.Text or 50)
            data.playerattr.jump = m and jumptb.Text or 50
        end)
        
        createCheckbox(UDim2.new(0, 20, 0, 20), UDim2.new(0.93, 0, 0.131, 0), data.playercontrol.lockjump, function(isChecked)
            data.playercontrol.lockjump = isChecked
        end)

        CreateLabel("最大血量", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.25, 0))
        local mhtb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.MaxHealth), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.24, 0))
        local slider3 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.24, 0),
            1, -- minValue
            1000, -- maxValue
            LocalPlayer.Character.Humanoid.MaxHealth, -- defaultValue
            function(value) -- callback
                mhtb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.MaxHealth = value
                data.playerattr.maxhealth = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.24, 0), function()
            k = tonumber(mhtb.Text)
            LocalPlayer.Character.Humanoid.MaxHealth = k and mhtb.Text or 100
            slider3.setValue(k and mhtb.Text or 100)
            data.playerattr.maxhealth = k and mhtb.Text or 100
        end)
        
        createCheckbox(UDim2.new(0, 20, 0, 20), UDim2.new(0.93, 0, 0.231, 0), data.playercontrol.lockmaxhealth, function(isChecked)
            data.playercontrol.lockmaxhealth = isChecked
        end)

        CreateLabel("血量", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.35, 0))
        local htb = CreateTextBox(string.format("%.2f", LocalPlayer.Character.Humanoid.Health), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.34, 0))
        local slider4 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.34, 0),
            0, -- minValue
            tonumber(mhtb.Text), -- maxValue
            LocalPlayer.Character.Humanoid.Health, -- defaultValue
            function(value) -- callback
                htb.Text = string.format("%.2f", value)
                LocalPlayer.Character.Humanoid.Health = value
                data.playerattr.health = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.34, 0), function()
            p = tonumber(htb.Text)
            LocalPlayer.Character.Humanoid.Health = p and htb.Text or 100
            slider4.setValue(p and htb.Text or 100)
            data.playerattr.health = p and htb.Text or 100
        end)
        
        createCheckbox(UDim2.new(0, 20, 0, 20), UDim2.new(0.93, 0, 0.331, 0), data.playercontrol.lockhealth, function(isChecked)
            data.playercontrol.lockhealth = isChecked
        end)

        CreateLabel("重力", 18, UDim2.new(0.10, 0, 0.05, 0), UDim2.new(0.01, 0, 0.45, 0))
        local gtb = CreateTextBox(string.format("%.2f", game.Workspace.Gravity), 18, UDim2.new(0.15, 0, 0.08, 0), UDim2.new(0.11, 0, 0.44, 0))
        local slider5 = createSlider(
            UDim2.new(0.43, 0, 0.08, 0),
            UDim2.new(0.29, 0, 0.44, 0),
            0, -- minValue
            500, -- maxValue
            game.Workspace.Gravity, -- defaultValue
            function(value) -- callback
                gtb.Text = string.format("%.2f", value)
                game.Workspace.Gravity = value
                data.playerattr.gravity = value
            end
        )
        CreateButton("设置", UDim2.new(0.13, 0, 0.08, 0), UDim2.new(0.78, 0, 0.44, 0), function()
            z = tonumber(gtb.Text)
            game.Workspace.Gravity = z and gtb.Text or 196.2
            slider5.setValue(z and gtb.Text or 196.2)
            data.playerattr.gravity = z and gtb.Text or 196.2
        end)
        
        createCheckbox(UDim2.new(0, 20, 0, 20), UDim2.new(0.93, 0, 0.431, 0), data.playercontrol.lockgravity, function(isChecked)
            data.playercontrol.lockgravity = isChecked
        end)
    elseif category == "兽化项目" then
        CreateLabel("基础操作", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.01, 0, 0.03, 0))
        CreateButton("删除捕兽夹", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.1, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "__SnarePhysical" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个捕兽夹", 10, true)
        end)
        CreateButton("删除地雷", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.2, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "Landmine" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个地雷", 10, true)
        end)
        CreateButton("删除阔剑地雷", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.01, 0, 0.3, 0), function()
            local deletedCount = 0
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model.Name == "__ClaymorePhysical" then
                    model:Destroy()
                    deletedCount = deletedCount + 1
                end
            end
            CreateNotification("Project Transfur", "已删除" .. deletedCount .. "个阔剑地雷", 10, true)
        end)
        CreateLabel("透视功能", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.03, 0))
        CreateButton(data.pt.esp and "透视(开)" or "透视(关)", UDim2.new(0.23, 0, 0.09, 0), UDim2.new(0.31, 0, 0.1, 0), function(button)
            toggleFeature(not data.pt.esp)
            button.Text = data.pt.esp and "透视(开)" or "透视(关)"
        end)
        CreateLabel("透视列表", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.31, 0, 0.23, 0))
        local espList = CreateList(UDim2.new(0, 100, 0.645, 0), UDim2.new(0.30, 0, 0.3, 0))
        espList.add(getModelHighlight("Bot") and "Bot兽(开)" or "Bot兽(关)", function(button)
            toggleModelHighlight("Bot")
            button.Text = getModelHighlight("Bot") and "Bot兽(开)" or "Bot兽(关)"
        end)
        espList.add(getModelHighlight("__BasicSmallSafe") and "小保险箱(开)" or "小保险箱(关)", function(button)
            toggleModelHighlight("__BasicSmallSafe")
            button.Text = getModelHighlight("__BasicSmallSafe") and "小保险箱(开)" or "小保险箱(关)"
        end)
        espList.add(getModelHighlight("__BasicLargeSafe") and "大保险箱(开)" or "大保险箱(关)", function(button)
            toggleModelHighlight("__BasicLargeSafe")
            button.Text = getModelHighlight("__BasicLargeSafe") and "大保险箱(开)" or "大保险箱(关)"
        end)
        espList.add(getModelHighlight("__LargeGoldenSafe") and "金保险箱(开)" or "金保险箱(关)", function(button)
            toggleModelHighlight("__LargeGoldenSafe")
            button.Text = getModelHighlight("__LargeGoldenSafe") and "金保险箱(开)" or "金保险箱(关)"
        end)
        espList.add(getModelHighlight("Surplus Crate") and "武器盒(开)" or "武器盒(关)", function(button)
            toggleModelHighlight("Surplus Crate")
            toggleModelHighlight("Military Crate")
            button.Text = getModelHighlight("Military Crate") and "武器盒(开)" or "武器盒(关)"
        end)
        espList.add(getModelHighlight("SupplyDrop") and "空投(开)" or "空投(关)", function(button)
            toggleModelHighlight("SupplyDrop")
            button.Text = getModelHighlight("SupplyDrop") and "空投(开)" or "空投(关)"
        end)
    elseif category == "格蕾丝" then
        local graceList = CreateList(UDim2.new(1, 0, 1, 0), UDim2.new(0.01, 0, 0.01, 0))
        graceList.addToogle("自动拉杆", data.grace.autolever, _, _, function(_, newState) data.grace.autolever = newState end)
        graceList.add("删除全部实体(无法关闭)", function(button)
            data.grace.deleteentite = true
        end)
    elseif category == "死亡球" then
        local DBList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        DBList.addToogle("主功能和界面", data.deathball.enable, function() _G.DeathBallScript:Enable() end, function() _G.DeathBallScript:Disable() end, function(_, newState) data.deathball.enable = newState end)
    elseif category == "小屋角色扮演" then
        local CRPList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        CRPList.add("变正常", function(button)
            chatMessage("/re")
        end)
        CRPList.add("变小孩", function(button)
            chatMessage("/kid")
        end)
        CRPList.add("鲨鱼服装", function(button)
            chatMessage("/shark")
        end)
        CRPList.add("修狗服装", function(button)
            chatMessage("/dog")
        end)
        CRPList.add("修猫服装", function(button)
            chatMessage("/cat")
        end)
    elseif category == "南极探险队" then
        CreateLabel("基础操作", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.01, 0, 0.03, 0))
        local SEList = CreateList(UDim2.new(0.23, 0, 0.8, 0), UDim2.new(0.01, 0, 0.1, 0))
        SEList.add("大本营", function(button)
            TeleportTo(-6015, -158, -35)
        end)
        SEList.add("营地1", function(button)
            TeleportTo(-3719, 226, 235)
        end)
        SEList.add("营地2", function(button)
            TeleportTo(1790, 106, -138)
        end)
        SEList.add("营地3", function(button)
            TeleportTo(5892, 321, -18)
        end)
        SEList.add("营地4", function(button)
            TeleportTo(8992, 596, 102)
        end)
        SEList.add("终点", function(button)
            TeleportTo(10990, 550, 104)
        end)
        CreateLabel("圣诞活动", 18, UDim2.new(0.23, 0, 0.05, 0), UDim2.new(0.27, 0, 0.03, 0))
        CreateButton("获取所有礼物", UDim2.new(0.26, 0, 0.09, 0), UDim2.new(0.25, 0, 0.1, 0), function(button)
            loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/modules/SouthExpedition_Christmas_getallgifts.lua"))()
        end)
        local giftnumber = CreateTextBox(1, 18, UDim2.new(0.10, 0, 0.08, 0), UDim2.new(0.33, 0, 0.33, 0))
        CreateButton("传送到礼物", UDim2.new(0.26, 0, 0.09, 0), UDim2.new(0.25, 0, 0.21, 0), function(button)
            TeleportToPresent(tonumber(giftnumber.Text))
        end)
    elseif category == "噩梦之行" then
        local NRList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        NRList.addToogle("高亮所有怪物", data.nightmare_run.highlightmonster, function() data.nightmare_run.monster:enable() end, function() data.nightmare_run.monster:disable() end, function(_, newState) data.nightmare_run.highlightmonster = newState end)
        NRList.add("高亮芝士", function(button)
            data.nightmare_run.HLCheese.apply()
            CreateNotification("Nightmare Run", "已高亮芝士\n仅高亮一次", 10, true)
        end)
        NRList.add("无敌(怪物不追不杀)", function(button)
            -- 无敌实现
            local ClientScripts = game.Players.LocalPlayer.PlayerGui.ClientScripts
            if ClientScripts:FindFirstChild("SafeSpaceHandler") then
                ClientScripts.SafeSpaceHandler:Destroy() -- 删除安全区处理脚本、防止被持续监测到（注意：死亡后会重新生成）
            end
            local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
            local LocalPlayer_upvr = game.Players.LocalPlayer
            local Events_upvr = ReplicatedStorage_upvr.Events
            LocalPlayer_upvr:SetAttribute("Safe", true) -- 设置安全状态
            Events_upvr.SetAttributeEvent:FireServer("Safe", true) -- 向服务端发送安全状态
            CreateNotification("Nightmare Run", "已设置玩家安全状态\n死亡前生效", 10, true)
        end)
    elseif category == "西部森林" then
        local WWList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        WWList.addToogle("怪物标签", data.west_wood.monster_xray, function() data.west_wood.monster:enable() end, function() data.west_wood.monster:disable() end, function(_, newState) data.west_wood.monster_xray = newState end)
    elseif category == "警笛头:遗产" then
        local SHLList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        SHLList.addToogle("透视盒子", data.sirenhead_legacy.cratexray, function()
            data.sirenhead_legacy.cratemodule.apply()
            data.sirenhead_legacy.cratenametagmodule:enable()
        end, function()
            data.sirenhead_legacy.cratemodule.destroy()
            data.sirenhead_legacy.cratenametagmodule:disable()
        end, function(_, newState) data.sirenhead_legacy.cratexray = newState end)
        SHLList.addToogle("透视浆果", data.sirenhead_legacy.berryxray, function()
            data.sirenhead_legacy.berrymodule.apply()
            data.sirenhead_legacy.berrynametagmodule:enable()
        end, function()
            data.sirenhead_legacy.berrymodule.destroy()
            data.sirenhead_legacy.berrynametagmodule:disable()
        end, function(_, newState) data.sirenhead_legacy.berryxray = newState end)
        SHLList.add("传送到树顶", function(button)
            TeleportTo(69, 206, -72)
        end)
    elseif category == "支持的游戏" then
        local ACGList = CreateList(UDim2.new(0.98, 0, 0.98, 0), UDim2.new(0.01, 0, 0.01, 0))
        for _, GetgameInfo in ipairs(Supported_Games) do
            if GetgameInfo.gameid then
                ACGList.add(GetgameInfo.name .. "(点击进入)", function(button)
                    if game.GameId == GetgameInfo.gameid then CreateNotification("提示", "你已经在这个游戏里了。", 5, true) else GameTeleport.teleportByGameId(GetgameInfo.gameid) end
                end)
            end
        end
    end
end

local function addMenu(menutext)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, #functionList:GetChildren() * 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 56) -- 中墨蓝色
    button.BorderSizePixel = 0
    button.Text = menutext
    button.TextColor3 = Color3.new(1, 1, 1) -- 白色
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = functionList
    local uiCorner = Instance.new("UICorner", button)
    uiCorner.CornerRadius = UDim.new(0, 5)
    applyParticleEffect(button)

    button.MouseButton1Click:Connect(function()
        uiclicker:Play()
        AddMenuContent(menutext) -- 切换菜单内容
    end)
end

-- 添加功能列表
addMenu("基础")
addMenu("工具")
addMenu("脚本中心")
addMenu("传送器")
addMenu("执行器")
addMenu("音乐播放器")
addMenu("音频检查器")
addMenu("聊天接收器")
addMenu("支持的游戏")
for _, GetgameInfo in ipairs(Supported_Games) do
    if GetgameInfo.gameid then
        if game.GameId == GetgameInfo.gameid then addMenu(GetgameInfo.name) end
    end
end

-- 更新功能栏的滚动区域
functionList.CanvasSize = UDim2.new(0, 0, 0, #functionList:GetChildren() * 30)

-- 设置按钮
local settingButton = Instance.new("TextButton")
settingButton.Size = UDim2.new(0, 30, 0, 30)
settingButton.Position = UDim2.new(1, -35, 0.125, 0)
settingButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
settingButton.BorderSizePixel = 0
settingButton.Text = "⚙️"
settingButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
settingButton.Font = Enum.Font.SourceSansBold
settingButton.TextSize = 18
settingButton.Parent = infoBar
applyParticleEffect(settingButton)

local uiCorner40 = Instance.new("UICorner", settingButton)
uiCorner40.CornerRadius = UDim.new(0, 5)

settingButton.MouseButton1Click:Connect(function()
    uiclicker:Play()
    AddMenuContent("设置")
end)

-- 关闭按钮
local infoButton = Instance.new("TextButton")
infoButton.Size = UDim2.new(0, 30, 0, 30)
infoButton.Position = UDim2.new(1, -70, 0.125, 0)
infoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70) -- 浅墨蓝色
infoButton.BorderSizePixel = 0
infoButton.Text = "ℹ️"
infoButton.TextColor3 = Color3.new(1, 1, 1) -- 白色
infoButton.Font = Enum.Font.SourceSansBold
infoButton.TextSize = 18
infoButton.Parent = infoBar
applyParticleEffect(infoButton)

local uiCorner50 = Instance.new("UICorner", infoButton)
uiCorner50.CornerRadius = UDim.new(0, 5)

infoButton.MouseButton1Click:Connect(function()
    uiclicker:Play()
    AddMenuContent("关于")
end)

local floatingWindow = loadstring(game:HttpGet("https://raw.atomgit.com/Furrycalin/RobloxScripts/raw/main/floatingWindow.lua"))()
local fw = floatingWindow:createWindow("📕", function(label)
    if mainFrame.Visible then
        mainFrame.Visible = false
        CreateNotification("ChronixHub已隐藏", "点击悬浮窗重新打开界面", 10, false)
        achievementSound:Stop()
        label.Text = "📖"
    else
        mainFrame.Visible = true
        label.Text = "📕"
    end
end)

fw.Position = UDim2.new(2, 0, 2, 0)

if GetDeviceType() == "Desktop" then
    CreateNotification("欢迎使用，电脑用户" .. displayName, "ChronixHub v2已启动!\n反挂机系统已自动开启", 10, true)
elseif GetDeviceType() == "Mobile" then
    CreateNotification("欢迎使用，手机用户" .. displayName, "ChronixHub v2已启动!\n反挂机系统已自动开启", 10, true)
    fw.Position = UDim2.new(0.5, -40, 0.5, -40)
end

SystemNotification.Rainbow("ChronixHubV2 Already Success Loaded!\nWelcome " .. displayName)

local function unloadchronixhub()
    SystemNotification.UnloadedGradient("ChronixHubv2 Already Unload!")
    print("ChronixHubv2 已卸载。")
    _G.ChronixHubisLoaded = false
    data.musictest.enable = false
    data.tools.noclip = false
    data.tools.infjump = false
    PlayerVisibleModule.unload()
    NameTagModule.unload()
    LandingEffect.unload()
    FreecamModule.unload()
    SpectatorModule.unload()
    PlayerLightModule:unload()
    HighlightModule.unload()
    StandRecovery:unload()
    _G.DeathBallScript:Unload()
    data.tools.zoom:Unload()
    FlingDetector.unload()
    PlayerESP.unload()
    MovableHighlighter_NM.unloadAll()
    musicbox:Stop()
    musicbox:Destroy()
    chatcheck:Disconnect()
    offce:Disconnect()
    al:Disconnect()
    ds:Disconnect()
    Stepped6:Disconnect()
    cc:Disconnect()
    gsr:Disconnect()
    toggleFeature(false)
    mainFrame:Destroy()
    fw:Destroy()
    Gui:Destroy()
    script:Destroy()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode[data.setting.BindKey] then
        if mainFrame.Visible then
            if not isProcessing then
                mainFrame.Visible = false
                CreateNotification("ChronixHub已隐藏", "按下" .. data.setting.BindKey .. "重新打开界面", 10, false)
                achievementSound:Stop()
            else
                isProcessing = false
            end
        else
            mainFrame.Visible = true
        end
    end
end)

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    unloadchronixhub()
end)

-- 设置默认显示内容
AddMenuContent("基础")
AddMenuContent("关于")