function fastWT1(Y,scale)
% N = 8 would be ok for ERP data
wname = 'bior3.9';
dwtmode('sp1')
% [cA,cD] = dwt(Y,wname);
[C,L] = wavedec(Y,scale,wname);
D = detcoef(C,L,1:scale);% details of each scale
A = appcoef(C,L,wname,scale);
% nY = waverec(C,L,wname);
% figure
% subplot(10,1,1);plot(Y);
% subplot(10,1,2);plot(D{1});
% subplot(10,1,3);plot(D{2});
% subplot(10,1,4);plot(D{3});
% subplot(10,1,5);plot(D{4});
% subplot(10,1,6);plot(D{5});
% subplot(10,1,7);plot(D{6});
% subplot(10,1,8);plot(D{7});
% subplot(10,1,9);plot(D{8});
% subplot(10,1,10);plot(A);
sc = 8;
x = nY(1,:);
av = nY(2,:);
[coeff,denAv,denCoeff,y] = Run_NZT(x,av,sc);

