require("src/utils/OOP");

local Scene = Class("Scene");



-- PUBLIC API

Scene.init = function(self)
	self._canProcessSignals = true;
end

Scene.update = function(self, dt)
end

Scene.draw = function(self)
end

Scene.handleKeyPress = function(self, key)
end

Scene.canProcessSignals = function(self)
	return self._canProcessSignals;
end

Scene.getScene = function(self)
	return self;
end



-- STATIC

local currentScene = Scene:new();

Scene.getCurrent = function(self)
	return currentScene;
end

Scene.setCurrent = function(self, scene)
	assert(scene);
	currentScene = scene;
end

Scene.playMusic = function( self, musicName )
	if not musicName then
		return;
	end
	if ( gCurrentMusic and gCurrentMusic ~= musicName ) then
		love.audio.stop( gCurrentMusic );
	end

	gCurrentMusic = musicName;
	gCurrentMusic:setLooping( true );

	love.audio.play( gCurrentMusic );
	love.audio.setVolume( 0.5 );
end



return Scene;
