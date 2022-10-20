% Main script to generate a STL file from a 2D network.
% This script considers fibers as beams of rectangular cross-section with
% dimensions w x h (w is the width in the x-y plane and h is the height in z)
% Written by Mainak Sarkar, University of Wisconsin-Madison

clear all
clc

%% Input dimensions of fiber:
% input the desired width (w) and height (h) of the cross section of fibers
% (w is the width in the x-y plane and h is the height in z)
w = 0.5 ; 
h = 1.5 ; 

%% Create a primary folder and insert its address below:
P = 'D:\primary_folder_STL_generation';

%% Load the nodes and elemensts of network from the primary folder:
load(('D:\primary_folder_STL_generation\Voronoi_2DNetwork_data_NM_110x110_rho_0.036_pr_0.97.mat'), 'nodes_set_final' , 'el_set_final') ;

%% Name the subfolder which will contain the individual fiber meshes 
Fstl = ['Voronoi_2DNetwork_data_NM_110x110_rho_0.036_pr_0.97_date_', date, '_stlFiles'] ;

% Following function file generates a STL file containing a combined single object all fiber meshes
% mutually disconnected at the nodes
stl_gen_lattice_network_recCS_Vup(nodes_set_final, el_set_final, w, h, P, Fstl)


