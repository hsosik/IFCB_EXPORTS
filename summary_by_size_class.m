load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018.mat')
load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018lists');

uw107ind = find(meta_data.ifcb==107 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uw125ind = find(meta_data.ifcb==125 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

group_table = readtable('\\sosiknas1\training_sets\IFCB\config\IFCB_classlist_type.csv');
[~,ia,ib] = intersect(group_table.CNN_classlist, class2use);
diatom_ind = ib(find(group_table.Diatom(ia)));
notalive_ind = [ib(find(group_table.OtherNotAlive(ia))); ib(find(group_table.IFCBArtifact(ia)))];
alive_ind = 1:length(class2use); alive_ind(notalive_ind) = [];
%alive_ind(strmatch( 'Phaeocystis', class2use(alive_ind))) = []; %seems to be detritus for en644
alive_ind(strmatch( 'unclassified', class2use(alive_ind))) = [];

f107_9t = .0125;
f125_9t = .0155;
f107_8t = .012;
f125_8t = .016;


%%
warning off
ind = alive_ind;
fi1 = strmatch('ESD', classFeaList_variables);
fi2 = strmatch('maxFeretDiameter', classFeaList_variables);
flist = filelist(uw125ind);
numfiles = length(flist);
count_byESD = NaN(numfiles,1);
bv_bymaxFD = count_byESD;
count_table = table;
bv_table = table;
for ii = 1:numfiles
    if ~rem(ii,20), disp(flist(ii)), end
    if ~meta_data.skip(uw125ind(ii))
        temp = cat(1,classFeaList{uw125ind(ii),ind}); 
        bv = 4/3*pi*(temp(:,fi1)/2).^3;
        count_table.total(ii) = size(temp,1);
        bv_table.total(ii) = sum(bv);
        
        gti = find(temp(:,fi1)>=5 & temp(:,fi1)<20);
        count_table.ESD5_20(ii) = numel(gti); 
        bv_table.ESD5_20(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi1)>=20);
        count_table.ESD20(ii) = numel(gti); 
        bv_table.ESD20(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi2)>=7 & temp(:,fi2)<20);
        count_table.maxFD7_20(ii) = numel(gti); 
        bv_table.maxFD7_20(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi2)>20);
        count_table.maxFD20(ii) = numel(gti); 
        bv_table.maxFD20(ii) = sum(bv(gti));
        
        temp2 = temp;
        temp = temp(temp(:,9)>f125_9t,:);
 
        bv = 4/3*pi*(temp(:,fi1)/2).^3;
        count_table.totalFL(ii) = size(temp,1);
        bv_table.totalFL(ii) = sum(bv);
        
        gti = find(temp(:,fi1)>=5 & temp(:,fi1)<20);
        count_table.ESD5_20FL(ii) = numel(gti); 
        bv_table.ESD5_20FL(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi1)>=20);
        count_table.ESD20FL(ii) = numel(gti); 
        bv_table.ESD20FL(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi2)>=7 & temp(:,fi2)<20);
        count_table.maxFD7_20FL(ii) = numel(gti); 
        bv_table.maxFD7_20FL(ii) = sum(bv(gti));
        
        gti = find(temp(:,fi2)>20);
        count_table.maxFD20FL(ii) = numel(gti); 
        bv_table.maxFD20FL(ii) = sum(bv(gti));
        
    end
end

mdate_uw125 = mdate(uw125ind);
meta_data_uw125 = meta_data(uw125ind,:);
notes = {'bv, biovolume in cubic microns; maxFD, maximum Feret diameter in microns; ESD, equivalent spherical diameter in microns computed from biovolume'};
notes2 = {'script summary_by_size_class'};
save('\\sosiknas1\IFCB_products\EXPORTS\summary\uw125_fractions_July2020', 'count_table', 'bv_table', 'notes*', 'mdate_uw125', 'meta_data_uw125')

