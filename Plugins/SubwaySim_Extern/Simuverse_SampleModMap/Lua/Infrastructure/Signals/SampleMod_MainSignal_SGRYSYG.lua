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
	contentName		= "SampleMod_MainSignal_SGRYSYG",

	title			= "SampleMod - Hauptsignal (Standard)",
	author			= "Simuverse GmbH",

	-- not required for ue classes
	description			= "",
	previewFilename 	= "",
	immediateSpeedLimitIncrease	= true,
	
	lights			= {
		{
			name	= "GreenLightTop",
			componentName = "Signal",
			elementIndex	= "GreenLightTop",
		},
		{
			name	= "RedLight",
			componentName = "Signal",
			elementIndex	= "RedLight",
		},
		{
			name	= "YellowLightTop",
			componentName = "Signal",
			elementIndex	= "YellowLightTop",
		},
		{
			name	= "YellowLightBottom",
			componentName = "Signal",
			elementIndex	= "YellowLightBottom",
		},
		{
			name	= "GreenLightBottom",
			componentName = "Signal",
			elementIndex	= "GreenLightBottom",
		},
	},

	components		= {
		{	name	= "D_Platform1",		componentName	= "TopScreen_Num1",			},
		{	name	= "D_Platform2",		componentName	= "TopScreen_Num2",			},
		{	name	= "D_Platform3",		componentName	= "TopScreen_Num3",			},
		{	name	= "D_Platform4",		componentName	= "TopScreen_Num4",			},
		{	name	= "D_Platform5",		componentName	= "TopScreen_Num5",			},
		{	name	= "D_Platform6",		componentName	= "TopScreen_Num6",			},
		{	name	= "D_Platform7",		componentName	= "TopScreen_Num7",			},
		{	name	= "D_Platform8",		componentName	= "TopScreen_Num8",			},
		{	name	= "D_Platform9",		componentName	= "TopScreen_Num9",			},
		{	name	= "D_SwitchLeft",		componentName	= "BottomScreen_SwitchL",	},
		{	name	= "D_SwitchRight",		componentName	= "BottomScreen_SwitchR",	},
		{	name	= "Zs1",				componentName	= "BottomScreen_Triangle",	},
		{	name	= "Zs11",				componentName	= "BottomScreen_Sphere",	},
		{	name	= "Zs12",				componentName	= "BottomScreen_Square",	},
		{	name	= "CloseDoors",			componentName	= "BottomScreen_T",			},
		{	name	= "WaitForCloseDoors",	componentName	= "BottomScreen_WaitforT",	},
	},

	aspects				= {
		["Hp0"]			= {
			aspect		= Signal_AspectType.Stop,
			lights		= { "RedLight" },
			components	= { "" },
		},
		["Hp1"]			= {
			aspect		= Signal_AspectType.Clear,
			speedLimit	= 60,
			lights		= { "GreenLightTop" },
			components	= { "" },
		},
		["Hp2"]			= {
			aspect		= Signal_AspectType.Clear,
			speedLimit	= 40,
			lights		= { "GreenLightTop", "YellowLightTop" },
			components	= { "" },
		},
		["Hp3"]			= {
			aspect		= Signal_AspectType.Clear,
			lights		= { "GreenLightTop", "YellowLightTop", "YellowLightBottom" },
			speedLimit	= 25,
			components	= { "" },
		},
		["Hp4"]			= {
			aspect		= Signal_AspectType.OnSight,
			speedLimit	= 25,
			lights		= { "YellowLightTop", "YellowLightBottom" },
			components	= { "" },
		},
		["Override"]	= {
			aspect		= Signal_AspectType.Override,
			speedLimit	= 20,
			lights		= { "RedLight" },
			components	= { "Zs1" },
		},
	},

	onInit				= function(self)
		self:showAspect("Hp0");
	end,

	onRouteSet			= function(self, routeSection)
		-- use on sight mode if required by the route section
		if routeSection:getRequiresOnSight() then
			self:showAspect("Hp4");
		else
			local speedLimit	= routeSection:getSignalSpeedLimit();
			local aspect		= "Hp1";
			if speedLimit == 40 then
				aspect			= "Hp2";
				
			elseif speedLimit == 25 then
				aspect			= "Hp3";
			end;

			self:showAspect(aspect, speedLimit, routeSection:getTimetableSpeedLimit());
		end;

		local routeString	= routeSection:getSignalRouteString();
		if routeString then
			self:showComponentsPrefix("D_", ("D_%s"):format(routeString));
		else
			self:showComponentsPrefix("D_", "");
		end;
	end,

	onTrainDetected		= function(self, trigger, trainComposition, trainPart)
		self:showAspect("Hp0");
	end,
};

g_contentManager:addContent(dataTable);
