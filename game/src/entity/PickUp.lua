require("src/utils/OOP");
local Debug = require("src/Debug");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");
local Fish = require("src/entity/Fish");
local TimeNotify = require("src/entity/TimeNotify");

local PickUp = Class("PickUp", Entity);


PickUp.init = function(self, scene, entityData)
	PickUp.super.init(self, scene);
	self._fish = nil;
	self._grabbable = false;
	self._fish = entityData.fish;
	assert(self._fish);

	self._pickupData = entityData.props;
	self._ent = entityData.props.ent; -- use this for sorting the pickup order
	self._xRef = entityData.props.x;
	self._yRef = entityData.props.y;

	self._image = self._fish:getBubbleSprite();
	assert(self._image);

end

PickUp.addedToScene = function(self)
	local physicsRadius = 20;
	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), self._xRef, self._yRef, "dynamic");
	self._body:setUserData(self);
	self._body:setLinearVelocity(0, math.random(-20, 20));
	self._shape = love.physics.newCircleShape(physicsRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setSensor(true);
end

PickUp.getPosition = function(self)
	return self._body:getPosition();
end

PickUp.update = function(self, dt)

	PickUp.super.update(self, dt);

	local x, y = self._body:getPosition();
	if y > self._yRef + 8 then
		self._body:applyLinearImpulse(0, dt * -100);
	elseif y < self._yRef - 8 then
		self._body:applyLinearImpulse(0, dt * 100);
	end  

	self._grabbable = self._pickupData == self._fish:getNextPickUp();
end

PickUp.render = function(self)
	love.graphics.setColor( 255, 255, 255, (self._grabbable and 255 or 63) );
	local w, h = self._image:getDimensions();
	local x, y = self._body:getPosition();
	love.graphics.draw(self._image, x - w/2, y - h/2);
	if gDrawPhysics then
		Debug.drawCircleShape(self._body, self._shape);
	end
end

PickUp.collideWith = function(self, object)
	if self:getScene():isOver() then
		return;
	end
	if self._fish == object and self._grabbable then
		object:pickedUpItem(self);
	end
end

local getNewSound = function()
	local randomSound = math.random( 1,56 );
	if randomSound >= 1 and randomSound <= 10 then
		return gAssets.SOUND.bub1;
	elseif randomSound >= 11 and randomSound <= 20 then
		return gAssets.SOUND.bub2;
	elseif randomSound >= 11 and randomSound <= 30 then
		return gAssets.SOUND.bub3;
	elseif randomSound >= 11 and randomSound <= 40 then
		return gAssets.SOUND.bub4;
	elseif randomSound >= 11 and randomSound <= 50 then
		return gAssets.SOUND.bub5;
	elseif randomSound == 51 then
		return gAssets.SOUND.secretBub1;
	elseif randomSound == 52 then
		return gAssets.SOUND.secretBub2;
	elseif randomSound == 53 then
		return gAssets.SOUND.secretBub3;
	elseif randomSound == 54 then
		return gAssets.SOUND.secretBub4;
	elseif randomSound == 55 then
		return gAssets.SOUND.secretBub5;
	else
		return gAssets.SOUND.pickup;
	end
end

PickUp.pickup = function(self, wasFinal)
	if self._currentSound then
		love.audio.stop( self._currentSound );
	end
	self._currentSound = getNewSound();
	love.audio.play( self._currentSound );
	local timeEarned = wasFinal and 5 or 1;
	local scene = self:getScene();
	scene:giveExtraTime(timeEarned);
	scene:spawn(TimeNotify, {time = timeEarned, source = self});
	self:despawn();
end

return PickUp;
