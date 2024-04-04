include <BOSL2/std.scad>

H = 7;
R = 30;
N = 5;
S = 1.5;

linear_extrude(H, scale = S)
star(n=N, r=R, step=2);

translate([0,0,H])
linear_extrude(H, scale = 1/S)
star(n=N, r=R*S, step=2);