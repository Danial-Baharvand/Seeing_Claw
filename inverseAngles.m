function [R0,R1,R2,R3]= inverseAngles (x, y, z)
h=53;
r=30.309;
l2=170.384;
l3=136.307;
l4=40+86;
alpha=90;

b=sqrt((x^2)+(y^2))-r;
b2=b+r
c=z+l4-h;
a=sqrt((b^2)+(c^2));
n=((-a^2)+(l2^2)+(l3^2))/(2*l2*l3);
A1=atan2(sqrt(abs(1-(n^2))),n );
A2=atan2(n, -sqrt(abs(1-(n^2))));
E=atan2(c,b);
D=atan2(b,c);
B=asin((sin(A1)*l3)/a);
C=asin((sin(A1)*l2)/a);
R1=radtodeg(B+E);
R2=radtodeg(A1);
R3 = 270 - R1 - R2;
R0=-(radtodeg(atan2(y,x)));
%R3=radtodeg(C+D)
%angles={R1,R2,R3};

end



