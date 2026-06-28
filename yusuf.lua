local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

-- 🌟 YENİ ORBIT LOG KANALININ WEBHOOK URL'İNİ BURAYA YAPIŞTIR
local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1520836928583368817/-Ok-poCmg6pbShDV3RK_0bTuYuXGohJYYlLoZRO88_7eMfn7NaXVyiilxnzm3UbnoZL5"

-- 🌟 2. SCRIPT İÇİN ÖZEL ENDPOINT (Backend'e istek /whitelist-kontrol2 olarak gidecek)
local API_URL = "https://ahead-coastal-relapsing.ngrok-free.dev/whitelist-kontrol2"

local function CheckWhitelist()
    local headers = {["ngrok-skip-browser-warning"] = "true"}
    local success, result
    
    if http_request then
        success, result = pcall(function()
            return http_request({
                Url = API_URL,
                Method = "GET",
                Headers = headers
            }).Body
        end)
    end
    
    if not success or not result then
        success, result = pcall(function() return game:HttpGet(API_URL, true) end)
    end
    
    if success and result and result ~= "" then
        local allowedIds = HttpService:JSONDecode(result)
        for _, id in ipairs(allowedIds) do
            if LocalPlayer.UserId == tonumber(id) then return true end
        end
    end
    return false
end

-- Yeni Script İçin Özelleştirilmiş Log Sistemi
local function SendLogToDiscord()
    pcall(function()
        local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        local accountAge = LocalPlayer.AccountAge
        local userId = LocalPlayer.UserId
        local username = LocalPlayer.Name
        local displayName = LocalPlayer.DisplayName
        local membershipType = tostring(LocalPlayer.MembershipType):gsub("Enum.MembershipType.", "")
        
        local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
        local hwid = (gethwid and gethwid()) or "Not Supported"
        
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 YUSUF SCRIPT ACTIVATED Successfully",
                ["color"] = 16738657, -- Farklı bir görsel renk (Pembe/Kırmızı tonu)
                ["fields"] = {
                    {["name"] = "Username (Display)", ["value"] = username .. " (" .. displayName .. ")", ["inline"] = true},
                    {["name"] = "Roblox ID", ["value"] = tostring(userId), ["inline"] = true},
                    {["name"] = "Account Age", ["value"] = tostring(accountAge) .. " days", ["inline"] = true},
                    {["name"] = "User Details", ["value"] = "**Premium:** " .. membershipType .. "\n**Executor:** " .. executor .. "\n**HWID:** `" .. hwid .. "`", ["inline"] = false},
                    {["name"] = "Game & Server Info", ["value"] = "**Name:** " .. gameName .. "\n**Place ID:** " .. tostring(game.PlaceId) .. "\n**Players:** " .. #Players:GetPlayers() .. "/" .. game.Players.MaxPlayers, ["inline"] = false},
                    {["name"] = "Server Teleport Code (JobId)", ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" .. game.PlaceId .. ", '" .. game.JobId .. "', game.Players.LocalPlayer)\n```", ["inline"] = false}
                },
                ["footer"] = {["text"] = "Yusuf System Logging • " .. os.date("%X")}
            }}
        }
        
        (http_request or request)({
            Url = DISCORD_WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Whitelist Kontrolü Başlıyor Bildirimi
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "🔑 MAL YUSUF",
        Text = "AWEL YUSUF MUSUN KONTROL ETÇEM BEKLE",
        Duration = 4
    })
end)

task.wait(4.0)

-- EĞER WHITELISTTE YOKSA
if not CheckWhitelist() then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "❌ NİGGA YUSUF!",
            Text = "BU HESAP EKLİ DEĞİL DM YAZ",
            Duration = 5,
            Button1 = "TAMAM ABİ"
        })
    end)
    return
end

-- EĞER WHITELISTTE VARSA
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✅ AWEL YUSUF ALGILANDI!",
        Text = "AFERİN EĞLEN BİRAZ",
        Duration = 4
    })
end)

---------------------------------------------------------------------------
-- 🌟 ORİJİNAL ORBIT KODUNUN TAMAMI
---------------------------------------------------------------------------
--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
setting = settings().Network
local Effect = Instance.new("ColorCorrectionEffect")
Effect.Parent = game.Lighting
Effect.Saturation = -1
Effect.Brightness = 0
Effect.Contrast = 0

toggle = false

Effect.Enabled = false

function onKeyPress(inputObject, gameProcessedEvent)
    if inputObject.KeyCode == Enum.KeyCode.C then  -- Toggle op X toets
        if toggle == false then
            setting.IncomingReplicationLag = 1000
            Effect.Enabled = true
            toggle = true
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed * 1
        else
            setting.IncomingReplicationLag = 0
            Effect.Enabled = false
            toggle = false
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
