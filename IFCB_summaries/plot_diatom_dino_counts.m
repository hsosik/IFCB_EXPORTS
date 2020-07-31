%load \\sosiknas1\IFCB_products\EXPORTS\summary\summary_count_allHDF2018 %from count_summary_allHDF2.m
load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018.mat')

notes = {'CNN model: Jan10_8020_seeded_iv3_pt_nn_xyto_min20';...
    'results: summary_count_allHDF2018 from count_summary_allHFD2.m, April 2020';...
    'diatom grouping excludes catchall "Bacillariophyceae" class heavily contaminated with what might be tiny dinos';...
    'diatom grouping excludes due to absence in dataset: Licmophora, Nanoneis';...
    'diatom grouping excludes due to predominance of false positives: Thalassiosira';...
    'diatom grouping excludes: Thalassiosira_TAG_external_detritus'};

%group_table = readtable('\\sosiknas1\IFCB_products\MVCO\train_May2019_jmf\config\IFCB_classlist_type.csv');
group_table = readtable('\\sosiknas1\training_sets\IFCB\config\IFCB_classlist_type.csv');
[~,ia,ib] = intersect(group_table.CNN_classlist, class2use);
diatom_ind = ib(find(group_table.Diatom(ia)));
%diatom_ind = setdiff(diatom_ind, strmatch('Bacillariophyceae', class2use));
[~,exclude_ind] = intersect(class2use, {'Bacillariophyceae' 'Licmophora' 'Nanoneis' 'Thalassiosira' 'Thalassiosira_TAG_external_detritus'});
diatom_ind = setdiff(diatom_ind, exclude_ind);
dino_ind = ib(find(group_table.Dinoflagellate(ia)));
% fudge until fixed in dashboard for a couple of crazy high volumes
ii = find(meta_data.ml_analyzed > 5);
meta_data.ml_analyzed(ii) = IFCB_volume_analyzed(strcat('https://ifcb-data.whoi.edu/EXPORTS/', meta_data.pid(ii), '.hdr'));
%metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 15));
%m = [ 3.1338 5.1815 5.5791 3.7348];
%meta_data.ml_analyzed(ii) = m;

survey_ind = find(meta_data.ifcb == 125 & ~meta_data.skip & strcmp('underway', meta_data.sample_type));
process_ind = find(meta_data.ifcb == 107 & ~meta_data.skip & strcmp('underway', meta_data.sample_type));


%%
%section2
figure %1
plot(mdate(survey_ind), sum(classcount(survey_ind,diatom_ind),2)./meta_data.ml_analyzed(survey_ind), '.-')
hold on
plot(mdate(survey_ind), sum(classcount(survey_ind,dino_ind),2)./meta_data.ml_analyzed(survey_ind), '.-')
datetick, ylim([0 300])

figure 
plot(mdate(survey_ind)-datenum('1-0-2018'), sum(classcount(survey_ind,diatom_ind),2)./meta_data.ml_analyzed(survey_ind), '.-')
hold on
plot(mdate(survey_ind)-datenum('1-0-2018'), sum(classcount(survey_ind,dino_ind),2)./meta_data.ml_analyzed(survey_ind), '.-')
ylim([0 300])

figure
plot(mdate(survey_ind), sum(classcount(survey_ind,dino_ind),2)./sum(classcount(survey_ind,diatom_ind),2), '.-')
datetick

