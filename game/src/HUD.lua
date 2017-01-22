require("src/utils/OOP");

local HUD = Class("HUD");

HUD.init = function(self, scene)
	assert(scene);
	self._scene = scene;
	self._timerFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 50);
	self._gameOverFont = self._timerFont;
	self._scoreFont = love.graphics.newFont("assets/fonts/smallFont.ttf", 18);
end

HUD.update = function(self, dt)
end

HUD.render = function(self)
	local timeLeft = self._scene:getTimeLeft();
	local isOver = self._scene:isOver();

	love.graphics.setColor(0, 0, 0, 180);
	love.graphics.rectangle("fill", 0, 0, 640, 80);

	if isOver then
		timeLeft = 0;
		local w = 400;
		local x = (640 - w) / 2;
		love.graphics.setColor(0, 0, 0, 180);
		love.graphics.rectangle("fill", x, 350, w, 240);
	end


	local timeLeft = math.ceil(timeLeft);
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.setFont(self._timerFont);
	love.graphics.printf(timeLeft, 0, 40, 640, "center");

	local score = self._scene:getScore();
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.setFont(self._scoreFont);
	love.graphics.printf("Score: " .. score, 40, 40, 640, "left");

	if isOver then
		love.graphics.printf("Press Space To Continue", 0, 550, 640, "center");
		love.graphics.setFont(self._gameOverFont);
		love.graphics.printf("GAME OVER", 0, 400, 640, "center");
		love.graphics.printf("Score: " .. score, 0, 450, 640, "center");
	end
end

return HUD;
