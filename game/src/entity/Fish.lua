require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");

local Fish = Class("Fish", Entity);
Fish.sparky = {
	findex = 1,
	left = "left",
	right = "right",
	up = "up",
	spawnLocation = { x = 100, y = 100 },
}
Fish.other = {
	findex = 2,
	left = "a",
	right = "d",
	up = "w",
	spawnLocation = { x = 50, y = 300 },
}

Fish.init = function(self, scene, options)
	Fish.super.init(self, scene);
	self._force = 250;
	self._angularSpeed = 4;
	self._length = 35;
	self._player = options.player;

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._player.spawnLocation.x, self._player.spawnLocation.y);
	self._body:setLinearDamping(2.2);
	self._body:setUserData(self);

	self._shape = love.physics.newCircleShape(10);
	self._fixture = love.physics.newFixture(self._body, self._shape);
end


Fish.update = function(self, dt)
	local xs = 0;
	if love.keyboard.isDown(self._player.left) then
		xs = -1; 
	end
	if love.keyboard.isDown(self._player.right) then
		xs = 1;
	end
	self._body:setAngularVelocity(xs * self._angularSpeed);

	local angle = self._body:getAngle();
	if love.keyboard.isDown(self._player.up) then
		self._body:applyLinearImpulse(self._force * math.cos(angle) * dt, self._force * math.sin(angle) * dt);
	end
end

Fish.render = function(self)
	local x, y = self._body:getPosition();
	local angle = self._body:getAngle();
	local halfLength = self._length / 2;
	love.graphics.push()
	love.graphics.translate(x, y);
	love.graphics.rotate(angle);

	local image = self._player.findex == Fish.sparky.findex and gAssets.CHAR.sparky or gAssets.CHAR.other;
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.draw(image, -halfLength, -halfLength);
	love.graphics.pop();
end

return Fish;
