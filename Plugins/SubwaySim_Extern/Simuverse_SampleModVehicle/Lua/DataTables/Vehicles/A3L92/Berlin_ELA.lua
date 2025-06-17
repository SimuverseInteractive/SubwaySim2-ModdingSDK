--
--
-- SubwaySim
-- Module SampleMod_Berlin_ELA.lua
--
-- short for "Integriertes Bord-Informations-System"
-- Device that interacts with ZZA, FIS and control center
--
--
-- Author:	Barnabas Tamas-Nagy
-- Date:	21/10/2024
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

---@class SampleMod_Berlin_ELA : BaseClass, IBaseCabModule
SampleMod_Berlin_ELA = Class("SampleMod_Berlin_ELA", SampleMod_Berlin_ELA);

SavegameUtil.setDefaultPropertySerializer(SampleMod_Berlin_ELA,				SavegameUtil.dontSerialize);
SavegameUtil.registerPropertySerializer(SampleMod_Berlin_ELA,	"isOn",			SavegameUtil.serializeRaw);
SavegameUtil.registerPropertySerializer(SampleMod_Berlin_ELA,	"routeId",		SavegameUtil.serializeRaw);
SavegameUtil.registerPropertySerializer(SampleMod_Berlin_ELA,	"elaDeviceNo",	SavegameUtil.serializeRaw);
SavegameUtil.registerPropertySerializer(SampleMod_Berlin_ELA,	"_et_zp_blink",	SavegameUtil.serializeRaw);
SavegameUtil.registerPropertySerializer(SampleMod_Berlin_ELA,	"_et_zp_on",	SavegameUtil.serializeRaw);

---@class ELA_Device_DataTable
---@field elaDeviceMesh string
---@field elaCoderMaterialSlot string
---@field elaLightsMaterialSlot string

---@class ELA_Device
---@field elaDeviceMeshId sceneComponentId
---@field elaCoderMID materialInstanceDynamicId
---@field elaLightsMID materialInstanceDynamicId

--- Called to initialize this cab module
---@param cab BaseCab parent cab
---@param vehicle RailVehicle parent rail vehicle
---@param cabData RailVehicle_DataTable_CabData
---@return SampleMod_Berlin_ELA? instance
function SampleMod_Berlin_ELA:new(cab, vehicle, cabData)
	---@type ELA_Device_DataTable
	local elaData			= cabData["ELADevice"];
	if elaData == nil then
		return nil;
	end;

	self					= self:class().emptyNew(self);
	self.cab				= cab;
	self.SampleMod_A3L92CabModule		= assert(self.cab:getModule(SampleMod_A3L92CabModule));
	self.vehicle			= vehicle;
	self.elaData			= elaData;

	-- is this ELA device turned on?
	self.isOn				= false;

	-- route id. Nil if the device has not been logged in.
	---@type integer
	self.routeId			= 0;

	self.enteredRouteId		= 0;

	---@type number[]
	self.elaDeviceNo		= {0,0,0,0};

	---@type ELA_Device
	self.elaDevice = nil;

	---@type table<string, string>
	self.elaLightsSlots = {
		["Enter"] 	= "Emissive07",
		["Error"] 	= "Emissive08",
		["FL"] 		= "Emissive09",
		["L"] 		= "Emissive10",
		["F"] 		= "Emissive11",
		["ET/ZP"] 	= "Emissive12",
	};

	self.serviceList = {
		[0014] 		= "Sonderfahrt",
		[0015] 		= "Betriebsfahrt",
		[0016] 		= "Z6",
		[0017] 		= "Fahrschule",
		[0018] 		= "Pendelverkehr",
		[0019] 		= "White",
	};

	self.elaAnnouncement 				= false;
	self.elaAnnouncementAutomatic 		= false;
	self.speakerActive					= false;

	return self;
end;

--- Called when this vehicle has received a body.
function SampleMod_Berlin_ELA:onBodyCreated()
	local _elaDeviceMeshId		= Actor.getSceneComponent(self.vehicle,	self.elaData.elaDeviceMesh);
	assert(_elaDeviceMeshId, "ELA must have a valid skeletalMesh.");

	local _elaCoderMID 		= PrimitiveComponent.createMaterialInstanceDynamic(_elaDeviceMeshId, self.elaData.elaCoderMaterialSlot);
	assert(_elaCoderMID, "ELA has an invalid Coder material slot specified.");

	local _elaLightsMID 		= PrimitiveComponent.createMaterialInstanceDynamic(_elaDeviceMeshId, self.elaData.elaLightsMaterialSlot);
	assert(_elaLightsMID, "ELA has an invalid Lights material slot specified.");

	---@type ELA_Device
	local _elaDevice = {
		elaDeviceMeshId 	= _elaDeviceMeshId,
		elaCoderMID 		= _elaCoderMID,
		elaLightsMID		= _elaLightsMID,
	};

	self.elaDevice = _elaDevice;

	self:updateMaterial();
