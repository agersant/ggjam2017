local ScriptRunner = require("src/utils/ScriptRunner");
local Script = require("src/utils/Script");
local Scene = require("src/utils/Scene");
local GameScene = require("src/GameScene");

gAssets = {
	BG = {},
	CHAR = {},
	SOUND = {},
	MUSIC = {},
}

love.load = function()
	local scene = GameScene:new();
	Scene:setCurrent(scene);
	gAssets.CHAR.sparky = love.graphics.newImage( "assets/sprites/sparky_base.png" );
end

love.update = function(dt)
	Scene:getCurrent():update(dt);
end

love.draw= function()
	Scene:getCurrent():draw();
end
