load('\\sosiknas1\IFCB_products\EXPORTS\summary\summary_biovol_allHDF_min20_2018.mat')
%cat(1,classFeaList{8,2})
%cat(1,classFeaList{1:10,8})

uw107ind = find(meta_data.ifcb==107 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);
uw125ind = find(meta_data.ifcb==125 & strcmp(meta_data.sample_type, 'underway') & ~meta_data.skip);

%%
cc = strmatch('Ceratium', class2use)
cc = strmatch('Oxy', class2use)
f107uw = cat(1,classFeaList{uw107ind,cc});
f125uw = cat(1,classFeaList{uw125ind,cc});
p107uw = cat(1,classPidList{uw107ind,cc});
p125uw = cat(1,classPidList{uw125ind,cc});

%%
figure
axlim = [.05 10 .05 10];
subplot(2,2,1)
loglog(f107uw(:,8)+.1, f107uw(:,9)+.1, '.'), title('107')
xlabel('SSC peak'), ylabel('Chl peak')
axis(axlim)
subplot(2,2,2)
loglog(f125uw(:,8)+.1, f125uw(:,9)+.1, '.'), title('125')
xlabel('SSC peak'), ylabel('Chl peak')
axis(axlim)
subplot(2,2,3)
loglog(f107uw(:,4)+.1, f107uw(:,5)+.1, '.'), title('107')
xlabel('SSC integrated'), ylabel('Chl integrated')
axis(axlim)
subplot(2,2,4)
loglog(f125uw(:,4)+.1, f125uw(:,5)+.1, '.'), title('125')
xlabel('SSC integrated'), ylabel('Chl integrated')
axis(axlim)


ii = find(f107uw(:,9)<.1 & f107uw(:,9)>.02);

pid107 = strcat('https://ifcb-data.whoi.edu/EXPORTS/', p107uw', '.png');
pid125 = strcat('https://ifcb-data.whoi.edu/EXPORTS/', p125uw', '.png');
%for iii = 1:length(ii), figure(99), imshow(imread(pids{iii})), pause, end

%%
close(99), g = ginput;
isin = find(isinpoly((f125uw(:,4)+.1), (f125uw(:,5)+.1), g(:,1), g(:,2)));
%isin = find(isinpoly((f125uw(:,8)+.1), (f125uw(:,9)+.1), g(:,1), g(:,2)));
for iii = 1:length(isin), figure(99), imshow(imread(pid125{isin(iii)})), pause, end

%%
close(99), g = ginput;
isin = find(isinpoly((f107uw(:,4)+.1), (f107uw(:,5)+.1), g(:,1), g(:,2)));
for iii = 1:length(isin), figure(99), imshow(imread(pid107{isin(iii)})), pause, end

%%
for iii = 1:length(f), figure(99), imshow(imread(pid107{f(iii)})), pause, end

%%

for ii = 1:length(uw107ind)
    [mdate_diff(ii), survey_match_ind(ii)] = min(abs(mdate(uw107ind(ii)) - mdate(uw125ind)));
    ddist(ii) = sw_dist([meta_data.latitude(uw107ind(ii)); meta_data.latitude(uw125ind(survey_match_ind(ii)))],[meta_data.longitude(uw107ind(ii)); meta_data.longitude(uw125ind(survey_match_ind(ii)))], 'km');
end

close_ind = find(ddist<=10 & mdate_diff<1/24); %5 used for nm, switch to 10 km

figure
plot(mdate(uw125ind(survey_match_ind(close_ind))), classcount(uw125ind(survey_match_ind(close_ind)),cc)./meta_data.ml_analyzed(uw125ind(survey_match_ind(close_ind))), 'm*')
hold on
plot(mdate(uw107ind(close_ind)), classcount(uw107ind(close_ind),cc)./meta_data.ml_analyzed(uw107ind(close_ind)), 'g*')

%%
f107_9t = .0125;
f125_9t = .0155;
f107_8t = .012;
f125_8t = .016;

for ii = 1:length(uw107ind), count_above_9t_107(ii,1) = sum(classFeaList{uw107ind(ii),cc}(:,9)>f107_9t & classFeaList{uw107ind(ii),cc}(:,13)>.5); end
for ii = 1:length(uw125ind), count_above_9t_125(ii,1) = sum(classFeaList{uw125ind(ii),cc}(:,9)>f125_9t & classFeaList{uw125ind(ii),cc}(:,13)>.5); end

for ii = 1:length(uw107ind), count_above_9t_107(ii,1) = sum(classFeaList{uw107ind(ii),cc}(:,8)>f107_8t &classFeaList{uw107ind(ii),cc}(:,9)>f107_9t & classFeaList{uw107ind(ii),cc}(:,1)>10); end
for ii = 1:length(uw125ind), count_above_9t_125(ii,1) = sum(classFeaList{uw125ind(ii),cc}(:,8)>f125_8t & classFeaList{uw125ind(ii),cc}(:,9)>f125_9t & classFeaList{uw125ind(ii),cc}(:,1)>10); end

for ii = 1:length(uw107ind), for iii = 1:length(cc), count_above_9t_107(ii,iii) = sum(classFeaList{uw107ind(ii),cc(iii)}(:,8)>f107_8t &classFeaList{uw107ind(ii),cc(iii)}(:,9)>f107_9t & classFeaList{uw107ind(ii),cc(iii)}(:,1)>20); end; end
for ii = 1:length(uw125ind), for iii = 1:length(cc), count_above_9t_125(ii,iii) = sum(classFeaList{uw125ind(ii),cc(iii)}(:,8)>f125_8t & classFeaList{uw125ind(ii),cc(iii)}(:,9)>f125_9t & classFeaList{uw125ind(ii),cc(iii)}(:,1)>20); end; end

%%%
cast107ind = find(meta_data.ifcb==107 & strcmp(meta_data.sample_type, 'cast') & ~meta_data.skip);
cast125ind = find(meta_data.ifcb==125 & strcmp(meta_data.sample_type, 'cast') & ~meta_data.skip);

for ii = 1:length(cast107ind)
    [cast_mdate_diff(ii), cast_survey_match_ind(ii)] = min(abs(mdate(cast107ind(ii)) - mdate(cast125ind)));
    
    cast_ddist(ii) = sw_dist([meta_data.latitude(cast107ind(ii)); meta_data.latitude(cast125ind(cast_survey_match_ind(ii)))],[meta_data.longitude(cast107ind(ii)); meta_data.longitude(cast125ind(cast_survey_match_ind(ii)))], 'km');
end

depth_diff = meta_data.depth(cast107ind
cast_close_ind = find(cast_ddist<=10 & cast_mdate_diff<1/24); %5 used for nm, switch to 10 km

%%
unique(meta_data.cast(cast107ind(cast_close_ind)))
%%{'SIO037'}
%%{'SIO052'}
%%{'SIO065'}
%%{'SIO079'}
sr_cast = [62 87 112 130];

meta_data(strmatch('SIO065', meta_data.cast),:)

ii1 = strmatch('130', meta_data.cast);
ii = ii1(meta_data.ifcb(ii1)==125);
meta_data(ii,:)

ii = ii1(meta_data.ifcb(ii1)==11);
meta_data(ii,:)
