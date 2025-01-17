% Facts
car_speed(30).                             % Current speed of the car (km/h)
car_braking_distance(3500).                % Minimum safe braking distance (meters)
traffic_signal(green).
stop_sign(absent). 
time(day).
weather(icy).
railroad_gate(up).
want_to_turn(right).
vehicle(opposite_lane, 35, sedan).
sign(-yeild).
police(absent).
ambulance(present).

                 
% Rules
should_go :- 
    traffic_signal(green).                  % Go if the signal is green

should_go :- 
    traffic_signal(yellow), 
    car_speed(Speed), Speed > 40.           % Go if the signal is yellow and speed is greater than 40

should_go :-
    railroad_gate(up).

should_stop :- 
    stop_sign(present).                     % Stop if there is a stop sign.

should_stop :- 
    traffic_signal(red).

should_stop :- 
    railroad_gate(down). 

should_stop :-                    % Stop if the signal is red
    (traffic_signal(yellow), 
    car_speed(Speed), Speed =< 40).         % Stop if the signal is yellow and speed is 40 or less
should_stop :-
    police(present).

should_stop :-
    ambulance(present).
% Light control rules
turn_on_lights :- 
    time(day).                              % Turn on lights if it is daytime.

turn_off_lights :- 
    time(night). 

% Speed adjustment based on weather conditions
adjust_speed(Speed) :- 
    weather(icy), Speed is 20.              % Slow down to 20 mph if icy.
adjust_speed(Speed) :- 
    weather(snowy), Speed is 15.            % Slow down to 15 mph if snowy.
adjust_speed(Speed) :- 
    weather(foggy).                         % Slow down to visible speed if foggy.
    weather(rainy).                         % Slow down to visible speed if rainy.


% Output decisions
decision(go) :- 
    should_go, 
    not should_stop.
decision(stop) :- should_stop.

 

% Query to get the decision
query(Decision) :- decision(Decision).

query_lights(Status) :- 
    time(day), Status = off.                 % If it's daytime, lights are on.
query_lights(Status) :- 
    time(night), Status = no.              % If it's nighttime, lights are off.

query_adjusted_speed(Speed) :- 
    adjust_speed(Speed).

% Left turn logic
query_turn_left(Decision) :- 
    want_to_turn(left),
    not traffic_signal(green),                         % If vehicles are within 30 meters
    Decision = stop. 
query_turn_left(Decision) :- 
    want_to_turn(left),
    traffic_signal(green),                     % The car wants to turn left
    vehicle(opposite_lane, Distance, _),    % Check for vehicles in the opposite lane
    Distance > 30,                         % If vehicles are within 30 meters
    Decision = go.                        % Stop and wait for them to pass

% Right turn logic

query_turn_right(Decision) :- 
    want_to_turn(right),                    % The car wants to turn right
    vehicle(opposite_lane, Distance, _),     % Check for vehicles in the opposite lane
    Distance > 30,                           % If vehicles are more than 30 meters away
    Decision = go. 
query_turn_right(Decision) :- 
    want_to_turn(right),                    % The car wants to turn right
    vehicle(opposite_lane, Distance, _),     % Check for vehicles in the opposite lane
    Distance =< 30,                           % If vehicles are more than 30 meters away
    Decision = stop.

query_should_yeild(Decision) :-
    sign(yeild),
    vehicle(opposite_lane, Distance, _),
    Distance > 100,
    Decision= go.
query_should_yeild(Decision) :-
    sign(yeild),
    vehicle(opposite_lane, Distance, _),
    Distance =< 100,
    Decision= go.

