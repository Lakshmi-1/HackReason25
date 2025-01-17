% Facts
car_speed(30).                             % Current speed of the car (km/h)
traffic_signal(yellow).
stop_sign(absent). 
curr_time(day).
weather(icy).
railroad_gate(up).
want_to_turn(left).                        % Want to turn left
vehicle(opposite_lane, 35, sedan).
sign(-yeild).
police(absent).
ambulance(absent). 

% Rules
should_go :- 
    traffic_signal(green).                  % Go if the signal is green

should_go :- 
    traffic_signal(yellow), 
    car_speed(Speed), Speed > 40.           % Go if the signal is yellow and speed is greater than 40

should_go :- 
    railroad_gate(up).                      % Go if the railroad gate is up

should_stop :- 
    stop_sign(present).                     % Stop if there is a stop sign

should_stop :- 
    traffic_signal(red).                    % Stop if the signal is red

should_stop :- 
    railroad_gate(down).                    % Stop if the railroad gate is down

should_stop :-                              % Stop if the signal is yellow and speed is 40 or less
    (traffic_signal(yellow), 
    car_speed(Speed), Speed =< 40).

should_stop :- 
    police(present).                        % Stop if police are present

should_stop :- 
    ambulance(present).                     % Stop if ambulance is present

% Speed adjustment based on weather conditions
adjust_speed(Speed) :- 
    weather(icy), Speed is 20.              % Slow down to 20 km/h if icy
adjust_speed(Speed) :- 
    weather(snowy), Speed is 15.            % Slow down to 15 km/h if snowy
adjust_speed(Speed) :- 
    weather(foggy), Speed is 25.            % Slow down to visible speed if foggy
adjust_speed(Speed) :- 
    weather(rainy), Speed is 25.            % Slow down to visible speed if rainy

% Light control rules
turn_on_lights :- 
    curr_time(day).                              % Turn on lights if it is daytime

turn_off_lights :- 
    curr_time(night).                            % Turn off lights if it is nighttime


% Consolidated query for turning left with cut operator
query(left, Decision) :- 
    police(present),                        % Check if police are present
    Decision = stop,                        % Stop if police are present
    !.                                      % Cut: stop further evaluation

query(left, Decision) :- 
    ambulance(present),                     % Check if ambulance is present
    Decision = stop,                        % Stop if ambulance is present
    !.                                      % Cut: stop further evaluation

query(left, Decision) :- 
    traffic_signal(red),                    % Check if the traffic signal is red
    Decision = stop,                        % Stop if the signal is red
    !.                                      % Cut: stop further evaluation

query(left, Decision) :- 
    traffic_signal(yellow),                 % Check if the traffic signal is yellow
    car_speed(Speed), Speed > 40,           % If speed is above 40 km/h
    vehicle(opposite_lane, Distance, _),    % Check oncoming vehicle distance
    Distance < 3200,                        % If distance is less than 3200 meters
    Decision = go,                          % Proceed
    !.                                      % Cut: stop further evaluation

query(left, Decision) :- 
    vehicle(opposite_lane, Distance, _),    % Check for oncoming traffic
    Distance =< 30,                         % If oncoming traffic is within 30 meters
    Decision = stop,                        % Stop and wait
    !.                                      % Cut: stop further evaluation

query(left, Decision) :-
    railroad_gate(down),
    Decision = stop,
    !.

query(left, Decision) :-
    stop_sign(present),
    Decision = stop.
    !.

query(left, Decision) :- 
    vehicle(opposite_lane, Distance, _),    % Check for oncoming traffic
    Distance > 30,                          % If oncoming traffic is more than 30 meters away
    Decision = go.                          % Safe to proceed

    % Consolidated query for turning right with priority checks and cut operator
query(right, Decision) :- 
    police(present),                        % Check if police are present
    Decision = stop,                        % Stop if police are present
    !.                                      % Cut: stop further evaluation

query(right, Decision) :- 
    ambulance(present),                     % Check if ambulance is present
    Decision = stop,                        % Stop if ambulance is present
    !.                                      % Cut: stop further evaluation

