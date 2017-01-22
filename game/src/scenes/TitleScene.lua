require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local HowToPlayScene = require("src/scenes/HowToPlayScene");
local AmbientBubbles = require("src/AmbientBubbles");
local TitleScene = Class("TitleScene", Scene);

TitleScene.init = function(self)
	TitleScene.super.init(self);
	AmbientBubbles:init();
	self._backgroundImg = love.graphics.newImage( "assets/sprites/ui/oceanBackground.png" );
	self._titleText = love.graphics.newImage( "assets/sprites/ui/TitleScreen_text.png" );
	self._pressStartFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 35);
	self._promptAlpha = 1;
	self._script = Script:new(self, function(script)
		self:script(script);
	end);
	self:playMusic( gAssets.MUSIC.waves );
end

TitleScene.update = function(self, dt)
	self._script:update(dt);
	AmbientBubbles:moveBubbles(dt);
end

TitleScene.script = function(self, script)
	script:thread(function()
		while true do
			script:tween(0, 1, .4, nil, function(v) self._promptAlpha = v end);
			script:tween(1, 0, .4, nil, function(v) self._promptAlpha = v end);
		end
	end);

	script:thread(function()
		while true do
			script:tween(70, 80, 1.5, nil, function(v) self._titleY = v end);
			script:tween(80, 70, 1.5, nil, function(v) self._titleY = v end);
		end
	end);
	
	script:wait(.1);
	script:waitForInput("space");
	Scene:setCurrent(HowToPlayScene:new());
end

TitleScene.draw = function(self)
	local w, h = 400, 120;
	local x = 640/2 - w/2;
	local y = 80;

	--Background
	love.graphics.setColor(255, 255 , 255, 255);
	love.graphics.draw( self._backgroundImg );

	--Bubbles
	AmbientBubbles:draw();

	--Title
	love.graphics.draw( self._titleText, x / 2, self._titleY );

	--Start Text
	love.graphics.setFont(self._pressStartFont);
	love.graphics.setColor(255, 255, 255, 255 * self._promptAlpha);
	love.graphics.printf("Press Space To Start", 0, 500, 640, "center");
end

return TitleScene;
