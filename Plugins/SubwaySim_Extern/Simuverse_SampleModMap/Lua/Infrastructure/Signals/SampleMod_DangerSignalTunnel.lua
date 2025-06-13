--
--
-- SubwaySim
-- Module SampleMod_DangerSignalTunnel.lua
--
-- SampleMod_DangerSignalTunnel data table
--
--
-- Author:	Dominik Kerschbaumer
-- Date:	18/12/2024
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

---@type DangerSignal_DataTable
---@diagnostic disable: inject-field
local dataTable = {
	contentType		= "signal",
	contentName		= "SampleMod_DangerSignalTunnel",

	title			= "SampleMod - Gefahrensignal Tunnel",
	author			= "Simuverse Interactive",

	-- not required for ue classes
	description			= "",
	previewFilename 	= "",

	lights			= {
		{
			name	= "Danger1",
			componentName	= "SM_Signal",
			elementIndex	= "YellowLight",
			materialParams = {
				["EmissiveStrength"] = 15,
			},
		},
		{
			name	= "Danger2",
			componentName	= "SM_Signal",
			elementIndex	= "RedLight",
			materialParams = {
				["EmissiveStrength"] = 15,
			},
		},
		{
			name	= "Danger3",
			componentName	= "SM_Signal",
			elementIndex	= "GreenLight",
			materialParams = {
				["EmissiveStrength"] = 15,
			},
		},
	},

	onActivated			= function(self)
		self:showLights("Danger1", "Danger2", "Danger3");
	end,

	onDeactivated		= function(self)
		self:showLights("");
	end,
};

g_contentManager:addContent(dataTable);
