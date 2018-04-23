function [dF] = dF_calc_function(Stim)
%   calculates dF/F from raw flourescence trace

global Fr
global trial_duration
global dF
StimOnset = Fr*10;                       %%%Stimulus comes on at 10 seconds in each trial

F0=mean(Stim(StimOnset-11:StimOnset-1));          %%%take as baseline avg intensity 10 frames before stimulation
F0_vector = F0*ones(trial_duration,1);

dF = (Stim - F0_vector)./F0;


end

