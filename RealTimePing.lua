local AddonName, Addon = ...
local MSG_PREFIX = "RealTimePing"
local string_format = string.format
local math_floor = math.floor
local CurrentPingValue = "0"

Addon.Feed = LibStub("LibDataBroker-1.1"):NewDataObject("RealTimePing", { type = "data source" })
Addon.Feed.icon = [[Interface\Addons\RealTimePing\computer.tga]]

local function Round(number, decimals)
	return (("%%.%df"):format(decimals)):format(number)
end

local function SendPing()
	SendAddonMessage(MSG_PREFIX, tostring(GetTime()), "WHISPER", UnitName("player"))
end

function Addon:OnInitialize()
	self:RegisterSlashCommand("ping")
	RegisterAddonMessagePrefix(MSG_PREFIX)
	self:RegisterEvent("CHAT_MSG_ADDON")
end

function Addon:OnSlashCommand(msg)
	SendPing()
end

function Addon:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	if prefix == "RealTimePing" then
		local now = GetTime() * 1000
		local sent = message * 1000

		CurrentPingValue = tostring(Round(now - sent, 0)))
		self:Print("Pong: " .. CurrentPingValue
	end
end

function Addon:OnInitialize()
	SendPing()
end

function Addon:OnEnable()
	self:StartRepeatingTimer(.2, "UpdateText")
	self:UpdateText()
end

function Addon:UpdateText()
	UpdateAddOnMemoryUsage()

	self.Feed.text = string_format("%d fps  %d ms %.1f MiB, %s rtp", math_floor(GetFramerate() + 0.5), select(3, GetNetStats()) , self:GetTotalAddonMemory(), CurrentPingValue)
end

function Addon:GetTotalAddonMemory()
	local numOfAddons = GetNumAddOns()
	local total = 0

	for i = 1, numOfAddons do
		local mem = GetAddOnMemoryUsage(i)
		total = total + mem
	end

	return total / 1024
end

function Addon.Feed.OnClick(self, button)
	SendPing()
end
