%update h5 classifier output files for EXPORTS NP

classbase = '\\sosiknas1\IFCB_products\EXPORTS\class\v3\20220225_EXPORTS_pacific_Dec2021_1_3_rev_labels\';
f = dir([classbase '\**\*.h5']); 
classfullname = fullfile(f(1).folder, f(1).name);
cl = h5read(classfullname,'/class_labels');

switches = ["amoeba" "Amoeba"; "cryptophyta" "Cryptophyta"; "detritus_clear" "detritus_transparent"];
[~,~,ia] = intersect(switches(:,1),cl);
cl(ia) = switches(:,2);

for ii = 1:length(f)
    disp(ii)
    h5write(fullfile(f(ii).folder, f(ii).name),'/class_labels', cl);
end
    
