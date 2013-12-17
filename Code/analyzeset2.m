folder='results/set2/'

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
    
    try
        data = load([folder, files(i).name]);
    catch err
        fprintf('\nFailed for %s!\n', files(i).name);
        continue
    end
    
    pN=[pN N];
    pK=[pK K];
    pR=[pR R];
    pF=[pF F];
    pt_max=[pt_max t_max];
    pnoise=[pnoise noise];
    pd_min_factor=[pd_min_factor d_min_factor];
    pspring_relaxation_factor=[pspring_relaxation_factor spring_relaxation_factor];
    piteration=[piteration iteration];
    %pdata=[pdata data];
    
    catname = sprintf('%0.1f', F);
    %catname = sprintf('%0.1f/%0.1f', F, spring_relaxation_factor);
    categories = [categories catname];
    L = [L data.performance_L(end)];
    sigma_p = [sigma_p data.performance_sigma_p(end)];
    sigma_d = [sigma_d data.performance_sigma_d(end)];
    
    fprintf('%d ',length(L));
end


figsizes=[0 0 15 6];
fig1 = figure();
set(fig1, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(L(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
%boxplot(L, categories);
xlabel('F');
ylabel('L');
print -depsc '../report/set2-L-nosrf.eps';

fig2 = figure();
set(fig2, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_p(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
%boxplot(sigma_p, categories);
xlabel('F');
ylabel('\sigma_p^2');
print -depsc '../report/set2-sp-nosrf.eps';
ylim([-0.01 0.35]);
print -depsc '../report/set2-sp-nosrf-ylim.eps';

fig3 = figure();
set(fig3, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_d(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
%boxplot(sigma_d, categories);
xlabel('F');
ylabel('\sigma_d^2');
print -depsc '../report/set2-sd-nosrf.eps';
ylim([-0.1 4]);
print -depsc '../report/set2-sd-nosrf-ylim.eps';
return

figure;    
boxplot(L(find(L>3)), categories(find(L>3)));
figure;
boxplot(L, categories);
figure;
boxplot(sigma_p(find(L>3)), categories(find(L>3)));
ylim([-1,100])
figure;
boxplot(sigma_d(find(L>3)), categories(find(L>3)));
ylim([-1,100])
