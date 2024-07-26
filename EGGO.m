function [gbestfitness,gbestX,gbesthistory] = EGGO(popsize,MaxFEs,xmin,xmax,dimension,Func)
%Parameter setting
FEs = 0;P1 = 5;P2 = 0.001;P3 = 0.3; %recommended parameter P1=5;P2=0.001;P3=0.3;
%initialization
x = initialization(popsize,dimension,xmax,xmin); %Eq.(8)
gbestfitness = inf;
gbesthistory = inf(1,MaxFEs);
fitness=inf(1,popsize);
for i=1:popsize
    fitness(i) = Func(x(i,:));
    FEs = FEs+1;
    if gbestfitness>fitness(i)
        gbestfitness = fitness(i);
        gbestX = x(i,:);
    end
    gbesthistory(FEs) = gbestfitness;
end

while 1
    FEs
    r1 = rand();
    E1 = 1.5*(1-(FEs/MaxFEs));
    E0 = 2*r1-1;
    E = E1*E0; % Eq.(18)
    [~, ind] = sort(fitness);
    Best_X = x(ind(1),:);
    Worst_X = x(ind(randi([popsize-P1+1,popsize],1)),:);
    Better_X=x(ind(randi([2,P1],1)),:);
    for i=1:popsize
        %% Exploration stage
        if abs(E)>1
            if rand>0.5
                %Learning phase
                random = selectID(popsize,i,2);
                L1 = random(1);
                L2 = random(2);
                Gap1 = (Best_X-Better_X); %Eq.(10)
                Gap2 = (Best_X-Worst_X);
                Gap3 = (Better_X-Worst_X);
                Gap4 = (x(L1,:)-x(L2,:));
                Distance1 = norm(Gap1);
                Distance2 = norm(Gap2);
                Distance3 = norm(Gap3);
                Distance4 = norm(Gap4);
                SumDistance = Distance1+Distance2+Distance3+Distance4;
                LF1 = Distance1/SumDistance; %Eq.(11)
                LF2 = Distance2/SumDistance;
                LF3 = Distance3/SumDistance;
                LF4 = Distance4/SumDistance;
                SF = (fitness(i)/max(fitness)); %Eq.(12)
                KA1 = LF1*SF*Gap1; %Eq.(13)
                KA2 = LF2*SF*Gap2;
                KA3 = LF3*SF*Gap3;
                KA4 = LF4*SF*Gap4;
                newx(i,:) = x(i,:)+KA1+KA2+KA3+KA4; %Eq.(14)
            else
                %The efficient global search Eq.(19)
                newx(i,:) = theGlobalSearch(x(i,:), Best_X, E, 0.5, xmax, xmin);
            end
        else
            %% Exploitation stage
            if rand>0.5
                %Reflection phase Eq.(16)
                newx(i,:) = x(i,:);
                j = 1;
                while j<=dimension
                    if rand<P3
                        R = x(ind(randi(P1)),:);
                        newx(i,j) = x(i,j)+(R(:,j)-x(i,j))*unifrnd(0,1);
                        AF = (0.01+(1-0.01)*(1-FEs/MaxFEs)); %Eq.(17)
                        if rand<AF
                            newx(i,j) = xmin(j)+(xmax(j)-xmin(j))*unifrnd(0,1);
                        end
                    end
                    j = j+1;
                end
            else
                %% EXPLOITATION
                if rand>=0.5
                    %Elite natural evolution Eq.(20)
                    for j=1:dimension
                        r5 = rand;
                        if r5<abs(E)
                            temp_X(1,j) = Best_X(1,j);
                        else
                            temp_X(1,j) = Better_X(1,j);
                        end
                    end
                    newx(i,:) = temp_X+(normrnd(0,0.33333,1,dimension).*abs(temp_X-x(i,:)));
                else
                    %Elite random mutation Eq.(21)
                    j1 = round(1+rand*(dimension-1));
                    GSnum = randn;
                    V = ((xmin+xmax)/2);
                    for j=1:dimension
                        r5 = rand;
                        if r5<abs(E) || j==j1
                            distance2Leader = abs(V(1,j)-Best_X(1,j));
                            newx(i,j) = V(1,j)+(GSnum*distance2Leader);
                        else
                            newx(i,j) = Best_X(1,j);
                        end
                    end
                end
            end
        end
        %Clipping
        newx(i,:) = max(newx(i,:),xmin);
        newx(i,:) = min(newx(i,:),xmax);
        newfitness = Func(newx(i,:));
        FEs = FEs+1;
        %Update Eq.(15)
        if fitness(i)>newfitness
            fitness(i) = newfitness;
            x(i,:) = newx(i,:);
        else
            if rand<P2&&ind(i)~=1
                fitness(i) = newfitness;
                x(i,:) = newx(i,:);
            end
        end
        if gbestfitness>fitness(i)
            gbestfitness = fitness(i);
            gbestX = x(i,:);
        end
        gbesthistory(FEs) = gbestfitness;
    end
    if FEs>MaxFEs
        break;
    end
end

%Deal with the situation of too little or too much evaluation
if FEs<MaxFEs
    gbesthistory(FEs+1:MaxFEs) = gbestfitness;
else
    if FEs>MaxFEs
        gbesthistory(MaxFEs+1:end) = [];
    end
end
end

function [r] = selectID(popsize,i,k)
%Generate k random integer values within [1,popsize] that do not include i and do not repeat each other
if k<=popsize
    vecc = [1:i-1,i+1:popsize];
    r = zeros(1,k);
    for kkk =1:k
        n = popsize-kkk;
        t = randi(n,1,1);
        r(kkk) = vecc(t);
        vecc(t) = [];
    end
end
end

