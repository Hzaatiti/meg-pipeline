#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2024.2.4),
    on February 20, 2025, at 11:49
If you publish work using this script the most relevant publication is:

    Peirce J, Gray JR, Simpson S, MacAskill M, Höchenberger R, Sogo H, Kastman E, Lindeløv JK. (2019)
        PsychoPy2: Experiments in behavior made easy Behav Res 51: 195.
        https://doi.org/10.3758/s13428-018-01193-y

"""

import psychopy

psychopy.useVersion('2024.2.4')

# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
from experiments.psychopy.general.utilities import *
from pypixxlib import _libdpx as dp

plugins.activatePlugins()
prefs.hardware['audioLib'] = 'ptb'
prefs.hardware['audioLatencyMode'] = '3'
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout, hardware
from psychopy.tools import environmenttools
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER, priority)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding

from psychopy.hardware import keyboard



USE_VPIXX = False

if USE_VPIXX:
    dp.DPxOpen()
    dp.DPxDisableDoutPixelMode()
    dp.DPxWriteRegCache()
    dp.DPxSetDoutValue(RGB2Trigger(black), 0xFFFFFF)
    dp.DPxUpdateRegCache()

# --- Setup global variables (available in all functions) ---
# create a device manager to handle hardware (keyboards, mice, mirophones, speakers, etc.)
deviceManager = hardware.DeviceManager()
# ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
# store info about the experiment session
psychopyVersion = '2024.2.4'
expName = 'masked_priming_english_new_implementation'  # from the Builder filename that created this script
# information about this experiment
expInfo = {
    'participant': f"{randint(0, 999999):06.0f}",
    'list': '01a',
    'date|hid': data.getDateStr(),
    'expName|hid': expName,
    'psychopyVersion|hid': psychopyVersion,
}

# --- Define some variables which will change depending on pilot mode ---
'''
To run in pilot mode, either use the run/pilot toggle in Builder, Coder and Runner, 
or run the experiment with `--pilot` as an argument. To change what pilot 
#mode does, check out the 'Pilot mode' tab in preferences.
'''
# work out from system args whether we are running in pilot mode
PILOTING = core.setPilotModeFromArgs()
# start off with values from experiment settings
_fullScr = True
_winSize = [3008, 1692]
# if in pilot mode, apply overrides according to preferences
if PILOTING:
    # force windowed mode
    if prefs.piloting['forceWindowed']:
        _fullScr = False
        # set window size
        _winSize = prefs.piloting['forcedWindowSize']


def showExpInfoDlg(expInfo):
    """
    Show participant info dialog.
    Parameters
    ==========
    expInfo : dict
        Information about this experiment.

    Returns
    ==========
    dict
        Information about this experiment.
    """
    # show participant info dialog
    dlg = gui.DlgFromDict(
        dictionary=expInfo, sortKeys=False, title=expName, alwaysOnTop=True
    )
    if dlg.OK == False:
        core.quit()  # user pressed cancel
    # return expInfo
    return expInfo


def setupData(expInfo, dataDir=None):
    """
    Make an ExperimentHandler to handle trials and saving.

    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    dataDir : Path, str or None
        Folder to save the data to, leave as None to create a folder in the current directory.
    Returns
    ==========
    psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    """
    # remove dialog-specific syntax from expInfo
    for key, val in expInfo.copy().items():
        newKey, _ = data.utils.parsePipeSyntax(key)
        expInfo[newKey] = expInfo.pop(key)

    # data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
    if dataDir is None:
        dataDir = _thisDir
    filename = u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])
    # make sure filename is relative to dataDir
    if os.path.isabs(filename):
        dataDir = os.path.commonprefix([dataDir, filename])
        filename = os.path.relpath(filename, dataDir)

    # an ExperimentHandler isn't essential but helps with data saving
    thisExp = data.ExperimentHandler(
        name=expName, version='',
        extraInfo=expInfo, runtimeInfo=None,
        originPath='C:\\Users\\hz3752\\PycharmProjects\\meg-pipeline\\experiments\\psychopy\\DiogoLab\\masked-priming-experiment\\masked_priming_english_new_implementation.py',
        savePickle=True, saveWideText=True,
        dataFileName=dataDir + os.sep + filename, sortColumns='time'
    )
    thisExp.setPriority('thisRow.t', priority.CRITICAL)
    thisExp.setPriority('expName', priority.LOW)
    # return experiment handler
    return thisExp


def setupLogging(filename):
    """
    Setup a log file and tell it what level to log at.

    Parameters
    ==========
    filename : str or pathlib.Path
        Filename to save log file and data files as, doesn't need an extension.

    Returns
    ==========
    psychopy.logging.LogFile
        Text stream to receive inputs from the logging system.
    """
    # set how much information should be printed to the console / app
    if PILOTING:
        logging.console.setLevel(
            prefs.piloting['pilotConsoleLoggingLevel']
        )
    else:
        logging.console.setLevel('warning')
    # save a log file for detail verbose info
    logFile = logging.LogFile(filename + '.log')
    if PILOTING:
        logFile.setLevel(
            prefs.piloting['pilotLoggingLevel']
        )
    else:
        logFile.setLevel(
            logging.getLevel('debug')
        )

    return logFile


def setupWindow(expInfo=None, win=None):
    """
    Setup the Window

    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    win : psychopy.visual.Window
        Window to setup - leave as None to create a new window.

    Returns
    ==========
    psychopy.visual.Window
        Window in which to run this experiment.
    """
    if PILOTING:
        logging.debug('Fullscreen settings ignored as running in pilot mode.')

    if win is None:
        # if not given a window to setup, make one
        win = visual.Window(
            size=_winSize, fullscr=_fullScr, screen=0,
            winType='pyglet', allowGUI=True, allowStencil=False,
            monitor='laptopDiogo', color=[0, 0, 0], colorSpace='rgb',
            backgroundImage='', backgroundFit='none',
            blendMode='avg', useFBO=True,
            units='height',
            checkTiming=False  # we're going to do this ourselves in a moment
        )
    else:
        # if we have a window, just set the attributes which are safe to set
        win.color = [0, 0, 0]
        win.colorSpace = 'rgb'
        win.backgroundImage = ''
        win.backgroundFit = 'none'
        win.units = 'height'
    if expInfo is not None:
        # get/measure frame rate if not already in expInfo
        if win._monitorFrameRate is None:
            win._monitorFrameRate = win.getActualFrameRate(
                infoMsg='Attempting to measure frame rate of screen, please wait...')
        expInfo['frameRate'] = win._monitorFrameRate
    win.hideMessage()
    # show a visual indicator if we're in piloting mode
    if PILOTING and prefs.piloting['showPilotingIndicator']:
        win.showPilotingIndicator()

    return win


def setupDevices(expInfo, thisExp, win):
    """
    Setup whatever devices are available (mouse, keyboard, speaker, eyetracker, etc.) and add them to
    the device manager (deviceManager)

    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    win : psychopy.visual.Window
        Window in which to run this experiment.
    Returns
    ==========
    bool
        True if completed successfully.
    """
    # --- Setup input devices ---
    ioConfig = {}
    ioSession = ioServer = eyetracker = None

    # store ioServer object in the device manager
    deviceManager.ioServer = ioServer

    # create a default keyboard (e.g. to check for escape)
    if deviceManager.getDevice('defaultKeyboard') is None:
        deviceManager.addDevice(
            deviceClass='keyboard', deviceName='defaultKeyboard', backend='ptb'
        )
    if deviceManager.getDevice('start_exp') is None:
        # initialise start_exp
        start_exp = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='start_exp',
        )
    if deviceManager.getDevice('get_practice') is None:
        # initialise get_practice
        get_practice = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='get_practice',
        )
    if deviceManager.getDevice('lex_dec') is None:
        # initialise lex_dec
        lex_dec = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='lex_dec',
        )
    if deviceManager.getDevice('get_exp') is None:
        # initialise get_exp
        get_exp = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='get_exp',
        )
    if deviceManager.getDevice('finish_break') is None:
        # initialise finish_break
        finish_break = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='finish_break',
        )
    if deviceManager.getDevice('end_experiment') is None:
        # initialise end_experiment
        end_experiment = deviceManager.addDevice(
            deviceClass='keyboard',
            deviceName='end_experiment',
        )
    # return True if completed successfully
    return True


def pauseExperiment(thisExp, win=None, timers=[], playbackComponents=[]):
    """
    Pause this experiment, preventing the flow from advancing to the next routine until resumed.

    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    win : psychopy.visual.Window
        Window for this experiment.
    timers : list, tuple
        List of timers to reset once pausing is finished.
    playbackComponents : list, tuple
        List of any components with a `pause` method which need to be paused.
    """
    # if we are not paused, do nothing
    if thisExp.status != PAUSED:
        return

    # start a timer to figure out how long we're paused for
    pauseTimer = core.Clock()
    # pause any playback components
    for comp in playbackComponents:
        comp.pause()
    # make sure we have a keyboard
    defaultKeyboard = deviceManager.getDevice('defaultKeyboard')
    if defaultKeyboard is None:
        defaultKeyboard = deviceManager.addKeyboard(
            deviceClass='keyboard',
            deviceName='defaultKeyboard',
            backend='PsychToolbox',
        )
    # run a while loop while we wait to unpause
    while thisExp.status == PAUSED:
        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=['escape']):
            endExperiment(thisExp, win=win)
        # sleep 1ms so other threads can execute
        clock.time.sleep(0.001)
    # if stop was requested while paused, quit
    if thisExp.status == FINISHED:
        endExperiment(thisExp, win=win)
    # resume any playback components
    for comp in playbackComponents:
        comp.play()
    # reset any timers
    for timer in timers:
        timer.addTime(-pauseTimer.getTime())


def run(expInfo, thisExp, win, globalClock=None, thisSession=None):
    """
    Run the experiment flow.

    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    psychopy.visual.Window
        Window in which to run this experiment.
    globalClock : psychopy.core.clock.Clock or None
        Clock to get global time from - supply None to make a new one.
    thisSession : psychopy.session.Session or None
        Handle of the Session object this experiment is being run from, if any.
    """
    # mark experiment as started
    thisExp.status = STARTED
    # make sure window is set to foreground to prevent losing focus
    win.winHandle.activate()
    # make sure variables created by exec are available globally
    exec = environmenttools.setExecEnvironment(globals())
    # get device handles from dict of input devices
    ioServer = deviceManager.ioServer
    # get/create a default keyboard (e.g. to check for escape)
    defaultKeyboard = deviceManager.getDevice('defaultKeyboard')
    if defaultKeyboard is None:
        deviceManager.addDevice(
            deviceClass='keyboard', deviceName='defaultKeyboard', backend='PsychToolbox'
        )
    eyetracker = deviceManager.getDevice('eyetracker')
    # make sure we're running in the directory for this experiment
    os.chdir(_thisDir)
    # get filename from ExperimentHandler for convenience
    filename = thisExp.dataFileName
    frameTolerance = 0.001  # how close to onset before 'same' frame
    endExpNow = False  # flag for 'escape' or other condition => quit the exp
    # get frame duration from frame rate in expInfo
    if 'frameRate' in expInfo and expInfo['frameRate'] is not None:
        frameDur = 1.0 / round(expInfo['frameRate'])
    else:
        frameDur = 1.0 / 60.0  # could not measure, so guess

    # Start Code - component code to be run after the window creation

    # --- Initialize components for Routine "Instructions" ---
    instructions = visual.TextStim(win=win, name='instructions',
                                   text='In this experiment, you will be reading strings of letters on the screen.\n\nSometimes they will spell a word in English, like FOREST. \n\nSometimes they will not, like BLICKET.\n\nYour task is to judge, for each string, whether it spells a word in English.\n\nIf you think the string spells a word, press F.\n\nIf you think it does not spell a word, press J.\n',
                                   font='Arial',
                                   pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                   color='white', colorSpace='rgb', opacity=None,
                                   languageStyle='LTR',
                                   depth=0.0);
    start_exp = keyboard.Keyboard(deviceName='start_exp')

    # --- Initialize components for Routine "StartPractice" ---
    start_practice = visual.TextStim(win=win, name='start_practice',
                                     text='You are now ready to start the practice.\n\nRemember, your task is to judge whether each string you read spells a word of English.\n\nPress F, if you think it is a word.\n\nPress J, if you think it is not a word.\n\nLet the experimenter know when you are ready to start the practice.',
                                     font='Arial',
                                     pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                     color='white', colorSpace='rgb', opacity=None,
                                     languageStyle='LTR',
                                     depth=0.0);
    get_practice = keyboard.Keyboard(deviceName='get_practice')

    # --- Initialize components for Routine "ITI" ---
    inter_trial_int = visual.TextStim(win=win, name='inter_trial_int',
                                      text=None,
                                      font='Arial',
                                      pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                      color='white', colorSpace='rgb', opacity=None,
                                      languageStyle='LTR',
                                      depth=0.0);

    # --- Initialize components for Routine "three_field_masked_priming" ---
    mask = visual.TextStim(win=win, name='mask',
                           text='######',
                           font='Courier',
                           pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                           color='white', colorSpace='rgb', opacity=None,
                           languageStyle='LTR',
                           depth=0.0);
    prime = visual.TextStim(win=win, name='prime',
                            text='',
                            font='Courier',
                            pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                            color='white', colorSpace='rgb', opacity=None,
                            languageStyle='LTR',
                            depth=-1.0);
    target = visual.TextStim(win=win, name='target',
                             text='',
                             font='Courier',
                             pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                             color='white', colorSpace='rgb', opacity=None,
                             languageStyle='LTR',
                             depth=-2.0);
    lex_dec = keyboard.Keyboard(deviceName='lex_dec')

    # --- Initialize components for Routine "StartExp" ---
    start_experiment = visual.TextStim(win=win, name='start_experiment',
                                       text='Any questions? Please let us know now.\n\nOtherwise, let the experimenter know you are ready to start.',
                                       font='Arial',
                                       pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                       color='white', colorSpace='rgb', opacity=None,
                                       languageStyle='LTR',
                                       depth=0.0);
    get_exp = keyboard.Keyboard(deviceName='get_exp')

    # --- Initialize components for Routine "is_break" ---
    take_break = visual.TextStim(win=win, name='take_break',
                                 text='Please take a quick break now.\n\nRemember, your task is to judge, for each string you read, whether it spells a word of English.\n\nPress F if it does, and J if it does not.\n\nYou can continue by pressing the space bar.',
                                 font='Arial',
                                 pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                 color='white', colorSpace='rgb', opacity=None,
                                 languageStyle='LTR',
                                 depth=0.0);
    finish_break = keyboard.Keyboard(deviceName='finish_break')

    # --- Initialize components for Routine "ITI" ---
    inter_trial_int = visual.TextStim(win=win, name='inter_trial_int',
                                      text=None,
                                      font='Arial',
                                      pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                                      color='white', colorSpace='rgb', opacity=None,
                                      languageStyle='LTR',
                                      depth=0.0);

    # --- Initialize components for Routine "three_field_masked_priming" ---
    mask = visual.TextStim(win=win, name='mask',
                           text='######',
                           font='Courier',
                           pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                           color='white', colorSpace='rgb', opacity=None,
                           languageStyle='LTR',
                           depth=0.0);
    prime = visual.TextStim(win=win, name='prime',
                            text='',
                            font='Courier',
                            pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                            color='white', colorSpace='rgb', opacity=None,
                            languageStyle='LTR',
                            depth=-1.0);
    target = visual.TextStim(win=win, name='target',
                             text='',
                             font='Courier',
                             pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                             color='white', colorSpace='rgb', opacity=None,
                             languageStyle='LTR',
                             depth=-2.0);
    lex_dec = keyboard.Keyboard(deviceName='lex_dec')

    # --- Initialize components for Routine "EndExp" ---
    end_exp = visual.TextStim(win=win, name='end_exp',
                              text='The experiment is over!\n\nThank you for your participation.\n\nPlease remain still and wait until the experimenter come help you out of the room.\n\n[Press the space bar to exit this screen]',
                              font='Arial',
                              pos=(0, 0), draggable=False, height=0.05, wrapWidth=None, ori=0.0,
                              color='white', colorSpace='rgb', opacity=None,
                              languageStyle='LTR',
                              depth=0.0);
    end_experiment = keyboard.Keyboard(deviceName='end_experiment')

    # create some handy timers

    # global clock to track the time since experiment started
    if globalClock is None:
        # create a clock if not given one
        globalClock = core.Clock()
    if isinstance(globalClock, str):
        # if given a string, make a clock accoridng to it
        if globalClock == 'float':
            # get timestamps as a simple value
            globalClock = core.Clock(format='float')
        elif globalClock == 'iso':
            # get timestamps in ISO format
            globalClock = core.Clock(format='%Y-%m-%d_%H:%M:%S.%f%z')
        else:
            # get timestamps in a custom format
            globalClock = core.Clock(format=globalClock)
    if ioServer is not None:
        ioServer.syncClock(globalClock)
    logging.setDefaultClock(globalClock)
    # routine timer to track time remaining of each (possibly non-slip) routine
    routineTimer = core.Clock()
    win.flip()  # flip window to reset last flip timer
    # store the exact time the global clock started
    expInfo['expStart'] = data.getDateStr(
        format='%Y-%m-%d %Hh%M.%S.%f %z', fractionalSecondDigits=6
    )

    # --- Prepare to start Routine "Instructions" ---
    # create an object to store info about Routine Instructions
    Instructions = data.Routine(
        name='Instructions',
        components=[instructions, start_exp],
    )
    Instructions.status = NOT_STARTED
    continueRoutine = True
    # update component parameters for each repeat
    # create starting attributes for start_exp
    start_exp.keys = []
    start_exp.rt = []
    _start_exp_allKeys = []
    # store start times for Instructions
    Instructions.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
    Instructions.tStart = globalClock.getTime(format='float')
    Instructions.status = STARTED
    thisExp.addData('Instructions.started', Instructions.tStart)
    Instructions.maxDuration = None
    # keep track of which components have finished
    InstructionsComponents = Instructions.components
    for thisComponent in Instructions.components:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1

    # --- Run Routine "Instructions" ---
    Instructions.forceEnded = routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *instructions* updates

        # if instructions is starting this frame...
        if instructions.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            instructions.frameNStart = frameN  # exact frame index
            instructions.tStart = t  # local t and not account for scr refresh
            instructions.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(instructions, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'instructions.started')
            # update status
            instructions.status = STARTED
            instructions.setAutoDraw(True)

        # if instructions is active this frame...
        if instructions.status == STARTED:
            # update params
            pass

        # *start_exp* updates
        waitOnFlip = False

        # if start_exp is starting this frame...
        if start_exp.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            start_exp.frameNStart = frameN  # exact frame index
            start_exp.tStart = t  # local t and not account for scr refresh
            start_exp.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(start_exp, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'start_exp.started')
            # update status
            start_exp.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(start_exp.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(start_exp.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if start_exp.status == STARTED and not waitOnFlip:
            theseKeys = start_exp.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _start_exp_allKeys.extend(theseKeys)
            if len(_start_exp_allKeys):
                start_exp.keys = _start_exp_allKeys[-1].name  # just the last key pressed
                start_exp.rt = _start_exp_allKeys[-1].rt
                start_exp.duration = _start_exp_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False

        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, win=win)
            return
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp,
                win=win,
                timers=[routineTimer],
                playbackComponents=[]
            )
            # skip the frame we paused on
            continue

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            Instructions.forceEnded = routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in Instructions.components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # --- Ending Routine "Instructions" ---
    for thisComponent in Instructions.components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store stop times for Instructions
    Instructions.tStop = globalClock.getTime(format='float')
    Instructions.tStopRefresh = tThisFlipGlobal
    thisExp.addData('Instructions.stopped', Instructions.tStop)
    # check responses
    if start_exp.keys in ['', [], None]:  # No response was made
        start_exp.keys = None
    thisExp.addData('start_exp.keys', start_exp.keys)
    if start_exp.keys != None:  # we had a response
        thisExp.addData('start_exp.rt', start_exp.rt)
        thisExp.addData('start_exp.duration', start_exp.duration)
    thisExp.nextEntry()
    # the Routine "Instructions" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()

    # --- Prepare to start Routine "StartPractice" ---
    # create an object to store info about Routine StartPractice
    StartPractice = data.Routine(
        name='StartPractice',
        components=[start_practice, get_practice],
    )
    StartPractice.status = NOT_STARTED
    continueRoutine = True
    # update component parameters for each repeat
    # create starting attributes for get_practice
    get_practice.keys = []
    get_practice.rt = []
    _get_practice_allKeys = []
    # store start times for StartPractice
    StartPractice.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
    StartPractice.tStart = globalClock.getTime(format='float')
    StartPractice.status = STARTED
    thisExp.addData('StartPractice.started', StartPractice.tStart)
    StartPractice.maxDuration = None
    # keep track of which components have finished
    StartPracticeComponents = StartPractice.components
    for thisComponent in StartPractice.components:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1

    # --- Run Routine "StartPractice" ---
    StartPractice.forceEnded = routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *start_practice* updates

        # if start_practice is starting this frame...
        if start_practice.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            start_practice.frameNStart = frameN  # exact frame index
            start_practice.tStart = t  # local t and not account for scr refresh
            start_practice.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(start_practice, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'start_practice.started')
            # update status
            start_practice.status = STARTED
            start_practice.setAutoDraw(True)

        # if start_practice is active this frame...
        if start_practice.status == STARTED:
            # update params
            pass

        # *get_practice* updates
        waitOnFlip = False

        # if get_practice is starting this frame...
        if get_practice.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            get_practice.frameNStart = frameN  # exact frame index
            get_practice.tStart = t  # local t and not account for scr refresh
            get_practice.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(get_practice, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'get_practice.started')
            # update status
            get_practice.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(get_practice.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(get_practice.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if get_practice.status == STARTED and not waitOnFlip:
            theseKeys = get_practice.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _get_practice_allKeys.extend(theseKeys)
            if len(_get_practice_allKeys):
                get_practice.keys = _get_practice_allKeys[-1].name  # just the last key pressed
                get_practice.rt = _get_practice_allKeys[-1].rt
                get_practice.duration = _get_practice_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False

        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, win=win)
            return
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp,
                win=win,
                timers=[routineTimer],
                playbackComponents=[]
            )
            # skip the frame we paused on
            continue

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            StartPractice.forceEnded = routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in StartPractice.components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # --- Ending Routine "StartPractice" ---
    for thisComponent in StartPractice.components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store stop times for StartPractice
    StartPractice.tStop = globalClock.getTime(format='float')
    StartPractice.tStopRefresh = tThisFlipGlobal
    thisExp.addData('StartPractice.stopped', StartPractice.tStop)
    # check responses
    if get_practice.keys in ['', [], None]:  # No response was made
        get_practice.keys = None
    thisExp.addData('get_practice.keys', get_practice.keys)
    if get_practice.keys != None:  # we had a response
        thisExp.addData('get_practice.rt', get_practice.rt)
        thisExp.addData('get_practice.duration', get_practice.duration)
    thisExp.nextEntry()
    # the Routine "StartPractice" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()

    # set up handler to look after randomisation of conditions etc
    practice = data.TrialHandler2(
        name='practice',
        nReps=1.0,
        method='random',
        extraInfo=expInfo,
        originPath=-1,
        trialList=data.importConditions('Practice.csv'),
        seed=None,
    )
    thisExp.addLoop(practice)  # add the loop to the experiment
    thisPractice = practice.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisPractice.rgb)
    if thisPractice != None:
        for paramName in thisPractice:
            globals()[paramName] = thisPractice[paramName]
    if thisSession is not None:
        # if running in a Session with a Liaison client, send data up to now
        thisSession.sendExperimentData()

    for thisPractice in practice:
        currentLoop = practice
        thisExp.timestampOnFlip(win, 'thisRow.t', format=globalClock.format)
        if thisSession is not None:
            # if running in a Session with a Liaison client, send data up to now
            thisSession.sendExperimentData()
        # abbreviate parameter names if possible (e.g. rgb = thisPractice.rgb)
        if thisPractice != None:
            for paramName in thisPractice:
                globals()[paramName] = thisPractice[paramName]

        # --- Prepare to start Routine "ITI" ---
        # create an object to store info about Routine ITI
        ITI = data.Routine(
            name='ITI',
            components=[inter_trial_int],
        )
        ITI.status = NOT_STARTED
        continueRoutine = True
        # update component parameters for each repeat
        # store start times for ITI
        ITI.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
        ITI.tStart = globalClock.getTime(format='float')
        ITI.status = STARTED
        thisExp.addData('ITI.started', ITI.tStart)
        ITI.maxDuration = None
        # keep track of which components have finished
        ITIComponents = ITI.components
        for thisComponent in ITI.components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1

        # --- Run Routine "ITI" ---
        # if trial has changed, end Routine now
        if isinstance(practice, data.TrialHandler2) and thisPractice.thisN != practice.thisTrial.thisN:
            continueRoutine = False
        ITI.forceEnded = routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame

            # *inter_trial_int* updates

            # if inter_trial_int is starting this frame...
            if inter_trial_int.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                inter_trial_int.frameNStart = frameN  # exact frame index
                inter_trial_int.tStart = t  # local t and not account for scr refresh
                inter_trial_int.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(inter_trial_int, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'inter_trial_int.started')
                # update status
                inter_trial_int.status = STARTED
                inter_trial_int.setAutoDraw(True)

            # if inter_trial_int is active this frame...
            if inter_trial_int.status == STARTED:
                # update params
                pass

            # if inter_trial_int is stopping this frame...
            if inter_trial_int.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > inter_trial_int.tStartRefresh + random() * (1.5 - 0.9) + 0.9 - frameTolerance:
                    # keep track of stop time/frame for later
                    inter_trial_int.tStop = t  # not accounting for scr refresh
                    inter_trial_int.tStopRefresh = tThisFlipGlobal  # on global time
                    inter_trial_int.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'inter_trial_int.stopped')
                    # update status
                    inter_trial_int.status = FINISHED
                    inter_trial_int.setAutoDraw(False)

            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, win=win)
                return
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp,
                    win=win,
                    timers=[routineTimer],
                    playbackComponents=[]
                )
                # skip the frame we paused on
                continue

            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                ITI.forceEnded = routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in ITI.components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished

            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()

        # --- Ending Routine "ITI" ---
        for thisComponent in ITI.components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # store stop times for ITI
        ITI.tStop = globalClock.getTime(format='float')
        ITI.tStopRefresh = tThisFlipGlobal
        thisExp.addData('ITI.stopped', ITI.tStop)
        # the Routine "ITI" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()

        # --- Prepare to start Routine "three_field_masked_priming" ---
        # create an object to store info about Routine three_field_masked_priming
        three_field_masked_priming = data.Routine(
            name='three_field_masked_priming',
            components=[mask, prime, target, lex_dec],
        )
        three_field_masked_priming.status = NOT_STARTED
        continueRoutine = True
        # update component parameters for each repeat
        prime.setText(PRIME)
        target.setText(TARGET)
        # create starting attributes for lex_dec
        lex_dec.keys = []
        lex_dec.rt = []
        _lex_dec_allKeys = []
        # store start times for three_field_masked_priming
        three_field_masked_priming.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
        three_field_masked_priming.tStart = globalClock.getTime(format='float')
        three_field_masked_priming.status = STARTED
        thisExp.addData('three_field_masked_priming.started', three_field_masked_priming.tStart)
        three_field_masked_priming.maxDuration = None
        # keep track of which components have finished
        three_field_masked_primingComponents = three_field_masked_priming.components
        for thisComponent in three_field_masked_priming.components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1

        # --- Run Routine "three_field_masked_priming" ---
        # if trial has changed, end Routine now
        if isinstance(practice, data.TrialHandler2) and thisPractice.thisN != practice.thisTrial.thisN:
            continueRoutine = False
        three_field_masked_priming.forceEnded = routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 3.55:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame

            # *mask* updates

            # if mask is starting this frame...
            if mask.status == NOT_STARTED and frameN >= 0.0:
                # keep track of start time/frame for later
                mask.frameNStart = frameN  # exact frame index
                mask.tStart = t  # local t and not account for scr refresh
                mask.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(mask, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'mask.started')
                # update status
                mask.status = STARTED
                mask.setAutoDraw(True)

            # if mask is active this frame...
            if mask.status == STARTED:
                # update params
                pass

            # if mask is stopping this frame...
            if mask.status == STARTED:
                if frameN >= 30:
                    # keep track of stop time/frame for later
                    mask.tStop = t  # not accounting for scr refresh
                    mask.tStopRefresh = tThisFlipGlobal  # on global time
                    mask.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'mask.stopped')
                    # update status
                    mask.status = FINISHED
                    mask.setAutoDraw(False)

            # *prime* updates

            # if prime is starting this frame...
            if prime.status == NOT_STARTED and frameN >= 30:
                # keep track of start time/frame for later
                prime.frameNStart = frameN  # exact frame index
                prime.tStart = t  # local t and not account for scr refresh
                prime.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(prime, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'prime.started')
                # update status
                prime.status = STARTED
                prime.setAutoDraw(True)

            # if prime is active this frame...
            if prime.status == STARTED:
                # update params
                pass

            # if prime is stopping this frame...
            if prime.status == STARTED:
                if frameN >= 3:
                    # keep track of stop time/frame for later
                    prime.tStop = t  # not accounting for scr refresh
                    prime.tStopRefresh = tThisFlipGlobal  # on global time
                    prime.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'prime.stopped')
                    # update status
                    prime.status = FINISHED
                    prime.setAutoDraw(False)

            # *target* updates

            # if target is starting this frame...
            if target.status == NOT_STARTED and frameN >= 33:
                # keep track of start time/frame for later
                target.frameNStart = frameN  # exact frame index
                target.tStart = t  # local t and not account for scr refresh
                target.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(target, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'target.started')
                # update status
                target.status = STARTED
                target.setAutoDraw(True)

            # if target is active this frame...
            if target.status == STARTED:
                # update params
                pass

            # if target is stopping this frame...
            if target.status == STARTED:
                if frameN >= (target.frameNStart + 18):
                    # keep track of stop time/frame for later
                    target.tStop = t  # not accounting for scr refresh
                    target.tStopRefresh = tThisFlipGlobal  # on global time
                    target.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'target.stopped')
                    # update status
                    target.status = FINISHED
                    target.setAutoDraw(False)

            # *lex_dec* updates
            waitOnFlip = False

            # if lex_dec is starting this frame...
            if lex_dec.status == NOT_STARTED and frameN >= 33:
                # keep track of start time/frame for later
                lex_dec.frameNStart = frameN  # exact frame index
                lex_dec.tStart = t  # local t and not account for scr refresh
                lex_dec.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(lex_dec, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'lex_dec.started')
                # update status
                lex_dec.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(lex_dec.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(lex_dec.clearEvents, eventType='keyboard')  # clear events on next screen flip

            # if lex_dec is stopping this frame...
            if lex_dec.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > lex_dec.tStartRefresh + 3 - frameTolerance:
                    # keep track of stop time/frame for later
                    lex_dec.tStop = t  # not accounting for scr refresh
                    lex_dec.tStopRefresh = tThisFlipGlobal  # on global time
                    lex_dec.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'lex_dec.stopped')
                    # update status
                    lex_dec.status = FINISHED
                    lex_dec.status = FINISHED
            if lex_dec.status == STARTED and not waitOnFlip:
                theseKeys = lex_dec.getKeys(keyList=['f', 'j'], ignoreKeys=["escape"], waitRelease=False)
                _lex_dec_allKeys.extend(theseKeys)
                if len(_lex_dec_allKeys):
                    lex_dec.keys = _lex_dec_allKeys[-1].name  # just the last key pressed
                    lex_dec.rt = _lex_dec_allKeys[-1].rt
                    lex_dec.duration = _lex_dec_allKeys[-1].duration
                    # was this correct?
                    if (lex_dec.keys == str(COR_ANS)) or (lex_dec.keys == COR_ANS):
                        lex_dec.corr = 1
                    else:
                        lex_dec.corr = 0
                    # a response ends the routine
                    continueRoutine = False

            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, win=win)
                return
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp,
                    win=win,
                    timers=[routineTimer],
                    playbackComponents=[]
                )
                # skip the frame we paused on
                continue

            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                three_field_masked_priming.forceEnded = routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in three_field_masked_priming.components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished

            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()

        # --- Ending Routine "three_field_masked_priming" ---
        for thisComponent in three_field_masked_priming.components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # store stop times for three_field_masked_priming
        three_field_masked_priming.tStop = globalClock.getTime(format='float')
        three_field_masked_priming.tStopRefresh = tThisFlipGlobal
        thisExp.addData('three_field_masked_priming.stopped', three_field_masked_priming.tStop)
        # check responses
        if lex_dec.keys in ['', [], None]:  # No response was made
            lex_dec.keys = None
            # was no response the correct answer?!
            if str(COR_ANS).lower() == 'none':
                lex_dec.corr = 1;  # correct non-response
            else:
                lex_dec.corr = 0;  # failed to respond (incorrectly)
        # store data for practice (TrialHandler)
        practice.addData('lex_dec.keys', lex_dec.keys)
        practice.addData('lex_dec.corr', lex_dec.corr)
        if lex_dec.keys != None:  # we had a response
            practice.addData('lex_dec.rt', lex_dec.rt)
            practice.addData('lex_dec.duration', lex_dec.duration)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if three_field_masked_priming.maxDurationReached:
            routineTimer.addTime(-three_field_masked_priming.maxDuration)
        elif three_field_masked_priming.forceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-3.550000)
        thisExp.nextEntry()

    # completed 1.0 repeats of 'practice'

    if thisSession is not None:
        # if running in a Session with a Liaison client, send data up to now
        thisSession.sendExperimentData()
    # get names of stimulus parameters
    if practice.trialList in ([], [None], None):
        params = []
    else:
        params = practice.trialList[0].keys()
    # save data for this loop
    practice.saveAsExcel(filename + '.xlsx', sheetName='practice',
                         stimOut=params,
                         dataOut=['n', 'all_mean', 'all_std', 'all_raw'])
    practice.saveAsText(filename + 'practice.csv', delim=',',
                        stimOut=params,
                        dataOut=['n', 'all_mean', 'all_std', 'all_raw'])

    # --- Prepare to start Routine "StartExp" ---
    # create an object to store info about Routine StartExp
    StartExp = data.Routine(
        name='StartExp',
        components=[start_experiment, get_exp],
    )
    StartExp.status = NOT_STARTED
    continueRoutine = True
    # update component parameters for each repeat
    # create starting attributes for get_exp
    get_exp.keys = []
    get_exp.rt = []
    _get_exp_allKeys = []
    # store start times for StartExp
    StartExp.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
    StartExp.tStart = globalClock.getTime(format='float')
    StartExp.status = STARTED
    thisExp.addData('StartExp.started', StartExp.tStart)
    StartExp.maxDuration = None
    # keep track of which components have finished
    StartExpComponents = StartExp.components
    for thisComponent in StartExp.components:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1

    # --- Run Routine "StartExp" ---
    StartExp.forceEnded = routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *start_experiment* updates

        # if start_experiment is starting this frame...
        if start_experiment.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            start_experiment.frameNStart = frameN  # exact frame index
            start_experiment.tStart = t  # local t and not account for scr refresh
            start_experiment.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(start_experiment, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'start_experiment.started')
            # update status
            start_experiment.status = STARTED
            start_experiment.setAutoDraw(True)

        # if start_experiment is active this frame...
        if start_experiment.status == STARTED:
            # update params
            pass

        # *get_exp* updates
        waitOnFlip = False

        # if get_exp is starting this frame...
        if get_exp.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            get_exp.frameNStart = frameN  # exact frame index
            get_exp.tStart = t  # local t and not account for scr refresh
            get_exp.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(get_exp, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'get_exp.started')
            # update status
            get_exp.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(get_exp.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(get_exp.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if get_exp.status == STARTED and not waitOnFlip:
            theseKeys = get_exp.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _get_exp_allKeys.extend(theseKeys)
            if len(_get_exp_allKeys):
                get_exp.keys = _get_exp_allKeys[-1].name  # just the last key pressed
                get_exp.rt = _get_exp_allKeys[-1].rt
                get_exp.duration = _get_exp_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False

        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, win=win)
            return
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp,
                win=win,
                timers=[routineTimer],
                playbackComponents=[]
            )
            # skip the frame we paused on
            continue

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            StartExp.forceEnded = routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in StartExp.components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # --- Ending Routine "StartExp" ---
    for thisComponent in StartExp.components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store stop times for StartExp
    StartExp.tStop = globalClock.getTime(format='float')
    StartExp.tStopRefresh = tThisFlipGlobal
    thisExp.addData('StartExp.stopped', StartExp.tStop)
    # check responses
    if get_exp.keys in ['', [], None]:  # No response was made
        get_exp.keys = None
    thisExp.addData('get_exp.keys', get_exp.keys)
    if get_exp.keys != None:  # we had a response
        thisExp.addData('get_exp.rt', get_exp.rt)
        thisExp.addData('get_exp.duration', get_exp.duration)
    thisExp.nextEntry()
    # the Routine "StartExp" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()

    # set up handler to look after randomisation of conditions etc
    experiment = data.TrialHandler2(
        name='experiment',
        nReps=1.0,
        method='random',
        extraInfo=expInfo,
        originPath=-1,
        trialList=data.importConditions("LIST" + expInfo['list'] + ".csv"),
        seed=None,
    )
    thisExp.addLoop(experiment)  # add the loop to the experiment
    thisExperiment = experiment.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisExperiment.rgb)
    if thisExperiment != None:
        for paramName in thisExperiment:
            globals()[paramName] = thisExperiment[paramName]

    for thisExperiment in experiment:
        currentLoop = experiment
        thisExp.timestampOnFlip(win, 'thisRow.t', format=globalClock.format)
        # abbreviate parameter names if possible (e.g. rgb = thisExperiment.rgb)
        if thisExperiment != None:
            for paramName in thisExperiment:
                globals()[paramName] = thisExperiment[paramName]

        # --- Prepare to start Routine "is_break" ---
        # create an object to store info about Routine is_break
        is_break = data.Routine(
            name='is_break',
            components=[take_break, finish_break],
        )
        is_break.status = NOT_STARTED
        continueRoutine = True
        # update component parameters for each repeat
        # create starting attributes for finish_break
        finish_break.keys = []
        finish_break.rt = []
        _finish_break_allKeys = []
        # Run 'Begin Routine' code from code
        if experiment.thisN == 0 or experiment.thisN % 20 != 0:
            continueRoutine = False
        # store start times for is_break
        is_break.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
        is_break.tStart = globalClock.getTime(format='float')
        is_break.status = STARTED
        thisExp.addData('is_break.started', is_break.tStart)
        is_break.maxDuration = None
        # keep track of which components have finished
        is_breakComponents = is_break.components
        for thisComponent in is_break.components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1

        # --- Run Routine "is_break" ---
        # if trial has changed, end Routine now
        if isinstance(experiment, data.TrialHandler2) and thisExperiment.thisN != experiment.thisTrial.thisN:
            continueRoutine = False
        is_break.forceEnded = routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame

            # *take_break* updates

            # if take_break is starting this frame...
            if take_break.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                take_break.frameNStart = frameN  # exact frame index
                take_break.tStart = t  # local t and not account for scr refresh
                take_break.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(take_break, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'take_break.started')
                # update status
                take_break.status = STARTED
                take_break.setAutoDraw(True)

            # if take_break is active this frame...
            if take_break.status == STARTED:
                # update params
                pass

            # *finish_break* updates
            waitOnFlip = False

            # if finish_break is starting this frame...
            if finish_break.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                finish_break.frameNStart = frameN  # exact frame index
                finish_break.tStart = t  # local t and not account for scr refresh
                finish_break.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(finish_break, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'finish_break.started')
                # update status
                finish_break.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(finish_break.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(finish_break.clearEvents, eventType='keyboard')  # clear events on next screen flip
            if finish_break.status == STARTED and not waitOnFlip:
                theseKeys = finish_break.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
                _finish_break_allKeys.extend(theseKeys)
                if len(_finish_break_allKeys):
                    finish_break.keys = _finish_break_allKeys[-1].name  # just the last key pressed
                    finish_break.rt = _finish_break_allKeys[-1].rt
                    finish_break.duration = _finish_break_allKeys[-1].duration
                    # a response ends the routine
                    continueRoutine = False

            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, win=win)
                return
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp,
                    win=win,
                    timers=[routineTimer],
                    playbackComponents=[]
                )
                # skip the frame we paused on
                continue

            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                is_break.forceEnded = routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in is_break.components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished

            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()

        # --- Ending Routine "is_break" ---
        for thisComponent in is_break.components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # store stop times for is_break
        is_break.tStop = globalClock.getTime(format='float')
        is_break.tStopRefresh = tThisFlipGlobal
        thisExp.addData('is_break.stopped', is_break.tStop)
        # check responses
        if finish_break.keys in ['', [], None]:  # No response was made
            finish_break.keys = None
        experiment.addData('finish_break.keys', finish_break.keys)
        if finish_break.keys != None:  # we had a response
            experiment.addData('finish_break.rt', finish_break.rt)
            experiment.addData('finish_break.duration', finish_break.duration)
        # the Routine "is_break" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()

        # --- Prepare to start Routine "ITI" ---
        # create an object to store info about Routine ITI
        ITI = data.Routine(
            name='ITI',
            components=[inter_trial_int],
        )
        ITI.status = NOT_STARTED
        continueRoutine = True
        # update component parameters for each repeat
        # store start times for ITI
        ITI.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
        ITI.tStart = globalClock.getTime(format='float')
        ITI.status = STARTED
        thisExp.addData('ITI.started', ITI.tStart)
        ITI.maxDuration = None
        # keep track of which components have finished
        ITIComponents = ITI.components
        for thisComponent in ITI.components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1

        # --- Run Routine "ITI" ---
        # if trial has changed, end Routine now
        if isinstance(experiment, data.TrialHandler2) and thisExperiment.thisN != experiment.thisTrial.thisN:
            continueRoutine = False
        ITI.forceEnded = routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame

            # *inter_trial_int* updates

            # if inter_trial_int is starting this frame...
            if inter_trial_int.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
                # keep track of start time/frame for later
                inter_trial_int.frameNStart = frameN  # exact frame index
                inter_trial_int.tStart = t  # local t and not account for scr refresh
                inter_trial_int.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(inter_trial_int, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'inter_trial_int.started')
                # update status
                inter_trial_int.status = STARTED
                inter_trial_int.setAutoDraw(True)

            # if inter_trial_int is active this frame...
            if inter_trial_int.status == STARTED:
                # update params
                pass

            # if inter_trial_int is stopping this frame...
            if inter_trial_int.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > inter_trial_int.tStartRefresh + random() * (1.5 - 0.9) + 0.9 - frameTolerance:
                    # keep track of stop time/frame for later
                    inter_trial_int.tStop = t  # not accounting for scr refresh
                    inter_trial_int.tStopRefresh = tThisFlipGlobal  # on global time
                    inter_trial_int.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'inter_trial_int.stopped')
                    # update status
                    inter_trial_int.status = FINISHED
                    inter_trial_int.setAutoDraw(False)

            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, win=win)
                return
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp,
                    win=win,
                    timers=[routineTimer],
                    playbackComponents=[]
                )
                # skip the frame we paused on
                continue

            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                ITI.forceEnded = routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in ITI.components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished

            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()

        # --- Ending Routine "ITI" ---
        for thisComponent in ITI.components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # store stop times for ITI
        ITI.tStop = globalClock.getTime(format='float')
        ITI.tStopRefresh = tThisFlipGlobal
        thisExp.addData('ITI.stopped', ITI.tStop)
        # the Routine "ITI" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()

        # --- Prepare to start Routine "three_field_masked_priming" ---
        # create an object to store info about Routine three_field_masked_priming
        three_field_masked_priming = data.Routine(
            name='three_field_masked_priming',
            components=[mask, prime, target, lex_dec],
        )
        three_field_masked_priming.status = NOT_STARTED
        continueRoutine = True
        # update component parameters for each repeat
        prime.setText(PRIME)
        target.setText(TARGET)
        # create starting attributes for lex_dec
        lex_dec.keys = []
        lex_dec.rt = []
        _lex_dec_allKeys = []
        # store start times for three_field_masked_priming
        three_field_masked_priming.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
        three_field_masked_priming.tStart = globalClock.getTime(format='float')
        three_field_masked_priming.status = STARTED
        thisExp.addData('three_field_masked_priming.started', three_field_masked_priming.tStart)
        three_field_masked_priming.maxDuration = None
        # keep track of which components have finished
        three_field_masked_primingComponents = three_field_masked_priming.components
        for thisComponent in three_field_masked_priming.components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1

        # --- Run Routine "three_field_masked_priming" ---
        # if trial has changed, end Routine now
        if isinstance(experiment, data.TrialHandler2) and thisExperiment.thisN != experiment.thisTrial.thisN:
            continueRoutine = False
        three_field_masked_priming.forceEnded = routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 3.55:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame

            # *mask* updates

            # if mask is starting this frame...
            if mask.status == NOT_STARTED and frameN >= 0.0:
                # keep track of start time/frame for later
                mask.frameNStart = frameN  # exact frame index
                mask.tStart = t  # local t and not account for scr refresh
                mask.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(mask, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'mask.started')
                # update status
                mask.status = STARTED
                mask.setAutoDraw(True)

            # if mask is active this frame...
            if mask.status == STARTED:
                # update params
                pass

            # if mask is stopping this frame...
            if mask.status == STARTED:
                if frameN >= 30:
                    # keep track of stop time/frame for later
                    mask.tStop = t  # not accounting for scr refresh
                    mask.tStopRefresh = tThisFlipGlobal  # on global time
                    mask.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'mask.stopped')
                    # update status
                    mask.status = FINISHED
                    mask.setAutoDraw(False)

            # *prime* updates

            # if prime is starting this frame...
            if prime.status == NOT_STARTED and frameN >= 30:
                # keep track of start time/frame for later
                prime.frameNStart = frameN  # exact frame index
                prime.tStart = t  # local t and not account for scr refresh
                prime.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(prime, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'prime.started')
                # update status
                prime.status = STARTED
                prime.setAutoDraw(True)

            # if prime is active this frame...
            if prime.status == STARTED:
                # update params
                pass

            # if prime is stopping this frame...
            if prime.status == STARTED:
                if frameN >= 3:
                    # keep track of stop time/frame for later
                    prime.tStop = t  # not accounting for scr refresh
                    prime.tStopRefresh = tThisFlipGlobal  # on global time
                    prime.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'prime.stopped')
                    # update status
                    prime.status = FINISHED
                    prime.setAutoDraw(False)

            # *target* updates

            # if target is starting this frame...
            if target.status == NOT_STARTED and frameN >= 33:
                # keep track of start time/frame for later
                target.frameNStart = frameN  # exact frame index
                target.tStart = t  # local t and not account for scr refresh
                target.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(target, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'target.started')
                # update status
                target.status = STARTED
                target.setAutoDraw(True)

            # if target is active this frame...
            if target.status == STARTED:
                # update params
                pass

            # if target is stopping this frame...
            if target.status == STARTED:
                if frameN >= (target.frameNStart + 18):
                    # keep track of stop time/frame for later
                    target.tStop = t  # not accounting for scr refresh
                    target.tStopRefresh = tThisFlipGlobal  # on global time
                    target.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'target.stopped')
                    # update status
                    target.status = FINISHED
                    target.setAutoDraw(False)

            # *lex_dec* updates
            waitOnFlip = False

            # if lex_dec is starting this frame...
            if lex_dec.status == NOT_STARTED and frameN >= 33:
                # keep track of start time/frame for later
                lex_dec.frameNStart = frameN  # exact frame index
                lex_dec.tStart = t  # local t and not account for scr refresh
                lex_dec.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(lex_dec, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'lex_dec.started')
                # update status
                lex_dec.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(lex_dec.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(lex_dec.clearEvents, eventType='keyboard')  # clear events on next screen flip

            # if lex_dec is stopping this frame...
            if lex_dec.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > lex_dec.tStartRefresh + 3 - frameTolerance:
                    # keep track of stop time/frame for later
                    lex_dec.tStop = t  # not accounting for scr refresh
                    lex_dec.tStopRefresh = tThisFlipGlobal  # on global time
                    lex_dec.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'lex_dec.stopped')
                    # update status
                    lex_dec.status = FINISHED
                    lex_dec.status = FINISHED
            if lex_dec.status == STARTED and not waitOnFlip:
                theseKeys = lex_dec.getKeys(keyList=['f', 'j'], ignoreKeys=["escape"], waitRelease=False)
                _lex_dec_allKeys.extend(theseKeys)
                if len(_lex_dec_allKeys):
                    lex_dec.keys = _lex_dec_allKeys[-1].name  # just the last key pressed
                    lex_dec.rt = _lex_dec_allKeys[-1].rt
                    lex_dec.duration = _lex_dec_allKeys[-1].duration
                    # was this correct?
                    if (lex_dec.keys == str(COR_ANS)) or (lex_dec.keys == COR_ANS):
                        lex_dec.corr = 1
                    else:
                        lex_dec.corr = 0
                    # a response ends the routine
                    continueRoutine = False

            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, win=win)
                return
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp,
                    win=win,
                    timers=[routineTimer],
                    playbackComponents=[]
                )
                # skip the frame we paused on
                continue

            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                three_field_masked_priming.forceEnded = routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in three_field_masked_priming.components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished

            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()

        # --- Ending Routine "three_field_masked_priming" ---
        for thisComponent in three_field_masked_priming.components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # store stop times for three_field_masked_priming
        three_field_masked_priming.tStop = globalClock.getTime(format='float')
        three_field_masked_priming.tStopRefresh = tThisFlipGlobal
        thisExp.addData('three_field_masked_priming.stopped', three_field_masked_priming.tStop)
        # check responses
        if lex_dec.keys in ['', [], None]:  # No response was made
            lex_dec.keys = None
            # was no response the correct answer?!
            if str(COR_ANS).lower() == 'none':
                lex_dec.corr = 1;  # correct non-response
            else:
                lex_dec.corr = 0;  # failed to respond (incorrectly)
        # store data for experiment (TrialHandler)
        experiment.addData('lex_dec.keys', lex_dec.keys)
        experiment.addData('lex_dec.corr', lex_dec.corr)
        if lex_dec.keys != None:  # we had a response
            experiment.addData('lex_dec.rt', lex_dec.rt)
            experiment.addData('lex_dec.duration', lex_dec.duration)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if three_field_masked_priming.maxDurationReached:
            routineTimer.addTime(-three_field_masked_priming.maxDuration)
        elif three_field_masked_priming.forceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-3.550000)
    # completed 1.0 repeats of 'experiment'

    # --- Prepare to start Routine "EndExp" ---
    # create an object to store info about Routine EndExp
    EndExp = data.Routine(
        name='EndExp',
        components=[end_exp, end_experiment],
    )
    EndExp.status = NOT_STARTED
    continueRoutine = True
    # update component parameters for each repeat
    # create starting attributes for end_experiment
    end_experiment.keys = []
    end_experiment.rt = []
    _end_experiment_allKeys = []
    # store start times for EndExp
    EndExp.tStartRefresh = win.getFutureFlipTime(clock=globalClock)
    EndExp.tStart = globalClock.getTime(format='float')
    EndExp.status = STARTED
    thisExp.addData('EndExp.started', EndExp.tStart)
    EndExp.maxDuration = None
    # keep track of which components have finished
    EndExpComponents = EndExp.components
    for thisComponent in EndExp.components:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1

    # --- Run Routine "EndExp" ---
    EndExp.forceEnded = routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *end_exp* updates

        # if end_exp is starting this frame...
        if end_exp.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            end_exp.frameNStart = frameN  # exact frame index
            end_exp.tStart = t  # local t and not account for scr refresh
            end_exp.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(end_exp, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'end_exp.started')
            # update status
            end_exp.status = STARTED
            end_exp.setAutoDraw(True)

        # if end_exp is active this frame...
        if end_exp.status == STARTED:
            # update params
            pass

        # *end_experiment* updates
        waitOnFlip = False

        # if end_experiment is starting this frame...
        if end_experiment.status == NOT_STARTED and tThisFlip >= 0.0 - frameTolerance:
            # keep track of start time/frame for later
            end_experiment.frameNStart = frameN  # exact frame index
            end_experiment.tStart = t  # local t and not account for scr refresh
            end_experiment.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(end_experiment, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'end_experiment.started')
            # update status
            end_experiment.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(end_experiment.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(end_experiment.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if end_experiment.status == STARTED and not waitOnFlip:
            theseKeys = end_experiment.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _end_experiment_allKeys.extend(theseKeys)
            if len(_end_experiment_allKeys):
                end_experiment.keys = _end_experiment_allKeys[-1].name  # just the last key pressed
                end_experiment.rt = _end_experiment_allKeys[-1].rt
                end_experiment.duration = _end_experiment_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False

        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, win=win)
            return
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp,
                win=win,
                timers=[routineTimer],
                playbackComponents=[]
            )
            # skip the frame we paused on
            continue

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            EndExp.forceEnded = routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in EndExp.components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # --- Ending Routine "EndExp" ---
    for thisComponent in EndExp.components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store stop times for EndExp
    EndExp.tStop = globalClock.getTime(format='float')
    EndExp.tStopRefresh = tThisFlipGlobal
    thisExp.addData('EndExp.stopped', EndExp.tStop)
    # check responses
    if end_experiment.keys in ['', [], None]:  # No response was made
        end_experiment.keys = None
    thisExp.addData('end_experiment.keys', end_experiment.keys)
    if end_experiment.keys != None:  # we had a response
        thisExp.addData('end_experiment.rt', end_experiment.rt)
        thisExp.addData('end_experiment.duration', end_experiment.duration)
    thisExp.nextEntry()
    # the Routine "EndExp" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()

    # mark experiment as finished
    endExperiment(thisExp, win=win)


def saveData(thisExp):
    """
    Save data from this experiment

    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    """
    filename = thisExp.dataFileName
    # these shouldn't be strictly necessary (should auto-save)
    thisExp.saveAsWideText(filename + '.csv', delim='auto')
    thisExp.saveAsPickle(filename)


def endExperiment(thisExp, win=None):
    """
    End this experiment, performing final shut down operations.

    This function does NOT close the window or end the Python process - use `quit` for this.

    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about
        where to save it to.
    win : psychopy.visual.Window
        Window for this experiment.
    """
    if win is not None:
        # remove autodraw from all current components
        win.clearAutoDraw()
        # Flip one final time so any remaining win.callOnFlip()
        # and win.timeOnFlip() tasks get executed
        win.flip()
    # return console logger level to WARNING
    logging.console.setLevel(logging.WARNING)
    # mark experiment handler as finished
    thisExp.status = FINISHED
    logging.flush()


def quit(thisExp, win=None, thisSession=None):
    """
    Fully quit, closing the window and ending the Python process.

    Parameters
    ==========
    win : psychopy.visual.Window
        Window to close.
    thisSession : psychopy.session.Session or None
        Handle of the Session object this experiment is being run from, if any.
    """
    thisExp.abort()  # or data files will save again on exit
    # make sure everything is closed down
    if win is not None:
        # Flip one final time so any remaining win.callOnFlip()
        # and win.timeOnFlip() tasks get executed before quitting
        win.flip()
        win.close()
    logging.flush()
    if thisSession is not None:
        thisSession.stop()
    # terminate Python process
    core.quit()


# if running this experiment as a script...
if __name__ == '__main__':
    # call all functions in order
    expInfo = showExpInfoDlg(expInfo=expInfo)
    thisExp = setupData(expInfo=expInfo)
    logFile = setupLogging(filename=thisExp.dataFileName)
    win = setupWindow(expInfo=expInfo)
    setupDevices(expInfo=expInfo, thisExp=thisExp, win=win)
    run(
        expInfo=expInfo,
        thisExp=thisExp,
        win=win,
        globalClock='float'
    )
    saveData(thisExp=thisExp)
    quit(thisExp=thisExp, win=win)


    if USE_VPIXX:
        dp.DPxClose()
