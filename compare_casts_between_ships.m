eco = load('\\sosiknas1\IFCB_products\EXPORTS\summary\ecotaxaexport12832020072814082SIO037');

pid = eco.ecotaxaexport12832020072814082SIO037.object_id;
file = char(pid);
file = cellstr(file(:,1:24));
filelist = unique(file)
for ii = 1:length(filelist), total_num(ii) = numel(strmatch(filelist(ii),file)); end

classpredicted = cellstr(ecotaxaexport12832020072814082SIO037.object_annotation_category);
class2use_ecotaxa = unique(classpredicted); 

count_ecotaxa = NaN(numel(filelist), numel(class2use_ecotaxa));
for ii = 1:length(filelist)
    fileind = strmatch(filelist(ii),file);
    for iii = 1:length(class2use_ecotaxa)
        ind = strmatch(class2use_ecotaxa(iii),classpredicted(fileind));
        count_ecotaxa(ii,iii) = length(ind);
    end
end

myreadtable = @(filename)readtable(filename, 'Format', '%s%s%s %f%f%f%f%f %s%s %f%s%f %s%s%s%s%s %f'); %case with 5 tags
metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60, 'ContentReader', myreadtable));
%metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60));
[~,ia,ib] = intersect(filelist, metaT.pid);
metadata_eco(ia,:) = metaT(ib,:);

ifcbann = load('\\sosiknas1\IFCB_products\EXPORTS\summary\count_biovol_size_manual_03Aug2020');


%%
ic = strmatch('Oxytoxum', class2use_ecotaxa);

ic_cnn = strmatch('Oxytoxum', ifcbann.classes);
%ic_cnn = strmatch('Syracosphaera pulchra', ifcbann.classes);
castnum = '62'; rrstr = 'SIO037';
ind11 = find(strcmp(castnum, ifcbann.meta_data.cast) & ifcbann.meta_data.ifcb == 11);
ind125 = find(strcmp(castnum, ifcbann.meta_data.cast) & ifcbann.meta_data.ifcb == 125);

figure
x = metadata_eco.depth;
yn = count_ecotaxa(:,ic);
yd = metadata_eco.ml_analyzed;
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'b.', 'markersize', 18)
set(gca, 'ydir', 'rev', 'xaxislocation', 'top')
%xlabel('\itOxytoxum\rm (cells ml^{-1})')
xlabel(['\it' ifcbann.classes{ic_cnn} '\rm (cells ml^{-1})'])
ylabel('Depth (m)')
title(['Casts: SR ' castnum '; RR ' rrstr])
hold on
ind = ind125;
x = ifcbann.meta_data.depth(ind);
yn = ifcbann.summary.count(ind,ic_cnn);
yd = ifcbann.meta_data.ml_analyzed(ind);
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'r^', 'markersize', 8, 'MarkerFaceColor', 'r')
legend('RR', 'SR')

ind = ind11;
x = ifcbann.meta_data.depth(ind);
yn = ifcbann.summary.count(ind,ic_cnn);
yd = ifcbann.meta_data.ml_analyzed(ind);
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'cs', 'markersize', 8, 'MarkerFaceColor', 'c')

legend('Process, IFCB107', 'Survey,   IFCB125', 'Survey,   IFCB011', 'location', 'southeast')
set(gcf, 'position', [450 300 300 400])

%%

ic_cnn = strmatch('Oxytoxum', ifcbann.classes);

castnum = '112'; rrstr = 'SIO065';
castnum = '87'; rrstr = 'SIO052';
castnum = '130'; rrstr = 'SIO079';

ind107 = find(strcmp(rrstr, ifcbann.meta_data.cast) & ifcbann.meta_data.ifcb == 107);
ind11 = find(strcmp(castnum, ifcbann.meta_data.cast) & ifcbann.meta_data.ifcb == 11);
ind125 = find(strcmp(castnum, ifcbann.meta_data.cast) & ifcbann.meta_data.ifcb == 125);

figure
ind = ind107;
x = ifcbann.meta_data.depth(ind);
yn = ifcbann.summary.count(ind,ic_cnn);
yd = ifcbann.meta_data.ml_analyzed(ind);
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'b.', 'markersize', 18)
set(gca, 'ydir', 'rev', 'xaxislocation', 'top')
%xlabel('\itOxytoxum\rm (cells ml^{-1})')
xlabel(['\it' ifcbann.classes{ic_cnn} '\rm (cells ml^{-1})'])
ylabel('Depth (m)')
title(['Casts: SR ' castnum '; RR ' rrstr])
hold on
ind = ind125;
x = ifcbann.meta_data.depth(ind);
yn = ifcbann.summary.count(ind,ic_cnn);
yd = ifcbann.meta_data.ml_analyzed(ind);
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'r^', 'markersize', 8, 'MarkerFaceColor', 'r')
legend('RR', 'SR')

if 0
ind = ind11;
x = ifcbann.meta_data.depth(ind);
yn = ifcbann.summary.count(ind,ic_cnn);
yd = ifcbann.meta_data.ml_analyzed(ind);
y = yn./yd;
ci = poisson_count_ci(yn,.95)./yd; 
neg = y-ci(:,1);
pos = ci(:,2)-y;
errorbar(y,x,neg,pos,'horizontal', 'cs', 'markersize', 8, 'MarkerFaceColor', 'c')
end

legend('Process, IFCB107', 'Survey,   IFCB125', 'Survey,   IFCB011', 'location', 'southeast')
set(gcf, 'position', [450 300 300 400])

