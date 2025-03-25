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

-- 通用翻译API调用函数
local function callTranslateAPI(apiType, text)
    local apiEndpoints = {
        YouDao = "https://api.52vmy.cn/api/query/fanyi/youdao?msg=",
        AI = "https://api.52vmy.cn/api/ai/fanyi?msg=翻译成中文：",
        Bing = "https://api.52vmy.cn/api/query/fanyi?msg=",
        SoGou = "https://api.52vmy.cn/api/query/fanyi/sogou?msg=",
        QQ = "https://api.52vmy.cn/api/query/fanyi/qq?msg="
    }
    
    -- 检查API类型是否有效
    if not apiEndpoints[apiType] then
        return text
    end
    
    local url = apiEndpoints[apiType] .. urlEncode(text)
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return text
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success then
        return text
    end
    
    -- 处理不同API的响应结构
    if apiType == "AI" then
        if data.code == 110 then
            return text -- 特殊代码，返回原文
        end
        return data.data.answer
    else
        return data.data.target
    end
end

function translateModuel:translateText(text, api)
    -- 参数检查
    if not text or type(text) ~= "string" then
        return text
    end
    
    -- 特殊处理Roblox翻译
    if api == "Roblox" then
        return tryTranslate(text, "zh")
    end
    
    -- 调用通用API处理
    local result = callTranslateAPI(api, text)
    
    -- 如果翻译失败，返回原始文本
    return result or text
end

return translateModuel