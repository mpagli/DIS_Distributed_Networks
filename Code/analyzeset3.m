%Make plots for experiment 3
folder='results/set3/';
files=dir([folder '*.mat']);

categories = {};
L = [];
sigma_p = [];
sigma_d = [];

pN=[];
pK=[];
pR=[];
pF=[];
pt_max=[];
pnoise=[];
pd_min_factor=[];
pspring_relaxation_factor=[];
piteration=[];

pdata = {};

for i = 1:length(files)
    vec = sscanf(files(i).name,'result-%d-%d-%d-%f-%d-%f-%f-%f-%d.mat');
    N = vec(1);
    K = vec(2);
    R = vec(3);
    F = vec(4);
    t_max = vec(5);
    noise = vec(6);
    d_min_factor = vec(7);
    spring_relaxation_factor = vec(8);
    iteration = vec(9);
    
    %try
        data = load([folder, files(i).name]);
    %catch err
        
    %    fprintf('\nFailed for %s!\n', files(i).name);
    %    continue
    %end
    
    pN=[pN N];
    pK=[pK K];
    pR=[pR R];
    pF=[pF F];
    pt_max=[pt_max t_max];
    pnoise=[pnoise noise];
    pd_min_factor=[pd_min_factor d_min_factor];
    pspring_relaxation_factor=[pspring_relaxation_factor spring_relaxation_factor];
    piteration=[piteration iteration];
    pdata=[pdata data];
    
    catname = sprintf('%0.1f/%0.1f', noise, spring_relaxation_factor);
    categories = [categories catname];
    L = [L data.performance_L(end)];
    sigma_p = [sigma_p data.performance_sigma_p(end)];
    sigma_d = [sigma_d data.performance_sigma_d(end)];
    
    fprintf('%d\n',length(L));
end
figsizes=[0 0 15 6];
fig1 = figure();
set(fig1, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(L, categories);
ylabel('L');
print -depsc '../report/set3-L.eps';

fig2 = figure();
set(fig2, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_p, categories);
ylabel('\sigma_p^2');
print -depsc '../report/set3-sp.eps';

fig3 = figure();
set(fig3, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_d, categories);
ylabel('\sigma_d^2');
print -depsc '../report/set3-sd.eps';

