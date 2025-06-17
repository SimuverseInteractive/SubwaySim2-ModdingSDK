--
--
-- Simuverse_SampleModVehicle
-- Module SampleMod_A3L92Component.lua
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

---@class SampleMod_A3L92Component : RailVehicleComponent
SampleMod_A3L92Component = Class("SampleMod_A3L92Component", SampleMod_A3L92Component);

---@class SampleMod_A3L92Component_DataTable
---@field isKWaggon boolean?

--- Creates a new instance of this component
---@param vehicle RailVehicle
function SampleMod_A3L92Component:new(vehicle)
	self			= SampleMod_A3L92Component:emptyNew();
	self.vehicle	= vehicle;

	self.isKWaggon 	= false;

	return self;
end;

--- Called whenever this vehicle has received a new physical body
function SampleMod_A3L92Component:onBodyCreated()
	---@type SampleMod_A3L92Component_DataTable?
	local dataTable				= self.vehicle.dataTable["SampleMod_A3L92Component"];
	if dataTable == nil then
		return;
	end;

	self.isKWaggon = dataTable.isKWaggon or false;
	-- debugprint("[SampleMod_A3L92Component] isKWaggon: %s",self.isKWaggon)
end;

--- Called whenever this vehicle's physical body is destroyed
function SampleMod_A3L92Component:onBodyDestroyed()
	self.isKWaggon = false;
end;



--- Update function, called every tick
function SampleMod_A3L92Component:update(dt)
	-- don't update for AI trains
	if not self.vehicle:hasPlayerEnteredCab() then
		return;
	end;
end;

--- Called by the station as soon as the train has entered the platform.
---@param station Station
---@param platformNumber string
function SampleMod_A3L92Component:onPlatformEntered(station, platformNumber)

end;

--- Called by the station as soon as the train is leaving the platform.
---@param station Station
---@param platformNumber string
function SampleMod_A3L92Component:onPlatformLeft(station, platformNumber)

end;