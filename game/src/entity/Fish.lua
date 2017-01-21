require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");

local Fish = Class("Fish", Entity);


Fish.init = function(self, scene)
	Fish.super.init(self, scene);
	self._x = 100;
	self._y = 100;
	self._speed = 60;
end


Fish.update = function(self, dt)

	local ys = 0;
	if love.keyboard.isDown("up") then
		ys = -1;
	end
	if love.keyboard.isDown("down") then
		ys = 1;
	end
	self._y = self._y + dt * ys * self._speed;
	
	local xs = 0;
	if love.keyboard.isDown("left") then
		xs = -1; 
	end
	if love.keyboard.isDown("right") then
		xs = 1;
	end
	self._x = self._x + dt * xs * self._speed;

end

Fish.render = function(self)
	love.graphics.setColor( 255, 0, 0, 255 );
	love.graphics.rectangle("fill", self._x, self._y, 10, 10 );
end

return Fish;
