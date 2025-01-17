% Facts
car_speed(30).                             % Current speed of the car (km/h)
traffic_signal(yellow).
stop_sign(absent).
curr_time(day).
weather(icy).
railroad_gate(up).
want_to_turn(left).                        % Want to turn left
vehicle(opposite_lane, 20, sedan).
sign(yield).
police(absent).
ambulance(absent).
distance_from_light(3000).

% Rules for traffic decisions
should_go :-
    traffic_signal(green).                 % Go if the signal is green

should_go :-
    traffic_signal(yellow),
    car_speed(Speed), Speed > 40.          % Go if the signal is yellow and speed is greater than 40

should_go :-
    railroad_gate(up).                     % Go if the railroad gate is up

should_stop :-
    stop_sign(present).                    % Stop if there is a stop sign

should_stop :-
    traffic_signal(red).                   % Stop if the signal is red

should_stop :-
    railroad_gate(down).                   % Stop if the railroad gate is down

should_stop :-
    traffic_signal(yellow),
    car_speed(Speed), Speed =< 40.         % Stop if the signal is yellow and speed is 40 or less

should_stop :-
    police(present).                       % Stop if police are present

should_stop :-
    ambulance(present).                    % Stop if ambulance is present

% Speed adjustment based on weather conditions
adjust_speed(Speed) :-
    weather(icy), Speed is 20.             % Slow down to 20 km/h if icy

adjust_speed(Speed) :-
    weather(snowy), Speed is 15.           % Slow down to 15 km/h if snowy

adjust_speed(Speed) :-
    weather(foggy), Speed is 25.           % Slow down to visible speed if foggy

adjust_speed(Speed) :-
    weather(rainy), Speed is 30.           % Slow down to 30 km/h if rainy

% Light control rules
turn_on_lights :-
    curr_time(night).                      % Turn on lights if it is nighttime

turn_off_lights :-
    curr_time(day).                        % Turn off lights if it is daytime

% Consolidated query logic for turning left
query(left, Decision) :-
    police(present),
    Decision = stop, !.

query(left, Decision) :-
    ambulance(present),
    Decision = stop, !.

query(left, Decision) :-
    traffic_signal(red),
    Decision = stop, !.

query(left, Decision) :-
    traffic_signal(yellow),
    should_go,
    distance_from_light(Distance),
    Distance < 3200,
    Decision = go, !.

query(left, Decision) :-
    railroad_gate(down),
    Decision = stop, !.

query(left, Decision) :-
    stop_sign(present),
    Decision = stop, !.

query(left, Decision) :-
    vehicle(opposite_lane, Distance, _),
    Distance =< 30,
    Decision = stop, !.

query(left, Decision) :-
    vehicle(opposite_lane, Distance, _),
    Distance > 30,
    Decision = go.

% Consolidated query logic for turning right
query(right, Decision) :-
    police(present),
    Decision = stop, !.

query(right, Decision) :-
    ambulance(present),
    Decision = stop, !.

query(right, Decision) :-
    traffic_signal(red),
    Decision = stop, !.

query(right, Decision) :-
    traffic_signal(yellow),
    should_go,
    distance_from_light(Distance),
    Distance < 3200,
    Decision = go, !.

query(right, Decision) :-
    railroad_gate(down),
    Decision = stop, !.

query(right, Decision) :-
    stop_sign(present),
    Decision = stop, !.

query(right, Decision) :-
    vehicle(opposite_lane, Distance, _),
    Distance =< 30,
    Decision = stop, !.

query(right, Decision) :-
    vehicle(opposite_lane, Distance, _),
    Distance > 30,
    Decision = go.

% Consolidated query logic for going straight
query(straight, Decision) :-
    police(present),
    Decision = stop, !.

query(straight, Decision) :-
    ambulance(present),
    Decision = stop, !.

query(straight, Decision) :-
    stop_sign(present),
    Decision = stop, !.

query(straight, Decision) :-
    traffic_signal(red),
    Decision = stop, !.

query(straight, Decision) :-
    traffic_signal(yellow),
    should_go,
    distance_from_light(Distance),
    Distance < 3200,
    Decision = go, !.

query(straight, Decision) :-
    railroad_gate(down),
    Decision = stop, !.

query(straight, Decision) :-
    traffic_signal(green),
    Decision = go.

% Query for speed adjustment based on weather conditions
query(speed, Speed) :-
    adjust_speed(Speed), !.

% Query for lights based on time of day
query(lights, Status) :-
    curr_time(night),
    Status = on, !.

query(lights, Status) :-
    curr_time(day),
    Status = off.

% Query for yield logic based on oncoming vehicles
query(yield, Decision) :-
    vehicle(opposite_lane, Distance, _),
    Distance =< 100,
    Decision = stop, !.

query(yield, Decision) :-
    Decision = go.

%Test Queries
% query(left, X). or right or straight
% query(speed, X).
% query(lights, X).
% query(yeild, X).
