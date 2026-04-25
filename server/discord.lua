-- ======================
--  Discord helpers
--  Guild roles are cached indefinitely (they rarely change).
--  Call RefreshGuildRoles() to bust that cache if needed.
-- ======================

local cachedGuildRoles = nil -- not yet fetched

-- Fetch guild roles, using cache if available.
local function getGuildRoles(cb)
	if cachedGuildRoles then
		return cb(cachedGuildRoles)
	end

	PerformHttpRequest(
		"https://discord.com/api/v10/guilds/" .. Config.DiscordGuildId .. "/roles",
		function(status, body, _)
			if status ~= 200 then
				return cb(nil)
			end
			cachedGuildRoles = json.decode(body)
			cb(cachedGuildRoles)
		end,
		"GET",
		"",
		{ ["Authorization"] = Config.DiscordBotToken }
	)
end

-- Bust the guild role cache (e.g. after roles change in Discord)
function RefreshGuildRoles()
	cachedGuildRoles = nil
end

-- Log a message to the configured Discord webhook.
function LogToDiscord(content)
	if not Config.DiscordLogs then
		return
	end

	if not Config.DiscordWebhookURL then
		print("You've enabled Discord logs but have not provided a Webhook URL. Please check your config.")
		return
	end

	PerformHttpRequest(Config.DiscordWebhookURL, function(status, _, _)
		if status ~= 204 then
			print("Webhook failed with status: " .. tostring(status))
		end
	end, "POST", json.encode({ content = content }), { ["Content-Type"] = "application/json" })
end

-- Resolve a player's highest Discord role name.
-- cb(roleName | nil)
function GetHighestDiscordRole(playerSource, cb)
	if not Config.DiscordRolesEnabled then
		return cb(nil)
	end

	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(playerSource)) do
		if id:sub(1, 8) == "discord:" then
			discordId = id:sub(9)
			break
		end
	end

	if not discordId then
		return cb(nil)
	end

	PerformHttpRequest(
		"https://discord.com/api/v10/guilds/" .. Config.DiscordGuildId .. "/members/" .. discordId,
		function(status, body, _)
			if status ~= 200 then
				return cb(nil)
			end

			local member = json.decode(body)
			if not member or not member.roles or #member.roles == 0 then
				return cb(nil)
			end

			local memberRoleSet = {}
			for _, rid in ipairs(member.roles) do
				memberRoleSet[rid] = true
			end

			getGuildRoles(function(guildRoles)
				if not guildRoles then
					return cb(nil)
				end

				local highestRole = nil
				for _, role in ipairs(guildRoles) do
					if memberRoleSet[role.id] then
						if not highestRole or role.position > highestRole.position then
							highestRole = role
						end
					end
				end

				cb(highestRole and highestRole.name or nil)
			end)
		end,
		"GET",
		"",
		{ ["Authorization"] = Config.DiscordBotToken }
	)
end
