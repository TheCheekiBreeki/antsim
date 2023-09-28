function [pher] = PheromonesUpdate(pher, decay)

%PheromonesUpdate Decreases pheromone concentration by set amount, and if below 0, removes pheromone from list
%   Inputs:
%       pher : list of pheromones and respective concentrations
%       decay : rate of decay
%   Outputs:
%       pher : list of modified pheromones and repsective concentrations

if size(pher,1) > 0 % if there are pheromones
    
    pher(:,3) = pher(:,3) - decay ; % decrease pheromone concentrations

    i = 1 ; % initiate counter

    while (1) % until broken
        if pher(i,3) <= 0 % if pheromone concentration is less than or equal to 0, remove pheromone from list
            pher(i,:) = [] ;
        else % otherwise, advance counter by 1
            i = i + 1 ;
        end
    
        if i > size(pher,1) % if counter is beyond the number of pheromones in the list, break loop
            break
        end
    end

end

end
