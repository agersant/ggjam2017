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

DEBUG_MODE = false;

love.load = function()
	gAssets.CHAR.sparky = love.graphics.newImage( "assets/sprites/sparky_base.png" );
	gAssets.CHAR.other = love.graphics.newImage( "assets/sprites/otherfish_base.png" );
	local scene = GameScene:new();
	Scene:setCurrent(scene);
end

love.update = function(dt)
	Scene:getCurrent():update(dt);
end

love.draw= function()
	Scene:getCurrent():draw();
end
