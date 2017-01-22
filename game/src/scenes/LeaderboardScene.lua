require("src/utils/OOP");
local Scene = require("src/utils/Scene");
local Script = require("src/utils/Script");
local Leaderboard = require("src/Leaderboard");
local CreditsScene = require("src/scenes/CreditsScene");

local LeaderboardScene = Class("LeaderboardScene", Scene);

local maxNameLength = 8;

LeaderboardScene.init = function(self, playerScore)
	LeaderboardScene.super.init(self);
	self._titleFont = love.graphics.newFont("assets/fonts/ThatNogoFontCasual.ttf", 60);
	self._dataFont = love.graphics.newFont("assets/fonts/smallFont.ttf", 40);
	self._playerScore = playerScore;
	self._nameInput = "";
	self._playerRank = Leaderboard:getScorePosition(playerScore);
	self._data = Leaderboard:getData();
	self._startTime = love.timer.getTime();
end

LeaderboardScene.update = function(self, dt)
	if not self._playerRank then
		local now = love.timer.getTime();
		if now - self._startTime > 2 then
			self._completedInput = true;
		end
	end
end

LeaderboardScene.handleKeyPress = function(self, key)
	
	if self._completedInput and key == "space" then
		Scene:setCurrent(CreditsScene:new());
	end

	if self._playerRank and not self._completedInput then
		if key == "return" and #self._nameInput > 0 then
			self:completeInput();
		elseif #key == 1 then
			self._nameInput = self._nameInput .. key;
			if #self._nameInput >= maxNameLength then
				self:completeInput();
			end
		end
	end

end

LeaderboardScene.completeInput = function(self)
	Leaderboard:insert(self._nameInput, self._playerScore);
	self._completedInput = true;
end

LeaderboardScene.draw = function(self)
	love.graphics.setFont(self._titleFont);
	love.graphics.setColor(255, 255, 255, 255);
	love.graphics.printf("Leaderboard", 40, 40, 640, "left");

	love.graphics.setFont(self._dataFont);
	for i = 1, #self._data do
		love.graphics.setColor(255, 255, 255, 255);
		local entry = self._data[i];
		if self._playerRank then
			if self._playerRank == i then
				love.graphics.setColor(0, 255, 255, 255);

				local now = love.timer.getTime();
				local blink = (1000 * (now - self._startTime)) % 800 > 400;
				local nameDisplay = self._nameInput;
				if not self._completedInput and blink then
					nameDisplay = nameDisplay .. "|";
				end
				entry = { name = nameDisplay, score = self._playerScore };

			elseif self._playerRank < i then
				entry = self._data[i-1];
			end
		end
		local digit = string.format("%2d", i);
		love.graphics.printf("#" .. digit .. " " .. entry.name, 80, 80 + i * 45, 640, "left");
		love.graphics.printf(entry.score, 80, 80 + i * 45, 500, "right");
	end

	if self._completedInput then
		love.graphics.printf("Press Space To Continue", 0, 640, 640, "center");
	end
end

return LeaderboardScene;
