local ScriptRunner = require("src/utils/ScriptRunner");
local Script = require("src/utils/Script");
local Scene = require("src/utils/Scene");
local GameScene = require("src/GameScene");


love.load = function()
	local scene = GameScene:new();
	Scene:setCurrent(scene);
end

love.update = function(dt)
	Scene:getCurrent():update(dt);
end