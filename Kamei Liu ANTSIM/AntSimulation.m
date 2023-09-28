%{

    CEEE M20 - Introduction to Computer Programming with Matlab
    Final Project
    Ant Simulation
    Justin Kamei
    905956219
    Richard Liu
    705916719

%}

% Housekeeping ...

clear
clc
close all


% Set Random Seed

seed = 1111 ;
rng(seed) ;


% Load Map

map = input("Enter Map Number to Analyze: ") ; % allows user to select map number
while (1) % ensures map is an integer between 1 and 3
    if map < 1 || map > 3 || mod(map,1)~=0
        map = input("Please Enter an Integer between 1 and 3: ") ;
    else
        break
    end
end
disp("Thank you, please wait.") ;

switch map
    case 1 % load settings for map 1
        walls = [] ; % create empty matrix for walls
        load("map1.mat", "T", "colony_pos", "colony_proximity_threshold", "food_proximity_threshold", "food_sources", "map_coordinates", "n_ants") ;
        dBlue = (25)^-1 ;
        dRed = (25)^-1 ;
        rSmell = 20 ;
        sigPhi2 = pi/4 ;
    case 2 % load settings for map 2
        walls = [] ; % create empty matrix for walls
        load("map2.mat", "T", "colony_pos", "colony_proximity_threshold", "food_proximity_threshold", "food_sources", "map_coordinates", "n_ants") ;
        dBlue = (25)^-1 ;
        dRed = (25)^-1 ;
        rSmell = 20 ;
        sigPhi2 = pi/4 ;
    case 3 % load settings for map 3
        load("map3_ExtraCredit.mat", "T", "colony_pos", "colony_proximity_threshold", "food_proximity_threshold", "food_sources", "map_coordinates", "n_ants", "walls") ;
        dBlue = (28)^-1 ;
        dRed = (28)^-1 ;
        rSmell = 16 ;
        sigPhi2 = pi/6 ;
end

% constant parameters between maps
sigPhi1 = sigPhi2 / 4 ;
vel = 1 ;

%{
dBlue   = decrease in concetration of blue pheromone
dRed    = decrease in concentration of red pheromone
rSmell  = smell diameter
sigPhi1 = max random rotation if ant find pher (rad)
sigPhi2 = max random rotation if ant not find pher (rad)
vel     = ants move vel units per timestamp
%}


% Fixed Parameters

posColony = colony_pos ; % center of colony
rColony = colony_proximity_threshold ; % distance for colony sensing
rFood = food_proximity_threshold ; % distance for food sensing
posFood = [food_sources, ones(size(food_sources,1),1)*n_ants*1e5] ; % locations of food (3rd column modified to be pheromones)
posMap = map_coordinates ; % map limits
N = n_ants ; % total number of ants
T ; % total timestamps
posWalls = walls ; % walls


% Initialize Ants

xAnts = ones(N,1) * posColony(1) ; % x positions
yAnts = ones(N,1) * posColony(2) ; % y positions
phiAnts = rand(N,1)*2*pi; % angles
foodAnts = zeros(N,1) ; % food boolean (1 if has food, 0 if does not have food)


% Initialize Pheromones

posPherRed = [] ; % columns 1&2 are position, column 3 is concentration (red is drop by ant with food)
posPherBlue = [] ; % columns 1&2 are position, column 3 is concentration (blue is drop by ant without food)

colPherBlue = [posColony(1), posColony(2), N*1e8] ; % designate colony blue pheromone


% Create Circle for Plotting Colony

theta = linspace(0, 2*pi, 1e3) ;
xcirc = posColony(1) + rColony*cos(theta) ;
ycirc = posColony(2) + rColony*sin(theta) ;


% Colony Food Counter Variable

colFoodCounter = 0 ;


% Preamble (Video and Figure Initiation)

s = date ;
videoFile = VideoWriter(s(10:11) + "" + s(4:6) + "" + s(1:2) + "_Map" + map + "_Kamei_905956219_Liu_705916719_AntSimulationVideo.mp4", 'MPEG-4') ;
videoFile.FrameRate = 30 ;
open(videoFile) ;

figure('NumberTitle', 'off', 'Name', "Figure " + 1 + " | Seed #" + seed) ;


% Main Simulation

