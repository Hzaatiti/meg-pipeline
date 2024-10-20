% Trigger test for EEG-FMRI
% Author: Hadi Zaatiti <hadi.zaatiti@nyu.edu>

%fingertapping- this one for haidee only stop and tap 
% big font

clear all
close all

global parameters;
global screen;
global tc;
global isTerminationKeyPressed;
global resReport;
global totalTime;
global datapixx;
global PSYCHTOOLBOX;
global VPIXX_USE;

VPIXX_USE = false;
PSYCHTOOLBOX = false;

% Pinout of the trigger socket (digital port) on USB2 Adapter on the
% EEG-FMRI trigger box

% +-----------------------------------------------------+
% | Pin on 26-pin HD D-Sub    | Function   | 25-pin D-Sub/LPT on  | BNC connector on |
% | trigger socket (digital   |            | trigger cable        | trigger cable     |
% | port)                     |            |                      |                  |
% +-----------------------------------------------------+
% |  1                        | Ground     | 25                   | Ground           |
% |  2                        | D01 (S 2)  | 3                    |                  |
% |  3                        | D03 (S 8)  | 5                    |                  |
% |  4                        | D05 (S 32) | 7                    |                  |
% |  5                        | D07 (S128) | 9                    |                  |
% |  6                        | D09 (R 2)  |                      |                  |
% |  7                        | D11 (R 8)  |                      |                  |
% |  8                        | D13 (R 32) |                      |                  |
% |  9                        | D15 (R128) |                      | Signal           |
% | 10                        | Unused     |                      |                  |
% | 11                        | Unused     |                      |                  |
% | 12                        | VCC +3.3 V |                      |                  |
% | 13                        | Unused     |                      |                  |
% | 14                        | D00 (S 1)  | 2                    |                  |
% | 15                        | D02 (S 4)  | 4                    |                  |
% | 16                        | D04 (S 16) | 6                    |                  |
% | 17                        | D06 (S 64) | 8                    |                  |
% | 18                        | D08 (R 1)  |                      |                  |
% | 19                        | D10 (R 4)  |                      |                  |
% | 20                        | D12 (R 16) |                      |                  |
% | 21                        | D14 (R 64) |                      |                  |
% | 22                        | Ground     | 1                    |                  |
% | 23                        | Block+     |                      |                  |
% | 24                        | Block-     |                      |                  |
% | 25                        | 5 kHz out  |                      |                  |
% | 26                        | Unused     |                      |                  |
% +-----------------------------------------------------+



% Table 3: Digital output pin assignment from Vpixx system towards EEG-FMRI
% trigger Box

% +--------------------+--------------------+--------------------+-------------------+
% |        Pin          |     Description    |        Pin          |    Description    |
% +--------------------+--------------------+--------------------+-------------------+
% |         1           |   Digital Out 0    |         14          |   Digital Out 1   |
% |         2           |   Digital Out 2    |         15          |   Digital Out 3   |
% |         3           |   Digital Out 4    |         16          |   Digital Out 5   |
% |         4           |   Digital Out 6    |         17          |   Digital Out 7   |
% |         5           |   Digital Out 8    |         18          |   Digital Out 9   |
% |         6           |   Digital Out 10   |         19          |   Digital Out 11  |
% |         7           |   Digital Out 12   |         20          |   Digital Out 13  |
% |         8           |   Digital Out 14   |         21          |   Digital Out 15  |
% |         9           |   Digital Out 16   |         22          |   Digital Out 17  |
% |        10           |   Digital Out 18   |         23          |   Digital Out 19  |
% |        11           |   Digital Out 20   |         24          |   Digital Out 21  |
% |        12           |   Digital Out 22   |         25          |   Digital Out 23  |
% |        13           |        GND         |      Shield *       |        Shield     |
% +--------------------+--------------------+--------------------+-------------------+

% * Shield is tied to the GND by a 0 Ohm resistor inside the DATAPixx system.



if PSYCHTOOLBOX
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'Verbosity', 0);
end
timingsReport = {};

clear map
map = struct('block',0,...
    'startTime',0,...
    'endTime',0,...
    'totalBlockDuration',0);

timingsReport=cell2mat(timingsReport);
addpath('supportFiles');   
%   Load parameters
%--------------------------------------------------------------------------------------------------------------------------------------%
loadParameters();
 
%   Initialize the subject info
%--------------------------------------------------------------------------------------------------------------------------------------%
initSubjectInfo();

% %  Hide Mouse Cursor

if PSYCHTOOLBOX
    if parameters.hideCursor
        HideCursor()
    end

%   Initialize screen
%--------------------------------------------------------------------------------------------------------------------------------------%
initScreen(); %change transparency of screen from here


%   Convert values from visual degrees to pixels
%--------------------------------------------------------------------------------------------------------------------------------------%
visDegrees2Pix();
end
%   Initialize Datapixx
%-------------------------------------------------------------------------- ------------------------------------------------------------%

if VPIXX_USE
    if ~parameters.isDemoMode
        % datapixx init
        datapixx = 1;               
        AssertOpenGL;   % We use PTB-3;
        isReady =  Datapixx('Open');
        Datapixx('StopAllSchedules');
        Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
    end
end

% Show how many TTL output bits are in the Datapixx
nBits = Datapixx('GetDoutNumBits');
fprintf('\nDATAPixx has %d TTL output bits\n\n', nBits);

% Bring 1 output high
HitKeyToContinue('\nHit any key to bring digital output bit 0 high:');
Datapixx('SetDoutValues', 1);
Datapixx('RegWrRd');

% According to BrainProducts datasheet:
% +-----------------------------------------------------+
% | Pin on 26-pin HD D-Sub    | Function   | 25-pin D-Sub/LPT on  | BNC connector on |
% | trigger socket (digital   |            | trigger cable        | trigger cable     |
% | port)                     |            |                      |                  |
% +-----------------------------------------------------+
% |  2                        | D01 (S 2)  | 3                    |                  |
% |  3                        | D03 (S 8)  | 5                    |                  |
% |  4                        | D05 (S 32) | 7                    |                  |
% |  5                        | D07 (S128) | 9                    |                  |
% | 14                        | D00 (S 1)  | 2                    |                  |
% | 15                        | D02 (S 4)  | 4                    |                  |
% | 16                        | D04 (S 16) | 6                    |                  |
% | 17                        | D06 (S 64) | 8                    |                  |


% In MRI we have a 25-pin D-Sub cable so we care about this column
% Trigger S2 marker by activating the 3rd pin of the 25-pin D-sub cable
% The 3rd pin corresponds to digital output 4 on the vpixx system
% 4 in binary is 0100

% Should trigger S2 marker on EEG
HitKeyToContinue('\nHit any key to bring the EEG S2 marker on:');
Datapixx('SetDoutValues', (2^nBits) - 1);
Datapixx('RegWrRd');


% Bring all the outputs high
HitKeyToContinue('\nHit any key to bring all the digital outputs high:');
Datapixx('SetDoutValues', (2^nBits) - 1);
Datapixx('RegWrRd');

% Bring all the outputs low
HitKeyToContinue('\nHit any key to bring all the digital outputs low:');
Datapixx('SetDoutValues', 0);
Datapixx('RegWrRd');


if VPIXX_USE
    if ~parameters.isDemoMode
        % datapixx shutdown
        Datapixx('RegWrRd');
        Datapixx('StopAllSchedules');
        Datapixx('Close');
    end
end