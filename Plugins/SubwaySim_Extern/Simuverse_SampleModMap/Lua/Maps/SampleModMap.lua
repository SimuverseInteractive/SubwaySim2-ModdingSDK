--
--
-- SubwaySim2
-- Module SampleModMap.lua
--
-- Map file for SampleModMap
--
--
-- Author:	Maximilian Rudorfer
-- Date:	12/05/2025
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
InitializeClassReference("MapBerlin", MapBerlin);

---@class MapSampleModMap : MapBerlin, BaseMap
MapSampleModMap = Class("MapSampleModMap", MapSampleModMap, MapBerlin);

---@type Map_DataTable
local SampleModMap_DataTable = {
	contentType		= "map",
	contentName		= "SampleModMap",
	class			= MapSampleModMap,
	levelName		= "SampleModMap",
	author			= "$GameDeveloper",

	title			= "Sample Mod Map",
	subtitle		= "This could be your text",
	description		= "This is a test map that demonstrates how to use the Modding SDK. You can also use it for testing your own vehicles.",
	previewFilename = "/SubwaySim2_Core/UI/MainMenu/Backgrounds/CityBerlin.CityBerlin",
};
g_contentManager:addContent(SampleModMap_DataTable);

--- Creates a new instance of this class
---@return MapSampleModMap
function MapSampleModMap:new()
	self = MapSampleModMap:emptyNew();

	self.levelName		= "SampleModMap";
	self.displayName	= "Sample Mod Map";
	
	-- latitude and longitude of Berlin's city center
	self.latitude		= 52.518611;
	self.longitude		= 13.408333;
	-- UTC+1
	self.timezone		= 1;

	self:loadStations();
	self:loadTimetables();
	self:loadCareerMode();

	self:loadElaLists();
	self:loadIbisLists();

	EventManager.callModListeners("onMapCreated", self);

	return self;
end;

--- Event to load any additionally required level instances
function MapSampleModMap:loadLevelInstances()
	assert(GameplayStatics.loadLevelInstance("SubwaySim2_Environment", Vector3.zero, Vector3.zero), "Failed to load a part of the level");
end;

--- Loads the station definitions for this map
function MapSampleModMap:loadStations()
	---@type table<string, Station>
	self.stations = {};

	self.stations.A = Station:new("A", "Adlerhain")
		:setPISData({
			announcements	= {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Station_WA.Station_WA",
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Station_WA_ConnectionsU1.Station_WA_ConnectionsU1",
			},
			destinationAnnouncements = {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_WA.Destination_WA",
			},
			connections		= {
				["U1"]		= "U3",
				["U3"]		= "U1",
			},
			extraAnnouncements	= HHA_Announcements.TerminusStationLR,
		})
		:addSpawnPlatform("1", 105, 1)
		:addSpawnPlatform("2", 105, 1)
		:addSpawnPlatform("3", 105, 1)
		:addSpawnPlatform("4", 105, 1)
	
	self.stations.B = Station:new("B", "Birkenau")
		:setPISData({
			announcements	= {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Station_Go.Station_Go",
			},
			destinationAnnouncements = {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_Go.Destination_Go",
			},
			extraAnnouncements	= HHA_Announcements.TerminusStationLR,
		});

	self.stations.C = Station:new("C", "Charlottenfeld"):setPISData({
			connections		= { ["U1"] = "U1" },
			announcements	= {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Station_Fpo.Station_Fpo",
			},
			destinationAnnouncements = {
				"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_Fpo.Destination_Fpo",
			},
			extraAnnouncements	= HHA_Announcements.TerminusStationLR,
		})
		:addSpawnPlatform("1", 105, 2)
		:addSpawnPlatform("2", 105, 2)

	self.stations.D = Station:new("D", "Depot")
		:addSpawnPlatform("3", 105, 2)
		:addSpawnPlatform("4", 105, 2)
		:addSpawnPlatform("5", 105, 2)
		:addSpawnPlatform("6", 105, 2)

	---@type table<string, Station[]>
	self.stationsByLine = {};

	self.stationsByLine.U1 = {
		self.stations.A,
		self.stations.B,
		self.stations.C,
	};
end;

