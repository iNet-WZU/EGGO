function [current_X] = theGlobalSearch(current_X, best_X, E, p, ub, lb)
    if rand<p
        current_X = best_X-E+rand*((ub-lb)*rand+lb);   
    else
         current_X = best_X-E*(abs(2*rand*best_X-current_X));
    end   
end