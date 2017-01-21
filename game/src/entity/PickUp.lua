require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Fish = require("src/entity/Fish");

local PickUp = Class("PickUp", Entity);


PickUp.init = function(self, scene, entityData)
	PickUp.super.init(self, scene);
	self._chunk = entityData.chunk;
	self._ent = entityData.ent; -- use this for sorting the pickup order
	self._x = entityData.x;
	self._y = entityData.y;

	local physicsRadius = 20;
	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), 0, 0, "dynamic");
	self._body:setPosition(self._x, self._y);
	self._body:setUserData(self);
	self._shape = love.physics.newCircleShape(physicsRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setSensor(true);

end

PickUp.render = function(self)
	love.graphics.setColor( 0, 255, 0, 255 );
	love.graphics.rectangle("fill", self._x, self._y, 5, 5 );
end

PickUp.collideWith = function(self, object)
	if object:isInstanceOf(Fish) then
		self:despawn();
	end
end

return PickUp;
