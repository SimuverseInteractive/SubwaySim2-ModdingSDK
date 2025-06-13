--
--
-- Simuverse_SampleModVehicle
-- Module A3L92CabModule.lua
--
-- Component for any vehicle-specific features in A3L92
--
--
-- Author:	Barnabas Tamas-Nagy
-- Date:	18/07/2024
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

---@class A3L92CabModule : BaseClass, IBaseCabControllerModule
A3L92CabModule = Class("A3L92CabModule", A3L92CabModule);

-- make this the main module in the Cab
A3L92CabModule.isControllerModule	= true;

---@class A3L92CabModule_DataTable
---@field agFeedPipe AnalogGauge_Data? -- white needle
---@field agControlPipe AnalogGauge_Data? -- red needle
---@field agVoltMeter AnalogGauge_Data? -- volt meter


--- Called to initialize this cab module
---@param cab BaseCab parent cab
---@param vehicle RailVehicle parent rail vehicle
---@param cabData RailVehicle_DataTable_CabData
---@return A3L92CabModule? instance
function A3L92CabModule:new(cab, vehicle, cabData)
	---@type A3L92CabModule_DataTable
	local dataTable			= cabData["A3L92CabModule"];
	if dataTable == nil then
		debugprint("dataTable is nil")
		return nil;
	end;


	self					= self:class().emptyNew(self);
	self.cab				= cab;
	self.vehicle			= vehicle;
	self.dataTable 			= dataTable;

	-- Desired AFB speed in [km/h]
	self._afbValue			= 0;

	self.afbGaugeValue		= 0;

	-- target pipe pressure in main brake pipe (Hauptluftleitung HLL)
	self._targetPipePressure	= 0;


	-- target direct brake value (specified by user)
	-- [0..1]
	self._directBrakeValue	= 1;

	return self;
end;

--- Called whenever this vehicle has received a new physical body
function A3L92CabModule:onBodyCreated()
	if self.dataTable.agFeedPipe ~= nil then
		self.agFeedPipe 	= AnalogGauge:new(self.cab.skeletalMesh, self.dataTable.agFeedPipe);
	end;

	if self.dataTable.agControlPipe ~= nil then
		self.agControlPipe 	= AnalogGauge:new(self.cab.skeletalMesh, self.dataTable.agControlPipe);
	end;

	if self.dataTable.agVoltMeter ~= nil then
		self.agVoltMeter 	= AnalogGauge:new(self.cab.skeletalMesh, self.dataTable.agVoltMeter);
	end;

	-- Create dynamic material instance for our cab
	self.cabDynMI1			= PrimitiveComponent.createMaterialInstanceDynamic(self.cab.skeletalMesh, "A3L92-CabLights1");
	self.cabDynMI2			= PrimitiveComponent.createMaterialInstanceDynamic(self.cab.skeletalMesh, "A3L92-CabLights2");
	self.cabDynMI3			= PrimitiveComponent.createMaterialInstanceDynamic(self.cab.skeletalMesh, "A3L92-CabLights3");
end;

--- Called whenever this vehicle's physical body is destroyed
function A3L92CabModule:onBodyDestroyed()
	self.agFeedPipe 		= nil;
	self.agControlPipe 		= nil;
	self.agVoltMeter 		= nil;

	self.cabDynMI1			= nil;
	self.cabDynMI2			= nil;
	self.cabDynMI3			= nil;
end;

function A3L92CabModule:onCabActivated()
	self.cab.railVehicle:getTrainComposition():foreachVehicle(function (vehicle)
		local lightManager = vehicle:getComponent(LightManager);
		if lightManager ~= nil then
			lightManager:setInteriorLightState(EInteriorLightState.Permanent);
		end;
	end);
end;

function A3L92CabModule:onCabDeactivated()
	self.cab.railVehicle:getTrainComposition():foreachVehicle(function (vehicle)
		local lightManager = vehicle:getComponent(LightManager);
		if lightManager ~= nil then
			lightManager:setInteriorLightState(EInteriorLightState.Off);
		end;
	end);
end;

