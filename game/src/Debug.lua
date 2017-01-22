local Debug = {};

Debug.drawCircleShape = function(body, shape)

	local r = shape:getRadius();
	local ox, oy = shape:getPoint();
	local bx, by = body:getPosition();
	local x, y = bx + ox, by + oy;

	love.graphics.setColor(255, 255, 0, 150);
	love.graphics.circle("fill", x, y, r);
end

Debug.drawRectangleShape = function(body, width, height)
	local x, y = body:getPosition();
	local angle = body:getAngle();
	love.graphics.push()
	love.graphics.translate(x, y);
	love.graphics.rotate(angle);

	love.graphics.setColor(255, 255, 0, 150);
	love.graphics.rectangle("fill", -width / 2, -height / 2, width, height);
	love.graphics.pop();	
end

return Debug;
