%% 
% This script loads in the fully subset WOA 2013 data for each water mass,
% output by "filter_WOD_data_C.m", then plots of all of the nutrients and
% performs linear regressions

% Last updated 2022 04 21 by Natalya Evans to clean this code. Comments to
% explain its function can be found on its companion, process_WOA.m.
% However, in this version, NaN values need to be removed, which makes data
% cleaning for linear regression more complex.

%%
load('WOD_data_C_filter');

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

p1=plot(AAIW_Cfilt.Phosphatemmolkg, AAIW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphatemmolkg, EqPIW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphatemmolkg, x13CW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% % perform linear regressions

% 13CW
pfilt=1; % removes low values from trendline
ind=[isnan(x13CW_Cfilt.tCO_2umolkg)~=1].*[isnan(x13CW_Cfilt.Phosphatemmolkg)~=1].*[x13CW_Cfilt.Phosphatemmolkg>1];
x=x13CW_Cfilt.Phosphatemmolkg(ind==1);
y=x13CW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-C 13CW'};

xfit=sort(x);
yfit=m*sort(x)+b;

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-C 13CW'};

% NEPIW
lr_num=lr_num+1;
ind=[isnan(EqPIW_Cfilt.tCO_2umolkg)~=1].*[isnan(EqPIW_Cfilt.Phosphatemmolkg)~=1];
x=EqPIW_Cfilt.Phosphatemmolkg(ind==1);
y=EqPIW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-C NEPIW'};

% AAIW
lr_num=lr_num+1;
ind=[isnan(AAIW_Cfilt.tCO_2umolkg)~=1].*[isnan(AAIW_Cfilt.Phosphatemmolkg)~=1];
x=AAIW_Cfilt.Phosphatemmolkg(ind==1);
y=AAIW_Cfilt.tCO_2umolkg(ind==1);

[m,b,r,sm,sb] = lsqfitma(x,y);
xfit=sort(x);
yfit=m*sort(x)+b;

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'PO4-C AAIW'};

hold off

xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('Total CO_2/{\mu}mol kg^{-1}')
legend([p3, p2, p1],'13CW','NEPIW','AAIW','Location','Northwest')

%% NO3-C

figure(2)
i=1;

