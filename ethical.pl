% Facts
car(left, 6, 60).           
roadblock(right).           
legal_crossing(left).      
num_pedestrians(left, 5).   
num_animals(left, 6).       
speed_limit(50).                      

% Rules
above_speed_limit :- 
    car(_, _, Speed), 
    speed_limit(Limit), 
    Speed > Limit.

pedestrians_crossing_legally(Lane, true):- legal_crossing(Lane).
pedestrians_crossing_legally(Lane, false):- not legal_crossing(Lane).

illegal_driving(DUI) :- dui(DUI), DUI = true.
illegal_driving(PhoneUse) :- phone_use(PhoneUse), PhoneUse = true.
illegal_driving(Speeding) :- above_speed_limit, Speeding = true.

dui_value(1) :- dui(true).
dui_value(0) :- not dui(true).

phone_value(1) :- phone_use(true).
phone_value(0) :- not phone_use(true).

speed_value(1) :- above_speed_limit.
speed_value(0) :- not above_speed_limit.

sum_illegal_driving_activities(Sum) :- 
    Sum = DUI_Value + Phone_Value + Speed_Value,
    dui_value(DUI_Value), 
    phone_value(Phone_Value), 
    speed_value(Speed_Value).

pedestrians(Lane, Num_P) :- num_pedestrians(Lane, Num_P),!.
pedestrians(Lane, 0).

animals(Lane, Num_A) :- num_animals(Lane, Num_A),!.
animals(Lane,0).

human_weight(100).
animal_weight(1).

pedestrian_weight(Lane, Weight) :- 
    pedestrians_crossing_legally(Lane, true),
    sum_illegal_driving_activities(Sum), 
    Weight is 10 + 5 * Sum. 
pedestrian_weight(Lane, Weight) :- 
    pedestrians_crossing_legally(Lane, false),
    sum_illegal_driving_activities(Sum), 
    Weight is 1 + 5 * Sum.

passenger_weight(Lane, Weight) :- 
    pedestrians_crossing_legally(Lane, true), 
    Weight is 1.
passenger_weight(Lane, Weight) :- 
    pedestrians_crossing_legally(Lane, false), 
    Weight is 10.

opposite_lane(left, right). 
opposite_lane(right, left).

pedestrians_harmed(Lane, PH) :- pedestrians(Lane, H), PH is H.
animals_harmed(Lane, AH) :- animals(Lane, H), AH is H.
passengers_harmed(Lane, PaH) :- roadblock(Lane),!, car(_, H, _), PaH is H.
passengers_harmed(_,0).

harm_stay(H) :- 
    car(Lane, _, _),
    pedestrians_harmed(Lane, PH),
    animals_harmed(Lane, AH),
    passengers_harmed(Lane, PaH),
    passenger_weight(Lane, PaW),
    pedestrian_weight(Lane, PW),
    animal_weight(AW),
    human_weight(HW),
    H is PH * HW * PW + AH * AW + PaH * HW * PaW.

harm_swerve(H) :- 
    car(Lane,_,_),
    opposite_lane(Lane, Opposite),
    pedestrians(Opposite, PH), 
    animals(Opposite, AH),
    passenger_weight(Opposite, PaW),
    pedestrian_weight(Opposite, PW),
    animal_weight(AW),
    human_weight(HW),
    passengers_harmed(Opposite, PaH),
    H is PH * HW * PW + AH * AW + PaH * HW * PaW.

decision(stay) :-
    harm_stay(HStay), 
    harm_swerve(HSwerve),
    HStay = 0.

decision(swerve) :-
    harm_stay(HStay), 
    harm_swerve(HSwerve),
    HSwerve = 0.

decision(stay) :-
    harm_stay(HStay), 
    harm_swerve(HSwerve),
    HStay = HSwerve.

decision(stay) :-
    harm_stay(HStay), 
    harm_swerve(HSwerve),
    HStay < HSwerve.

decision(swerve) :- 
    harm_stay(HStay), 
    harm_swerve(HSwerve),
    HStay > HSwerve.

% Query
?- decision(X).