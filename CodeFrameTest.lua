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
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    -- 创建 UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = size
    ScrollingFrame.Position = position
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始 CanvasSize
    ScrollingFrame.Parent = ScreenGui

    local LineNumbers = Instance.new("TextLabel")
    LineNumbers.Size = UDim2.new(0.05, 0, 1, 0)
    LineNumbers.Position = UDim2.new(0, 0, 0, 0)
    LineNumbers.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LineNumbers.BorderSizePixel = 0
    LineNumbers.TextColor3 = Color3.fromRGB(200, 200, 200)
    LineNumbers.TextXAlignment = Enum.TextXAlignment.Right
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

-- 示例用法
local codeEditor = createCodeEditor(UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.25, 0, 0.25, 0))

-- 设置内容
codeEditor.set([[
function test()
    local x = 10
    local y = "Hello, World!"
    if x > 5 then
        print(y)
    end
    -- This is a comment
    return x + 5
end
]])

-- 获取内容
local content = codeEditor.get()
print("获取的内容：", content)