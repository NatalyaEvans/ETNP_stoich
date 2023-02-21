%% 
% This script loads in the fully subset WOA 2013 data for each water mass,
% output by "filter_WOA_data.m", then plots of all of the nutrients and
% performs linear regressions

% Last updated 2022 04 21 by Natalya Evans to comment this code

%%

load('WOA_data_filter'); % loads in output from the previous function
% load('basis_ETNP_Bograd.mat'); % loads in the water types from Evans et al. (2020) as well as Bograd et al. (2019). Both are in TEOS-10. Not actually used in these figures anymore

% wm={'13CW','NEPIW','AAIW'}; % water mass names
% wm_bograd={'uPEW','dPEW'}; % water mass names
% basis_Bograd_gsw(:,2)=[]; % remove dpsuW
% basis_Bograd_gsw(:,4:5)=[]; % remove ENPCWs
% basis_Bograd_gsw(:,1)=[]; % remove uPSUW
% 
% basis_ETNP(:,4:5)=[]; % remove uPSUW and ESW

col=[[0 0.4470 0.7410]',[0.8500 0.3250 0.0980]',[0.9290 0.6940 0.1250]',[0.4940 0.1840 0.5560]',[0.4660 0.6740 0.1880]',[0.3010 0.7450 0.9330]',[0.6350 0.0780 0.1840]',[1 0 0]']; %colors for iterating on loops
mark={'o','d','^'}; % markers for iterating on loops

% set up arrays to accumulate results from linear regressions
clear lr_out
clear lr_label
lr_out=ones(1,5);
lr_num=2;
lr_label={};

%% NO3-PO4

figure(1)
% plot WOA data
i=3;

