fileset = {'D20180815T074234_IFCB107'	'D20180815T073204_IFCB125';...
'D20180815T080458_IFCB107'	'D20180815T075513_IFCB125';...
'D20180815T084945_IFCB107'	'D20180815T084131_IFCB125';...
'D20180815T091208_IFCB107'	'D20180815T090439_IFCB125';...
'D20180817T021625_IFCB107'	'D20180817T022001_IFCB125';...
'D20180817T023849_IFCB107'	'D20180817T024310_IFCB125';...
'D20180817T081302_IFCB107'	'D20180817T080713_IFCB125';...
'D20180817T083525_IFCB107'	'D20180817T083022_IFCB125';...
'D20180817T085749_IFCB107'	'D20180817T085330_IFCB125';...
'D20180822T024339_IFCB107'	'D20180822T024347_IFCB125';...
'D20180822T030603_IFCB107'	'D20180822T025557_IFCB125';...
'D20180822T032826_IFCB107'	'D20180822T031901_IFCB125';...
'D20180823T133645_IFCB107'	'D20180823T134604_IFCB125';...
'D20180823T135909_IFCB107'	'D20180823T140908_IFCB125';...
'D20180823T142132_IFCB107'	'D20180823T143212_IFCB125';...
'D20180823T144356_IFCB107'	'D20180823T145515_IFCB125';...
'D20180823T150619_IFCB107'	'D20180823T145515_IFCB125';...
'D20180828T061434_IFCB107'	'D20180828T061034_IFCB125';...
'D20180828T063658_IFCB107'	'D20180828T063338_IFCB125';...
'D20180829T071313_IFCB107'	'D20180829T070152_IFCB125';...
'D20180829T073537_IFCB107'	'D20180829T072456_IFCB125';...
'D20180829T075801_IFCB107'	'D20180829T074800_IFCB125';...
'D20180829T101222_IFCB107'	'D20180829T100624_IFCB125';...
'D20180829T103446_IFCB107'	'D20180829T102928_IFCB125';...
'D20180829T224239_IFCB107'	'D20180829T223825_IFCB125';...
'D20180830T002706_IFCB107'	'D20180830T002122_IFCB125';...
'D20180830T004930_IFCB107'	'D20180830T004426_IFCB125';...
'D20180814T063128_IFCB107'	'D20180814T062435_IFCB125';...
'D20180814T065352_IFCB107'	'D20180814T064744_IFCB125';...
'D20180814T071615_IFCB107'	'D20180814T071053_IFCB125';...
'D20180814T073839_IFCB107'	'D20180814T073401_IFCB125';...
'D20180814T080102_IFCB107'	'D20180814T075710_IFCB125';...
'D20180830T095120_IFCB107'	'D20180830T094521_IFCB125';...
'D20180830T105831_IFCB107'	'D20180830T105433_IFCB125';...
'D20180830T112054_IFCB107'	'D20180830T111737_IFCB125';...
'D20180830T114318_IFCB107'	'D20180830T114041_IFCB125';...
'D20180830T120541_IFCB107'	'D20180830T120345_IFCB125';...
'D20180814T082326_IFCB107'	'D20180814T082019_IFCB125';...
'D20180814T084550_IFCB107'	'D20180814T084328_IFCB125';...
'D20180814T090813_IFCB107'	'D20180814T090636_IFCB125';...
'D20180814T093037_IFCB107'	'D20180814T092945_IFCB125';...
'D20180814T095300_IFCB107'	'D20180814T095254_IFCB125'};

%'D20180815T082721_IFCB107'	'D20180815T081822_IFCB125';... %bad flow 107?
%below not closest
%D20180822T015852_IFCB107	D20180822T024347_IFCB125		8.897	-0.7486		D20180822T015852_IFCB107,	D20180822T024347_IFCB125,	Emily finished	uncertain clearl ciliates in detritus in this set.		
%D20180822T022116_IFCB107	D20180822T024347_IFCB125		9.6818	-0.3753		D20180822T022116_IFCB107,	D20180822T024347_IFCB125,	Emily finished	uncertain clearl ciliates in detritus in this set.		

