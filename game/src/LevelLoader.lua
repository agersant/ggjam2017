require('src/utils/OOP');

local LevelLoader = Class("LevelLoader");
LevelLoader.init = function(self)
end

--Reads a list of objects from a Tiled level and returns a table of pickup positions
--level.pickups[1].x
--level.pickups[1].y
LevelLoader.loadLevel = function(self, levelName)
    local levelData = require("assets/levels/"..levelName);
    local entities = {};
    entities.pickups = {};

    local objects = levelData.layers[1].objects;
    for i in pairs(objects) do
        table.insert(entities.pickups, {x = objects[i].x, y = objects[i].y})
    end
    return entities;
end

--return table of positions
return LevelLoader;