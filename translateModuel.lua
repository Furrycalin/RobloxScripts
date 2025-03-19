local translateModuel = {}

function translateModuel:translateText(text, api)
    if api == "YouDao" then
        local url = "https://api.52vmy.cn/api/query/fanyi/youdao?msg=" .. text
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
        local url = "https://api.52vmy.cn/api/ai/fanyi?msg=翻译成中文：" .. text
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            local data = HttpService:JSONDecode(response)
            return data.data.answer
        else
            return nil
        end
    end
end

return translateModuel