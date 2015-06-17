-- Korg nanoKontrol2 Lua Codec
-- Propellerhead Software
-- Carlos Eduardo, 2015
-- Version 1.0
--  - 16/06/2015
--  - Updated stock script to support soft pickup for the sliders and knobs.

--position of first analog control in the items table
gFirstAnalogIndex = 12

function remote_init()
local items=
 {
  {name="Rew Button", input="button", output="value"},
  {name="FFW Button", input="button", output="value"},
  {name="Stop Button", input="button", output="value"},
  {name="Play Button", input="button", output="value"},
  {name="Rec Button", input="button", output="value"},

  {name="Prev Track Button", input="button", output="value"},
  {name="Next Track Button", input="button", output="value"},
  {name="Cycle Button", input="button", output="value"},
  {name="Set Marker Button", input="button", output="value"},
  {name="Left Marker Button", input="button", output="value"},
  {name="Right Marker Button", input="button", output="value"},

  {name="Knob 1", input="value", output="value", min=0, max=127},
  {name="Knob 2", input="value", output="value", min=0, max=127},
  {name="Knob 3", input="value", output="value", min=0, max=127},
  {name="Knob 4", input="value", output="value", min=0, max=127},
  {name="Knob 5", input="value", output="value", min=0, max=127},
  {name="Knob 6", input="value", output="value", min=0, max=127},
  {name="Knob 7", input="value", output="value", min=0, max=127},
  {name="Knob 8", input="value", output="value", min=0, max=127},

  {name="Slider 1", input="value", output="value", min=0, max=127},
  {name="Slider 2", input="value", output="value", min=0, max=127},
  {name="Slider 3", input="value", output="value", min=0, max=127},
  {name="Slider 4", input="value", output="value", min=0, max=127},
  {name="Slider 5", input="value", output="value", min=0, max=127},
  {name="Slider 6", input="value", output="value", min=0, max=127},
  {name="Slider 7", input="value", output="value", min=0, max=127},
  {name="Slider 8", input="value", output="value", min=0, max=127},

  {name="Button S1", input="button", output="value"},
  {name="Button S2", input="button", output="value"},
  {name="Button S3", input="button", output="value"},
  {name="Button S4", input="button", output="value"},
  {name="Button S5", input="button", output="value"},
  {name="Button S6", input="button", output="value"},
  {name="Button S7", input="button", output="value"},
  {name="Button S8", input="button", output="value"},

  {name="Button M1", input="button", output="value"},
  {name="Button M2", input="button", output="value"},
  {name="Button M3", input="button", output="value"},
  {name="Button M4", input="button", output="value"},
  {name="Button M5", input="button", output="value"},
  {name="Button M6", input="button", output="value"},
  {name="Button M7", input="button", output="value"},
  {name="Button M8", input="button", output="value"},

  {name="Button R1", input="button", output="value"},
  {name="Button R2", input="button", output="value"},
  {name="Button R3", input="button", output="value"},
  {name="Button R4", input="button", output="value"},
  {name="Button R5", input="button", output="value"},
  {name="Button R6", input="button", output="value"},
  {name="Button R7", input="button", output="value"},
  {name="Button R8", input="button", output="value"},
 }
remote.define_items(items)

