-- ======================
--  Role cache
--  Populated on playerConnecting, cleared on playerDropped.
--  Key = player source (integer), value = role name string or false (no role found)
-- ======================
local roleCache = {}

-- ======================
-- DM cache
-- Only stores DM senders and their recipients, in order to
-- allow a user to use the /r command to quick-reply to a DM.
-- Key = recipient (integer), value = author source (integer)
-- ======================
local lastDmSource = {}

-- Fetch and cache a player's highest Discord role.
-- cb(roleName | nil) is calld once the fetch resolves.
local function fetchAndCacheRole(source, cb)
	GetHighestDiscordRole(source, function(role)
		roleCache[source] = role or false
		if cb then
			cb(role)
		end
	end)
end

-- Returns the cached role immediately, or triggers a fetch if the cache is cold.
local function getCachedRole(source, cb)
	local cached = roleCache[source]
	if cached ~= nil then
		cb(cached ~= false and cached or nil)
	else
		fetchAndCacheRole(source, cb)
	end
end

-- Warm the cache as early as possible when a player connects
AddEventHandler("playerConnecting", function(_, _, deferrals)
	deferrals.defer()
	local src = source
	fetchAndCacheRole(src, function()
		deferrals.done()
	end)
end)

AddEventHandler("playerDropped", function(reason, resourceName, clientDropReason)
	local src = source

	if Config.LogDrops then
		print(
			string.format(
				"%s dropped | Reason: %s | Resource: %s | Client: %s",
				GetPlayerName(src),
				reason,
				resourceName,
				clientDropReason
			)
		)
	end

	if Config.LeaveMessages then
		TriggerClientEvent(
			"obsidian_chat:addMessage",
			-1,
			"system",
			"System",
			"sys",
			GetPlayerName(src) .. " left. (Reason: " .. reason .. ")"
		)
	end

	roleCache[src] = nil -- clear cache
end)

-- ======================
--  Join messages
-- ======================
if Config.JoinMessages then
	AddEventHandler("playerJoining", function()
		TriggerClientEvent(
			"obsidian_chat:addMessage",
			-1,
			"system",
			"System",
			"Sys",
			GetPlayerName(source) .. " joined."
		)
	end)
end

-- ======================
--  Global chat
-- ======================
AddEventHandler("chatMessage", function(source, _, message)
	CancelEvent()

	if message:sub(1, 1) == "/" then
		return
	end

	local src = source
	local playerName = GetPlayerName(src)

	if Config.DiscordRolesEnabled then
		getCachedRole(src, function(role)
			local displayName = role and (role .. " | " .. playerName) or playerName
			LogToDiscord(string.format("**[Global]** `%s`: %s", playerName, message))
			TriggerClientEvent("obsidian_chat:addMessage", -1, "global", displayName, "Global", message)
		end)
	else
		LogToDiscord(string.format("**[Global]** `%s`: %s", playerName, message))
		TriggerClientEvent("obsidian_chat:addMessage", -1, "global", playerName, "Global", message)
	end
end)

-- ======================
--  OOC command
-- ======================
RegisterCommand("ooc", function(source, args, _)
	if #args == 0 then
		return
	end
	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)

	LogToDiscord(string.format("**[OOC]** `%s`: %s", playerName, message))
	TriggerClientEvent("obsidian_chat:addMessage", -1, "ooc", playerName, "OOC", message)
end, false)

-- ======================
--  LOOC command (prox)
-- ======================
RegisterCommand("looc", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	LogToDiscord(string.format("**[LOOC]** `%s`: %s", playerName, message))

	TriggerClientEvent(
		"obsidian_chat:addProximityMessage",
		-1,
		"looc",
		playerName,
		"LOOC",
		message,
		source,
		coords.x,
		coords.y,
		coords.z
	)
end, false)

-- ======================
--  ME command (prox)
-- ======================
RegisterCommand("me", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	LogToDiscord(string.format("**[ME]** `%s`: %s", playerName, message))
	TriggerClientEvent(
		"obsidian_chat:addProximityMessage",
		-1,
		"me",
		playerName,
		"ME",
		message,
		source,
		coords.x,
		coords.y,
		coords.z
	)
end, false)

