
b = '\\sosiknas1\IFCB_products\EXPORTS\features\';
metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 15));

f1 = 'D20180825T050336_IFCB125'
fea1 = readtable([b f1(1:5) filesep f1(1:9) filesep f1 '_fea_v4.csv']);
bins = 1:150;
h1 = histcounts(fea1.EquivDiameter/2.77, bins);
ml1 = metaT.ml_analyzed(strmatch(f1, metaT.pid))

semilogy(bins(1:end-1), h1./ml1)