[temp, ss] = sort(sum(classcount(survey_ind,diatom_ind)), 'descend')
[class2use(diatom_ind(ss)) cellstr(num2str(temp'))]
figure %2
plot(mdate(survey_ind), classcount(survey_ind,diatom_ind(ss(1:10)))./repmat(meta_data.ml_analyzed(survey_ind),1,10), '.-', 'linewidth',2)
legend(class2use(diatom_ind(ss(1:10))))

for cc = 1:length(filelist), dinocount(cc) = length(cell2mat(classESDlist{cc}(dino_ind)')); dinocount_gt10(cc) = sum((cell2mat(classESDlist{cc}(dino_ind)')>=10)); end
for cc = 1:length(filelist), diatomcount(cc) = length(cell2mat(classESDlist{cc}(diatom_ind)')); diatomcount_gt10(cc) = sum((cell2mat(classESDlist{cc}(diatom_ind)')>=10)); end

IFCB125_uw = meta_data(survey_ind,:);
%IFCB125_uw.diatom_roi_per_ml = sum(classcount(survey_ind,diatom_ind),2)./meta_data.ml_analyzed(survey_ind);
%IFCB125_uw.dinoflagellate_roi_per_ml = sum(classcount(survey_ind,dino_ind),2)./meta_data.ml_analyzed(survey_ind);
IFCB125_uw.diatom_roi_per_ml = diatomcount(survey_ind)'./meta_data.ml_analyzed(survey_ind);
IFCB125_uw.diatomgt10_roi_per_ml = diatomcount_gt10(survey_ind)'./meta_data.ml_analyzed(survey_ind);
IFCB125_uw.dinoflagellate_roi_per_ml = dinocount(survey_ind)'./meta_data.ml_analyzed(survey_ind);
IFCB125_uw.dinoflagellategt10_roi_per_ml = dinocount_gt10(survey_ind)'./meta_data.ml_analyzed(survey_ind);
IFCB107_uw = meta_data(process_ind,:);
%IFCB107_uw.diatom_roi_per_ml = sum(classcount(process_ind,diatom_ind),2)./meta_data.ml_analyzed(process_ind);
%IFCB107_uw.dinoflagellate_roi_per_ml = sum(classcount(process_ind,dino_ind),2)./meta_data.ml_analyzed(process_ind);
IFCB107_uw.diatom_roi_per_ml = diatomcount(process_ind)'./meta_data.ml_analyzed(process_ind);
IFCB107_uw.diatomgt10_roi_per_ml = diatomcount_gt10(process_ind)'./meta_data.ml_analyzed(process_ind);
IFCB107_uw.dinoflagellate_roi_per_ml = dinocount(process_ind)'./meta_data.ml_analyzed(process_ind);
IFCB107_uw.dinoflagellategt10_roi_per_ml = dinocount_gt10(process_ind)'./meta_data.ml_analyzed(process_ind);

%save('\\sosiknas1\IFCB_products\EXPORTS\summary\EXPORTS_IFCB125_uw_dino_diatomB', 'IFCB125_uw', 'notes')

alim = [-146 -144 49.3 51.3];
figure, set(gcf, 'position', [90 300 1400 300])
%scatter(meta_data.longitude(survey_ind), meta_data.latitude(survey_ind), 15, sum(classcount_above_adhocthresh(survey_ind,dino_ind),2)./meta_data.ml_analyzed(survey_ind), 'filled')
subplot(1,3,1)
scatter(IFCB125_uw.longitude, IFCB125_uw.latitude, 20, IFCB125_uw.dinoflagellate_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 150])
title('Dinoflagellates (ml^{-1})')
set(gca, 'box', 'on')
subplot(1,3,2)
scatter(IFCB125_uw.longitude, IFCB125_uw.latitude, 20, IFCB125_uw.diatom_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 150])
title('Diatoms (ml^{-1})')
set(gca, 'box', 'on')
subplot(1,3,3)
scatter(IFCB125_uw.longitude, IFCB125_uw.latitude, 20, IFCB125_uw.dinoflagellate_roi_per_ml./IFCB125_uw.diatom_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 6])
title('Dinoflagellates : Diatoms')
set(gca, 'box', 'on')

