%%

clear
close all
load('ETNP_df_pyompasoln')

res=sqrt((base.CT_resid.^2)/12+(base.SA_resid.^2)/8+(base.Phosphate_resid.^2)/6+(base.Nitrate_resid.^2)/4+(base.Silicate_resid.^2)/2+(base.tCO2_resid.^2)/4);
base(res>4,:)=[]; % removes large residuals
mean_endmembers(res>4,:)=[]; % removes large residuals
std_endmembers(res>4,:)=[]; % removes large residuals


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



%% splitting out each cruise

cruises=unique(base.OriginatorsCruise);
year=[1994,2007,2016];

k=1;
for j=1:length(cruises)
    base_cruise=base(base.OriginatorsCruise==cruises(j),:);
    mean_endmembers_cruise=mean_endmembers(mean_endmembers.OriginatorsCruise==cruises(j),:);
    std_endmembers_cruise=std_endmembers(std_endmembers.OriginatorsCruise==cruises(j),:);
    
%% O2

figure(k); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.Oxygenmmolkg,50,'natural','extrap');
caxis([0 20]) %sets the range of colorbar. Comment out for an auto scale
cmap=cmocean('-ice');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Oxygen/{\mu}mol kg^{-1}','FontSize',12);
% xlabel(['Latitude/' char(176) 'N'])

if j==1
ylabel('Depth/m')
else
    set(gca,'YTickLabels',[]);
end
ylim([200 800])

set(gca,'XTickLabels',[]);
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
title(year(j))
k=k+1;

saveas(gcf,[num2str(year(j)) ' o2.svg']);

%% % reox

figure(k); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.no2_reox,50,'natural','extrap');
caxis([30 60]) %sets the range of colorbar. Comment out for an auto scale
cmap=viridis(100);
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Nitrite reoxidized','FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
% xlabel(['Latitude/' char(176) 'N'])

if j==1
ylabel('Depth/m')
else
    set(gca,'YTickLabels',[]);
end
ylim([200 800])

set(gca,'XTickLabels',[]);
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
k=k+1;

saveas(gcf,[num2str(year(j)) ' no2 reox.svg']);

%% % reox

figure(k); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(std_endmembers_cruise.Latitudedegrees_north,std_endmembers_cruise.Depthm,std_endmembers_cruise.no2_reox/3,50,'natural','extrap');
caxis([0 13/3]) %sets the range of colorbar. Comment out for an auto scale
cmap=viridis(100);
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Uncertainty in nitrite reoxidized','FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
% xlabel(['Latitude/' char(176) 'N'])

if j==1
ylabel('Depth/m')
else
    set(gca,'YTickLabels',[]);
end
ylim([200 800])

set(gca,'XTickLabels',[]);
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
k=k+1;

saveas(gcf,[num2str(year(j)) ' no2 reox std.svg']);

    
%% aerobic remin

figure(k); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.aero_proj,50,'natural','extrap');
cmap=cmocean('amp');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Aerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);
% xlabel(['Latitude/' char(176) 'N'])

if j==1
ylabel('Depth/m')
else
    set(gca,'YTickLabels',[]);
end
ylim([200 800])

set(gca,'XTickLabels',[]);
set(gca,'box','on')
caxis([-0.1 0.2]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
k=k+1;

saveas(gcf,[num2str(year(j)) ' aero.svg']);

%% anaerobic remin

figure(k); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(mean_endmembers_cruise.Latitudedegrees_north,mean_endmembers_cruise.Depthm,mean_endmembers_cruise.anaero_proj,50,'natural','extrap');
caxis([0 0.2]) %sets the range of colorbar. Comment out for an auto scale
h=colorbar; %displays the colorbar
cmap=cmocean('algae');
colormap(cmap);
set(get(h,'label'),'string',{'Anaerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);

if j==1
ylabel('Depth/m')
else
    set(gca,'YTickLabels',[]);
end

ylim([200 800])
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([10 22.9]) 
k=k+1;

saveas(gcf,[num2str(year(j)) ' anaero.svg']);

end

