require("src/utils/OOP");
local Entity = require("src/utils/Entity");

local PickUp = Class("PickUp", Entity);


PickUp.init = function(self, scene, position)
	PickUp.super.init(self, scene);
	self._x = position.x;
	self._y = position.y;
end

PickUp.render = function(self)
	love.graphics.setColor( 0, 255, 0, 255 );
	love.graphics.rectangle("fill", self._x, self._y, 5, 5 );
end

return PickUp;
