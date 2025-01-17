% Facts
car(left, 6).
roadblock(right).
pedestrians(left, 5). 
animals(left, 6).

opposite_lane(left, right). 
opposite_lane(right, left).

% Harm calculations
pedestrians_harmed(Lane, PH) :- pedestrians(Lane, PH).
animals_harmed(Lane, AH) :- animals(Lane, AH).
passengers_harmed(Lane, PaH) :- 
    roadblock(Lane), 
    car(_, H), 
    PaH is H.
passengers_harmed(Lane, 0) :- \+ roadblock(Lane).

% Harm when staying
harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, PH),
    animals_harmed(Lane, AH),
    passengers_harmed(Lane, PaH),
    H is PH + AH + PaH.

% Harm when swerving
harm_swerve(H) :- 
    car(Lane, _),
    opposite_lane(Lane, Opposite),
    pedestrians_harmed(Opposite, PH),
    animals_harmed(Opposite, AH),
    passengers_harmed(Opposite, PaH),
    H is PH + AH + PaH.

% Decision rules
decision(swerve) :- 
    harm_stay(HStay), 
    harm_swerve(HSwerve), 
    HStay > HSwerve.

decision(stay) :- 
    harm_stay(HStay), 
    harm_swerve(HSwerve), 
    HStay =< HSwerve.

% Query
?- decision(X).
