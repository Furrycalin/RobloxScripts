local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- 判断是否为旧聊天系统
local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

-- 发送消息的函数
function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- 接收消息的函数
local function setupMessageReceiver()
    if not isLegacyChat then
        -- 新聊天系统：监听 RBXGeneral 频道的消息
        TextChatService.TextChannels.RBXGeneral.OnIncomingMessage:Connect(function(message)
            local sender = message.TextSource -- 发送者
            local text = message.Text -- 消息内容
            print("新聊天系统 - 收到消息：", sender, text)
        end)
    else
        -- 旧聊天系统：监听 OnMessageDoneFiltering 事件
        ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
            local sender = messageData.FromSpeaker -- 发送者
            local text = messageData.Message -- 消息内容
            print("旧聊天系统 - 收到消息：", sender, text)
        end)
    end
end

-- 初始化消息接收
setupMessageReceiver()