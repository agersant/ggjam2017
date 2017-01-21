require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");
local TimeNotify = Class("TimeNotify", Entity);


TimeNotify.init = function(self, scene, options)
	TimeNotify.super.init(self, scene);
	self._displayText = "+" .. options.time;
	self._x, self._y = options.source:getPosition();
	self._alpha = 1;
	if not TimeNotify._font then
		TimeNotify._font = love.graphics.newFont("assets/fonts/smallFont.ttf", 24);
	end

	self:addScriptRunner();

	local script = Script:new(self, function(self)
		local entity = self:getEntity();

		-- Blink
		for i = 1, 10 do
			self:wait(.05);
			entity._alpha = i%2 == 0 and 1 or 0;
		end
		entity._alpha = 1;
		self:wait(2);

		-- Fade
		self:tween(1, 0, .5, nil, function(v)
			entity._alpha = v;
		end );

		entity:despawn();
	end);
	self:addScript(script);
end

TimeNotify.render = function(self)
	love.graphics.setFont(TimeNotify._font);
	love.graphics.setColor(255, 255, 255, 255 * self._alpha);
	love.graphics.printf(self._displayText, self._x, self._y, 560, "left" );
end

return TimeNotify;