ifcbann = load('\\sosiknas1\IFCB_products\EXPORTS\summary\count_biovol_size_manual_03Aug2020');
[~,uwmind(:,1)] = ismember(fileset(:,1),ifcbann.filelist);
[~,uwmind(:,2)] = ismember(fileset(:,2),ifcbann.filelist);
uwmind = sortrows(uwmind,1);
%isequal(fileset(:,2), ifcbann.filelist(uwmind(:,2)))
ic_cnn = strmatch('Oxytoxum', ifcbann.classes)
%ic_cnn = strmatch('Syracosphaera pulchra', ifcbann.classes)

%%
%figure
%plot(ifcbann.matdate(uwmind(:,1)), ifcbann.summary.count(uwmind(:,1),ic_cnn)./ifcbann.ml_analyzed(uwmind(:,1)), '.-', 'markersize', 14)
%hold on
%plot(ifcbann.matdate(uwmind(:,2)), ifcbann.summary.count(uwmind(:,2),ic_cnn3)./ifcbann.ml_analyzed(uwmind(:,2)), '.-', 'markersize', 14)
%datetick

%%
figure
set(gcf, 'position',[200 400 850 300])
yn = ifcbann.summary.count(uwmind(:,1),ic_cnn);
yd = ifcbann.ml_analyzed(uwmind(:,1));
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(ifcbann.matdate(uwmind(:,1)),y,neg,pos,'.b', 'markersize', 18, 'linewidth', 2)
hold on
yn = ifcbann.summary.count(uwmind(:,2),ic_cnn);
yd = ifcbann.ml_analyzed(uwmind(:,2));
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(ifcbann.matdate(uwmind(:,2)),y,neg,pos, 'r^', 'markersize', 7, 'MarkerFaceColor', 'r')
datetick
%ylabel('\itOxytoxum\rm (cells ml^{-1})')
ylabel(['\it' ifcbann.classes(ic_cnn) '\rm (cells ml^{-1})'])
title('Underway')
legend('Process, IFCB107', 'Survey,   IFCB125', 'location', 'northwest')

%%
figure
set(gcf, 'position',[200 400 850 300])
yn = ifcbann.summary.count(uwmind(:,1),ic_cnn);
yd = ifcbann.ml_analyzed(uwmind(:,1));
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(1:length(y),y,neg,pos,'.b', 'markersize', 18, 'linewidth', 2)
hold on
yn = ifcbann.summary.count(uwmind(:,2),ic_cnn);
yd = ifcbann.ml_analyzed(uwmind(:,2));
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(1:length(y),y,neg,pos, 'r^', 'markersize', 7,'MarkerFaceColor', 'r')
%ylabel('\itOxytoxum\rm (cells ml^{-1})')
ylabel(['\it' ifcbann.classes(ic_cnn) '\rm (cells ml^{-1})'])
legend('Process, IFCB107', 'Survey,   IFCB125', 'location', 'northwest')
xlabel('Sample pair index number')

%%
figure
b = [0:1:80 inf];
%b = [logspace(-3,log10(3),100) inf];
clear hc
hc(:,1) = histcounts(cat(1,ifcbann.summary.esd{uwmind(:,1),ic_cnn}),b);
hc(:,2) = histcounts(cat(1,ifcbann.summary.esd{uwmind(:,2),ic_cnn}),b); xlabel('ESD (\mum)')
%hc(:,1) = histcounts(cat(1,ifcbann.summary.maxFd{uwmind(:,1),ic_cnn}),b);
%hc(:,2) = histcounts(cat(1,ifcbann.summary.maxFd{uwmind(:,2),ic_cnn}),b); xlabel('max Feret diameter (\mum)')
hold on
bar(b(1:end-1), hc./sum(ifcbann.ml_analyzed(uwmind)))
title(['\it' ifcbann.classes(ic_cnn)])
legend('Process, IFCB107', 'Survey,   IFCB125')
ylabel('Concentration (ml^{-1} \mum^{-1})')
set(gca, 'box','on')

