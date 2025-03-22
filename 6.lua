local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local chatControl = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/chat_test.lua"))()

local seed = math.random(1, 9999)
local url = "https://api.52vmy.cn/api/wl/yan/yiyan?random=" .. seed
local success, response = pcall(function()
    chatControl:chat("正在从网络中获取JSON数据... | 种子码：" .. seed)
    return game:HttpGet(url)
end)

if success then
    chatControl:chat("解析数据...")
    local data = HttpService:JSONDecode(response)
    chatControl:chat("每日一言：" .. data.data.hitokoto)
    chatControl:chat("来自：" .. data.data.source)
    chatControl:chat("作者：" .. data.data.author)     
end