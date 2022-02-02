clear all;close all;
load mouse_path;
h=open('C:\matlab\hotfigure for mice trajectray\*.fig');title('Origin');
h_line=get(gca,'Children');
xdata=get(h_line,'Xdata');
ydata=get(h_line,'Ydata');
xdata=double(xdata);ydata=double(ydata);
figure; plot(xdata,ydata,'b');
xdata=(xdata-min(xdata));xdata=xdata/max(xdata);
ydata=(ydata-min(ydata));ydata=ydata/max(ydata);
lx=100;ly=100;
mouse_size=4;
x1=linspace(50,528,45000); 
y1=linspace(97,323,45000);
[tx,ty]=meshgrid(x1,y1);
tx=0:lx;ty=0:ly;[tx,ty]=meshgrid(tx,ty);
x_data=floor(xdata*lx);y_data=floor(ydata*ly);

path=zeros(lx+1,ly+1);
for i=1:(length(x_data))
   temp_path=zeros(lx+1,ly+1);
    temp_path = gaosi(tx,ty,x_data(i),y_data(i),mouse_size);
    path=path+temp_path;
end
load('mycolor.mat')
figure; figure('color',[1 1 1]);
pcolor(tx,ty,path);shading interp;
colormap(mycolor); colorbar;
set(gca,'ytick',[]) 
set(gca,'xtick',[])