--- Loads the default timetables for this map
function MapSampleModMap:loadTimetables()
	-- Außenring
	---@type Timetable_stop[]
	local stopListU1_dir1 = {
		{
			station = self.stations.A,
			departure = daytime(00, 00),
			platform = "1",
			speedLimit = 80,
		},
		{
			station = self.stations.B,
			departure = daytime(00, 01.5),
			platform = "1",
			speedLimit = 60,
			pisData = {
				customDestinationText = "Gleisdreieck",
			},
		},
		{
			station = self.stations.C,
			departure = daytime(00, 04),
			platform = "1",
			altPlatform = { "2", },
			speedLimit = 80,
			pisData = {
				customDestinationText = "Fehrbelliner Platz",
			},
		},
	};

	---@type Timetable_stop[]
	local stopListU1_dir2 = {
		{
			station = self.stations.C,
			departure = daytime(00, 00),
			platform = "2",
			speedLimit = 80,
		},
		{
			station = self.stations.B,
			departure = daytime(00, 02),
			platform = "2",
			speedLimit = 80,
			pisData = {
				customDestinationText = "Gleisdreieck",
			},
		},
		{
			station = self.stations.A,
			departure = daytime(00, 04),
			platform = "2",
			speedLimit = 60,
		},
		{
			station = self.stations.A,
			departure = daytime(00, 05),
			platform = "4",
			speedLimit = 25,
			altPlatform = { "3", },
		},
	};

	---@type Timetable[]
	self.timetables = {};

	self.U1_Full_Dir1	= Timetable:new("U1", 0);
	self.U1_Full_Dir2	= Timetable:new("U1", 0);

	-- List of templates by line, then by direction
	---@type Timetable[][]
	self.templatesByLine = {
		[1] = {
			[1] = self.U1_Full_Dir1,
			[2] = self.U1_Full_Dir2,
		},
	};

	---@type table<1|2, Timetable[]>
	self.templatesByDirection = {
		[1] = {
			self.U1_Full_Dir1,
		},
		[2] = {
			self.U1_Full_Dir2,
		},
	};

	self.U1_Full_Dir1:addStops(stopListU1_dir1);
	-- self.U1_Full_Dir1:addTrainComposition("Berlin_Flexity_F8Z_1x");
	-- self.U1_Full_Dir1:addTrainComposition("Hamburg_DT5.2_2x");
	self.U1_Full_Dir1:addTrainComposition("Berlin_HK_1x");
	self.U1_Full_Dir1:addTrainComposition("Berlin_A3L92_2x");
	
	self.U1_Full_Dir2:addStops(stopListU1_dir2);
	-- self.U1_Full_Dir2:addTrainComposition("Berlin_Flexity_F8Z_1x");
	-- self.U1_Full_Dir2:addTrainComposition("Hamburg_DT5.2_2x");
	self.U1_Full_Dir2:addTrainComposition("Berlin_HK_1x");
	self.U1_Full_Dir2:addTrainComposition("Berlin_A3L92_2x");
	-- self.U1_Full_Dir2:addTrainComposition("Hamburg_DT5.2_1x");
	-- self.U1_Full_Dir2:addTrainComposition("Berlin_HK_1x");


	local DM = DayMask;
	-- 10 minute interval from 4:30 to 23:30
	TableUtil.insertList(self.timetables,	self.U1_Full_Dir1 :clone(daytime(04, 30))				:repeatUntil(daytime(23, 30),	10));
	TableUtil.insertList(self.timetables,	self.U1_Full_Dir2 :clone(daytime(04, 20))				:repeatUntil(daytime(23, 20),	10));

	-- 5 mins interval weekdays from 6:00 to 21:00
	TableUtil.insertList(self.timetables,	self.U1_Full_Dir1 :clone(daytime(06, 05))				:repeatUntil(daytime(21, 00),	10));
	TableUtil.insertList(self.timetables,	self.U1_Full_Dir2 :clone(daytime(05, 55))				:repeatUntil(daytime(20, 50),	10));

	---@type table<string, Depot_DepotSpace[]>
	self.depots					= {
		["D_03_06"]				= {
			{
				station			= self.stations.D,
				platform		= "4",
				direction		= 2,
			},
			{
				station			= self.stations.D,
				platform		= "6",
				direction		= 2,
			},
			{
				station			= self.stations.D,
				platform		= "5",
				direction		= 2,
			},
			{
				station			= self.stations.D,
				platform		= "3",
				direction		= 2,
			},
		},
	};

	---@type table<Station, ControlCenter_DispatchingStrategy[]>
	self.dispatchingStrategies = {
		[self.stations.A]	= {
			-- connecting trains with 4 min of layover
			{
				sourceStation = self.stations.A,
				targetStation = self.stations.A,
				sourcePlatforms = { "3", "4", },
				targetPlatforms	= { "1", "2", },
				minLayover = 4,
			},
			-- trains with 2 mins of layover may do a short turnaround
			{
				sourceStation = self.stations.A,
				targetStation = self.stations.A,
				useLastPassengerStop = true,
				replaceFirstPlatform = true,
				sourcePlatforms = { "1", "2", },
				targetPlatforms	= { "1", "2", },
				minLayover = 2,
			},
		},
		[self.stations.B] = {
			{
				sourceStation = self.stations.B,
				targetStation = self.stations.B,
				sourcePlatforms = { "1", },
				targetPlatforms = { "2", },
				minLayover = 3,
				timetable = Timetable:new("", 0)
					:setIsServiceRun(true)
					:addStop({
						station = self.stations.B,
						platform = "3",
						departure = 2,
						speedLimit = 25,
						turnAround = true,
					})
					:addStop({
						station = self.stations.B,
						platform = "2",
						departure = 3,
						speedLimit = 25,
					}),
			},
			{
				sourceStation = self.stations.B,
				targetStation = self.stations.B,
				sourcePlatforms = { "2", },
				targetPlatforms = { "1", },
				minLayover = 3,
				timetable = Timetable:new("", 0)
					:setIsServiceRun(true)
					:addStop({
						station = self.stations.B,
						platform = "3",
						departure = 2,
						speedLimit = 25,
						turnAround = true,
					})
					:addStop({
						station = self.stations.B,
						platform = "1",
						departure = 3,
						speedLimit = 25,
					}),
			},
		},
		[self.stations.C] = {
			-- per default, we do a short turnaround at 1/2
			{
				sourceStation = self.stations.C,
				targetStation = self.stations.C,
				sourcePlatforms = { "1", "2", },
				targetPlatforms = { "1", "2", },
				replaceFirstPlatform = true,
				minLayover = 2,
			},

			-- Spawning trains
			{
				sourceStation = nil,
				sourcePlatforms = nil,
				targetStation = self.stations.C,
				targetPlatforms = { "1", "2" },
				replaceLastPlatform = true,
				depotName = "D_03_06",
				timetable = Timetable:new("", 0)
					:setIsServiceRun(true)
					:addStop({
						station = self.stations.D,
						departure = -3,
						platform = "3",
						speedLimit = 25,
					})
					:addStop({
						station = self.stations.C,
						departure = -1,
						platform = "1",
						speedLimit = 25,
					}),
			},
			-- Despawning trains
			{
				sourceStation = self.stations.C,
				sourcePlatforms = { "1", "2", },
				targetStation = nil,
				targetPlatforms = nil,
				replaceFirstPlatform = true,
				useLastPassengerStop = true,
				depotName = "D_03_06",
				timetable = Timetable:new("", 0)
					:setIsServiceRun(true)
					:addStop({
						station = self.stations.C,
						departure = 0,
						platform = "1",
						speedLimit = 25,
						openDoors = false,
					})
					:addStop({
						station = self.stations.D,
						departure = 2,
						platform = "3",
						speedLimit = 25,
						openDoors = false,
					}),
			},
		},
	};
