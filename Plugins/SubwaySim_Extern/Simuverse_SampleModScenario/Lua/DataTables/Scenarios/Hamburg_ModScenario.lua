--
--
-- SubwaySim
-- Module Hamburg_ModScenario.lua
--
-- Mod Scenario for the Hamburg Map
--
--
-- Author:	Johannes Pauschenwein
-- Date:	16/06/2025
--
--
-- Copyright (C) Simuverse GmbH, Confidential. All Rights Reserved.
--
-- This is proprietary to Simuverse GmbH. Any contents of this file
-- are considered trade secrets. Therefore, any reproduction or
-- distribution, partly or as a whole, is strictly forbidden except
-- by explicit permission of Simuverse GmbH.
--
--

InitializeClassReference("SSB_ScenarioScenarioMode", SSB_ScenarioScenarioMode);

---@class Hamburg_ModScenario : SSB_ScenarioScenarioMode
local Hamburg_ModScenario = Class("Hamburg_ModScenario", {}, SSB_ScenarioScenarioMode);

---@type Scenario_DataTable
local Hamburg_ModScenario_Datatable = {
	contentType		= "scenario",
	contentName		= "Hamburg_ModScenario",

	title			= "Hamburg Sample Mod Scenario",
	author			= "$GameDeveloper",
	previewFilename	= "/Simuverse_SampleModScenario/UI/Hamburg_Sample_Mod_Banner.Hamburg_Sample_Mod_Banner",

	description		= "Hamburg Sample Mod Scenario",
	duration		= 10,
	mapName			= "Hamburg",

	class			= Hamburg_ModScenario,
};

g_contentManager:addContent(Hamburg_ModScenario_Datatable);

