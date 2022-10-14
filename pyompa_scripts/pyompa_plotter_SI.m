%%

clear all
close all
load('ETNP_df_pyompasoln')

years=[1994,2007,2016];

res=sqrt((base.CT_resid.^2)/12+(base.SA_resid.^2)/8+(base.Phosphate_resid.^2)/6+(base.Nitrate_resid.^2)/4+(base.Silicate_resid.^2)/2+(base.tCO2_resid.^2)/4);
base(res>4,:)=[]; % removes large residuals
mean_endmembers(res>4,:)=[]; % removes large residuals
std_endmembers(res>4,:)=[]; % removes large residuals
res(res>4)=[]; % removes large residuals


%% perform calculations

% for base
ref=-94.4;
base.no2_reox=100*(ref-base.Nitrate_to_anaerobic_remin_ratio)./ref;

refmag=106^2+16^2+1^2; % reference stoichiometry
ref=[106,16,1];
aero_angle=[base.tCO2_to_aerobic_remin_ratio,base.Nitrate_to_aerobic_remin_ratio,base.Phosphate_to_aerobic_remin_ratio]; % define the vector direction
base.aero_proj=base.aerobic_remin.*aero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

refmag=106^2+94.4^2+1^2; % reference stoichiometry
ref=[106,-94.4,1];
anaero_angle=[base.tCO2_to_anaerobic_remin_ratio,base.Nitrate_to_anaerobic_remin_ratio,base.Phosphate_to_anaerobic_remin_ratio]; % define the vector direction
base.anaero_proj=base.anaerobic_remin.*anaero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

% for mean_endmembers
ref=-94.4;
mean_endmembers.no2_reox=100*(ref-mean_endmembers.Nitrate_to_anaerobic_remin_ratio)./ref;

refmag=106^2+16^2+1^2; % reference stoichiometry
ref=[106,16,1];
aero_angle=[mean_endmembers.tCO2_to_aerobic_remin_ratio,mean_endmembers.Nitrate_to_aerobic_remin_ratio,mean_endmembers.Phosphate_to_aerobic_remin_ratio]; % define the vector direction
mean_endmembers.aero_proj=mean_endmembers.aerobic_remin.*aero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

refmag=106^2+94.4^2+1^2; % reference stoichiometry
ref=[106,-94.4,1];
anaero_angle=[mean_endmembers.tCO2_to_anaerobic_remin_ratio,mean_endmembers.Nitrate_to_anaerobic_remin_ratio,mean_endmembers.Phosphate_to_anaerobic_remin_ratio]; % define the vector direction
mean_endmembers.anaero_proj=mean_endmembers.anaerobic_remin.*anaero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

% for std_endmembers
ref=-94.4;
std_endmembers.no2_reox=100*abs((std_endmembers.Nitrate_to_anaerobic_remin_ratio)./ref);

refmag=106^2+16^2+1^2; % reference stoichiometry
ref=[106,16,1];
aero_angle=[std_endmembers.tCO2_to_aerobic_remin_ratio,std_endmembers.Nitrate_to_aerobic_remin_ratio,std_endmembers.Phosphate_to_aerobic_remin_ratio]; % define the vector direction
std_endmembers.aero_proj=std_endmembers.aerobic_remin.*aero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

refmag=106^2+94.4^2+1^2; % reference stoichiometry
ref=[106,-94.4,1];
anaero_angle=[std_endmembers.tCO2_to_anaerobic_remin_ratio,std_endmembers.Nitrate_to_anaerobic_remin_ratio,std_endmembers.Phosphate_to_anaerobic_remin_ratio]; % define the vector direction
std_endmembers.anaero_proj=std_endmembers.anaerobic_remin.*anaero_angle*ref'./refmag; % decouple nitrite reoxidation from our remineralization

%%

% figure()
% plot(mean_endmembers.Oxygenmmolkg,mean_endmembers.no2_reox,'ko')


%% splitting out each cruise

cruises=unique(base.OriginatorsCruise);
years=[1994,2007,2016];
wms={'13CW','NEPIW','AAIW'};

k=1;
for j=1:length(cruises)
    base_cruise=base(base.OriginatorsCruise==cruises(j),:);
    mean_endmembers_cruise=mean_endmembers(mean_endmembers.OriginatorsCruise==cruises(j),:);
    std_endmembers_cruise=std_endmembers(std_endmembers.OriginatorsCruise==cruises(j),:);
    res2=res(base.OriginatorsCruise==cruises(j));
    
%% water masses

titles={'13CW','NEPIW','AAIW'};
for i=1:3

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,100*table2array(mean_endmembers_cruise(:,60+i)),50,'natural','extrap');
cmap=cmocean('tempo');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',[titles{i} ' content'],'FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
xlim([10 22.9])
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
% caxis([0 max(100*table2array(mean_endmembers_cruise(:,61+i)))])
caxis([0 100])
title(years(j))

saveas(gcf,[num2str(years(j)) ' ' wms{i} '.svg']);
end

for i=1:3

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(std_endmembers_cruise.Latitudedegrees_north,std_endmembers_cruise.Depthm,100*table2array(std_endmembers_cruise(:,60+i))/3,50,'natural','extrap');
cmap=cmocean('tempo');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',['Uncertainty in ' titles{i} ' content'],'FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
xlim([10 22.9])
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
% caxis([0 max(100*table2array(std_endmembers_cruise(:,61+i)))])
% caxis([0 100])
title(years(j))

saveas(gcf,[num2str(years(j)) ' ' wms{i} ' unc.svg']);

end

%% aerobic remin

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.aero_proj,50,'natural','extrap');
cmap=cmocean('amp');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Aerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
caxis([-0.1 0.2]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9])
title(years(j))

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(std_endmembers_cruise.Latitudedegrees_north,std_endmembers_cruise.Depthm,std_endmembers_cruise.aero_proj/3,50,'natural','extrap');
cmap=cmocean('amp');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Unc in aerobic remineralization/','{\mu}mol kg^{-1} PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
caxis([0 0.005/3]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
title(years(j))

saveas(gcf,[num2str(years(j)) ' aero unc.svg']);


%% anaerobic remin

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.anaero_proj,50,'natural','extrap');
cmap=cmocean('algae');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Anaerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
caxis([0 0.2]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9])
title(years(j))

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(std_endmembers_cruise.Latitudedegrees_north,std_endmembers_cruise.Depthm,abs(std_endmembers_cruise.anaero_proj)/3,50,'natural','extrap');
cmap=cmocean('algae');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Unc in anaerobic remineralization/','{\mu}mol kg^{-1} PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
caxis([0 0.00016/3]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
title(years(j)) 

saveas(gcf,[num2str(years(j)) ' anaero unc.svg']);



%% residuals

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
chem_all=res; %change this assignment to alter what you are plotting. RHS is the name in the workspace defined in import_data
fig=striped_interp(base_cruise.Latitudedegrees_north,base_cruise.Depthm,res2,50,'natural','extrap');
cmap=cmocean('tempo');
colormap(cmap);
caxis([0 2])
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Sum of squared residuals','FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9])
title(years(j))

saveas(gcf,[num2str(years(j)) ' resid.svg']);


pause
end

100*mean((std_endmembers.aero_proj./mean_endmembers.aero_proj),'omitnan')
100*mean((abs(std_endmembers.anaero_proj)./mean_endmembers.anaero_proj),'omitnan')


