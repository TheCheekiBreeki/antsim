function [angle] = ComputeNewAngle(x, y, angle, pher, r_smell, sigma1, sigma2)

%ComputeNewAngle Computes new angle for ants to face based on pheromones it senses
%   Detailed Functionality:
%       if no pheromones, change angle randomly according to sigma2
%       compute pheromones position relative to ant and relative distance
%       compute pheromone angles relative to x axis, then relative to ant
%       filter out unavailable pheromones, if no available, angle changes slightly at random
%       compute weighted average of pheromone positions and new angle
%       towards that
%   Inputs:
%       x : ant's x position
%       y : ant's y position
%       angle : ant's angle
%       pher : list of pheromones and respective concentrations
%       r_smell : smell threshold
%       sigma1 : maximum random rotation if discover pheromones
%       sigma2 : maximum random rotation if does not discover pheromones
%   Outputs:
%       angle : new ant facing angle

if size(pher,1) > 0 % if there are pheromones

    % initialize new matrices
    phernew = zeros(size(pher,1),3) ;
    dist = zeros(size(pher,1),1) ;
    ang = zeros(size(pher,1),1) ;
    phernew2 = [] ;

    for i = 1:1:size(pher,1) % iterate through all rows of pher

        % compute relative position
        phernew(i,1) = pher(i,1) - x ;
        phernew(i,2) = pher(i,2) - y ;
        phernew(i,3) = pher(i,3) ;

        dist(i) = sqrt( phernew(i,1)^2 + phernew(i,2)^2 ) ; % compute distance from ant
        ang(i) = modArcTan(phernew(i,1), phernew(i,2)) ; % compute angle with respect to x axis
        dtheta = mod(ang(i) - angle + 2*pi, 2*pi) ; % compute difference in angle (in range from 0 to 2pi)

        boole = dtheta < pi/2 || dtheta > 3*pi/2 ; % boolean if pheromone angle is within angle range
        
        if boole && dist(i) <= r_smell % if pheromone within angle range and distance range, add pheromone to list of sensed pheromones and advance acceptable pheromone counter by 1
            phernew2 = [phernew2 ; phernew(i,:)] ;
        end
        
    end
    
    if size(phernew2,1) > 0 % if there are acceptable pheromones, compute weighted average and new angle
        
        sumWeigh = sum(phernew2(:,3)) ; % sum the pheromone weights

        sumX = sum(phernew2(:,3).*phernew2(:,1)) ; % sum the weighted x positions
        sumY = sum(phernew2(:,3).*phernew2(:,2)) ; % sum the weighted y positions

        avgX = sumX / sumWeigh ; % compute weighted average x position
        avgY = sumY / sumWeigh ; % compute weighted average y position

        angle = modArcTan(avgX, avgY) ; % compute new angle towards weighted position

        angle = mod(angle + (2*rand(1)-1)*sigma1 + 2*pi, 2*pi) ; % modify angle by sigma1 parameter

    else % if there are no acceptable angles, modify angle by sigma2 parameter

        angle = mod(angle + (2*rand(1)-1)*sigma2 + 2*pi, 2*pi) ;

    end

else % if there are no pheromones, modify angle by sigma2 parameter

    angle = mod(angle + (2*rand(1)-1)*sigma2 + 2*pi, 2*pi) ;

end


end