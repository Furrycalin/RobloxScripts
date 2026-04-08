-- 临时替换 tpWalk.lua 的内容
local tpWalk = {}

function tpWalk:Enabled(enabled)
    print("TPWalk Enabled:", enabled)
end

function tpWalk:GetEnabled()
    return false
end

function tpWalk:SetSpeed(speed) end
function tpWalk:GetSpeed()
    return 0.1
end

return tpWalk