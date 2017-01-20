require("src/utils/OOP");
local ScriptRunner = require("src/utils/ScriptRunner");

local Entity = Class("Entity");



Entity.init = function(self, scene)
	assert(scene);
	self._scene = scene;
end

Entity.isUpdatable = function( self )
	return self._scriptRunner;
end

Entity.isDrawable = function( self )
	return false;
end


-- SCRIPT COMPONENT

Entity.addScriptRunner = function(self)
	self._scriptRunner = ScriptRunner:new(self);
end

Entity.addScript = function(self, script)
	assert(self._scriptRunner);
	self._scriptRunner:addScript(script);
end

Entity.removeScript = function(self, script)
	assert(self._scriptRunner);
	self._scriptRunner:removeScript(script);
end

Entity.signal = function(self, signal, ...)
	if not self._scriptRunner then
		return;
	end
	self._scriptRunner:signal(signal, ...);
end


-- CORE

Entity.update = function(self, dt)
	if self._scriptRunner then
		self._scriptRunner:update(dt);
	end
end

Entity.draw = function(self)
end

Entity.despawn = function(self)
	self._scene:despawn(self);
end

Entity.getScene = function(self)
	return self._scene;
end



return Entity;