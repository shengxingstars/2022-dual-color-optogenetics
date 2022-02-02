% stop timer when reach timeout
if(nValues > vData.testTime*vData.perSecondReadFrames)
    putvalue(handles.diOut,0);
    figFileName = strrep(vData.filename, 'dat', 'fig');
    %print(gcf, '-djpeg', datFileName)
    matFileName = strrep(vData.filename, 'dat', 'mat');
    % centroids  elipMouse
    vData.centroids = centroids; 
    %vData.testTime = timeValue;
    vData.elipMouse =elipMouse;
    save(matFileName, '-struct', 'vData');
    stoppreview(handles.obj);
    baseImg = imshow(vData.refImg,'Parent',handles.axes2);
    hold on 
    plot(gca,vData.centroids(:,1),vData.centroids(:,2),'b-');
    h2 = imrect(gca,vData.stimPos);
    setColor(h2,'r');
    hold off
    saveas(handles.figure1, figFileName, 'fig'); 
    
    stop(handles.dio)
    %nValues
    centroids = [];
    elipMouse = [];
    nValues = [];
    timeValue = 0;
    
    if(~isempty(daqfind))
        stop(daqfind)
        clear daqfind
    end

    if(~isempty(timerfind))
         stop(timerfind)
         clear timerfind
    end

    disp('Well Done!')
    return
end