local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- 判断是否为旧聊天系统
local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

local chatControl = {}

-- 发送消息的函数
function chatControl:chat(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- 接收消息的函数
function chatControl:MessageReceiver(callback)
    if not isLegacyChat then
        -- 新聊天系统：监听 RBXGeneral 频道的消息
        TextChatService.TextChannels.RBXGeneral.OnIncomingMessage:Connect(function(message)
            local messageData = {}
            messageData["sender"] = message.TextSource -- 发送者
            messageData["text"] = message.Text -- 消息内容
            callback(messageData)
        end)
    else
        -- 旧聊天系统：监听 OnMessageDoneFiltering 事件
        ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
            local messageData = {}
            messageData["sender"] = messageData.FromSpeaker -- 发送者
            messageData["text"] = messageData.Message -- 消息内容
            callback(messageData)
        end)
    end
end

return chatControl