end;

--- Called when this vehicle is virtualized
function SampleMod_Berlin_ELA:onBodyDestroyed()
	-- reset some of the variables
	self.elaDevice = nil;
end;

function SampleMod_Berlin_ELA:updateMaterial()
	if self.elaDevice == nil then
		return;
	end;

	local _mat = self.elaDevice.elaCoderMID;
	for index, value in ipairs(self.elaDeviceNo) do
		MaterialInstanceDynamic.setScalar(_mat, ("Digit%02d"):format(index), self.elaDeviceNo[index]);
	end;
end;

--- Callback when the button for up down was pressed so the ela number is half set
---@param buttonIndex integer
---@param direction -1|1
function SampleMod_Berlin_ELA:onButtonPressed(buttonIndex, direction)
	local currentNumber		= self.elaDeviceNo[buttonIndex];
	currentNumber			= currentNumber + direction/2;

	self.elaDeviceNo[buttonIndex] = currentNumber;
	self:updateMaterial();
end;

--- Callback when the button for up down was released so the ela number is full set
---@param buttonIndex integer
---@param direction -1|1
function SampleMod_Berlin_ELA:onButtonReleased(buttonIndex, direction)
	local currentNumber = self.elaDeviceNo[buttonIndex] + direction/2;
	if direction > 0 then
		currentNumber = currentNumber % 10;
	else
		currentNumber = math.floor(ifelse(currentNumber < 0, 9, currentNumber));
	end;

	self.elaDeviceNo[buttonIndex] = currentNumber;

	self.routeId		= self:parseRouteNumber();
	self:updateMaterial();
end;

--- Parses the current ela number into a 4-digit integer
---@return integer routeId
---@nodiscard
function SampleMod_Berlin_ELA:parseRouteNumber()
	local routeId		= 0;
	for index, value in ipairs(self.elaDeviceNo) do
		routeId			= routeId + (clamp(math.floor(value), 0, 9) * math.pow(10, 4-index));
	end;
	return routeId;
end;

function SampleMod_Berlin_ELA:onButtonEnter()
	if not self.SampleMod_A3L92CabModule:isActiveCab() then
		return;
	end;
	if self.routeId == 0 then
		self:logOff();
	else
		self:logIn();
	end;
	self.enteredRouteId = self.routeId;
end;

function SampleMod_Berlin_ELA:onButtonAnnouncementToBoard()
	if not self.SampleMod_A3L92CabModule:isActiveCab() then
		return;
	end;
	if self.elaAnnouncement then
		self.cab.railVehicle:getComponent(Berlin_PIS):playArrivalAnnouncement("/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/General_Enter.General_Enter");
		self.elaAnnouncementAutomatic = true;
	end;
	self.elaAnnouncement = true;
end;


function SampleMod_Berlin_ELA:logIn()
	local elaOrientation 	= ifelse(self.cab:getCabOrientation() == -1 ,2, 1);

	local map			= g_scenario.map:cast(MapBerlin);
	if map == nil then
		print("[SampleMod_Berlin_ELA] Can't login on a non-Berlin map.");
		return;
	end;
	local trainComposition = self.vehicle:getTrainComposition();

	local serviceDisplay = self.serviceList[self.routeId];
	if serviceDisplay ~= nil then
		self:loginResponse(true);
		trainComposition:foreachVehicle(function(vehicle)
			local pis = assert(vehicle:getComponent(Berlin_PIS));
			pis:setDestination(EDestinationDisplayData.CustomTextDontEnter, "", serviceDisplay);
		end);
		return;
	end;

	local timetablePIS, message	= map:getTimetablePISFromElaCode(elaOrientation, self.elaDeviceNo[1], self.routeId);

	self:loginResponse(timetablePIS ~= nil);
	if self:wasAskedByTask(false) then
		return;
	end;

	trainComposition:onPISInfoUpdated(timetablePIS and timetablePIS:getTimetablePIS() or nil, 1, true);
end;

function SampleMod_Berlin_ELA:logOff()
	-- just remove the PIS timetable
	local trainComposition		= self.cab:getVehicle():getTrainComposition();
	trainComposition:onPISInfoUpdated(nil, 1, true);
end;

--- Returns if the player was asked by a task to do an ELA login (if `logoff` is `false`) or an ELA logout (if `logoff` is `true`)
---@param logoff boolean
---@return boolean
function SampleMod_Berlin_ELA:wasAskedByTask(logoff)
	if g_scenario.currentTask == nil then
		return false;
	end;
	local elaTask			= g_scenario.currentTask:cast(TaskEnterELACode);
	if elaTask == nil then
		return false;
	end;
	return true;
end;

