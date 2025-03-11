local TeleportService = game:GetService("TeleportService")

local tpgame = {}

-- 将自己传送到目标游戏
function tpgame:teleportSelfToGame(targetPlaceId)
    local player = game.Players.LocalPlayer  -- 获取本地玩家
    if player then
        local success, errorMessage = pcall(function()
            TeleportService:TeleportAsync(targetPlaceId, player)
        end)
        
        if not success then
            warn("传送失败: " .. errorMessage)
        end
    else
        warn("无法找到本地玩家。")
    end
end

-- 将指定玩家传送到目标游戏
function tpgame:teleportPlayerToGame(player, targetPlaceId)
    if player and player:IsA("Player") then
        local success, errorMessage = pcall(function()
            TeleportService:TeleportAsync(targetPlaceId, player)
        end)
        
        if not success then
            warn("传送失败: " .. errorMessage)
        end
    else
        warn("提供的player参数无效。")
    end
end

return tpgame