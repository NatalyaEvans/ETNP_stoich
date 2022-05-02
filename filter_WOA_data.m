%% Info

% This script was written to load in data exported from WOA2013, filtered
% in ODV, and apply a more rigorous set of filters, then save that output.

% Last updated 2022 04 21 by Natalya Evans to add descriptive comments

load('WOA_data_full') % This was output by ODV to txt, then loaded into matlab and saved

% following code is for each water mass

%% ESW

ESWfilt=ESW; % define a duplicate to subset
toDelete = ESWfilt.Latitudedegrees_north < 0; % N hemisphere
ESWfilt(toDelete,:) = [];

toDelete = ESWfilt.ConservativeTemperatureQdegC < 21 | ESWfilt.ConservativeTemperatureQdegC > 23;
ESWfilt(toDelete,:) = [];

toDelete = ESWfilt.AbsoluteSalinityS_Agkg < 34.3 | ESWfilt.AbsoluteSalinityS_Agkg > 34.6;
ESWfilt(toDelete,:) = [];

toDelete = ESWfilt.PotentialDensityAnomalys_0kgm3 < 23.3 | ESWfilt.PotentialDensityAnomalys_0kgm3 > 23.7;
ESWfilt(toDelete,:) = [];

toDelete = ESWfilt.Depthm < 25;
ESWfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, don't actually use in this paper
ESWfilt.O2corr=(1.009.*(ESWfilt.Oxygenumolkg.*((1000+ESWfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+ESWfilt.PotentialDensityAnomalys_0kgm3));

%% 13CW

x13CWfilt=x13CW; % define a duplicate to subset
toDelete = x13CWfilt.Latitudedegrees_north < 0;
x13CWfilt(toDelete,:) = [];

toDelete = x13CWfilt.ConservativeTemperatureQdegC < 12.5 | x13CWfilt.ConservativeTemperatureQdegC > 13.5;
x13CWfilt(toDelete,:) = [];

toDelete = x13CWfilt.AbsoluteSalinityS_Agkg < 34.8 | x13CWfilt.AbsoluteSalinityS_Agkg > 35.2;
x13CWfilt(toDelete,:) = [];

toDelete = x13CWfilt.PotentialDensityAnomalys_0kgm3 < 26.2 | x13CWfilt.PotentialDensityAnomalys_0kgm3 > 26.4;
x13CWfilt(toDelete,:) = [];

toDelete =x13CWfilt.Nitrateumolkg < 15; % removes low NO3 points that snuck in
x13CWfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this paper
x13CWfilt.O2corr=(1.009.*(x13CWfilt.Oxygenumolkg.*((1000+x13CWfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+x13CWfilt.PotentialDensityAnomalys_0kgm3));

%% EqPIW

EqPIWfilt=EqPIW; % define a duplicate to subset
toDelete = EqPIWfilt.Latitudedegrees_north < 0;
EqPIWfilt(toDelete,:) = [];

toDelete = EqPIWfilt.ConservativeTemperatureQdegC < 9 | EqPIWfilt.ConservativeTemperatureQdegC > 10;
EqPIWfilt(toDelete,:) = [];

toDelete = EqPIWfilt.AbsoluteSalinityS_Agkg < 34.7 | EqPIWfilt.AbsoluteSalinityS_Agkg > 34.85;
EqPIWfilt(toDelete,:) = [];

toDelete = EqPIWfilt.PotentialDensityAnomalys_0kgm3 < 26.7 | EqPIWfilt.PotentialDensityAnomalys_0kgm3 > 26.9;
EqPIWfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this paper
EqPIWfilt.O2corr=(1.009.*(EqPIWfilt.Oxygenumolkg.*((1000+EqPIWfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+EqPIWfilt.PotentialDensityAnomalys_0kgm3));

%% AAIW

AAIWfilt=AAIW; % define a duplicate to subset
toDelete = AAIWfilt.Latitudedegrees_north < 0;
AAIWfilt(toDelete,:) = [];

toDelete = AAIWfilt.ConservativeTemperatureQdegC < 5. | AAIWfilt.ConservativeTemperatureQdegC > 6;
AAIWfilt(toDelete,:) = [];

toDelete = AAIWfilt.AbsoluteSalinityS_Agkg < 34.67 | AAIWfilt.AbsoluteSalinityS_Agkg > 34.72;
AAIWfilt(toDelete,:) = [];

toDelete = AAIWfilt.PotentialDensityAnomalys_0kgm3 < 27.2 | AAIWfilt.PotentialDensityAnomalys_0kgm3 > 27.3;
AAIWfilt(toDelete,:) = [];

% Apply Bianchi et al. 2012 O2 correction, not actually used in this paper
AAIWfilt.O2corr=(1.009.*(AAIWfilt.Oxygenumolkg.*((1000+AAIWfilt.PotentialDensityAnomalys_0kgm3)./1000))-2.523).*(1000./(1000+AAIWfilt.PotentialDensityAnomalys_0kgm3));


%% save

% save('WOA_data_filter','ESWfilt','x13CWfilt','EqPIWfilt','AAIWfilt')
