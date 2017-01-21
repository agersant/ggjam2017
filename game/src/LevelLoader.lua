require('src/utils/OOP');
TableUtils = require('src/utils/TableUtils');

local LevelLoader = Class("LevelLoader");
LevelLoader.init = function(self)
end

local function compareEnts(a,b)
    return a.ent < b.ent
end

--Reads a list of objects from a Tiled level and returns a table data like this:
--level.numPickups
--level.pickups[1].ent -- used for sorting (pickups need to be collected in order)
--level.pickups[1].chunk
--level.pickups[1].x
--level.pickups[1].y

--TODO: Need to keep track of the amount in each level so Fish/GameScene can know when to load next level.
LevelLoader.loadLevel = function(self, levelName)
    local levelData = require("assets/levels/"..levelName);
    local entities = {};
    entities.pickups = {};
    entities.numPickups = 0;

    local objects = levelData.layers[1].objects;
    for i in pairs(objects) do
        print(levelName, entities);
        table.insert(entities.pickups, {
                ent = tonumber(objects[i].properties['ent']) + 1,
                chunk = objects[i].properties['chunk'],
                x = objects[i].x,
                y = objects[i].y
            })
        entities.numPickups =  entities.numPickups + 1;
    end
    table.sort(entities.pickups, compareEnts);
    return entities;
end

--return table of positions
return LevelLoader;