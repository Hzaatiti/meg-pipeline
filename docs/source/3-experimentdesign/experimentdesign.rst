.. _design_experiment:

Designing your MEG experiment
=============================

Purpose
-------

This section provides information to help you out designing your MEG experiment.
What is meant by experiment, is the stimuli involving usually visual and auditory or other perception-type stimulus.
The experiment defines the timing of display of the stimuli, tracks responses from the participants and controls the different settings related
to the content being presented to the participant.
This section also provides the requirements that should be met to run your experiment in the NYUAD MEG Lab.
Roughly speaking, the experiment should be designed in a way such that:

- when the participant performs the experiment, a specific behavior in the brain is triggered due to the stimulus from the experiment
- which you should "beleive" that, when MEG/EEG measurements are obtained, would nicely `highlight` the specific behavior

Therefore, the design of an experiment should come after extensive research about the phenomena that we would like to characterize.


There are three tools primarily used for designing the experiment used in NYUAD MEG Lab

- Psychtoolbox: a MATLAB based library (all NYUAD affiliated students/employees have access to MATLAB)
- Presentation: a powerful license based software (a license is available at the NYUAD MEG LAB)
- Psychopy: an open source Python library with both GUI based design and code based design


Defining the hardware needs for your experiment
------------------------------------------------

Depending on your study you might need different require different hardware, the following use cases can be identified:

- Show visual stimuli to participants for a certain amount of time
- Allow participant to send their input via buttons
- Get eyetracking information from the eyetracker device
- Provide audio to the user
- Record audio from the user's voice

Hardware involved in experiment
-------------------------------

- Propixx
- Datapixx
- Eyetracker

Datapixx pixel mode `Pixel mode <https://docs.vpixx.com/vocal/defining-triggers-using-pixel-mode>`_.

The eyetracker sends three different signals to the MEG/EEG channels:

- The X-coordinates of the eye as function of time
- The Y-coordinates of the eye as function of time
- The Area of the pupil of the eye as function of time


Files produced by the experiment design
---------------------------------------


- An experiment in PsychToolBox is a `.m` MATLAB script.
- Presentation provides a `.exp` file, an experiment file.
- PsychoPy is a `.py` experiment file.

If using python library PsychoPy:

* Open the file with .psyexp extension
* you can run from within the psycopy builder the experiment file with .psyexp extension c



Pixel mode experiments
----------------------

All experiments that uses the Vpixx pixel mode should follow these rules:

- Once the experiment script is run, the experiment should land on an `Introduction page` that requires a button press to be able to continue by the project owner (the participant should not be able to continue through this page)
- Prior to landing on the `Introduction page` within your script, you should deactivate the Vpixx Pixel Mode, otherwise there could be false trigger events in the data recording


"Presentation" based experiments
--------------------------------

Experiments coded in "Presentation" do not enable the Vpixx pixel mode by default.
If your experiment uses Pixel Mode (i.e., you are using the color of the top left pixel of the screen as a condition to send triggers), you must run the `enablepixelmode.m` script.
Find the script under  `experiments/psychtoolbox/general/enablepixelmode.m <https://github.com/hzaatiti-NYU/meg-pipeline/blob/main/experiments/psychtoolbox/general/enablepixelmode.m>`_


KIT experiment length
---------------------

The maximum length of a KIT `.con` file recording can be 4000 seconds = 66 minutes, this is the maximum total length of the recording.
Therefore, the design of your experiment that requires more then this time, should be performed in blocks each of maximum total duration of ideally 55 minutes (to have a safety time margin).
When the recording reaches the final length, a new recording must start (this is described in the KIT operational protocol).


KIT system testing triggers
---------------------------

If you are in the testing phase of your experiment and would like to test the triggers, you can do so without locking the sensors.
Simply open `MEG160` and then `Acquire -> MEG Measurement`, then run your experiment from the stimulus computer and observe channels 224 -> 231 to check for trigger signals.






PsychoPy experiment
-------------------

Adapting your PsychoPy experiment to the NYUAD setup requires the following:
- add code for sending triggers
- add code for Vpixx accessories devices (response box, eyetracker and so on)

