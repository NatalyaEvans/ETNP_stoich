%%

close all
load('ETNP_df_pyompasoln')

%% plot data

figure(1)
plot(100*df.CW_frac_total,df.Depthm,'ko')
hold on
plot(100*df.NEPIW_frac_total,df.Depthm,'rd')
plot(100*df.AAIW_frac_total,df.Depthm,'b^')
% plot(100*df.uPSUW_frac_total,df.pdens,'g*')

axis ij
xlabel('Water mass content (%)')
ylabel('Potential density/kg m^{-3}')
legend('13CW','NEPIW','AAIW','uPSUW','Location','Northeast')
hold off

figure(2)
plot(df.aerobic_remin,df.Depthm,'ko')
hold on
plot(df.anaerobic_remin,df.Depthm,'rd')
axis ij
xlabel('Remineralization/{\mu}mol PO_4^{3-} equivalents kg^{-1}')
ylabel('Potential density/kg m^{-3}')
legend('Aerobic','Anaerobic','Location','Northeast')
xlim([0 0.4])
hold off

res=sqrt((df.CT_resid.^2)/12+(df.SA_resid.^2)/8+(df.Phosphate_resid.^2)/6+(df.Nitrate_resid.^2)/4+(df.Silicate_resid.^2)/2+(df.tCO2_resid.^2)/4);
figure(3)
plot(res,df.Depthm,'ko')
axis ij

df(res>4,:)=[]; % removes large residuals



%% splitting out each cruise

cruises=unique(df.OriginatorsCruise);
df_backup=df;

for j=1:length(cruises)
    df=df_backup(df_backup.OriginatorsCruise==cruises(j),:);
    
%% aerobic remin

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,df.aerobic_remin,50,'natural','extrap');
cmap=cmocean('amp');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',{'Aerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
set(gca,'box','on')
caxis([0 0.2]) %sets the range of colorbar. Comment out for an auto scale
set(gca,'position',[.1 .1 .69 .6])
xlim([8 22.9])

%% anaerobic remin

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,df.anaerobic_remin,50,'natural','extrap');
caxis([0 0.25]) %sets the range of colorbar. Comment out for an auto scale
h=colorbar; %displays the colorbar
cmap=cmocean('algae');
colormap(cmap);
set(get(h,'label'),'string',{'Anaerobic remineralization/{\mu}mol kg^{-1}','PO_4^{3-} equivalents'},'FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([8 22.9])

%% O2

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,df.Oxygenmmolkg,50,'natural','extrap');
caxis([0 20]) %sets the range of colorbar. Comment out for an auto scale
cmap=cmocean('-ice');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Oxygen/{\mu}mol kg^{-1}','FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([8 22.9])

%% Calculate how much nitrite reox is occuring

ref=-94.4;
no2_reox=100*(ref-df.Nitrate_to_anaerobic_remin_ratio)./ref;

%% % reox

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,no2_reox,50,'natural','extrap');
caxis([30 60]) %sets the range of colorbar. Comment out for an auto scale
cmap=viridis(100);
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Nitrite reoxidized','FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([8 22.9])

%% water masses

titles={'13CW','NEPIW','AAIW'};
for i=1:3

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,100*table2array(df(:,61+i)),50,'natural','extrap');
cmap=cmocean('tempo');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string',[titles{i} ' content'],'FontSize',12);
h.Ruler.TickLabelFormat='%g%%';
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
xlim([8 22.9])
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
caxis([0 max(100*table2array(df(:,61+i)))])

end


%% residuals

figure(); %declare the figure. Running this script again will overwrite the figure unless you change the number
chem_all=res; %change this assignment to alter what you are plotting. RHS is the name in the workspace defined in import_data
fig=striped_interp(df.Latitudedegrees_north,df.Depthm,res,50,'natural','extrap');
cmap=cmocean('tempo');
colormap(cmap);
h=colorbar; %displays the colorbar
set(get(h,'label'),'string','Sum of squared residuals','FontSize',12);
xlabel(['Latitude/' char(176) 'N'])
ylabel('Depth/m')
set(gca,'box','on')
set(gca,'position',[.1 .1 .69 .6])
xlim([8 22.9])

pause
end

