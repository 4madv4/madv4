--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))
local runService = cloneref(game:GetService('RunService')) -- Fixed: Added missing service 

local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local sessioninfo = vape.Libraries.sessioninfo
local bedwars = {}

local function notif(...)
	return vape:CreateNotification(...)
end

run(function()
	local function dumpRemote(tab)
		local ind = table.find(tab, 'Client')
		return ind and tab[ind + 1] or ''
	end
	local KnitInit, Knit
	repeat
		KnitInit, Knit = pcall(function()
			return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 9)
		end)
		if KnitInit then break end
		task.wait(0.1)
	until KnitInit

	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait(0.1) until debug.getupvalue(Knit.Start, 1)
	end

	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local InventoryUtil = require(replicatedStorage.TS.inventory['inventory-util']).InventoryUtil
	local Client = require(replicatedStorage.TS.remotes).default.Client
	local OldGet, OldBreak = Client.Get
	local function safeGetProto(func, index)
		if not func then return nil end
		local success, proto = pcall(safeGetProto, func, index)
		if success then
			return proto
		else
			warn("function:", func, "index:", index) 
			return nil
		end
	end

	bedwars = setmetatable({
	 	MatchHistroyApp = require(lplr.PlayerScripts.TS.controllers.global["match-history"].ui["match-history-moderation-app"]).MatchHistoryModerationApp,
	 	MatchHistroyController = Knit.Controllers.MatchHistoryController,
		AbilityController = Flamework.resolveDependency('@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController'),
		AnimationType = require(replicatedStorage.TS.animation['animation-type']).AnimationType,
		AnimationUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out['shared'].util['animation-util']).AnimationUtil,
		AppController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.controllers['app-controller']).AppController,
		BedBreakEffectMeta = require(replicatedStorage.TS.locker['bed-break-effect']['bed-break-effect-meta']).BedBreakEffectMeta,
		BedwarsKitMeta = require(replicatedStorage.TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta,
		ClickHold = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.ui.lib.util['click-hold']).ClickHold,
		Client = Client,
		ClientConstructor = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts'].net.out.client),
		MatchHistoryController = require(lplr.PlayerScripts.TS.controllers.global['match-history']['match-history-controller']),
		PlayerProfileUIController = require(lplr.PlayerScripts.TS.controllers.global['player-profile']['player-profile-ui-controller']),
		TitleTypes = require(game.ReplicatedStorage.TS.locker.title['title-type']).TitleType,
		TitleTypesMeta =  require(game.ReplicatedStorage.TS.locker.title['title-meta']).TitleMeta,
		EmoteType = require(replicatedStorage.TS.locker.emote['emote-type']).EmoteType,
		GameAnimationUtil = require(replicatedStorage.TS.animation['animation-util']).GameAnimationUtil,
		NotificationController = Flamework.resolveDependency('@easy-games/game-core:client/controllers/notification-controller@NotificationController'),
		getIcon = function(item, showinv)
			local itemmeta = bedwars.ItemMeta[item.itemType]
			return itemmeta and showinv and itemmeta.image or ''
		end,
		getInventory = function(plr)
			local suc, res = pcall(function()
				return InventoryUtil.getInventory(plr)
			end)
			return suc and res or {
				items = {},
				armor = {}
			}
		end,
		HudAliveCount = require(lplr.PlayerScripts.TS.controllers.global['top-bar'].ui.game['hud-alive-player-counts']).HudAlivePlayerCounts,
		ItemMeta = debug.getupvalue(require(replicatedStorage.TS.item['item-meta']).getItemMeta, 1),
		Knit = Knit,
		KnockbackUtil = require(replicatedStorage.TS.damage['knockback-util']).KnockbackUtil,
		MageKitUtil = require(replicatedStorage.TS.games.bedwars.kit.kits.mage['mage-kit-util']).MageKitUtil,
		NametagController = Knit.Controllers.NametagController,
		PartyController = Flamework.resolveDependency('@easy-games/lobby:client/controllers/party-controller@PartyController'),
		ProjectileMeta = require(replicatedStorage.TS.projectile['projectile-meta']).ProjectileMeta,
		QueryUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil,
		QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui['queue-card']).QueueCard,
		QueueMeta = require(replicatedStorage.TS.game['queue-meta']).QueueMeta,
		Roact = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts']['roact'].src),
		RuntimeLib = require(replicatedStorage['rbxts_include'].RuntimeLib),
		SoundList = require(replicatedStorage.TS.sound['game-sound']).GameSound,
		Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
		TeamUpgradeMeta = debug.getupvalue(require(replicatedStorage.TS.games.bedwars['team-upgrade']['team-upgrade-meta']).getTeamUpgradeMetaForQueue, 6),
		UILayers = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).UILayers,
		VisualizerUtils = require(lplr.PlayerScripts.TS.lib.visualizer['visualizer-utils']).VisualizerUtils,
		WeldTable = require(replicatedStorage.TS.util['weld-util']).WeldUtil,
		WinEffectMeta = require(replicatedStorage.TS.locker['win-effect']['win-effect-meta']).WinEffectMeta,
		ZapNetworking = require(lplr.PlayerScripts.TS.lib.network),
	}, {
		__index = function(self, ind)
			rawset(self, ind, Knit.Controllers[ind])
			return rawget(self, ind)
		end
	})

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	vape:Clean(function()
		table.clear(bedwars)
	end)
end)

-- Fixed: Changed 'i' to '_' and ensured 'v.Name' is used to prevent crashing 
for _, v in pairs(vape.Modules) do
	if v.Category == 'Combat' or v.Category == 'Render' then
		vape:Remove(v.Name)
	end
end

run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = false end) end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() bedwars.SprintController:stopSprinting() end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = true end) end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
	
