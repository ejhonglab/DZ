%temp=zeros(126,6);
global Fr
global trial_duration
global dF

trials = 3;                      %%% # of trials in recording %%%
Fr = 5.5;                         %%% Frame Rate %%%


%%%divide up recording into individual trials

intensity=temp(:,3);
trial_duration=floor(numel(temp(:,1))/trials);  
Stim_1=intensity(1:trial_duration);
Stim_2=intensity(trial_duration+1:2*trial_duration);
if trials==3
    Stim_3=intensity(2*trial_duration+1:3*trial_duration);
else  
    Stim_3 = zeros(trial_duration,1);
end


%%%calculate dF/F for individual trials

deltaF_calc_function(Stim_1)
dF1=dF;
deltaF_calc_function(Stim_2)
dF2=dF;
if trials==3
    deltaF_calc_function(Stim_3)
    dF3=dF;
else
    dF3=zeros(3);
end


%%%calculate average dF/F and SEM

if trials==3
    dF_AVG = (dF1+dF2+dF3)./3;
    catdF = cat(2,dF1,dF2,dF3)';
    dF_SEM = std(catdF)./sqrt(3);
    dF_SEM = dF_SEM';
else
    dF_AVG = (dF1+dF2)./2;
    catdF = cat(2,dF1,dF2)';
    dF_STD = std(catdF)';
end



%if trials==3
%    Stim_AVG = (Stim_1+Stim_2+Stim_3)./3;
%else
%    Stim_AVG = (Stim_1+Stim_2)./2;
%end

%StimOnset = Fr*10;                       %%%Stimulus comes on at 10 seconds in each trial

%F0=mean(Stim_AVG(StimOnset-11:StimOnset-1));          %%%take as baseline avg intensity 10 frames before stimulation
%F0_vector = F0*ones(trial_duration,1);

%dF = (Stim_AVG - F0_vector)./F0;


save('dF_AVG','dF_AVG'), save('dF1','dF1'),save('dF2','dF2'),save('dF3','dF3') , save('fiji_spreadsheet','temp')
if trials==3
    save('dF3','dF3'),save('dF_SEM','dF_SEM')
else
    clear dF3 Stim_3, save('dF_STD','dF_STD')
end

%save('Stim_1','Stim_1'), save('Stim_2','Stim_2'), save('Stim_AVG') , save('dF','dF') , save('fiji_spreadsheet','temp')
%if trials==3
%    save('Stim_3','Stim_3');
%else)
%    clear Stim_3;
%end


%%%plot dF_AVG +- SEM or STD

t=1:trial_duration;
t;
time=Fr.*t;

%plot(t,dF)
%plot(t,dF_AVG)
if trials==3
patch([t fliplr(t)],[dF_AVG'+dF_SEM' fliplr(dF_AVG'-dF_SEM')],[0.9 0.9 1]), hold on, plot(dF_AVG','Color','b','LineWidth',0.5)
else
patch([t fliplr(t)],[dF_AVG'+dF_STD' fliplr(dF_AVG'-dF_STD')],[0.9 0.9 1]), hold on, plot(dF_AVG','Color','b','LineWidth',0.5)
end
%figure;
%plot(t,Stim_1)
%figure;
%plot(t,Stim_2)
%figure;
%plot(t,Stim_3)
