--
--
-- SubwaySim2_Modding
-- Module plugin.lua
--
-- Main lua file for SubwaySim2_Modding Plugin
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

---@type ContentManager_Plugin
return {
	title			= "SubwaySim2_Modding",
	version			= "1.0",
	description		= "Content for SubwaySim2_Modding",
	author			= "$GameDeveloper",
	isDLC			= true,
	dlcAppId		= nil,
	dlcHash			= "0b4e10024c646f00be0144a05787a966",
	targetGame		= "SubwaySim2",

	scripts			= {
		"Infrastructure/Signals/Class_SWSModding_MainSignal.lua",

		-- MainSignals
		"Infrastructure/Signals/SWSModding_AdvanceSignal_GY.lua",
		"Infrastructure/Signals/SWSModding_AdvanceSignalTunnel_GY.lua",
		"Infrastructure/Signals/SWSModding_MainSignal_GRY.lua",
		"Infrastructure/Signals/SWSModding_MainSignal_SGRYSYG.lua",

		-- TunnelSignals
		"Infrastructure/Signals/SWSModding_MainSignalTunnel_GRY.lua",
		"Infrastructure/Signals/SWSModding_MainSignalTunnel_SGRYSYG.lua",

		-- DangerSignals
		"Infrastructure/Signals/SWSModding_DangerSignal.lua",
		"Infrastructure/Signals/SWSModding_DangerSignalTunnel.lua",

		-- other signals
		"Infrastructure/Signals/SWSModding_BufferStop.lua",
	},
};
