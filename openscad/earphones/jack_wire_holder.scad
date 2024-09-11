include <BOSL2/std.scad>

D = 8.4;
D_small = 6.4;
L = 21.5;
L2 = 5;

D2 = 6;
H = 16;
DX = 24;
E = 0.1;
$fn = 50;
R = 2;

DCABLE = 4;
DHole = 3.9;
LHole = 5.5;

CAP_H = 2;
DCapHole = 2.5;

BASE = true;
CAP = true;
CUT = false;

module perform_cut(cut=false)
{
    if (cut)
        left_half(s=200) children();
    else children();
}

module holes(d = DHole, dy = -(L+L2+E)/2, chamfer=0)
{
translate([(DX/2-D/2)/2 + D/2,dy,0])
ycyl(d = d, l = LHole, anchor=FRONT, chamfer1=chamfer);

translate([-D,dy,(H/2-DCABLE/2)/2+DCABLE/2])
ycyl(d = d, l = LHole, anchor=FRONT, chamfer1=chamfer);
}

module base()
{

difference()
{
cuboid([DX, L+L2, H], rounding=R, edges="Y");

translate([0,-L2/2,0])
ycyl(d = D, l = L+E, anchor=CENTER);

ycyl(d = D2, l = L+L2+E, anchor=CENTER);

cuboid([DX/2+E, L+L2+E, DCABLE], anchor=RIGHT);

holes(d = DHole, dy = -(L+L2+E)/2, chamfer=-0.5);
}

}

module cap()
{
difference()
{
cuboid([DX, CAP_H, H], rounding=R, edges="Y");
ycyl(d = D_small, l = CAP_H+E, anchor=CENTER, chamfer=-0.5);
holes(d = DCapHole, dy = -CAP_H, chamfer=-2);
}
}


rotate([-90,0,0])
perform_cut(CUT)
{
if (BASE)
base();

if (CAP)
translate([-L-L2,0,0])
rotate([180,0,0])
cap();
}