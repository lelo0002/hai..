local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local httprequest = request or http_request or (http and http.request)
local getassetfunc = getcustomasset

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles;

local assert = function(condition, errorMessage) 
    if (not condition) then
        error(if errorMessage then errorMessage else "assert failed", 3)
    end
end

if typeof(clonefunction) == "function" then
    -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local ThemeManager = {} do
	local ThemeFields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor", "VideoLink" }
	ThemeManager.Folder = "LinoriaLibSettings"
	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = nil
ThemeManager.BuiltInThemes = {
	['Roxy.win']         = { 1,  { FontColor = "ffffff", MainColor = "161616", AccentColor = "5384ab", BackgroundColor = "131313", OutlineColor = "1e1e1e" } },
	['BBot']             = { 2,  { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" } },
	['Fatality']         = { 3,  { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" } },
	['Jester']           = { 4,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
	['Mint']             = { 5,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
	['Tokyo Night']      = { 6,  { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" } },
	['Ubuntu']           = { 7,  { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" } },
	['Quartz']           = { 8,  { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" } },

	['Carbon']           = { 9,  { FontColor = "ffffff", MainColor = "1a1a1a", AccentColor = "5c5cff", BackgroundColor = "121212", OutlineColor = "2c2c2c" } },
	['Graphite']         = { 10, { FontColor = "f0f0f0", MainColor = "202020", AccentColor = "888888", BackgroundColor = "161616", OutlineColor = "303030" } },
	['Violet Dream']     = { 11, { FontColor = "ffffff", MainColor = "221c30", AccentColor = "b06cff", BackgroundColor = "171320", OutlineColor = "342a46" } },
	['Iceberg']          = { 12, { FontColor = "ffffff", MainColor = "1d2830", AccentColor = "6ccfff", BackgroundColor = "141c22", OutlineColor = "30414c" } },
	['Rose Gold']        = { 13, { FontColor = "ffffff", MainColor = "2b1f24", AccentColor = "ff7f9f", BackgroundColor = "1d1519", OutlineColor = "3a2b30" } },
	['Nightfall']        = { 14, { FontColor = "ffffff", MainColor = "181818", AccentColor = "4a90e2", BackgroundColor = "101010", OutlineColor = "242424" } },
	['Cherry']           = { 15, { FontColor = "ffffff", MainColor = "2a1a1d", AccentColor = "ff335f", BackgroundColor = "1a1113", OutlineColor = "40252b" } },
	['Cyberpunk']        = { 16, { FontColor = "ffffff", MainColor = "1a1a22", AccentColor = "ff00aa", BackgroundColor = "111118", OutlineColor = "2c2c38" } },
	['Electric Blue']    = { 17, { FontColor = "ffffff", MainColor = "182030", AccentColor = "00aaff", BackgroundColor = "101722", OutlineColor = "263349" } },
	['Lime']             = { 18, { FontColor = "ffffff", MainColor = "1e241b", AccentColor = "8cff00", BackgroundColor = "151914", OutlineColor = "2e3829" } },
	['Oceanic']          = { 19, { FontColor = "ffffff", MainColor = "1a2630", AccentColor = "00c8ff", BackgroundColor = "121b22", OutlineColor = "2c3f4d" } },
	['Blood Moon']       = { 20, { FontColor = "ffffff", MainColor = "241414", AccentColor = "ff4444", BackgroundColor = "180d0d", OutlineColor = "3a2424" } },
	['Slate']            = { 21, { FontColor = "ffffff", MainColor = "252525", AccentColor = "5f7a8a", BackgroundColor = "1a1a1a", OutlineColor = "353535" } },
	['Dracula']          = { 22, { FontColor = "f8f8f2", MainColor = "282a36", AccentColor = "bd93f9", BackgroundColor = "21222c", OutlineColor = "44475a" } },
	['Nord']             = { 23, { FontColor = "eceff4", MainColor = "2e3440", AccentColor = "88c0d0", BackgroundColor = "242933", OutlineColor = "3b4252" } },
	['Matrix']           = { 24, { FontColor = "a6ff9b", MainColor = "111111", AccentColor = "00ff66", BackgroundColor = "090909", OutlineColor = "1d1d1d" } },
	['Sunset']           = { 25, { FontColor = "ffffff", MainColor = "2a2020", AccentColor = "ff8844", BackgroundColor = "1c1515", OutlineColor = "3c2c2c" } },
	['Aqua']             = { 26, { FontColor = "ffffff", MainColor = "1b2528", AccentColor = "44ffe1", BackgroundColor = "13191c", OutlineColor = "2d3b3f" } },
	['Steam']            = { 27, { FontColor = "ffffff", MainColor = "1b2838", AccentColor = "66c0f4", BackgroundColor = "101822", OutlineColor = "2c3e50" } },
	['Mono']             = { 28, { FontColor = "ffffff", MainColor = "202020", AccentColor = "ffffff", BackgroundColor = "151515", OutlineColor = "2c2c2c" } },
	['Obsidian']         = { 29, { FontColor = "ffffff", MainColor = "141414", AccentColor = "9b59b6", BackgroundColor = "0d0d0d", OutlineColor = "232323" } },
	['Forest']           = { 30, { FontColor = "ffffff", MainColor = "1c241d", AccentColor = "44cc66", BackgroundColor = "141914", OutlineColor = "2c382d" } },
	['Inferno']          = { 31, { FontColor = "ffffff", MainColor = "2a1812", AccentColor = "ff5500", BackgroundColor = "1b100b", OutlineColor = "40251d" } },
	['Purple Haze']      = { 32, { FontColor = "ffffff", MainColor = "241b2e", AccentColor = "b266ff", BackgroundColor = "191320", OutlineColor = "382b46" } },
	['Royal']            = { 33, { FontColor = "ffffff", MainColor = "1c2233", AccentColor = "5577ff", BackgroundColor = "141925", OutlineColor = "2e3850" } },
	['Emerald']          = { 34, { FontColor = "ffffff", MainColor = "18241d", AccentColor = "00d27a", BackgroundColor = "101814", OutlineColor = "284030" } },
	['Arctic']           = { 35, { FontColor = "ffffff", MainColor = "1f2b33", AccentColor = "99ddff", BackgroundColor = "151d22", OutlineColor = "30424d" } },
	['Mocha']            = { 36, { FontColor = "ffffff", MainColor = "2a221d", AccentColor = "c89b6d", BackgroundColor = "1d1714", OutlineColor = "40352f" } },
	['Ruby']             = { 37, { FontColor = "ffffff", MainColor = "2c161c", AccentColor = "ff3366", BackgroundColor = "1d1014", OutlineColor = "42252d" } },
	['Sapphire']         = { 38, { FontColor = "ffffff", MainColor = "162030", AccentColor = "3399ff", BackgroundColor = "101722", OutlineColor = "26364d" } },
	['Ghost']            = { 39, { FontColor = "ffffff", MainColor = "2a2a2a", AccentColor = "d9d9d9", BackgroundColor = "1d1d1d", OutlineColor = "3a3a3a" } },
	['Midnight']         = { 40, { FontColor = "ffffff", MainColor = "111827", AccentColor = "3b82f6", BackgroundColor = "0b1120", OutlineColor = "1f2937" } },
	['Coral']            = { 41, { FontColor = "ffffff", MainColor = "2b1f1d", AccentColor = "ff7f50", BackgroundColor = "1d1514", OutlineColor = "40302d" } },
	['Blossom']          = { 42, { FontColor = "ffffff", MainColor = "2a1f28", AccentColor = "ff66c4", BackgroundColor = "1d151b", OutlineColor = "403040" } },
	['Neon Green']       = { 43, { FontColor = "ffffff", MainColor = "151515", AccentColor = "39ff14", BackgroundColor = "0d0d0d", OutlineColor = "242424" } },
	['Minimal Red']      = { 44, { FontColor = "ffffff", MainColor = "1d1d1d", AccentColor = "ff4444", BackgroundColor = "141414", OutlineColor = "2c2c2c" } },
	['Minimal Blue']     = { 45, { FontColor = "ffffff", MainColor = "1d1d1d", AccentColor = "4488ff", BackgroundColor = "141414", OutlineColor = "2c2c2c" } },
	['Minimal Purple']   = { 46, { FontColor = "ffffff", MainColor = "1d1d1d", AccentColor = "aa66ff", BackgroundColor = "141414", OutlineColor = "2c2c2c" } },
	['Minimal Green']    = { 47, { FontColor = "ffffff", MainColor = "1d1d1d", AccentColor = "44ff88", BackgroundColor = "141414", OutlineColor = "2c2c2c" } },
	['Pearl']            = { 48, { FontColor = "ffffff", MainColor = "252525", AccentColor = "c0c0c0", BackgroundColor = "1b1b1b", OutlineColor = "343434" } },
	['Deep Space']       = { 49, { FontColor = "ffffff", MainColor = "11131a", AccentColor = "5d7cff", BackgroundColor = "0b0d12", OutlineColor = "1f2430" } },
	['Gunmetal']         = { 50, { FontColor = "ffffff", MainColor = "23272e", AccentColor = "7289da", BackgroundColor = "1b1f24", OutlineColor = "323841" } },
	['Frost']            = { 51, { FontColor = "ffffff", MainColor = "202830", AccentColor = "7dd3fc", BackgroundColor = "151b22", OutlineColor = "303c47" } },
	['Void']             = { 52, { FontColor = "ffffff", MainColor = "121212", AccentColor = "6f42c1", BackgroundColor = "090909", OutlineColor = "1f1f1f" } },
	['Candy']            = { 53, { FontColor = "ffffff", MainColor = "2a1c22", AccentColor = "ff66aa", BackgroundColor = "1c1217", OutlineColor = "40303a" } },
	['Dark Matter']      = { 54, { FontColor = "ffffff", MainColor = "181818", AccentColor = "9d4edd", BackgroundColor = "101010", OutlineColor = "252525" } },
	['Celestial']        = { 55, { FontColor = "ffffff", MainColor = "1a1f2b", AccentColor = "7aa2ff", BackgroundColor = "121620", OutlineColor = "2b3242" } },
	['Toxic']            = { 56, { FontColor = "ffffff", MainColor = "1b2015", AccentColor = "b4ff00", BackgroundColor = "12160f", OutlineColor = "2d3824" } },
	['Velvet']           = { 57, { FontColor = "ffffff", MainColor = "241820", AccentColor = "d16ba5", BackgroundColor = "191118", OutlineColor = "382830" } },
	['Blueberry']        = { 58, { FontColor = "ffffff", MainColor = "1c2230", AccentColor = "6699ff", BackgroundColor = "141925", OutlineColor = "2d3850" } },
	['Night Sky']        = { 59, { FontColor = "ffffff", MainColor = "151a22", AccentColor = "89b4fa", BackgroundColor = "0f1319", OutlineColor = "252c38" } },
	['Pine']             = { 60, { FontColor = "ffffff", MainColor = "1c241f", AccentColor = "4ade80", BackgroundColor = "141914", OutlineColor = "2c382d" } },
	['Lavender']         = { 61, { FontColor = "ffffff", MainColor = "241f2a", AccentColor = "c084fc", BackgroundColor = "18141d", OutlineColor = "383040" } },
	['Cobalt']           = { 62, { FontColor = "ffffff", MainColor = "162033", AccentColor = "3b82f6", BackgroundColor = "101722", OutlineColor = "26364d" } },
	['Sandstorm']        = { 63, { FontColor = "ffffff", MainColor = "2a241c", AccentColor = "d4a373", BackgroundColor = "1c1812", OutlineColor = "40362c" } },
	['Plasma']           = { 64, { FontColor = "ffffff", MainColor = "20192a", AccentColor = "ff00ff", BackgroundColor = "15111c", OutlineColor = "342a42" } },
	['Onyx']             = { 65, { FontColor = "ffffff", MainColor = "171717", AccentColor = "707070", BackgroundColor = "101010", OutlineColor = "232323" } },
	['Crimson']          = { 66, { FontColor = "ffffff", MainColor = "2a1518", AccentColor = "dc2626", BackgroundColor = "1b0d10", OutlineColor = "40252a" } },
	['Skyline']          = { 67, { FontColor = "ffffff", MainColor = "1c2630", AccentColor = "38bdf8", BackgroundColor = "131a22", OutlineColor = "2e3e4d" } },
	['Ivory Dark']       = { 68, { FontColor = "f5f5f5", MainColor = "2a2a2a", AccentColor = "d6d3d1", BackgroundColor = "1d1d1d", OutlineColor = "3c3c3c" } },
	['Horizon']          = { 69, { FontColor = "ffffff", MainColor = "222233", AccentColor = "ff9966", BackgroundColor = "171722", OutlineColor = "35354a" } },
	['CSGO Green']       = { 70, { FontColor = "ffffff", MainColor = "1b1e1b", AccentColor = "8cff4a", BackgroundColor = "121412", OutlineColor = "2a2f2a" } },
	['Gamesense']        = { 71, { FontColor = "ffffff", MainColor = "1c1c1c", AccentColor = "a0ff00", BackgroundColor = "111111", OutlineColor = "2d2d2d" } },
	['Neverlose']        = { 72, { FontColor = "ffffff", MainColor = "202020", AccentColor = "00b4ff", BackgroundColor = "151515", OutlineColor = "303030" } },
	['Primordial']       = { 73, { FontColor = "ffffff", MainColor = "1f1f2a", AccentColor = "8b5cf6", BackgroundColor = "14141c", OutlineColor = "303042" } },
	['Skeet']            = { 74, { FontColor = "ffffff", MainColor = "1d1d1d", AccentColor = "99ff00", BackgroundColor = "141414", OutlineColor = "2d2d2d" } },
	['Monolith']         = { 75, { FontColor = "ffffff", MainColor = "1a1a1a", AccentColor = "4f46e5", BackgroundColor = "111111", OutlineColor = "292929" } },
}

	function ApplyBackgroundVideo(videoLink)
		if
			typeof(videoLink) ~= "string" or
			not (getassetfunc and writefile and readfile and isfile) or
			not (ThemeManager.Library and ThemeManager.Library.InnerVideoBackground)
		then return; end;

		--// Variables \\--
		local videoInstance = ThemeManager.Library.InnerVideoBackground;
		local extension = videoLink:match(".*/(.-)?") or videoLink:match(".*/(.-)$"); extension = tostring(extension);
		local filename = string.sub(extension, 0, -6);
		local _, domain = videoLink:match("^(https?://)([^/]+)"); domain = tostring(domain); -- _ is protocol

		--// Check URL \\--
		if videoLink == "" then
			videoInstance:Pause();
			videoInstance.Video = "";
			videoInstance.Visible = false;
			return
		end
		if #extension > 5 and string.sub(extension, -5) ~= ".webm" then return; end;

		--// Fetch Video Data \\--
		local videoFile = ThemeManager.Folder .. "/themes/" .. string.gsub(domain .. filename, 0, 249) .. ".webm";
		if not isfile(videoFile) then
			local success, requestRes = pcall(httprequest, { Url = videoLink, Method = 'GET' })
			if not (success and typeof(requestRes) == "table" and typeof(requestRes.Body) == "string") then return; end;

			writefile(videoFile, requestRes.Body)
		end

		--// Play Video \\--
		videoInstance.Video = getassetfunc(videoFile);
		videoInstance.Visible = true;
		videoInstance:Play();
	end

	function ThemeManager:SetLibrary(library)
		self.Library = library
	end

	--// Folders \\--
	function ThemeManager:GetPaths()
	    local paths = {}

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		paths[#paths + 1] = self.Folder .. '/themes'
		
		return paths
	end

	function ThemeManager:BuildFolderTree()
		local paths = self:GetPaths()

		for i = 1, #paths do
			local str = paths[i]
			if isfolder(str) then continue end
			makefolder(str)
		end
	end

	function ThemeManager:CheckFolderTree()
		if isfolder(self.Folder) then return end
		self:BuildFolderTree()

		task.wait(0.1)
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end
	
	--// Apply, Update theme \\--
	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end

		-- custom themes are just regular dictionaries instead of an array with { index, dictionary }
		if self.Library.InnerVideoBackground ~= nil then
			self.Library.InnerVideoBackground.Visible = false
		end
		
		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			if idx == "VideoLink" then
				self.Library[idx] = col
				
				if self.Library.Options[idx] then
					self.Library.Options[idx]:SetValue(col)
				end
				
				ApplyBackgroundVideo(col)
			else
				self.Library[idx] = Color3.fromHex(col)
				
				if self.Library.Options[idx] then
					self.Library.Options[idx]:SetValueRGB(Color3.fromHex(col))
				end
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		-- This allows us to force apply themes without loading the themes tab :)
		if self.Library.InnerVideoBackground ~= nil then
			self.Library.InnerVideoBackground.Visible = false
		end

		for i, field in next, ThemeFields do
			if self.Library.Options and self.Library.Options[field] then
				self.Library[field] = self.Library.Options[field].Value

				if field == "VideoLink" then
					ApplyBackgroundVideo(self.Library.Options[field].Value)
				end
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	--// Get, Load, Save, Delete, Refresh \\--
	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file .. '.json'
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:LoadDefault()
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
			theme = self.DefaultTheme
		end

		if isDefault then
			self.Library.Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			self.Library:Notify('Invalid file name for theme (empty)', 3)
			return
		end

		local theme = {}
		for _, field in next, ThemeFields do
			if field == "VideoLink" then
				theme[field] = self.Library.Options[field].Value
			else
				theme[field] = self.Library.Options[field].Value:ToHex()
			end
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', HttpService:JSONEncode(theme))
	end

	function ThemeManager:Delete(name)
		if (not name) then
			return false, 'no config file is selected'
		end

		local file = self.Folder .. '/themes/' .. name .. '.json'
		if not isfile(file) then return false, 'invalid file' end

		local success = pcall(delfile, file)
		if not success then return false, 'delete file error' end
		
		return true
	end
	
	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1, start - 1))
				end
			end
		end

		return out
	end

	--// GUI \\--
	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });
		groupbox:AddInput('VideoLink', { Text = '.webm Video Background (Link)', Default = self.Library.VideoLink });
		
		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()

		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })
		groupbox:AddButton('Set as default', function()
			self:SaveDefault(self.Library.Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Set default theme to %q', self.Library.Options.ThemeManager_ThemeList.Value))
		end)

		self.Library.Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(self.Library.Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()

		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
		groupbox:AddButton('Create theme', function() 
			local name = self.Library.Options.ThemeManager_CustomThemeName.Value
			if name:gsub(" ", "") == "" then
                self.Library:Notify("Invalid theme name (empty)", 2)
                return
            end

            self:SaveCustomTheme(name)

            self.Library:Notify(string.format("Created theme %q", name))
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddDivider()

		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddButton('Load theme', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			self:ApplyTheme(name)
			self.Library:Notify(string.format('Loaded theme %q', name))
		end)
		groupbox:AddButton('Overwrite theme', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			self:SaveCustomTheme(name)
			self.Library:Notify(string.format('Overwrote config %q', name))
		end)
		groupbox:AddButton('Delete theme', function()
			local name = self.Library.Options.ThemeManager_CustomThemeList.Value

			local success, err = self:Delete(name)
			if not success then
				self.Library:Notify('Failed to delete theme: ' .. err)
				return
			end

			self.Library:Notify(string.format('Deleted theme %q', name))
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)
		groupbox:AddButton('Refresh list', function()
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)
		groupbox:AddButton('Set as default', function()
			if self.Library.Options.ThemeManager_CustomThemeList.Value ~= nil and self.Library.Options.ThemeManager_CustomThemeList.Value ~= '' then
				self:SaveDefault(self.Library.Options.ThemeManager_CustomThemeList.Value)
				self.Library:Notify(string.format('Set default theme to %q', self.Library.Options.ThemeManager_CustomThemeList.Value))
			end
		end)
		groupbox:AddButton('Reset default', function()
			local success = pcall(delfile, self.Folder .. '/themes/default.txt')
			if not success then 
				self.Library:Notify('Failed to reset default: delete file error')
				return
			end
				
			self.Library:Notify('Set default theme to nothing')
			self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		self:LoadDefault()

		local function UpdateTheme() self:ThemeUpdate() end
		self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
		self.Library.Options.MainColor:OnChanged(UpdateTheme)
		self.Library.Options.AccentColor:OnChanged(UpdateTheme)
		self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
		self.Library.Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'ThemeManager:CreateGroupBox -> Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'ThemeManager:ApplyToTab -> Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'ThemeManager:ApplyToGroupbox -> Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

getgenv().LinoriaThemeManager = ThemeManager
return ThemeManager
