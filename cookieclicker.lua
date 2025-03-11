-- 服务
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- 本地玩家
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 创建 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- 游戏数据
local cookies = 0
local clickMultiplier = 1  -- 初始点击倍数
local currentLanguage = "zh"  -- 默认语言

-- 多语言支持
local language = {
    ["zh"] = {
        ["Cursor"] = "鼠标指针",
        ["Grandma"] = "老奶奶",
        ["Mine"] = "矿场",
        ["Factory"] = "工厂",
        ["Alchemy Lab"] = "炼金术实验室",
        ["Shipment"] = "运输船",
        ["Time Machine"] = "时间机器",
        ["Click x2"] = "点击 x2",
        ["Click x5"] = "点击 x5",
        ["Click x10"] = "点击 x10",
        ["Click x20"] = "点击 x20",
        ["Golden Cookie"] = "黄金饼干",
        ["Cookies"] = "饼干",
        ["Not enough cookies!"] = "饼干不足！",
        ["Already purchased!"] = "已购买！",
        ["Requires previous facility!"] = "需要先购买前一个设施！"
    },
    ["en"] = {
        ["Cursor"] = "Cursor",
        ["Grandma"] = "Grandma",
        ["Mine"] = "Mine",
        ["Factory"] = "Factory",
        ["Alchemy Lab"] = "Alchemy Lab",
        ["Shipment"] = "Shipment",
        ["Time Machine"] = "Time Machine",
        ["Click x2"] = "Click x2",
        ["Click x5"] = "Click x5",
        ["Click x10"] = "Click x10",
        ["Click x20"] = "Click x20",
        ["Golden Cookie"] = "Golden Cookie",
        ["Cookies"] = "Cookies",
        ["Not enough cookies!"] = "Not enough cookies!",
        ["Already purchased!"] = "Already purchased!",
        ["Requires previous facility!"] = "Requires previous facility!"
    }
}

-- 设置语言
local function setLanguage(lang)
    currentLanguage = lang
    updateUI()  -- 更新界面文本
end

-- 获取当前语言的文本
local function getText(key)
    return language[currentLanguage][key] or key
end

-- 音效
local sounds = {
    clickSound = "rbxassetid://你的点击音效ID",  -- 替换为你的点击音效 ID
    upgradeSound = "rbxassetid://你的升级音效ID",  -- 替换为你的升级音效 ID
    eventSound = "rbxassetid://你的事件音效ID"  -- 替换为你的事件音效 ID
}

-- 播放音效
local function playSound(soundName)
    local sound = Instance.new("Sound")
    sound.SoundId = sounds[soundName]
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- 设施数据
local facilities = {
    ["Cursor"] = {
        index = 0,
        basePrice = 10,
        priceGrowth = 1.15,  -- 价格增长倍数
        cookiesPerSecond = 0.1,
        requiresUnlock = false
    },
    ["Grandma"] = {
        index = 1,
        basePrice = 100,
        priceGrowth = 1.15,
        cookiesPerSecond = 1,
        requiresUnlock = true
    },
    ["Mine"] = {
        index = 2,
        basePrice = 500,
        priceGrowth = 1.15,
        cookiesPerSecond = 5,
        requiresUnlock = true
    },
    ["Factory"] = {
        index = 3,
        basePrice = 1000,
        priceGrowth = 1.15,
        cookiesPerSecond = 10,
        requiresUnlock = true
    },
    ["Alchemy Lab"] = {
        index = 4,
        basePrice = 5000,
        priceGrowth = 1.15,
        cookiesPerSecond = 20,
        requiresUnlock = true
    },
    ["Shipment"] = {
        index = 5,
        basePrice = 10000,
        priceGrowth = 1.15,
        cookiesPerSecond = 50,
        requiresUnlock = true
    },
    ["Time Machine"] = {
        index = 6,
        basePrice = 50000,
        priceGrowth = 1.15,
        cookiesPerSecond = 100,
        requiresUnlock = true
    }
}

