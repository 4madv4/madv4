local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/4madv4/madv4/'..readfile('vaperewrite/profiles/commit.txt')..'/'..select(1, path:gsub('vaperewrite/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'vaperewrite', 'vaperewrite/games', 'vaperewrite/profiles', 'vaperewrite/assets', 'vaperewrite/libraries', 'vaperewrite/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

local function downloadPremadeProfiles(commit)
    local httpService = game:GetService('HttpService')
    if not isfolder('vaperewrite/profiles/premade') then
        makefolder('vaperewrite/profiles/premade')
    end

    local success, response = pcall(function()
        return game:HttpGet('https://api.github.com/repos/4madv4/madv4/contents/profiles/premade?ref=' .. commit)
    end)

    if success and response then
        local ok, files = pcall(function()
            return httpService:JSONDecode(response)
        end)

        if ok and type(files) == 'table' then
            for _, file in pairs(files) do
                if file.name and file.name:find('.txt') and file.name ~= 'commit.txt' then
                    local filePath = 'vaperewrite/profiles/premade/' .. file.name
                    if not isfile(filePath) then
                        local dl = file.download_url or ('https://raw.githubusercontent.com/poopparty/poopparty/' .. commit .. '/profiles/premade/' .. file.name)
                        local ds, dc = pcall(function()
                            return game:HttpGet(dl, true)
                        end)
                        if ds and dc and dc ~= '404: Not Found' then
                            writefile(filePath, dc)
                        end
                    end
                end
            end
        end
    end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/4madv4/madv4')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('vaperewrite/profiles/commit.txt') and readfile('vaperewrite/profiles/commit.txt') or '') ~= commit then
		wipeFolder('vaperewrite')
		wipeFolder('vaperewrite/games')
		wipeFolder('vaperewrite/guis')
		wipeFolder('vaperewrite/libraries')
	end
	downloadPremadeProfiles(commit)
	writefile('vaperewrite/profiles/commit.txt', commit)
end

return loadstring(downloadFile('vaperewrite/main.lua'), 'main')({
    Username = shared.ValidatedUsername
})