local inputs=
 {
  {pattern="b? 2b xx", name="Rew Button", value="x/127"},
  {pattern="b? 2c xx", name="FFW Button", value="x/127"},
  {pattern="b? 2a xx", name="Stop Button", value="x/127"},
  {pattern="b? 29 xx", name="Play Button", value="x/127"},
  {pattern="b? 2d xx", name="Rec Button", value="x/127"},

  {pattern="b? 3a xx", name="Prev Track Button", value="x/127"},
  {pattern="b? 3b xx", name="Next Track Button", value="x/127"},
  {pattern="b? 2e xx", name="Cycle Button", value="x/127"},
  {pattern="b? 3c xx", name="Set Marker Button", value="x/127"},
  {pattern="b? 3d xx", name="Left Marker Button", value="x/127"},
  {pattern="b? 3e xx", name="Right Marker Button", value="x/127"},

  -- {pattern="bf 10 xx", name="Knob 1"},
  -- {pattern="bf 11 xx", name="Knob 2"},
  -- {pattern="bf 12 xx", name="Knob 3"},
  -- {pattern="bf 13 xx", name="Knob 4"},
  -- {pattern="bf 14 xx", name="Knob 5"},
  -- {pattern="bf 15 xx", name="Knob 6"},
  -- {pattern="bf 16 xx", name="Knob 7"},
  -- {pattern="bf 17 xx", name="Knob 8"},

  -- {pattern="bf 00 xx", name="Slider 1"},
  -- {pattern="bf 01 xx", name="Slider 2"},
  -- {pattern="bf 02 xx", name="Slider 3"},
  -- {pattern="bf 03 xx", name="Slider 4"},
  -- {pattern="bf 04 xx", name="Slider 5"},
  -- {pattern="bf 05 xx", name="Slider 6"},
  -- {pattern="bf 06 xx", name="Slider 7"},
  -- {pattern="bf 07 xx", name="Slider 8"},

  {pattern="bf 20 xx", name="Button S1", value="x/127"},
  {pattern="bf 21 xx", name="Button S2", value="x/127"},
  {pattern="bf 22 xx", name="Button S3", value="x/127"},
  {pattern="bf 23 xx", name="Button S4", value="x/127"},
  {pattern="bf 24 xx", name="Button S5", value="x/127"},
  {pattern="bf 25 xx", name="Button S6", value="x/127"},
  {pattern="bf 26 xx", name="Button S7", value="x/127"},
  {pattern="bf 27 xx", name="Button S8", value="x/127"},

  {pattern="bf 30 xx", name="Button M1", value="x/127"},
  {pattern="bf 31 xx", name="Button M2", value="x/127"},
  {pattern="bf 32 xx", name="Button M3", value="x/127"},
  {pattern="bf 33 xx", name="Button M4", value="x/127"},
  {pattern="bf 34 xx", name="Button M5", value="x/127"},
  {pattern="bf 35 xx", name="Button M6", value="x/127"},
  {pattern="bf 36 xx", name="Button M7", value="x/127"},
  {pattern="bf 37 xx", name="Button M8", value="x/127"},

  {pattern="bf 40 xx", name="Button R1", value="x/127"},
  {pattern="bf 41 xx", name="Button R2", value="x/127"},
  {pattern="bf 42 xx", name="Button R3", value="x/127"},
  {pattern="bf 43 xx", name="Button R4", value="x/127"},
  {pattern="bf 44 xx", name="Button R5", value="x/127"},
  {pattern="bf 45 xx", name="Button R6", value="x/127"},
  {pattern="bf 46 xx", name="Button R7", value="x/127"},
  {pattern="bf 47 xx", name="Button R8", value="x/127"},
 }
 remote.define_auto_inputs(inputs)

