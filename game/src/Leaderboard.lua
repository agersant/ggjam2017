local TableUtils = require("src/utils/TableUtils");

local Leaderboard = {};

local filename = "leaderboard.oink"
local writeToDisk;
local readFromDisk;

local maxEntries = 10;

Leaderboard.init = function(self)

	self._entries = {
		{ name = "Unagi", score = 300*100 },
		{ name = "Aji", score = 280*100 },
		{ name = "Ebi", score = 260*100 },
		{ name = "Tamago", score = 240*100 },
		{ name = "Maguro", score = 220*100 },
		{ name = "Saba", score = 200*100 },
		{ name = "Ikura", score = 180*100 },
		{ name = "Hamachi", score = 160*100 },
		{ name = "Sake", score = 140*100 },
		{ name = "Tako", score = 120*100 },
	};

	readFromDisk(self);
end

Leaderboard.getData = function(self)
	return TableUtils.shallowCopy(self._entries);
end

Leaderboard.getScorePosition = function(self, score)
	for i = #self._entries, 1, -1 do
		if score <= self._entries[i].score then
			if i == #self._entries then
				return nil;
			else
				return i + 1;
			end
		end
	end
	return 1;
end

Leaderboard.insert = function(self, name, score)
	table.insert(self._entries, { name = name, score = score });
	table.sort(self._entries, function(a, b)
		return a.score > b.score;
	end);
	while #self._entries > maxEntries do
		table.remove(self._entries, #self._entries);
	end
	writeToDisk(self);
end

readFromDisk = function(self)
	local rawData = love.filesystem.read(filename);
	if not rawData then
		return;
	end
	local luaChunk = loadstring(rawData);
	if not luaChunk or type(luaChunk) ~= "function" then 
		return;
	end
	local entries = luaChunk();
	if not entries or type(entries) ~= "table" then
		return;
	end
	for i, entry in ipairs(entries) do
		if not entry.name or not entry.score then
			return;
		end
	end
	self._entries = entries;
	print("Read " .. #self._entries .. " leaderboard entries from disk");
end

writeToDisk = function(self)
	local out = "return {";
	for i, entry in ipairs(self._entries) do
		out = out .. "{ name = \"" .. entry.name .. "\", score = " .. entry.score .. " },"
	end
	out = out .. "}";
	love.filesystem.write(filename, out);
	print("Wrote " .. #self._entries .. " leaderboard entries to disk");
end

return Leaderboard;
