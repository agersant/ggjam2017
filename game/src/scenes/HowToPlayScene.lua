require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local GameScene = require("src/GameScene");

local HowToPlayScene = Class("HowToPlayScene", Scene);

HowToPlayScene.init = function(self)
	HowToPlayScene.super.init(self);
end

HowToPlayScene.update = function(self, dt)
	if love.keyboard.isDown("space") then
		Scene:setCurrent(GameScene:new());
		return;
	end
end

HowToPlayScene.draw = function(self)
	local w, h = 640, 720;
	local x = 0;
	local y = 0;
	love.graphics.setColor(0, 255 , 0, 255);
	love.graphics.rectangle("fill", x, y, w, h);
	
	love.graphics.setColor(0, 0 , 0, 255);
	love.graphics.printf("HOW TO PLAY", 0, 500, 640, "center");
end

return HowToPlayScene;