run(function()
	local AutoGamble
	
	AutoGamble = vape.Categories.Minigames:CreateModule({
		Name = 'AutoGamble',
		Function = function(callback)
			if callback then
				AutoGamble:Clean(bedwars.Client:GetNamespace('RewardCrate'):Get('CrateOpened'):Connect(function(data)
					if data.openingPlayer == lplr then
						local tab = bedwars.CrateItemMeta[data.reward.itemType] or {displayName = data.reward.itemType or 'unknown'}
						notif('AutoGamble', 'Won '..tab.displayName, 5)
					end
				end))
	
				repeat
					if not bedwars.CrateAltarController.activeCrates[1] then
						for _, v in bedwars.Store:getState().Consumable.inventory do
							if v.consumable:find('crate') then
								bedwars.CrateAltarController:pickCrate(v.consumable, 1)
								task.wait(1.2)
								if bedwars.CrateAltarController.activeCrates[1] and bedwars.CrateAltarController.activeCrates[1][2] then
									bedwars.Client:GetNamespace('RewardCrate'):Get('OpenRewardCrate'):SendToServer({
										crateId = bedwars.CrateAltarController.activeCrates[1][2].attributes.crateId
									})
								end
								break
							end
						end
					end
					task.wait(1)
				until not AutoGamble.Enabled
			end
		end,
		Tooltip = 'Automatically opens lucky crates, piston inspired!'
	})
end)
	
-- Stream Proof Module 
run(function()
	local StreamProof
	local originalNames = {}
	local nametagConnection = nil
	
	local function modifyPlayerName(element)
		if element:IsA("TextLabel") and element.Name == "PlayerName" then
			if element.Text:find(lplr.Name) or element.Text:find(lplr.DisplayName) then
				if not originalNames[element] then
					originalNames[element] = element.Text
				end
				element.Text = "Me"
			end
		end
		
		if element:IsA("TextLabel") and element.Name == "EntityName" then
			if element.Text:find(lplr.Name) or element.Text:find(lplr.DisplayName) then
				if not originalNames[element] then
					originalNames[element] = element.Text
				end
				element.Text = "Me"
			end
		end
		
		if element:IsA("TextLabel") and element.Name == "DisplayName" then
			if element.Text:find(lplr.Name) or element.Text:find(lplr.DisplayName) then
				if not originalNames[element] then
					originalNames[element] = element.Text
				end
				element.Text = "Me"
			end
		end
	end
	
	local function restorePlayerName(element)
		if originalNames[element] then
			element.Text = originalNames[element]
			originalNames[element] = nil
		end
	end
	
	local function processGui(gui)
		for _, descendant in gui:GetDescendants() do
			modifyPlayerName(descendant)
		end
	end
	
	local function modifyNametag(character)
		if not character then return end
		local head = character:FindFirstChild("Head")
		if not head then return end
		local nametag = head:FindFirstChild("Nametag")
		if not nametag then return end
		local displayNameContainer = nametag:FindFirstChild("DisplayNameContainer")
		if not displayNameContainer then return end
		local displayName = displayNameContainer:FindFirstChild("DisplayName")
		if displayName and displayName:IsA("TextLabel") then
			modifyPlayerName(displayName)
		end
	end
	
	local function restoreNametag(character)
		if not character then return end
		local head = character:FindFirstChild("Head")
		if not head then return end
		local nametag = head:FindFirstChild("Nametag")
		if not nametag then return end
		local displayNameContainer = nametag:FindFirstChild("DisplayNameContainer")
		if not displayNameContainer then return end
		local displayName = displayNameContainer:FindFirstChild("DisplayName")
		if displayName and displayName:IsA("TextLabel") then
			restorePlayerName(displayName)
		end
	end
	
	StreamProof = vape.Categories.Render:CreateModule({
		Name = 'Stream Proof',
		Function = function(callback)
			if callback then
				local existingTabList = lplr.PlayerGui:FindFirstChild("TabListScreenGui")
				if existingTabList then
					processGui(existingTabList)
					StreamProof:Clean(existingTabList.DescendantAdded:Connect(modifyPlayerName))
				end
				
				local existingKillFeed = lplr.PlayerGui:FindFirstChild("KillFeedGui")
				if existingKillFeed then
					processGui(existingKillFeed)
					StreamProof:Clean(existingKillFeed.DescendantAdded:Connect(modifyPlayerName))
				end
				
				StreamProof:Clean(lplr.PlayerGui.ChildAdded:Connect(function(gui)
					if gui.Name == "TabListScreenGui" or gui.Name == "KillFeedGui" then
						processGui(gui)
						StreamProof:Clean(gui.DescendantAdded:Connect(modifyPlayerName))
					end
				end))
				
				if lplr.Character then modifyNametag(lplr.Character) end
				StreamProof:Clean(lplr.CharacterAdded:Connect(function(char)
					task.wait(0.5)
					if StreamProof.Enabled then modifyNametag(char) end
				end))
				
				nametagConnection = runService.RenderStepped:Connect(function()
					if StreamProof.Enabled and lplr.Character then
						pcall(modifyNametag, lplr.Character)
					end
				end)
			else
				if nametagConnection then nametagConnection:Disconnect(); nametagConnection = nil end
				local tab = lplr.PlayerGui:FindFirstChild("TabListScreenGui")
				if tab then for _, d in pairs(tab:GetDescendants()) do restorePlayerName(d) end end
				local feed = lplr.PlayerGui:FindFirstChild("KillFeedGui")
				if feed then for _, d in pairs(feed:GetDescendants()) do restorePlayerName(d) end end
				if lplr.Character then restoreNametag(lplr.Character) end
				table.clear(originalNames)
			end
		end,
		Tooltip = 'Hides your name in TabList, KillFeed, and Nametag [cite: 3, 10]'
	})
end)
