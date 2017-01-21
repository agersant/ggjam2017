require("src/utils/OOP");

local HUD = Class("HUD");

HUD.init = function(self, scene)
	assert(scene);
	self._scene = scene;
	self._timerFont = love.graphics.newFont("assets/fonts/timerFont.ttf", 50);
end

HUD.update = function(self, dt)
end

HUD.render = function(self)
	local timeLeft = math.ceil( self._scene:getTimeLeft() );
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.setFont(self._timerFont);
	love.graphics.printf(timeLeft, 0, 40, 640, "center");
end

return HUD;
