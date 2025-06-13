--
--
-- Simuverse_SampleModVehicle
-- Module A3L92Component.lua
--
-- Component for any vehicle-specific features in A3L92
--
--
-- Author:	Barnabas Tamas-Nagy
-- Date:	14/08/2024
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

---@class A3L92Component : RailVehicleComponent
A3L92Component = Class("A3L92Component", A3L92Component);

---@class A3L92Component_DataTable

--- Creates a new instance of this component
---@param vehicle RailVehicle
function A3L92Component:new(vehicle)
	self			= A3L92Component:emptyNew();
	self.vehicle	= vehicle;

	return self;
end;

--- Called whenever this vehicle has received a new physical body
function A3L92Component:onBodyCreated()
	---@type A3L92Component_DataTable?
	local dataTable				= self.vehicle.dataTable["A3L92Component"];
	if dataTable == nil then
		return;
	end;
end;

--- Called whenever this vehicle's physical body is destroyed
function A3L92Component:onBodyDestroyed()
end;



--- Update function, called every tick
function A3L92Component:update(dt)
	-- don't update for AI trains
	if not self.vehicle:hasPlayerEnteredCab() then
		return;
	end;
end;

--- Called by the station as soon as the train has entered the platform.
---@param station Station
---@param platformNumber string
function A3L92Component:onPlatformEntered(station, platformNumber)

end;

--- Called by the station as soon as the train is leaving the platform.
---@param station Station
---@param platformNumber string
function A3L92Component:onPlatformLeft(station, platformNumber)

end;