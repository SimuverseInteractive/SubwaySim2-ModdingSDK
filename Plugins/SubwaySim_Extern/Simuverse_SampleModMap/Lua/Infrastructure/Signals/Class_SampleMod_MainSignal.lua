--
--
-- SubwaySim
-- Module SampleMod_MainSignal.lua
--
-- SampleMod_MainSignal functionality
--
--
-- Author:	Maximilian Rudorfer
-- Date:	22/03/2025
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

-- make sure this is not nil
InitializeClassReference("MainSignal",	MainSignal);

---@class SampleMod_MainSignal : MainSignal
SampleMod_MainSignal = Class("SampleMod_MainSignal", SampleMod_MainSignal, MainSignal);

--- Switches the signal back to red after the train has passed.
---@param trigger SignalTrigger
---@param trainComposition TrainComposition? If `nil`, this route is being destroyed from control center.
---@param trainPart TrainPart? If `nil`, this route is being destroyed from control center.
function SampleMod_MainSignal:onTrainHasPassed(trigger, trainComposition, trainPart)
	-- check if we need to trigger "Fahrsperre"
	if trainComposition and trainPart == TrainPart.FirstBogie and (self.aspect.aspect == Signal_AspectType.Stop or self.aspect.aspect == Signal_AspectType.Override) then
		-- Fahrsperre needs to be triggered
		trainComposition:callEvent("Fahrsperre_triggerForcedBrake", self);
	end;

	SampleMod_MainSignal:parentClass().onTrainHasPassed(self, trigger, trainComposition, trainPart);
end;
