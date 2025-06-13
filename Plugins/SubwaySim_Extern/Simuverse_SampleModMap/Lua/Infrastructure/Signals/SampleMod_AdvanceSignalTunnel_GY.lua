--
--
-- SubwaySim
-- Module HHA_AdvanceSignal.lua
--
-- HHA_AdvanceSignal data table
--
--
-- Author:	Maximilian Rudorfer
-- Date:	31/08/2023
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

---@type AdvanceSignal_DataTable
local dataTable = {
	contentType		= "signal",
	contentName		= "SampleMod_AdvanceSignalTunnel_GY",

	title			= "SampleMod Vorsignal (Standard)",
	author			= "Simuverse GmbH",

	-- not required for ue classes
	description			= "",
	previewFilename 	= "",
	
	lights			= {
		{
			name	= "GreenLight",
			componentName = "Signal",
			elementIndex	= "GreenLight",
		},
		{
			name	= "YellowLight",
			componentName = "Signal",
			elementIndex	= "YellowLight",
		},
	},

	onInit				= function(self)
		self:showLights("YellowLight");
	end,

	copyAspect			= function(self, mainSignal, isPathClear)
		local aspect	= mainSignal:getAspect();

		if isPathClear and aspect.aspect == Signal_AspectType.Clear then
			if aspect.speedLimit <= 40 then
				self:showLights("GreenLight", "YellowLight");
			else
				self:showLights("GreenLight");
			end;
		else
			self:showLights("YellowLight");
		end;
	end,
};

g_contentManager:addContent(dataTable);