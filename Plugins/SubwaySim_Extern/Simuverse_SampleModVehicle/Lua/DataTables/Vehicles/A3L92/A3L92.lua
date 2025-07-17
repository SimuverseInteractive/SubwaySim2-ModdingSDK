--
--
-- SubwaySim
-- Module A3L92.lua
--
-- A3L92 data table
--
--
-- Author:	Barnabas Tamas-Nagy
-- Date:	06/05/2024
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

InitializeClassReference("Berlin_PIS",						Berlin_PIS);
InitializeClassReference("SampleMod_Berlin_ELA",						SampleMod_Berlin_ELA);
InitializeClassReference("TaskEnterELACode",				TaskEnterELACode);
InitializeClassReference("TaskEnterCab",					TaskEnterCab);
InitializeClassReference("TaskActivateCab",					TaskActivateCab);
InitializeClassReference("A3L92_TaskActivateCab",			A3L92_TaskActivateCab);
InitializeClassReference("TaskCloseDoors",					TaskCloseDoors);
InitializeClassReference("TaskOpenDoors",					TaskOpenDoors);
InitializeClassReference("TaskApplyParkingBrake",			TaskApplyParkingBrake);
InitializeClassReference("TaskReleaseParkingBrake",			TaskReleaseParkingBrake);
InitializeClassReference("TaskActivateFahrsperre",			TaskActivateFahrsperre);
InitializeClassReference("Berlin_TaskDispatchDeparture",	Berlin_TaskDispatchDeparture);
InitializeClassReference("Berlin_TaskDispatchArrival",		Berlin_TaskDispatchArrival);
InitializeClassReference("A3L92_AudioComponent",			A3L92_AudioComponent);
InitializeClassReference("Berlin_A3L92_VehicleDoor",		Berlin_A3L92_VehicleDoor);

--- signal lights
InitializeClassReference("TaskSignalLights",				TaskSignalLights);
InitializeClassReference("TaskSignalLightsSplit",			TaskSignalLightsSplit);
InitializeClassReference("TaskSignalLightsCouple",			TaskSignalLightsCouple);

