require("src/utils/OOP");
local Debug = require("src/Debug");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");
local AmbientBubbles = require("src/AmbientBubbles");

local BubbleFart = Class("BubbleFart", Entity);


BubbleFart.init = function(self, scene, options)
	BubbleFart.super.init(self, scene);
	assert(options.x);
	assert(options.y);
	self._x = options.x;
	self._y = options.y;
	local rate = options.emissionRate or 5;

	self._swimParticles = love.graphics.newParticleSystem( AmbientBubbles._bubbleImgs[3], 32 );
	self._swimParticles:setParticleLifetime(2, 5); -- Particles live at least 2s and at most 5s.
	self._swimParticles:setEmissionRate(3);
	self._swimParticles:setSizes(1, .2);
	self._swimParticles:setSizeVariation(0.2);
	self._swimParticles:setAreaSpread("uniform", 10, 10);
	self._swimParticles:setLinearAcceleration(-10, -20, 10, -4); -- Random movement in all directions.
	self._swimParticles:setColors(255, 255, 255, 255, 255, 255, 255, 0); -- Fade to transparency.

	self._script = Script:new(self, function(script)
		script:wait(1);
		self._swimParticles:setEmissionRate(0);
		script:wait(5);
		self:despawn();
	end);
end

BubbleFart.render = function(self)
	love.graphics.setColor(255, 255, 255, 200);
	love.graphics.draw(self._swimParticles, self._x, self._y);
end

BubbleFart.update = function(self, dt)
	self._script:update(dt)
	self._swimParticles:update(dt)
end


return BubbleFart;