--- Updates gauges and lamps
---@param dt number delta time [seconds]
function A3L92CabModule:updateGauges(dt)
	if self.cabDynMI1 == nil or self.cabDynMI2 == nil then
		return;
	end;
	local vehicle				= self.cab:getVehicle();
	local currentPipePressure	= vehicle:getBrakingSystem(BrakePneumatic5bar):getMainBrakePipePressure();
	if self.agFeedPipe ~= nil then
		self.agFeedPipe:updateGauge(5.0, dt);
	end;
	if self.agControlPipe ~= nil then
		self.agControlPipe:updateGauge(currentPipePressure, dt);
	end;
	if self.agVoltMeter ~= nil then
		self.agVoltMeter:updateGauge(110, dt);
	end;

	-- update lamps
	-- E4
	local leverBrake		= self.cab:getInteractableOfClass(AnalogInputDevice, "leverBrake");
	if leverBrake ~= nil then
		MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive10", ifelse(math.abs(leverBrake:getRawValue() - (-1)) < 0.1, 1, 0));
	end;

	-- Brake on
	local directBrake		= vehicle:getBrakingSystem(BrakePneumaticDirect);
	if directBrake ~= nil then
		local directBrakeValue	= directBrake:getPressure();
		MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive11", ifelse(currentPipePressure < 4.8 or directBrakeValue > 0.2, 1, 0));
	end;
	
	-- Doors closed
	local doorManager = vehicle:getComponent(DoorManager);
	if doorManager ~= nil then
		MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive09", ifelse(doorManager:areDoorsClosed(), 1, 0));
	end;

	-- Fahrsperre
	MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive04", ifelse(self.cab:isActiveCab(), 1, 0));

	-- Tachometer +Needle
	MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive05", ifelse(self.cab:isActiveCab(), 1, 0));
	MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive06", ifelse(self.cab:isActiveCab(), 1, 0));
	-- Pressure Gauge
	MaterialInstanceDynamic.setScalar(self.cabDynMI1, "Emissive08", ifelse(self.cab:isActiveCab(), 1, 0));
	
	-- Voltage 750V
	MaterialInstanceDynamic.setScalar(self.cabDynMI2, "Emissive10", 1);
end;

--- Processes cab joystick inputs
---@param dt number delta time [seconds]
---@param value number
function A3L92CabModule:processJoystickInput(dt, value)
	local cab				= self.cab;
	local lvThrottle		= cab:getInteractableOfClass(AnalogInputDevice, "leverThrottle");
	---@cast lvThrottle AnalogInputDevice

	local fakeLvThrottleValue = ifelse(value > 0, ifelse(value > 0.95, 1, 0.5), 0);
	lvThrottle:setValue(fakeLvThrottleValue, true);

	local leverBrake			= cab:getInteractableOfClass(AnalogInputDevice, "leverBrake");
	---@cast leverBrake AnalogInputDevice

	local fakeBrakeValue		= 0;
	-- if lastThrottle == 0 then
	-- 	fakeBrakeValue = 0.2;
	-- else
	if value > 0 then
		fakeBrakeValue = 0.4; -- "fahren"
	elseif value == 0 then
		fakeBrakeValue = 0.2; -- "lösen"
	else
		fakeBrakeValue = map(-1, 0, -1.4, 0, value);
	end;
	leverBrake:setValue(fakeBrakeValue, true);
end;

