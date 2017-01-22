require("src/utils/OOP");

local AnimatedSprite = Class("AnimatedSprite");

AnimatedSprite.init = function(self, source)
	self._source = source;
end

AnimatedSprite.playAnimation = function(self, anim)
	if not self._source[anim] then
		print("Missing anim " .. anim);
		return;
	end
	if self._currentAnim == self._source[anim] then
		return;
	end
	self._currentAnim = self._source[anim];
	local fps = self._currentAnim.fps or 24;
	self._duration = #self._currentAnim.frames / fps;
	self._animTime = 0;
end

AnimatedSprite.update = function(self, dt)
	self._animTime = self._animTime + dt;
	local p = (self._animTime % self._duration) / self._duration;
	local currentFrame = math.ceil(p * #self._currentAnim.frames);
	self._image = self._currentAnim.frames[currentFrame];
end

AnimatedSprite.render = function(self, x, y)
	if self._image then
		local w, h = self._image:getDimensions();
		love.graphics.draw(self._image, x -w/2, y -h/2);
	end
end

return AnimatedSprite;
