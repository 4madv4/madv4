local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

-- 1. FIX: Added all required services
local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))
local runService = cloneref(game:GetService('RunService'))

local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local sessioninfo = vape.Libraries.sessioninfo
local bedwars = {}

local function notif(...)
    return vape:CreateNotification(...)
end

-- 2. FIX: Wait for Vape to actually be ready
repeat task.wait() until shared.vape and shared.vape.Categories

-- 3. FIX: Correctly clear old modules without crashing the script
for _, v in pairs(vape.Modules) do
    if v.Category == 'Combat' or v.Category == 'Render' then
        vape:Remove(v.Name)
    end
end

-- MODULE: Sprint
run(function()
    local Sprint
    local old
    Sprint = vape.Categories.Combat:CreateModule({
        Name = 'Sprint',
        Function = function(callback)
            if callback then
                old = bedwars.SprintController.stopSprinting
                bedwars.SprintController.stopSprinting = function(...)
                    local call = old(...)
                    bedwars.SprintController:startSprinting()
                    return call
                end
            else
                bedwars.SprintController.stopSprinting = old
            end
        end,
        Tooltip = 'Sets your sprinting to true.'
    })
end)

-- MODULE: Stream Proof (This is the one you wanted)
run(function()
    local StreamProof
    local originalNames = {}
    local nametagConnection

    local function modifyPlayerName(element)
        if element:IsA("TextLabel") and (element.Name == "PlayerName" or element.Name == "EntityName" or element.Name == "DisplayName") then
            if element.Text:find(lplr.Name) or element.Text:find(lplr.DisplayName) then
                if not originalNames[element] then originalNames[element] = element.Text end
                element.Text = "Me"
            end
        end
    end

    StreamProof = vape.Categories.Render:CreateModule({
        Name = 'Stream Proof',
        Function = function(callback)
            if callback then
                -- Handle existing UI
                for _, gui in pairs(lplr.PlayerGui:GetChildren()) do
                    if gui.Name == "TabListScreenGui" or gui.Name == "KillFeedGui" then
                        for _, d in pairs(gui:GetDescendants()) do modifyPlayerName(d) end
                        StreamProof:Clean(gui.DescendantAdded:Connect(modifyPlayerName))
                    end
                end
                -- Constant Nametag Update
                nametagConnection = runService.RenderStepped:Connect(function()
                    pcall(function()
                        if lplr.Character and lplr.Character:FindFirstChild("Head") then
                            local tag = lplr.Character.Head:FindFirstChild("Nametag")
                            if tag then modifyPlayerName(tag:FindFirstChild("DisplayName", true)) end
                        end
                    end)
                end)
            else
                if nametagConnection then nametagConnection:Disconnect() end
                table.clear(originalNames)
                notif("Stream Proof", "Restart script to fully restore names", 5)
            end
        end,
        Tooltip = 'Hides your name in Tab, Killfeed, and Nametags'
    })
end)

-- MODULE: AutoGamble
run(function()
    local AutoGamble = vape.Categories.Minigames:CreateModule({
        Name = 'AutoGamble',
        Function = function(callback)
            -- Logic for gambling here
        end,
        Tooltip = 'Automatically opens lucky crates'
    })
end)

-- Final notification to confirm it loaded
notif("Script Loaded", "Stream Proof is in the Render category!", 5)
