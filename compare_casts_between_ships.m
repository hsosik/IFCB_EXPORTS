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
metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60));
[~,ia,ib] = intersect(filelist, metaT.pid);
metadata_eco(ia,:) = metaT(ib,:);


ifcbann = load('\\sosiknas1\IFCB_products\EXPORTS\summary\count_biovol_size_manual_30Jul2020');
