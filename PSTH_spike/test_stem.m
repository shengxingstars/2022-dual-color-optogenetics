X = linspace(0,2*pi,50)';
y1=1+ones(length(X),1)*0.4;
y2=2+ones(length(X),1)*0.4;
figure;stem(X,y1,'BaseValue',1,'ShowBaseLine','off');hold on;


stem(X,y2,'BaseValue',2);hold on;