end;

--- Initializes data for career mode
function MapSampleModMap:loadCareerMode()

	-- List of stations where the player can take over in career mode
	-- make sure that each of these stations has a BP_PlayerSpawn
	self.cmTakeoverStations		= {
		self.stations.C,
		self.stations.B,
	};

	-- List of possible route closures for career mode
	self.cmRouteClosures		= {
		{
			stationSource		= self.stations.A,
			stationTarget		= self.stations.B,
			tempClosure			= DayMask.Always,
			permanentClosure	= DayMask.Weekends,
		},
		{
			stationSource		= self.stations.B,
			stationTarget		= self.stations.C,
			tempClosure			= DayMask.Weekends,
		},
	};

	-- List of timetables that can be used for pathfinding
	self.pathfindingTemplates = {
		self.U1_Full_Dir1,
		self.U1_Full_Dir2,
	};
end;

--- Registers all valid timetables to the given `controlCenter` instance
---@param controlCenter ControlCenter
function MapSampleModMap:registerTimetables(controlCenter)
	controlCenter:setStationList(self.stations);
	controlCenter:setTimetableList(self.timetables, self.dispatchingStrategies, self.depots);
end;


--- Returns the station addressed by the given id (Hamburg IBIS)
---@param id integer station id
---@param isTerminus boolean if `true`, this station is the terminus of the route. (This can influence the returned direction)
---@return Station?
---@return integer direction 1 or 2
---@nodiscard
function MapSampleModMap:getStationById(id, isTerminus)
	-- direction 1 + terminus stations
		if id == 11 then	return self.stations.A, ifelse(isTerminus, 2, 1);
	elseif id == 13 then	return self.stations.B, 1;
	elseif id == 14 then	return self.stations.C, ifelse(isTerminus, 1, 2);
	end;

	-- direction 2
		if id == 12 then	return self.stations.B, 2;
	end;
	return nil, 1;
