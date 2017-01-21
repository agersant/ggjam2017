require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");

local Fish = Class("Fish", Entity);


Fish.init = function(self, scene)
	Fish.super.init(self, scene);
	self._speed = 0.5;
	self._angularSpeed = 4;
	self._length = 35;

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(100, 100);
	self._body:setLinearDamping(2.2);

	self._shape = love.physics.newCircleShape(10);
	self._fixture = love.physics.newFixture(self._body, self._shape);
end


Fish.update = function(self, dt)

	local xs = 0;
	if love.keyboard.isDown("left") then
		xs = -1; 
	end
	if love.keyboard.isDown("right") then
		xs = 1;
	end
	self._body:setAngularVelocity(xs * self._angularSpeed)

	local angle = self._body:getAngle();
	if love.keyboard.isDown("up") then
		self._body:applyLinearImpulse(self._speed * math.cos(angle), self._speed * math.sin(angle));
	end
end

Fish.render = function(self)
	local x, y = self._body:getPosition();
	local angle = self._body:getAngle();
	local halfLength = self._length / 2;
	love.graphics.push()
	love.graphics.translate(x, y);
	love.graphics.rotate(angle);

	love.graphics.setColor(255, 0, 0, 255);
	love.graphics.rectangle("fill", -halfLength, -halfLength, self._length, self._length);
	love.graphics.pop();
end

return Fish;
