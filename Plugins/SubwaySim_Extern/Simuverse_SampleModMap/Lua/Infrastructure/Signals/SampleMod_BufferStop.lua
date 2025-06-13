--
--
-- SubwaySim
-- Module SampleMod_BufferStop.lua
--
-- SampleMod_BufferStop data table
--
--
-- Author:	Maximilian Rudorfer
-- Date:	14/09/2023
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

---@type MainSignal_DataTable
local dataTable = {
	contentType		= "signal",
	contentName		= "SampleMod_BufferStop",

	title			= "SampleMod - Prellbock",
	author			= "Simuverse GmbH",

	-- not required for ue classes
	description			= "",
	previewFilename 	= "",

	requireOnSightApproach	= false,
	noDepartingRoutes		= true,
	locationOffset			= -0.78,

	aspects			= {
		["Default"]	= {
			aspect		= Signal_AspectType.EndOfTracks,
		},
	},

	onInit				= function(self)
		self:showAspect("Default");
	end,

	onRouteSet			= function(self, routeSection)
		self:showAspect("Default");
	end,
};

g_contentManager:addContent(dataTable);
