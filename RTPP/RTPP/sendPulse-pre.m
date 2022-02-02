function sendPulse(parport,stimTag,perNum, ontime, offtime)
% creates a digital I/O object
%parport = digitalio('parallel','LPT1');

% adds out line to the digital I/O object
%hwline = addline(parport,0,'out');
if stimTag == 1

    %putvalue(parport.Line(1), 0); %pulse is off
    if strcmp(parport.Running, 'off')
        %configures the digital I/O object
        set(parport, 'TimerPeriod', offtime);
        set(parport, 'TimerFcn', {@puton, perNum, ontime, offtime});
        set(parport, 'UserData', 0);
        putvalue(parport.Line(1), 0); %pulse is off
        start(parport);
    end
else
    stop(parport);
    putvalue(parport.Line(1), 0);
    %return
end
end

% Subfunction that switches the pulse "on" or "off"
% and also stops the object when the specified
% number of periods has been reached.
function puton(obj, str, perNum, ontime, offtime)

obj.TimerFcn = {@putoff, perNum, ontime, offtime};
obj.TimerPeriod = offtime;
putvalue(obj.Line(1), 1); %pulse is on

if (obj.UserData == perNum)
obj.TimerFcn = ' ';
stop(obj);
end
obj.UserData = obj.UserData +1;
end

function putoff(obj, str, perNum, ontime, offtime)
obj.TimerFcn = {@puton, perNum, ontime, offtime};
obj.TimerPeriod = ontime;
putvalue(obj.Line(1), 0); %pulse is off
end