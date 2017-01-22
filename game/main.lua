local ScriptRunner = require("src/utils/ScriptRunner");
local Script = require("src/utils/Script");
local Scene = require("src/utils/Scene");
local GameScene = require("src/GameScene");
local TitleScene = require("src/scenes/TitleScene");

gDrawPhysics = false;

gCurrentMusic = nil;
gAssets = {
	BG = {},
	CHAR = {},
	SOUND = {},
	MUSIC = {},
}


love.load = function()
	gAssets.CHAR.sparky = {
		idle = {
			frames = {
				love.graphics.newImage( "assets/sprites/sparky_base.png" ),
			},
		},
	};
	gAssets.CHAR.other = {
		idle = {
			frames = {
				love.graphics.newImage( "assets/sprites/otherfish_base.png" ),
			},
		},
	};
	
	gAssets.CHAR.bubbleA = love.graphics.newImage( "assets/sprites/bubbleA.png" );
	gAssets.CHAR.bubbleB = love.graphics.newImage( "assets/sprites/bubbleB.png" );

	gAssets.MUSIC.theme = love.audio.newSource( "assets/music/Theme.mp3" );
	gAssets.MUSIC.hidden = love.audio.newSource( "assets/music/HiddenTheme.mp3" );

	local scene = TitleScene:new();
	Scene:setCurrent(scene);
end

love.update = function(dt)
	Scene:getCurrent():update(dt);
end

love.draw = function()
	Scene:getCurrent():draw();
end

love.keypressed = function(key)
	if key == "p" then
		gDrawPhysics = not gDrawPhysics;
	end
end