local outputs =
    {
        {name="Rew Button", pattern="bf 2b xx", x="127*value"},
        {name="FFW Button", pattern="bf 2c xx", x="127*value"},
        {name="Stop Button", pattern="bf 2a xx", x="127*value"},
        {name="Play Button", pattern="bf 29 xx", x="127*value"},
        {name="Rec Button", pattern="bf 2d xx", x="127*value"},

        {name="Prev Track Button", pattern="bf 3a xx", x="127*value"},
        {name="Next Track Button", pattern="bf 3b xx", x="127*value"},
        {name="Cycle Button", pattern="bf 2e xx", x="127*value"},
        {name="Set Marker Button", pattern="bf 3c xx", x="127*value"},
        {name="Left Marker Button", pattern="bf 3d xx", x="127*value"},
        {name="Right Marker Button", pattern="bf 3e xx", x="127*value"},

        {name="Button S1", pattern="bf 20 xx", x="127*value"},
        {name="Button S2", pattern="bf 21 xx", x="127*value"},
        {name="Button S3", pattern="bf 22 xx", x="127*value"},
        {name="Button S4", pattern="bf 23 xx", x="127*value"},
        {name="Button S5", pattern="bf 24 xx", x="127*value"},
        {name="Button S6", pattern="bf 25 xx", x="127*value"},
        {name="Button S7", pattern="bf 26 xx", x="127*value"},
        {name="Button S8", pattern="bf 27 xx", x="127*value"},

        {name="Button M1", pattern="bf 30 xx", x="127*value"},
        {name="Button M2", pattern="bf 31 xx", x="127*value"},
        {name="Button M3", pattern="bf 32 xx", x="127*value"},
        {name="Button M4", pattern="bf 33 xx", x="127*value"},
        {name="Button M5", pattern="bf 34 xx", x="127*value"},
        {name="Button M6", pattern="bf 35 xx", x="127*value"},
        {name="Button M7", pattern="bf 36 xx", x="127*value"},
        {name="Button M8", pattern="bf 37 xx", x="127*value"},

        {name="Button R1", pattern="bf 40 xx", x="127*value"},
        {name="Button R2", pattern="bf 41 xx", x="127*value"},
        {name="Button R3", pattern="bf 42 xx", x="127*value"},
        {name="Button R4", pattern="bf 43 xx", x="127*value"},
        {name="Button R5", pattern="bf 44 xx", x="127*value"},
        {name="Button R6", pattern="bf 45 xx", x="127*value"},
        {name="Button R7", pattern="bf 46 xx", x="127*value"},
        {name="Button R8", pattern="bf 47 xx", x="127*value"},
    }
 remote.define_auto_outputs(outputs)
end

--"Analogs" indicates non-encoder analog controls and refers to both knobs and sliders on the nanoKONTROL
gNumberOfAnalogs = 16

gAnalogCCLookup = { --converts CC numbers to slider/knob numbers
    [16]=1,[17]=2,[18]=3,[19]=4,[20]=5,[21]=6,[22]=7,[23]=8, --Knobs 1-8
    [0]=9,[1]=10,[2]=11,[3]=12,[4]=13,[5]=14,[6]=15,[7]=16, --Sliders 1-8
    }

gAnalogPhysicalState, gAnalogMachineState, gAnalogMismatch, gLastAnalogMoveTime, gSentValueSettleTime = {}, {}, {}, {}, {}

for i = 1, gNumberOfAnalogs do --set up slider/knob tracking arrays
    gAnalogPhysicalState[i] = 0 --stores current position/value of control on hardware
    gAnalogMachineState[i] = 0 --stores value of connected software item
    gAnalogMismatch[i] = nil --difference between physical state of control and software value (positive numbers indicate physical value is greater, nil indicates mismatch assumption due to unknown physical state at startup)
    gLastAnalogMoveTime[i] = 0 --stores timestamp of last time knob/slider was moved on hardware
    gSentValueSettleTime[i] = 250 --number of milliseconds to wait for a sent slider or knob value to be echoed back before reevaluating synchronization
end

