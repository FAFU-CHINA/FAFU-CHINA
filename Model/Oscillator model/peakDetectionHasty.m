function [AllPeaks,AllPeaksLoc,Freq]=peakDetectionHasty(T,Y,peakThreshold)
    figflaglbl=1;
    TT = T;
    YY = Y;
    minpeakdist=1;
    AllPeaks = [];
    dim=size(Y);
    for n = 1:dim(2)
        dummydeletion = [];
        if length(YY(:,n)) < minpeakdist
            disp('No oscillations!');
            Freq(n) = 0;
        else
            clearvars pks locs
            [pks,locs]=findpeaks(YY(:,n),'MINPEAKHEIGHT',peakThreshold*median(YY(:,n)),'MINPEAKDISTANCE',minpeakdist);
            [pksmin,locsmin]=findpeaks(-YY(:,n),'MINPEAKHEIGHT',20*median(-YY(:,n)),'MINPEAKDISTANCE',minpeakdist);
            clearvars peak.mxloc peak.minleftloc peak.minrightloc
            if length(pks) > 1
                j=1;
                for i=1:length(pks)
                    [idleft,idright] = locate(locs(i), locsmin);
                    if idleft > 0 && idright >0
                        peak.mxloc(j)=locs(i);
                        peak.minleftloc(j)=locsmin(idleft);
                        peak.minrightloc(j)=locsmin(idright);
                        j=j+1;
                    end
                end
                AllPeaksORI{n}=peak.mxloc;
                deletion=[];
                for i=1:(length(peak.mxloc)-1)
                    if (peak.minleftloc(i) == peak.minleftloc(i+1)) && (peak.minrightloc(i) == peak.minrightloc(i+1))
                        if YY(peak.mxloc(i),n) > YY(peak.mxloc(i+1),n)
                            deletion=cat(1,deletion,i+1);
                        else
                            deletion=cat(1,deletion,i);
                        end
                    end
                    if (YY(peak.mxloc(i),n)-YY(peak.minleftloc(i),n)) <= 0.1*YY(peak.mxloc(i),n) || ...
                            (YY(peak.mxloc(i),n)-YY(peak.minrightloc(i),n)) <= 0.1*YY(peak.mxloc(i),n)
                        deletion=cat(1,deletion,i);
                    end

                end
                deletion=unique(deletion);
                peak.mxloc(deletion')=[];
                peak.minleftloc(deletion')=[];
                peak.minrightloc(deletion')=[];
                if length(peak.mxloc) >= 1
                    for i=1:length(peak.mxloc)
                        Amps{n}(i)= max([YY(peak.mxloc(i),n)-YY(peak.minleftloc(i),n)...
                            YY(peak.mxloc(i),n)-YY(peak.minrightloc(i),n)]);
                    end
                    meanAmps(n) = mean(Amps{n});
                    deletion=[];
                    for i=1:length(peak.mxloc)
                        if Amps{n}(i) < 0.30*meanAmps(n) 
                            deletion=cat(1,deletion,i);
                        end
                    end
                    deletion=unique(deletion);
                    dummydeletion=cat(1,dummydeletion,peak.mxloc(deletion')');
                    AllPeaksDel{n}=dummydeletion';
                    peak.mxloc(deletion')=[];
                    peak.minleftloc(deletion')=[];
                    peak.minrightloc(deletion')=[];
                    if figflaglbl == 1
                        figure
                        hold on
                        plot(TT(:),YY(:,n)) 
                        hold off
                    end
                    for i=1:length(peak.mxloc)
                        AllPeaks{n}(i) = TT(peak.mxloc(i));
                        AllPeaksLoc{n}(i) = peak.mxloc(i);
                    end
                        
                    L(n) = length(peak.mxloc);
                    Freq(n) = L(n)*3600.0 / (max(TT(:))-min(TT(:)));
                else
                    disp(sprintf('No pulses for specie %s\n',num2str(n)));
                    Freq(n) = 0;
                end
            else
                disp(sprintf('No pulses for specie %s\n',num2str(n)));
                Freq(n) = 0;
            end
        end
    end

    if figflaglbl == 1
        figure
        for n = 1 : dim(2)
            hold all
            plot(TT, YY(:,n), 'LineWidth', 1.5)
            if exist('AllPeaksORI','var')
            end
            if exist('AllPeaksDel','var')
            end
        end
   end

    output.Freq = Freq;

    meanfreq=mean(output.Freq);
    stdfreq=std(output.Freq);
    disp(sprintf('mean frequency: ''%d'' +- ''%d'' h^-1',meanfreq,stdfreq));
    disp(sprintf('mean period: ''%d'' min',1/meanfreq*60));

    if ~exist('AllPeaksLoc','var') 
        for n=1:dim(2)
            AllPeaksLoc{n}=0;
        end
    else
        for n=1:dim(2)
            if isempty(AllPeaksLoc{n})
                AllPeaksLoc{n}=0;
            end
        end
    end
    if ~exist('AllPeaks','var') 
        for n=1:dim(2)
            AllPeaks{n}=0;
        end
    else
        for n=1:dim(2)
            if isempty(AllPeaks{n})
                AllPeaks{n}=0;
            end
        end
    end
    if ~exist('Freq','var') 
        for n=1:dim(2)
            Freq(n)=0;
        end
    else
        for n=1:dim(2)
            if isempty(Freq(n))
                Freq(n)=0;
            end
        end
    end   
    
end

