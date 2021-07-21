function N = cost(num, obs)
  %COST   Cost function for minimization.
  %   N = cost(num, obs) where
  %   num(1) = casesNum, num(2) = removedNum,
  %   obs(1) = casesObs, obs(2) = removedObs
  
  %create new variables for ease
  casesNum = num(1);
  removedNum = num(2);
  casesObs = obs(1);
  removedObs = obs(2);
  
  %calculate the Euclidean norm
  N = norm(casesNum - casesObs) + norm(removedNum - removedObs);
end