---@param soundName  string
---@return string path
local function getSound(soundName)
	---@type table<string, string>
	local sounds = {
		["e1"] 						= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_e1.bremsschalter_e1",
		["e2"] 						= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_e2.bremsschalter_e2",
		["e3"] 						= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_e3.bremsschalter_e3",
		["e4"] 						= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_e4.bremsschalter_e4",
		["isolate"]					= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_abschluss.bremsschalter_abschluss",
		["driver"]					= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_fahren.bremsschalter_fahren",
		["release"]					= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter_loesen.bremsschalter_loesen",
		["airBrake"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter-2.bremsschalter-2",
		["fastBrake"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/bremsschalter.bremsschalter",

		["driveController"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/fahrschalter.fahrschalter",
		["driveController0"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/fahrschalter_0.fahrschalter_0",

		["key"]						= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/schloss.schloss",

		["lvThrottle0"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/fahrtaster_0.fahrtaster_0",
		["lvThrottle50"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/fahrtaster_halb.fahrtaster_halb",
		["lvThrottle100"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/fahrtaster_voll.fahrtaster_voll",

		["lvSifaDown"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/handsifa_an.handsifa_an",
		["lvSifaUp"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Levers/handsifa_aus.handsifa_aus",

		["sifaDown"] 				= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/fusssifa_an.fusssifa_an",
		["sifaUp"] 					= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/fusssifa_aus.fusssifa_aus",

		["sw"]						= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/drehschalter2.drehschalter2",
		["swSnapin"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/SC_swSnapin.SC_swSnapin",

		["btnDown"]					= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/SC_btnDown.SC_btnDown",
		["btnUp"]					= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/SC_btnUp.SC_btnUp",

		["elaBtnDown"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/ELA_button_down.ELA_button_down",
		["elaBtnUp"]				= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/ELA_button_up.ELA_button_up",

		["elaCoderBtnDown"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/ELA_coder_button_down.ELA_coder_button_down",
		["elaCoderBtnUp"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/ELA_coder_button_up.ELA_coder_button_up",

		["couplingDoorOpen"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/begleiterschrank_auf.begleiterschrank_auf",
		["couplingDoorClosed"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/begleiterschrank_zu.begleiterschrank_zu",

		["SideCabDoorOpen"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_auf.tuer_auf",
		["SideCabDoorClosed"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_zu.tuer_zu",

		["BackCabDoorOpen"]			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_hinten_auf.tuer_hinten_auf",
		["BackCabDoorClosed"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_hinten_zu.tuer_hinten_zu",

		["FrontCabDoorOpen"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_vorne_auf.tuer_vorne_auf",
		["FrontCabDoorClosed"]		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/tuer_vorne_zu.tuer_vorne_zu",
	};
	local path = sounds[soundName];
	if path == nil then
		debugprint("[A3L92] sound for %s does not exists", soundName);
		return "";
	end;

	return path;
end;

---@param index integer
---@param direction -1|1
---@return InteractableButton_Data_Cab 
local function getElaCoder(index, direction)

	local upText = {
		"$Berlin_ia_ELA_Coder_Up1",
		"$Berlin_ia_ELA_Coder_Up2",
		"$Berlin_ia_ELA_Coder_Up3",
		"$Berlin_ia_ELA_Coder_Up4",
	};
	local downText = {
		"$Berlin_ia_ELA_Coder_Down1",
		"$Berlin_ia_ELA_Coder_Down2",
		"$Berlin_ia_ELA_Coder_Down3",
		"$Berlin_ia_ELA_Coder_Down4",
	};
	--- up is 1 and down is -1
	local _name 			= ifelse(direction==1, upText[index], downText[index]);
	
	--- up is -1 and down is 1
	local _directionText 	= ifelse(direction==-1, "up", "down");
	---@type InteractableButton_Data_Cab 
	local _elaCoder = {
		boneName		= "Btn_ELA_Coder_".._directionText..index,
		name			= _name,
		posePressed 	= Transform:new(Vector3:new(-0.001,0,0), Vector3:new(0,0,0)),
		downSound		= getSound("elaCoderBtnDown"),
		upSound			= getSound("elaCoderBtnUp"),
		callback		= function(cab, isDown, pressDuration)
			if isDown then
				cab:callEvent("onButtonPressed", index, direction);
			else
				cab:callEvent("onButtonReleased", index, direction);
			end;
		end,
	};

	return _elaCoder;
end;

---@param meshName string
---@param socketName string
---@param instanceIndex integer
---@param side -1|1 left or right side
---@return RailVehicle_Seat_DataTable table
local function seat(meshName, socketName, instanceIndex, side)
	---@type RailVehicle_Seat_DataTable
	local seat = {
		mesh = meshName,
		socketName = socketName,
		seatOffset = Vector3:new(0, -0.10* side, -0.40),
		instanceIndex = instanceIndex,
	};
	return seat;
end;

--- Generates the data table for the status light
---@param type RVDM_StatusLightType type of the status light
---@param materialParam string material parameter name
---@param doors integer[] list of affected door indices
---@return RVDM_StatusLight_DataTable
local function statusLight(type, materialParam, doors)
	---@type RVDM_StatusLight_DataTable
	return {
		-- Status Light LEFT coach 1
		mesh			= "Exterior",
		materialSlot	= "A3L92-ExteriorLights",
		type			= type,
		materialParams	= {
			[materialParam] = 5,
		},
		doorList		= doors,
	};
end;

--- Generates the data table for the door with the given skeletal mesh name
---@param audioComponentName string
---@param index integer
---@param doorSide RVDM_DoorSide
---@param exteriorEmissiveSlots table<string, number>
---@param interiorEmissiveSlots table<string, number>
---@param isPRMDoor boolean? Is this a door for passengers with reduced mobility?
---@return VehicleDoor_DataTable
local function door(audioComponentName, index, doorSide, exteriorEmissiveSlots, interiorEmissiveSlots, isPRMDoor)

	local side = ifelse(doorSide == RVDM_DoorSide.Left, "L", "R");
	---@type VehicleDoor_DataTable
	return {
		doorMeshes			= {
			{
				skeletalMesh 		= "Exterior",
				lightMaterialSlot 	= "A3L92-ExteriorLights",
				doorCloserSlots 	= exteriorEmissiveSlots,
			},
			{
				skeletalMesh 		= "Interior",
				lightMaterialSlot 	= "A3L92-InteriorLights",
				doorCloserSlots 	= interiorEmissiveSlots,
			},
		},
		animationPath		= "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_PDoor"..index..side.."Open.A3L92_Anims_PDoor"..index..side.."Open",
		animationLength		= 2.0,
		animNameABP			= "PassengerDoors"..index..side,
		side				= doorSide,
		durationOpen		= 2.0,
		durationClose		= 3.0,
		soundStopTime		= 7.0,
		animCloseWaitTimer	= 1.7,
		soundCloseWaitTimer	= -1.7,
		audioComponent		= audioComponentName,
		exteriorLocation	= Vector3:new(0, 1.8 * doorSide, 0),
		interiorLocation	= Vector3:new(0, 0, 0),
		isAccessibleAccess 	= getNoNil(isPRMDoor, false),
		closeSound 			= "",
		openSound 			= "",
		endSound 			= "",
		beepSound 			= "",
		fastBeepSound 		= "",
		doorLocSocketName	= "Socket_PDoor"..index,
		interactables 		= {
			doors = {
				doorL_exterior = {
					name = "$HHA_DT5_ia_OpenPaDoor",
					boneName = "PDoor"..index.."-1"..side,
					skeletalMesh = "Exterior",
					callback = function (vehicleDoor, isDown)
						if isDown then
							vehicleDoor:canEnter(true);
						end;
					end;
				},
				doorL_interior = {
					name = "$HHA_DT5_ia_OpenPaDoor",
					boneName = "PDoor"..index.."-1"..side,
					skeletalMesh = "Interior",
					callback = function (vehicleDoor, isDown)
						if isDown then
							vehicleDoor:canEnter(true);
						end;
					end;
				},
				doorR_exterior = {
					name = "$HHA_DT5_ia_OpenPaDoor",
					boneName = "PDoor"..index.."-2"..side,
					skeletalMesh = "Exterior",
					callEveryFrame = true,
					callback = function (vehicleDoor, isDown)
						if isDown then
							vehicleDoor:canEnter(true);
						end;
					end;
				},
				doorR_interior = {
					name = "$HHA_DT5_ia_OpenPaDoor",
					boneName = "PDoor"..index.."-2"..side,
					skeletalMesh = "Interior",
					callEveryFrame = true,
					callback = function (vehicleDoor, isDown)
						if isDown then
							vehicleDoor:canEnter(true);
						end;
					end;
				},
			},
			-- btnCloseDoor = {
			-- 	btnClose = {
			-- 		name = "$HHA_DT5_ia_ClosePaDoor",
			-- 		boneName = "Button_DoorClose"..index..side,
			-- 		callEveryFrame = true,
			-- 		downSound = "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/DT-5_ButtonClick.DT-5_ButtonClick",
			-- 		upSound = "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/DT-5_ButtonRelease.DT-5_ButtonRelease",
			-- 		posePressed = Transform:new(Vector3:new(-0.001,0,0), Vector3:new(0,0,0)),
			-- 		callback = function (self, isDown, pressDuration)
			-- 			if isDown then
			-- 				if pressDuration > 1.2 then
			-- 					self:closeDoorSoftly(true);
			-- 				end;
			-- 			elseif self.isUnlocked and self.animTimeCurrent > 0.1 then
			-- 				self:openDoor();
			-- 			end;
			-- 		end;
			-- 	},
			-- },
		},
	};
end;

--- Callback function for door unlocking buttons
---@param cab BaseCab
---@param isDown boolean
---@param pressDuration number
---@param side RVDM_DoorSide
function A3L92_unlockDoors(cab, isDown, pressDuration, side)
	if not isDown then
		return;
	end;

	side					= side * cab:getCabOrientation();
	-- Doors on one side can only be unlocked if either
	-- a) doors on the other side are still locked
	-- b) there is no active cab
	local doorManager		= cab.railVehicle:getComponent(DoorManager);
	cab.railVehicle:getTrainComposition():foreachVehicle(function(vehicle) vehicle:getComponent(DoorManager):unlockDoors(side); end);
end;

--- Checks if doors are unlocked, used to control the emissive state
---@param cab BaseCab
---@param side RVDM_DoorSide
---@return boolean
function A3L92_isUnlockedDoors(cab, side)
	side					= side * cab:getCabOrientation();
	local doorManager		= cab.railVehicle:getComponent(DoorManager);

	if doorManager == nil then
		return false;
	end;

	return doorManager:areDoorsUnlocked(side);
end;

--- Checks if doors are unlocked, used to control the emissive state
---@param cab BaseCab
---@return boolean
function A3L92_isClosedDoors(cab)
	-- check all vehicles
	for n, vehicle in ipairs(cab.railVehicle:getTrainComposition():getVehicles()) do
		local doorManager		= vehicle:getComponent(DoorManager);
		if doorManager and not doorManager:areDoorsClosed(true) then
			return false;
		end;
	end;
	return true;
end;


--- Generates the data table for the given cab
---@return RailVehicle_DataTable_CabData
local function cab()

	---@class RailVehicle_DataTable_CabData : A3L92CabModule_DataTable
	---@type RailVehicle_DataTable_CabData
	return {
		cabModules		= { SampleMod_A3L92CabModule, SampleMod_Berlin_ELA, Berlin_Fahrsperre, Sifa, },
		interiorCamera	= {
			cameraName	= "CabCamera",
		},
		skeletalMesh	= "Cab",
		driverCharacter	= {
			driverName = "Driver",
		},
		leaveLocation	= "LeaveLocation",
		seatBone		= "Seat",
		sifa = {
			audioComponent 	= "Sifa_Audio",
			sifaSoundPath 	= "/Simuverse_SampleModVehicle/HK/Audio/Misc/DT5SifaBeep.DT5SifaBeep",
		},
		---@type Berlin_Fahrsperre_DataTable
		fahrsperre = {
			materialSlotCounter1	= "A3L92-Fahrsperre1",
			materialSlotCounter2	= "A3L92-Fahrsperre2",
		},
		isForward		= true,
		interactables	= {
			levers 			= {
				leverThrottle	= {
					boneName	= "Btn_Throttle",
					name		= "$Berlin_ia_CabThrottleButton",
					--axisName	= "Cab_lvThrottle",
					poseMin		= Transform:new(Vector3:new(0,0,0),		Vector3:new(0,0,0)),
					poseMax		= Transform:new(Vector3:new(-0.016,0,0),	Vector3:new(0,0,0)),
					interactableDirection = Vector3:new(0,0,-0.05),
					positions	= {
						{
							name			= "$Berlin_ia_CabThrottleLeverAcc0",
							value			= 0.0,
							thresholdArrive	= 0.0,
							thresholdLeave	= 0.0,
							deadzone		= 0.5,
							audio			= getSound("lvThrottle0"),
						},
						{
							name			= "$Berlin_ia_CabThrottleLeverAcc50",
							value			= 0.5,
							thresholdArrive	= 0.0,
							thresholdLeave	= 0.0,
							deadzone		= 0.5,
							audio			= getSound("lvThrottle50"),
							springDrag		= -1,
							inputKey		= "Cab_lvThrottleHalf",
						},
						{
							name			= "$Berlin_ia_CabThrottleLeverAcc100",
							value			= 1,
							thresholdArrive	= 0.0,
							thresholdLeave	= 0.0,
							deadzone		= 0.5,
							audio			= getSound("lvThrottle100"),
							springDrag		= -1,
							inputKey		= "Cab_lvThrottleUp",
						},
					},
					hidePoints			= true,
				},
				leverAFB	= {
					boneName 	= "Lever_AFB",
					name		= "$Berlin_ia_CabDriveController",
					defaultPosition	= 3,
					poseMin		= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0,-50)),
					poseMax		= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0, 50)),
					axisName	= "Cab_AFB",
					positions	= {
						-- we have to use a function for the name, because otherwise only the language while reading the data table is relevant
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerReverse", 25);		end,	value	= -0.25,	deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerReverse", 15);		end,	value	= -0.15,	deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerNeutral", 0);		end,	value	= 0, 		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController0"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerForward", 15);		end,	value	= 0.15,		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerForward",	25);	end, 	value	= 0.25,		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerForward",	40);	end, 	value	= 0.40,		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerForward",	50);	end, 	value	= 0.50,		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
						{	name	= function() return g_l10n:format("$Berlin_ia_CabDriveControllerForward",	60);	end, 	value	= 0.60,		deadzone	= 0.3, thresholdArrive	= 0.02, thresholdLeave = 0.02, audio = getSound("driveController"),},
					},
					interactableDirection = Vector3:new(0.05,0,0);
					hidePoints			= true,
					getValueInfo = function (lv, value)
						local positions = lv.positions;
						local lastPosition = positions[lv:getLastPosition()];
						assert(lastPosition);
						return lv:getPositionName(lastPosition);
					end,
				},
				leverBrake	= {
					axisName	= "Cab_lvBrake",
					boneName	= "Lever_Brake",
					name		= "$Berlin_ia_CabBrakeSwitch",
					poseMin		= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0,-50)),
					poseMax		= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0, 50)),
					defaultPosition	= 9,
					positions	= {
						{ 	name		= "$Berlin_ia_CabBrakeSwitchFastBrake", 	value = -1.4, 	deadzone	= 0.3, 	thresholdArrive	= 0.02, thresholdLeave	= 0.02, audio = getSound("fastBrake"),},
						---- -1.0: E-Brake fully active
						
						{	name		= "$Berlin_ia_CabBrakeSwitchAirBrake",		value = -1.20,	deadzone	= 0.3,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("airBrake"),},
						-- -1.0: E-Brake fully active
						{	name		= "E4",										value = -1.00,	deadzone	= 0.4,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("e4"),},
						{	name		= "E3",										value = -0.66,	deadzone	= 0.4,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("e3"),},
						{	name		= "E2",										value = -0.33,	deadzone	= 0.4,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("e2"),},
						{	name		= "E1",										value = 	0,	deadzone	= 0.4,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("e1"),},
						-- 0: E-Brake released

						{	name		= "$Berlin_ia_CabBrakeSwitchRelease",		value = 0.2, 	deadzone	= 0.3,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("release"),},
						{	name		= "$Berlin_ia_CabBrakeSwitchDrive",			value = 0.4, 	deadzone	= 0.3,	thresholdArrive	= 0.02,	thresholdLeave	= 0.02,	audio = getSound("driver"),},
						{	name		= "$Berlin_ia_CabBrakeSwitchIsolation",		value = 0.5, 	deadzone	= 0.3, 	thresholdArrive	= 0.02, thresholdLeave	= 0.02, audio = getSound("isolate"),},
					},
					interactableDirection = Vector3:new(0.05,0,0);
					hidePoints			= true,
				},
			},
			iaCabSeat		= {
				skeletalMesh = "Seat",
				boneName 	= "SeatCube",
				name		= "$HHA_DT5_ia_CabSeat",
				callback	= function(cab, isDown)
					if isDown and cab.currentUser == nil then
						cab:setCurrentUser(g_scenario.player);
					end;
				end,
			},
			agSpeed			= {
				boneName	= "Tachometer_Needle",
				valueMin	= 0,
				valueMax	= 90,
				poseMin		= Transform:new(Vector3.zero, Vector3:new(0, 0, 0)),
				poseMax		= Transform:new(Vector3.zero, Vector3:new(0, 240, 0)),
			},
			buttons 		= {
				btnLeverSifa = {
					boneName	= "Lever_Sifa",
					name		= "$ui_Settings_input_Cab_btnSifa_title",
					poseReleased 	= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0,5)),
					posePressed 	= Transform:new(Vector3:new(0,0,0), Vector3:new(0,0,-10)),
					downSound		= getSound("lvSifaDown"),
					upSound			= getSound("lvSifaUp"),
					callback		= function(cab, isDown, pressDuration)

					end,
					getInputInfo = function (cab, isDown)
						return ifelse(isDown, "pressed", "released");
					end,
				},
				btnSifa = {
					boneName		= "Btn_SifaFoot",
					name			= "$ui_Settings_input_Cab_btnSifa_title",
					key				= "Cab_btnSifa",
					downSound		= getSound("sifaDown"),
					upSound			= getSound("sifaUp"),
					callEveryFrame 	= true,
					poseReleased 	= Transform:new(Vector3:new(0,0,0), 		Vector3:new(0,0,0)),
					posePressed 	= Transform:new(Vector3:new(-0.0025,0,0), 	Vector3:new(0,0,0)),
					callback		= function(cab, isDown, pressDuration)
						cab:callEvent("onSifaPressed", isDown, pressDuration);
					end,
				},
				btnDoorsUnlockLeft = {
					boneName	= "Btn_UnlockDoorsLeft",
					name		= "$ui_Settings_input_Cab_btnDoorsUnlockLeft_title",
					key			= "Cab_btnDoorsUnlockLeft",
					posePressed = Transform:new(Vector3:new(-0.0025,0,0), Vector3:new(0,0,0)),
					downSound	= getSound("btnDown"),
					upSound		= getSound("btnUp"),
					callback	= function(cab, isDown, pressDuration)
						if isDown then
							A3L92_unlockDoors(cab, isDown, pressDuration, RVDM_DoorSide.Left);
						end;
					end,
					lightMaterialSlot = "A3L92-CabLights1",
					materialParameterSlots = {
						["Emissive12"] = 1,
					},
					getEmissiveState = function (cab, isDown, pressDuration)
						return A3L92_isUnlockedDoors(cab, RVDM_DoorSide.Left);
					end,
				},
				btnDoorsUnlockRight = {
					boneName	= "Btn_UnlockDoorsRight",
					name		= "$ui_Settings_input_Cab_btnDoorsUnlockRight_title",
					key			= "Cab_btnDoorsUnlockRight",
					posePressed = Transform:new(Vector3:new(-0.0025,0,0), Vector3:new(0,0,0)),
					downSound	= getSound("btnDown"),
					upSound		= getSound("btnUp"),
					callback	= function(cab, isDown, pressDuration)
						if isDown then
							A3L92_unlockDoors(cab, isDown, pressDuration, RVDM_DoorSide.Right);
						end;
					end,
					lightMaterialSlot = "A3L92-CabLights1",
					materialParameterSlots = {
						["Emissive14"] = 1,
					},
					getEmissiveState = function (cab, isDown, pressDuration)
						return A3L92_isUnlockedDoors(cab, RVDM_DoorSide.Right);
					end,
				},
				btnDoorsClose	= {
					boneName	= "Btn_CloseDoors",
					name		= "$HHA_DT5_ia_DoorsClose",
					key			= "Cab_btnDoorsClose",
					posePressed = Transform:new(Vector3:new(-0.0025,0,0), Vector3:new(0,0,0)),
					downSound	= getSound("btnDown"),
					upSound		= getSound("btnUp"),
					callback	= function(cab, isDown, pressDuration)
						if isDown then
							cab.railVehicle:getTrainComposition():foreachVehicle(function(vehicle) vehicle:getComponent(DoorManager):closeDoors(); end);
						end;
					end,
					lightMaterialSlot = "A3L92-CabLights1",
					materialParameterSlots = {
						["Emissive09"] = 2,	-- separate lamp
						["Emissive13"] = 2,	-- button
					},
					getEmissiveState = function (cab, isDown, pressDuration)
						return ifelse(A3L92_isClosedDoors(cab), 1, 0);
					end,
				},
				btnDoorsClose2	= {
					boneName	= "Btn_CloseDoorsExtra",
					name		= "$HHA_DT5_ia_DoorsClose",
					posePressed = Transform:new(Vector3:new(-0.0025,0,0), Vector3:new(0,0,0)),
					downSound	= getSound("btnDown"),
					upSound		= getSound("btnUp"),
					callback	= function(cab, isDown, pressDuration)
						if isDown then
							cab.railVehicle:getTrainComposition():foreachVehicle(function(vehicle) vehicle:getComponent(DoorManager):closeDoors(); end);
						end;
					end,
					lightMaterialSlot = "A3L92-CabLights2",
					materialParameterSlots = {
						["Emissive14"] = 2,	-- button
					},
					getEmissiveState = function (cab, isDown, pressDuration)
						return ifelse(A3L92_isClosedDoors(cab), 1, 0);
					end,
				},
				btnFahrsperre = {
					boneName	= "Btn_TrainProtection",
					name		= "$Berlin_ia_Fahrsperre",
					key			= "Cab_btnFahrsperre",
					posePressed	= Transform:new(Vector3:new(-0.0025,0,0), Vector3:new(0,0,0)),
					downSound	= getSound("btnDown"),
					upSound		= getSound("btnUp"),
					lightMaterialSlot = "A3L92-CabLights1",
					materialParameterSlots = {
						["Emissive04"] = 5,
					},
					getEmissiveState = function (cab, isDown, pressDuration)
						local fsp = cab:getModule(Berlin_Fahrsperre);
						if fsp then
							return fsp:getButtonState();
						end;
						return false;
					end,
					callback	= function(cab, isDown, pressDuration)
						cab:getModule(Berlin_Fahrsperre):onBtnPressed(isDown);
					end,
				},
				btnHorn			= {
					boneName	= "Btn_Horn",
					name		= "$ui_Settings_input_Cab_btnHorn_title",
					key			= "Cab_btnHorn",
					posePressed = Transform:new(Vector3:new(-0.005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("btnDown"),
					upSound			= getSound("btnUp"),
					callEveryFrame	= true,
					callback	= function(cab, isDown, pressDuration)
						local audioManager = cab.railVehicle:getComponent(A3L92_AudioComponent);
						if audioManager ~= nil then
							audioManager:setHornState(isDown);
						end;
					end,
				},
				btnCabLight = {
					boneName		= "Switch_LightCab",
					name			= "$HHA_DT5_ia_CabLight",
					key				= "Cab_btnToggleCabLight",
					posePressed 	= Transform:new(Vector3:new(0,0,0), Vector3:new(-30,0,0)),
					poseReleased 	= Transform:new(Vector3:new(0,0,0), Vector3:new(30,0,0)),
					downSound		= getSound("btnDown"),
					upSound			= getSound("btnUp"),
					isToggleButton = true,
					callback		= function(cab, isDown, pressDuration)
						--if isDown then
							local lightManager = cab.railVehicle:getComponent(LightManager);
							if lightManager ~= nil then
								lightManager:setCabLightState(cab, isDown);
							end;
						--end;
					end,
					getInputInfo = function (cab, isDown)
						local lightManager = cab.railVehicle:getComponent(LightManager);
						if lightManager == nil then
							return nil;
						end;
						return ifelse(lightManager:getCabLightState(cab), "$Berlin_ia_CabInteractableOn", "$Berlin_ia_CabInteractableOff");
					end,
				},
				-- btnPassengerLight = {
				-- 	boneName		= "Switch_LightInterior",
				-- 	name			= "$HHA_DT5_ia_CabLight",
				-- 	key				= "Cab_btnToggleCabLight",
				-- 	posePressed 	= Transform:new(Vector3:new(0,0,0), Vector3:new(-0.005,0,0)),
				-- 	downSound		= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/DT-5_ButtonClick.DT-5_ButtonClick",
				-- 	upSound			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/DT-5_ButtonRelease.DT-5_ButtonRelease",
				-- 	isToggleButton = true,
				-- 	-- callback		= function(cab, isDown, pressDuration)
				-- 	-- 	local lightManager = cab.railVehicle:getComponent(LightManager);
				-- 	-- 	if lightManager ~= nil then
				-- 	-- 		lightManager:setCabLight(cab, isDown);
				-- 	-- 	end;
				-- 	-- end,
				-- 	-- getInputInfo = function (cab, isDown)
				-- 	-- 	local lightManager = cab.railVehicle:getComponent(LightManager);
				-- 	-- 	if lightManager ~= nil then
				-- 	-- 		lightManager:getCabLightState(cab);
				-- 	-- 	end;
				-- 	-- 	return nil;
				-- 	-- end,
				-- },
				btnElaCoderUp1		= getElaCoder(1, 1),
				btnElaCoderUp2		= getElaCoder(2, 1),
				btnElaCoderUp3		= getElaCoder(3, 1),
				btnElaCoderUp4		= getElaCoder(4, 1),

				btnElaCoderDown1	= getElaCoder(1, -1),
				btnElaCoderDown2	= getElaCoder(2, -1),
				btnElaCoderDown3	= getElaCoder(3, -1),
				btnElaCoderDown4	= getElaCoder(4, -1),

				btnElaCoderEnter	= {
					boneName		= "Btn_ELA_E",
					name			= "$Berlin_ia_ELA_Enter",
					posePressed = Transform:new(Vector3:new(-0.0005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("elaBtnDown"),
					upSound			= getSound("elaBtnUp"),
					callback		= function(cab, isDown, pressDuration)
						if isDown then
							cab:callEvent("onButtonEnter");
						end;
					end,
				},
				btnAnnouncementToBoard	= {
					boneName		= "Btn_ELA_ET",
					name			= "$Berlin_ia_CabAnnouncement_Board",
					key				= "Cab_AnnouncementToBoard",
					posePressed = Transform:new(Vector3:new(-0.0005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("elaBtnDown"),
					upSound			= getSound("elaBtnUp"),
					callback		= function(cab, isDown, pressDuration)
						if isDown then
							cab:callEvent("onButtonAnnouncementToBoard");
						end;
					end,
				},
				btnAnnouncementStandBack = {
					boneName	= "Btn_ELA_ZP",
					name		= "$Berlin_ia_CabAnnouncement_StandBack",
					key			= "Cab_AnnouncementStandBack",
					posePressed = Transform:new(Vector3:new(-0.0005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("elaBtnDown"),
					upSound			= getSound("elaBtnUp"),
					callback	= function(cab, isDown, pressDuration)
						if isDown then
							cab.railVehicle:getComponent(Berlin_PIS):playDispatchAnnouncement("/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/General_DoNotEnter.General_DoNotEnter");
						end;
					end,
				},
				btnSpeakerInterior = {
					boneName	= "BTN_ELA_L",
					name		= "$ui_Settings_input_Cab_btnSpeakerInside_title",
					posePressed = Transform:new(Vector3:new(-0.0005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("elaBtnDown"),
					upSound			= getSound("elaBtnUp"),
					callback	= function(cab, isDown, pressDuration)
						local pis = cab.railVehicle:getComponent(Berlin_PIS);
						if pis ~= nil then
							pis:onSpeakerButton(EPIS_SpeakerType.Interior, isDown);
						end;
						if isDown then
							local ela = cab:getModule(SampleMod_Berlin_ELA);
							if ela ~= nil then
								ela:onSpeakerButton();
							end;
						end;
					end,
				},
				btnSpeakerRadio = {
					boneName	= "BTN_ELA_F",
					name		= "$ui_Settings_input_Cab_btnSpeakerRadio_title",
					posePressed = Transform:new(Vector3:new(-0.0005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("elaBtnDown"),
					upSound			= getSound("elaBtnUp"),
					callback	= function(cab, isDown, pressDuration)
						local pis = cab.railVehicle:getComponent(Berlin_PIS);
						if pis ~= nil then
							pis:onSpeakerButton(EPIS_SpeakerType.Radio, isDown);
						end;
					end,
				},
				btnParkingBrakeApply	= {
					boneName	= "Btn_ApplyParkingBrake",
					name		= "$Berlin_ia_ParkingBrakeApply",
					key			= "Cab_btnParkingBrakeApply",
					posePressed	= Transform:new(Vector3:new(-0.005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("btnDown"),
					upSound			= getSound("btnUp"),
					callback	= function(cab, isDown)
						if isDown and cab.railVehicle:getCurrentWheelSpeed(true) < 5 then
							cab.railVehicle.trainComposition:foreachVehicle(function(vehicle)
								-- only control brake spring loaded of remote-controlled vehicles
								vehicle:callBrakeFunction(BrakeSpringLoaded, "setActive", true);
							end);
						end;
					end,
				},
				btnParkingBrakeRelease	= {
					boneName	= "Btn_ReleaseParkingBrake",
					name		= "$Berlin_ia_ParkingBrakeRelease",
					key			= "Cab_btnParkingBrakeRelease",
					posePressed	= Transform:new(Vector3:new(-0.005,0,0), Vector3:new(0,0,0)),
					downSound		= getSound("btnDown"),
					upSound			= getSound("btnUp"),
					callback	= function(cab, isDown)
						if isDown and cab.railVehicle:getCurrentWheelSpeed(true) < 5 then
							cab.railVehicle.trainComposition:foreachVehicle(function(vehicle)
								-- only control brake spring loaded of remote-controlled vehicles
								vehicle:callBrakeFunction(BrakeSpringLoaded, "setActive", false);
							end);
						end;
					end,
				},
				btnCouplingDoor		= {
					boneName		= "DoorDecoupler",
					name			= "$Berlin_ia_Flap_Open",
					posePressed		= Transform:new(Vector3:new(0,0,0), 	Vector3:new(-90,0,0)),
					poseReleased	= Transform:new(Vector3:new(0,0,0), 	Vector3:new(0,0,0)),
					isToggleButton 	= true,
					downSound		= getSound("couplingDoorOpen"),
					upSound			= getSound("couplingDoorClosed"),
					speed			= 2,
					callback		= function(cab, isDown)
						-- TODO
					end,
				},
				btnDecoupling		= {
					boneName		= "DecouplerArm",
					name			= "$HHA_DT5_ia_TrainSeparate",
					posePressed		= Transform:new(Vector3:new(0,0,0), 	Vector3:new(0,0,10)),
					poseReleased	= Transform:new(Vector3:new(0,0,0), 	Vector3:new(0,0,0)),
					downSound		= getSound("btnDown"),
					upSound			= getSound("btnUp"),
					callback		= function(cab, isDown)
						if isDown then
							cab:detachVehicle(true);
						end;
					end,
				},
			},
			switches		= {
				swActivateCab	= {
					boneName 	= "Cab_Key",
					name 		= "$Berlin_ia_CabKey",
					defaultPosition	= 1,
					keyDown		= "Cab_swDeactivateCab",
					keyUp		= "Cab_swActivateCab",
					axis		= 1,
					positions	= {
						{
							name	= "$HHA_DT5_ia_CabInactive",
							angle	= 0,
							sound	= getSound("key"),
						},
						{
							name	= "$HHA_DT5_ia_CabActive",
							angle	= 90,
							sound	= getSound("key"),
						},
					},
					callback	= function(cab, position)
						cab:activate(position == 2);
					end,
					interactableDirection = Vector3:new(0, 0.05, 0);
				},
				swWiper	= {
					boneName 	= "Switch_Wiper",
					name 		= "$HHA_DT5_DMI_Windscreen_TitleWiper",
					defaultPosition	= 2,
					axis		= 1,
					keyDown		= "Cab_btnWiperLeft",
					keyUp		= "Cab_btnWiperRight",
					positions	= {
						{
							name	= "$Berlin_Windscreen_IntervalWiping",
							angle	= 30,
							sound	= getSound("sw"),
						},
						{
							name	= "$HHA_DT5_DMI_Windscreen_Off",
							angle	= 0,
							sound	= getSound("sw"),
						},
						{
							name	= "$HHA_DT5_DMI_Windscreen_ContinuousWiping",
							angle	= -30,
							sound	= getSound("sw"),
						},
					},
					callback	= function(cab, position)
						local weatherComponent = cab.railVehicle:getComponent(WeatherComponent);
						if weatherComponent ~= nil then
							weatherComponent:setStateForWipers(weatherComponent:getWipersOfDirection(cab.cabOrientation), position	~= 2, position	== 1);
						end;
					end,
					interactableDirection = Vector3:new(-0.05, 0, 0),
					hidePoints = true;
				},
				swSignalLeft	= {
					boneName 	= "Switch_HeadlightLeft",
					name 		= "$Berlin_ia_CabSignalLightsLeft",
					defaultPosition	= 1, -- per default red lights
					axis		= 1,
					positions	= {
						{
							name	= "$Berlin_ia_CabSignalLightsRed",
							angle	= -30,
						},
						{
							name	= "$Berlin_ia_CabSignalLightsOff",
							angle	= 0,
						},
						{
							name	= "$Berlin_ia_CabSignalLightsWhite",
							angle	= 30,
						},
					},
					callback	= function(cab, position)
						local lightManger 		= cab.railVehicle:getComponent(LightManager);
						local cabOrientation 	= cab.cabOrientation;
						if lightManger ~= nil then
							lightManger:setHeadLightState(cabOrientation, 	ifelse(position == 3, EHeadlightState.Signal, EHeadlightState.Off), nil, 1);
							lightManger:setTailLightState(-cabOrientation, 	position==1, nil, 1);
						end;
					end,
					interactableDirection = Vector3:new(0, 0.01, 0),
				},
				swSignalRight	= {
					boneName 	= "Switch_HeadlightRight",
					name 		= "$Berlin_ia_CabSignalLightsRight",
					defaultPosition	= 1,
					axis		= 1,
					positions	= {
						{
							name	= "$Berlin_ia_CabSignalLightsRed",
							angle	= -30,
						},
						{
							name	= "$Berlin_ia_CabSignalLightsOff",
							angle	= 0,
						},
						{
							name	= "$Berlin_ia_CabSignalLightsWhite",
							angle	= 30,
						},
					},
					callback	= function(cab, position)
						local lightManger 		= cab.railVehicle:getComponent(LightManager);
						local cabOrientation 	= cab.cabOrientation;
						if lightManger ~= nil then
							lightManger:setHeadLightState(cabOrientation, 	ifelse(position == 3, EHeadlightState.Signal, EHeadlightState.Off), nil, 2);
							lightManger:setTailLightState(-cabOrientation, 	position==1, nil, 2);
						end;
					end,
					interactableDirection = Vector3:new(0, 0.01, 0),
				},

			},
		},
		---@type A3L92CabModule_DataTable
		SampleMod_A3L92CabModule = {
			agFeedPipe = {
				boneName	= "PressureGaugeNeedle1",
				valueMin	= 0,
				valueMax	= 10,
				poseMin		= Transform:new(Vector3.zero, Vector3:new(0, 0, 0)),
				poseMax		= Transform:new(Vector3.zero, Vector3:new(0, 266, 0)),
			},
			agControlPipe = {
				boneName	= "PressureGaugeNeedle2",
				valueMin	= 0,
				valueMax	= 10,
				poseMin		= Transform:new(Vector3.zero, Vector3:new(0, 0, 0)),
				poseMax		= Transform:new(Vector3.zero, Vector3:new(0, 266, 0)),
			},
			agVoltMeter		= {
				boneName	= "Voltmeter_Arrow",
				valueMin	= 0,
				valueMax	= 150,
				poseMin		= Transform:new(Vector3.zero, Vector3:new(0, 0, 0)),
				poseMax		= Transform:new(Vector3.zero, Vector3:new(0, 0, 45)),
			},
		},
		---@type ELA_Device_DataTable
		ELADevice = {
			elaDeviceMesh 			= "Cab",
			elaCoderMaterialSlot 	= "A3L92-DigitsVertical",
			elaLightsMaterialSlot 	= "A3L92-CabLights3",
		},
	};
end;


---@class Berlin_A3L92_DataTable : RailVehicle_DataTable, A3L92Component_DataTable
---@type Berlin_A3L92_DataTable
local A3L92_S = {
	contentType		= "railVehicle",
	contentName		= "Berlin_SampleModVehicle_S",

	title			= "A3L92 (S-Wagen)",
	author			= "$GameDeveloper",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	emptyMass			= 37.4,
	vmax				= 60,

	length				= 12.83,
	frontToFirstBogie	= 2.63,
	rearToLastBogie		= 2.63,

	maxEnginePower		= 712,
	maxEngineForce		= 47,
	engineDelay			= 3,

	blueprintFilename	= "/Simuverse_SampleModVehicle/A3L92/BP_A3L92.BP_A3L92",

	couplingFront		= {
		rotationOrigin	= "Coupling_F",
		couplingOffset	= 1.08073,
		automaticCoupling	= true,
		skeletalMesh = "Exterior",
		couplingBoneName = "Coupling1Rotation",
	},
	couplingRear		= {
		rotationOrigin	= "Coupling_B",
		couplingOffset	= 1.08073,
		automaticCoupling	= true,
		skeletalMesh = "Exterior",
		couplingBoneName = "Coupling2Rotation",
	},

	brakingSystems		= {
		pneumatic5bar	= {
			maxBrakeForce	= 60,
			pumpSpeed		= 1.6,
		},
		pneumaticDirect	= {
			maxBrakeForce	= 80,
		},
		electric		= {
			maxBrakeForce	= 60,
			maxBrakePower	= 720,
			fadeoutSpeedMin	= 5,
			fadeoutSpeedMax	= 8,
			ebrakeDelay		= 0.8,
		},
		springLoaded = {
			maxBrakeForce	= 8,
			isActive		= true,
		},
	},
	components = {
		InteractableComponent,
		VehicleNumber,
		DoorManager,
		Berlin_PIS,
		A3L92_AudioComponent,
		LightManager,
		SampleMod_A3L92Component,
		WeatherComponent,
		RepaintComponent,
	},

	genericTasks		= {
		[EGenericTaskType.ActivateCab]	= {
			TaskEnterCab,
			TaskActivateCab,
			A3L92_TaskActivateCab,
			TaskSignalLights,
			TaskReleaseParkingBrake,
			TaskActivateFahrsperre,
		},
		[EGenericTaskType.OpenDoors]		= {
			TaskOpenDoors,
			Berlin_TaskDispatchArrival,
		},
		[EGenericTaskType.CloseDoors]		= {
			Berlin_TaskDispatchDeparture,
			TaskCloseDoors,
		},
		[EGenericTaskType.Login]			= { TaskEnterELACode },
		[EGenericTaskType.Logout]			= {},
		[EGenericTaskType.DeactivateCab] 	= {
			TaskApplyParkingBrake,
			TaskIsolateBrake,
			TaskSignalLights,
			A3L92_TaskActivateCab,
			TaskActivateCab,
		},
		[EGenericTaskType.SplitTrain]		= { TaskSplitTrain, TaskSignalLightsSplit},
		[EGenericTaskType.AttachTrain]		= { TaskCoupleTrain, TaskSignalLightsCouple},
	},

	cabs				= {
		cab(),
	},

	cameras				= {
		exteriorCameras	= {
			{
				cameraName		= "ExteriorCamera",
				rotationOrigin	= "ExteriorCameraRot",
			},
		},
	},

	doors = {
		maxUnlockSpeed		= 100, -- can always unlock
		maxOpenDoorSpeed	= 7,
		statusLights = {
			statusLight(RVDM_StatusLightType.Unlocked, "Emissive05", {1,2,3,4,5,6}),
			statusLight(RVDM_StatusLightType.Unlocked, "Emissive06", {1,2,3,4,5,6}),
		},
		hasAccessibleAccess = false,
		passengerDoors = {
			door("DoorAudio1_L", 1, RVDM_DoorSide.Left, 	{["Emissive07"] = 5}, {["Emissive06"] = 5}, true),
			door("DoorAudio1_R", 1, RVDM_DoorSide.Right, 	{["Emissive10"] = 5}, {["Emissive05"] = 5}, true),
			door("DoorAudio2_L", 2, RVDM_DoorSide.Left, 	{["Emissive08"] = 5}, {["Emissive10"] = 5}, true),
			door("DoorAudio2_R", 2, RVDM_DoorSide.Right, 	{["Emissive11"] = 5}, {["Emissive09"] = 5}, true),
			door("DoorAudio3_L", 3, RVDM_DoorSide.Left, 	{["Emissive09"] = 5}, {["Emissive14"] = 5}, true),
			door("DoorAudio3_R", 3, RVDM_DoorSide.Right, 	{["Emissive12"] = 5}, {["Emissive13"] = 5}, true),
		},
		VehicleDoorOverrideClass = Berlin_A3L92_VehicleDoor,
		cabDoors = {
			--- side door
			{
				skeletalMesh		= "Exterior",
				boneName			= "CabDoor",
				animNameABP			= "CabDoor",
				preventsTraction	= false,
				cabAnimSequences = {
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_CabDoorCloseOut.A3L92_Anims_CabDoorCloseOut",
							animationDuration = 2,
							rateScale = 1,
							startTime = 2,
							soundPath = getSound("SideCabDoorClosed"),
						},
						doorState = CabDoor_State.Closed,
						doorStateText = "$HHA_DT5_ia_CabDoorClose",
					},
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_CabDoorOpenOut.A3L92_Anims_CabDoorOpenOut",
							animationDuration = 2,
							rateScale = 1,
							soundPath = getSound("SideCabDoorOpen"),
						},
						doorState = CabDoor_State.FullOpen,
						doorStateText = "$HHA_DT5_ia_CabDoorOpen",
					},
				},
				interactable = {
					boneName = "CabDoor",
					name = "$HHA_DT5_ia_CabDoor",
					callback = function (door, isDown)
						if not door:blockInteraction() and isDown then
							local lastDoorState = door.doorState;
							local newDoorState 	= door:evaluateInteraction();
						end;
					end,
				},
				extraMeshes			= {
					{
						extraMesh = "Cab",
						extraCabAnimSequences = {
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_CabDoorCloseIn.A3L92_Cab_Anims_CabDoorCloseIn",
									animationDuration = 2,
									rateScale = 1,
									startTime = 1.9,
								},
								doorState = CabDoor_State.Closed,
								doorStateText = "$HHA_DT5_ia_CabDoorClose",
							},
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_CabDoorOpenIn.A3L92_Cab_Anims_CabDoorOpenIn",
									animationDuration = 2,
									rateScale = 1,
								},
								doorState = CabDoor_State.FullOpen,
								doorStateText = "$HHA_DT5_ia_CabDoorOpen",
							},
						},
					},
				},
			},
			--- passenger door
			{
				skeletalMesh		= "Interior",
				boneName			= "DoorCabIn",
				animNameABP			= "DoorCabIn",
				preventsTraction	= false,
				cabAnimSequences = {
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_DoorCabInCloseOut.A3L92_Anims_DoorCabInCloseOut",
							animationDuration = 1.83333,
							rateScale = 1,
							startTime = 1.73333,
							soundPath = getSound("BackCabDoorClosed"),
						},
						doorState = CabDoor_State.Closed,
						doorStateText = "$HHA_DT5_ia_CabDoorClose",
					},
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_DoorCabInOpenOut.A3L92_Anims_DoorCabInOpenOut",
							animationDuration = 2,
							rateScale = 1,
							soundPath = getSound("BackCabDoorOpen"),
						},
						doorState = CabDoor_State.FullOpen,
						doorStateText = "$HHA_DT5_ia_CabDoorOpen",
					},
				},
				interactable = {
					boneName = "DoorCabIn",
					name = "$HHA_DT5_ia_CabDoor",
					callback = function (door, isDown)
						if not door:blockInteraction() and isDown then
							local lastDoorState = door.doorState;
							local newDoorState 	= door:evaluateInteraction();
						end;
					end,
				},
				extraMeshes			= {
					{
						extraMesh = "Cab",
						extraCabAnimSequences = {
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_DoorCabInCloseIn.A3L92_Cab_Anims_DoorCabInCloseIn",
									animationDuration = 2,
									rateScale = 1,
									startTime = 1.9,
								},
								doorState = CabDoor_State.Closed,
								doorStateText = "$HHA_DT5_ia_CabDoorClose",
							},
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_DoorCabInOpenIn.A3L92_Cab_Anims_DoorCabInOpenIn",
									animationDuration = 2,
									rateScale = 1,
								},
								doorState = CabDoor_State.FullOpen,
								doorStateText = "$HHA_DT5_ia_CabDoorOpen",
							},
						},
					},
				},
			},
			--- front door
			{
				skeletalMesh		= "Cab",
				boneName			= "DoorFront",
				animNameABP			= "FrontDoor",
				preventsTraction	= false,
				cabAnimSequences = {
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_DoorFrontCloseIn.A3L92_Cab_Anims_DoorFrontCloseIn",
							animationDuration = 2,
							rateScale = 1,
							soundPath = getSound("FrontCabDoorClosed"),
							startTime = 1.9,
						},
						doorState = CabDoor_State.Closed,
						doorStateText = "$HHA_DT5_ia_CabDoorClose",
					},
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Cab_Anims_DoorFrontOpenIn.A3L92_Cab_Anims_DoorFrontOpenIn",
							animationDuration = 2.0,
							rateScale = 1,
							soundPath = getSound("FrontCabDoorOpen"),
						},
						doorState = CabDoor_State.FullOpen,
						doorStateText = "$HHA_DT5_ia_CabDoorOpen",
					},
				},
				interactable = {
					boneName = "DoorFront",
					name = "$HHA_DT5_ia_CabDoor",
					callback = function (door, isDown)
						if not door:blockInteraction() and isDown then
							local lastDoorState = door.doorState;
							local newDoorState 	= door:evaluateInteraction();
						end;
					end,
				},
				extraMeshes			= {
					{
						extraMesh = "Exterior",
						extraCabAnimSequences = {
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_DoorFrontCloseOut.A3L92_Anims_DoorFrontCloseOut",
									animationDuration = 1.83333,
									rateScale = 1,
									startTime = 1.73333,
								},
								doorState = CabDoor_State.Closed,
								doorStateText = "$HHA_DT5_ia_CabDoorClose",
							},
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_DoorFrontOpenOut.A3L92_Anims_DoorFrontOpenOut",
									animationDuration = 2.0,
									rateScale = 1,
								},
								doorState = CabDoor_State.FullOpen,
								doorStateText = "$HHA_DT5_ia_CabDoorOpen",
							},
						},
					},
				},
			},
			--- back door
			{
				skeletalMesh		= "Exterior",
				boneName			= "DoorBack",
				animNameABP			= "BackDoor",
				preventsTraction	= false,
				cabAnimSequences = {
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_BackDoorClose.A3L92_Anims_BackDoorClose",
							animationDuration = 1,
							rateScale = 1,
							startTime = 0.9,
							soundPath = getSound("FrontCabDoorClosed"),
						},
						doorState = CabDoor_State.Closed,
						doorStateText = "$Berlin_ia_DoorClose",
					},
					{
						animWithSound = {
							animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_BackDoorOpen.A3L92_Anims_BackDoorOpen",
							animationDuration = 1,
							rateScale = 1,
							soundPath = getSound("FrontCabDoorOpen"),
						},
						doorState = CabDoor_State.FullOpen,
						doorStateText = "$Berlin_ia_DoorOpen",
					},
				},
				interactable = {
					boneName = "DoorBack",
					name = "$Berlin_ia_Door",
					callback = function (self, isDown)
						if isDown then
							local lastDoorState = self.doorState;
							local newDoorState 	= self:evaluateInteraction();
						end;
					end,
				},
				extraMeshes			= {
					{
						extraMesh = "Interior",
						extraCabAnimSequences = {
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_BackDoorClose.A3L92_Anims_BackDoorClose",
									animationDuration = 1,
									rateScale = 1,
									startTime = 0.9,
									soundPath = getSound("FrontCabDoorOpen"),
								},
								doorState = CabDoor_State.Closed,
								doorStateText = "$Berlin_ia_DoorClose",
							},
							{
								animWithSound = {
									animationPath = "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_BackDoorOpen.A3L92_Anims_BackDoorOpen",
									animationDuration = 1.0,
									rateScale = 1,
								},
								doorState = CabDoor_State.FullOpen,
								doorStateText = "$Berlin_ia_DoorOpen",
							},
						},
					},
				},
			},
		},
	},
	seats = {
		passengerSeats = {
			seat("Bench", "PassengerSeat1", 	0, 	-1),
			seat("Bench", "PassengerSeat2", 	0, 	-1),
			seat("Bench", "PassengerSeat3", 	0, 	-1),
			seat("Bench", "PassengerSeat4", 	0, 	-1),

			seat("Bench", "PassengerSeat1", 	1, 	1),
			seat("Bench", "PassengerSeat2", 	1, 	1),
			seat("Bench", "PassengerSeat3", 	1, 	1),
			seat("Bench", "PassengerSeat4", 	1, 	1),

			seat("Bench", "PassengerSeat1", 	2, 	-1),
			seat("Bench", "PassengerSeat2", 	2, 	-1),
			seat("Bench", "PassengerSeat3", 	2, 	-1),
			seat("Bench", "PassengerSeat4", 	2, 	-1),
			
			seat("Bench", "PassengerSeat1", 	3, 	1),
			seat("Bench", "PassengerSeat2", 	3, 	1),
			seat("Bench", "PassengerSeat3", 	3, 	1),
			seat("Bench", "PassengerSeat4", 	3, 	1),
			
			seat("BenchEnd", "PassengerSeat5", 	0, 	-1),
			seat("BenchEnd", "PassengerSeat6", 	0, 	-1),
			seat("BenchEnd", "PassengerSeat7", 	0, 	1),
			seat("BenchEnd", "PassengerSeat8", 	0, 	1),
		}
	},

	audio = {
		audioBogieInterior = {
			{
				audioComponent = "InteriorAudio",
				brakeAttenuationSetting = "/Game/Shared/Audio/Attenuations/EngineAttenuation.EngineAttenuation",
				brakeAudioPath 			= "/Simuverse_SampleModVehicle/A3L92/Audio/Inside/bremse_innen.bremse_innen",
			},
		},
		audioBogieExterior = {
			{
				audioComponent = "Bogie1Audio",
				brakeAttenuationSetting = "/Game/Shared/Audio/Attenuations/EngineAttenuation.EngineAttenuation",
				bogie = 1,
				brakeAudioPath 			= "/Simuverse_SampleModVehicle/A3L92/Audio/Outside/bremse.bremse",
			},
			{
				audioComponent = "Bogie2Audio",
				brakeAttenuationSetting = "/Game/Shared/Audio/Attenuations/EngineAttenuation.EngineAttenuation",
				bogie = 2,
				brakeAudioPath 			= "/Simuverse_SampleModVehicle/A3L92/Audio/Outside/bremse.bremse",
			},
		},
		audioBogieAI = {
			{
				audioComponent = "AiAudio",
				brakeAttenuationSetting = "/Game/Shared/Audio/Attenuations/EngineAttenuation.EngineAttenuation",
				brakeAudioPath 			= "/Simuverse_SampleModVehicle/A3L92/Audio/Outside/bremse.bremse",
			},
		},
		outsideNoiseGain = 0.35,
		audioHorn = {
			{
				audioComponent = "Horn_Audio",
			},
		},
		hornDeactivateTimer = 1.15,
	},

	vehicleNumber = {
		labels	= {
			{
				mesh			= "Exterior",
				materialSlot	= "A3L92-Digits",
			},
			{
				mesh			= "Cab",
				materialSlot	= "A3L92-Digits",
			},
			{
				mesh			= "Interior",
				materialSlot	= "A3L92-Digits",
			},
		},
		poolName		= "Berlin",
		poolFormat		= "%03d",
		poolValueMin	= 538,
		poolValueMax	= 639,
		useMultipleUnitNumber	= true,
		muOffset		= 0, -- S-Wagen
	},

	repaint = {
		repaintNames = {
			["RepaintBodyExterior"] = {
				{
					mesh 	= "Exterior",
					slots 	= { "A3L92-Repaint", "A3L92-RepaintGlass", },
					parameterName = "RepaintAlbedo",
				},
			},
			["RepaintDecalExterior"] = {
				{
					mesh = "Exterior",
					slots = { "A3L92-Decals", },
					parameterName = "AlbedoTexture",
				},
			},
		},
	},

	lights = {
		headLights = {
			{
				direction		= 1,
				initialState	= EHeadlightState.Off,
				headlightElements	= {
					{
						mesh = "Exterior",
						materialSlot = "A3L92-ExteriorLights",
						materialParams = {
							["Emissive01"] = 2.5,
						},
						lightComponents = {
							{lightComponent ="FrontLightL", intensity = 2, temperature = 4000, attenuationRadius = 100, innerConeAngle = 12, outerConeAngle = 24},
						},
					},
				}
			},
			{
				direction		= 1,
				initialState	= EHeadlightState.Off,
				headlightElements	= {
					{
						mesh = "Exterior",
						materialSlot = "A3L92-ExteriorLights",
						materialParams = {
							["Emissive02"] = 2.5,
						},
						lightComponents = {
							{lightComponent ="FrontLightR", intensity = 2, temperature = 4000, attenuationRadius = 100, innerConeAngle = 12, outerConeAngle = 24},
						},
					},
				}
			},
		},
		tailLights = {
			{
				mesh = "Exterior",
				materialSlot = "A3L92-ExteriorLights",
				direction = -1,
				materialParams = {
					["Emissive03"] = 2.5,
				},
			},
			{
				mesh = "Exterior",
				materialSlot = "A3L92-ExteriorLights",
				direction = -1,
				materialParams = {
					["Emissive04"] = 2.5,
				},
			},
		},
		interiorCabLights ={
			{
				mesh ="Cab",
				materialSlot = "A3L92-CabLights1",
				materialParams = {
					["Emissive15"] = 2.5,
					["Emissive16"] = 2.5,
				},
				lightComponents = {
					{lightComponent ="CabLightL", intensity = 10, temperature = 4000},
					{lightComponent ="CabLightR", intensity = 10, temperature = 4000},
				},
				direction = 1,
			},
		},
		interiorLights = {
			{
				mesh = "Interior",
				materialSlot = "A3L92-InteriorLights",
				materialParams = {
					["Emissive01"] = 1,
					["Emissive02"] = 1,
				},
				lightComponents = {
					{
						lightComponent ="PassengerLightL",
						intensity = 150,
						temperature = 4000,
					},
					{
						lightComponent ="PassengerLightR",
						intensity = 150,
						temperature = 4000,
					},
				},

			},
		},
		intervalPassengerLight 	= false,
		useActiveCab 			= true,
		autoHeadTailLights		= false,
	},

	---@type Berlin_PIS_DataTable
	PIS = {
		destinationDisplays	= {
			{
				componentName	= "ZZA",
				direction		= 1,
			},
		},

		PISDisplays = {
			{componentName = "PIS1",},
			{componentName = "PIS2",},
		},

		announcementNextStop		= {},
		announcementTerminus		= {
			"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/General_Termination01.General_Termination01",
		},
		announcementExitLeft		= {},
		announcementExitRight		= {
			"/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/General_ExitRight.General_ExitRight",
		},
		announcementBell			= {
			"/SubwaySim_Berlin/Vehicles/Shared/Audio/Gong/Berlin_Standardgong_MasterV1_kurz.Berlin_Standardgong_MasterV1_kurz",
		},
		announcementTerminusBell = {
			"/SubwaySim_Berlin/Vehicles/Shared/Audio/Gong/Berlin_Infogong_MasterV2_kurz.Berlin_Infogong_MasterV2_kurz",
		},
		announcementDelay			= 1.2,
		defaultDestinationAnnouncement	= "/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_General.Destination_General",
		destinationAnnouncementByLine	= {
			["U1"]					= "/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_U1.Destination_U1",
			["U2"]					= "/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_U2.Destination_U2",
			["U3"]					= "/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_U3.Destination_U3",
			["U4"]					= "/SubwaySim_Berlin/Vehicles/Shared/Audio/Announcements/Destination_U4.Destination_U4",
		},

		audioComponent 				= "PIS_Audio",
		autoTerminateAnnouncement 	= false,
	},

	interactables = {
 		vehicleInteractables = {
			fixtures = {

				sunvisor = {
					boneName 		= "Sunvisor_Handle",
					name			= "$HHA_DT5_ia_CabSunvisor",
					skeletalMesh 	= "Cab",
					poseMax 		= Transform:new(Vector3:new(0.68, 0,0), Vector3:new(0,0,0)),
					poseCurrent		= Transform:new(Vector3:new(0.15, 0,0), Vector3:new(0,0,0)),
					poseMin 		= Transform.identity,
					callback 		= function (railVehicle, isMoved)
						if isMoved then
							GameplayStatics.spawnSound2D("/Simuverse_SampleModVehicle/A3L92/Audio/Misc/SunVisor-In.SunVisor-In");
						end;
					end,
				},
			},
		},
	},

	---@type A3L92Component_DataTable
	SampleMod_A3L92Component = {
		isKWaggon = false;
	},
	weatherComponents = {
		vehicleWeatherComponents = {
			{
				vehicleWeatherCheckers = {
					{
						mesh = "Exterior",
						socketName = "WeatherChecker1",
					},
					{
						mesh = "Exterior",
						socketName = "WeatherChecker2",
					},
					{
						mesh = "Exterior",
						socketName = "WeatherChecker3",
					},
				},
				vehicleWeatherMaterials = {
					{
						skeletalMesh = "Exterior",
						weatherMaterialSlot = "A3L92-ExteriorGlass",
					},
					{
						skeletalMesh = "Interior",
						weatherMaterialSlot = "A3L92-ExteriorGlass",
					},
				},
			},
			{
				vehicleWeatherCheckers = {
					{
						mesh = "Exterior",
						socketName = "WeatherChecker1"
					},
				},
				vehicleWeatherMaterials = {
					{
						skeletalMesh = "Cab",
						weatherMaterialSlot = "A3L92-ExteriorGlass",
					},
				},
				vehicleWindscreenWipers = {
					{
						wiperSkeletalMesh 	= "Exterior",
						ABPName				= "Wiper",
						animSequence		= "/Simuverse_SampleModVehicle/A3L92/TrainComponents/Animations/A3L92_Anims_WiperAnimation.A3L92_Anims_WiperAnimation",
						animLength			= 1.333333,
						pauseLength			= 1,
						direction 			= 1,
						rateScale			= 1,
						soundPath			= "/Simuverse_SampleModVehicle/A3L92/Audio/Misc/Wiper.Wiper",
						wiperFloatCurve		= "/Simuverse_SampleModVehicle/A3L92/Wiper/FC_A3L92_Wiper.FC_A3L92_Wiper",
						audioSocketName		= "WiperAudio",	
						wiperMaterials 		= {
							{
								skeletalMesh = "Cab",
								weatherMaterialSlot = "A3L92-FrontGlassIn",
							},
							{
								skeletalMesh = "Exterior",
								weatherMaterialSlot = "A3L92-FrontGlassOut",
							},
						},
					},
				},
			},
		},
	},
};

