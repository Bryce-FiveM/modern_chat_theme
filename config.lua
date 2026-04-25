Config = {}

--- ====================
--- Please Read!
---
--- If you're installing this resource in your server with the intent
--- of using the Discord features and you do not have prior experience
--- setting up Discord bots, please read below:
---
--- For the Discord role integration, you'll need a Discord Bot in your server.
--- Don't worry, you don't need to host it, you only need to create one:
--- 1. Go to https://discord.com/developers/applications
--- 2. Click New Application -> give it a name -> Create
--- 3. On the left sidebar click Bot
--- 4. Click Reset Token -> copy the token and paste it to the DiscordBotToken variable
--- 5. While still on the Bot page, scroll down to Privileged Gateway Intents and enable
--- Server Members Intent
--- 6. On the left sidebar click OAuth2 -> URL Generator
--- 7. Under scopes check "Bot"
--- 8. Under bot Permissions check "View Channels" and "Manage Roles"
--- 9. Copy the generated URL at the bottom, open it in the browser, and add the bot to your server
--- 10. Lastly, in Discord, go to User Settings -> Advanced and enable Developer Mode
--- 11. Right click your server icon in the sidebar -> Copy Server ID -> paste into DiscordGuildId
---
--- If you experience any issues with your roles not showing, I suggest putting the bot's role above
--- the roles you want it to be able to read and ensure the bot is visible in your member list.
---
--- For the DiscordLogs feature, you'll need a WebHook. You can find see
--- how to create one here: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
--- You will be able to copy your WebHook ID there, and paste it into the DiscordWebhookURL variable.
--- ====================

-- Basic Configuration
Config.AllowDMs = true -- allow users to DM each other (/dm, /r)
Config.ProximityRange = 20.0 -- the range that proximity messages will be received

-- Discord Integration
Config.DiscordRolesEnabled = true -- prefix messages with the sender's highest Discord role
Config.DiscordGuildId = ""
Config.DiscordBotToken = ""

-- Webhook Logging
Config.DiscordLogs = true -- log chat messages/commands to a Discord channel
Config.DiscordWebhookURL = ""

-- Server event messages
Config.JoinMessages = false -- announce when a player joins
Config.LeaveMessages = false -- announce when a player leaves
Config.LogDrops = true -- print drop reason to server console (useful for crash debugging)
