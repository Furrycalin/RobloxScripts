--[[
    Roblox DropDownMenu Component
    Version: 1.0.0
    Author: Roblox Developer
    Description: A reusable dropdown menu component for Roblox games that supports dynamic item addition and custom functions.
]]

local DropDownMenu = {}
DropDownMenu.__index = DropDownMenu

-- Constants for UI styling
local UI_STYLES = {
    Menu = {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 1,
        CornerRadius = UDim.new(0, 4),
        ShadowTransparency = 0.7,
        ShadowSize = 10
    },
    Title = {
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.SourceSansBold,
        Height = 30
    },
    Item = {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        HoverColor = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        DisabledColor = Color3.fromRGB(100, 100, 100),
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        Height = 28,
        IconSize = 20
    },
    Separator = {
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Height = 1
    }
}

--[[
    Creates a new DropDownMenu instance.
    
    Parameters:
        title (string) - The title to display at the top of the menu
        position (Vector2) - The position of the menu on the screen
        parent (Instance) - The parent instance to attach the menu to (usually PlayerGui)
        
    Returns:
        DropDownMenu - A new DropDownMenu instance
]]
function DropDownMenu.new(title, position, parent)
    local self = setmetatable({}, DropDownMenu)
    
    -- Create main UI components
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "DropDownMenu_" .. title
    self.screenGui.Parent = parent
    
    -- Main menu container
    self.menuContainer = Instance.new("Frame")
    self.menuContainer.Name = "MenuContainer"
    self.menuContainer.Position = UDim2.new(0, position.X, 0, position.Y)
    self.menuContainer.BackgroundColor3 = UI_STYLES.Menu.BackgroundColor3
    self.menuContainer.BorderColor3 = UI_STYLES.Menu.BorderColor3
    self.menuContainer.BorderSizePixel = UI_STYLES.Menu.BorderSizePixel
    self.menuContainer.ClipsDescendants = true
    self.menuContainer.Parent = self.screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UI_STYLES.Menu.CornerRadius
    corner.Parent = self.menuContainer
    
    -- Add shadow effect
    local shadow = Instance.new("UIStroke")
    shadow.Name = "MenuShadow"
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = UI_STYLES.Menu.ShadowTransparency
    shadow.Thickness = UI_STYLES.Menu.ShadowSize
    shadow.Parent = self.menuContainer
    
    -- Title bar
    self.titleBar = Instance.new("TextLabel")
    self.titleBar.Name = "TitleBar"
    self.titleBar.Text = title
    self.titleBar.BackgroundColor3 = UI_STYLES.Title.BackgroundColor3
    self.titleBar.TextColor3 = UI_STYLES.Title.TextColor3
    self.titleBar.TextSize = UI_STYLES.Title.TextSize
    self.titleBar.Font = UI_STYLES.Title.Font
    self.titleBar.Size = UDim2.new(1, 0, 0, UI_STYLES.Title.Height)
    self.titleBar.Position = UDim2.new(0, 0, 0, 0)
    self.titleBar.Parent = self.menuContainer
    
    -- Content container for menu items
    self.contentContainer = Instance.new("Frame")
    self.contentContainer.Name = "ContentContainer"
    self.contentContainer.BackgroundTransparency = 1
    self.contentContainer.Size = UDim2.new(1, 0, 0, 0)
    self.contentContainer.Position = UDim2.new(0, 0, 0, UI_STYLES.Title.Height)
    self.contentContainer.Parent = self.menuContainer
    
    -- UIListLayout for automatic item layout
    self.listLayout = Instance.new("UIListLayout")
    self.listLayout.Name = "ItemLayout"
    self.listLayout.FillDirection = Enum.FillDirection.Vertical
    self.listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.listLayout.Parent = self.contentContainer
    
    -- Store menu items
    self.menuItems = {}
    self.itemCount = 0
    
    -- Update menu size initially
    self:UpdateMenuSize()
    
    return self
end

