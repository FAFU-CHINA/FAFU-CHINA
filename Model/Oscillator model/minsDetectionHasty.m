function [AllMins,AllMinsLoc,Freq]=minsDetectionHasty(T,Y)
    figflaglbl=0;% Set this to 1 if you want to plot debugging figures, 0 otherwise
    TT = T;
    YY = Y;
    minpeakdist=10; 
    AllPeaks = [];
    AllMins = [];
    dim=size(Y);
    for n = 1:dim(2)
        dummydeletion = [];
        if length(YY(:,n)) < minpeakdist
            disp('No oscillations!');
            Freq(n) = 0;
        else
            clearvars pksmin locsmin pks locs
            [pks,locs]=findpeaks(YY(:,n),'MINPEAKHEIGHT',median(YY(:,n)),'MINPEAKDISTANCE',minpeakdist);
            [pksmin,locsmin]=findpeaks(-YY(:,n),'MINPEAKHEIGHT',20*median(-YY(:,n)),'MINPEAKDISTANCE',minpeakdist);
            if figflaglbl == 1
                figure
                hold on
                plot(TT(:),YY(:,n))
                scatter(TT(locsmin),YY(locsmin,n),'filled','r')
                scatter(TT(locs),YY(locs,n),'filled','g')
                hold off
            end
        
            clearvars mins.mxloc mins.minleftloc peak.minrightloc
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
                        if Amps{n}(i) < 0.10*meanAmps(n) 
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
                        scatter(TT(peak.mxloc),YY(peak.mxloc,n),'filled','r')
                        hold off
                    end
                    for i=1:length(peak.mxloc)
                        AllPeaks{n}(i) = TT(peak.mxloc(i));
                        AllPeaksLoc{n}(i) = peak.mxloc(i);
                    end
                    L(n) = length(peak.mxloc);
                    Freq(n) = L(n)*3600.0 / (max(TT(:))-min(TT(:)));% In h^-1
                else
                    disp(sprintf('No pulses for specie %s\n',num2str(n)));
                    Freq(n) = 0;
                end
            else
                disp(sprintf('No pulses for specie %s\n',num2str(n)));
                Freq(n) = 0;
            end
            if length(pksmin) > 1
               j=1;
               for i=1:length(pksmin)
                   [idleftmin,idrightmin] = locate(locsmin(i), locs);
                   if idleftmin > 0 && idrightmin >0
                       peak.minloc(j)=locsmin(i);
                       peak.maxleftloc(j)=locs(idleftmin);
                       peak.maxrightloc(j)=locs(idrightmin);
                       j=j+1;
                   end
               end
               AllMinsORI{n}=peak.minloc;
               deletion=[];
               for i=1:(length(peak.minloc)-1)
                   if (peak.maxleftloc(i) == peak.maxleftloc(i+1)) && (peak.maxrightloc(i) == peak.maxrightloc(i+1))
                        if YY(peak.minloc(i),n) < YY(peak.minloc(i+1),n)
                            disp('deleting element of the peak structure')
                            i+1;
                            deletion=cat(1,deletion,i+1);
                        else
                            disp('deleting element of the peak structure')
                            i;
                            deletion=cat(1,deletion,i);
                        end
                   end
               end
                deletion=unique(deletion);
                peak.minloc(deletion')=[];
                peak.maxleftloc(deletion')=[];
                peak.maxrightloc(deletion')=[];
               for i=1:length(peak.minloc)
                   AllMins{n}(i) = TT(peak.minloc(i));
                   AllMinsLoc{n}(i) = peak.minloc(i);
               end
               
            end
            
          end
            
        end
    
    if figflaglbl == 1
            n=1;
            figure
            hold on
            plot(TT(:),YY(:,n))
            scatter(TT(locsmin),YY(locsmin,n),'filled','k')
            scatter(TT(AllPeaksLoc{n}),YY(AllPeaksLoc{n},n),'filled','k')
            hold off
            figure
            hold on
            plot(TT(:),YY(:,n))
            scatter(TT(AllMinsLoc{n}),YY(AllMinsLoc{n},n),'filled','k')
            scatter(TT(AllPeaksLoc{n}),YY(AllPeaksLoc{n},n),'filled','k')
            hold off
    end

end

