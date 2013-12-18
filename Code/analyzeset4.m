%Make plots for experiment 4
folder='results/set1/';
files=dir([folder 'result-20-11-20-0.20-100-0.10-1.00-*.mat']);

categories = {};
L = [];
sigma_p = [];
sigma_d = [];

at_list = 1:100;

pN=[];
pK=[];
pR=[];
pF=[];
pt_max=[];
pnoise=[];
pd_min_factor=[];
pspring_relaxation_factor=[];
piteration=[];
pat = [];

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
    
    for at = at_list
        pN=[pN N];
        pK=[pK K];
        pR=[pR R];
        pF=[pF F];
        pat=[pat, at];
        pt_max=[pt_max t_max];
        pnoise=[pnoise noise];
        pd_min_factor=[pd_min_factor d_min_factor];
        pspring_relaxation_factor=[pspring_relaxation_factor spring_relaxation_factor];
        piteration=[piteration iteration];
        %pdata=[pdata data];
        
        catname = sprintf('%d', at, spring_relaxation_factor);
        categories = [categories catname];
        L = [L data.performance_L(at)];
        sigma_p = [sigma_p data.performance_sigma_p(at)];
        sigma_d = [sigma_d data.performance_sigma_d(at)];
    end
    
    fprintf('%d\n',length(L));
end


figsizes=[0 0 15 6];
fig1 = figure();
set(fig1, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(L(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
xlabel('t');
ylabel('L');
set(gca,'xtickmode','auto','xticklabelmode','auto')
print -depsc '../report/set4-L-nosrf.eps';


figsizes=[0 0 15 6];
fig2 = figure();
set(fig2, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_p(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
xlabel('t');
ylabel('\sigma_p^2');
set(gca,'xtickmode','auto','xticklabelmode','auto')
ylim([-0.1 5])
print -depsc '../report/set4-sp-nosrf.eps';

figsizes=[0 0 15 6];
fig3 = figure();
set(fig3, 'PaperUnits', 'centimeters', 'PaperPosition', figsizes);
boxplot(sigma_d(find(pspring_relaxation_factor==0)), categories(find(pspring_relaxation_factor==0)));
xlabel('t');
ylabel('\sigma_d^2');
set(gca,'xtickmode','auto','xticklabelmode','auto')
ylim([-1 100])
print -depsc '../report/set4-sd-nosrf.eps';
