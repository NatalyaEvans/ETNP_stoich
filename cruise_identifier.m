clear

% load('WOD_data_C_filter')
load('WOD_clean_filter');

alldata=vertcat(x13CW_Cfilt,EqPIW_Cfilt, AAIW_Cfilt);

cruises=unique(alldata.orig_id);
cruises(isundefined(cruises))=[];

o2thresh=5;
k=1;

for i=1:length(cruises)
   temp=alldata(alldata.orig_id==cruises(i),:);
   if sum(temp.Oxygenumolkg<o2thresh)>0
       cruises2(k)=cruises(i);
       vals(k)=sum(temp.Oxygenumolkg>=o2thresh);
       k=k+1;
   end
end



out=[string(cruises2'),vals'];
[~,inds]=sort(vals,'descend');
out=out(inds,:);

out=vertcat(["Cruise","Number of samples"],out)

%%

figure(1)
NO3=[20:1:40];
plot(NO3,100*(NO3./(NO3+2)),'k--')
hold on
plot(NO3,100*(NO3./(NO3+3)),'b-')
plot(NO3,100*(NO3./(NO3+4)),'r.-')
hold off
xlabel('NO_3')
ylabel('NO3/(NO3+NO2)')
legend('NO2=2','NO2=3','NO2=4','Location','Southeast')
ytickformat('percentage')