for i = 1:1:T % for each timestamp


    % Update Pheromone Concentrations

    [posPherRed] = PheromonesUpdate(posPherRed, dRed) ;
    [posPherBlue] = PheromonesUpdate(posPherBlue, dBlue) ;


    for j = 1:1:N % for each ant


        % Designate Matrix for ALL Blue Pheromones

        totPherBlue = colPherBlue ;
        totPherBlue = [totPherBlue ; posPherBlue] ;

        % Designate Matrix for ALL Red Pheromones

        totPherRed = posFood ;
        totPherRed = [totPherRed ; posPherRed] ;


        % Compute New Angle

        if foodAnts(j) == 1 % if ant has food, look for Blue Pheromones
            phiAnts(j) = ComputeNewAngle(xAnts(j), yAnts(j), phiAnts(j), totPherBlue, rSmell/2, sigPhi1, sigPhi2) ;
        elseif foodAnts(j) == 0 % if ant does not have food, look for Red Pheromones
            phiAnts(j) = ComputeNewAngle(xAnts(j), yAnts(j), phiAnts(j), totPherRed, rSmell/2, sigPhi1, sigPhi2) ;
        end


        % Validate Movement

        [xAnts(j), yAnts(j), phiAnts(j)] = MovementValidationExecution(xAnts(j), yAnts(j), phiAnts(j), vel, posMap, posWalls) ;


        % Pick Up or Drop Off Food

        if foodAnts(j) == 0 % if ant does not have food, look for food
            [posFood, foodAnts(j)] = CheckFoodProximity(xAnts(j), yAnts(j), posFood, rFood) ;
            if foodAnts(j) == 1 % if the ant picks up food, rotate pi rad
                phiAnts(j) = mod(phiAnts(j)+pi,2*pi) ;
            end
        elseif foodAnts(j) == 1 % if ant has food, look for colony
            [foodAnts(j)] = CheckColonyProximity(xAnts(j), yAnts(j), posColony, rColony) ;
            if foodAnts(j) == 0 % if ant drops off food, rotate pi rad & advance food counter by 1
                phiAnts(j) = mod(phiAnts(j)+pi,2*pi) ;
                colFoodCounter = colFoodCounter + 1 ;
            end
        end


        % Drop Pheromone

        if foodAnts(j) == 0 % if the ant does not have food, drop Blue Pheromone
            posPherBlue = [posPherBlue ; xAnts(j), yAnts(j), 1] ;
        elseif foodAnts(j) == 1 % if ant has food, drop Red Pheromone
            posPherRed = [posPherRed ; xAnts(j), yAnts(j), 1] ;
        end
        
    end
    

    % Plot Everything

    grid on % turn grid on
    fill(xcirc,ycirc,'y') ; % plot colony
    hold on % hold plot

    if size(posFood,1) > 0 % if there is food left, plot them
        plot(posFood(:,1), posFood(:,2), '^m') ;
    end

    % set plot limits
    xlim([posMap(1), posMap(3)]) ;
    ylim([posMap(2), posMap(4)]) ;

    title("Ant Simulation, Timestamp: " + i + " [s] | Food in Colony: " + colFoodCounter) ; % title plot
    pbaspect([1, 1, 1]) ; % set aspect ratio to 1
        
    if size(posPherRed,1) > 0 % if there are red pheromones, plot them
        plotpherred = scatter(posPherRed(:,1), posPherRed(:,2), 6, 'r', 'filled') ;
        plotpherred.AlphaData = posPherRed(:,3) ;
        plotpherred.MarkerFaceAlpha = 'flat' ;
    end

    if size(posPherBlue,1) > 0 % if there are blue pheromones, plot them
        plotpherblue = scatter(posPherBlue(:,1), posPherBlue(:,2), 6, 'b', 'filled') ;
        plotpherblue.AlphaData = posPherBlue(:,3) ;
        plotpherblue.MarkerFaceAlpha = 'flat' ;
    end

    plot(xAnts, yAnts,'k*') ; % plot ants
        
    for k = 1:1:size(posWalls,1) % plot walls
        fill([posWalls(k,1), posWalls(k,1), posWalls(k,3), posWalls(k,3)], [posWalls(k,2), posWalls(k,4), posWalls(k,4), posWalls(k,2)],'k') ;
    end

    hold off % do not hold plot


    % Save Frame to Video

    capturedFrame = getframe(gcf) ;
    writeVideo(videoFile, capturedFrame) ;

    
end


% Close Video File

close(videoFile) ;


% Display Settings and Results

disp(" ") ;
disp("Parameters Used:") ;
disp("dBlue = " + dBlue) ;
disp("dRed = " + dRed) ;
disp("rSmell = " + rSmell) ;
disp("sigPhi1 = " + sigPhi1) ;
disp("sigPhi2 = " + sigPhi2) ;
disp("vel = " + vel) ;

disp(" ") ;
disp("Percentage of Food Obtained: ") ;
fprintf("%3.2f %%\n", (size(food_sources,1)-size(posFood,1))/size(food_sources,1)*100) ;
disp("Percentage of Food in Colony: ") ;
fprintf("%3.2f %%\n", colFoodCounter/size(food_sources,1)*100) ;