query(right, Decision) :- 
    traffic_signal(red),                    % Check if the traffic signal is red
    Decision = stop,                        % Stop if the signal is red
    !.                                      % Cut: stop further evaluation

query(right, Decision) :- 
    traffic_signal(yellow),                 % Check if the traffic signal is yellow
    car_speed(Speed), Speed > 40,           % If speed is above 40 km/h
    vehicle(opposite_lane, Distance, _),    % Check oncoming vehicle distance
    Distance < 3200,                        % If distance is less than 3200 meters
    Decision = go,                          % Proceed
    !.                                      % Cut: stop further evaluation

query(right, Decision) :- 
    vehicle(opposite_lane, Distance, _),    % Check for oncoming traffic
    Distance =< 30,                         % If oncoming traffic is within 30 meters
    Decision = stop,                        % Stop and wait
    !. 

query(right, Decision) :-
    railroad_gate(down),
    Decision = stop,
    !.                                     % Cut: stop further evaluation

query(right, Decision) :-
    stop_sign(present),
    Decision = stop.
    !.

query(right, Decision) :- 
    vehicle(opposite_lane, Distance, _),    % Check for oncoming traffic
    Distance > 30,                          % If oncoming traffic is more than 30 meters away
    Decision = go.                          % Safe to proceed

% Consolidated query for going straight with priority checks and cut operator
query(straight, Decision) :- 
    police(present),                        % Check if police are present
    Decision = stop,                        % Stop if police are present
    !.                                      % Cut: stop further evaluation

query(straight, Decision) :- 
    ambulance(present),                     % Check if ambulance is present
    Decision = stop,                        % Stop if ambulance is present
    !.                                      % Cut: stop further evaluation

query(straight, Decision) :-
    stop_sign(present),
    Decision= stop.
    !.

query(straight, Decision) :- 
    traffic_signal(red),                    % Check if the traffic signal is red
    Decision = stop,                        % Stop if the signal is red
    !.                                      % Cut: stop further evaluation

query(straight, Decision) :- 
    traffic_signal(yellow),                 % Check if the traffic signal is yellow
    car_speed(Speed), Speed > 40,           % If speed is above 40 km/h
    vehicle(opposite_lane, Distance, _),    % Check oncoming vehicle distance
    Distance < 3200,                        % If distance is less than 3200 meters
    Decision = go,                          % Proceed
    !.                                      % Cut: stop further evaluation

query(straight, Decision) :-
    railroad_gate(down),
    Decision = stop,
    !.

query(straight, Decision) :-
    traffic_signal(green), 
    Decision = go.                          % Otherwise, proceed straight

% Query for speed adjustment based on weather conditions
query(speed, Speed) :- 
    weather(icy),                          % If the weather is icy
    Speed is 20,                           % Set speed to 20 km/h
    !.                                     % Cut: stop further evaluation

query(speed, Speed) :- 
    weather(snowy),                        % If the weather is snowy
    Speed is 15,                           % Set speed to 15 km/h
    !.                                     % Cut: stop further evaluation

query(speed, Speed) :- 
    weather(foggy),                        % If the weather is foggy
    Speed is 25,                           % Set speed to 25 km/h
    !.                                     % Cut: stop further evaluation

query(speed, Speed) :- 
    weather(rainy),                        % If the weather is rainy
    Speed is 30,                           % Set speed to 30 km/h
    !.                                     % Cut: stop further evaluation

% Query for lights based on time of day
query(lights, Status) :- 
    curr_time(night),                % If it's nighttime
    Status = on,                % Lights should be ON
    !.                          % Cut: stop further evaluation

query(lights, Status) :- 
    curr_time(day),                  % If it's daytime
    Status = off.               % Lights should be OFF

% Query for yield logic based on oncoming vehicles
query(yield, Decision) :- 
    vehicle(opposite_lane, Distance, _),  % Check for oncoming vehicles
    Distance =< 100,                      % If an oncoming vehicle is within 100 meters
    Decision = stop,                      % The car should stop
    !.                                    % Cut: stop further evaluation

query(yield, Decision) :- 
    Decision = go.                        % If no oncoming vehicles, proceed
