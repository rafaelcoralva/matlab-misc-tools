function [ ectopic_beats ] = premature_beat_detector( r_pos , fs)
% Function to detect premature heart beats from their r peak positions

%  The RR interval is calulcated based on the r_pos input. A moving median
%  RR interval is calculated and used to set a threshold zone of acceptable
%  (i.e. non-ectopic) RR intervals. If a beat's RR interval falls outside
%  this zone, it is considered ectopic.


% Detection of ectopic beats. A beat is considered ectopic if its RR interval is less than 85% of the median RR interval of the last 5 beats,
% or greater than 115% than this RR interval.

rr=diff(r_pos); % RR intervals (in samples).

ectopic_beats=[];

% For the first 10 beats we simply consider an aboslute HR threshold to remove any premature beats.

for i=1:10
    
    if rr(i)<fs*0.4
        
        ectopic_beats=[ectopic_beats i+1];
        rr(i)=NaN;
        
    end
    
end

for i=11:length(r_pos)-1
    
    median_rr=nanmedian(rr(i-8:i-1));
    
    if rr(i-1)<0.75*median_rr || rr(i-1)>1.25*median_rr || rr(i-1)<fs*0.35
        ectopic_beats=[ectopic_beats i-1];
        rr(i-1)=NaN; % Ectopic beats dont compute in the calculation of the median rr
    end
    
end

end

