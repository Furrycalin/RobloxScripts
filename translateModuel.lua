local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- 预设常见语言
local commonLanguages = {"en", "es", "fr", "de", "ja", "ko", "ru", "pt", "it"}

-- 尝试翻译
local function tryTranslate(text, targetLanguage)
    for _, sourceLanguage in ipairs(commonLanguages) do
        local success, result = pcall(function()
            return TextService:Translate(text, sourceLanguage, targetLanguage)
        end)
        if success then
            return result.Text
        end
    end
    return text -- 如果所有语言都失败，返回原始文本
end

local translateModuel = {}

local function urlEncode(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char:match("[a-zA-Z0-9%-_.~]") then
            -- 保留字母、数字和部分特殊字符
            result = result .. char
        else
            -- 对其他字符进行编码
            result = result .. string.format("%%%02X", char:byte())
        end
    end
    return result
end

function translateModuel:translateText(text, api)
    if api == "YouDao" then
        local url = "https://api.52vmy.cn/api/query/fanyi/youdao?msg=" .. urlEncode(text)
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            local data = HttpService:JSONDecode(response)
            return data.data.target
        else
            return nil
        end
    elseif api == "AI" then
        local url = "https://api.52vmy.cn/api/ai/fanyi?msg=翻译成中文：" .. urlEncode(text)
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            local data = HttpService:JSONDecode(response)
            if data.code == 110 then return text end
            return data.data.answer
        else
            return nil
        end
    elseif api == "Roblox" then
        return tryTranslate(text, "zh")
    end
end

return translateModuel