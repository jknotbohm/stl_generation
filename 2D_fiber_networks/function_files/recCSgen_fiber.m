% DESCRIPTION: This function file converts the line fiber into a beam of
% rectangular cross-section w x h, which has width w in the x-y plane and height
% h (along z).
% INPUT VARIABLES: 
% w: Width of the fiber in the x-y plane
% h: Height of the fiber in z
% r1: coordinate of the first node in [x y z] format. Put z = 0 for the inplane
% network.
% r2: coordinate of the second node in [x y z] format. Put z = 0 for the inplane
% network.
% F: Destination subfolder to store the individual fiber meshes (F is in the destination folder P)
% cmapp, fiber_counter (not related to analysis): These are just used to make a representative
% visualiation of the network with each fibers of different colors in MATLAB once the code finishes its run.
% OUTPUT VARIABLES: 
% Xf, Yf, Zf: coordinate data for generating the surfaces of closed-ended
% beam representing each fiber.
% Written by Mainak Sarkar, University of Wisconsin-Madison

function [Xf, Yf, Zf] = recCSgen_fiber(w, h, r1,r2, cmapp, fiber_counter) 

num = atan(w/h) ;
theta = [num, pi-num, pi+num, (2*pi)-num, num+(2*pi)] ;
R = 0.5*sqrt(h^2+w^2) ;

m = length(R);                 
                                   
    if m == 1                      
        R = [R; R];                
        m = 2;                     
    end

    
    v=(r2-r1)/sqrt((r2-r1)*(r2-r1)');    %Normalized vector;

    
    x2=[0 0 1] ;     %orthonormal vector to v
    x3=cross(v,x2) ;
    x3=x3/sqrt(x3*x3') ;
    
    r1x=r1(1);r1y=r1(2);r1z=r1(3);
    r2x=r2(1);r2y=r2(2);r2z=r2(3);
    vx=v(1);vy=v(2);vz=v(3);
    x2x=x2(1);x2y=x2(2);x2z=x2(3);
    x3x=x3(1);x3y=x3(2);x3z=x3(3);
    
    time=linspace(0,1,m);
    for j = 1 : m
      t=time(j);
      X(j, :) = r1x+(r2x-r1x)*t+R(j)*cos(theta)*x2x+R(j)*sin(theta)*x3x; 
      Y(j, :) = r1y+(r2y-r1y)*t+R(j)*cos(theta)*x2y+R(j)*sin(theta)*x3y; 
      Z(j, :) = r1z+(r2z-r1z)*t+R(j)*cos(theta)*x2z+R(j)*sin(theta)*x3z;
    end
    

% designing the lids:
Xp1 = [X(5) X(7) X(5);
    X(1) X(3) X(1) ] ;
Yp1 = [Y(5) Y(7) Y(5) ;
    Y(1) Y(3) Y(1) ] ;
Zp1 = [Z(5) Z(7) Z(5);
    Z(1) Z(3) Z(1) ] ;

Xp2 = [X(2) X(4) X(2);
    X(6) X(8) X(6) ] ;
Yp2 = [Y(2) Y(4) Y(2) ;
    Y(6) Y(8) Y(6) ] ;
Zp2 = [Z(2) Z(4) Z(2) ;
    Z(6) Z(8) Z(6) ] ;


Xf = [X, Xp1, Xp2] ;
Yf = [Y, Yp1, Yp2] ;
Zf = [Z, Zp1, Zp2] ;

surf([X,Xp1,Xp2], [Y Yp1 Yp2], [Z Zp1 Zp2], 'FaceColor', cmapp(fiber_counter,:), 'FaceAlpha', 1, 'EdgeColor', [0 0 0]);
