function [fitresult, gof] = createFit(time, OD)
[xData, yData] = prepareCurveData(time, OD);
% Set up fittype and options.
ft = 'pchipinterp';
 
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
 
% Plot fit with data.
%figure( 'Name', 'Cavefit' );
h = plot( fitresult, xData, yData );
legend( h, 'Time/OD', 'Cavefit', 'Location', 'NorthEast' );
% Label axes
grid on
grid minor
end