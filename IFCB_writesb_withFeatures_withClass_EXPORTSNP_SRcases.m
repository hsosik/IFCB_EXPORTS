%%myreadtable = @(filename)readtable(filename, 'Format', '%s%s%s %f%f%f%f%f%s%s %f%s%f %s%s%s %f'); %case with 3 tags
%%metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60, 'ContentReader', myreadtable));
%metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60));
opts = delimitedTextImportOptions("NumVariables", 20);
opts.DataLines = [2 inf];
opts.VariableTypes = ["string", "string", "string", "double", "double", "double", "double", "double", "string", "string", "double", "string", "double", "string", "string", "string", "string", "string", "double", "double"];
opts.VariableNamesLine = 1;
myreadtable = @(filename)readtable(filename, opts); %
metaT =  webread('https://ifcb-data.whoi.edu/api/export_metadata/EXPORTS', weboptions('Timeout', 60, 'ContentReader', myreadtable));
metaT.cast = fillmissing(metaT.cast, 'constant', "");
clear myreadtable opts
%%
%outpath = 'C:\work\EXPORTS\sb-test_process_with_class\';
outpath = '\\sosiknas1\IFCB_products\EXPORTS\SeaBASS\20220225_EXPORTS_pacific_Dec2021_1_3_rev_labels\sb_files\';
feabase = '\\sosiknas1\IFCB_products\EXPORTS\features\';
classbase = '\\sosiknas1\IFCB_products\EXPORTS\class\v3\20220225_EXPORTS_pacific_Dec2021_1_3_rev_labels\';
urlbase = 'http://ifcb-data.whoi.edu/EXPORTS/';
load("C:\work\EXPORTS\assessed_ID_table.mat") %created with make_SB_assessed_ID_table.m
%%
if exist('hdr', 'var')
    clear hdr*
end
ship = 'survey'; %'survey' 'process'
sampletype = 'discrete'; %'inline' 'discrete'
switch ship
case 'survey'
    cruise = 'SR1812';
    hdr.investigators = 'Heidi_Sosik,Collin_Roesler';
    hdr.affiliations = 'Woods_Hole_Oceanographic_Institution,Bowdoin_College';
    hdr.contact = 'hsosik@whoi.edu,croesler@bowdoin.edu';
    uwdepth = '6';
    if strcmp(sampletype, 'discrete')
        r2r = readtable("C:\work\EXPORTS\R2R_ELOG_SR1812_FINAL_EVENTLOG_20180913_022931.csv");
    end
% case 'process'
%     cruise = 'RR1813';
%     hdr.investigators = 'Lee_Karp-Boss,Heidi_Sosik';
%     hdr.affiliations = 'University_of_Maine,Woods_Hole_Oceanographic_Institution';
%     hdr.contact = 'lee.karp-boss@maine.edu,hsosik@whoi.edu';
%     uwdepth = '5';
%     if strcmp(sampletype, 'discrete') %for RR1813 discretes, get this file for concentration factors
%         %meta_upload = readtable("\\sosiknas1\IFCB_data\EXPORTS\to_tag\EXPORTS_metadata_20191113_IFCB107_fromNils_mod4upload.csv");
%         meta_upload = readtable("\\sosiknas1\IFCB_data\EXPORTS\to_tag\EXPORTS_metadata_20191113_IFCB107_fromNils_mod.csv");
%     end
end
switch sampletype
    case 'inline'
        sbdatatypestr = 'flow_thru';
        IFCBtypestr = {'underway'};
    case 'discrete'
        sbdatatypestr = 'bottle'; %default, overwrite with net_tow as appropriate below
        %IFCBtypestr = {'cast' 'towfish_discrete' 'underway_discrete' 'zootow_discrete' 'expt_karen' 'incubation'};
        IFCBtypestr = {'cast' 'underway_discrete'};
