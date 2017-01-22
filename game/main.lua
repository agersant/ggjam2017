local ScriptRunner = require("src/utils/ScriptRunner");
local Script = require("src/utils/Script");
local Scene = require("src/utils/Scene");
local GameScene = require("src/GameScene");
local TitleScene = require("src/scenes/TitleScene");
local Leaderboard = require("src/Leaderboard");

gDrawPhysics = false;
gNumLevels = 10;

gCurrentMusic = nil;
gAssets = {
	BG = {},
	CHAR = {},
	SOUND = {},
	MUSIC = {},
}


love.load = function()
	math.randomseed(os.time());
	Leaderboard:init();
	gAssets.CHAR.sparky = {
		idle = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_000.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_001.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_002.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_003.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_004.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_005.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_006.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_007.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_008.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_009.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_010.png" ),
				love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_011.png" ),
			},
		},
		swim = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_000.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_001.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_002.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_003.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_004.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_005.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_006.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_007.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_008.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_009.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_010.png" ),
				love.graphics.newImage( "assets/sprites/fishA/swimming/other_fish_otherfish_swimming_011.png" ),
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
	gAssets.MUSIC.waves = love.audio.newSource( "assets/music/waves.ogg" );
	gAssets.MUSIC.pickup = love.audio.newSource( "assets/sfx/pickup.ogg" );
	gAssets.MUSIC.bonk = love.audio.newSource( "assets/sfx/bonk.ogg" );
	gAssets.MUSIC.hurryUp = love.audio.newSource( "assets/music/HurryUp.mp3" );

	gAssets.BG.game = love.graphics.newImage("assets/backgrounds/playspace_bg.png")

	Scene:setCurrent(TitleScene:new());
end

love.update = function(dt)
	Scene:getCurrent():update(dt);
end

love.draw = function()
	Scene:getCurrent():draw();
end

love.keypressed = function(key)
	if key == "p" and not love.filesystem.isFused() then
		gDrawPhysics = not gDrawPhysics;
	elseif key == "escape" then
		Scene:setCurrent(TitleScene:new());
	end

	Scene:getCurrent():handleKeyPress(key);
end