-- 升级数据
local upgrades = {
    ["Click x2"] = {
        price = 50,
        multiplier = 2,
        purchased = false
    },
    ["Click x5"] = {
        price = 200,
        multiplier = 5,
        purchased = false
    },
    ["Click x10"] = {
        price = 1000,
        multiplier = 10,
        purchased = false
    },
    ["Click x20"] = {
        price = 5000,
        multiplier = 20,
        purchased = false
    }
}

-- 事件系统
local events = {
    ["Golden Cookie"] = {
        chance = 0.01,  -- 触发概率 1%
        callback = function()
            cookies = cookies + 1000
            updateCookieDisplay()
            showEventPopup(getText("Golden Cookie") .. "! +1000 " .. getText("Cookies") .. "!")
            playSound("eventSound")
        end
    }
}

-- 创建游戏界面
local function createGameUI()
    -- 游戏标题
    local title = Instance.new("TextLabel")
    title.Text = "Cookie Clicker"
    title.Size = UDim2.new(0, 200, 0, 50)
    title.Position = UDim2.new(0.5, -100, 0.1, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = screenGui

    -- 饼干数量显示
    local cookieCount = Instance.new("TextLabel")
    cookieCount.Text = getText("Cookies") .. ": 0"
    cookieCount.Size = UDim2.new(0, 200, 0, 50)
    cookieCount.Position = UDim2.new(0.5, -100, 0.2, 0)
    cookieCount.TextColor3 = Color3.new(1, 1, 1)
    cookieCount.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    cookieCount.Font = Enum.Font.SourceSansBold
    cookieCount.TextSize = 20
    cookieCount.Parent = screenGui

    -- 饼干按钮
    local cookieButton = Instance.new("ImageButton")
    cookieButton.Image = "rbxassetid://你的饼干图片ID"  -- 替换为你的饼干图片 ID
    cookieButton.Size = UDim2.new(0, 100, 0, 100)
    cookieButton.Position = UDim2.new(0.5, -50, 0.5, -50)
    cookieButton.Parent = screenGui

    -- 点击反馈文字
    local clickText = Instance.new("TextLabel")
    clickText.Text = "+1"
    clickText.Size = UDim2.new(0, 50, 0, 20)
    clickText.Position = UDim2.new(0.5, -25, 0.5, -60)
    clickText.TextColor3 = Color3.new(1, 1, 1)
    clickText.BackgroundTransparency = 1
    clickText.Font = Enum.Font.SourceSansBold
    clickText.TextSize = 16
    clickText.Visible = false
    clickText.Parent = screenGui

    -- 升级栏（横向滚动）
    local upgradeFrame = Instance.new("Frame")
    upgradeFrame.Size = UDim2.new(0, 300, 0, 80)
    upgradeFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
    upgradeFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    upgradeFrame.Parent = screenGui

    local upgradeList = Instance.new("ScrollingFrame")
    upgradeList.Size = UDim2.new(1, 0, 1, 0)
    upgradeList.CanvasSize = UDim2.new(0, 0, 0, 0)
    upgradeList.ScrollBarThickness = 5
    upgradeList.BackgroundTransparency = 1
    upgradeList.Parent = upgradeFrame

    -- 设施购买列表
    local facilityFrame = Instance.new("Frame")
    facilityFrame.Size = UDim2.new(0, 300, 0, 300)
    facilityFrame.Position = UDim2.new(0.1, 0, 0.25, 0)
    facilityFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    facilityFrame.Parent = screenGui

    local facilityList = Instance.new("ScrollingFrame")
    facilityList.Size = UDim2.new(1, 0, 1, 0)
    facilityList.CanvasSize = UDim2.new(0, 0, 0, 0)
    facilityList.ScrollBarThickness = 5
    facilityList.BackgroundTransparency = 1
    facilityList.Parent = facilityFrame

    -- 返回 UI 元素
    return {
        title = title,
        cookieCount = cookieCount,
        cookieButton = cookieButton,
        clickText = clickText,
        upgradeList = upgradeList,
        facilityList = facilityList
    }
end

-- 创建 UI
local ui = createGameUI()

-- 更新饼干数量显示
local function updateCookieDisplay()
    ui.cookieCount.Text = getText("Cookies") .. ": " .. cookies
end

-- 显示事件弹窗
local function showEventPopup(message)
    local popup = Instance.new("TextLabel")
    popup.Text = message
    popup.Size = UDim2.new(0, 200, 0, 50)
    popup.Position = UDim2.new(0.5, -100, 0.5, -25)
    popup.TextColor3 = Color3.new(1, 1, 0)
    popup.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    popup.Font = Enum.Font.SourceSansBold
    popup.TextSize = 20
    popup.Parent = screenGui

    -- 弹窗动画
    local tween = TweenService:Create(popup, TweenInfo.new(1), {Position = UDim2.new(0.5, -100, 0.4, -25)})
    tween:Play()
    tween.Completed:Wait()
    wait(1)
    popup:Destroy()
end

-- 点击饼干按钮
ui.cookieButton.MouseButton1Click:Connect(function()
    cookies = cookies + clickMultiplier
    updateCookieDisplay()

    -- 显示点击反馈文字
    ui.clickText.Text = "+" .. clickMultiplier
    ui.clickText.Visible = true
    ui.clickText.Position = UDim2.new(0.5, -25, 0.5, -60)
    wait(0.2)
    ui.clickText.Visible = false

    -- 播放点击音效
    playSound("clickSound")

    -- 触发随机事件
    for eventName, eventData in pairs(events) do
        if math.random() < eventData.chance then
            eventData.callback()
        end
    end
end)

-- 创建升级按钮
local function createUpgradeButton(upgradeName, upgradeData)
    local button = Instance.new("TextButton")
    button.Text = getText(upgradeName) .. "\n(" .. upgradeData.price .. " " .. getText("Cookies") .. ")"
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = UDim2.new(0, (#ui.upgradeList:GetChildren() - 1) * 90, 0, 0)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.Parent = ui.upgradeList

    button.MouseButton1Click:Connect(function()
        if cookies >= upgradeData.price and not upgradeData.purchased then
            cookies = cookies - upgradeData.price
            clickMultiplier = clickMultiplier * upgradeData.multiplier
            upgradeData.purchased = true
            button:Destroy()  -- 从列表中移除升级
            updateCookieDisplay()
            playSound("upgradeSound")
        else
            warn(getText("Not enough cookies!") or getText("Already purchased!"))
        end
    end)
end

-- 初始化升级按钮
for upgradeName, upgradeData in pairs(upgrades) do
    createUpgradeButton(upgradeName, upgradeData)
end

-- 创建设施按钮
local function createFacilityButton(facilityName, facilityData)
    local button = Instance.new("TextButton")
    button.Text = getText(facilityName) .. " (" .. math.floor(facilityData.basePrice) .. " " .. getText("Cookies") .. ")"
    button.Size = UDim2.new(1, -10, 0, 50)
    button.Position = UDim2.new(0, 5, 0, facilityData.index * 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = ui.facilityList

    button.MouseButton1Click:Connect(function()
        if cookies >= facilityData.basePrice then
            -- 检查是否需要解锁前一个设施
            if facilityData.requiresUnlock and (not facilities[facilityName - 1] or facilities[facilityName - 1].basePrice == 0) then
                warn(getText("Requires previous facility!"))
                return
            end

            cookies = cookies - facilityData.basePrice
            facilityData.basePrice = facilityData.basePrice * facilityData.priceGrowth
            button.Text = getText(facilityName) .. " (" .. math.floor(facilityData.basePrice) .. " " .. getText("Cookies") .. ")"
            updateCookieDisplay()
            playSound("upgradeSound")
        else
            warn(getText("Not enough cookies!"))
        end
    end)
end

-- 初始化设施按钮
for facilityName, facilityData in pairs(facilities) do
    createFacilityButton(facilityName, facilityData)
end

-- 自动化生产饼干
local function autoClickerLoop()
    while true do
        for facilityName, facilityData in pairs(facilities) do
            if facilityData.index > 0 then
                cookies = cookies + facilityData.cookiesPerSecond
            end
        end
        updateCookieDisplay()
        wait(1)
    end
end

-- 启动自动化生产
spawn(autoClickerLoop)

-- 设置语言为中文
setLanguage("zh")