-- ======================
--  GME command
-- ======================
RegisterCommand("gme", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)

	LogToDiscord(string.format("**[GME]** `%s`: %s", playerName, message))
	TriggerClientEvent("obsidian_chat:addMessage", -1, "gme", playerName, "gME", message)
end, false)

-- ======================
--  DO command
-- ======================
RegisterCommand("do", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	LogToDiscord(string.format("**[DO]** `%s`: %s", playerName, message))
	TriggerClientEvent(
		"obsidian_chat:addProximityMessage",
		-1,
		"do",
		playerName,
		"DO",
		message,
		source,
		coords.x,
		coords.y,
		coords.z
	)
end, false)

-- ======================
--  AD command
-- ======================
RegisterCommand("ad", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)

	LogToDiscord(string.format("**[AD]** `%s`: %s", playerName, message))
	TriggerClientEvent("obsidian_chat:addMessage", -1, "ad", playerName, "AD", message)
end, false)

-- ======================
--  LI command
-- ======================
RegisterCommand("li", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)

	LogToDiscord(string.format("**[LI]** `%s`: %s", playerName, message))
	TriggerClientEvent("obsidian_chat:addMessage", -1, "li", playerName, "li", message)
end, false)

-- ======================
--  DW command
-- ======================
RegisterCommand("dw", function(source, args, _)
	if #args == 0 then
		return
	end

	local message = table.concat(args, " ")
	local playerName = GetPlayerName(source)

	LogToDiscord(string.format("**[DW]** `%s`: %s", playerName, message))
	TriggerClientEvent("obsidian_chat:addMessage", -1, "dw", "Anonymous", "Dark Web", message)
end, false)

if Config.AllowDMs then
	-- ======================
	--  DM commands
	-- ======================
	RegisterCommand("dm", function(source, args, _)
		if #args < 2 then
			return
		end

		local targetId = tonumber(args[1])
		local message = table.concat(args, " ", 2)

		if not targetId or targetId == 0 then
			TriggerClientEvent("obsidian_chat:addMessage", source, "system", "System", "sys", "Invalid ID.")

			return
		elseif targetId == source then
			TriggerClientEvent(
				"obsidian_chat:addMessage",
				source,
				"system",
				"System",
				"sys",
				"You cannot send a DM to yourself."
			)

			return
		end

		if not targetId or not GetPlayerName(targetId) then
			TriggerClientEvent(
				"obsidian_chat:addMessage",
				source,
				"system",
				"System",
				"sys",
				"Player with ID " .. tostring(targetId) .. " not found."
			)
			return
		end

		local senderName = GetPlayerName(source)
		local targetName = GetPlayerName(targetId)

		lastDmSource[targetId] = source
		lastDmSource[source] = targetId

		TriggerClientEvent(
			"obsidian_chat:addMessage",
			source,
			"dm",
			"to " .. targetName .. " (" .. targetId .. ")",
			"DM",
			message
		)
		TriggerClientEvent(
			"obsidian_chat:addMessage",
			targetId,
			"dm",
			"from " .. senderName .. " (" .. source .. ")",
			"DM",
			message
		)
	end, false)

	RegisterCommand("r", function(source, args, _)
		if #args == 0 then
			return
		end

		local targetId = lastDmSource[source]
		if targetId == 0 then -- this shouldn't ever be 0
			return
		end

		if not targetId then
			TriggerClientEvent("obsidian_chat:addMessage", source, "system", "System", "sys", "No one to reply to.")
			return
		end

		if not GetPlayerName(targetId) then
			TriggerClientEvent(
				"obsidian_chat:addMessage",
				source,
				"system",
				"",
				"System",
				"sys",
				"That player has left the server."
			)
			lastDmSource[source] = nil
			return
		end

		local message = table.concat(args, " ")
		local senderName = GetPlayerName(source)
		local targetName = GetPlayerName(targetId)

		lastDmSource[targetId] = source
		lastDmSource[source] = targetId

		TriggerClientEvent(
			"obsidian_chat:addMessage",
			source,
			"dm",
			"to " .. targetName .. " (" .. targetId .. ")",
			"DM",
			message
		)
		TriggerClientEvent(
			"obsidian_chat:addMessage",
			targetId,
			"dm",
			"from " .. senderName .. " (" .. source .. ")",
			"DM",
			message
		)
	end, false)
end
