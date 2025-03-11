-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Local Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Game Data
local cookies = 0
local clickMultiplier = 1  -- Initial click multiplier
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

local facilities = {
    ["Cursor"] = {
        index = 0,
        basePrice = 10,
        priceGrowth = 1.15,  -- Exponential growth factor
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

-- Event System
local events = {
    ["Golden Cookie"] = {
        chance = 0.01,  -- 1% chance to trigger
        callback = function()
            cookies = cookies + 1000
            updateCookieDisplay()
            showEventPopup("Golden Cookie! +1000 cookies!")
        end
    }
}

-- Create Game UI
local function createGameUI()
    -- Game Title
    local title = Instance.new("TextLabel")
    title.Text = "Cookie Clicker"
    title.Size = UDim2.new(0, 200, 0, 50)
    title.Position = UDim2.new(0.5, -100, 0.1, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = screenGui

    -- Cookie Count Display
    local cookieCount = Instance.new("TextLabel")
    cookieCount.Text = "Cookies: 0"
    cookieCount.Size = UDim2.new(0, 200, 0, 50)
    cookieCount.Position = UDim2.new(0.5, -100, 0.2, 0)
    cookieCount.TextColor3 = Color3.new(1, 1, 1)
    cookieCount.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    cookieCount.Font = Enum.Font.SourceSansBold
    cookieCount.TextSize = 20
    cookieCount.Parent = screenGui

    -- Cookie Button
    local cookieButton = Instance.new("ImageButton")
    cookieButton.Image = "rbxassetid://你的饼干图片ID"  -- Replace with your cookie image ID
    cookieButton.Size = UDim2.new(0, 100, 0, 100)
    cookieButton.Position = UDim2.new(0.5, -50, 0.5, -50)
    cookieButton.Parent = screenGui

    -- Click Feedback Text
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

    -- Upgrade Frame (Horizontal Scroll)
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

    -- Facility Purchase List
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

    -- Return UI Elements
    return {
        title = title,
        cookieCount = cookieCount,
        cookieButton = cookieButton,
        clickText = clickText,
        upgradeList = upgradeList,
        facilityList = facilityList
    }
end

-- Create UI
local ui = createGameUI()

-- Update Cookie Display
local function updateCookieDisplay()
    ui.cookieCount.Text = "Cookies: " .. cookies
end

-- Show Event Popup
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

    -- Popup Animation
    local tween = TweenService:Create(popup, TweenInfo.new(1), {Position = UDim2.new(0.5, -100, 0.4, -25)})
    tween:Play()
    tween.Completed:Wait()
    wait(1)
    popup:Destroy()
end

-- Click Cookie Button
ui.cookieButton.MouseButton1Click:Connect(function()
    cookies = cookies + clickMultiplier
    updateCookieDisplay()

    -- Show Click Feedback Text
    ui.clickText.Text = "+" .. clickMultiplier
    ui.clickText.Visible = true
    ui.clickText.Position = UDim2.new(0.5, -25, 0.5, -60)
    wait(0.2)
    ui.clickText.Visible = false

    -- Trigger Random Event
    for eventName, eventData in pairs(events) do
        if math.random() < eventData.chance then
            eventData.callback()
        end
    end
end)

-- Create Upgrade Buttons
local function createUpgradeButton(upgradeName, upgradeData)
    local button = Instance.new("TextButton")
    button.Text = upgradeName .. "\n(" .. upgradeData.price .. " cookies)"
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
            button:Destroy()  -- Remove the upgrade from the list
            updateCookieDisplay()
        else
            warn("Not enough cookies or already purchased!")
        end
    end)
end

-- Initialize Upgrade Buttons
for upgradeName, upgradeData in pairs(upgrades) do
    createUpgradeButton(upgradeName, upgradeData)
end

-- Create Facility Buttons
local function createFacilityButton(facilityName, facilityData)
    local button = Instance.new("TextButton")
    button.Text = facilityName .. " (" .. math.floor(facilityData.basePrice) .. " cookies)"
    button.Size = UDim2.new(1, -10, 0, 50)
    button.Position = UDim2.new(0, 5, 0, facilityData.index * 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = ui.facilityList

    button.MouseButton1Click:Connect(function()
        if cookies >= facilityData.basePrice then
            cookies = cookies - facilityData.basePrice
            facilityData.basePrice = facilityData.basePrice * facilityData.priceGrowth
            button.Text = facilityName .. " (" .. math.floor(facilityData.basePrice) .. " cookies)"
            updateCookieDisplay()
        else
            warn("Not enough cookies!")
        end
    end)
end

-- Initialize Facility Buttons
for facilityName, facilityData in pairs(facilities) do
    createFacilityButton(facilityName, facilityData)
end

-- Automate Cookie Production
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

-- Start Automation
spawn(autoClickerLoop)