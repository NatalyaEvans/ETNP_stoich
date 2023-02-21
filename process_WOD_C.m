%% 
% This script loads in the fully subset WOD 2018 data for each water mass,
% output by "filter_WOD_data_C.m", then plots of all of the nutrients and
% performs linear regressions

% Last updated 2022 04 21 by Natalya Evans to clean this code. Comments to
% explain its function can be found on its companion, process_WOD.m.
% However, in this version, NaN values need to be removed, which makes data
% cleaning for linear regression more complex.

% Updated 2022 02 20 to use a cleaned WOD output

%%
close all
clear

load('WOD_clean_filter');

wm={'13CW','NEPIW','AAIW'}; % water mass names

col=[[0 0.4470 0.7410]',[0.8500 0.3250 0.0980]',[0.9290 0.6940 0.1250]',[0.4940 0.1840 0.5560]',[0.4660 0.6740 0.1880]',[0.3010 0.7450 0.9330]',[0.6350 0.0780 0.1840]',[1 0 0]']; % colors in the for loop
mark={'o','d','^'};

clear lr_out
clear lr_label
lr_out=ones(1,5);
lr_num=2;
lr_label={};

%% PO4-total C

figure(1)

% plot WOD data
i=3;

p1=plot(AAIW_Cfilt.Phosphateumolkg, AAIW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphateumolkg, EqPIW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphateumolkg, x13CW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% % perform linear regressions

pfilt=1; % removes low values from trendline
ind=[isnan(x13CW_Cfilt.DICumolkg)~=1].*[isnan(x13CW_Cfilt.Phosphateumolkg)~=1].*[x13CW_Cfilt.Phosphateumolkg>1];
x=x13CW_Cfilt.Phosphateumolkg(ind==1);
y=x13CW_Cfilt.DICumolkg(ind==1);

ind=[isnan(EqPIW_Cfilt.DICumolkg)~=1].*[isnan(EqPIW_Cfilt.Phosphateumolkg)~=1];
x=[x', EqPIW_Cfilt.Phosphateumolkg(ind==1)']';
y=[y', EqPIW_Cfilt.DICumolkg(ind==1)']';

ind=[isnan(AAIW_Cfilt.DICumolkg)~=1].*[isnan(AAIW_Cfilt.Phosphateumolkg)~=1];
x=[x', AAIW_Cfilt.Phosphateumolkg(ind==1)']';
y=[y', AAIW_Cfilt.DICumolkg(ind==1)']';

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-C aerobic'};

hold off
set(gca,'YTickLabels',[])

xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
% ylabel('Dissolved Inorganic Carbon/{\mu}mol kg^{-1}')
% legend([p3, p2, p1],'13CW','NEPIW','AAIW','Location','Northwest')

%% NO3-C

figure(2)
i=1;

p1=plot(x13CW_Cfilt.Nitrateumolkg,x13CW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i+1;

p2=plot(EqPIW_Cfilt.Nitrateumolkg,EqPIW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

p3=plot(AAIW_Cfilt.Nitrateumolkg,AAIW_Cfilt.DICumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

% linear regressions
% 13CW
lr_num=lr_num+1;
nfilt=2230; % removes low values from trendline
ind=[isnan(x13CW_Cfilt.DICumolkg)~=1].*[isnan(x13CW_Cfilt.Nitrateumolkg)~=1].*[x13CW_Cfilt.DICumolkg<nfilt];
x=x13CW_Cfilt.Nitrateumolkg(ind==1);
y=x13CW_Cfilt.DICumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Aerobic NO3-C 13CW'};

lr_num=lr_num+1;
ind=[isnan(x13CW_Cfilt.DICumolkg)~=1].*[isnan(x13CW_Cfilt.Nitrateumolkg)~=1].*[x13CW_Cfilt.DICumolkg>nfilt];
x=x13CW_Cfilt.Nitrateumolkg(ind==1);
y=x13CW_Cfilt.DICumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Anaerobic NO3-C 13CW'};

% NEPIW
lr_num=lr_num+1;
% nfilt=2.26*1000;
nfilt=2.255*1000;
ind=[isnan(EqPIW_Cfilt.DICumolkg)~=1].*[isnan(EqPIW_Cfilt.Nitrateumolkg)~=1].*[EqPIW_Cfilt.DICumolkg<nfilt];
x=EqPIW_Cfilt.Nitrateumolkg(ind==1);
y=EqPIW_Cfilt.DICumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Aerobic NO3-C NEPIW'};

lr_num=lr_num+1;
nfilt2=2340;
ind=[isnan(EqPIW_Cfilt.DICumolkg)~=1].*[isnan(EqPIW_Cfilt.Nitrateumolkg)~=1].*[EqPIW_Cfilt.DICumolkg>nfilt].*[EqPIW_Cfilt.DICumolkg<nfilt2];
x=EqPIW_Cfilt.Nitrateumolkg(ind==1);
y=EqPIW_Cfilt.DICumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Anaerobic NO3-C NEPIW'};

% % AAIW
% lr_num=lr_num+1;
% nfilt=2.28*1000;
% ind=[isnan(AAIW_Cfilt.DICumolkg)~=1].*[isnan(AAIW_Cfilt.Nitrateumolkg)~=1].*[AAIW_Cfilt.DICumolkg<nfilt];
% x=AAIW_Cfilt.Nitrateumolkg(ind==1);
% y=AAIW_Cfilt.DICumolkg(ind==1);
% [m,b,r,sm,sb] = lsqfitma(x,y);
% plot(sort(x),m*sort(x)+b,'k') 
% lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
% lr_label(lr_num)={'Aerobic NO3-C AAIW'};

hold off

xlabel('NO_3^{-}/{\mu}mol kg^{-1}')
ylabel('Dissolved Inorganic Carbon/{\mu}mol kg^{-1}')
% legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northwest')

%% 
figure(3)

% plot WOD N-P
i=3;

p1=plot(AAIW_Cfilt.Phosphateumolkg, AAIW_Cfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphateumolkg, EqPIW_Cfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphateumolkg, x13CW_Cfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% perform linear regressions
% AAIW
lr_num=lr_num+1;
pfilt=3.1;
x=AAIW_Cfilt.Phosphateumolkg(AAIW_Cfilt.Phosphateumolkg<pfilt);
y=AAIW_Cfilt.Nitrateumolkg(AAIW_Cfilt.Phosphateumolkg<pfilt);

inds= y<34.5;
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P AAIW aerobic'};

% NEPIW
lr_num=lr_num+1;
pfilt=2.68;
x=EqPIW_Cfilt.Phosphateumolkg(EqPIW_Cfilt.Phosphateumolkg<pfilt);
y=EqPIW_Cfilt.Nitrateumolkg(EqPIW_Cfilt.Phosphateumolkg<pfilt);
inds= y-13*x < 0;
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P NEPIW aerobic'};

lr_num=lr_num+1;
% pfilt=2.56;
pfilt=2.52;
x=EqPIW_Cfilt.Phosphateumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);
y=EqPIW_Cfilt.Nitrateumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<21)=[];
yfit(yfit<21)=[];

xfit(yfit>40)=[];
yfit(yfit>40)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P NEPIW anaerobic'};

% 13CW
lr_num=lr_num+1;
pfilt=2.29;
x=x13CW_Cfilt.Phosphateumolkg(x13CW_Cfilt.Phosphateumolkg<pfilt);
y=x13CW_Cfilt.Nitrateumolkg(x13CW_Cfilt.Phosphateumolkg<pfilt);
inds= x>1.5 & y<21;
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x(y>18)),m*sort(x(y>18))+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P 13CW aerobic'};

lr_num=lr_num+1;
pfilt=2.24;
nfilt=33;
x=x13CW_Cfilt.Phosphateumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);
y=x13CW_Cfilt.Nitrateumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);
x(y>nfilt)=[];
y(y>nfilt)=[];
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P 13CW anaerobic'};

