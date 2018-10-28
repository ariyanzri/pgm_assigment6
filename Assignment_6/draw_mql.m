%  draw_mql  Renders an MQL creatrure
%
%  Input:
%     Most arguments are angles which are descretized into num_angles and thus
%     ar represented by an integer between 1 and num_angles. The number of
%     possible angles, num_angles, must be odd, and the unique central index
%     corresponds to the bisector (e.g., 45 degrees) with respect to the
%     relavent quadrant. 
%
%     num_angles = Number of allowable angles which must be an odd integer. 
%                  For the current version of the assignment, this should be 9.
%                  This sets the range of  the discretized angles which must be
%                  in 1:num_angles.
%
%     angle_step = The differnce between two successive angles. In the current
%                  version of the assignmet, this is 15 degress. 
%
%     shape   =    Set to 1 if the body is a circle, 0 for a hexagon
%     riaa    =    The inner angle for the right arm. 
%     rila    =    The inner angle for the right leg. 
%     liaa    =    The inner angle for the left arm. 
%     lila    =    The inner angle for the left leg. 
%     roaa    =    The outer angle for the right arm. 
%     rola    =    The right leg outer angle.
%     loaa    =    The left arm outer angle. 
%     lola    =    The left leg outer angle.
%
%   Output:
%      figure_handle, a handle to the figure where the MQL creature was
%      rendered. Use functions close to close the figure, and saveas
%      to save it as an image.
%
%   Credit: 
%        This implementation is based heavily on code written by Luca del Pero, class of 2011. 

