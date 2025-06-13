--
--
-- SubwaySim
-- Module SampleMod_MainSignal.lua
--
-- SampleMod_MainSignal data table
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

---@type MainSignal_DataTable
local dataTable = {
	contentType		= "signal",
	contentName		= "SampleMod_MainSignal_GRY",

	title			= "SampleMod - Hauptsignal (Standard)",
	author			= "Simuverse GmbH",

	-- not required for ue classes
	description			= "",
	previewFilename 	= "",
	immediateSpeedLimitIncrease	= true,
	
	lights				= {
		{
			name			= "GreenLight",
			componentName	= "Signal",
			elementIndex	= "GreenLight",
		},
		{
			name			= "RedLight",
			componentName	= "Signal",
			elementIndex	= "RedLight",
		},
		{
			name			= "YellowLight",
			componentName	= "Signal",
			elementIndex	= "YellowLight",
		},
	},

	aspects				= {
		["Hp0"]			= {
			aspect		= Signal_AspectType.Stop,
			lights		= { "RedLight" },
		},
		["Hp1"]			= {
			aspect		= Signal_AspectType.Clear,
			lights		= { "GreenLight" },
			speedLimit	= 60,
		},
		["Hp2"]			= {
			aspect		= Signal_AspectType.Clear,
			lights		= { "GreenLight", "YellowLight" },
			speedLimit	= 40,
		},
		["Override"]	= {
			aspect		= Signal_AspectType.Override,
			speedLimit	= 20,
			lights		= { "RedLight" },
		},
	},

	onInit				= function(self)
		self:showAspect("Hp0");
	end,

	onRouteSet			= function(self, routeSection)
		-- use on sight mode if required by the route section
		if routeSection:getRequiresOnSight() then
			self:showAspect("Override");
			return;
		end;

		local speedLimit	= routeSection:getSignalSpeedLimit();
		local aspect		= "Hp1";
		if speedLimit == 40 then
			aspect			= "Hp2";
		end;

		self:showAspect(aspect, routeSection:getSignalSpeedLimit(), routeSection:getTimetableSpeedLimit());
	end,

	onTrainDetected		= function(self, trigger, trainComposition, trainPart)
		self:showAspect("Hp0");
	end,
};

g_contentManager:addContent(dataTable);
