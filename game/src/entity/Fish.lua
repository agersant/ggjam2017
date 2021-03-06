require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Fish = Class("Fish", Entity);
package.loaded["src/entity/Fish"] = Fish;

local Debug = require("src/Debug");
local Script = require("src/utils/Script");
local LevelLoader = require("src/LevelLoader");
local AnimatedSprite = require("src/gfx/AnimatedSprite");
local PickUp = require("src/entity/PickUp");
local Bumper = require("src/entity/Bumper");
local BubbleFart = require("src/entity/BubbleFart");
local AmbientBubbles = require("src/AmbientBubbles");

Fish.sparky = {
	findex = 1,
	left = "left",
	right = "right",
	up = "up",
	spawnLocation = { x = 400, y = 40 },
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
	self._puffForce = 100;
	self._angularForce = 3300;
	self._puffAngularForce = 1700;
	self._foresight = 2;
	self._levelsLoaded = 0; 
	self._player = options.player;
	self._bodyRadius = 20;
	self._fishBounce = 250;
	self._isNearTop = true;

	self:addScriptRunner();
	self:addScript(Script:new(self, function(script)
		self:script(script);
	end));

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._player.spawnLocation.x, self._player.spawnLocation.y);
	self._body:setLinearDamping(2.2);
	self._body:setAngularDamping(2.5);
	self._body:setUserData(self);

	self._shape = love.physics.newCircleShape(self._bodyRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setCategory(Entity.PHYSICS_TAG.FISH);
	self._fixture:setRestitution(.9);
	self._body:setMass( 0.4 );

	local spriteData = self._player.findex == Fish.sparky.findex and gAssets.CHAR.sparky or gAssets.CHAR.other;
	self:addSprite(AnimatedSprite:new(spriteData));
	self:playAnimation("idle");
	self._waterSprite = AnimatedSprite:new(gAssets.ITEMS.waterSurface);
	self._waterSprite:playAnimation("idle");

	self._upcomingPickUps = {};
	self._levelLengths = {};
	for i = 1, self._foresight do
		self:spawnNextPickUp(i);
	end
end

Fish.script = function(self, script)
	script:thread(function(script)
		while true do
			script:waitFor("puff");
			script:thread(function(script)
				script:endOn("puff");
				self._puffed = true;
				script:wait(1);
				self._puffed = false;
			end);
		end
	end);

	script:thread(function(script)
		while true do
			script:wait(math.random(1, 5)/15);
			if self._pressingAnything then
				local scene = self:getScene();
				local x, y = self._body:getPosition();
				local a = self._body:getAngle();
				local px = x + 60 * math.cos(a);
				local py = y + 60 * math.sin(a);
				scene:spawn(BubbleFart, {x = px, y = py });
			end
		end
	end);
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
	local levelToLoad;
	if self._levelsLoaded < 3 then
		levelToLoad = self._levelsLoaded + 1;
	else
		repeat
			levelToLoad = math.random(1, gNumLevels);
		until levelToLoad ~= self._previousLevel;
	end
	local levelName = "level" .. levelToLoad .. "-" .. self._player.findex;
	local levelData = LevelLoader:loadLevel(levelName);
	for i, pickup in ipairs(levelData.pickups) do
		table.insert(self._upcomingPickUps, pickup);
	end
	table.insert(self._levelLengths, #levelData.pickups);
	self._levelsLoaded = self._levelsLoaded + 1;
	self._previousLevel = levelToLoad;
end

Fish.update = function(self, dt)

	Fish.super.update(self, dt);
	self._waterSprite:update(dt);

	local pressingLeft = love.keyboard.isDown(self._player.left);
	local pressingRight = love.keyboard.isDown(self._player.right);
	local pressingForward = love.keyboard.isDown(self._player.up);
	self._pressingAnything = pressingLeft or pressingRight or pressingForward;

	if not self:getScene():isOver() then
		local angularForce = self._puffed and self._puffAngularForce or self._angularForce;
		local force = self._puffed and self._puffForce or self._force;
		local xs = 0;
		if pressingLeft then
			xs = -1; 
		end
		if pressingRight then
			xs = 1;
		end
		self._body:applyAngularImpulse(xs * dt * angularForce);

		local angle = self._body:getAngle();
		if pressingForward then
			self._body:applyLinearImpulse(force * math.cos(angle) * dt, force * math.sin(angle) * dt);
		end
	end

	if self._puffed then
		self:playAnimation("puff");
	elseif self._pressingAnything then
		self:playAnimation("swim");
	else
		self:playAnimation("idle");
	end

	self._isNearTop = self._body:getY() <= 35;
end

Fish.render = function(self)
	local x, y = self._body:getPosition();
	local angle = self._body:getAngle();

	love.graphics.push();

	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.translate(x, y);

	love.graphics.push()
	love.graphics.rotate(angle);
	self._sprite:render(0, -5);
	love.graphics.pop();

	if self._isNearTop then
		self._waterSprite:render(0, -5);
	end

	love.graphics.pop();
	

	if gDrawPhysics then
		Debug.drawCircleShape(self._body, self._shape);
	end
end

Fish.collideWith = function(self, object, contact)
	local isFish = object:isInstanceOf(Fish);
	local isBumper = object:isInstanceOf(Bumper);

	if isFish or isBumper then
		love.audio.stop( gAssets.SOUND.bonk );
		love.audio.play( gAssets.SOUND.bonk );
		self:signal("puff");
	end

	if isFish then
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