%%
%adc: PMTA, PMTB, PMTC, PMTD, peakA, peakB, peakC, peakD, time of flight
adc1 = cat(1,ifcbann.summary.adc{uwmind(:,1),ic_cnn});
adc2 = cat(1,ifcbann.summary.adc{uwmind(:,2),ic_cnn});

figure
subplot(2,2,1)
b = [0:.01:1 inf];
%b = [logspace(-3,log10(3),100) inf];
clear hc
hc(:,1) = histcounts(adc1(:,6),b);
hc(:,2) = histcounts(adc2(:,6),b);
bar(b(1:end-1), hc./sum(ifcbann.ml_analyzed(uwmind)),'barwidth', 3)
xlabel('Chl fluoresence, peak signal')
title('\itOxytoxum\rm')
title(['\it' ifcbann.classes(ic_cnn)])
legend('Process, IFCB107', 'Survey,   IFCB125', 'location', 'northeast')

subplot(2,2,2)
b = [-.01:.01:1 inf];
clear hc
hc(:,1) = histcounts(adc1(:,5),b);
hc(:,2) = histcounts(adc2(:,5),b);
bar(b(1:end-1), hc./sum(ifcbann.ml_analyzed(uwmind)),3)
xlabel('Side scattering, peak signal')
%title('\itOxytoxum\rm')
title(['\it' ifcbann.classes(ic_cnn)])

subplot(2,2,3)
b = [-.012:.001:.1 inf];
clear hc
hc(:,1) = histcounts(adc1(:,2),b);
hc(:,2) = histcounts(adc2(:,2),b);
bar(b(1:end-1), hc./sum(ifcbann.ml_analyzed(uwmind)), 'barwidth', 3)
xlabel('Chl fluoresence, integrated signal')

subplot(2,2,4)
b = [0:.001:.1 inf];
clear hc
hc(:,1) = histcounts(adc1(:,1),b);
hc(:,2) = histcounts(adc2(:,1),b);
bar(b(1:end-1), hc./sum(ifcbann.ml_analyzed(uwmind)), 'barwidth', 3)
xlabel('Side scattering, integrated signal')


%%
%everything
adc1_all = cat(1,ifcbann.summary.adc{uwmind(:,1),:});
adc2_all = cat(1,ifcbann.summary.adc{uwmind(:,2),:});
%one class
adc1 = cat(1,ifcbann.summary.adc{uwmind(:,1),ic_cnn});
adc2 = cat(1,ifcbann.summary.adc{uwmind(:,2),ic_cnn});

adct = adc2;
adct_all = adc2_all;
figure
subplot(2,2,1)
loglog(adct_all(:,5), adct_all(:,6), '.', 'markersize', 3), ylabel('Chl peak'), xlabel('SSC peak')
hold on
loglog(adct(:,5), adct(:,6), 'r.', 'markersize', 4)
axis([.01 5 .01 5])
title(['\it' ifcbann.classes(ic_cnn)])
subplot(2,2,2)
loglog(adct_all(:,1), adct_all(:,2)+.1, '.', 'markersize', 3), ylabel('Chl integrated, +0.1'), xlabel('SSC integrated')
hold on
loglog(adct(:,1), adct(:,2)+.1, 'r.', 'markersize', 4)
axis([.001 5 .05 5])
subplot(2,2,3)
loglog(adct_all(:,5), adct_all(:,1), '.', 'markersize', 3), xlabel('SSC peak'), ylabel('SSC integrated')
hold on
loglog(adct(:,5), adct(:,1), 'r.', 'markersize', 4)
axis([.01 5 .001 5])
subplot(2,2,4)
loglog(adct_all(:,6), adct_all(:,2)+.1, '.', 'markersize', 3), xlabel('Chl peak'), ylabel('Chl integrated, +0.1')
hold on
loglog(adct(:,6), adct(:,2)+.1, 'r.', 'markersize', 4)
axis([.01 5 .05 5])
set(gcf, 'position',[250 100 560*1.5 420*1.5])

