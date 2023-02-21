%% 

% This script is designed to combine the anoxic cruises in the WOD18
% database into a single file

%% remove extra columns

clear
load('WOD_anoxic_all')
vars=DSCG941hy1clean.Properties.VariableNames;
R325020060213hy1clean=removevars(R325020060213hy1clean,setdiff(R325020060213hy1clean.Properties.VariableNames,vars));
RO20071215hy1clean=removevars(RO20071215hy1clean,setdiff(RO20071215hy1clean.Properties.VariableNames,vars));
RO20161119hy1clean=removevars(RO20161119hy1clean,setdiff(RO20161119hy1clean.Properties.VariableNames,vars));

% go back over them
vars=R325020060213hy1clean.Properties.VariableNames;
DSCG941hy1clean=removevars(DSCG941hy1clean,setdiff(DSCG941hy1clean.Properties.VariableNames,vars));
RO20071215hy1clean=removevars(RO20071215hy1clean,setdiff(RO20071215hy1clean.Properties.VariableNames,vars));
RO20161119hy1clean=removevars(RO20161119hy1clean,setdiff(RO20161119hy1clean.Properties.VariableNames,vars));

vars=RO20071215hy1clean.Properties.VariableNames;
DSCG941hy1clean=removevars(DSCG941hy1clean,setdiff(DSCG941hy1clean.Properties.VariableNames,vars));
R325020060213hy1clean=removevars(R325020060213hy1clean,setdiff(R325020060213hy1clean.Properties.VariableNames,vars));
RO20161119hy1clean=removevars(RO20161119hy1clean,setdiff(RO20161119hy1clean.Properties.VariableNames,vars));

vars=RO20161119hy1clean.Properties.VariableNames;
DSCG941hy1clean=removevars(DSCG941hy1clean,setdiff(DSCG941hy1clean.Properties.VariableNames,vars));
R325020060213hy1clean=removevars(R325020060213hy1clean,setdiff(R325020060213hy1clean.Properties.VariableNames,vars));
RO20071215hy1clean=removevars(RO20071215hy1clean,setdiff(RO20071215hy1clean.Properties.VariableNames,vars));

%% combine and clean for missing values
R325020060213hy1clean.EXPOCODE=categorical(R325020060213hy1clean.EXPOCODE);
R325020060213hy1clean.SECT_ID=categorical(R325020060213hy1clean.SECT_ID);
RO20071215hy1clean.SECT_ID=categorical(RO20071215hy1clean.SECT_ID);
RO20161119hy1clean.SECT_ID=categorical(RO20161119hy1clean.SECT_ID);

WOD_anoxic_comb=vertcat(DSCG941hy1clean, R325020060213hy1clean, RO20071215hy1clean, RO20161119hy1clean);
WOD_anoxic_comb(WOD_anoxic_comb.NITRAT<0 | WOD_anoxic_comb.PHSPHT<0 | WOD_anoxic_comb.TCARBN<0 | WOD_anoxic_comb.LATITUDE<0,:)=[];

save('WOD_anoxic_comb', 'WOD_anoxic_comb');
