clc,clear,close all;
listOfSims={'data2';...
    'data1'};
for i=1:length(listOfSims)
    load(listOfSims{i});
    dataID = erase(listOfSims{i},"TimeSeries");
    processingSimData_Portfolio(TTT,YYY,dataID);
    close all;
end