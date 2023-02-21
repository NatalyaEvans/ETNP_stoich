%% 

% This file is designed to read in netCDF files from WOD18select with DIC
% (tCO2) measurements then clean them. Cleaning consists of removing files
% that are marked as having nitrate=nitrate+nitrite. These files are
% checked over by comparing against data from CCHDO, then saved.

% Written 20 Feb 2023 by Talia Evans


%% read in data and configure values for iteration

clear

folderData = 'C:\Users\zheva\Documents\Matlab folders\Matlab_WMA_ETNP\REU 2020\separate project split\stoichiometry\Stoich code\WOD_pyompa_v2\ocldb1675837096.4384.OSD.tar\ocldb1675837096.4384.OSD';
filePattern = fullfile(folderData, '*.nc'); 
ncfiles = dir(filePattern);
nFiles = length(ncfiles);

out=array2table(ones(0,12)*NaN);
out.Properties.VariableNames = {'orig_id','WOD_id','Longitudedegrees', ...
    'Latitudedegrees_north','Depthm', 'Temperaturedegrees_C','Salinitypsu','Phosphateumolkg', 'Silicateumolkg',...
           'Oxygenumolkg','Nitrateumolkg','DICmmolL'};

out.orig_id=categorical(out.orig_id);    
out.WOD_id=categorical(out.WOD_id);  

NplusN=0; % counter for rejected WOD stations
NO3NO2=0; % counter for rejected WOD stations


%% iterate

for i = 1:nFiles
    filename = fullfile(ncfiles(i).folder, ncfiles(i).name);
    
    % clean data
    vinfo = ncinfo(filename);
    for j=1:length(vinfo.Variables) % check for O2
        vars{j,:}=vinfo.Variables(j).Name;
    end
    
    if any(strcmp(vars,'Nitrate_contains_nitrite')) % contains nitrite
        NplusN=NplusN+1;
        continue
    end
    
    if any(strcmp(vars,'NO2NO3')) % contains nitrite
        NO3NO2=NO3NO2+1;
        continue
    end
    
    depth = ncread(filename,'z');
    temp=array2table(ones(length(depth),12)*NaN);
    temp.Properties.VariableNames = {'orig_id','WOD_id','Longitudedegrees', ...
    'Latitudedegrees_north','Depthm', 'Temperaturedegrees_C','Salinitypsu','Phosphateumolkg', 'Silicateumolkg',...
           'Oxygenumolkg','Nitrateumolkg','DICmmolL'};
        
    temp.Depthm=depth;
    temp.Temperaturedegrees_C = ncread(filename,'Temperature');
    temp.Salinitypsu = ncread(filename,'Salinity');
    temp.Oxygenumolkg = ncread(filename,'Oxygen');
    temp.Phosphateumolkg = ncread(filename,'Phosphate');  
    temp.Silicateumolkg = ncread(filename,'Silicate');  
    temp.Nitrateumolkg = ncread(filename,'Nitrate');  
    temp.DICmmolL  = ncread(filename,'tCO2');  
    
    if any(strcmp(vars,'originators_cruise_identifier')) % contains nitrite
        id = ncread(filename,'originators_cruise_identifier');  
        id(isspace(id))=[]; % remove extra characters at end
        id2=cell(length(depth),1);
        id2(:)={char(strrep(strjoin(string(id))," ",""))}; % join strings together, remove spaces, and fill cell array
        temp.orig_id=categorical(id2);
    
    else
        id2=cell(length(depth),1);
        id2(:)={'missing_value'};
        temp.orig_id=categorical(id2);
    end
    
    id = ncread(filename,'WOD_cruise_identifier');
    id(isspace(id))=[]; % remove extra characters at end
    id2=cell(length(depth),1);
    id2(:)={char(strrep(strjoin(string(id))," ",""))}; % join strings together, remove spaces, and fill cell array
    temp.WOD_id=categorical(id2);
    
    lon = ncread(filename,'lon');
    lat = ncread(filename,'lat');
    temp.Longitudedegrees=double(lon).*ones(length(depth),1);
    temp.Latitudedegrees_north=double(lat).*ones(length(depth),1);
    
    out=vertcat(out,temp);
    
end

%% clean data

out(out.Phosphateumolkg<0,:)=[];
out(out.Nitrateumolkg<0,:)=[];
out(out.DICmmolL<0,:)=[];
out(out.Oxygenumolkg<0,:)=[];

%% check that nitrate matches the CCHDO database for anoxic cruises

close all

load('WOD_anoxic_comb')
cruises={'31DSCG94_3','3250200602','33RO20071215','33RO20161119'};
out.press=gsw_p_from_z(-out.Depthm, out.Latitudedegrees_north);

for i=1:4
    if i==2
        comp=out(out.orig_id==cruises{i} & out.Latitudedegrees_north<2.5 & out.Latitudedegrees_north>1.5,:);
        CCHDO=WOD_anoxic_comb(WOD_anoxic_comb.EXPOCODE=='325020000000' & WOD_anoxic_comb.LATITUDE<2.5 & WOD_anoxic_comb.LATITUDE>1.5,:);
    else        
        comp=out(out.orig_id==cruises{i} & out.Latitudedegrees_north<14.7 & out.Latitudedegrees_north>14.3,:);
        CCHDO=WOD_anoxic_comb(WOD_anoxic_comb.EXPOCODE==cruises(i) & WOD_anoxic_comb.LATITUDE<14.7 & WOD_anoxic_comb.LATITUDE>14.3,:);
    end
    
    figure(i)
    [y,inds]=sort(comp.press);
    x=comp.Nitrateumolkg(inds);
    plot(x,y,'ko-')
    hold on
    
    [y,inds]=sort(CCHDO.CTDPRS);
    x=CCHDO.NITRAT(inds);
    x2=CCHDO.NITRIT(inds);
    plot(x,y,'rd--')
    plot(x2,y,'b^-.')
    axis ij
    xlabel('N')
    ylabel('Pressure/dbar')
    legend('WOD Nitrate','CCHDO Nitrate','CCHDO Nitrite','Location','South')
    hold off
    title(cruises{i})
end
    
%% remove data not relevant

WOD_clean=out(out.Latitudedegrees_north>=0,:);
cruises_anoxic=unique(WOD_clean.orig_id(WOD_clean.Oxygenumolkg<5));

% check which cruises are present
cruises_list=[];
k=1;
clear cruises2 vals
for i=1:length(cruises_anoxic)
   temp=WOD_clean(WOD_clean.orig_id==cruises_anoxic(i),:);
   if sum(temp.Oxygenumolkg<5)>0
       cruises2(k)=cruises_anoxic(i);
       vals(k)=sum(temp.Oxygenumolkg<5);
       k=k+1;
   end
end

% format output table
summary=[string(cruises2'),vals'];
[~,inds]=sort(vals,'descend');
summary=summary(inds,:);
summary=vertcat(["Cruise","Number of samples"],summary) % display output
display('Total WOD_clean samples')
length(WOD_clean.orig_id)

WOD_clean(WOD_clean.orig_id=='LEGX' | WOD_clean.orig_id=='22660006',:)=[]; % DIC entered wrong
display('Kept WOD_clean samples')
length(WOD_clean.orig_id)

save('WOD_clean','WOD_clean')

