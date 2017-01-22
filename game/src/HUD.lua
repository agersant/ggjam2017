require("src/utils/OOP");

local HUD = Class("HUD");

HUD.init = function(self, scene)
	assert(scene);
	self._scene = scene;
	self._timerFont = love.graphics.newFont("assets/fonts/timerFont.ttf", 50);
	self._gameOverFont = self._timerFont;
end

HUD.update = function(self, dt)
end

HUD.render = function(self)
	local timeLeft = self._scene:getTimeLeft();
	if self._scene:isOver() then
		timeLeft = 0;
		love.graphics.setColor(0, 0, 0, 180);
		love.graphics.rectangle("fill", 40, 120, 560, 560);
	end


	local timeLeft = math.ceil(timeLeft);
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.setFont(self._timerFont);
	love.graphics.printf(timeLeft, 0, 40, 640, "center");

	if self._scene:isOver() then
		love.graphics.setFont(self._gameOverFont);
		love.graphics.printf("GAME OVER", 0, 400, 640, "center");
	end
end

return HUD;
