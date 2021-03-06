clear all; clc;
%Known Values
L = 0.02; %Length of the domain (or rod in this case)
n = 5; %Number of Control Volumes(CVs) considered
dx = L/n; %Grid Spacing %Assumed Uniform Grid spacing

%Thermal Conductivity - Assumed constant throught the domain
k = 0.5;
ke = 0.5;
kw = 0.5;
q = 1000*1000; %Uniform Heat Generation

%Boundary Conditions
%Temperature - in degree celsius
TA = 100;
TB = 200;

%Calculated Constants
aw = kw/dx;
ae = ke/dx;

%Mesh Creation
x = dx/2:dx:L;
N = length(x);

%Matrices Creation
A = zeros(N,N); %Coefficient Matrix
b = zeros(N,1); %Constants' Matrix

%Algorithm
for i=1:N
    if x(i) == min(x) %For Boundary Point-1 (Left most Node)
        A(i,i) = ae + 2*(kw/dx);
        A(i,i+1) = -ae;
        b(i,1) = q*dx + 2*(kw/dx)*TA;
    elseif x(i) == max(x) %For Boundary Point-2 (Right most Node)
        A(i,i) = aw + 2*(ke/dx);
        A(i,i-1) = -aw;
        b(i,1) = q*dx + 2*(ke/dx)*TB;
    else %For all Internal Nodes
        A(i,i) = ae + aw;
        A(i,i+1) = -ae;
        A(i,i-1) = -aw;
        b(i,1) = q*dx;
    end
end

%Final results
A %Coefficient Tri-Diagonal Matrix
b %Constant Matrix
T = A\b %Displays the Temperature matrix after solving

%Plots and comparison between Analytical/Exact & Numerical solution curves
y = linspace(0,L,500);
Te = TA + y.*(((TB-TA)/L)+(q/(2*k)).*(L-y)); %Exact solution (Analytical) for Temperature
plot(x,T,'o-',y,Te,'r')
xlabel('Length')
ylabel('Variation in T')
legend('Numerical solution','Exact/Analytical Solution')
