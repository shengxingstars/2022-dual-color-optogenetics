function plotCoefficients(handles)
%Plots either coefficients, frequency bands, single-trials or the contour plots.
% [coeff,denAv,denCoeff,yDen]=Run_NZT(x,av,sc)
h = findobj('Tag','gui2');
vData = getappdata(h,'UserData');
coeff=vData.cCoeff; 
denCoeff=vData.cDenCoeff; 
%  x=data{2};
%  xx=data{3};        
%  denAv=data{5};     
%  YDEN=data{8};
%  yo=data{9};
%  y=data{10};
%  amp=data{14};
%  lat=data{15}; 
%  xx_lc=data{18};
%  yo_lc=data{19};
 
plot_type = 'coeff';
sc = vData.sc;
zeroIdx= find(vData.nx == 0);
samples = length(vData.nx);
sr = 1./vData.resp1.interval*vData.deciR;
% max_trials = handles.par.max_trials;
% max_contour = handles.par.max_contour;
% t_min=handles.par.t_min;
% t_max=handles.par.t_max;
% sweeps =length(x)/samples;
axes(handles.axes2)
cla
hold on
axis off
set(handles.axes2,'xlimmode','auto');
set(handles.axes2,'ylimmode','auto');
set(handles.axes2, 'Box', 'off')
%% Plotting
switch plot_type
    
    case 'coeff'
        step = 1/(sc+2):1/(sc+2):1;
        if isempty(denCoeff)
            for i=1:sc+1
                scaling_factor = 1.5 *max(abs(coeff(i,:))) * (sc+1);
                aux1 = coeff(i,:)/ scaling_factor;
                plot(((1:samples)-zeroIdx+1)/sr,aux1+step(sc+2-i),'color', [0.5 0.5 0.5])
            end    
        else
            for i=1:sc+1
                scaling_factor = 1.5 * max(abs(coeff(i,:))) * (sc+1);
                aux1= coeff(i,:)/ scaling_factor;
                aux2=denCoeff(i,:)/scaling_factor;
                plot(((1:samples)-zeroIdx+1)/sr,aux1+step(sc+2-i),'color', [0.5 0.5 0.5])
                plot(((1:samples)-zeroIdx+1)/sr,aux2+step(sc+2-i), 'color',vData.colorOrder(2,:))
            end
        end
        xlim([(1-zeroIdx+1)/sr (samples-zeroIdx+1)/sr])
        xrange = get(handles.axes2,'xlim') * 1.1;          
        line([0 0],[0.05 0.95],'Linestyle',':','color','k')
         for i=1:sc
            texto =['D' num2str(i)];
            text(xrange(1),step(sc+2-i)+0.01,texto);
         end
         texto =['A' num2str(sc)];
         text(xrange(1),step(1)+0.01,texto);
         axis off
         
  