figure, set(gcf, 'position', [100 400 650 300])
plot(mdate_uw125, count_table.total./meta_data_uw125.ml_analyzed, 'linewidth', 2)
hold on
plot(mdate_uw125, count_table.ESD5_20./meta_data_uw125.ml_analyzed, 'linewidth', 2)
plot(mdate_uw125, count_table.ESD20./meta_data_uw125.ml_analyzed, 'linewidth', 2) 
legend('all measured', 'ESD 5-20\mum','ESD > 20\mum')
datetick keeplimits
ylabel('Concentration (ml^{-1})')
print('\\sosiknas1\IFCB_products\EXPORTS\summary\uw125_conc_byESD.png', '-dpng')

figure, set(gcf, 'position', [100 400 650 300])
plot(mdate_uw125, count_table.total./meta_data_uw125.ml_analyzed, 'linewidth', 2)
hold on
plot(mdate_uw125, count_table.maxFD7_20./meta_data_uw125.ml_analyzed, 'linewidth', 2)
plot(mdate_uw125, count_table.maxFD20./meta_data_uw125.ml_analyzed, 'linewidth', 2) 
legend('all measured', 'maxFeret 7-20\mum','maxFeret > 20\mum')
datetick keeplimits
ylabel('Concentration (ml^{-1})')
print('\\sosiknas1\IFCB_products\EXPORTS\summary\uw125_conc_bymaxFD.png', '-dpng')

figure, set(gcf, 'position', [100 400 650 300])
plot(mdate_uw125, bv_table.total./meta_data_uw125.ml_analyzed, 'linewidth', 2)
hold on
plot(mdate_uw125, bv_table.ESD5_20./meta_data_uw125.ml_analyzed, 'linewidth', 2)
plot(mdate_uw125, bv_table.ESD20./meta_data_uw125.ml_analyzed, 'linewidth', 2) 
legend('all measured', 'ESD 5-20\mum','ESD > 20\mum')
datetick keeplimits
ylabel('Biovolume concentration (\mum^3 ml^{-1})')
ylim([0 1e6])
print('\\sosiknas1\IFCB_products\EXPORTS\summary\uw125_biovolconc_byESD.png', '-dpng')

figure, set(gcf, 'position', [100 400 650 300])
plot(mdate_uw125, bv_table.total./meta_data_uw125.ml_analyzed, 'linewidth', 2)
hold on
plot(mdate_uw125, bv_table.maxFD7_20./meta_data_uw125.ml_analyzed, 'linewidth', 2)
plot(mdate_uw125, bv_table.maxFD20./meta_data_uw125.ml_analyzed, 'linewidth', 2) 
legend('all measured', 'maxFeret 7-20\mum','maxFeret > 20\mum')
datetick keeplimits
ylabel('Biovolume concentration (\mum^3 ml^{-1})')
ylim([0 1e6])
print('\\sosiknas1\IFCB_products\EXPORTS\summary\uw125_biovolconc_bymaxFD.png', '-dpng')

return

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



ind = Lpoly_ind;
fi1 = strmatch('ESD', classFeaList_variables);
fi2 = strmatch('maxFeretDiameter', classFeaList_variables);
numfiles = length(filelist);
count_gt10 = NaN(numfiles,1);
bv_gt10 = count_gt10;
for ii = 1:numfiles
    if ~rem(ii,20), disp(filelist(ii)), end
    if ~meta_data.skip(ii)
        temp = cat(1,classFeaList{ii,ind}); 
        bv_table = 4/3*pi*(temp(:,fi1)/2).^3;
        count_gt10(ii,2) = size(temp,1);
        gt10i = find(temp(:,fi1)>10 | temp(:,fi2)>10);
        count_gt10(ii,1) = numel(gt10i); 
        bv_gt10(ii,2) = sum(bv_table);
        bv_gt10(ii,1) = sum(bv_table(gt10i));
    end
end
