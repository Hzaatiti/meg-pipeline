import numpy as np


def sloreta_localization(L, M, Cn=None, lambda_reg=0.1):
    """
    Simplified sLORETA implementation for MEG/EEG source localization.

    Parameters:
        L (ndarray): Lead field matrix [n_sensors × n_sources]
        M (ndarray): Sensor data matrix [n_sensors × n_timepoints]
        Cn (ndarray): Noise covariance matrix [n_sensors × n_sensors]
        lambda_reg (float): Regularization parameter (default: 0.1)

    Returns:
        S_lor (ndarray): sLORETA source estimates [n_sources × n_timepoints]
    """
    n_sensors, n_sources = L.shape

    # If noise covariance is unknown, assume identity matrix
    if Cn is None:
        Cn = np.eye(n_sensors)

    # Step 1: Compute regularized inverse operator (minimum norm estimate)
    # G = L^T (L L^T + λ * Cn)^-1
    L_Lt = L @ L.T
    inv_term = np.linalg.pinv(L_Lt + lambda_reg * Cn)
    G = L.T @ inv_term  # Inverse operator [n_sources × n_sensors]

    # Step 2: Compute source estimates (minimum norm)
    S_mne = G @ M  # [n_sources × n_timepoints]

    # Step 3: Compute sLORETA standardization
    # Variance for each source: T = diag(L_i^T (L L^T + λ Cn)^-1 L_i)
    T = np.zeros(n_sources)
    for i in range(n_sources):
        L_i = L[:, i].reshape(-1, 1)
        T[i] = L_i.T @ inv_term @ L_i

    # Standardize the MNE solution
    epsilon = 1e-12  # Avoid division by zero
    S_lor = S_mne / np.sqrt(T + epsilon)[:, np.newaxis]

    return S_lor


# ------------------------------
# Example Usage
# ------------------------------

# Simulate a lead field matrix (L) and sensor data (M)
n_sensors = 50
n_sources = 1000
n_timepoints = 10

# Random lead field matrix (replace with real data)
L = np.random.randn(n_sensors, n_sources)

# Simulate sensor data (replace with real measurements)
M = np.random.randn(n_sensors, n_timepoints)

# Run sLORETA
source_estimates = sloreta_localization(L, M)

print("sLORETA source estimates shape:", source_estimates.shape)