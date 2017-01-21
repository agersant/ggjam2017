local Debug = {};

Debug.drawCircleShape = function(body, shape)

	local r = shape:getRadius();
	local ox, oy = shape:getPoint();
	local bx, by = body:getPosition();
	local x, y = bx + ox, by + oy;

	love.graphics.setColor(255, 255, 0, 150);
	love.graphics.circle("fill", x, y, r);
end

return Debug;
