% Format list of assessed classes for SeaBASS submission of CNN predictions
% for IFCB data, script for EXPORTS-NP
%
% Heidi M. Sosik, Woods Hole Oceanographic Institution
% April 2022

classpath = '\\sosiknas1\IFCB_products\EXPORTS\class\v3\20220225_EXPORTS_pacific_Dec2021_1_1\';
f = dir([classpath '\**\*.h5']);

classTable = load_class_scores(fullfile(f(1).folder, f(1).name));
assessed_ID_table = table;
assessed_ID_table.data_provider_category_automated = classTable.class_labels;
assessed_ID_table.scientificName_automated(1) = {''};
assessed_ID_table.scientificNameID_automated(1) = NaN;
obj = AphiaNameService;
WoRMSstr = 'urn:lsid:marinespecies.org:taxname:';

%%
classMap_provider2WoRMS = table;
classMap_provider2OtherNamespace = table;
%classMap_provider2WoRMS.data_provider_category_automated = {'Dinophyceae_morphotype_1' 'Dinophyceae_morphotype_2' 'Katodinium_or_Torodinium' 'Pyramimonas_morphotype1' 'Strombidium_morphotype1'...
%    'ciliate' 'coccolithophorid' 'colony' 'crescent' 'flagellate' 'mix' 'pennate' 'pennate_morphotype1' 'square_unknown' 'unknown3_squiggle'}';
%classMap_provider2WoRMS.data_provider_rename_automated = {'Dinophyceae' 'Dinophyceae' 'Dinophyceae' 'Pyramimonas' 'Strombidium'...
%    'Ciliophora' 'Prymnesiophyceae' 'Biota' 'Biota' 'Biota' 'Biota' 'Bacillariophyceae' 'Bacillariophyceae' 'Bacillariophyceae' 'Dinophyceae'}';
classMap_provider2WoRMS.data_provider_category_automated = {'Dinophyceae_morphotype_1' 'Dinophyceae_morphotype_2' 'Katodinium_or_Torodinium' 'Pyramimonas_morphotype1' 'Strombidium_morphotype1'...
    'ciliate' 'coccolithophorid' 'colony' 'crescent' 'pennate' 'pennate_morphotype1' 'square_unknown' 'unknown3_squiggle'}';
classMap_provider2WoRMS.data_provider_rename_automated = {'Dinophyceae' 'Dinophyceae' 'Dinophyceae' 'Pyramimonas' 'Strombidium'...
    'Ciliophora' 'Prymnesiophyceae' 'Biota' 'Biota' 'Bacillariophyceae' 'Bacillariophyceae' 'Bacillariophyceae' 'Dinophyceae'}';
classMap_provider2OtherNamespace.data_provider_category_automated = {'detritus' 'detritus_clear' 'fecal_pellet' 'mix' 'flagellate'}';
classMap_provider2OtherNamespace.data_provider_rename_automated = {'ptwg:detritus' 'whoi-plankton:detritus_clear' 'ptwg:fecal_pellet' 'whoi-plankton:nanoplankton_mix' 'whoi-plankton:flagellate' }';
%% **We should change Radiozoa to Rhizaria**

%%
for ii = 1:size(assessed_ID_table,1)
    disp(ii)
    %assessed_ID_table.scientificNameID_automated(ii) = getAphiaID(obj, assessed_ID_table.data_provider_category_automated{ii}, 'marine_only');
    temp = webread(['https://www.marinespecies.org/rest/AphiaIDByName/' assessed_ID_table.data_provider_category_automated{ii} '?marine_only=true']);
    if ~isempty(temp)
        assessed_ID_table.scientificNameID_automated(ii) = temp;
    else
    %if isnan(assessed_ID_table.scientificNameID_automated(ii)) 
        % check for rename entry
        iii = find(strcmp(assessed_ID_table.data_provider_category_automated{ii},classMap_provider2WoRMS.data_provider_category_automated));
        if ~isempty(iii)
            %assessed_ID_table.scientificNameID_automated(ii) = getAphiaID(obj,classMap_provider2WoRMS.data_provider_rename_automated{iii}, 'marine_only');
            assessed_ID_table.scientificNameID_automated(ii) = webread(['https://www.marinespecies.org/rest/AphiaIDByName/' classMap_provider2WoRMS.data_provider_rename_automated{iii} '?marine_only=true']);
        end
    end
    %%
    for ii = 1:size(assessed_ID_table,1)
        if assessed_ID_table.scientificNameID_automated(ii) % these are from WoRMS
            %    assessed_ID_table.scientificName_automated{ii} = [WoRMSstr getAphiaNameByID(obj,assessed_ID_table.scientificNameID_automated(ii))];
                assessed_ID_table.scientificName_automated{ii} = webread(['https://www.marinespecies.org/rest/AphiaNameByAphiaID/' num2str(assessed_ID_table.scientificNameID_automated(ii))]);
        else %get cases in ptwg or whoi-plankton
            iii = find(strcmp(assessed_ID_table.data_provider_category_automated{ii},classMap_provider2OtherNamespace.data_provider_category_automated));
            if ~isempty(iii)
                assessed_ID_table.scientificName_automated(ii) = classMap_provider2OtherNamespace.data_provider_rename_automated(iii);
            end
        end      
    end
    %%
end
notes = 'created with make_SB_assessed_ID_table.m';
save('C:\work\EXPORTS\assessed_ID_table', 'assessed_ID_table', 'notes')
writetable(assessed_ID_table, 'C:\work\EXPORTS\automated_assessed_id_EXPORTSNP_IFCB125.txt', 'WriteVariableNames', false, 'FileType', 'text', 'WriteMode', 'append')

%
%    