end;

--- Returns the station id from the given station and direction
---@param station Station
---@param direction integer
---@return integer stationId
---@nodiscard
function MapSampleModMap:getStationId(station, direction)
	local stationCode	= -1;
		if station == self.stations.A then		return 11;
	elseif station == self.stations.B then		stationCode = 13;
	elseif station == self.stations.C then		return 14;
	end;

	-- Return -1 in case the station code is invalid
	if stationCode < 0 then
		return -1;
	end;

	-- Codes for direction 2 are always (direction 1)-1
	return ifelse(direction == 1, stationCode, stationCode-1);
end;


--- Loads the Ibis List for this map
function MapSampleModMap:loadIbisLists()
	
	self.ibis_u1 = {
		"A",
		"B",
		"C",
	};

	---@type table<string, string[]>
	self.ibis_u = {
		["U1"] 	= self.ibis_u1,
	};

	---@type table<integer, string>
	self.ibis_u_key= {
		[1] 	= "U1",
	};
end;

---@enum ESampleModMap_ELA_U1
ESampleModMap_ELA_U1 = {
	A 	= 1,
	B 	= 2,
	C 	= 3,
};

--- Loads the Ela List for this map
function MapSampleModMap:loadElaLists()
	--- U1

	---@type integer[][]
	self.ela_u1 = {
		--						A,		B,		C,
		[ESampleModMap_ELA_U1.A] 	= 	{ 0, 	1001, 	1002, 	},
		[ESampleModMap_ELA_U1.B] 	= 	{ 1001,	0,		1003, 	},
		[ESampleModMap_ELA_U1.C] 	= 	{ 1002,	1003, 	0, 	},
	};
	---@type Station[]
	self.ela_u1_Station_List = {
		[ESampleModMap_ELA_U1.A] 	= self.stations.A,
		[ESampleModMap_ELA_U1.B] 	= self.stations.B,
		[ESampleModMap_ELA_U1.C] 	= self.stations.C,
	};


	self.ela_u = {
		[1] = self.ela_u1,
	};
	self.ela_u_Station_List = {
		[1] = self.ela_u1_Station_List,
	};

end;

--- This function must be able to generate a timetable from any PASSENGER STOP on the map to the next available depot.
--- Currently the function is NOT able to start at non-passenger stops!
---@param controlCenter ControlCenter
---@param startStation Station
---@param startPlatform string
---@return Timetable[]?
function MapSampleModMap:findWayToDepot(controlCenter, startStation, startPlatform)
	---@type Timetable[]?
	local ttList;

	local ttHome	= Timetable:new("", 0):setIsServiceRun(true)
		:addStop({
			station = self.stations.C,
			platform = "1",
			departure = 0,
			speedLimit = 25,
		})
		:addStop({
			station = self.stations.D,
			platform = "3",
			departure = 2,
			speedLimit = 20,
		});

	if startStation.nameShort == self.stations.C.nameShort then
		ttHome.stops[1].platform	= startPlatform;
		-- TODO check if we need a turnaround
		return { ttHome };
	end;

	ttList		= self:findRoute(controlCenter, startStation, startPlatform,
		{ self.stations.C, }, { self.stations.B, });

	if ttList == nil then
		return nil;
	end;

	table.insert(ttList, ttHome);
	return ttList;
end;