--- Plays a sound as response to the successful / failed login
---@param successful boolean
function SampleMod_Berlin_ELA:loginResponse(successful)
	if successful then
		printf("[SampleMod_Berlin_ELA] ELA Login was successful (%d)", self.routeId);
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Enter"], 1);
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Error"], 0);
		GameplayStatics.spawnSound2D("/SubwaySim_Berlin/Vehicles/A3L92/Audio/Misc/ELA_beep.ELA_beep");
	else
		printf("[SampleMod_Berlin_ELA] ELA Login was not successful (%d)", self.routeId);
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Enter"], 0);
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Error"], 1);
		GameplayStatics.spawnSound2D("/SubwaySim_Berlin/Vehicles/A3L92/Audio/Misc/ELA_beep_routeFinished.ELA_beep_routeFinished");
	end
end;

--- Returns the current vehicle location and direction (in terms of station, platform and direction)
---@return Station? station
---@return string platformNo
---@return 1|2 direction
function SampleMod_Berlin_ELA:getLocation()
	local station, platform	= self.vehicle:getCurrentStation();
	if station == nil or platform == nil then
		return nil, "", 1;
	end;

	-- let's find out in which direction our cab is pointing
	local trainComposition		= self.vehicle:getTrainComposition();

	-- find the last signal that was set for this route
	local nextSignal			= g_controlCenter:getNextSignalAlongRoute(trainComposition);
	if nextSignal == nil then
		return nil, "", 1;
	end;

	-- using the signal's forward seems a bit weird, but is actually okay because we assume
	-- that there is a signal directly after every station.
	local s_location, s_forward	= nextSignal:getLocation();

	-- check if these are aligned with the platform
	local platformDirection		= (platform.platformEnd - platform.platformBegin):normalized();
	local direction				= ifelse(Vector3.dotProduct(s_forward, platformDirection) >= 0, 1, 2);

	return station, tostring(platform.number), direction;
end;

function SampleMod_Berlin_ELA:onSpeakerButton()
	if not self.SampleMod_A3L92CabModule:isActiveCab() then
		return;
	end;
	self.elaSpeakerActive		= true;
end;

--- Called by BaseCab upon activating the cab
function SampleMod_Berlin_ELA:onCabActivated()
	-- do not turn ELA on if this vehicle is AI controlled
	if self.vehicle:getIsAIControlled() or self.vehicle.isVirtual then
		if self.vehicle:getIsAIControlled() then
			self:onAiCabActivated();
		end
		return;
	end;
end;

--- Called by BaseCab upon deactivating the cab
function SampleMod_Berlin_ELA:onCabDeactivated()
	self.elaAnnouncement 			= false;
	self.elaAnnouncementAutomatic	= false;
	self.elaSpeakerActive			= false;
end;

function SampleMod_Berlin_ELA:onAiCabActivated()
	local routeId = 0;
	local trainComposition		= self.vehicle:getTrainComposition();
	local timetable = trainComposition:getTimetable();
	local map					= g_scenario.map:cast(MapBerlin);
	if timetable == nil or map == nil then

	else
		routeId = map:getRouteId(timetable);
	end;

	self.routeId 		= routeId;
	self.enteredRouteId = self.routeId;


	local routeString = string.format("%04d", self.routeId);
	for n = 1, 4, 1 do
		local digitChar = routeString:sub(n, n)
		self.elaDeviceNo[n] = tonumber(digitChar);
	end;

	self:updateMaterial();
end

--- Tick function
---@param dt number delta time [seconds]
function SampleMod_Berlin_ELA:update(dt)
	--if not self.isOn or self.vehicle.isVirtual then
	if self.vehicle.isVirtual and self.elaDevice == nil then
		return;
	end;

	MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["L"], ifelse(self.elaSpeakerActive, 1, 0));

	if self.elaAnnouncementAutomatic then
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["ET/ZP"], 1);
	elseif self.elaAnnouncement then
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["ET/ZP"], ifelse((getTime() % 1) < 0.5, 1, 0));
	else
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["ET/ZP"], 0);
	end;

	local berlin_pis = self.vehicle:getComponent(Berlin_PIS);
	if berlin_pis == nil then
		return;
	end;
	if berlin_pis.isTerminatingAnnouncement then
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Enter"], ifelse((getTime() % 1) < 0.5, 1, 0));
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["ET/ZP"], 0);
	else
		MaterialInstanceDynamic.setScalar(self.elaDevice.elaLightsMID, self.elaLightsSlots["Enter"], 0);
	end;
end;

--- This is called any time the train composition's timetable has changed
---@param newTimetable Timetable?
function SampleMod_Berlin_ELA:onTimetableChanged(newTimetable)
	if not self.vehicle:getIsAIControlled() then
		return;
	end;
	
	local map					= g_scenario.map:cast(MapBerlin);
	if newTimetable == nil or map == nil then
		self.routeId		= 0;
		return;
	end;

	self.routeId			= map:getRouteId(newTimetable);
end;

--- Function to focus the given button in instruction HUD
---@param buttonName string
---@return BaseInteractable interactable?
function SampleMod_Berlin_ELA:getButton(buttonName)
	return self.cab.interactables[buttonName];
end;