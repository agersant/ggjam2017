require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local HowToPlayScene = require("src/scenes/HowToPlayScene");

local TitleScene = Class("TitleScene", Scene);

TitleScene.init = function(self)
	TitleScene.super.init(self);
	self:setupBubbles();
	self._backgroundImg = love.graphics.newImage( "assets/sprites/ui/oceanBackground.png" );
	self._titleText = love.graphics.newImage( "assets/sprites/ui/TitleScreen_text.png" );
	self._bubbleImgs = {love.graphics.newImage("assets/sprites/bubbleA.png"), love.graphics.newImage("assets/sprites/bubbleB.png")};
	self._pressStartFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 35);
	self._promptAlpha = 1;
	self._script = Script:new(self, function(script)
		self:script(script);
	end);

	self:playMusic( gAssets.MUSIC.waves );
end

TitleScene.update = function(self, dt)
	if love.keyboard.isDown("space") then
		Scene:setCurrent(HowToPlayScene:new());
		return;
	end
	self._script:update(dt);
	self:moveBubbles(dt);
end

TitleScene.script = function(self, script)
	while true do
		script:tween(0, 1, .4, nil, function(v) self._promptAlpha = v end);
		script:tween(1, 0, .4, nil, function(v) self._promptAlpha = v end);
	end
end

TitleScene.setupBubbles = function(self)
	self._bubbles = {};
	for i = 1,10 do
		table.insert(self._bubbles,{x=0, y=-90, speed=1, img=1});
		table.insert(self._bubbles,{x=0, y=-90, speed=1, img=2});
	end  
end

TitleScene.moveBubbles = function (self, dt)
	for k, bub in pairs(self._bubbles) do
		if (bub.y <= -10) then
			bub.x = math.random(10,600)
			bub.y = math.random(700,1500)
			bub.speed = math.random(100,300)
		end
		bub.y = bub.y - bub.speed *dt;
	end
end

TitleScene.draw = function(self)
	local w, h = 400, 120;
	local x = 640/2 - w/2;
	local y = 80;

	--Background
	love.graphics.setColor(255, 255 , 255, 255);
	love.graphics.draw( self._backgroundImg );

	--Bubbles
	for k, bub in pairs(self._bubbles) do
		love.graphics.draw( self._bubbleImgs[bub.img], bub.x, bub.y );
	end

	--Title
	love.graphics.draw( self._titleText, x / 2, y, 0.02 * self._promptAlpha);

	--Start Text
	love.graphics.setFont(self._pressStartFont);
	love.graphics.setColor(255, 255, 255, 255 * self._promptAlpha);
	love.graphics.printf("Press Space To Start", 0, 500, 640, "center");
end

return TitleScene;
