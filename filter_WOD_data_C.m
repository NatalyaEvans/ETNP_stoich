%% Info

% This script was written to load in data exported from WOA2013, filtered
% in ODV, and apply a more rigorous set of filters, then save that output.

% Last updated 2022 04 21 by Natalya Evans to add descriptive comments

load('WOD_data_C_full') % This was output by ODV to txt, then loaded into matlab and saved

% following code is for each water mass

%% ESW
% ESW lacks carbon data so it got commented out
% 
% ESWfilt=ESW;
% toDelete = ESWfilt.Latitudedegrees_north < 0;
% ESWfilt(toDelete,:) = [];
% 
% toDelete = ESWfilt.ConservativeTemperatureQdegC < 21 | ESWfilt.ConservativeTemperatureQdegC > 23;
% ESWfilt(toDelete,:) = [];
% 
% toDelete = ESWfilt.AbsoluteSalinityS_Agkg < 34.3 | ESWfilt.AbsoluteSalinityS_Agkg > 34.6;
% ESWfilt(toDelete,:) = [];
% 
% toDelete = ESWfilt.PotentialDensityAnomalys_0kgm3 < 23.3 | ESWfilt.PotentialDensityAnomalys_0kgm3 > 23.7;
% ESWfilt(toDelete,:) = [];
% 
% toDelete = ESWfilt.Depthm < 25;
% ESWfilt(toDelete,:) = [];
% 
% % Apply Bianchi et al. 2012 O2 correction
% ESWfilt.O2corr=(1.009.*(ESWfilt.Oxygenumolkg.*((1000+ESWfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+ESWfilt.PotentialDensityAnomalys_0kgm3));

%% 13CW

x13CW_Cfilt=x13CW_C; % define a duplicate to subset

% generate TEOS-10 values
x13CW_Cfilt.press=gsw_p_from_z(-x13CW_Cfilt.Depthm,x13CW_Cfilt.Latitudedegrees_north);
x13CW_Cfilt.AbsoluteSalinityS_Agkg=gsw_SA_from_SP(x13CW_Cfilt.Salinitypsu,x13CW_Cfilt.press,x13CW_Cfilt.Longitudedegrees_east,x13CW_Cfilt.Latitudedegrees_north);
x13CW_Cfilt.ConservativeTemperatureQdegC=gsw_CT_from_t(x13CW_Cfilt.AbsoluteSalinityS_Agkg,x13CW_Cfilt.Temperaturedegrees_C,x13CW_Cfilt.press);
x13CW_Cfilt.PotentialDensityAnomalys_0kgm3=gsw_sigma0(x13CW_Cfilt.AbsoluteSalinityS_Agkg,x13CW_Cfilt.ConservativeTemperatureQdegC);
x13CW_Cfilt.tCO_2umolkg=x13CW_Cfilt.tCO_2mmoll.*(1000./(1000+x13CW_Cfilt.PotentialDensityAnomalys_0kgm3))*1000;

toDelete = x13CW_Cfilt.Latitudedegrees_north < 0;
x13CW_Cfilt(toDelete,:) = [];

toDelete = x13CW_Cfilt.ConservativeTemperatureQdegC < 12.5 | x13CW_Cfilt.ConservativeTemperatureQdegC > 13.5;
x13CW_Cfilt(toDelete,:) = [];

toDelete = x13CW_Cfilt.AbsoluteSalinityS_Agkg < 34.8 | x13CW_Cfilt.AbsoluteSalinityS_Agkg > 35.2;
x13CW_Cfilt(toDelete,:) = [];

toDelete = x13CW_Cfilt.PotentialDensityAnomalys_0kgm3 < 26.2 | x13CW_Cfilt.PotentialDensityAnomalys_0kgm3 > 26.4;
x13CW_Cfilt(toDelete,:) = [];

toDelete =x13CW_Cfilt.Nitratemmolkg < 15; % removes low NO3 points
x13CW_Cfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this
% analysis
x13CW_Cfilt.O2corr=(1.009.*(x13CW_Cfilt.Oxygenmmolkg.*((1000+x13CW_Cfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+x13CW_Cfilt.PotentialDensityAnomalys_0kgm3));

%% EqPIW_C

EqPIW_Cfilt=EqPIW_C; % define a duplicate to subset

% generate TEOS-10 values
EqPIW_Cfilt.press=gsw_p_from_z(-EqPIW_Cfilt.Depthm,EqPIW_Cfilt.Latitudedegrees_north);
EqPIW_Cfilt.AbsoluteSalinityS_Agkg=gsw_SA_from_SP(EqPIW_Cfilt.Salinitypsu,EqPIW_Cfilt.press,EqPIW_Cfilt.Longitudedegrees_east,EqPIW_Cfilt.Latitudedegrees_north);
EqPIW_Cfilt.ConservativeTemperatureQdegC=gsw_CT_from_t(EqPIW_Cfilt.AbsoluteSalinityS_Agkg,EqPIW_Cfilt.Temperaturedegrees_C,EqPIW_Cfilt.press);
EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3=gsw_sigma0(EqPIW_Cfilt.AbsoluteSalinityS_Agkg,EqPIW_Cfilt.ConservativeTemperatureQdegC);
EqPIW_Cfilt.tCO_2umolkg=EqPIW_Cfilt.tCO_2mmoll.*(1000./(1000+EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3))*1000;

toDelete = EqPIW_Cfilt.Latitudedegrees_north < 0;
EqPIW_Cfilt(toDelete,:) = [];

toDelete = EqPIW_Cfilt.ConservativeTemperatureQdegC < 9 | EqPIW_Cfilt.ConservativeTemperatureQdegC > 10;
EqPIW_Cfilt(toDelete,:) = [];

toDelete = EqPIW_Cfilt.AbsoluteSalinityS_Agkg < 34.7 | EqPIW_Cfilt.AbsoluteSalinityS_Agkg > 34.85;
EqPIW_Cfilt(toDelete,:) = [];

toDelete = EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3 < 26.7 | EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3 > 26.9;
EqPIW_Cfilt(toDelete,:) = [];

% Added a line to cut low PO4 values
toDelete = EqPIW_Cfilt.Phosphatemmolkg < 1.5;
EqPIW_Cfilt(toDelete,:) = [];

toDelete = EqPIW_Cfilt.Depthm < 150;
EqPIW_Cfilt(toDelete,:) = [];

toDelete = EqPIW_Cfilt.Longitudedegrees_east > 230;
EqPIW_Cfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this
% analysis
EqPIW_Cfilt.O2corr=(1.009.*(EqPIW_Cfilt.Oxygenmmolkg.*((1000+EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+EqPIW_Cfilt.PotentialDensityAnomalys_0kgm3));

%% AAIW_C

AAIW_Cfilt=AAIW_C; % define a duplicate to subset

% generate TEOS-10 values
AAIW_Cfilt.press=gsw_p_from_z(-AAIW_Cfilt.Depthm,AAIW_Cfilt.Latitudedegrees_north);
AAIW_Cfilt.AbsoluteSalinityS_Agkg=gsw_SA_from_SP(AAIW_Cfilt.Salinitypsu,AAIW_Cfilt.press,AAIW_Cfilt.Longitudedegrees_east,AAIW_Cfilt.Latitudedegrees_north);
AAIW_Cfilt.ConservativeTemperatureQdegC=gsw_CT_from_t(AAIW_Cfilt.AbsoluteSalinityS_Agkg,AAIW_Cfilt.Temperaturedegrees_C,AAIW_Cfilt.press);
AAIW_Cfilt.PotentialDensityAnomalys_0kgm3=gsw_sigma0(AAIW_Cfilt.AbsoluteSalinityS_Agkg,AAIW_Cfilt.ConservativeTemperatureQdegC);
AAIW_Cfilt.tCO_2umolkg=AAIW_Cfilt.tCO_2mmoll.*(1000./(1000+AAIW_Cfilt.PotentialDensityAnomalys_0kgm3))*1000;

toDelete = AAIW_Cfilt.Latitudedegrees_north < 0;
AAIW_Cfilt(toDelete,:) = [];

toDelete = AAIW_Cfilt.ConservativeTemperatureQdegC < 5. | AAIW_Cfilt.ConservativeTemperatureQdegC > 6;
AAIW_Cfilt(toDelete,:) = [];

toDelete = AAIW_Cfilt.AbsoluteSalinityS_Agkg < 34.67 | AAIW_Cfilt.AbsoluteSalinityS_Agkg > 34.72;
AAIW_Cfilt(toDelete,:) = [];

toDelete = AAIW_Cfilt.PotentialDensityAnomalys_0kgm3 < 27.2 | AAIW_Cfilt.PotentialDensityAnomalys_0kgm3 > 27.3;
AAIW_Cfilt(toDelete,:) = [];

toDelete = AAIW_Cfilt.Depthm < 700;
AAIW_Cfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this
% analysis
AAIW_Cfilt.O2corr=(1.009.*(AAIW_Cfilt.Oxygenmmolkg.*((1000+AAIW_Cfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+AAIW_Cfilt.PotentialDensityAnomalys_0kgm3));

%% save

% save('WOD_data_C_filter','x13CW_Cfilt','EqPIW_Cfilt','AAIW_Cfilt')
