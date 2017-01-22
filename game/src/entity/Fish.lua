require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Fish = Class("Fish", Entity);
package.loaded["src/entity/Fish"] = Fish;

local Debug = require("src/Debug");
local Script = require("src/utils/Script");
local LevelLoader = require("src/LevelLoader");
local AnimatedSprite = require("src/gfx/AnimatedSprite");
local PickUp = require("src/entity/PickUp");

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
	self._force = 225;
	self._angularForce = 245;
	self._foresight = 3;
	self._currentLevel = 0;
	self._player = options.player;
	self._bodyRadius = 10;
	self._fishBounce = 250;

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._player.spawnLocation.x, self._player.spawnLocation.y);
	self._body:setLinearDamping(2.2);
	self._body:setAngularDamping(2.5);
	self._body:setUserData(self);

	self._shape = love.physics.newCircleShape(self._bodyRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setCategory(Entity.PHYSICS_TAG.FISH);
	self._fixture:setRestitution(.9);

	local spriteData = self._player.findex == Fish.sparky.findex and gAssets.CHAR.sparky or gAssets.CHAR.other;
	self:addSprite(AnimatedSprite:new(spriteData));
	self:playAnimation("idle");

	self._upcomingPickUps = {};
	self._levelLengths = {};
	for i = 1, self._foresight do
		self:spawnNextPickUp(i);
	end
end

Fish.getNextPickUp = function(self)
	return self._upcomingPickUps[1];
end

Fish.spawnNextPickUp = function(self, pickupIndex)
	pickupIndex = pickupIndex or self._foresight;
	while #self._upcomingPickUps < pickupIndex do
		self:loadNextLevel();
	end
	local pickupData = self._upcomingPickUps[pickupIndex];
	assert(pickupData);
	self:getScene():spawn(PickUp, {
		props = pickupData,
		fish = self,
	});
end

Fish.loadNextLevel = function(self)
	self._currentLevel = self._currentLevel + 1;
	local levelName = "level" .. self._currentLevel .. "-" .. self._player.findex;
	local levelData = LevelLoader:loadLevel(levelName);
	for i, pickup in ipairs(levelData.pickups) do
		table.insert(self._upcomingPickUps, pickup);
	end
	table.insert(self._levelLengths, #levelData.pickups);
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
	self._body:applyAngularImpulse(xs * dt * self._angularForce);

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
		self._body:applyLinearImpulse(nx * self._fishBounce, ny * self._fishBounce);
	end
end

Fish.pickedUpItem = function(self, pickup)
	table.remove(self._upcomingPickUps, 1);
	assert(self._levelLengths[1] > 0);
	if self._levelLengths[1] == 1 then
		table.remove(self._levelLengths, 1);
		pickup:pickup(true);
	else
		self._levelLengths[1] = self._levelLengths[1] - 1;
		pickup:pickup(false);
	end
	self:spawnNextPickUp();
end

Fish.getBubbleSprite = function(self)
	if self._player.findex == Fish.sparky.findex then
		return gAssets.CHAR.bubbleA;
	else
		return gAssets.CHAR.bubbleB;
	end
end

return Fish;
