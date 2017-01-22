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
		
		scene:spawn(Bumper, {});
		script:wait(8);

	end

end


return BumperSpawner;
