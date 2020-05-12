function valid=is_valid_state(x,x_dot,theta,theta_dot)

one_degree=0.0174532;	% 2pi/360 */
six_degrees=0.1047192;
twelve_degrees=0.2094384;
fifty_degrees=0.87266;

valid=1;
if (x < -2.4 | x > 2.4  | theta < -twelve_degrees | theta > twelve_degrees)  
    valid=-1;
end
    