% Facts
car(left, 6).
roadblock(right).
pedestrians(Lane, Num_P) :- num_pedestrians(Lane, Num_P),!.
pedestrians(Lane, 0).
num_pedestrians(left, 5).
animals(Lane, Num_A) :- num_animals(Lane, Num_A),!.
animals(Lane,0).
num_animals(left, 6).

opposite_lane(left, right). 
opposite_lane(right, left).

pedestrians_harmed(Lane, PH) :- pedestrians(Lane, H), PH is H.
animals_harmed(Lane, AH) :- animals(Lane, H), AH is H.
passengers_harmed(Lane, PaH) :- roadblock(Lane),!, car(_, H), PaH is H.
passengers_harmed(_,0).

harm_stay(H) :- 
    car(Lane, _),
    pedestrians_harmed(Lane, PH),
    animals_harmed(Lane, AH),
    passengers_harmed(Lane, PaH),
    H is PH + AH + PaH.

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
