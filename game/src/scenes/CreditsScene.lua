require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local TitleScene = require("src/scenes/TitleScene");

local CreditsScene = Class("CreditsScene", Scene);

CreditsScene.init = function(self)
	CreditsScene.super.init(self);
	self._textY = 720;
	self._font = love.graphics.newFont("assets/fonts/smallFont.ttf", 26);
	self._text = [[Sparky And The Other Fish

Made by The Goobs for
Global Game Jam 2017


Art

Amanda Newman
Devin Curry


Audio

Antoine Gersant
Cody Malach


Code

Antoine Gersant
Cody Malach
Devin Curry


Design

Amanda Newman
Antoine Gersant
Cody Malach
David Ludwig
Devin Curry


Flute Diddler

Devin Curry


Level Smith

David Ludwig


Opera

Amanda Newman



So long, and thanks for all the fish!
	]];

	--[[
		Amanda Newman: Art, Design, Opera
Antoine Gersant: Code, Audio, Design
Cody Malach: Design, Audio, Code
David Ludwig: Design, Level Smith
Devin Curry: Code, Art, Flute Diddler
	]]

	self._script = Script:new(self, function(script)
		script:wait(.1);
		script:waitForInput("space");
		self:nextScene();
	end);
end

CreditsScene.update = function(self, dt)
	self._script:update(dt);
	self._textY = self._textY - dt * 50;
	if self._textY < -1200 then
		self:nextScene();
	end
end

CreditsScene.nextScene = function(self)
	Scene:setCurrent(TitleScene:new());
end

CreditsScene.draw = function(self)
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.setFont(self._font);
	love.graphics.printf(self._text, 0, self._textY, 640, "center");
end

return CreditsScene;
