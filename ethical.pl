% Facts
car(left, 6).
roadblock(right).
pedestrians(left, 5). 
animals(left, 6).

opposite_lane(left, right). 
opposite_lane(right, left).

pedestrians(Lane, 0).
animals(Lane, 0).

pedestrians_harmed(Lane, PH) :- pedestrians(Lane, H), PH is H.
animals_harmed(Lane, AH) :- animals(Lane, H), AH is H.
passengers_harmed(Lane, PaH) :- roadblock(Lane), car(_, H), PaH is H.
passengers_harmed(_,0).

harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, PH), not pedestrians_harmed(Lane, 0),
    animals_harmed(Lane, AH), not animals_harmed(Lane, 0),
    passengers_harmed(Lane, PaH), not passengers_harmed(Lane, 0),
    H is PH + AH + PaH.

harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, 0),
    animals_harmed(Lane, AH), not animals_harmed(Lane, 0),
    passengers_harmed(Lane, PaH), not passengers_harmed(Lane, 0),
    H is AH + PaH.

harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, 0),
    animals_harmed(Lane, 0),
    passengers_harmed(Lane, PaH), not passengers_harmed(Lane, 0),
    H is PaH.

harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, 0),
    animals_harmed(Lane, 0),
    passengers_harmed(Lane, 0),
    H is 0.

harm_swerve(H) :- 
    car(Lane,_),
    opposite_lane(Lane, Opposite),
    pedestrians(Opposite, PH), 
    animals(Opposite, AH),
    passengers_harmed(Opposite, PaH),
    H is PH + AH + PaH.

decision(stay) :- 
    harm_stay(HStay), 
    harm_swerve(HSwerve), 
    HStay =< HSwerve.

decision(swerve) :- 
    harm_stay(HStay), 
    harm_swerve(HSwerve), 
    HStay > HSwerve.

% Query
?- decision(X).