ylim([15 45])
xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('NO_3^{-}/{\mu}mol kg^{-1}')
% legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northwest')
set(gca,'YTickLabels',[])

hold off

%% 
figure(4)

% plot WOD O2-P
i=3;

p1=plot(AAIW_Cfilt.Phosphateumolkg, AAIW_Cfilt.Oxygenumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphateumolkg, EqPIW_Cfilt.Oxygenumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphateumolkg, x13CW_Cfilt.Oxygenumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% perform linear regressions
% AAIW
% pfilt=3.1;
lr_num=lr_num+1;
pfilt=0;
x=AAIW_Cfilt.Phosphateumolkg(AAIW_Cfilt.Phosphateumolkg>pfilt);
y=AAIW_Cfilt.Oxygenumolkg(AAIW_Cfilt.Phosphateumolkg>pfilt);

inds = isnan(y);
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P AAIW aerobic'};

% NEPIW
lr_num=lr_num+1;
% pfilt=2.68;
pfilt=0;
x=EqPIW_Cfilt.Phosphateumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);
y=EqPIW_Cfilt.Oxygenumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);

% inds= y-13*x < 0;
% x(inds)=[];
% y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P NEPIW aerobic'};

% lr_num=lr_num+1;
% % pfilt=2.56;
% pfilt=0;
% x=EqPIW_Cfilt.Phosphateumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);
% y=EqPIW_Cfilt.Oxygenumolkg(EqPIW_Cfilt.Phosphateumolkg>pfilt);
% [m,b,r,sm,sb] = lsqfitma(x,y);
% 
% xfit=sort(x);
% yfit=m*sort(x)+b;
% xfit(yfit<21)=[];
% yfit(yfit<21)=[];
% 
% plot(xfit,yfit,'k')
% lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
% lr_label(lr_num)={'O2-P NEPIW anaerobic'};

