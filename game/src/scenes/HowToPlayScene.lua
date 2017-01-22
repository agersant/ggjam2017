require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local GameScene = require("src/GameScene");
local AmbientBubbles = require("src/AmbientBubbles");

local HowToPlayScene = Class("HowToPlayScene", Scene);

HowToPlayScene.init = function(self)
	HowToPlayScene.super.init(self);
	AmbientBubbles:init();
	self._titleFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 55);
	self._bodyFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 35);
	self._backgroundImg = love.graphics.newImage( "assets/sprites/ui/oceanBackground.png" );
	self._sparkyImg = love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_000.png" );
	self._otherFishImg = love.graphics.newImage( "assets/sprites/fishA/idle/other_fish_otherfish_idle_000.png" );
	self._script = Script:new(self, function(script)
		script:wait(.1);
		script:waitForInput("space");
		Scene:setCurrent(GameScene:new());
	end);
end

HowToPlayScene.update = function(self, dt)
	self._script:update(dt);
	AmbientBubbles:moveBubbles(dt);
end

HowToPlayScene.draw = function(self)
	local w, h = 640, 720;
	local x = 0;
	local y = 0;
	love.graphics.setColor(255, 255 , 255, 255);
	love.graphics.draw(self._backgroundImg);
	
	AmbientBubbles:draw();

	--Icont next to instructions
	love.graphics.draw( self._sparkyImg, 0, 190 );
	love.graphics.draw( AmbientBubbles._bubbleImgs[1], 95, 252 );
	love.graphics.draw( self._otherFishImg, 0, 318 );
	love.graphics.draw( AmbientBubbles._bubbleImgs[2], 95, 380 );

	love.graphics.setColor(240, 228, 199, 255);
	love.graphics.setFont(self._titleFont);
	love.graphics.printf("HOW TO PLAY", 0, 104, 640, "center");

	love.graphics.setFont(self._bodyFont);
	love.graphics.printf("Sparky: Use arrow keys to collect red bubbles.", 128, 218, 500, "left");
	love.graphics.printf("Other Fish: Use WASD keys to collect green bubbles.", 128, 346, 500, "left");
	love.graphics.printf("Both: Avoid Goobers! Collect as many bubbles as you can before the time runs out. Collecting bubbles will give you a small time bonus.", 128, 474, 500, "left");
end

return HowToPlayScene;
