local HttpService = game:GetService("HttpService")

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
    end
end

return translateModuel