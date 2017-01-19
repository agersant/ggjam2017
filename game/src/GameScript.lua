require("src/utils/OOP");
local Entity = require("src/utils/Entity");
local Script = require("src/utils/Script");

local GameScript = Class("GameScript", Entity);

GameScript.init = function(self, scene)
	GameScript.super.init(self, scene);
	self:addScriptRunner();

	local script = Script:new(self, function(self)
		
		self:thread(function(self)
			while true do
				self:wait(1);
				self:signal("s");
			end
		end);

		while true do
			self:waitFor("s");
			print("Hello");
		end
		
	end);
	self:addScript(script);
end


return GameScript;