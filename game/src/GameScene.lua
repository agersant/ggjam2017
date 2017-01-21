require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Entity = require("src/utils/Entity");
local TableUtils = require("src/utils/TableUtils");
local GameScript = require("src/GameScript");
local Fish = require("src/entity/Fish");
local PickUp = require("src/entity/PickUp");

local GameScene = Class("GameScene", Scene);



-- IMPLEMENTATION

local removeDespawnedEntitiesFrom = function(self, list)
	for i = #list, 1, -1 do
		local entity = list[i];
		if self._despawnedEntities[entity] then
			table.remove(list, i);
		end
	end
end


-- PUBLIC API

GameScene.init = function(self)
	GameScene.super.init(self);
	
	self._entities = {};
	self._updatableEntities = {};
	self._drawableEntities = {};
	self._spawnedEntities = {};
	self._despawnedEntities = {};
	
	self._world = love.physics.newWorld(0, 0, false);

	self:update(0);

	self:spawn(Fish, {});
	self:spawn(PickUp, {});
end

GameScene.update = function(self, dt)
	GameScene.super.update(self, dt);
	
	self._world:update(dt);

	self._canProcessSignals = true;
	
	-- Update entities
	for _, entity in ipairs(self._updatableEntities) do
		entity:update(dt);
	end
	
	-- Add new entities
	for entity, _ in pairs(self._spawnedEntities) do
		table.insert(self._entities, entity);
		if entity:isDrawable() then
			table.insert(self._drawableEntities, entity);
		end
	end
	for entity, _ in pairs(self._spawnedEntities) do
		if entity:isUpdatable() then
			table.insert(self._updatableEntities, entity);
			entity:update(0);
		end
	end
	self._spawnedEntities = {};
	
	self._canProcessSignals = false;
	
	-- Remove old entities
	removeDespawnedEntitiesFrom(self, self._entities);
	removeDespawnedEntitiesFrom(self, self._updatableEntities);
	removeDespawnedEntitiesFrom(self, self._drawableEntities);
	for entity, _ in pairs(self._despawnedEntities) do
		entity:destroy();
	end
	self._despawnedEntities = {};
	
	-- Sort drawable entities
	-- table.sort(self._drawableEntities, sortDrawableEntities);
end

GameScene.draw = function(self)
	GameScene.super.draw(self);
	
	love.graphics.push();
	for _, entity in ipairs( self._drawableEntities ) do
		entity:render();
	end
	
	love.graphics.pop();
end

GameScene.spawn = function(self, class, options)
	assert(type(options) == "table");
	local entity = class:new(self, options);
	self._spawnedEntities[entity] = true;
	return entity;
end

GameScene.despawn = function(self, entity)
	self._despawnedEntities[entity] = true;
end

GameScene.getPhysicsWorld = function(self)
	return self._world;
end


return GameScene;
