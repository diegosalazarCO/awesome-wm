-- Grab environment
local utils = require("freedesktop.utils")
local io = io
local ipairs = ipairs
local table = table
local os = os

module("freedesktop.menu")

function new()
	-- the categories and their synonyms where shamelessly copied from lxpanel
	-- source code.
	local programs = {}
	programs['AudioVideo'] = {}
	programs['Audio'] = {}
	programs['Video'] = {}
	programs['Development'] = {}
	--programs['Education'] = {}
	programs['Game'] = {}
	programs['Graphics'] = {}
	programs['Network'] = {}
	programs['Office'] = {}
	programs['Settings'] = {}
	programs['System'] = {}
	programs['Utility'] = {}
	programs['Other'] = {}


	for i, program in ipairs(utils.parse_dir('/usr/share/applications/')) do

		-- check whether to include in the menu
		if program.show and program.Name and program.cmdline then
			local target_category = nil
			if program.categories then
				for _, category in ipairs(program.categories) do
					if programs[category] then
						target_category = category
						break
					end
				end
			end
			if not target_category then
				target_category = 'Other'
			end
			if target_category then
				table.insert(programs[target_category], { program.Name, program.cmdline })
				--table.insert(programs[target_category], { program.Name, program.cmdline, nil})
			end
		end

	end

	local menu = {
		{ "Accessories", programs["Utility"], },
		{ "Development", programs["Development"], },
		{ "Education", programs["Education"], },
		{ "Games", programs["Game"], },
		{ "Graphics", programs["Graphics"], },
		{ "Internet", programs["Network"], },
		{ "Multimedia", programs["AudioVideo"], },
		{ "Office", programs["Office"], },
		{ "Other", programs["Other"], },
		{ "Settings", programs["Settings"], },
		{ "System Tools", programs["System"], },
	}

	-- Removing empty entries from menu
	local bad_indexes = {}
	for index , item in ipairs(menu) do
		if not item[2] then
			table.insert(bad_indexes, index)
		end
	end
	table.sort(bad_indexes, function (a,b) return a > b end)
	for _, index in ipairs(bad_indexes) do
		table.remove(menu, index)
	end

	return menu
end