figure, set(gcf, 'position', [90 300 1400 300])
%scatter(meta_data.longitude(survey_ind), meta_data.latitude(survey_ind), 15, sum(classcount_above_adhocthresh(survey_ind,dino_ind),2)./meta_data.ml_analyzed(survey_ind), 'filled')
subplot(1,3,1)
scatter(IFCB107_uw.longitude, IFCB107_uw.latitude, 20, IFCB107_uw.dinoflagellate_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 150])
title('Dinoflagellates (ml^{-1})')
set(gca, 'box', 'on')
subplot(1,3,2)
scatter(IFCB107_uw.longitude, IFCB107_uw.latitude, 20, IFCB107_uw.diatom_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 150])
title('Diatoms (ml^{-1})')
set(gca, 'box', 'on')
subplot(1,3,3)
scatter(IFCB107_uw.longitude, IFCB107_uw.latitude, 20, IFCB107_uw.dinoflagellate_roi_per_ml./IFCB107_uw.diatom_roi_per_ml, 'filled')
axis(alim)
colorbar
caxis([0 6])
title('Dinoflagellates : Diatoms')
set(gca, 'box', 'on')

%%
%section 3
figure %
plot(mdate(survey_ind), sum(classcount(survey_ind,diatom_ind),2)./meta_data.ml_analyzed(survey_ind), '.-')
hold on
plot(mdate(process_ind), sum(classcount(process_ind,diatom_ind),2)./meta_data.ml_analyzed(process_ind), '.-')
datetick, ylim([0 300])


%%
%section 4
cmax = 60;
figure(101),clf
subplot(2,3,1)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.dinoflagellategt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,2)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.diatomgt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Diatoms (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,3)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.dinoflagellategt10_roi_per_ml./IFCB125_uw.diatomgt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates/Diatoms','fontweight','bold')
set(h,'fontsize',15)
caxis([0 6])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

%%
% section 5
figure(102),clf
subplot(2,3,1)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.dinoflagellategt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,2)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.diatomgt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Diatoms (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,3)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.dinoflagellategt10_roi_per_ml./IFCB107_uw.diatomgt10_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates/Diatoms','fontweight','bold')
set(h,'fontsize',15)
caxis([0 6])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h


%%
% section 6
cmax = 150;
figure(103),clf
subplot(2,3,1)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.dinoflagellate_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,2)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.diatom_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Diatoms (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,3)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB125_uw.latitude,IFCB125_uw.longitude,40,IFCB125_uw.dinoflagellate_roi_per_ml./IFCB125_uw.diatom_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates/Diatoms','fontweight','bold')
set(h,'fontsize',15)
caxis([0 12])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

%%
% section 7
figure(104),clf
subplot(2,3,1)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.dinoflagellate_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,2)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.diatom_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Diatoms (mL^{-1})','fontweight','bold')
set(h,'fontsize',15)
caxis([0 cmax])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h

subplot(2,3,3)
ax = worldmap([49.6 51.2],[-146.2 -143.8]);
scatterm(IFCB107_uw.latitude,IFCB107_uw.longitude,40,IFCB107_uw.dinoflagellate_roi_per_ml./IFCB107_uw.diatom_roi_per_ml,'filled'),colorbar
hold on
h = colorbar;
title('Dinoflagellates/Diatoms','fontweight','bold')
set(h,'fontsize',15)
caxis([0 12])
set(gca,'fontsize',15)
setm(ax,'mlabelparallel',-90,'fontsize',14,'mlabellocation',[-146 -145 -144],'plabellocation',[49.5 50 50.5 51])
clear ax h



