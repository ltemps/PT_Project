# PT_Project

The data we were provided for this project was force plate data compiled by a team of graduate students at the Boston University Sargent College of Health and Rehabilitation Services. Our team chose to use the time normalized stance data in our data reconstruction. Each dataset includes trial records for 15696 individuals. Each trial spans 100 time normalized data points.

The datasets consisted of a large number of features for each trial, our objective was to perform dimension reduction on this data. Our team used PCA (Principal Component Analysis), Autoencoders and fPCA (functional Principal Component Analysis) techniques to perform dimension reduction. This enabled us to see which features were most significantly contributing to the data, and to reduce highly correlated measurements. We were also able to perform reconstruction on the PCA and the Autoencoder, which allowed us to see how well the dimension reduction was performing. 

# About the data

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