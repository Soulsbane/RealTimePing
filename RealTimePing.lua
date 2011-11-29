local AddonName, Addon = ...
local MSG_PREFIX = "RealTimePing"

local function Round(number, decimals)
	return (("%%.%df"):format(decimals)):format(number)
end

function Addon:OnInitialize()
	self:RegisterSlashCommand("ping")
	RegisterAddonMessagePrefix(MSG_PREFIX)
	self:RegisterEvent("CHAT_MSG_ADDON")
end

function Addon:OnSlashCommand(msg)
	SendAddonMessage(MSG_PREFIX, tostring(GetTime()), "WHISPER", UnitName("player"))
end

function Addon:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	if prefix == "RealTimePing" then
		local now = GetTime() * 1000
		local sent = message * 1000

		self:Print("Pong: " .. Round(now - sent, 0))
	end
end
