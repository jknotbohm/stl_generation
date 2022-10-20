% Main script to generate a STL file from a 3D network.
% This script considers fibers as beams of circular cross-section 
% Written by Mainak Sarkar, University of Wisconsin-Madison

clear all
clc

%% Input dimensions of fiber:
% input the desired radius of the circular cross section of fibers
% 
fiber_radius = 0.05 ; 

%% Create a primary folder and insert its address below:
P = 'D:\primary_folder_3Dnet_stl';

%% Load the nodes and elemensts of network from the primary folder:
load(('D:\primary_folder_3Dnet_stl\3D_Network_for_STL_30x30x30_Seed_1003.mat')) ;

nodes_set_final = [(1:1:size(nodes, 1))' , nodes] ;
el_set_final = [(1:1:size(fibers, 1))' , fibers] ;

%% Name the subfolder which will contain the individual fiber meshes 
Fstl = ['Voronoi_Network3D_for_STL_30x30x30_Seed_1003_date_', date, '_stlFiles'] ;

% Following function file generates a STL file containing a combined single object all fiber meshes
% mutually disconnected at the nodes
stl_gen_lattice_network_circleCS_3D_Vup(nodes_set_final, el_set_final, fiber_radius, P, Fstl)