%         case 'bands'
%             scaling_factor = 1.5 * max(max(abs(yo))) * (sc+1);
%             aux = y/ scaling_factor;
%             aux_all = yo/ scaling_factor;
%             aux_lc = yo_lc/ scaling_factor;
%             step = 1/(sc+2):1/(sc+2):1;           
%                     if isempty(YDEN)
%                           for i=1:sc+1
%                               plot(((1:samples)-zeroIdx+1)/sr,aux_all(i,:)+step(sc+2-i),'color', [0.6 0.6 0.6])
%                           end
%                     else
%                         for i=1:sc+1
%                             plot(((1:samples)-zeroIdx+1)/sr,aux_all(i,:)+step(sc+2-i),'color', [0.6 0.6 0.6])
%                             plot(((1:samples)-zeroIdx+1)/sr,aux(i,:)+step(sc+2-i),'r')
%                         end 
%                     end
% 
%             xlim([(1-zeroIdx+1)/sr (samples-zeroIdx+1)/sr])          
%             xrange = get(handles.axes2,'xlim') * 1.1;          
%             line([0 0],[0.05 0.95],'Linestyle',':','color','k')
%             for i=1:sc
%                 texto =['D' num2str(i)];
%                 text(xrange(1),step(sc+2-i)+0.01,texto);
%             end
%             texto =['A' num2str(sc)];
%             text(xrange(1),step(1)+0.01,texto);
% 
%             
%     case 'single'
%         nr_sweeps = min(sweeps,max_trials);
%         scaling_factor = 1.7 * max(max(abs(xx))) * nr_sweeps;
%         aux_all = xx / scaling_factor;
%         step = 1/(nr_sweeps+1):1/(nr_sweeps+1):1;
%         aux = YDEN / scaling_factor;
%         amp=amp/scaling_factor;
%         lat=lat/1000;
%             if isempty(amp)
%                 if isempty(YDEN) 
%                     for i=1:nr_sweeps;
%                          plot(((1:samples)-zeroIdx+1)/sr,aux_all(1+nr_sweeps-i,:)+step(i),'color', [0.6 0.6 0.6])
%                     end 
%                 else             
%                     for i=1:nr_sweeps;
%                          plot(((1:samples)-zeroIdx+1)/sr,aux_all(1+nr_sweeps-i,:)+step(i),'color', [0.6 0.6 0.6])
%                          plot(((1:samples)-zeroIdx+1)/sr,aux(1+nr_sweeps-i,:)+step(i) ,'r')
%                     end
%                 end
%             else
%                  for i=1:nr_sweeps;
%                      plot(((1:samples)-zeroIdx+1)/sr,aux_all(1+nr_sweeps-i,:)+step(i),'color', [0.6 0.6 0.6])
%                      plot(((1:samples)-zeroIdx+1)/sr,aux(1+nr_sweeps-i,:)+step(i) ,'r')
%                      plot(lat(1+nr_sweeps-i),amp(1+nr_sweeps-i)+step(i) ,'b:*','MarkerSize',5)
%                  end            
%                 rh=rectangle('position',[t_min,min(step)+min(aux(nr_sweeps,:)),t_max-t_min,max(step)-min(step)],'edgecolor','b');
%             end
%         xlim([(1-zeroIdx+1)/sr (samples-zeroIdx+1)/sr])          
%         xrange = get(handles.axes2,'xlim') * 1.1;          
%         line([0 0],[0.05 0.95],'Linestyle',':','color','k')
%         for i=1:nr_sweeps
%              texto =['#' num2str(1+nr_sweeps-i)];
%              text(xrange(1),step(i)+0.01,texto);
%         end
%        
%     case 'contour'
%              axis on            
%              nr_sweeps = min(sweeps,max_contour);
%             if isempty(xx_lc)  
%                 if isempty(amp)
%                     if isempty(YDEN)
%                         [c,h]=contourf(((1:samples)-zeroIdx+1)/sr,1:nr_sweeps,xx(1:nr_sweeps,:),10);
%                     else
%                         [c,h]=contourf(((1:samples)-zeroIdx+1)/sr,1:nr_sweeps,YDEN(1:nr_sweeps,:),10);
%                     end
%                 else
%                      [c,h]=contourf(((1:samples)-zeroIdx+1)/sr,1:nr_sweeps,YDEN(1:nr_sweeps,:),10);
%                      rectangle('position',[t_min,1,t_max-t_min,nr_sweeps-1],'edgecolor','b');             
%                      lat=lat/1000;
%                      for k=1:nr_sweeps
%                          plot(lat(k),k,'b:*')
%                      end             
%                      for k=1:nr_sweeps-1
%                         line([lat(k);lat(k+1)],[k;k+1],'color','b')
%                      end                     
%                 end
%                 else
%                  [c,h]=contourf(((1:samples)-zeroIdx+1)/sr,1:nr_sweeps,xx_lc(1:nr_sweeps,:),10);   
%             end       
%             set(h,'Edgecolor','none')
            
end