end
hdr.experiment = 'EXPORTS';
hdr.cruise = 'EXPORTSNP';31
hdr.station = '-9999';
hdr.r2r_event = '-9999';
hdr.data_file_name = 'temp'; 
%hdr.documents = 'IFCB_brief_protocol_Sosik_Oct2021.docx,checklist_IFCB_plankton_and_particles_EXPORTS-EXPORTSNP_Sosik.docx,namespace_ptwg_nonconforming_roi_v1.yml,namespace_whoi-plankton_extra_nonconforming_v1.yml';
%hdr.documents = 'IFCB_brief_protocol_Sosik_Oct2021.docx,checklist_IFCB_plankton_and_particles_EXPORTS-EXPORTSNP_SR1812_R2_Sosik_automated_classification.docx,namespace_ptwg_nonconforming_roi_v1.yml';
hdr.documents = 'IFCB_brief_protocol_Sosik_Oct2021.docx,checklist_IFCB_plankton_and_particles_EXPORTS-EXPORTSNP_SR1812_R2_Sosik_automated_classification.docx,namespace_ptwg_nonconforming_roi_v1.yml,automated_assessed_id_EXPORTSNP_IFCB125.txt';
hdr.calibration_files = 'no_cal_files';
hdr.eventID = 'temp';  
hdr.data_type = sbdatatypestr;
%if strcmp('discrete',sampletype)
%    hdr.data_use_warning = 'experimental'; %only needed for weird case of incubations
%end
hdr.instrument_model = 'temp'; 
hdr.instrument_manufacturer = 'McLane_Research_Laboratories_Inc';
hdr.data_status = 'final';
hdr.start_date = 'temp';
hdr.end_date = 'temp';  
hdr.start_time = 'temp';
hdr.end_time = 'temp'; 
hdr.north_latitude = 'temp'; 
hdr.south_latitude = 'temp'; 
hdr.east_longitude = 'temp'; 
hdr.west_longitude = 'temp'; 
hdr.water_depth = 'NA';
hdr.measurement_depth = uwdepth;
hdr.volume_sampled_ml = '5'; 
hdr.volume_imaged_ml = 'temp';  
hdr.pixel_per_um = '2.77'; 
hdr.associatedMedia_source = 'temp'; 
hdr.associated_archives = [hdr.experiment '-' hdr.cruise '_' cruise '_IFCB_raw_data.tgz'];
hdr.associated_archive_types = 'raw';
hdr.length_representation_instrument_varname = 'maxFeretDiameter'; 
hdr.width_representation_instrument_varname = 'minFeretDiameter';
hdr.missing = '-9999';
hdr.delimiter = 'comma'; 
hdr.fields = 'associatedMedia,data_provider_category_automated,scientificName_automated,scientificNameID_automated,prediction_score_automated_category,biovolume,area_cross_section,length_representation,width_representation,equivalent_spherical_diameter';
hdr.units = 'none,none,none,none,none,um^3,um^2,um,um,um';

%ii = find(strcmp(cruise, metaT.cruise) & strcmp(IFCBtypestr, metaT.sample_type));
ii = find(strcmp(cruise, metaT.cruise) & ismember(metaT.sample_type, IFCBtypestr) & ~(metaT.ifcb==11) & ~(metaT.skip));

comment1 = ['! EXPORTSNP cruise ' cruise];
%comment2 = '! To construct each image filename from associatedMedia: extract the string after the last / and replace .html with .png';
comment2 = '! To access each image directly from the associatedMedia string: replace .html with .png';
comment3 = '! v4 ifcb-analysis image products; https://github.com/hsosik/ifcb-analysis'; 
comment6 = '! Files updated (R2 version) to include taxonomic classification';

pixel_per_micron = str2num(hdr.pixel_per_um);
hdr_copy = hdr;
%%
for count = 1:length(ii) %1020:1021%length(ii) %1:10 %20:5:65 (survey) %1:2:20 (process) 132:133 (process expts)  %1:length(ii)
    hdr = hdr_copy;
    m = metaT(ii(count),:);
    hdr.data_type = sbdatatypestr; %default
    switch char(m.sample_type) %all other cases as defaulted to 'flow_thru' or 'bottle'
        case 'underway_discrete'
            hdr.data_type = 'flow_thru';
%            hdr = rmfield(hdr,'data_use_warning');
%        case 'zootow_discrete'
%            hdr.data_type = 'net_tow';
%            hdr = rmfield(hdr,'data_use_warning');
%        case 'expt_karen' 
%            hdr.data_type = 'experimental';
%            hdr.data_use_warning = 'experimental';
%        case 'incubation'
%            hdr.data_type = 'experimental';
%            hdr.data_use_warning = 'experimental';
%        case 'cast'
%            hdr = rmfield(hdr,'data_use_warning');
    end
    comment5 = '! ';
    if strcmp(sampletype, 'discrete') % for this case, check for type and if concentrated'
        comment5 = ['! ' char(m.sample_type)];
        if strcmp(m.sample_type, 'cast')
            comment5 = [comment5 ' ' char(m.cast) ' Niskin ' num2str(m.niskin)];
        end