---@type Berlin_A3L92_DataTable
local A3L92_K 				= TableUtil.deepCopy(A3L92_S);
A3L92_K.components 			= A3L92_S.components;
A3L92_K.genericTasks		= A3L92_S.genericTasks;
A3L92_K.vehicleNumber.muOffset	= 1;	-- K-Wagen
A3L92_K.contentName 		= "Berlin_SampleModVehicle_K";
A3L92_K.title 				= "A3L92 (K-Wagen)";
A3L92_K.isKWaggon = true;

---@type RV_MultipleUnit_DataTable
local A3L92 = {
	contentType		= "railVehicle",
	contentName		= "Berlin_SampleModVehicle",

	title			= "SampleModVehicle",
	author			= "$GameDeveloper",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	isMultipleUnit		= true,
	numberPoolMin		= 538,
	numberPoolMax		= 639,
	numberIncrement		= 2,
	numberPool			= "Berlin",

	vehicles		= {
		{
			contentName	= "Berlin_SampleModVehicle_S",
			forward		= true,
		},
		{
			contentName	= "Berlin_SampleModVehicle_K",
			forward		= false,
		},
	},
};

---@type RailVehicleGroup_DataTable
local A3L92_Group = {
	contentType 	= "railVehicleGroup",
	contentName 	= "Berlin_SampleModVehicle_Group",

	title 			= "SampleModVehicle",
	author 			= "$GameDeveloper",

	compatibleMaps 	= {"Berlin", "SampleModMap"},

	description 	= "$SSB_UI_Vehicle_A3L92_Description",
	infos 			= "$SSB_UI_Vehicle_A3L92_Infos",
	previewFilename = "/SubwaySim2_Core/UI/MainMenu/Backgrounds/A3L92_big.A3L92_big",
};

