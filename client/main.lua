-- gets the client's system time.
function GetTimestamp()
	local _, _, _, hour, minute, _ = GetLocalTime()

	if minute <= 9 then
		minute = "0" .. minute
	end

	local timestamp = hour .. ":" .. minute
	return timestamp
end

-- command autocompletes
Citizen.CreateThread(function()
	TriggerEvent("chat:addSuggestion", "/ooc", "Out of character global chat", {
		{ name = "Message", help = "The message to send" },
	})

	TriggerEvent("chat:addSuggestion", "/looc", "Out of character local chat", {
		{ name = "Message", help = "The message to send" },
	})

	TriggerEvent("chat:addSuggestion", "/me", "Perform an action in character locally", {
		{ name = "Action", help = "The action to perform" },
	})

	TriggerEvent("chat:addSuggestion", "/gme", "Perform an action in character globally", {
		{ name = "Action", help = "The action to perform" },
	})

	TriggerEvent("chat:addSuggestion", "/do", "Describe an environment or condition", {
		{ name = "Description", help = "The description" },
	})

	TriggerEvent("chat:addSuggestion", "/ad", "Broadcast a global advertisement", {
		{ name = "Advertisement", help = "The advertisement" },
	})

	TriggerEvent("chat:addSuggestion", "/li", "Send a global LifeInvader post", {
		{ name = "Post", help = "The post content" },
	})

	TriggerEvent("chat:addSuggestion", "/dw", "Send an anonymous global dark web post", {
		{ name = "Post", help = "The post content" },
	})

	if Config.AllowDMs then
		TriggerEvent("chat:addSuggestion", "/dm", "Send a private message to a player", {
			{ name = "ID", help = "The player's server ID" },
			{ name = "Message", help = "Your message" },
		})

		TriggerEvent("chat:addSuggestion", "/r", "Reply to your last DM", {
			{ name = "Message", help = "Your message" },
		})
	end
end)

-- event handlers
RegisterNetEvent("obsidian_chat:addMessage")
AddEventHandler("obsidian_chat:addMessage", function(type, name, tag, message)
	local timestamp = GetTimestamp()
	TriggerEvent("chat:addMessage", { templateId = "obsidian", args = { type, timestamp, name, tag, message } })
end)

RegisterNetEvent("obsidian_chat:addProximityMessage")
AddEventHandler("obsidian_chat:addProximityMessage", function(type, name, tag, message, authorServerId, ax, ay, az)
	local authorCoords = vector3(ax, ay, az)
	local myCoords = GetEntityCoords(PlayerPedId())

	if GetPlayerServerId(PlayerId()) == authorServerId or #(myCoords - authorCoords) < Config.ProximityRange then
		local timestamp = GetTimestamp()
		TriggerEvent("chat:addMessage", { templateId = "obsidian", args = { type, timestamp, name, tag, message } })
	end
end)
