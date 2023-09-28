function [indicator] = CheckColonyProximity(x, y, colony_pos, colony_proximity_threshold)

%CheckColonyProximity Computes distance between ant and colony, if within range, ant drops food
%   Inputs:
%       x : ant's x position
%       y : ant's y position
%       colony_pos : colony position
%       colony_proximity_threshold : threshold to determine proximity
%   Outputs:
%       indicator : 0 if ant is near colony, 1 if not

dist = sqrt((colony_pos(1)-x)^2 + (colony_pos(2)-y)^2) ; % compute distance from ant to colony

if dist <= colony_proximity_threshold % if within range, drop food
    indicator = 0 ;
else % if out of range, keep food
    indicator = 1 ;
end

end