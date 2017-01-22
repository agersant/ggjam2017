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
	ITEMS = {},
}


love.load = function()
	math.randomseed(os.time());
	Leaderboard:init();
	gAssets.CHAR.sparky = {
		idle = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_000.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_001.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_002.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_003.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_004.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_005.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_006.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_007.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_008.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_009.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_010.png" ),
				love.graphics.newImage( "assets/sprites/fishB/idle/sparky_sparky_idle_011.png" ),
			},
		},
		swim = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_000.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_001.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_002.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_003.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_004.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_005.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_006.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_007.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_008.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_009.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_010.png" ),
				love.graphics.newImage( "assets/sprites/fishB/swimming/sparky_sparky_swimming_011.png" ),
			},
		},
		puff = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishB/puff/puff.png" ),
			},
		},
	};
	gAssets.CHAR.other = {
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
		puff = {
			frames = {
				love.graphics.newImage( "assets/sprites/fishA/puff/puff.png" ),
			},
		},
	};
	
	gAssets.CHAR.bubbleA = love.graphics.newImage( "assets/sprites/bubbleA.png" );
	gAssets.CHAR.bubbleB = love.graphics.newImage( "assets/sprites/bubbleB.png" );

	gAssets.MUSIC.theme = love.audio.newSource( "assets/music/Theme.mp3" );
	gAssets.MUSIC.hidden = love.audio.newSource( "assets/music/HiddenTheme.mp3" );
	gAssets.MUSIC.waves = love.audio.newSource( "assets/music/waves.ogg" );
	gAssets.MUSIC.hurryUp = love.audio.newSource( "assets/music/HurryUp.mp3" );

	gAssets.SOUND.pickup = love.audio.newSource( "assets/sfx/pickup.ogg" );
	gAssets.SOUND.pickup:setVolume( 0.3 );
	gAssets.SOUND.bonk = love.audio.newSource( "assets/sfx/bonk.ogg" );
	gAssets.SOUND.bonk:setVolume( 0.4 );
	gAssets.SOUND.bub1 = love.audio.newSource( "assets/sfx/bub1.mp3" );
	gAssets.SOUND.bub2 = love.audio.newSource( "assets/sfx/bub2.mp3" );
	gAssets.SOUND.bub3 = love.audio.newSource( "assets/sfx/bub3.mp3" );
	gAssets.SOUND.bub4 = love.audio.newSource( "assets/sfx/bub4.mp3" );
	gAssets.SOUND.bub5 = love.audio.newSource( "assets/sfx/bub5.mp3" );
	gAssets.SOUND.secretBub1 = love.audio.newSource( "assets/sfx/secretBub1.mp3" );
	gAssets.SOUND.secretBub2 = love.audio.newSource( "assets/sfx/secretBub2.mp3" );
	gAssets.SOUND.secretBub3 = love.audio.newSource( "assets/sfx/secretBub3.mp3" );
	gAssets.SOUND.secretBub4 = love.audio.newSource( "assets/sfx/secretBub4.mp3" );
	gAssets.SOUND.secretBub5 = love.audio.newSource( "assets/sfx/secretBub5.mp3" );

	gAssets.BG.game = love.graphics.newImage("assets/backgrounds/playspace_bg.png")
	gAssets.BG.kelp = love.graphics.newImage("assets/backgrounds/kelp.png")
	gAssets.ITEMS.bumper = love.graphics.newImage("assets/sprites/bouncer.png");
	gAssets.ITEMS.waterSurface = {
		love.graphics.newImage("assets/sprites/waterSurface/waterSurface1.png"),
		love.graphics.newImage("assets/sprites/waterSurface/waterSurface2.png"),
		love.graphics.newImage("assets/sprites/waterSurface/waterSurface3.png"),
		love.graphics.newImage("assets/sprites/waterSurface/waterSurface4.png"),
	};

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