%        if strcmp(ship, 'process')
%            ind = strmatch(m.pid, meta_upload.filename);
%            if strcmp(m.sample_type, 'cast')
%                hdr.station = meta_upload.Tag4{ind};  %R2R event number
%            end
%            if ~isempty(meta_upload.comment1{ind})
%                comment5 = [comment5 '; ' meta_upload.comment1{ind}];
%            end
%        else %cast for ship = survey
            if strmatch(m.sample_type, 'cast')
                ind = find(strcmp(r2r.Instrument, 'CTD911') &  (str2num(char(m.cast)) == r2r.Cast) & ~strcmp(r2r.Action, 'other'));
                eventlist = strcat(r2r.R2R_Event(ind), ','); eventlist = strcat(eventlist{:}); eventlist = eventlist(1:end-1);
                hdr.r2r_event = eventlist;
                temp = regexprep(r2r.Station(ind), ' ', '');
                hdr.station = temp{end};
                if ~isequal(temp{:})%isequal(temp(ind(1)),temp(ind(2)))
                    disp('mismatched station info')
                    disp(temp)
                    disp(hdr.station)
                    keyboard
                end
            end
 %       end
    end
    if ~strcmp(m.sample_type, 'underway_discrete') && ~strcmp(m.sample_type, 'underway')
        hdr.measurement_depth = num2str(m.depth);
    end
    hdr.eventID = char(m.pid);
    disp(hdr.eventID)
    hdr.data_file_name = [hdr.experiment '-' hdr.cruise '_' cruise '_' sampletype '_IFCB_plankton_and_particles_' hdr.eventID([2:9 11:16]) '_R2.sb'];
    hdr.instrument_model = ['Imaging_FlowCytobot_IFCB' num2str(m.ifcb)];
    hdr.start_date = datestr(datenum(m.sample_time, 'yyyy-mm-dd HH:MM:ss+00:00'), 'yyyymmdd');
    hdr.end_date = hdr.start_date;
    hdr.start_time = [datestr(datenum(m.sample_time, 'yyyy-mm-dd HH:MM:ss+00:00'), 'HH:MM:ss') '[GMT]'];
    hdr.end_time = hdr.start_time;
    hdr.north_latitude = [num2str(m.latitude) '[DEG]'];
    hdr.south_latitude = hdr.north_latitude; 
    hdr.east_longitude = [num2str(m.longitude) '[DEG]'];
    hdr.west_longitude = hdr.east_longitude;
    hdr.volume_imaged_ml = num2str(m.ml_analyzed);
    hdr.associatedMedia_source = [urlbase char(m.pid) '.html'];
    f = fields(hdr);
    for eventlist = 1:length(f), hdrstr{eventlist} = ['/' f{eventlist} '=' hdr.(f{eventlist})]; end  
    
    if m.trigger_selection == 2
        comment4 = ['! IFCB trigger mode: chlorophyll fluorescence (PMTB)'];
    elseif m.trigger_selection == 3
        comment4 = ['! IFCB trigger mode: chlorophyll fluorescence (PMTB) OR side scattering (PMTA)'];
    else
        comment4 = ['!'];
    end
    
    hdrstr = ['/begin_header'; hdrstr(1:end-2)'; '!'; comment1; '!'; comment5; '!'; comment4; '!'; comment2; '!'; comment3; '!'; comment6; '!'; hdrstr(end-1:end)'; '/end_header'];
    outfullfile = [outpath hdr.data_file_name];
    writecell(hdrstr, outfullfile, 'FileType', 'text', 'QuoteStrings', false);
    clear hdrstr
    
    feafullname = [feabase hdr.eventID(1:5) filesep hdr.eventID(1:9) filesep hdr.eventID '_fea_v4.csv'];
    classfullname = [classbase hdr.eventID(1:5) filesep hdr.eventID(1:9) filesep hdr.eventID '_class.h5'];
    f = readtable(feafullname);
    c = load_class_scores(classfullname);
    [class_score,class_ind] = max(c.scores');
    class_label_data_provider = c.class_labels(class_ind);
    [~,label_ind] = ismember(class_label_data_provider, assessed_ID_table.data_provider_category_automated);
    outT = table;
    outT.associatedMedia = strcat(urlbase, hdr.eventID, '_', num2str(f.roi_number,'%05.0f'), '.html');
    outT.data_provider_category_automated = class_label_data_provider;
    outT.scientificName_automated = assessed_ID_table.scientificName_automated(label_ind);
    outT.scientificNameID_automated = assessed_ID_table.scientificNameID_automated(label_ind);
    outT.prediction_score_automated_category = class_score';
    outT.biovolume = round(f.Biovolume./(pixel_per_micron^3),3);
    outT.area = round(f.Area/(pixel_per_micron^2),3);
    outT.length = round(f.maxFeretDiameter/pixel_per_micron,3);
    outT.width = round(f.minFeretDiameter/pixel_per_micron,3);
    outT.esd = round((outT.biovolume/4*3/pi).^(1/3)*2,3);
    writetable(outT, outfullfile, 'WriteVariableNames', false, 'FileType', 'text', 'WriteMode', 'append')
end

