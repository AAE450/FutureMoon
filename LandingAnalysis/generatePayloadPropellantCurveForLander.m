% This function will the propellant required for descent, lower, and
% landing manuever. It is using a binary search to find the minimum
% acceptable propellant to land a given payload.

payloads = (1000:1000:30000);

initialX = -700000;
iterations = 10;

propReq = [];

for idx = (1:length(payloads))
    low = 1000;
    high = 100000;
    mid = low + (high-low)/2;
    
    nosoln = true;
    
    for iter = (1:iterations)
        try
            [propRemaing] = analyzeLunarDeploymentDescent(payloads(idx), mid, initialX);
        catch
            high = mid;
            mid = low + (high-low)/2;
            continue;
        end
        
        if propRemaing >= 0
            nosoln = false;
            high = mid;
            mid = low + (high-low)/2;
        else
            low = mid;
            mid = low + (high-low)/2;
        end
    end
    
    if nosoln
        fprintf('MAXIMUM PAYLOAD: %f\n', payloads(idx));
        break;
    else
        propReq(idx) = high;
    end
    
end

scatter(1e-3 * payloads(1:length(propReq)), 1e-3 * propReq);
title('Propellant Required To Land');
xlabel('Inert + Payload (Mg)')
ylabel('Propellant (Mg)')