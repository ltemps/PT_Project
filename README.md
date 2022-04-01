# PT_Project

IDinfo contains the row identifiers that apply to the rows for each of the data files contained in Data.zip​

Time series data are contained in the following files:​

GRFx, GRFy, GRFz, COPx, COPy, Mx, My, and Mz are not time-normalized​

AP_GRF_stance_N, ML_GRF_stance_N, V_GRF_stance_N, COPx_stance, and COPy_stance are time-normalized to stance (100 data points representing the time the foot is in contact with the ground)​

Abreviations:
  GRF(ground reaction force)
  COP(center of pressure)
  V(vertical)
  AP(anterior-posterior)
  ML(medial-lateral)

Definitions:
  Stance- time when foot is in contact with the ground
  Ground reaction force- force applied to the ground by the foot
  Center of pressure- estimated point of application of the ground reaction force to the foot

Discrete contains all the features that we manually extracted (see the previous slide and the data dictionary for more explanation) – each feature is one column in this file​