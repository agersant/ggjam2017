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
		local scorecheck = self._scene:getScore();
		if scorecheck > 8000 then
			math.randomseed( os.time() );
			timer = math.random(1, 4);
		elseif scorecheck > 5000 then
			math.randomseed( os.time() );
			timer = math.random(3, 6);
		elseif scorecheck > 3000 then
			math.randomseed( os.time() );
			timer = math.random(6, 8);
		else
			timer = 8;
		end
		script:wait(timer);
		scene:spawn(Bumper, {});

	end

end


return BumperSpawner;