p1=plot(x13CW_Cfilt.Nitratemmolkg,x13CW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i+1;

p2=plot(EqPIW_Cfilt.Nitratemmolkg,EqPIW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

p3=plot(AAIW_Cfilt.Nitratemmolkg,AAIW_Cfilt.tCO_2umolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

% linear regressions
% 13CW
lr_num=lr_num+1;
nfilt=2230; % removes low values from trendline
ind=[isnan(x13CW_Cfilt.tCO_2umolkg)~=1].*[isnan(x13CW_Cfilt.Nitratemmolkg)~=1].*[x13CW_Cfilt.tCO_2umolkg<nfilt];
x=x13CW_Cfilt.Nitratemmolkg(ind==1);
y=x13CW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Aerobic NO3-C 13CW'};

lr_num=lr_num+1;
ind=[isnan(x13CW_Cfilt.tCO_2umolkg)~=1].*[isnan(x13CW_Cfilt.Nitratemmolkg)~=1].*[x13CW_Cfilt.tCO_2umolkg>nfilt];
x=x13CW_Cfilt.Nitratemmolkg(ind==1);
y=x13CW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Anaerobic NO3-C 13CW'};

% NEPIW
lr_num=lr_num+1;
nfilt=2.26*1000;
ind=[isnan(EqPIW_Cfilt.tCO_2umolkg)~=1].*[isnan(EqPIW_Cfilt.Nitratemmolkg)~=1].*[EqPIW_Cfilt.tCO_2umolkg<nfilt];
x=EqPIW_Cfilt.Nitratemmolkg(ind==1);
y=EqPIW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Aerobic NO3-C NEPIW'};

lr_num=lr_num+1;
nfilt2=2340;
ind=[isnan(EqPIW_Cfilt.tCO_2umolkg)~=1].*[isnan(EqPIW_Cfilt.Nitratemmolkg)~=1].*[EqPIW_Cfilt.tCO_2umolkg>nfilt].*[EqPIW_Cfilt.tCO_2umolkg<nfilt2];
x=EqPIW_Cfilt.Nitratemmolkg(ind==1);
y=EqPIW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Anaerobic NO3-C NEPIW'};

% AAIW
lr_num=lr_num+1;
nfilt=2.32*1000;
ind=[isnan(AAIW_Cfilt.tCO_2umolkg)~=1].*[isnan(AAIW_Cfilt.Nitratemmolkg)~=1].*[AAIW_Cfilt.tCO_2umolkg<nfilt];
x=AAIW_Cfilt.Nitratemmolkg(ind==1);
y=AAIW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Aerobic NO3-C AAIW'};

% AAIW anaerobic
lr_num=lr_num+1;
nfilt=2.324*1000;
ind=[isnan(AAIW_Cfilt.tCO_2umolkg)~=1].*[isnan(AAIW_Cfilt.Nitratemmolkg)~=1].*[AAIW_Cfilt.tCO_2umolkg>nfilt];
x=AAIW_Cfilt.Nitratemmolkg(ind==1);
y=AAIW_Cfilt.tCO_2umolkg(ind==1);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'anaerobic NO3-C AAIW'};

hold off

xlabel('NO_3^{-}/{\mu}mol kg^{-1}')
ylabel('Total CO_2/{\mu}mol kg^{-1}')
legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northwest')

%% 
figure(3)

% plot WOD N-P
i=3;

p1=plot(AAIW_Cfilt.Phosphatemmolkg, AAIW_Cfilt.Nitratemmolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIW_Cfilt.Phosphatemmolkg, EqPIW_Cfilt.Nitratemmolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CW_Cfilt.Phosphatemmolkg, x13CW_Cfilt.Nitratemmolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% perform linear regressions
% AAIW
pfilt=3.1;
x=AAIW_Cfilt.Phosphatemmolkg(AAIW_Cfilt.Phosphatemmolkg<pfilt);
y=AAIW_Cfilt.Nitratemmolkg(AAIW_Cfilt.Phosphatemmolkg<pfilt);

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
x=EqPIW_Cfilt.Phosphatemmolkg(EqPIW_Cfilt.Phosphatemmolkg<pfilt);
y=EqPIW_Cfilt.Nitratemmolkg(EqPIW_Cfilt.Phosphatemmolkg<pfilt);
inds= y-13*x < 0;
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P NEPIW aerobic'};

lr_num=lr_num+1;
pfilt=2.56;
x=EqPIW_Cfilt.Phosphatemmolkg(EqPIW_Cfilt.Phosphatemmolkg>pfilt);
y=EqPIW_Cfilt.Nitratemmolkg(EqPIW_Cfilt.Phosphatemmolkg>pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<21)=[];
yfit(yfit<21)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P NEPIW anaerobic'};

% 13CW
lr_num=lr_num+1;
pfilt=2.29;
x=x13CW_Cfilt.Phosphatemmolkg(x13CW_Cfilt.Phosphatemmolkg<pfilt);
y=x13CW_Cfilt.Nitratemmolkg(x13CW_Cfilt.Phosphatemmolkg<pfilt);
inds= x>1.5 & y<21;
x(inds)=[];
y(inds)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x(y>18)),m*sort(x(y>18))+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P 13CW aerobic'};

lr_num=lr_num+1;
pfilt=2.29;
x=x13CW_Cfilt.Phosphatemmolkg(x13CW_Cfilt.Phosphatemmolkg>pfilt);
y=x13CW_Cfilt.Nitratemmolkg(x13CW_Cfilt.Phosphatemmolkg>pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<23)=[];
yfit(yfit<23)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'N-P 13CW anaerobic'};

ylim([15 45])
xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('NO_3^{-}/{\mu}mol kg^{-1}')
legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northwest')

hold off


%% Process table

lr_out=num2cell(lr_out);
lr_out(:,1)=lr_label';
lr_out(1,:)={'','Slope','Unc slope','Intercept','Unc intercept'};
% save('lr_out','lr_out')