--[[
    Adds a new item to the menu.
    
    Parameters:
        text (string) - The text to display for the item
        callback (function) - The function to execute when the item is clicked
        iconId (string, optional) - The asset ID of the icon to display (default: nil)
        isEnabled (boolean, optional) - Whether the item is enabled (default: true)
        
    Returns:
        Instance - The created menu item button
]]
function DropDownMenu:AddMenuItem(text, callback, iconId, isEnabled)
    -- Default values
    isEnabled = isEnabled ~= nil and isEnabled or true
    
    self.itemCount = self.itemCount + 1
    
    -- Create item button
    local itemButton = Instance.new("TextButton")
    itemButton.Name = "MenuItem_" .. self.itemCount
    itemButton.Text = text
    itemButton.BackgroundColor3 = UI_STYLES.Item.BackgroundColor3
    itemButton.TextColor3 = isEnabled and UI_STYLES.Item.TextColor3 or UI_STYLES.Item.DisabledColor
    itemButton.TextSize = UI_STYLES.Item.TextSize
    itemButton.Font = UI_STYLES.Item.Font
    itemButton.Size = UDim2.new(1, 0, 0, UI_STYLES.Item.Height)
    itemButton.LayoutOrder = self.itemCount
    itemButton.AutoButtonColor = false
    itemButton.Enabled = isEnabled
    itemButton.Parent = self.contentContainer
    
    -- Add hover effect
    itemButton.MouseEnter:Connect(function()
        if isEnabled then
            itemButton.BackgroundColor3 = UI_STYLES.Item.HoverColor
        end
    end)
    
    itemButton.MouseLeave:Connect(function()
        if isEnabled then
            itemButton.BackgroundColor3 = UI_STYLES.Item.BackgroundColor3
        end
    end)
    
    -- Add click event
    itemButton.MouseButton1Click:Connect(function()
        if isEnabled and type(callback) == "function" then
            callback()
        end
    end)
    
    -- Add icon if provided
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Name = "ItemIcon"
        icon.Image = iconId
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, UI_STYLES.Item.IconSize, 0, UI_STYLES.Item.IconSize)
        icon.Position = UDim2.new(0, 5, 0.5, -UI_STYLES.Item.IconSize/2)
        icon.Parent = itemButton
        
        -- Adjust text position to make room for icon
        itemButton.TextXAlignment = Enum.TextXAlignment.Left
        itemButton.TextTruncate = Enum.TextTruncate.AtEnd
        itemButton.TextBoundsOffset = Vector2.new(UI_STYLES.Item.IconSize + 10, 0)
    end
    
    -- Store the menu item
    table.insert(self.menuItems, {
        Button = itemButton,
        Text = text,
        Callback = callback,
        IconId = iconId,
        IsEnabled = isEnabled
    })
    
    -- Update menu size
    self:UpdateMenuSize()
    
    return itemButton
end

--[[
    Adds a separator line between menu items.
]]
function DropDownMenu:AddSeparator()
    self.itemCount = self.itemCount + 1
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator_" .. self.itemCount
    separator.BackgroundColor3 = UI_STYLES.Separator.BackgroundColor3
    separator.Size = UDim2.new(1, 0, 0, UI_STYLES.Separator.Height)
    separator.LayoutOrder = self.itemCount
    separator.Parent = self.contentContainer
    
    -- Store the separator
    table.insert(self.menuItems, {
        Button = separator,
        IsSeparator = true
    })
    
    -- Update menu size
    self:UpdateMenuSize()
    
    return separator
end

--[[
    Updates the menu size based on the number of items.
]]
function DropDownMenu:UpdateMenuSize()
    -- Calculate total content height
    local contentHeight = 0
    
    for _, item in ipairs(self.menuItems) do
        if item.IsSeparator then
            contentHeight = contentHeight + UI_STYLES.Separator.Height
        else
            contentHeight = contentHeight + UI_STYLES.Item.Height
        end
    end
    
    -- Update content container size
    self.contentContainer.Size = UDim2.new(1, 0, 0, contentHeight)
    
    -- Update menu container size
    local menuWidth = self.titleBar.TextBounds.X + 40 -- Add padding
    self.menuContainer.Size = UDim2.new(0, menuWidth, 0, UI_STYLES.Title.Height + contentHeight)
end

--[[
    Sets the enabled state of a specific menu item.
    
    Parameters:
        index (number) - The index of the menu item
        isEnabled (boolean) - Whether the item should be enabled
]]
function DropDownMenu:SetItemEnabled(index, isEnabled)
    if self.menuItems[index] and not self.menuItems[index].IsSeparator then
        local item = self.menuItems[index]
        item.IsEnabled = isEnabled
        item.Button.Enabled = isEnabled
        item.Button.TextColor3 = isEnabled and UI_STYLES.Item.TextColor3 or UI_STYLES.Item.DisabledColor
    end
end

--[[
    Updates the text of a specific menu item.
    
    Parameters:
        index (number) - The index of the menu item
        text (string) - The new text for the item
]]
function DropDownMenu:SetItemText(index, text)
    if self.menuItems[index] and not self.menuItems[index].IsSeparator then
        local item = self.menuItems[index]
        item.Text = text
        item.Button.Text = text
        
        -- Update menu size in case text is longer
        self:UpdateMenuSize()
    end
end

--[[
    Shows the menu.
]]
function DropDownMenu:Show()
    self.screenGui.Enabled = true
end

--[[
    Hides the menu.
]]
function DropDownMenu:Hide()
    self.screenGui.Enabled = false
end

--[[
    Destroys the menu and cleans up resources.
]]
function DropDownMenu:Destroy()
    -- Disconnect all connections
    for _, item in ipairs(self.menuItems) do
        if item.Button and item.Button:IsDescendantOf(game) then
            item.Button:Destroy()
        end
    end
    
    -- Destroy the main UI components
    self.screenGui:Destroy()
    
    -- Clear references
    self.menuItems = nil
end

return DropDownMenu