%Epoch 1- (2018,8,14,0) to (2018,8,23,9) 
%Epoch 2- (2018,8,23,9) to (2018,8,31,9)
%Epoch 3- (2018,8,31,9) to (2018,9,9,18)
e12 = datenum(2018,8,23,9,0,0);
e23 = datenum(2018,8,31,9,0,0);
figure
plot(mdate(survey_ind), IFCB125_uw.diatom_roi_per_ml, 'b.-')
hold on
plot(mdate(process_ind), IFCB107_uw.diatom_roi_per_ml, 'g.-')
set(gcf, 'position', [180 450 800 320])
lh = legend('Survey', 'Process');
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
line(e12*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e23*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
set(lh, 'string', {'Survey' 'Process'})
ylabel('Concentration (ml^{-1})')
datetick('x', 'keeplimits')
title('Diatoms, all measured')

figure
plot(mdate(survey_ind), IFCB125_uw.diatomgt10_roi_per_ml, 'b.-')
hold on
plot(mdate(process_ind), IFCB107_uw.diatomgt10_roi_per_ml, 'g.-')
set(gcf, 'position', [180 450 800 320])
lh = legend('Survey', 'Process');
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
line(e12*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e23*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
set(lh, 'string', {'Survey' 'Process'})
ylabel('Concentration (ml^{-1})')
datetick('x', 'keeplimits')
title('Diatoms, cells*chains > 10 \mum ESD')

confi = poisson_count_ci(diatomcount_gt10,.95);
diatomcount_gt10_confi_process = confi(process_ind,:)./meta_data.ml_analyzed(process_ind);
diatomcount_gt10_confi_survey = confi(survey_ind,:)./meta_data.ml_analyzed(survey_ind);
plot(mdate(survey_ind), diatomcount_gt10_confi_survey(:,1), '--', 'color', [.3 .3 .3])
plot(mdate(survey_ind), diatomcount_gt10_confi_survey(:,2), '--', 'color', [.3 .3 .3])
plot(mdate(process_ind), diatomcount_gt10_confi_process(:,2), '--', 'color', [.8 .8 .8])
plot(mdate(process_ind), diatomcount_gt10_confi_process(:,1), '--', 'color', [.8 .8 .8])


%%
%section 8

for ii = 1:length(process_ind)
    [mdate_diff(ii), survey_match_ind(ii)] = min(abs(mdate(process_ind(ii)) - mdate(survey_ind)));
    ddist(ii) = sw_dist([meta_data.latitude(process_ind(ii)); meta_data.latitude(survey_ind(survey_match_ind(ii)))],[meta_data.longitude(process_ind(ii)); meta_data.longitude(survey_ind(survey_match_ind(ii)))]);
end

plot(mdate(process_ind), ddist, '.-')
datetick keeplimits
datetick keeplimits
ylabel('Distance between ships (nm) at process ship IFCB sampling times')
ylabel({'Distance between ships (nm)'; 'at process ship IFCB sampling times'})
grid


close_ind = find(ddist<=10 & mdate_diff<1/24);
close_ind = find(ddist<=5 & mdate_diff<1/24);

figure
plot(mdate(survey_ind(survey_match_ind(close_ind))), IFCB125_uw.diatomgt10_roi_per_ml(survey_match_ind(close_ind)), 'b.', 'markersize', 14)
hold on
plot(mdate(process_ind(close_ind)), IFCB107_uw.diatomgt10_roi_per_ml(close_ind), 'g.', 'markersize', 14)
set(gcf, 'position', [180 450 800 320])
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
ylim([0 30])
line(e12*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e23*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
set(lh, 'string', {'Survey' 'Process'})
ylabel('Concentration (ml^{-1})')
datetick('x', 'keeplimits')
lh = legend('Survey', 'Process');
title('Diatoms, cells*chains > 10 \mum ESD; ships within 10 nm & 1 h')

hold on
plot(mdate(survey_ind(survey_match_ind(close_ind))), diatomcount_gt10_confi_survey((survey_match_ind(close_ind)),1), 'v', 'color', 'b', 'markersize', 4)
plot(mdate(survey_ind(survey_match_ind(close_ind))), diatomcount_gt10_confi_survey((survey_match_ind(close_ind)),2), '^', 'color', 'b', 'markersize', 4)
plot(mdate(process_ind(close_ind)), diatomcount_gt10_confi_process(close_ind,2), 'v', 'color', 'g', 'markersize', 4)
plot(mdate(process_ind(close_ind)), diatomcount_gt10_confi_process(close_ind,1),'^', 'color', 'g', 'markersize', 4)

%%
figure
set(gcf, 'position', [180 450 800 320])
x = mdate(survey_ind(survey_match_ind(close_ind)));
y1 = IFCB125_uw.diatomgt10_roi_per_ml(survey_match_ind(close_ind));
ci = diatomcount_gt10_confi_survey((survey_match_ind(close_ind)),:);
neg = y1-ci(:,1);
pos = ci(:,2)-y1;
errorbar(x,y1,neg,pos, 'b.', 'markersize', 14)
hold on
plot(mdate(process_ind(close_ind)), IFCB107_uw.diatomgt10_roi_per_ml(close_ind), 'g.', 'markersize', 14)
x = mdate(process_ind(close_ind));
y = IFCB107_uw.diatomgt10_roi_per_ml(close_ind);
ci = diatomcount_gt10_confi_process(close_ind,:);
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(x,y,neg,pos, 'g.', 'markersize', 14)
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
ylim([0 30])
line(e12*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e23*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
ylabel('Concentration (ml^{-1})')
datetick('x', 'keeplimits')
lh = legend('Survey', 'Process');
%set(lh, 'string', {'Survey' 'Process'})
title('Diatoms, cells*chains > 10 \mum ESD; ships within 10 nm & 1 h')

figure
plot(y1, y, '.', 'markersize', 14)
line(xlim, xlim, 'linewidth', 1)
axis square
ylabel('Process ship, concentration (ml^{-1})')
xlabel('Survey ship, concentration (ml^{-1})')
title('Diatoms, cells&chains > 10 \mum ESD; ships within 10 nm & 1 h')

%%
%Epoch 1- (2018,8,14,0) to (2018,8,23,9) 
%Epoch 2- (2018,8,23,9) to (2018,8,31,9)
%Epoch 3- (2018,8,31,9) to (2018,9,9,18)

ind = find(mdate > datenum(2018,8,14) & mdate < datenum(2018,9,9,18,0,0));

figure
plot(mdate(survey_ind), classcount(survey_ind,diatom_ind(35)))
hold on
plot(mdate(process_ind), classcount(process_ind,diatom_ind(35)))
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
datetick keeplimits
set(gcf, 'position', [180 450 800 320])

%%
figure
cc = diatom_ind(35);
cc = dino_ind(19);
cc = 70;
cc = 89;
x = mdate(survey_ind(survey_match_ind(close_ind)));
ii = survey_ind(survey_match_ind(close_ind));
y1 = classcount(ii,cc)./meta_data.ml_analyzed(ii);
ci = poisson_count_ci(classcount(ii,cc),.95)./meta_data.ml_analyzed(ii);
neg = y1-ci(:,1);
pos = ci(:,2)-y1;
errorbar(x,y1,neg,pos, 'b.', 'markersize', 14)
hold on
x = mdate(process_ind(close_ind));
ii = process_ind(close_ind);
y2 = classcount(ii,cc)./meta_data.ml_analyzed(ii);
ci = poisson_count_ci(classcount(ii,cc),.95)./meta_data.ml_analyzed(ii);
neg = y2-ci(:,1);
pos = ci(:,2)-y2;
errorbar(x,y2,neg,pos, 'g.', 'markersize', 14)
title(class2use(cc))
set(gcf, 'position', [180 450 800 320])
xlim([datenum(2018,8,14,0,0,0)  datenum(2018,9,9,18,0,0)])
datetick keeplimits

%%
e1 = datenum(2018,8,14,0,0,0);
e3end = datenum(2018,9,9,18,0,0);
cc = diatom_ind(35)
cc = dino_ind(19);
cc = 70
figure
plot(mdate(survey_ind), classcount(survey_ind,cc)./meta_data.ml_analyzed(survey_ind))
hold on
plot(mdate(process_ind), classcount(process_ind,cc)./meta_data.ml_analyzed(process_ind))
set(gcf, 'position', [180 450 800 320])
datetick keeplimits
title('\itOxytoxum')
ylabel('Concentration (ml^{-1})')
line(e12*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e23*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e1*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
line(e3end*[1 1], ylim, 'linestyle', '--', 'color', [.5 .5 .5],'linewidth', 2)
lh = legend('Survey', 'Process');
title(['\it' class2use{cc}])
