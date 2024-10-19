
import mne

# Load the raw .fif file
raw = mne.io.read_raw_fif('20241015_111855_sub-MarkerCoil_file-Preliminarymeasurement_raw.fif', preload=True)


# Get the channel information from the raw object
channel_info = raw.info['chs']

# Extract calibration (scaling) factors for all sensors
calibration_factors = [ch['cal'] for ch in channel_info]

# Display the first few calibration factors
print(calibration_factors[:10])


# Get the raw data (in Tesla or T/m for magnetometers or gradiometers)
data, times = raw[:, :]

# Convert data back to Volts (or original unit)
data_in_volts = data / calibration_factors