local AddonName, Addon = ...
local MSG_PREFIX = "RealTimePing"
local string_format = string.format
local CurrentPingValue = "0"
local WOW_API_VERSION = select(4, GetBuildInfo())

Addon.Feed = LibStub("LibDataBroker-1.1"):NewDataObject("RealTimePing", { type = "data source" })
Addon.Feed.icon = [[Interface\Addons\RealTimePing\computer.tga]]

local function Round(number, decimals)
	return (("%%.%df"):format(decimals)):format(number)
end

local function SendPing()
	--TODO: Should probably add some sort of ID to avoid ping collisions.
	if(WOW_API_VERSION >= 80000) then
		C_ChatInfo.SendAddonMessage(MSG_PREFIX, tostring(GetTime()), "WHISPER", UnitName("player"))
	else
		SendAddonMessage(MSG_PREFIX, tostring(GetTime()), "WHISPER", UnitName("player"))
	end
end

function Addon:OnInitialize()
	self:EnableDebug(true)
	self:StartRepeatingTimer(1)
	self:StartRepeatingTimer(5, "OnPingTimer")

	if(WOW_API_VERSION >= 80000) then
		C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
	else
		RegisterAddonMessagePrefix(MSG_PREFIX)
	end

	self:RegisterEvent("CHAT_MSG_ADDON")
end

function Addon:OnEnable()
	self:RegisterSlashCommand("ping")
end

function Addon:OnSlashCommand(msg)
	SendPing()
end

function Addon:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	if prefix == "RealTimePing" then
		local now = GetTime() * 1000
		local sent = message * 1000

		CurrentPingValue = tostring(Round(now - sent, 0))
		--self:Print("Pong: " .. CurrentPingValue) --Add option later to re-enable
	end
end

function Addon:OnTimer(elapsed, name)
	self.Feed.text = string_format("%d ms %s rtp", select(3, GetNetStats()) , CurrentPingValue)
end

function Addon:OnPingTimer(elapsed, name)
	SendPing()
end

function Addon.Feed.OnClick(self, button)
	SendPing()
end
