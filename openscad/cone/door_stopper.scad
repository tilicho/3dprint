include <BOSL2/std.scad>

H = 14.0;

D1 = 70.0;
H1 = 7.0;
D2 = 20.0;
H2 = H - H1;
$fn = 50;


cyl(l = H1, d = D1)
align(TOP)
cyl(l = H2, d1 = D1, d2 = D2);