function Hamburg_ModScenario:onScenarioStarted()
	Hamburg_ModScenario:parentClass().onScenarioStarted(self);

	---------------------------------------------------------------------
	-- Messages
	g_l10n:addText("de",	"Welcome_Modder",				"                       Willkommen lieber Modder!                       "); -- Longer messages = more time to read.
	g_l10n:addText("en",	"Welcome_Modder",				"                       Welcome dear Modder!                       ");

	g_l10n:addText("de",	"Have_Fun_Modder",				"                       Viel Spaß beim Modden!                       ");
	g_l10n:addText("en",	"Have_Fun_Modder",				"                       Have fun Modding!                       ");

	g_l10n:addText("de",	"Closure_Anouncement1",			"Hey! Zwischen Mundsburg und Uhlandstraße ist das Gleis gesperrt!");
	g_l10n:addText("en",	"Closure_Anouncement1",			"Hey! Between Mundsburg and Uhlandstraße is the track closed!");

	g_l10n:addText("de",	"Closure_Anouncement2",			"Drehe in Mundsburg um und fahr wieder nach Barmbek!");
	g_l10n:addText("en",	"Closure_Anouncement2",			"Turn around in Mundsburg and drive back to Barmbek!");

	self:addWelcomeMessage({
		{
			transcript		= "$Welcome_Modder",
		},
		{
			transcript		= "$Have_Fun_Modder",
		},
	});

	---------------------------------------------------------------------
	-- Basic Setup
	local map = self.map;
	---@cast map MapHamburg

	-- set date --> will update all timetables
	self.environment:setDate(2025, 06, 16, true, true);
	self.environment:setDaytime(daytime(10,21));
	self.environment:setWeather(EWeatherPreset.Overcast);

	self.timeForRain = 625;						-- 600 minutes after midgnight is 10AM, we want to let it rain at 10:25.
	self.weatherChanged = false;

	---------------------------------------------------------------------
	-- Player
	-- Spawn a train with a repaint on it.
	---@type TrainComposition_VehicleList
	local playerVehicle = {
		{	contentName = "Hamburg_DT5.1", direction = 2,	},
		{	contentName = "Hamburg_DT5.2", direction = 2,	vehicle = { _components = { RepaintComponent = { repaintPath	= "/SubwaySim_Hamburg/Vehicles/DT5/Textures/Graffiti_Skin.Graffiti_Skin",	}}}},
	};
	-- Spawn a train with which the player starts
	local playerTrain = assert(g_controlCenter:spawnTrainCompositionAtPlatform(playerVehicle, map.stations.BA, 4, 2), "Failed to spawn train 1");


	-- Landungsbrücken zu Rathaus
	-- Spawn Player
	local playerSpawner = PlayerSpawn.findSpawner(map.stations.BA, tostring(4));	-- Use Spawners to get locations for teleporting.
	if not playerSpawner then
		self.player:teleportCharacter(Vector3:new(-4073.2, 2577.75, 15.3), Vector3:new(-0.0, -0, 135));
		debugprint("[Hamburg_ModScenario] Couldn't find spawner!");
		-- printf("[Hamburg_ModScenario] Couldn't find spawner!"); Use printf if you want the message in the log file!
	else
		self.player:teleportCharacter(playerSpawner:getSpawnTransform().location, playerSpawner:getSpawnTransform().rotation);	-- Teleport to the spawners location.
	end;

	---------------------------------------------------------------------
	-- Player Timetables

	-- Timetable 1
	local tt1 = map.U3_Ring_Dir2:clone(daytime(10, 22), nil, true);
	tt1:setDate(self.environment:getMidnightOSTime());
	-- Barmbek has two codes: BA if you drive from Barmbek to Barmbek in direction 1 and BK if you drive from Wandsbek to Barmbek in direction 2.
	-- We use BK because we want to start at Barmbek and want to drive in direction 2.
	tt1:startAtStation("BK", false);
	tt1:getFirstStop().platform = 4;
	tt1:setIsServiceRun(false); 									-- We want passengers so, not a service run.
	tt1:terminateAtStation("MU", true, false, true, true);			-- Let tt1 stop at Mundsburg but keep the following tables.
	local muStop = tt1:findStop("MU");								-- Finds the first Stop in Mundsburg.
	assert(muStop, "Didn't find MU stop");

	muStop.onApproach = function()									-- Play a message as soon we are driving to Mundsburg.
		g_scenario:playMessage({
			{
				transcript = "$Closure_Anouncement1"
			},
			{
				transcript = "$Closure_Anouncement2"
			},
		});

	end;

	tt1:getLastStop().platformTerminating = 2;						-- We want to terminate at the platform 2.
	tt1:getLastStop().platform = 12;								-- Then we want to turn around at platform 12, but we don't say he should turn around yet.
	g_controlCenter:planSectionClosure("LU", "MU", nil, nil, true); -- We want to simulate a section closure. This only applies to AI train. For the player we must simulate a section closure with a custom time table.
																	-- This make AI trains spawn at Mundsburg and drive direction Barmbek and despawn at Lübecker Straße. So no AI trains will drive section LU-MU or vice versa.
	self:setupPIS();												-- Write a message to the Station PIS.

	-- Timetable 2
	local tt2 = Timetable:new("U3", daytime(10,28));				-- Create another Timetable for that departure time to simulate a section closure between Mundsburg and Lübecker Straße
	tt2:setIsServiceRun(false);
	tt2:setDate(self.environment:getMidnightOSTime());
	---@type TaskStack_Timetable_stop[]
	local tt2_stops = {
		{
			station				= map.stations.MU,				-- The first station of the second timetable must match with the last station of the timetable before.
			platform			= 12,							-- We stop at platform 12 so we can turn around. We can turn around because we have a signal facing both directions.
			departure			= 0,
			speedLimit			= 20,							-- Speedlimits don't overwrite maximum speeds defined by signals, but they can lower them.
			turnAround			= true,							-- Now turn around.
			login				= true,							-- Login to PIS.

		},
		{
			station				= map.stations.MU,
			platform			= 1,							-- We want to change tracks as soon as possible, so we specify platform 1 in Mundsburg, so we are at the correct side.
			departure			= 1,
			speedLimit			= 60,
		},
		{
			station				= map.stations.HS,
			platform			= 1,
			departure			= 4,
			speedLimit			= 60,
		},
		{
			station				= map.stations.DE,
			platform			= 1,
			departure			= 6,
			speedLimit			= 60,
		},
		{
			station				= map.stations.BK,
			platform			= 1,
			departure			= 7,
			speedLimit			= 60,
		},
	};
	tt2:addStops(tt2_stops);
	tt2:forceUniqueStopList(); 									-- Make sure the changes we do to this timetable are not happening on other timetables.
	tt1:linkFollowupTimetables({								-- To link multiple timetables without having to set source And follow up.
		tt2, }
	);

	local playerTasks = SSB_TaskStack:new();					-- Create new Task, that are the messages you get at the top left corner.
	playerTasks:setTrainComposition(playerTrain);
	playerTasks:generateFromTimetable(tt1, 1);					-- Generate tasks from tt1 and 1 following time tables.
	self:startTask(playerTasks:getTask());
end;

function Hamburg_ModScenario.update(self, dt)					-- Overwrite the update function of this scenario.
	Hamburg_ModScenario:parentClass().update(self, dt);			-- But still call the original update function so nothing brakes.

	if not self.weatherChanged and self.environment ~= nil then
		local minutes = self.environment.daytime;
		if minutes ~= nil then
			if minutes > self.timeForRain then
				self.environment:setWeather(EWeatherPreset.Thunderstorm, 15, 3); -- Transition to Thunderstorm for 15 minutes, transitioning for 3 minutes.
				self.weatherChanged = true;
			end;
		end;
	end;
end;

function Hamburg_ModScenario:setupPIS()
	HHA_PlatformInfoScreen.addTextOverride("U3", "MU/2", "BITTE NICHT EINSTEIGEN", {
		"Aktuell kein U-Bahn-Verkehr zw.",
		"Mandsburg und Lübecker Straße",
	});
end;