--acceptable difference between the first reported value from a control and the machine state for the 2 to be considered synchronized
gStartupLiveband = 3
function remote_process_midi(event) --manual handling of incoming values sent by controller
    --Analog Messages
    ret=remote.match_midi("BF yy xx", event) --check for messages in channel 1
    if ret~=nil then
        -- Catch knob events
        local AnalogNum = gAnalogCCLookup[ret.y] --try to get the analog number that corresponds to the received Continuous Controller message
        if AnalogNum == nil then --if message isn't from an analog
            return false --pass it on to auto input handling
        else
            gAnalogPhysicalState[AnalogNum] = ret.x --update the stored physical state to the incoming value
            local AllowChange = true --we'll send the incoming value to the host unless we find a reason not to

            if gAnalogMismatch[AnalogNum] ~= 0 then --assess conditions if controller and software values are mismatched
                if gAnalogMismatch[AnalogNum] == nil then --startup condition: analog hasn't reported in yet
                    gAnalogMismatch[AnalogNum] = gAnalogPhysicalState[AnalogNum] - gAnalogMachineState[AnalogNum] --calculate and store how physical and machine states relate to each other
                    if math.abs(gAnalogMismatch[AnalogNum]) > gStartupLiveband then --if the physical value is too far from the machine value
                        AllowChange = false --don't send it to Reason
                    end
                elseif gAnalogMismatch[AnalogNum] > 0 and gAnalogPhysicalState[AnalogNum] - gAnalogMachineState[AnalogNum] > 0 then --if physical state of analog was and still is above virtual value
                    AllowChange = false --don't send the new value to Reason because it's out of sync
                elseif gAnalogMismatch[AnalogNum] < 0 and gAnalogPhysicalState[AnalogNum] - gAnalogMachineState[AnalogNum] < 0 then --if physical state of analog was and still is below virtual value
                    AllowChange = false --don't send the updated value
                end
            end

            if AllowChange then --if the incoming change should be sent to Reason
                remote.handle_input({ time_stamp=event.time_stamp, item=gFirstAnalogIndex + AnalogNum - 1, value=ret.x }) --send the new analog value to Reason
                gLastAnalogMoveTime[AnalogNum] = remote.get_time_ms() --store the time this change was sent
                gAnalogMismatch[AnalogNum] = 0 --and set the flag to show the controller and Reason are in sync
            end
            return true --input has been handled
        end
    end
   return false
end

function remote_set_state(changed_items) --handle incoming changes sent by Reason
    for i,item_index in ipairs(changed_items) do
        local AnalogNum = item_index - gFirstAnalogIndex + 1 --calculate which analog (if any) the index of the changed item indicates
        if AnalogNum >= 1 and AnalogNum <= gNumberOfAnalogs then --if change belongs to an analog control
            gAnalogMachineState[AnalogNum] = remote.get_item_value(item_index) --update the machine state for the analog
            if gAnalogMismatch[AnalogNum] ~= nil then --if we know the analog's physical state
                if (remote.get_time_ms() - gLastAnalogMoveTime[AnalogNum]) > gSentValueSettleTime[AnalogNum] then --and the last value it sent to Reason happened outside the settle time
                    gAnalogMismatch[AnalogNum] = gAnalogPhysicalState[AnalogNum] - gAnalogMachineState[AnalogNum] --recalculate and store how physical and machine states relate to each other
                end
            end
        end
    end
end


function remote_probe()
return {
    request="f0 7e 7f 06 01 f7",
    response="F0 7E 00 06 02 42 13 01 00 00 ?? ?? ?? ?? F7"
    }
end

function remote_prepare_for_use()
-- Sets the nanoKontrol2 to Native Mode
    local retEvents={
        remote.make_midi("F0 42 40 00 01 13 00 00 00 01 F7"),
    }
    return retEvents
end

function remote_release_from_use()
-- Turns Native Mode off
    local retEvents={
        remote.make_midi("F0 42 40 00 01 13 00 00 00 00 F7"),
    }
    return retEvents
end

function trace_event(event)
  result = "Event: "
  result = result .. "port " .. event.port .. ", "
  result = result .. (event.timestamp and ("timestamp " .. event.timestamp .. ", ") or "")
  result = result .. (event.hi and ("hi " .. event.hi .. ", ") or "")
  result = result .. (event.lo and ("lo " .. event.lo .. ", ") or "")
  result = result .. (event.size and ("size " .. event.size .. ", ") or "")

  result = result .. "data {"
  for i=1,event.size do
     result = result .. event[i] .. ", "
  end
  result = result .. "}, "

  remote.trace(result)
end