- add code for importing the `utilities` functions found under `experiments/psychopy/general/utilities.py`
    .. code:: python

        from experiments.psychopy.general.utilities import *

- Add the Vpixx library import at the beginning of your `.py` PsychoPy experiment

    .. code:: python

        from pypixxlib import _libdpx as dp

- At the beginning of your script add the code to establish the connection with Vpixx devices and disable PixelMode in case it was already active

    .. code:: python

        dp.DPxOpen()
        dp.DPxDisableDoutPixelMode()
        dp.DPxWriteRegCache()
        dp.DPxSetDoutValue(RGB2Trigger(black), 0xFFFFFF)
        dp.DPxUpdateRegCache()


- At the end of your code add the code to disable the connection with Vpixx

    .. code:: python

        dp.DPxClose()

- Ideally, you would want to add a boolean flag `USE_VPIXX` that enables or not the connection and enclose the above code with the boolean condition
    - This will allow you to keep testing your experiment on your local computer that doesn't have Vpixx devices so that it doesn't crash from the Vpixx specific code

    .. code:: python

        USE_VPIXX = TRUE



PsychoPy code for sending triggers
----------------------------------

- Decide on how many trigger events are needed
    - If less than 8 event types, then you can use the 8 trigger channels of the KIT independently from one another
        - In this case, to activate channel 224 for example add the following code everytime you want to trigger the channel

        .. code:: python

            dp.DPxSetDoutValue(trigger_channels_dictionary[224], 0xFFFFFF)
            dp.DPxUpdateRegCache()

        - The above code will keep the channel 224 on the high level, we will need to set it back to the low level after a small delay (typically 10 frames)

        .. code:: python

            dp.DPxSetDoutValue(RGB2Trigger(black), 0xFFFFFF)
            dp.DPxUpdateRegCache()

    - If more than 8 event types are needed, then you can use each all 8 trigger channels in the combined binary mode
        - channels 224 to 231 will be interpreted as a binary code of zeros and ones with 224 being the most significant bit and 231 the least significant bit
        - In this case, design your trigger matrix containing for each stimulus, which 8 bit binary code shall be used to represent the type of the event
        - In your experiment code, everytime you would like to display a stimulus and activate the corresponding trigger code, you will need to add the following lines

        .. code:: python

            # Presuming your experiment import information about your trial from a .csv file then:
            # trialList is a csv where each row correspond to a trial
            # trialIndex is an index indicating the current number of the trial
            # the value of trialList[trialIndex]['trigger224'] is either 0 or 1 and correspond to the bit of channel 224
            # trigger_channels_dictionary is imported from the utilities and provides the channel-specific code
            combined_trigger_value = (
                trialList[trialIndex]['trigger224'] * trigger_channels_dictionary[224] +
                trialList[trialIndex]['trigger225'] * trigger_channels_dictionary[225] +
                trialList[trialIndex]['trigger226'] * trigger_channels_dictionary[226] +
                trialList[trialIndex]['trigger227'] * trigger_channels_dictionary[227] +
                trialList[trialIndex]['trigger228'] * trigger_channels_dictionary[228] +
                trialList[trialIndex]['trigger229'] * trigger_channels_dictionary[229] +
                trialList[trialIndex]['trigger230'] * trigger_channels_dictionary[230] +
                trialList[trialIndex]['trigger231'] * trigger_channels_dictionary[231]
            )
            print(f"Trial {trialIndex}, Trigger: Combined Value = {combined_trigger_value}")

            # Once the value is computed, then we can send it to Vpixx

            dp.DPxSetDoutValue(combined_trigger_value, 0xFFFFFF)
            dp.DPxUpdateRegCache()

        - The above code will keep the combination of selected channels on the high level, we will need to set it back to the low level (00000000) after a small delay (typically 10 frames)
            - Make an if/else test for the proper frame to stop the trigger activation

            .. code:: python

                dp.DPxSetDoutValue(RGB2Trigger(black), 0xFFFFFF)
                dp.DPxUpdateRegCache()

Psychopy Code for response boxes
--------------------------------

