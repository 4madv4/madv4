-- StreamProof Standalone - inject this AFTER vape is loaded
local runService = cloneref(game:GetService('RunService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

-- Wait for vape to be fully ready
repeat task.wait(0.1) until shared.vape and shared.vape.Categories and shared.vape.Categories.Render
local vape = shared.vape

print("[StreamProof] vape found, registering module...")

local StreamProof
local originalNames = {}
local nametagConnection = nil

local function modifyPlayerName(element)
	if not element:IsA("TextLabel") then return end
	if element.Name ~= "PlayerName" and element.Name ~= "EntityName" and element.Name ~= "DisplayName" then return end
	if element.Text:find(lplr.Name) or element.Text:find(lplr.DisplayName) then
		if not originalNames[element] then
			originalNames[element] = element.Text
		end
		element.Text = "Me"
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

local ok, err = pcall(function()
	StreamProof = vape.Categories.Render:CreateModule({
		Name = 'StreamProof',
		Function = function(callback)
			if callback then
				local existingTabList = lplr.PlayerGui:FindFirstChild("TabListScreenGui")
				if existingTabList then
					processGui(existingTabList)
					StreamProof:Clean(existingTabList.DescendantAdded:Connect(function(descendant)
						modifyPlayerName(descendant)
					end))
				end

				local existingKillFeed = lplr.PlayerGui:FindFirstChild("KillFeedGui")
				if existingKillFeed then
					processGui(existingKillFeed)
					StreamProof:Clean(existingKillFeed.DescendantAdded:Connect(function(descendant)
						modifyPlayerName(descendant)
					end))
				end

				StreamProof:Clean(lplr.PlayerGui.ChildAdded:Connect(function(gui)
					if gui.Name == "TabListScreenGui" then
						processGui(gui)
						StreamProof:Clean(gui.DescendantAdded:Connect(function(descendant)
							modifyPlayerName(descendant)
						end))
					elseif gui.Name == "KillFeedGui" then
						processGui(gui)
						StreamProof:Clean(gui.DescendantAdded:Connect(function(descendant)
							modifyPlayerName(descendant)
						end))
					end
				end))

				if lplr.Character then
					modifyNametag(lplr.Character)
				end

				StreamProof:Clean(lplr.CharacterAdded:Connect(function(character)
					task.wait(0.5)
					if StreamProof.Enabled then
						modifyNametag(character)
					end
				end))

				nametagConnection = runService.RenderStepped:Connect(function()
					if StreamProof.Enabled and lplr.Character then
						pcall(function()
							modifyNametag(lplr.Character)
						end)
					end
				end)
			else
				if nametagConnection then
					nametagConnection:Disconnect()
					nametagConnection = nil
				end

				local existingTabList = lplr.PlayerGui:FindFirstChild("TabListScreenGui")
				if existingTabList then
					for _, descendant in existingTabList:GetDescendants() do
						restorePlayerName(descendant)
					end
				end

				local existingKillFeed = lplr.PlayerGui:FindFirstChild("KillFeedGui")
				if existingKillFeed then
					for _, descendant in existingKillFeed:GetDescendants() do
						restorePlayerName(descendant)
					end
				end

				if lplr.Character then
					restoreNametag(lplr.Character)
				end

				table.clear(originalNames)
			end
		end,
		Tooltip = 'Hides your name in TabList, KillFeed, and Nametag'
	})
end)

if ok then
	print("[StreamProof] Module registered successfully!")
else
	print("[StreamProof] ERROR: " .. tostring(err))
end