p1=plot(AAIWfilt.Phosphateumolkg, AAIWfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i-1;

p2=plot(EqPIWfilt.Phosphateumolkg, EqPIWfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

p3=plot(x13CWfilt.Phosphateumolkg, x13CWfilt.Nitrateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i-1;

% % Plot basis
% p4=plot(basis_ETNP(4,:),basis_ETNP(5,:),'ro','MarkerFaceColor','r');
% text(basis_ETNP(4,:),basis_ETNP(5,:),wm,'VerticalAlignment','bottom','HorizontalAlignment','right')
% 
% p5=plot(basis_Bograd_gsw(4,:),basis_Bograd_gsw(5,:),'kd','MarkerFaceColor','k');
% text(basis_Bograd_gsw(4,:),basis_Bograd_gsw(5,:),wm_bograd,'VerticalAlignment','bottom','HorizontalAlignment','right')

% perform linear regressions
% AAIW
pfilt=3.1; % threshold cutoff for where to draw the line
x=AAIWfilt.Phosphateumolkg(AAIWfilt.Phosphateumolkg<pfilt);
y=AAIWfilt.Nitrateumolkg(AAIWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y); % performs the linear regression
plot(sort(x),m*sort(x)+b,'k') 
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % saves the linear regression output
lr_label(lr_num)={'N-P AAIW aerobic'};

lr_num=lr_num+1; % next value in the array
pfilt=3.1; % threshold to cut at
x=AAIWfilt.Phosphateumolkg(AAIWfilt.Phosphateumolkg>pfilt);
y=AAIWfilt.Nitrateumolkg(AAIWfilt.Phosphateumolkg>pfilt);
ind=y < 42.1 & x < 3.368; % remove a specific section so it doesn't interfere with the LR
x(ind)=[];
y(ind)=[];

[m,b,r,sm,sb] = lsqfitma(x,y); % LR
xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<37)=[]; % cut low values so the line isn't really long
yfit(yfit<37)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % save the LR results
lr_label(lr_num)={'N-P AAIW anaerobic'};

% NEPIW
lr_num=lr_num+1;
pfilt=2.68; % threshold to select values
x=EqPIWfilt.Phosphateumolkg(EqPIWfilt.Phosphateumolkg<pfilt);
y=EqPIWfilt.Nitrateumolkg(EqPIWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % keep output values
lr_label(lr_num)={'N-P NEPIW aerobic'};

lr_num=lr_num+1; % next column in the LR table
pfilt=2.6; % threshold for this process
x=EqPIWfilt.Phosphateumolkg(EqPIWfilt.Phosphateumolkg>pfilt);
y=EqPIWfilt.Nitrateumolkg(EqPIWfilt.Phosphateumolkg>pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<21)=[]; % cut low values so the line isn't super long
yfit(yfit<21)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % save output into LR table
lr_label(lr_num)={'N-P NEPIW anaerobic'};

% 13CW
lr_num=lr_num+1;
pfilt=2.29; % threshold for this process
x=x13CWfilt.Phosphateumolkg(x13CWfilt.Phosphateumolkg<pfilt);
y=x13CWfilt.Nitrateumolkg(x13CWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % save LR output into table
lr_label(lr_num)={'N-P 13CW aerobic'};

lr_num=lr_num+1; % next column in LR table
pfilt=2.29; % threshold for this process
x=x13CWfilt.Phosphateumolkg(x13CWfilt.Phosphateumolkg>pfilt);
y=x13CWfilt.Nitrateumolkg(x13CWfilt.Phosphateumolkg>pfilt);
ind = x > 2.372 & y > 29.86; % removes outliers from fit, positive bump on end
x(ind)=[];
y(ind)=[];
ind = x > 2.3 & y < 23.8; % removes outliers from fit, little curl
x(ind)=[];
y(ind)=[];
[m,b,r,sm,sb] = lsqfitma(x,y);

xfit=sort(x);
yfit=m*sort(x)+b;
xfit(yfit<23)=[];
yfit(yfit<23)=[];

plot(xfit,yfit,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; % save these LR values in the table
lr_label(lr_num)={'N-P 13CW anaerobic'};

ylim([15 45]) % set plot range
hold off % done with adding things to this plot

xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('NO_3^{-}/{\mu}mol kg^{-1}')
% legend([p3, p2, p1, p4, p5],'13CW','NEPIW','AAIW','This paper','Bograd','Location','Northwest')
legend([p3, p2, p1],'13CW','NEPIW','AAIW','Location','Northwest')

% Other nutrients are no longer in use in this code and therefore are
% commented out

%% SiO4-PO4

% See comments on the N-P chunk for clarification on this code

figure(2)
i=1;

% plot WOA
p1=plot(x13CWfilt.Phosphateumolkg, x13CWfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i+1;

p2=plot(EqPIWfilt.Phosphateumolkg, EqPIWfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

p3=plot(AAIWfilt.Phosphateumolkg, AAIWfilt.Silicateumolkg,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

% % Plot basis
% p4=plot(basis_ETNP(4,:),basis_ETNP(6,:),'ro','MarkerFaceColor','r');
% text(basis_ETNP(4,:),basis_ETNP(6,:),wm,'VerticalAlignment','bottom','HorizontalAlignment','right')
% 
% p5=plot(basis_Bograd_gsw(4,:),basis_Bograd_gsw(6,:),'kd','MarkerFaceColor','k');
% text(basis_Bograd_gsw(4,:),basis_Bograd_gsw(6,:),wm_bograd,'VerticalAlignment','bottom','HorizontalAlignment','right')

% linear regressions
% 13CW
lr_num=lr_num+1;
pfilt=2.365;
x=x13CWfilt.Phosphateumolkg(x13CWfilt.Phosphateumolkg<pfilt);
y=x13CWfilt.Silicateumolkg(x13CWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Si-P 13CW'};

% NEPIW
lr_num=lr_num+1;
pfilt=2.65;
x=EqPIWfilt.Phosphateumolkg(EqPIWfilt.Phosphateumolkg<pfilt);
y=EqPIWfilt.Silicateumolkg(EqPIWfilt.Phosphateumolkg<pfilt);

% ind=x < 2.15 & y < 31;
% ind=x<2.1;
% x(ind)=[];
% y(ind)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Si-P NEPIW'};

% AAIW
lr_num=lr_num+1;
pfilt=20;
x=AAIWfilt.Phosphateumolkg(AAIWfilt.Phosphateumolkg<pfilt);
y=AAIWfilt.Silicateumolkg(AAIWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'Si-P AAICW'};

hold off

xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('SiO_4^{2-}/{\mu}mol kg^{-1}')
% legend([p1, p2, p3, p4, p5],'13CW','NEPIW','AAIW','This paper','Bograd','Location','Northwest')
legend([p3, p2, p1],'13CW','NEPIW','AAIW','Location','Northwest')

%% O2-PO4

figure(3)
i=1;

% WOD data
p1=plot(x13CWfilt.Phosphateumolkg, x13CWfilt.O2corr,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
hold on
i=i+1;

p2=plot(EqPIWfilt.Phosphateumolkg, EqPIWfilt.O2corr,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

p3=plot(AAIWfilt.Phosphateumolkg, AAIWfilt.O2corr,'Color',col(:,i),'Marker',string(mark(i)),'LineStyle','none');
i=i+1;

% basis
% p5=plot(basis_Bograd_gsw(4,:),basis_Bograd_gsw(3,:),'kd','MarkerFaceColor','k');
% text(basis_Bograd_gsw(4,:),basis_Bograd_gsw(3,:),wm_bograd,'VerticalAlignment','bottom','HorizontalAlignment','right')

% linear regressions
% 13CW
lr_num=lr_num+1;
pfilt=2.3;
x=x13CWfilt.Phosphateumolkg(x13CWfilt.Phosphateumolkg<pfilt);
y=x13CWfilt.O2corr(x13CWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P 13CW'};

lr_num=lr_num+1;
pfilt=2.24;
x=x13CWfilt.Phosphateumolkg(x13CWfilt.Phosphateumolkg>pfilt);
y=x13CWfilt.O2corr(x13CWfilt.Phosphateumolkg>pfilt);
ind=[x>=2.489 & y>=14.79];
x(ind)=[];
y(ind)=[];

[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P 13CW anaerobic'};

% NEPIW
lr_num=lr_num+1;
pfilt=2.655;
x=EqPIWfilt.Phosphateumolkg(EqPIWfilt.Phosphateumolkg<pfilt);
y=EqPIWfilt.O2corr(EqPIWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P NEPIW'};

lr_num=lr_num+1;
pfilt=2.57;
x=EqPIWfilt.Phosphateumolkg(EqPIWfilt.Phosphateumolkg>pfilt);
y=EqPIWfilt.O2corr(EqPIWfilt.Phosphateumolkg>pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P NEPIW anaerobic'};

% AAIW
lr_num=lr_num+1;
pfilt=3.158;
x=AAIWfilt.Phosphateumolkg(AAIWfilt.Phosphateumolkg<pfilt);
y=AAIWfilt.O2corr(AAIWfilt.Phosphateumolkg<pfilt);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P AAIW'};

% AAIW
lr_num=lr_num+1;
pfilt=3.0;
x=AAIWfilt.Phosphateumolkg(AAIWfilt.Phosphateumolkg>pfilt & AAIWfilt.O2corr < 8);
y=AAIWfilt.O2corr(AAIWfilt.Phosphateumolkg>pfilt & AAIWfilt.O2corr < 8);
[m,b,r,sm,sb] = lsqfitma(x,y);
plot(sort(x),m*sort(x)+b,'k')
lr_out(lr_num,2)=m; lr_out(lr_num,3)=sm; lr_out(lr_num,4)=b; lr_out(lr_num,5)=sb; 
lr_label(lr_num)={'O2-P AAIW anaerobic'};

% xline([2.288, 2.655, 3.158],'k--')
xline(2.288,'k--');
xline(2.655,'k--');
xline(3.158,'k--');

hold off
xlabel('PO_4^{3-}/{\mu}mol kg^{-1}')
ylabel('WOA corrected O_2/{\mu}mol kg^{-1}')
legend([p1, p2, p3],'13CW','NEPIW','AAIW','Location','Northeast')
% legend([p1, p2, p3, p5],'13CW','NEPIW','AAIW','Bograd','Location','Northeast')
% ylim([0 50])
ylim([0 140])

%% Process table

lr_out=num2cell(lr_out);
lr_out(:,1)=lr_label';
lr_out(1,:)={'','Slope','Unc slope','Intercept','Unc intercept'};
% save('lr_out','lr_out')

    