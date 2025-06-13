--
--
-- Simuverse_SampleModVehicle
-- Module mod.lua
--
-- Main lua file for Simuverse_SampleModVehicle Plugin
--
--
-- Author:	Sebastian Hofer
-- Date:	25/02/2025
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

---@type ContentManager_Mod
return {
	title			= "Simuverse_SampleModVehicle",
	version			= "1.0",
	description		= "An example vehicle to demonstrate modding in SubwaySim 2",
	author			= "$GameDeveloper",
	targetGame		= "SubwaySim2",

	scripts			= {
		"DataTables/Vehicles/A3L92/A3L92Component.lua",
		"DataTables/Vehicles/A3L92/A3L92CabModule.lua",
		"DataTables/Vehicles/A3L92/Berlin_ELA.lua",
		"DataTables/Vehicles/A3L92/A3L92.lua",
	},
};
