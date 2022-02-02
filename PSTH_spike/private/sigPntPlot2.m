function sigRange = sigPntPlot2(x,y,posSigIdx,negSigIdx)
sigRange = nan(1,6);
interval = x(2) - x(1); 
if ~isempty(y) 
%     posSigIdx = y > threshH;
        if ~isempty(find(posSigIdx,1))
            sigPmY = y(posSigIdx);
            sigPX = x(posSigIdx);
            possIdx = find(posSigIdx,1,'first');
            poseIdx = find(posSigIdx,1,'last');
            posS = sigPX(1); 
            posE = sigPX(end);
            posContTag = length(sigPmY) >= (posE - posS)/interval*0.7;
            if posContTag
%                 plot(x(possIdx:poseIdx),y(possIdx:poseIdx),'-','Color',[0.850,0.325,0.098],'LineWidth',3);
                plot(x(possIdx:poseIdx),y(possIdx:poseIdx),'-','Color',[1,0,0],'LineWidth',3);
                sigRange(1,1:3) = [x(possIdx),x(poseIdx),x(poseIdx) - x(possIdx)];
                report = sprintf('Increased range: %0.2f %0.2f %0.2f\n',x(possIdx),x(poseIdx),x(poseIdx) - x(possIdx));
                fprintf('%s\n',report);                
            else
                plot(sigPX,sigPmY,'.','Color',[0.850,0.325,0.098],'LineWidth',3);
            end
%             disp('Activation')
        end
%         negSigIdx = y < threshL;
        if ~isempty(find(negSigIdx,1))
            sigNmY = y(negSigIdx);
            sigNX = x(negSigIdx);
            negsIdx = find(negSigIdx,1,'first');
            negeIdx = find(negSigIdx,1,'last');
            negS = sigNX(1); 
            negE = sigNX(end);
            negContTag = length(sigNmY) >= (negE - negS)/interval*0.7;
            if negContTag
                plot(x(negsIdx:negeIdx),y(negsIdx:negeIdx),'-','Color',[0,0.447,0.741],'LineWidth',3);
%                 plot(x(negsIdx:negeIdx),y(negsIdx:negeIdx),'-','Color',[0,0,1],'LineWidth',3);
                sigRange(1,4:6) = [x(negsIdx),x(negeIdx),x(negeIdx) - x(negsIdx)];
                report = sprintf('Decreased range: %0.2f %0.2f %0.2f\n',x(negsIdx),x(negeIdx),x(negeIdx) - x(negsIdx));
                fprintf('%s\n',report);    
            else
                plot(sigNX,sigNmY,'.','Color',[0,0.447,0.741],'LineWidth',3);
%                 plot(sigNX,sigNmY,'.','Color',[0,0,1],'LineWidth',3);
            end
%             disp('Inhibition')
        end        
end
