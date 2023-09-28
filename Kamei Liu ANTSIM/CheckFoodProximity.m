function [food_sources, indicator] = CheckFoodProximity(x, y, food_sources, food_proximity_threshold)

%CheckFoodProximity Computes distance between ant and all food sources, if closest food source is within range, pick up and remove from list
%   Inputs:
%       x : ant's x position
%       y : ant's y position
%       food_sources : list of all food sources
%       food_proximity_threshold : threshold to determine proximity
%   Outputs:
%       food_sources : updated list of food sources
%       indicator : 1 if ant is near food, 0 if not

if size(food_sources,1) > 0 % if there are food sources

    dist = sqrt((food_sources(:,1)-x).^2 + (food_sources(:,2)-y).^2) ; % compute distance between ant and each food source

    % initialize minimum distance and index
    minDist = dist(1) ;
    minIndex = 1 ;

    for i = 1:1:length(dist) % for each distance
        if dist(i) < minDist % if the distance is smaller than the minimum distance, set new minimum and record index
            minDist = dist(i) ;
            minIndex = i ;
        end
    end

    if minDist <= food_proximity_threshold % if minimum distance is within range, remove indexed food from list and set indicator to 1
        food_sources(minIndex,:) = [] ;
        indicator = 1 ;
    else % if not within range, set indicator to 0
        indicator = 0 ;
    end

else % if there are no food sources, set indicator to 0

    indicator = 0 ;

end
