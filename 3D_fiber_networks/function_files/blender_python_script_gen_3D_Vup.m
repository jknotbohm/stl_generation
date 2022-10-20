% DESCRIPTION: This function generates a python script which has to be run on the
% Blender-Python console to obtain the STL file for the entire
% network, which is a single object of disconnected fiber meshes, ready to be
% combined on Netfabb (Autodesk) software.
% INPUT: 
% fiber_nos: Serial number of fiber (if fiber mesh is further refined, it considers that number in the serial counting)
% P: The primary folder initialized in
% the main script named as 'primary_folder_3Dnet_stl'
% folder: The subfolder within which STL meshes of fibers will be saved.
% merged_stl_fileneme: The file name of the merged object.
% OUTPUT: The python script is saved in the primary folder P initialized in
% the main script named as 'primary_folder_3Dnet_stl'
% Written by Mainak Sarkar, University of Wisconsin-Madison

function [] = blender_python_script_gen_3D_Vup(fiber_nos, P, folder, merged_stl_fileneme)

clear A

A{1} = ['import os'] ;
A{2} = ['import bpy'] ;

A{3} = ['bpy.ops.object.select_all(action=','"','SELECT")'] ;
A{4} = ['bpy.ops.object.delete()'] ;

for gh = 1 : fiber_nos
str = join(strcat(folder,'/fiber_no_', char(string(gh)), '.stl')) ;
f = char(str) ;
A{5+gh} = ['bpy.ops.import_mesh.stl(filepath="',f ,'",','filter_glob="*.stl",files=[{"name": "fiber_no_',char(string(gh)),'.stl"}],directory="',folder,'/")'] ;
char(A{5+gh}) ;
end

gh = 5 + gh ; 

%% merging and exporting the final STL file

A{5 + gh + 1} = join(["bpy.ops.object.select_all(action=","'SELECT')"]) ;
char(A{5 + gh + 1}) ;

A{5 + gh + 2} = join("bpy.ops.object.join()") ;
char(A{5 + gh + 2}) ;

path_stl = [folder, '/', merged_stl_fileneme] ;
addem_str = char(["'OFF', axis_forward='Y', axis_up='Z')"]) ;
addem_str= addem_str(~isspace(addem_str));
A{5 + gh + 3} = ['bpy.ops.export_mesh.stl(filepath="',path_stl,'.stl", check_existing=True, filter_glob="', merged_stl_fileneme,'.stl", use_selection=False, global_scale=1.0, use_scene_unit=False, ascii=False, use_mesh_modifiers=True, batch_mode=',char(addem_str)]  ; 


% Write cell A into txt
fclose('all') ;
if exist([P,'\model_gen_script_blender_console.py'], 'file')==2
  delete([P,'\model_gen_script_blender_console.py']);
end
fid = fopen([P,'\model_gen_script_blender_console.py'], 'w');

for i = 1:(numel(A))
    fprintf(fid,'%s\n', A{i});
end

