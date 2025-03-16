# 🎮 **Roblox Scripts**

欢迎来到我的 Roblox 脚本仓库！这里集合了我开发的一些 Roblox 脚本，所有脚本均可直接执行。如果你有任何问题或建议，欢迎提交 Issue 或 Pull Request！
  
# ⚠️ **警告**  

从📅2025年3月15日到📅3月25日，请尽量不要使用注入器，因The HUNT活动原因，此段时间极容易封号！

---

## 📜 **脚本列表**

### **▶ ChronixHubV2.lua**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/ChronixHubv2.lua"))()
```
**描述**  
重新编写了我的菜单脚本，重新设计了新的 UI，并优化了代码结构。目前仍在持续完善中。  
**支持的游戏：**  
- 🛠️ **Deathball**（死亡球）  
- ✅ **Grace**（格蕾丝）  
- ✅ **ProjectTransfur**（项目Transfur）  
- ✅ **CabinRolePlay**（小屋角色扮演）  
- ✅ **DelusionalOffice**（妄想办公室）  

---

### **▶ FlyV4.lua**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/FlyV4.lua"))()
```
**描述**  
基于 FlyV3 脚本的魔改版本，重写了 UI 并优化了代码逻辑。新增快捷键 Ctrl + F 来快速切换飞行模式。

---

### **▶ NewLoadAnimation.lua**  
**使用方法：**  
```lua
-- 加载实例到脚本中
local LoadAnimationModule = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/NewLoadAnimation.lua"))()

-- 使用示例
LoadAnimationModule:LoadAnimation(2, { -- 模拟加载时间的秒数
    titleText = "ChronixHub V2", -- 标题文本
    loadingText = "加载中... ", -- 加载文本
    backgroundColor = Color3.new(0, 0, 0), -- 背景颜色
    textColor = Color3.new(1, 1, 1), -- 文字颜色
    language = "zh", -- 语言，此选项主要在源码里修改，无必要无需修改
    onComplete = function(isCancelled)
        if isCancelled then
            -- 取消加载执行代码
        else
        	-- 加载完成执行代码
        end
    end,
    showCancelButton = true -- 是否启用取消按钮
})
```
**描述**  
自己设计的全新加载动画，目前是假加载进度，你也完全可以自己魔改成真加载进度，使用方法在上面。

---

### **▶ chat_test.lua**  
**使用方法：**  
```lua
-- 加载实例到脚本中
local chatcontrol = loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/chat_test.lua"))()

-- 使用示例
chatcontrol:chat("这是一段消息")

chatControl:MessageReceiver(function(messageData)
    print("发送者:", messageData.sender)
    print("消息:", messageData.text)
end)
```
**描述**  
可以控制玩家发送消息和接收玩家发送的消息。

---

### **▶ Notification.lua**  
**描述**  
轻量级的消息框提示脚本，适合开发者参考使用。 

---
  
### **▶ DoorsNotification.lua**  
**描述**  
模仿《Doors》游戏中的成就框效果，适合开发者参考使用。

---

### **▶ chat_test.lua**  
**描述**  
实现聊天消息发送的代码示例，适合开发者参考。

---

## 🚫 **停止更新或弃用**
### **▶ AdminPanel.lua**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/AdminPanel.lua"))()
```
**描述**  
指令式功能集合脚本，通过输入指令实现各种功能。此脚本为 ChronixHub 的分支改版，目前已停止更新。

---

### **▶ ChronixHub.lua**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/ChronixHub.lua"))()
```
**描述**  
我的功能性菜单脚本，已实现部分实用功能。此脚本已停止更新，建议使用 ChronixHubV2。

---

### **▶ 移速控制.lua（已集成到 ChronixHubV2）**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/%E7%A7%BB%E9%80%9F%E6%9B%B4%E6%94%B9.lua"))()
```
**描述**  
可更改大部分小游戏的移动速度。**注意：** 请不要在有反作弊的服务器中使用，后果自负。

---

### **▶ Deathball.lua（已集成到 ChronixHubV2）**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/Deathball.lua"))()
```
**描述**  
死亡球脚本，目前无法使用自动格挡功能。开发已被暂停，欢迎有兴趣的开发者继续完善。

---

### **▶ Grace.lua（已集成到 ChronixHubV2）**  
**执行代码：**  
```lua
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/Grace.lua"))()
```
**描述**  
我制作的 Grace 脚本，可自动开门并删除所有怪物。

## 🤝 **贡献指南**
如果你有兴趣为这个项目贡献代码，请遵循以下步骤：
1. Fork 本仓库。
2. 创建一个新的分支（git checkout -b feature/YourFeatureName）。
3. 提交你的更改（git commit -m 'Add some feature'）。
4. 推送分支（git push origin feature/YourFeatureName）。
5. 提交 Pull Request。

## 📄 许可证  
本项目基于 [MIT License](https://opensource.org/licenses/MIT) 发布。