--- Processes cab inputs
---@param dt number delta time [seconds]
function A3L92CabModule:processInputs(dt)
	local value, isJoystick	= g_inputMapper:getAxis("Cab_lvThrottle");
	
	--debugprint("[A3L92CabModule] value: %s, isJoystick: %s", value, isJoystick);

	if isJoystick or self.lastJoystick then
		if not isJoystick then
			value				= 0;
			self.lastJoystick	= false;
		else
			self.lastJoystick	= true;
		end;
		
		self:processJoystickInput(dt, value);
	end;

	local cab				= self.cab;
	local currentSpeed		= cab.railVehicle:getCurrentSpeed(true);
	local currentSpeedKmh	= 3.6 * currentSpeed;
	
	local leverBrake			= cab:getInteractableOfClass(AnalogInputDevice, "leverBrake");
	assert(leverBrake);
	local brakePos				= leverBrake:getLastPosition();
	
	
	local lvThrottle		= cab:getInteractableOfClass(AnalogInputDevice, "leverThrottle");
	assert(lvThrottle);
	
	--- if the brake lever is not in drive then the throttle lever will be set to 0
	if brakePos ~= 8 then
		lvThrottle:setValue(0, true);
	end;

	-- get value from the interactable
	local lastThrottle		= cab.throttleValue;
	cab.throttleValue		= lvThrottle:getRawValue();

	local parkingBrake		= cab.railVehicle:needsParkingBrake();

	-- update AFB
	local afb				= cab:getInteractableOfClass(AnalogInputDevice, "leverAFB");
	assert(afb);
	-- A3L92 AFB values are configured that 0.15 = 15 km/h, thus multiply by 100
	self._afbValue			= afb:getRawValue() * 100;

	-- check if vehicle runs into the right direction
	local activeDirection	= ifelse(self._afbValue >= 0, 1, -1);
	if cab:getActiveDirection() ~= activeDirection then
		cab:setActiveDirection(activeDirection);
	end;

	local absAfbValue		= math.abs(self._afbValue);

	-- limit engine force 2 km/h before speed limit
	local engineForceCoeff	= mapClamped(absAfbValue-2, absAfbValue, cab.throttleValue, 0, currentSpeedKmh);

	local trainComposition	= cab.railVehicle:getTrainComposition();
	local emergencyBrake	= cab:getEventOR("isEmergencyBrakeActive");
	local forceServiceBrake	= cab:getEventOR("isServiceBrakeActive");

	-- always update traction prevention UNLESS it is already active (and the lever is not in zero position)
	if cab.throttleValue > 0 and (lastThrottle <= 0 or not cab.preventTraction) then
		cab.preventTraction = emergencyBrake or forceServiceBrake or cab.railVehicle:preventsTractionPower() or parkingBrake;
	end;
	if cab.preventTraction or emergencyBrake or forceServiceBrake then
		engineForceCoeff	= 0;
	end;

	-- brake control

	local brakeValue			= leverBrake:getRawValue();
	local isEBrakeActive		= brakeValue >= -1 and brakeValue <= 0;
	local eBrakeValue			= 0;
	local targetPipePressure	= self._targetPipePressure;
	local currentPipePressure	= cab:getVehicle():getBrakingSystem(BrakePneumatic5bar):getMainBrakePipePressure();


	if not isEBrakeActive and brakePos == 8 then
		-- slowly increase pipe pressure
		targetPipePressure	= Utils.moveTowards(targetPipePressure, 5, 0.15*dt);

		-- "FAHREN" = driving
		if currentPipePressure < 4.5 then
			engineForceCoeff	= 0;
			cab.preventTraction	= true;
		end;

	else
		-- no traction allowed and force resetting throttle to zero
		engineForceCoeff		= 0;
		cab.preventTraction		= true;

		if isEBrakeActive or brakePos == 3 or brakePos == 4 or brakePos == 5 or brakePos == 6 then
			eBrakeValue		= math.abs(brakeValue);
		end;
		if brakePos >= 4 and brakePos <= 7 then
			-- "E3" until "LÖSEN" = Release brake
			-- double the effect for "LÖSEN" (= 7)
			targetPipePressure	= Utils.moveTowards(targetPipePressure, 5, ifelse(brakePos ~= 7, 0.2, 0.4)*dt);
		end;

		if brakePos == 2 then
			-- "LUFTBREMSE" = increase brake effect
			eBrakeValue			= 0;
			targetPipePressure	= Utils.moveTowards(targetPipePressure, 0, 0.8*dt);

		elseif brakePos == 1 then
			-- "SCHNELLBREMSE" = Emergency brake
			eBrakeValue			= 0;
			targetPipePressure	= 0;
		end;
		-- in "ABSCHLUSS" (= Cab deactivated), we don't have to do anything
	end;

	-- we use the direct brake as "Haltebremse"

	-- below 3 km/h, the auto-brake will be enabled
	local autoBrakeSpeed	= 3;
	local directBrakeValue	= 0;
	if parkingBrake or (engineForceCoeff <= 0 and currentSpeedKmh <= autoBrakeSpeed) then
		directBrakeValue	= 1;

	elseif eBrakeValue > 0 and currentSpeedKmh < 7 then
		directBrakeValue	= math.max(directBrakeValue, eBrakeValue);
	end;

	-- if emergency brake is active, then set target pipe pressure to 0 + disable E-brake
	if emergencyBrake then
		targetPipePressure	= 0;
		eBrakeValue			= 0;
	end;

	cab.throttleValue		= math.min(cab.throttleValue, -eBrakeValue);

	self._targetPipePressure= targetPipePressure;
	local vehicles			= trainComposition:getVehicles();

	--debugprint("[A3L92CabModule] directBrakeValue: %s, targetPipePressure: %s", directBrakeValue*3.8, targetPipePressure);

	-- apply brake pressure and throttle to all vehicles
	for n, vehicle in ipairs(vehicles) do
		-- TODO check if brake pipes are really attached etc
		vehicle:callBrakeFunction(BrakePneumaticDirect,	"setTargetPressure",		directBrakeValue * 3.8);
		vehicle:callBrakeFunction(BrakePneumatic5bar,	"setMainBrakePipePressure",	targetPipePressure);
		vehicle:callBrakeFunction(BrakeElectric,		"setBrakeValue",			eBrakeValue);

		vehicle:setEngineForceCoeff(engineForceCoeff * cab:getCabOrientation() * cab:getActiveDirection());
	end;

	-- skip BaseCab update
	return true;
end;

---loads the analogGauges from the data table
---@param data AnalogGauge_Data
function A3L92CabModule:loadAnalogGauges(data)
	if data == nil then
		return;
	end;
end;
