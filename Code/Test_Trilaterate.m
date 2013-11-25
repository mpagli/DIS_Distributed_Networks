function Test_Trilaterate()
close all;
clc;
hold on, 

axis equal;
grid on;

P1=[0.8,0.8];
P2=[2,1];
P3=[1,2];

d14=1.414;
d24=1;
d34=1;

plot(P1(1),P1(2),'or');
circle(P1(1),P1(2),d14);
plot(P2(1),P2(2),'og');
circle(P2(1),P2(2),d24);
plot(P3(1),P3(2),'ok');
circle(P3(1),P3(2),d34);

Pos=Trilaterate(P1,d14,P2,d24,P3,d34)

end

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
end



