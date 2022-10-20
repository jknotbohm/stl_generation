% DESCRIPTION: This function file converts each fiber in the given network
% into a 3D triangulated mesh (STL file). Then it creates a python script to run on Blender's scripting environment where 
% the individual STL files are combined into a single object of disconnected fiber meshes, saved as merged_stl_file.stl  
% INPUT VARIABLES: 
% nodes_set_final: The list of nodes in the following format of row: [node#, x-coordinate, y-coordinate]
% el_set_final: List of fiber-connectivity in the 2D network where each row represents a fiber in the format: [fiber#, 1st node#, 2nd node#]
% w: Width of the fiber in the x-y plane
% h: Height of the fiber in z
% P: Destination folder 
% F: Destination subfolder to store the individual fiber meshes (F is in the destination folder P)
% Written by Mainak Sarkar, University of Wisconsin-Madison

function [] = stl_gen_lattice_network_recCS_Vup(nodes_set_final, el_set_final, w, h, P, F)

mkdir(P,F)
new = fullfile(P,F) ;

t = nodes_set_final(1:end,:) ;
[N_nodes, columns] = size(t) ;
t2 = [el_set_final(:,1), el_set_final(:,2), el_set_final(:,3)] ;
N_number = t(:,1) ;
x = t(:,2) ;
y = t(:,3) ; 

% generating the stl file for individual fibers
fiber_counter = 0 ;
nn = 0 ;
figure(1)
counter = 0 ;
counter1 = 0 ;
for i = 1:size(t2,1)
   fiber_counter = fiber_counter + 1 ;
   for j = 1:N_nodes
   if t2(i,2)==t(j,1)
       counter = counter + 1 ;
       X(counter,:) = [t(j,2) t(j,3)] ;
   end
   end
   for j = 1:N_nodes
   if t2(i,3)==t(j,1) 
       counter1 = counter1 + 1 ;
       Y(counter1,:) = [t(j,2) t(j,3)] ;
   end
   end
   
nN = 4 ; % refines mesh of each fiber
tT = linspace(0,1,nN+1)' ;
intpts = (1-tT) * X(counter,:) + tT * Y(counter1,:) ;

for ui = 1 : ( size(intpts,1) - 1 )
Xx = intpts(ui,:) ; Yy = intpts(ui+1,:) ;
ccc = prism(size(t2,1)) ;
cmapp = colormap(gca, ccc) ;
nidx = round((fiber_counter/size(t2,1))*length(cmapp)) ;
if nidx == 0 
    nidx = 1 ;
end
[Xa,Ya,Za] = recCSgen_fiber(w, h, [Xx 0], [Yy 0], cmapp, nidx) ;
nn = nn + 1 ; % calculates the number of fibers including sub-fibers
filename_reference = [new,'\fiber_no_',num2str(nn),'.stl'] ;
surf2stl(filename_reference,Xa,Ya,Za)
hold on 
end 
end

view(2)
daspect([1 1 1])
pbaspect([1 1 1])
axis off

%% generate the python script to run in blender-python console:
fiber_nos = nn ;
merged_stl_filename = 'merged_stl_file' ; % only finename / no extension is necesssary here

blender_python_script_gen_Vup(fiber_nos, P, new, merged_stl_filename) ;

 