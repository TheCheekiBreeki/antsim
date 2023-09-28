function theta = modArcTan(x, y)

%modArcTan Computes the arctangent of given x and y coordinates and returns corresponding angle in range from 0 to 2pi, rather than -pi/2 to pi/2
%   Inputs:
%       x : x position
%       y : y position
%   Outputs:
%       theta : arctan angle

theta = atan(y./x) ; % use Matlab command to compute arctangent (in range -pi/2 to pi/2)

if x < 0 % if negative x
    if y < 0 % if negative y, in quad III
        theta = pi + theta ; % rotate pi rad
    elseif y > 0 % if postive y, in quad II
        theta = pi + theta ; % rotate pi rad
    else % on x-axis, (-n, 0) for all n in R
        theta = pi ; % angle is pi
    end
else % positive x & x = 0
    % negative y, in quad IV & y-axis
        % Do Nothing
    % positve y, in quad I & y-axis
        % Do Nothing
    % on x-axis, (+n, 0) for all n in R
        % Do Nothing
end

theta = mod(theta+2*pi,2*pi) ; % ensure theta is in range 0 to 2pi

end