require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");

local Fish = Class("Fish", Entity);


Fish.init = function(self, scene)
	Fish.super.init(self, scene);
	self._speed = 60;

	self._body = love.physics.newBody( self._scene:getPhysicsWorld(), 0, 0, "dynamic" );
	self._body:setPosition(100, 100);
end


Fish.update = function(self, dt)

	local ys = 0;
	if love.keyboard.isDown("up") then
		ys = -1;
	end
	if love.keyboard.isDown("down") then
		ys = 1;
	end
	
	local xs = 0;
	if love.keyboard.isDown("left") then
		xs = -1; 
	end
	if love.keyboard.isDown("right") then
		xs = 1;
	end

	self._body:setLinearVelocity(xs * self._speed, ys * self._speed);
end

Fish.render = function(self)
	local x, y = self._body:getPosition();
	love.graphics.setColor( 255, 0, 0, 255 );
	love.graphics.rectangle("fill", x, y, 10, 10 );
end

return Fish;
