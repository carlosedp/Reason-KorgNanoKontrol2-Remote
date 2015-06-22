# Pickup Control Programming

This example is based on the an example controller, but should be easily adaptable for other devices with physically limited (non-encoder) analog controls.

Buttons are handled without any extra code, they're just typical auto inputs. Auto outputs aren't used because the buttons don't react to incoming messages to the controller.

Knobs and Sliders are not set up as auto inputs or outputs. Instead we handle them manually using remote_process_midi (for physical changes being passed to Reason) and remote_set_state (for Reason notifying controller of a GUI change).

## Elements of the .lua File Code

* Global variable indicating total number of analogs.
* Global variable specifying how many analogs are on each virtual page.
* Lookup table that associates MIDI CC Numbers with Analog numbers (the numbers for the analogs are based on their order in the items table).
* 5 global arrays (actually tables in Lua) that store the following information for each analog control:
    * Physical State (gPhysicalState) - The current physical position of the knob or slider, represented by an integer between 0 and 127 (unknown at startup).
    * Machine State (gMachineState) -  Sent by Reason to the controller whenever the analog is connected to a GUI control or the connected GUI control is moved.
    * Analog Mismatch (gAnalogMismatch) - Tracks the difference between the physical and machine states, including the direction of that difference. The core of the codec's capability comes from tracking this mismatch and noticing when it reaches zero or changes polarity, i.e. when the physical control's value matches the GUI control's value or passes from one side of it to the other (we can't count on every integer value being sent, so we may pass without an exact match). This is one of the 2 key elements that make pickup control possible.
    * gAnalogMismatch for each analog control is initialized to nil to indicate that the physical state is unknown when the codec is started.
    * Last Analog Move Time (gLastAnalogMoveTime) - The timestamp of the last instance where the knob or slider sent a new value to Reason.
    * Sent Value Settle Time (gSentValueSettleTime) - When a hardware control is moved (and allowed to send its value to Reason), it will cause a change to the connected GUI control. That changed value will be echoed back to the codec. However, the hardware may still be moving and thus may have a different value by the time the feedback is received. gSentValueSettleTime is the number of milliseconds after a physical move that the codec will allow the physical state and machine state to be different without considering them to be unsynchronized. Here's the other key element, at least the way I see it.
    * Global Variable storing the "Startup Liveband" Value - Since we don't know the physical state of each analog control when the device is first connected to Reason, we allow a small initial difference between the first physical value we receive from the device and the value of the GUI control it's connected to in which we still consider them to be synchronized. I call this the "Liveband". A common situation when starting up is that a paired physical and virtual (GUI) control are both at their upper or lower limit. When the physical control is first moved, it will send a value that's different from its initial position, which means the physical value won't match the virtual value even though they actually started out in sync. If we ignored this, the physical control would have to then be moved back to its starting position in order to "pick up" the virtual control, and then moved away again to effect a change. The Liveband alleviates this problem. Setting the Liveband to a larger value allows the first physical move to be more aggressive (the nanoKontrol and other devices won't necessarily send every value between A and B when moved from position A to position B), and may also catch more instances where the physical and virtual controls start out close but not at their limits.

Below is an example on how to integrate the soft-pickup control to your controller:

Add this variable to beginning of the lua script. It tells the first analog control index in the "items" array. It's currently 3 because our first controle is the third in the "items" array:

    --position of first analog control in the items table
    gFirstAnalogIndex = 3

Add or change your analog controls to have both input and output tags with the "value".

    local items=
     {
      {name="Stop Button", input="button", output="value"},

      {name="Knob 1", input="value", output="value", min=0, max=127},
      {name="Knob 2", input="value", output="value", min=0, max=127},
      {name="Knob 3", input="value", output="value", min=0, max=127},
      {name="Knob 4", input="value", output="value", min=0, max=127},
      {name="Knob 5", input="value", output="value", min=0, max=127},
      ....

In the inputs array, do not map( or comment) the analog CC mapping to avoid automatic match by the Remote engine. Ex:

    local inputs=
     {
      {pattern="b? 2a xx", name="Stop Button", value="x/127"},
      {pattern="b? 29 xx", name="Play Button", value="x/127"},
      -- {pattern="bf 10 xx", name="Knob 1"},
      -- {pattern="bf 11 xx", name="Knob 2"},
      -- {pattern="bf 12 xx", name="Knob 3"},
      ...
       }
    remote.define_auto_inputs(inputs)

There is no need to map the controls in the "outputs" array.

Add the following code to yout script respecting the changes I describe below:

Change this variable to the number of analog controls you have in yout controller. Remember that they must be in the "itens" array **in order**. So if you have 8 knobs and 8 sliders, this must be 16 and all 16 controls must be in the "itens" array (Knob1, Knob2.... Slider1, Slider2...).

    --"Analogs" indicates non-encoder analog controls and refers to both knobs and sliders on the surface
    gNumberOfAnalogs = 16


Here one must map the control index to the CC it sends. The index is the sequence of controls from the "items" array and between the brackets is the CC that control sends. The MIDI channel is set in another section. You find this either in your controller editor or using a MIDI monitor application. I have recommendation in the end of this doc.

    gAnalogCCLookup = { --converts CC numbers to slider/knob numbers
        [16]=1,[17]=2,[18]=3,[19]=4,[20]=5,[21]=6,[22]=7,[23]=8, --Knobs 1-8
        [0]=9,[1]=10,[2]=11,[3]=12,[4]=13,[5]=14,[6]=15,[7]=16, --Sliders 1-8
        }


No need to touch lines below:

    gAnalogPhysicalState, gAnalogMachineState, gAnalogMismatch, gLastAnalogMoveTime, gSentValueSettleTime = {}, {}, {}, {}, {}

    for i = 1, gNumberOfAnalogs do --set up slider/knob tracking arrays
        gAnalogPhysicalState[i] = 0 --stores current position/value of control on hardware
        gAnalogMachineState[i] = 0 --stores value of connected software item
        gAnalogMismatch[i] = nil --difference between physical state of control and software value (positive numbers indicate physical value is greater, nil indicates mismatch assumption due to unknown physical state at startup)
        gLastAnalogMoveTime[i] = 0 --stores timestamp of last time knob/slider was moved on hardware
        gSentValueSettleTime[i] = 250 --number of milliseconds to wait for a sent slider or knob value to be echoed back before reevaluating synchronization
    end


Here the only change needed is to set the MIDI channel used by the analog controls. It goes in the remote.match_midi line and the value is between B0 for channel 1 to BF to channel 16. Below I use BF because my controller uses channel 16. Do not touch the rest of the pattern ("yy xx" part).

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

That's it. For more information consult Propellerhead Remote SDK manuals and test it with the "Codec Test" app provided in the SDK. Just a little quirk that the Codec Test app does not set the statues of the controllers in the first use so you must go to zero on the control and then it will work. This is only in the test app. On Reason everything should work.

### Midi Monitor Apps

[Mac - Snoize MIDI Monitor](http://www.snoize.com/MIDIMonitor/)
[Windows - MIDI-OX](http://www.midiox.com/)
