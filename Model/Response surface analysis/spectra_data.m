clc,clear,close all;
load spectra_data.mat
temp = randperm(size(NIR,1));
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';
N = size(P_test,2);
[p_train, ps_input] = mapminmax(P_train,0,1);
p_test = mapminmax('apply',P_test,ps_input);
[t_train, ps_output] = mapminmax(T_train,0,1);
net = newff(p_train,t_train,9);
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;
net = train(net,p_train,t_train);
t_sim = sim(net,p_test);
T_sim = mapminmax('reverse',t_sim,ps_output);
error = abs(T_sim - T_test)./T_test;
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
result = [T_test' T_sim' error'];
figure
plot(1:N,T_test,'b',1:N,T_sim,'r')
xlabel('Prediction sample')
ylabel('Biomass')
string = {'forecast result';['R^2=' num2str(R2)]};
title(string)
