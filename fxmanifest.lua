game("gta5")
fx_version("cerulean")

version("1.0.0")
author("Bryce <me@bryce.rocks>")
description("A sleek, modern theme for FiveM's chat.")

dependency("chat")

client_script("client/*.lua")
server_script("server/*.lua")
shared_script("config.lua")
file("style.css")

chat_theme("obsidian")({
	styleSheet = "style.css",
	msgTemplates = {
		obsidian = '<div id="message" class="{0}"><div class="accent"></div><div class="bg-accent"></div><div class="content"><div class="content__info"><span class="timestamp">{1}</span><span class="name">{2}</span><span class="tag">{3}</span></div><div class="content__body">{4}</div></div></div',
	},
})
