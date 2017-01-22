require("src/utils/OOP");
local Debug = require("src/Debug");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");
local AnimatedSprite = require("src/gfx/AnimatedSprite");

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
	self._foresight = 3;
	self._currentLevel = 1;
	self._currentLevelPickups = 0;
	self._lastPickupEnt = 0;
	self._totalPickups = 0;
	self._angularSpeed = 4;
	self._player = options.player;
	self._bodyRadius = 10;

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._player.spawnLocation.x, self._player.spawnLocation.y);
	self._body:setLinearDamping(2.2);
	self._body:setUserData(self);

	self._shape = love.physics.newCircleShape(self._bodyRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setCategory(Entity.PHYSICS_TAG.FISH);
	self._fixture:setRestitution(.9);

	local spriteData = self._player.findex == Fish.sparky.findex and gAssets.CHAR.sparky or gAssets.CHAR.other;
	self:addSprite(AnimatedSprite:new(spriteData));
	self:playAnimation("idle");
end


Fish.update = function(self, dt)

	Fish.super.update(self, dt);

	if self:getScene():isOver() then
		return;
	end

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
	love.graphics.push()
	love.graphics.translate(x, y);
	love.graphics.rotate(angle);

	love.graphics.setColor(255, 255, 255, 255);
	self._sprite:render(0, -8);
	love.graphics.pop();

	if gDrawPhysics then
		Debug.drawCircleShape(self._body, self._shape);
	end
end

Fish.collideWith = function(self, object, contact)
	if object:isInstanceOf(Fish) then
		local nx, ny = contact:getNormal();
		local fixtureA, fixtureB = contact:getFixtures();
		if fixtureB == self._fixture then
			nx = -nx;
			ny = -ny;
		end
		local bounce = 500;
		self._body:applyLinearImpulse(nx * bounce, ny * bounce);
	end
end

Fish.pickedUpItem = function(self, pickup)
	-- TODO: Check the pickups in order, not just count
	self._lastPickupEnt = pickup._ent;
	print(self._lastPickupEnt, self._currentLevelPickups);
	if(self._lastPickupEnt + self._foresight > self._currentLevelPickups) then
		self._currentLevel = self._currentLevel + 1;
		if (self._lastPickupEnt >= self._currentLevelPickups) then
			self._lastPickupEnt = 0;
		end
	end
	local level = "level"..self._currentLevel.."-"..self._player.findex;
	self:getScene():spawnPickup(level, self, self._lastPickupEnt + self._foresight);
end

Fish.getBubbleSprite = function(self)
	if self._player.findex == Fish.sparky.findex then
		return gAssets.CHAR.bubbleA;
	else
		return gAssets.CHAR.bubbleB;
	end
end

return Fish;
