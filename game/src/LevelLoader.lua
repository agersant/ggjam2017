require('src/utils/OOP');
TableUtils = require('src/utils/TableUtils');

local LevelLoader = Class("LevelLoader");
LevelLoader.init = function(self)
end

local function compareEnts(a,b)
    return a.ent < b.ent
end

LevelLoader.loadLevel = function(self, levelName)
    local levelData = require("assets/levels/"..levelName);
    local entities = {};
    entities.pickups = {};

    local objects = levelData.layers[1].objects;
    for i, object in pairs(objects) do
		if object.type == "pickup" then
			local pickupIndex = tonumber(object.properties['ent']);
			if not pickupIndex then
				print("Missing pickup index for item in level " .. levelName);
			else
				table.insert(entities.pickups, {
					ent = pickupIndex,
					x = object.x,
					y = object.y
				});
			end
		end
    end
	
    table.sort(entities.pickups, compareEnts);
    return entities;
end

--return table of positions
return LevelLoader;
