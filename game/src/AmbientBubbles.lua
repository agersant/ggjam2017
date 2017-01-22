require("src/utils/OOP");
local AmbientBubbles = Class("AmbientBubbles", AmbientBubbles);

AmbientBubbles.init = function(self)
    self._bubbleImgs = {love.graphics.newImage("assets/sprites/bubbleA.png"), love.graphics.newImage("assets/sprites/bubbleB.png")};
    self._bubbles = {};
	for i = 1,10 do
		table.insert(self._bubbles,{x=0, y=-90, speed=1, img=1});
		table.insert(self._bubbles,{x=0, y=-90, speed=1, img=2});
	end
end

AmbientBubbles.moveBubbles = function (self, dt)
	for k, bub in pairs(self._bubbles) do
		if (bub.y <= -10) then
			bub.x = math.random(10,600)
			bub.y = math.random(700,1500)
			bub.speed = math.random(100,300)
		end
		bub.y = bub.y - bub.speed *dt;
	end
end

AmbientBubbles.draw = function (self)
    for k, bub in pairs(self._bubbles) do
		love.graphics.draw( self._bubbleImgs[bub.img], bub.x, bub.y );
	end
end

return AmbientBubbles;