function [x_new, y_new, angle] = MovementValidationExecution(x, y, angle, speed, allowed, forbidden)

%MovementValidationExecution Computes new ant position, chekcs if valid to return new position, and if not, only rotates by pi rad
%   Inputs:
%       x : ant's x position
%       y : ant's y position
%       angle : ant's angle
%       speed : speed at which ants move
%       allowed : matrix containing lower left and upper right corners of the map (1 row and 4 columns)
%       forbidden : matrix containing lower left and upper right corners of walls (N rows and 4 columns)
%   Outputs:
%       x_new : ant's new x position
%       y_new : ant's new y position
%       angle ; ant's facing angle

% compute new position
x_new = x + speed*cos(angle) ;
y_new = y + speed*sin(angle) ;

% check map boundaries
if x_new <= allowed(1) || y_new <= allowed(2) || x_new >= allowed(3) || y_new >= allowed(4) % if outside of boundaries, reset position and rotate pi rad
    angle = mod(angle + pi, 2*pi) ;
    x_new = x ;
    y_new = y ;
end

% check wall boundaries
N = size(forbidden,1) ;
if N > 0 % if there are walls
    for i = 1:1:N % for each wall
        if x_new >= forbidden(i,1) && x_new <= forbidden(i,3) && y_new >= forbidden(i,2) && y_new <= forbidden(i,4) % new position is inside wall, reset position and rotate pi rad
            angle = mod(angle + pi, 2*pi) ;
            x_new = x ;
            y_new = y ;
        end
    end
end

end
