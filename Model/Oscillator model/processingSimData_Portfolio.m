function processingSimData_Portfolio(TTT,YYY,dataID)
    wup = 100*3600;
    Tosc=TTT; 
    Tlen=TTT; 
    Yosc=YYY(:,1); 
    Ylen=YYY(:,3); 
    idxosc = find(Tosc>wup);
    TTosc = Tosc(idxosc);
    YYosc = Yosc(idxosc,:);
    idxlen = find(Tlen>wup);
    TTlen = Tlen(idxlen);
    YYlen = Ylen(idxlen);
    interval = max([mean(diff(TTosc))*2 mean(diff(TTlen))*2]);
    epsilon = interval;
    t1 = max([TTosc(1) TTlen(1)]); t2 = min([TTosc(end) TTlen(end)]);
    TT = [t1+epsilon:interval:t2-epsilon]';
    YYoscnew = interp1(TTosc,YYosc,TT);
    YYlennew = interp1(TTlen,YYlen,TT);
    YYosc = YYoscnew;
    YYlen = YYlennew;
    peakThreshold=3;
    [~,AllPeaksLocOSC,~]=peakDetectionHasty(TT,YYosc,peakThreshold);
    figure
    plot(TT/3600,YYosc(:,1));
    hold on
    hold off
    peakThreshold=0.5;
    [~,AllPeaksLocLEN,~]=peakDetectionHasty(TT,YYlen,peakThreshold);

    figure
    plot(TT/3600,YYlen(:,1));
    hold on
    hold off
    [~,AllMinsLocOSC,~]=minsDetectionHasty(TT,YYosc);
    Xtremesosc = zeros(1,length(TT));
    dimMAXSosc=size(AllPeaksLocOSC{1});
    dimMINSosc=size(AllMinsLocOSC{1});
    if dimMAXSosc >= 1
        Xtremesosc(AllPeaksLocOSC{1})=1;
    end
    if dimMINSosc >= 1
        Xtremesosc(AllMinsLocOSC{1})=-1;
    end
    figure
    hold on
    plot(TT,YYosc)
    kkmax=find(Xtremesosc==1);
    kkmin=find(Xtremesosc==-1);
    hold off
    dummyXtremesosc=Xtremesosc;
    kkMAX=[AllPeaksLocOSC{1}' ones(length(AllPeaksLocOSC{1}),1)];
    kkMIN=[AllMinsLocOSC{1}' ones(length(AllMinsLocOSC{1}),1).*(-1)];
    kkota=cat(1,kkMAX,kkMIN);
    [~,srtdId]=sort(kkota(:,1),1);
    srtdkkota=kkota(srtdId,:); 
    repXtremes=find(diff(srtdkkota(:,2))==0);
    while repXtremes
        l=1;
        if srtdkkota(repXtremes(l),2)==1 
            if YYosc(srtdkkota(repXtremes(l),1),1) > YYosc(srtdkkota(repXtremes(l),1)+1,1)
                srtdkkota(repXtremes(l),:) = []; 
            else
                srtdkkota(repXtremes(l)+1,:) = [];
            end
        else 
            if YYosc(srtdkkota(repXtremes(l),1),1) < YYosc(srtdkkota(repXtremes(l),1)+1,1)
                srtdkkota(repXtremes(l),:) = []; 
            else
                srtdkkota(repXtremes(l)+1,:) = [];
            end
        end
        repXtremes=find(diff(srtdkkota(:,2))==0);
    end
    finalXtremesosc = zeros(1,length(TT));
    lensrtdkkota=size(srtdkkota);
    for l=1:lensrtdkkota(1)
        finalXtremesosc(srtdkkota(l,1))=srtdkkota(l,2);
    end
    figure
    hold on
    plot(TT,YYosc)
    finalkkmax=find(finalXtremesosc==1);
    finalkkmin=find(finalXtremesosc==-1);
    hold off
    Xtremesosc=finalXtremesosc;
    Xtremeslen = zeros(1,length(TT));
    dimMAXSlen=size(AllPeaksLocLEN{1});
    if dimMAXSlen >= 1
        Xtremeslen(AllPeaksLocLEN{1})=1;
        Xtremeslen(AllPeaksLocLEN{1}+1)=-1;
    end
    if dimMAXSlen(2) >= 2 
        for i=1:dimMAXSlen(2)-1
            Lsegdata(i).len = YYlen(AllPeaksLocLEN{1}(i):AllPeaksLocLEN{1}(i+1));
            Lsegdata(i).osc = YYosc(AllPeaksLocLEN{1}(i):AllPeaksLocLEN{1}(i+1));
            Lsegdata(i).Oxtremes = Xtremesosc(AllPeaksLocLEN{1}(i):AllPeaksLocLEN{1}(i+1));
        end
        for i=1:dimMAXSlen(2)-1
            dummyLidx=2;
            Lsegdata(i).lenalignmin=dummyLidx;
            OSC.Loscavrgalmin(i).RIGHTvals=Lsegdata(i).osc(Lsegdata(i).lenalignmin:end);
            OSC.Loscavrgalmin(i).LEFTvals=Lsegdata(i).osc(Lsegdata(i).lenalignmin-1:-1:1);
            LEN.Llenavrgalmin(i).RIGHTvals=Lsegdata(i).len(Lsegdata(i).lenalignmin:end);
            LEN.Llenavrgalmin(i).LEFTvals=Lsegdata(i).len(Lsegdata(i).lenalignmin-1:-1:1);
            XTR.LOxtremealmin(i).RIGHTvals=Lsegdata(i).Oxtremes(Lsegdata(i).lenalignmin:end);
            XTR.LOxtremealmin(i).LEFTvals=Lsegdata(i).Oxtremes(Lsegdata(i).lenalignmin-1:-1:1);
        end
        OSC.Roscdummy=[];
        OSC.Loscdummy=[];
        for i=1:dimMAXSlen(2)-1
            OSC.Roscdim=size(OSC.Loscavrgalmin(i).RIGHTvals');
            OSC.Roscdummy=cat(1,OSC.Roscdummy,OSC.Roscdim(2));
            OSC.Loscdim=size(OSC.Loscavrgalmin(i).LEFTvals');
            OSC.Loscdummy=cat(1,OSC.Loscdummy,OSC.Loscdim(2));
        end
    end
    cc=jet(dimMAXSlen(2)-1); 
    figname2=sprintf('%s_PTAcellDivisionrawdata',dataID);
    figtitle1='Gene Oscillator';
    h2=figure(2);
    subplot(2, 1, 1)
    hold on
    for i=1:dimMAXSlen(2)-1
        plot([fliplr(-1*[1:length(OSC.Loscavrgalmin(i).LEFTvals)]) [0:length(OSC.Loscavrgalmin(i).RIGHTvals)-1]]*interval/60,[OSC.Loscavrgalmin(i).LEFTvals(end:-1:1)' OSC.Loscavrgalmin(i).RIGHTvals'],'color',cc(i,:),'LineStyle',':','LineWidth',2)
        segmentXTREMES=[fliplr(XTR.LOxtremealmin(i).LEFTvals) XTR.LOxtremealmin(i).RIGHTvals];
        kkidxMXS=find(segmentXTREMES==1);
        kksegmentTIME=[fliplr(-1*[1:length(OSC.Loscavrgalmin(i).LEFTvals)]) [0:length(OSC.Loscavrgalmin(i).RIGHTvals)-1]]*interval/60;
        kksegmentDATA=[OSC.Loscavrgalmin(i).LEFTvals(end:-1:1)' OSC.Loscavrgalmin(i).RIGHTvals'];
    end
    title(figtitle1,'fontsize',12)
    set(gca,'fontsize',10)

    subplot(2,1,2)
    figtitle2='Length (a.u.)';
    hold on
    for i=1:dimMAXSlen(2)-1
        plot([fliplr(-1*[1:length(LEN.Llenavrgalmin(i).LEFTvals)]) [0:length(LEN.Llenavrgalmin(i).RIGHTvals)-1]]*interval/60,[LEN.Llenavrgalmin(i).LEFTvals(end:-1:1)' LEN.Llenavrgalmin(i).RIGHTvals'],'color',cc(i,:),'LineStyle',':','LineWidth',2)
    end
    xlabel('"Time/min','fontsize',16);
    title(figtitle2,'fontsize',12)
    set(gca,'fontsize',10)
    ha2 = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off',...
        'Visible','off','Units','normalized', 'clipping' , 'off');
    colormap(jet);
    ch = colorbar;
    yl=get(ch,'ylim');
    zl=get(gca,'zlim');
    set(ch,'ytick',yl);
    set(ch,'yticklabel',{'1st';strcat(num2str(dimMAXSlen(2)-1),'th')});

    xch=get(ch,'Position');
    xch(2)=0.03;
    xch(2)=0.03;
    xch(4)=0.9;
    set(ch,'Position',xch)
    storeLoscMAXs=[];
    storeLoscMAXsNormt=[];
    noMAXscounter=0;
    for i=1:dimMAXSlen(2)-1
        segmentDATA=[fliplr(OSC.Loscavrgalmin(i).LEFTvals') OSC.Loscavrgalmin(i).RIGHTvals'];
        segmentTIME=[fliplr(-1*[1:length(OSC.Loscavrgalmin(i).LEFTvals)]) [0:length(OSC.Loscavrgalmin(i).RIGHTvals)-1]]*interval/60;
        newsegmentTIME=segmentTIME(2:end);
        segmentTIMENormt=newsegmentTIME/max(newsegmentTIME);
        segmentXTREMES=[fliplr(XTR.LOxtremealmin(i).LEFTvals) XTR.LOxtremealmin(i).RIGHTvals];
        newsegmentXTREMES=segmentXTREMES(2:end);
        locsSEG=find(newsegmentXTREMES==1);
        if ~isempty(locsSEG)
            for k=1:length(locsSEG)
                storeLoscMAXsNormt=cat(1,storeLoscMAXsNormt,segmentTIMENormt(locsSEG(k)));
            end
        else
            noMAXscounter=noMAXscounter+1;
        end
    end
    Roscmax=max(OSC.Roscdummy);
    Loscmax=max(OSC.Loscdummy);
    newbin=0:0.08:1+0.08;
    Losc_nNormt=histc(storeLoscMAXsNormt,newbin);
    figname1000012=sprintf('%s_PTAcellDivision_OscMAXShistogramNormt',dataID);
    h1000012=figure(1000012);
    figtitle1000012 = sprintf('%s PTA by lenght, distr. of all GENE OSC MAX, N=%s',dataID,num2str(sum(Losc_nNormt)));
    bar(newbin,Losc_nNormt/sum(Losc_nNormt),'histc')
    title(figtitle1000012,'fontsize',12)
    xlabel('Norm. time (a.u.)','fontsize',12);
    set(gca,'fontsize',12)
    [~,minindex] = locate(0.5,newbin);
    if newbin(end) > 1
        kkota=newbin(1:end-1)-newbin(minindex);
        finalLoscNormt_n=Losc_nNormt(1:end-1);
    else
        kkota=newbin-newbin(minindex);
        finalLoscNormt_n=Losc_nNormt;
    end
    kk=find(kkota<0);
    kk3=kkota>=0;
    kkota3=kkota(kk3);
    kkota2=kkota(kk)+max(abs(kkota(kk)))+(kkota3(2)-kkota3(1))*length(kkota3);
    kkotaALL=[kkota2 kkota3];

    figname1000013=sprintf('%s_PTAcellDivision_OscMAXShistogramNormt_rearranged',dataID);
    h1000013=figure(1000013);
    figtitle1000013 = sprintf('%s PTA by Lenght, distr. of all GENE OSC MAX, N=%s, re-arranged',dataID,num2str(sum(finalLoscNormt_n)));
    bar(kkotaALL,finalLoscNormt_n/sum(finalLoscNormt_n),'histc');
    title(figtitle1000013,'fontsize',12)
    ylim([0 0.35]);
    xlabel('Norm. Time (a.u.)','fontsize',12);
    set(gca,'fontsize',12)
    storeOSCperiods=[];
    oscmaxsok=find(Xtremesosc==1);
    dimMAXSosc=size(oscmaxsok);
    if dimMAXSosc(2) >= 2
        for i=1:dimMAXSosc(2)-1
            dummyperiod=(TT(oscmaxsok(i+1))-TT(oscmaxsok(i)))/60;
            storeOSCperiods=cat(1,storeOSCperiods,dummyperiod);
        end
    end
    bins3=min(storeOSCperiods):5:max(storeOSCperiods);
    OSCperiods_n=histc(storeOSCperiods,bins3);

    figname100003=sprintf('%s_OSCperiodshistogram',dataID);
    h100003=figure(100003);
    figtitle100003 = sprintf('OSC periods distribution, N=%s',num2str(sum(OSCperiods_n)));
    bar(bins3,OSCperiods_n/sum(OSCperiods_n),'histc')
    title(figtitle100003,'fontsize',12)
    xlabel('Periods (min)','fontsize',12);
    set(gca,'fontsize',12)

    disp('   ');
    disp(dataID);
    disp('   ');
    OSCdevResults=sprintf('OSC period: mean +- std = %s +- %s (in min)',num2str(mean(storeOSCperiods)), num2str(std(storeOSCperiods)));
    disp(OSCdevResults);
    disp('   ');
    storeLENperiods=[];
    if dimMAXSlen(2) >= 2
        for i=1:dimMAXSlen(2)-1
            dummyperiod=(TT(AllPeaksLocLEN{1}(i+1))-TT(AllPeaksLocLEN{1}(i)))/60;
            storeLENperiods=cat(1,storeLENperiods,dummyperiod);
        end
    end
    bins4=min(storeLENperiods):5:max(storeLENperiods);
    LENperiods_n=histc(storeLENperiods,bins4);
    figname100004=sprintf('%s_LENperiodshistogram',dataID);
    h100004=figure(100004);
    figtitle100004 = sprintf('LEN periods distribution, N=%s',num2str(sum(LENperiods_n)));
    bar(bins4,LENperiods_n/sum(LENperiods_n),'histc')
    xlim([20 220])
    title(figtitle100004,'fontsize',12)
    xlabel('Periods (min)','fontsize',12);
    set(gca,'fontsize',12)

    LENdevResults=sprintf('LEN period: mean +- std = %s +- %s (in min)',num2str(mean(storeLENperiods)), num2str(std(storeLENperiods)));
    disp(LENdevResults);
    disp('   ');

end
