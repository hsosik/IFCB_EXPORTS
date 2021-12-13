load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018.mat')
load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018lists');

uw107ind = find(meta_data.ifcb==107 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uw125ind = find(meta_data.ifcb==125 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%Epoch 1- (2018,8,14,0) to (2018,8,23,9) 
%Epoch 2- (2018,8,23,9) to (2018,8,31,9)
%Epoch 3- (2018,8,31,9) to (2018,9,9,18)
e01 = datenum(2018,8,14);
e12 = datenum(2018,8,23,9,0,0);
e23 = datenum(2018,8,31,9,0,0);
e30 = datenum(2018,9,9,18,0,0);
eall = find(mdate >= e01 & mdate < e30);
e1 = find(mdate >= e01 & mdate < e12);
e2 = find(mdate >= e12 & mdate < e23);
e3 = find(mdate >= e23 & mdate < e30);


%%
bins = [logspace(0,log10(200))];

fi1 = strmatch('ESD', classFeaList_variables);
fi2 = strmatch('maxFeretDiameter', classFeaList_variables);

numfiles = length(filelist);
h = NaN(length(bins),numfiles);
hbv = h;
cc = [diatom_ind; dino_ind; nano_ind]; %added 10/23/21 to do groups
cc = [particle_ind]; %added 10/23/21 to do groups

for ii = 1:numfiles
    if ~rem(ii,20), disp([num2str(ii) ' of ' num2str(numfiles) ' ' filelist{ii}]), end
    if ~meta_data.skip(ii)
        temp = cat(1,classFeaList{ii,cc});
        if length(temp) >0
        bv = 4/3*pi*(temp(:,fi1)/2).^3;
        [h(:,ii),~,binnum] = histcounts(temp(:,fi1), [bins inf]);
        for tt = 1:length(bins)  %does this include the last one?
            hbv(tt,ii) = sum(bv(binnum==tt));
        end
        end
    end
end    


%%
%ind = uw107ind;
ind = uw125ind;
yl = [1e-1 1e3];
figure, set(gcf, 'position',[250 100 560*1.5 420*1.5])
subplot(2,2,1)
ii = intersect(e1,ind);
y = h(:,ii)./meta_data.ml_analyzed(ii)';
clear m s
m(:,1) = mean(y,2);
s(:,1) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,1),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 1')
ylabel('Concentration ( ml^{-1} \mum^{-1})')
subplot(2,2,2)
ii = intersect(e2,ind);
y = h(:,ii)./meta_data.ml_analyzed(ii)';
m(:,2) = mean(y,2);
s(:,2) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,2),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 2')
subplot(2,2,3)
ii = intersect(e3,ind);
y = h(:,ii)./meta_data.ml_analyzed(ii)';
m(:,3) = mean(y,2);
s(:,3) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,3),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 3')
ylabel('Concentration ( ml^{-1} \mum^{-1})')
xlabel('ESD (\mum)')
subplot(2,2,4)
t = loglog(bins,m, 'linewidth', 3);
ylabel('Concentration ( ml^{-1} \mum^{-1})')
ylim(yl)
xlim([1 200])
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
legend(t(1:3),'Epoch 1', 'Epoch 2', 'Epoch 3')
set(gca, 'yscale', 'linear')
ylim([.1 170])
xlim([4 30])
xlabel('ESD (\mum)')

%%
%ind = uw107ind;
ind = uw125ind;
yl = [1 1e6];
figure, set(gcf, 'position',[250 100 560*1.5 420*1.5])
subplot(2,2,1)
ii = intersect(e1,ind);
y = hbv(:,ii)./meta_data.ml_analyzed(ii)';
clear m s
m(:,1) = mean(y,2);
s(:,1) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,1),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 1')
ylabel('Biovolume conc (\mum^3 ml^{-1} \mum^{-1})')
subplot(2,2,2)
ii = intersect(e2,ind);
y = hbv(:,ii)./meta_data.ml_analyzed(ii)';
m(:,2) = mean(y,2);
s(:,2) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,2),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 2')
subplot(2,2,3)
ii = intersect(e3,ind);
y = hbv(:,ii)./meta_data.ml_analyzed(ii)';
m(:,3) = mean(y,2);
s(:,3) = std(y,0,2);
loglog(bins,y)
hold on
loglog(bins,m(:,3),'k', 'linewidth', 4')
ylim(yl)
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
title('Epoch 3')
ylabel('Biovolume conc (\mum^3 ml^{-1} \mum^{-1})')
xlabel('ESD (\mum)')
subplot(2,2,4)
t = loglog(bins,m, 'linewidth', 3);
ylabel('Biovolume conc (\mum^3 ml^{-1} \mum^{-1})')
ylim(yl)
xlim([1 200])
patch([1 1 5 5], [ylim fliplr(ylim)], [.4 .4 .4], 'facealpha', .2)
legend(t(1:3),'Epoch 1', 'Epoch 2', 'Epoch 3')
set(gca, 'yscale', 'linear')
ylim([100 2e4])
xlim([4 100])
xlabel('ESD (\mum)')





%%

figure
yyaxis left
plot(mdate(uw125ind), sum(h(gt5,uw125ind)./meta_data.ml_analyzed(uw125ind)'), '.-')
datetick keeplimits
grid
yyaxis right
plot(mdate(uw125ind), sum(h(gt5,uw125ind).*bins(gt5)')./sum(h(gt5,uw125ind)), '.-')

%%
dv = datevec(mdate(uw125ind));
t = find(dv(:,3)==3);
figure
surf(mdate(uw125ind(t)), bins, h(:,uw125ind(t))./meta_data.ml_analyzed(uw125ind(t))')
set(gca, 'yscale', 'log')
datetick keeplimits

%%
binc = (bins(2:end)+bins(1:end-1))/2;
bins2use = (binc>5 & binc<20);
hdiff = h./diff([bins inf])';
for tt = 676:length(filelist)
    %f = fit(log10(binc(bins2use))', log10(hdiff(bins2use, uw125ind(tt))),'poly1');
    X = log10(binc(bins2use))';
    Y = log10(hdiff(bins2use, tt));
    if isnan(Y)
        keyboard
    else
        if ~isempty(isinf(Y))
            ttt = find(isinf(Y));
            disp(10.^X(ttt))
            Y(ttt:end) = [];
            X(ttt:end) = [];
        end
        if length(Y)>2
            f = fit(X, Y,'poly1');
            slope(tt) = f.p1;
        end
    end
end

s = find(mdate(uw125ind)>datenum('8-13-2018') & mdate(uw125ind)<datenum('9-9-2018'));
for hr = 1:24
    tt = find(ToDlocal(s)<hr & ToDlocal(s)>hr-1);
    hrmed(hr) = median(slope(uw125ind(s(tt))));
    hrmean(hr) = mean(slope(uw125ind(s(tt))));
end
end
