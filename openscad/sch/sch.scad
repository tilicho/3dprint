include <BOSL2/std.scad>

Y = 29;
L = 5;
DL = 5;
H = 3.6;

dE = 0.01;
$fn = 50;
R = 2.5;

W = L * 2 + DL * 3;


diff()
cuboid([W, Y + 2 * DL, H], rounding=R, edges = "Z")
{
tag("remove") translate([-DL/2 - L/2, 0, 0]) cuboid([L, Y, H + 2*dE], rounding = R, edges = "Z");

tag("remove") translate([DL/2 + L/2, 0, 0]) cuboid([L, Y, H + 2*dE], rounding = R, edges = "Z");
};