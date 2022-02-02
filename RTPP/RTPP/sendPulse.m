function sendPulse(numofperiods, ontime, offtime)
% creates a digital I/O object
parport = digitalio('parallel','LPT1');

% adds out line to the digital I/O object
hwline = addline(parport,0,'out');

%configures the digital I/O object
set(parport, 'TimerPeriod', offtime);
set(parport, 'TimerFcn', {@puton, numofperiods, ontime, offtime});
set(parport, 'UserData', 0);
putvalue(parport.Line(1), 0); %pulse is off
start(parport);
end

% Subfunction that switches the pulse "on" or "off"
% and also stops the object when the specified
% number of periods has been reached.
function puton(obj, str, numofperiods, ontime, offtime)

obj.TimerFcn = {@putoff, numofperiods, ontime, offtime};
obj.TimerPeriod = offtime;
putvalue(obj.Line(1), 1); %pulse is on
end

function putoff(obj, str, numofperiods, ontime, offtime)
obj.TimerFcn = {@puton, numofperiods, ontime, offtime};
obj.TimerPeriod = ontime;
putvalue(obj.Line(1), 0); %pulse is off

if (obj.UserData == numofperiods)
obj.TimerFcn = ' ';
stop(obj);
end
obj.UserData = obj.UserData +1;

end