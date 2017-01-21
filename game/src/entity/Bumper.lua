require("src/utils/OOP");
local Debug = require("src/Debug");
local Entity = require("src/utils/Entity");

local Bumper = Class("Bumper", Entity);


Bumper.init = function(self, scene, options)
	Bumper.super.init(self, scene);

	local physicsRadius = 60;

	local x, y;
	local xs, ys = 0, 0;

	local dir = {"up", "down", "left", "right"};
	dir = dir[math.random(1, 4)];
	if dir == "up" or dir == "down" then
		x = math.random(0, 560);
		if dir == "up" then
			y = 600;
			ys = -1;
		else
			y = -40;
			ys = 1;
		end
	end
	if dir == "left" or dir == "right" then
		y = math.random(0, 560);
		if dir == "left" then
			x = 600;
			xs = -1;
		else
			x = -40;
			xs = 1;
		end
	end

	local speed = 100;

	self._body = love.physics.newBody(self._scene:getPhysicsWorld(), x, y, "dynamic");
	self._body:setUserData(self);
	self._body:setMass(9000);
	self._body:setLinearVelocity(xs * speed, ys * speed);

	self._shape = love.physics.newCircleShape(physicsRadius);
	self._fixture = love.physics.newFixture(self._body, self._shape);
	self._fixture:setCategory(Entity.PHYSICS_TAG.BUMPER);
	self._fixture:setMask(Entity.PHYSICS_TAG.GEO);
	self._fixture:setRestitution(10);
end

Bumper.render = function(self)
	Debug.drawCircleShape(self._body, self._shape); -- TODO Replace with art
	if gDrawPhysics then
		Debug.drawCircleShape(self._body, self._shape);
	end
end

Bumper.update = function(self)
	local x, y = self._body:getPosition();
	if math.abs(x) > 800 or math.abs(y) > 800 then
		self:despawn();
	end
end


return Bumper;
