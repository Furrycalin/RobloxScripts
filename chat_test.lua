ReplicatedStorage = game:GetService("ReplicatedStorage")
TextChatService = game:GetService("TextChatService")

isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end