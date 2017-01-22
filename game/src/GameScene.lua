require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local GameScene = Class("GameScene", Scene);
package.loaded["src/GameScene"] = GameScene;

local Entity = require("src/utils/Entity");
local ScriptRunner = require("src/utils/ScriptRunner");
local Script = require("src/utils/Script");
local TableUtils = require("src/utils/TableUtils");
local GameScript = require("src/GameScript");
local BumperSpawner = require("src/entity/BumperSpawner");
local Fish = require("src/entity/Fish");
local PickUp = require("src/entity/PickUp");
local LevelLoader = require("src/LevelLoader");
local CreditsScene = require("src/scenes/CreditsScene");
local HUD = require("src/HUD");



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
	self._world:setCallbacks(
		function(fixtureA, fixtureB, contact) self:handleCollision(fixtureA, fixtureB, contact); end
	);
	self:spawnEdges();

	self._timeLeft = 60;
	self._score = 0;
	self._hud = HUD:new(self);

	self._scriptRunner = ScriptRunner:new(self);

	self:update(0);

	self._fishSparky = self:spawn(Fish, { player = Fish.sparky });
	self._fishOther = self:spawn(Fish, { player = Fish.other});
	self._bumperSpawner = self:spawn(BumperSpawner, {});
	
	math.randomseed( os.time() );
	local songRandom = math.random( 1, 10 );
	if songRandom == 1 then
		self:playMusic( gAssets.MUSIC.hidden );
	else
		self:playMusic( gAssets.MUSIC.theme );
	end
end

GameScene.handleCollision = function(self, fixtureA, fixtureB, contact)
	local objectA = fixtureA:getBody():getUserData();
	local objectB = fixtureB:getBody():getUserData();
	if not objectA or not objectB then
		return;
	end
	if objectA.collideWith then
		objectA:collideWith(objectB, contact);
	end
	if objectB.collideWith then
		objectB:collideWith(objectA, contact);
	end
end

GameScene.spawnEdges = function(self)
	local walls = {
		{ x = -20, y = 280, w = 40, h = 560 },
		{ x = 580, y = 280, w = 40, h = 560 },
		{ x = 280, y = -20, w = 560, h = 40 },
		{ x = 280, y = 580, w = 560, h = 40 },
	};
	for _, wall in pairs(walls) do
		local body = love.physics.newBody(self._world, 0, 0, "static");
		local shape = love.physics.newRectangleShape(wall.x, wall.y, wall.w, wall.h);
		local fixture = love.physics.newFixture(body, shape);
		fixture:setRestitution(1);
		fixture:setCategory(Entity.PHYSICS_TAG.GEO);
	end
	
end

GameScene.update = function(self, dt)
	GameScene.super.update(self, dt);
	
	self._timeLeft = self._timeLeft - dt;
	if not self._gameOver then
		self._score = self._score + dt;
		self._gameOver = self._timeLeft < 0;
		if self._gameOver then
			self:doGameOver();
		end
	end

	self._world:update(dt);

	self._canProcessSignals = true;
	self._scriptRunner:update(dt);
	
	-- Update entities
	for _, entity in ipairs(self._updatableEntities) do
		entity:update(dt);
	end
	
	-- Add new entities
	for entity, _ in pairs(self._spawnedEntities) do
		table.insert(self._entities, entity);
		entity:addedToScene();
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

	love.graphics.translate(40, 120);

	love.graphics.setColor(0, 150, 150, 255);
	love.graphics.rectangle("fill", 0, 0, 560, 560 );

	for _, entity in ipairs( self._drawableEntities ) do
		entity:render();
	end
	
	love.graphics.pop();

	self._hud:render();
	
end

GameScene.isOver = function(self)
	return self._gameOver;
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

GameScene.doGameOver = function(self)
	self._scriptRunner:addScript(Script:new(self, function(script)
		script:wait(2);
		script:waitForInput("space");
		Scene:setCurrent(CreditsScene:new());
	end));
end

GameScene.getTimeLeft = function(self)
	return self._timeLeft;
end

GameScene.getScore = function(self)
	return self._score;
end

GameScene.giveExtraTime = function(self, seconds)
	self._timeLeft = self._timeLeft + seconds;
end

return GameScene;