% 13CW
lr_num=lr_num+1;
% pfilt=2.29;
pfilt=0;
x=x13CW_Cfilt.Phosphateumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);
y=x13CW_Cfilt.Oxygenumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);

inds = isnan(y);
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P 13CW aerobic'};

% lr_num=lr_num+1;
% pfilt=2.29;
% x=x13CW_Cfilt.Phosphateumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);
% y=x13CW_Cfilt.Oxygenumolkg(x13CW_Cfilt.Phosphateumolkg>pfilt);
% [m,b,r,sm,sb] = lsqfitma(x,y);
% 
% xfit=sort(x);
% yfit=m*sort(x)+b;
% xfit(yfit<23)=[];
% yfit(yfit<23)=[];
% 
% plot(xfit,yfit,'k')
% lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
% lr_label(lr_num)={'O2-P 13CW anaerobic'};

ylim([0 140])
xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('O_2/{\mu}mol kg^{-1}')
% legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northwest')
xline(2.33,'k--');
xline(2.65,'k--');

hold off


%% PO4-SiO4

figure(5)

% plot WOD data
i=3;

p1=plot(AAIW_Cfilt.Phosphateumolkg, AAIW_Cfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphateumolkg, EqPIW_Cfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphateumolkg, x13CW_Cfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% % endmembers
% p4=plot([2.355,2.65,3.13],[25.4,33.86,83.68],'kd','MarkerFaceColor','r');

% % perform linear regressions

% 13CW
pfilt=1; % removes low values from trendline
ind=[isnan(x13CW_Cfilt.Silicateumolkg)~=1].*[isnan(x13CW_Cfilt.Phosphateumolkg)~=1].*[x13CW_Cfilt.Phosphateumolkg>1];
x=x13CW_Cfilt.Phosphateumolkg(ind==1);
y=x13CW_Cfilt.Silicateumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')

xfit=sort(x);
yfit=m*sort(x)+b;

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-SiO4 13CW'};

% NEPIW
lr_num=lr_num+1;
sifilt=28;
ind=[isnan(EqPIW_Cfilt.Silicateumolkg)~=1].*[isnan(EqPIW_Cfilt.Phosphateumolkg)~=1].*[EqPIW_Cfilt.Silicateumolkg>sifilt];
x=EqPIW_Cfilt.Phosphateumolkg(ind==1);
y=EqPIW_Cfilt.Silicateumolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-SiO4 NEPIW'};

% AAIW
lr_num=lr_num+1;
% pfilt=3.19;
ind=[isnan(AAIW_Cfilt.Silicateumolkg)~=1].*[isnan(AAIW_Cfilt.Phosphateumolkg)~=1];
x=AAIW_Cfilt.Phosphateumolkg(ind==1);
y=AAIW_Cfilt.Silicateumolkg(ind==1);
% y=y(x<=pfilt);
% x=x(x<=pfilt);


[m,b,r,sm,sb] = lsqfitma(x,y);
xfit=sort(x);
yfit=m*sort(x)+b;

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-SiO4 AAIW'};

hold off

xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('SiO_4^{2-}/{\mu}mol kg^{-1}')
% legend([p3, p2, p1, p4],'13CW','NEPIW','AAIW','Endmembers','Location','Northwest')
% legend([p3, p2, p1],'13CW','NEPIW','AAIW','Location','Northwest')



%% Process table

lr_out=num2cell(lr_out);
lr_out(:,1)=lr_label';
lr_out(1,:)={'','Slope','Unc slope','Intercept','Unc intercept'};
% save('lr_out','lr_out')