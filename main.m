% Developed in MATLAB R2021b
% Source codes demo version 1.0
% _____________________________________________________
%  Author, inventor and programmer of EGGO: Long Chen,
%  Email: chenlong@zjnu.edu.cn
%  Co-authors:Zishang Qiu, Ying Wu, Zhenzhou Tang,
% _____________________________________________________
% Please refer to the main paper:
% Optimizing k-coverage in Energy-saving Wireless Sensor Networks Based on the Elite Global Growth Optimizer
% Long Chen, Zishang Qiu, Ying Wu, Zhenzhou Tang
% Expert Systems with Applications, DOI: 
%        AND
% Qingke Zhang, Hao Gao, Zhi-Hui Zhan, Junqing Li, Huaxiang Zhang 
% Growth Optimizer: A powerful metaheuristic algorithm for solving continuous and discrete global optimization problems
% Knowledge-Based Systems, DOI: https://doi.org/10.1016/j.knosys.2022.110206
% _____________________________________________________
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc

N = 30; % Number of search agents

Function_name = 'F1'; % Name of the test function 

Max_FE = 15000; % Maximum number of iterations

% Load details of the selected benchmark function
[lb,ub,dim,fobj] = Get_Functions_details(Function_name);

if size(lb,1) ~=dim || size(ub,1) ~=dim
    lb = ones(1,dim).*lb;
    ub = ones(1,dim).*ub;
end

[Best_score,Best_pos,Convergence_FE] = EGGO(N,Max_FE,lb,ub,dim,fobj);

%Draw objective space
figure,
hold on
semilogy(Convergence_FE,'Color','b','LineWidth',1);
title('Convergence curve')
xlabel('FEs');
ylabel('Best fitness obtained so far');
axis tight
grid off
box on
legend('EGGO')

display(['The best location of EGGO is: ', num2str(Best_pos)]);
display(['The best fitness of EGGO is: ', num2str(Best_score)]);

        



