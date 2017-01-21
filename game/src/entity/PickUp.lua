require("src/utils/OOP");
local Debug = require("src/Debug");
local Entity = require("src/utils/Entity");
local Fish = require("src/entity/Fish");
local TimeNotify = require("src/entity/TimeNotify");

local PickUp = Class("PickUp", Entity);


PickUp.init = function(self, scene, entityData)
	PickUp.super.init(self, scene);
	self._fish = nil;
	self._grabbable = false;
	self._ent = entityData.ent; -- use this for sorting the pickup order
	self._x = entityData.x;
	self._y = entityData.y;
end

PickUp.addedToScene = function(self)
	local physicsRadius = 20;
	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._x, self._y);
	self._body:setUserData(self);
	self._shape = love.physics.newCircleShape(physicsRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setSensor(true);
end

PickUp.getPosition = function(self)
	return self._body:getPosition();
end

PickUp.render = function(self)
	self._grabbable = self._ent == self._fish._lastPickupEnt + 1; -- This should be in an update function
	love.graphics.setColor( 0, 255, 0, (self._grabbable and 255 or 63) );
	love.graphics.rectangle("fill", self._x, self._y, 5, 5 );
	if gDrawPhysics then
		Debug.drawCircleShape(self._body, self._shape);
	end
end

PickUp.collideWith = function(self, object)
	if self._fish == object and self._grabbable then
		object:pickedUpItem(self);
		self:grantTime();
		self:despawn();
	end
end

PickUp.grantTime = function(self)
	local timeEarned = 2;
	local scene = self:getScene();
	scene:giveExtraTime(timeEarned);
	scene:spawn(TimeNotify, {time = timeEarned, source = self});
end

return PickUp;
