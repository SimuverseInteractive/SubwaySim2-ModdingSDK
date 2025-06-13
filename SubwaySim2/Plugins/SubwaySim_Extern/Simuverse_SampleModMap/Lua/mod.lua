--
--
-- Simuverse_SampleModMap
-- Module mod.lua
--
-- Main lua file for Simuverse_SampleModMap Plugin
--
--
-- Author:	Maximilian Rudorfer
-- Date:	22/11/2024
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
	title			= "Simuverse_SampleModMap",
	version			= "1.0",
	description		= "An example map to demonstrate modding in SubwaySim 2",
	author			= "$GameDeveloper",
	targetGame		= "SubwaySim2",

	scripts			= {
		"Maps/SampleModMap.lua",
		"l10n/texts_en.lua",

		"Infrastructure/Signals/Class_SampleMod_MainSignal.lua",

		-- MainSignals
		"Infrastructure/Signals/SampleMod_AdvanceSignal_GY.lua",
		"Infrastructure/Signals/SampleMod_AdvanceSignalTunnel_GY.lua",
		"Infrastructure/Signals/SampleMod_MainSignal_GRY.lua",
		"Infrastructure/Signals/SampleMod_MainSignal_SGRYSYG.lua",

		-- TunnelSignals
		"Infrastructure/Signals/SampleMod_MainSignalTunnel_GRY.lua",
		"Infrastructure/Signals/SampleMod_MainSignalTunnel_SGRYSYG.lua",

		-- DangerSignals
		"Infrastructure/Signals/SampleMod_DangerSignal.lua",
		"Infrastructure/Signals/SampleMod_DangerSignalTunnel.lua",

		-- other signals
		"Infrastructure/Signals/SampleMod_BufferStop.lua",
	},
};