function [figure_handle] = draw_mql(num_angles, angle_step, shape , riaa, rila, liaa, lila, roaa, rola, loaa, lola)

    if(riaa < 1 || riaa > num_angles)
        display('Error, riaa must be between 1 and num_angles');
        return;
    end
    
    if(rila < 1 || rila > num_angles)
        display('Error, rila must be between 1 and num_angles');
        return;
    end
    
    if(liaa < 1 || liaa > num_angles)
        display('Error, liaa must be between 1 and num_angles');
        return;
    end
    
    if(lila < 1 || lila > num_angles)
        display('Error, lila must be between 1 and num_angles');
        return;
    end
    
    if(roaa < 1 || roaa > num_angles)
        display('Error, roaa must be between 1 and num_angles');
        return;
    end
    
    if(rola < 1 || rola > num_angles)
        display('Error, rola must be between 1 and num_angles');
        return;
    end
    
    if(loaa < 1 || loaa > num_angles)
        display('Error, loaa must be between 1 and num_angles');
        return;
    end
    
    if(lola < 1 || lola > num_angles)
        display('Error, lola must be between 1 and num_angles');
        return;
    end
    
    if(shape < 0 || shape > 1)
        display('Error, shape must be either 0 or 1');
        return;
    end

    angle_step_rad = angle_step * pi / 180; 

    figure_handle = figure();

    riaa_rad = (1/4) * pi + bins_to_rad(num_angles, angle_step_rad, riaa);
    rila_rad = (7/4) * pi + bins_to_rad(num_angles, angle_step_rad, rila);

    liaa_rad = (3/4) * pi + bins_to_rad(num_angles, angle_step_rad, liaa);
    lila_rad = (5/4) * pi + bins_to_rad(num_angles, angle_step_rad, lila);

    roaa_rad = (1/4) * pi + bins_to_rad(num_angles, angle_step_rad, roaa);
    rola_rad = (7/4) * pi + bins_to_rad(num_angles, angle_step_rad, rola);

    loaa_rad = (3/4) * pi + bins_to_rad(num_angles, angle_step_rad, loaa);
    lola_rad = (5/4) * pi + bins_to_rad(num_angles, angle_step_rad, lola);

    limb_radius_x = 1.0;
    limb_radius_y = 0.4;
    plot(-5,-5);
    hold on
    axis square off
    plot(5,5);
    plot(-5,5);
    plot(5,-5);

    if shape == 1
        radius_body = 1;
        myEllipse(0,0,1,0,radius_body,radius_body,[0.5,0.5,0.5]);
    else
        t = (1/12:1/6:1)'*2*pi;
        x = (1.2)*sin(t);
        y = (1.2)*cos(t);
        fill(x,y,[0.5,0.5,0.5]);
        axis square
    end

    contact_riaa_rad_x = 1/sqrt(2);
    contact_riaa_rad_y = 1/sqrt(2);
    vertex_x = -limb_radius_x;
    dx = vertex_x - vertex_x*cos(riaa_rad);
    dy = -vertex_x*sin(riaa_rad);
    myEllipse(contact_riaa_rad_x+limb_radius_x + dx,contact_riaa_rad_y + dy, 1,riaa_rad,limb_radius_x,limb_radius_y,[1.0,1.0,0.0]);

    vertex_x = limb_radius_x;
    contact_roaa_rad_x = vertex_x*cos(riaa_rad) + contact_riaa_rad_x + limb_radius_x + dx;
    contact_roaa_rad_y = vertex_x*sin(riaa_rad) + contact_riaa_rad_y + dy;
    vertex_x = -limb_radius_x;
    dx = vertex_x - vertex_x*cos(roaa_rad);
    dy = -vertex_x*sin(roaa_rad);
    myEllipse(contact_roaa_rad_x+limb_radius_x + dx,contact_roaa_rad_y + dy, 1,roaa_rad,limb_radius_x,limb_radius_y,[1.0,0.0,1.0]);

    contact_liaa_rad_x = -1/sqrt(2);
    contact_liaa_rad_y = 1/sqrt(2);
    vertex_x = limb_radius_x;
    dx = vertex_x + vertex_x*cos(liaa_rad);
    dy = vertex_x*sin(liaa_rad);
    myEllipse(contact_liaa_rad_x - limb_radius_x + dx,contact_liaa_rad_y  + dy,1,liaa_rad,limb_radius_x,limb_radius_y,[1.0,1.0,0.0]);
    vertex_x = -limb_radius_x;
    contact_loaa_rad_x = -vertex_x*cos(liaa_rad) + contact_liaa_rad_x - limb_radius_x + dx;
    contact_loaa_rad_y = -vertex_x*sin(liaa_rad) + contact_liaa_rad_y + dy;
    vertex_x = limb_radius_x;
    dx = vertex_x +vertex_x*cos(loaa_rad);
    dy = vertex_x*sin(loaa_rad);
    myEllipse(contact_loaa_rad_x-limb_radius_x + dx,contact_loaa_rad_y + dy, 1,loaa_rad,limb_radius_x,limb_radius_y,[1.0,0.0,1.0]);
    contact_rila_rad_x = 1/sqrt(2);
    contact_rila_rad_y = -1/sqrt(2);
    vertex_x = -limb_radius_x;
    vertex_y = 0;
    dx = vertex_x - vertex_x*cos(rila_rad);
    dy = -vertex_x*sin(rila_rad);
    myEllipse(contact_rila_rad_x+limb_radius_x + dx,contact_rila_rad_y + dy, 1,rila_rad,limb_radius_x,limb_radius_y,[1.0,0.0,0.0]);
    vertex_x = limb_radius_x;
    contact_rola_rad_x = vertex_x*cos(rila_rad) + contact_rila_rad_x + limb_radius_x + dx;
    contact_rola_rad_y = vertex_x*sin(rila_rad) + contact_rila_rad_y + dy;
    vertex_x = -limb_radius_x;
    dx = vertex_x - vertex_x*cos(rola_rad);
    dy = -vertex_x*sin(rola_rad);
    myEllipse(contact_rola_rad_x+limb_radius_x + dx,contact_rola_rad_y + dy, 1,rola_rad,limb_radius_x,limb_radius_y,[0.0,1.0,0.0]);


    contact_lila_rad_x = -1/sqrt(2);
    contact_lila_rad_y = -1/sqrt(2);
    vertex_x = limb_radius_x;
    dx = vertex_x + vertex_x*cos(lila_rad);
    dy = vertex_x*sin(lila_rad);
    myEllipse(contact_lila_rad_x - limb_radius_x + dx,contact_lila_rad_y  + dy,1,lila_rad,limb_radius_x,limb_radius_y,[1.0,0.0,0.0]);
    vertex_x = -limb_radius_x;
    contact_lola_rad_x = -vertex_x*cos(lila_rad) + contact_lila_rad_x - limb_radius_x + dx;
    contact_lola_rad_y = -vertex_x*sin(lila_rad) + contact_lila_rad_y + dy;
    vertex_x = limb_radius_x;
    dx = vertex_x +vertex_x*cos(lola_rad);
    dy = vertex_x*sin(lola_rad);
    myEllipse(contact_lola_rad_x-limb_radius_x + dx,contact_lola_rad_y + dy, 1,lola_rad,limb_radius_x,limb_radius_y,[0.0,1.0,0.0]);

    %imresize(figure_handle, 0.5);
end


function myEllipse(x0,y0,dilation,rotation,rx,ry, thecolor) % x0, y0: coordinates of center point % rx, ry: radii in x and y directions
    % Part I: Compute ellipse with axes parallel to % x and y axes and center at (0, 0)
    delt = 2*pi/30;	
    t = 0:delt:2*pi; x=rx*cos(t);	
    y = ry*sin(t);
    % Translate, dilate and rotate the ellipse
     xxxx= x0 + dilation*(cos(rotation)*x-sin(rotation)*y); 
     yyyy=y0 + dilation*(sin(rotation)*x+cos(rotation)*y); 
     thandle = plot(xxxx,yyyy,'k-');
     thandle = fill(xxxx,yyyy,thecolor);
end


function angle = bins_to_rad(num_angles, angle_step_rad, i)
    angle = angle_step_rad * (i - 1 - (num_angles - 1)/2); 
end

