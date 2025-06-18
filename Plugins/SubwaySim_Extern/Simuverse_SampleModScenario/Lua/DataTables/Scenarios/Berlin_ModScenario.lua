--
--
-- SubwaySim
-- Module Berlin_ModScenario.lua
--
-- Mod Scenario for the Berlin Map
--
--
-- Author:	Johannes Pauschenwein
-- Date:	11/06/2025
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

---@class Berlin_ModScenario : SSB_ScenarioScenarioMode
local Berlin_ModScenario = Class("Berlin_ModScenario", {}, SSB_ScenarioScenarioMode);

---@type Scenario_DataTable
local Berlin_ModScenario_Datatable = {
	contentType		= "scenario",
	contentName		= "Berlin_ModScenario",

	title			= "Berlin Sample Mod Scenario",
	author			= "$GameDeveloper",
	previewFilename	= "/Simuverse_SampleModScenario/UI/Berlin_Sample_Mod_Banner.Berlin_Sample_Mod_Banner",

	description		= "Berlin Sample Mod Scenario",
	duration		= 10,
	mapName			= "Berlin",

	class			= Berlin_ModScenario,
};

g_contentManager:addContent(Berlin_ModScenario_Datatable);
	

function Berlin_ModScenario:onScenarioStarted()
	Berlin_ModScenario:parentClass().onScenarioStarted(self);

	---------------------------------------------------------------------
	-- Messages
	g_l10n:addText("de",	"Welcome_Modder",				"                       Willkommen lieber Modder!                       "); -- Longer messages = more time to read.
	g_l10n:addText("en",	"Welcome_Modder",				"                       Welcome dear Modder!                       ");
	
	g_l10n:addText("de",	"Have_Fun_Modder",				"                       Viel Spaß beim Modden!                       ");
	g_l10n:addText("en",	"Have_Fun_Modder",				"                       Have fun Modding!                       ");
	
	g_l10n:addText("de",	"Drive_Into_U7",				"                       Schiebe den Zug in die Platform!                       ");
	g_l10n:addText("en",	"Drive_Into_U7",				"                       Push the train, into the platform!                       ");

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
	---@cast map MapBerlin
	
	-- set date --> will update all timetables
	self.environment:setDate(2025, 06, 12, true, true);
	self.environment:setDaytime(daytime(10,11));
	self.environment:setWeather(EWeatherPreset.Overcast);

	---------------------------------------------------------------------
	-- Player
	-- Spawn a train with which the player starts
	local playerTrain = assert(g_controlCenter:spawnTrainCompositionAtPlatform("Berlin_HK_1x", map.stations.Go, 1, 1), "Failed to spawn train 1");
	-- Spawn a train that will be attached later, use "don't register = true", so the train is parked and can be attached later with allowOnSight.
	local playerTrain2 = assert(g_controlCenter:spawnTrainCompositionAtPlatform("Berlin_HK_1x", map.stations.U, 7, 1, true), "Failed to spawn train 2"); 

	-- Spawn Player
	local playerSpawner = PlayerSpawn.findSpawner(map.stations.Go, tostring(1));	-- Use Spawners to get locations for teleporting.
	if not playerSpawner then
		self.player:teleportCharacter(Vector3:new(-389, 3166.22, 49.45), Vector3:new(-0.0, -0, 50.95));
		debugprint("[Berlin_ModScenario] Couldn't find spawner!");
		-- printf("[Berlin_ModScenario] Couldn't find spawner!"); Use printf if you want the message in the log file!
	else
		self.player:teleportCharacter(playerSpawner:getSpawnTransform().location, playerSpawner:getSpawnTransform().rotation);	-- Teleport to the spawners location.
	end;

	---------------------------------------------------------------------
	-- Player Timetables
	local tt1 = map.U1_Dir1:clone(daytime(09, 59), nil, true);	-- Clone a specific timetable from the berlin map.
	tt1:forceUniqueStopList();									-- Make sure the changes we do to this timetable are not happening on other timetables.
	tt1:startAtStation("Go", false);							-- Let the timetable start at Gleisdreieck.
	tt1:setDate(self.environment:getMidnightOSTime());
	tt1:setIsServiceRun(false);									-- We want to transport passengers.
	tt1:terminateAtStation("U", true, false, false, true);		-- Discard all following stops and let timtetable2 take over.
	tt1:getLastStop().platformTerminating = 1;					-- Specify on which platform the train should terminate.

	local tt2 = Timetable:new("", daytime(10,22));				-- Create another Timetable for that departure time.
	tt2:setIsServiceRun(true); 									-- Sets the second timetable as serviceRun so we force passengers out, before driving into the depot.
	tt2:setDate(self.environment:getMidnightOSTime());
	---@type TaskStack_Timetable_stop[]
	local tt2_stops = {
		{
			station				= map.stations.U,
			platform			= 1,
			direction			= 1,
			departure			= 0,							-- Departure 0 means it autogenerates the departure time.
			speedLimit			= 60,							-- Speedlimits don't overwrite maximum speeds defined by signals, but they can lower them.
		},
		{
			station				= map.stations.U,
			platform			= 7,
			departure			= 0,
			speedLimit			= 60,
			attachVehicle 		= playerTrain2:getFirstVehicle(true), -- Attach a Vehicle.
			allowOnSight 		= true,							-- Allows your train to drive into a platform where a train is parked.
			turnAround			= true,							-- Gives you the task to switch cab so you can drive out of the depot.
			customUpdateApproach= function ()					-- An update function that plays everyframe until end of the stop.
				g_scenario:playMessage({						-- PlayMessage plays a message. We can't specify how long it is visible so we spam it every frame.
					{
						transcript = "$Drive_Into_U7",
					},
				});
				return false;									-- We always return false so the regular update is executed.
			end;
			
		},
		{
			station				= map.stations.U,
			platform			= 1,
			direction 			= 2,
			departure			= 0,
			speedLimit			= 60,
		},
	};

	tt2:addStops(tt2_stops);
	tt2:forceUniqueStopList(); 									-- Make sure the changes we do to this timetable are not happening on other timetables.
	tt1:setFollowupTimetable(tt2);
	tt2:setSourceTimetable(tt1);

	local tt3		= Timetable:new("", daytime(10, 25)); 		-- Make a new timetable that is not a serviceRun so passengers get in again.
	tt3:setIsServiceRun(false);
	tt3:setDate(self.environment:getMidnightOSTime());
	---@type TaskStack_Timetable_stop[]
	local tt3_stops = {
		{
			station				= map.stations.U,
			platform			= 1,
			departure			= 0,
			speedLimit			= 60,
			direction			= 2,
		},
		{
			station				= map.stations.Kfo,
			platform			= 2,
			departure			= 0,
			speedLimit			= 60,
		},
		{
			station				= map.stations.Wt,
			platform			= 6,
			departure			= 0,
			speedLimit			= 60,
		},
	}
	tt3:addStops(tt3_stops);
	tt2:setFollowupTimetable(tt3);
	tt3:setSourceTimetable(tt2);

	local playerTasks = SSB_TaskStack:new();					-- Create new Task, that are the messages you get at the top left corner.
	playerTasks:setTrainComposition(playerTrain);
	playerTasks:generateFromTimetable(tt1, 2);					-- Generate tasks from tt1 and 2 following time tables.
	self:startTask(playerTasks:getTask());

	---------------------------------------------------------------------
	-- AI Train
	local AITrainComposition = assert(g_controlCenter:spawnTrainCompositionAtPlatform("Berlin_A3L92_2x", map.stations.Go, 2, 2), "Failed to spawn AI Train");

	---@type Timetable
	local AItt = Timetable:new("", daytime(09, 53))
		:setIsServiceRun(false)
		:setDate(self.environment:getMidnightOSTime());

	---@type TaskStack_Timetable_stop[]
	local AItt_stops = {
		{
			station		= map.stations.Go,
			platform	= 2,
			departure	= 0,
			speedLimit	= 50,
		},
		{
			station		= map.stations.Mo,
			platform	= 2,
			departure	= 0,
			speedLimit	= 50,
		},
		{
			station		= map.stations.Ho,
			platform	= 2,
			departure	= 0,
			speedLimit	= 25,
		},
	}
	AItt:addStops(AItt_stops);
	AItt:terminateAtStation("Ho", true, false, false);			-- Makes the AI train dissappear at this station.
	AITrainComposition:setIsAIControlled(true);					-- So it is actuall an AI train.
	AITrainComposition:assignTimetable(AItt);



end;