---@type TrainComposition_DataTable
local A3L92_1x = {
	contentType		= "trainComposition",
	contentName		= "Berlin_SampleModVehicle_1x",

	title			= "Sample Mod Vehicle x1",
	author			= "$GameDeveloper",

	compatibleMaps = {"Berlin", "SampleModMap"},
	vehicleGroup 	= "Berlin_SampleModVehicle_Group",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	vehicles		= {
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
	},
};

---@type TrainComposition_DataTable
local A3L92_2x = {
	contentType		= "trainComposition",
	contentName		= "Berlin_SampleModVehicle_2x",

	title			= "Sample Mod Vehicle x2",
	author			= "$GameDeveloper",

	compatibleMaps = {"Berlin", "SampleModMap"},
	vehicleGroup 	= "Berlin_SampleModVehicle_Group",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	vehicles		= {
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
	},
};
---@type TrainComposition_DataTable
local A3L92_3x = {
	contentType		= "trainComposition",
	contentName		= "Berlin_SampleModVehicle_3x",

	title			= "Sample Mod Vehicle x3",
	author			= "$GameDeveloper",

	compatibleMaps = {"Berlin", "SampleModMap"},
	vehicleGroup 	= "Berlin_SampleModVehicle_Group",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	vehicles		= {
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
	},
};

---@type TrainComposition_DataTable
local A3L92_4x = {
	contentType		= "trainComposition",
	contentName		= "Berlin_SampleModVehicle_4x",

	title			= "Sample Mod Vehicle x4",
	author			= "$GameDeveloper",

	compatibleMaps = {"Berlin", "SampleModMap"},
	vehicleGroup 	= "Berlin_SampleModVehicle_Group",

	-- not required for AI trains
	description			= "",
	previewFilename 	= "",

	vehicles		= {
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
		{
			contentName	= "Berlin_SampleModVehicle",
			direction	= 1,
		},
	},
};

g_contentManager:addContent(A3L92_S);
g_contentManager:addContent(A3L92_K);
g_contentManager:addContent(A3L92);
g_contentManager:addContent(A3L92_Group);
g_contentManager:addContent(A3L92_1x);
g_contentManager:addContent(A3L92_2x);
g_contentManager:addContent(A3L92_3x);
g_contentManager:addContent(A3L92_4x);
