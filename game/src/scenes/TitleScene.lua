require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local HowToPlayScene = require("src/scenes/HowToPlayScene");

local TitleScene = Class("TitleScene", Scene);

TitleScene.init = function(self)
	TitleScene.super.init(self);
	self._pressStartFont = love.graphics.newFont("assets/fonts/smallFont.ttf", 24);
	self._promptAlpha = 1;
	self._script = Script:new(self, function(script)
		self:script(script);
	end);

	math.randomseed( os.time() );
	local songRandom = math.random( 1, 10 );
	if songRandom == 1 then
		self:playMusic( gAssets.MUSIC.hidden );
	else
		self:playMusic( gAssets.MUSIC.theme );
	end
end

TitleScene.update = function(self, dt)
	if love.keyboard.isDown("space") then
		Scene:setCurrent(HowToPlayScene:new());
		return;
	end
	self._script:update(dt);
end

TitleScene.script = function(self, script)
	while true do
		script:tween(0, 1, .5, nil, function(v) self._promptAlpha = v end);
		script:tween(1, 0, .5, nil, function(v) self._promptAlpha = v end);
	end
end

TitleScene.draw = function(self)
	local w, h = 400, 120;
	local x = 640/2 - w/2;
	local y = 80;
	love.graphics.setColor(255, 0 , 0, 255);
	love.graphics.rectangle("fill", x, y, w, h);

	love.graphics.setColor(255, 255, 255, 255 * self._promptAlpha);
	love.graphics.setFont(self._pressStartFont);
	love.graphics.printf("Press Space To Start", 0, 500, 640, "center");
end

return TitleScene;
