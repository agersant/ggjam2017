require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");
local Bumper = require("src/entity/Bumper");

local BumperSpawner = Class("BumperSpawner", Entity);

BumperSpawner.init = function(self, scene, options)
	BumperSpawner.super.init(self, scene);
	self:addScriptRunner();
	local script = Script:new(self, function(script)
		self:spawnLogic(script);
	end);
	self:addScript(script);
end

BumperSpawner.spawnLogic = function(self, script)

	local scene = self:getScene();
	while true do

		if scene:isOver() then
			self:despawn();
			return;
		end
		local scoreCheck = self._scene:getScore();
		if scoreCheck > 30000 then
			timer = math.random( 5, 10 );
			timer = timer / 10;
		elseif scoreCheck > 25000 then
			timer = math.random( 8, 15 );
			timer = timer / 10;
		elseif scoreCheck > 18000 then
			timer = math.random( 9, 20 );
			timer = timer / 10;
		elseif scoreCheck > 12000 then -- The Gersant Level
			timer = math.random(1, 3);
		elseif scoreCheck > 8000 then
			timer = math.random(1, 4);
		elseif scoreCheck > 5000 then
			timer = math.random(3, 6);
		elseif scoreCheck > 3000 then
			timer = math.random(6, 8);
		else
			timer = 8;
		end
		script:wait(timer);
		scene:spawn(Bumper, {});

	end

end


return BumperSpawner;
