include <BOSL2/std.scad>

D1 = 12.8;
D2 = 12;
D3 = 11.6;

W = 1.2;
L = 15;
L2 = 5;
$fn = 50;
E = 0.1;
CUT = false;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

rotate([180,0,0])
perform_cut()
{
    difference()
    {
    cyl(d1 = D1 + 2*W, d2 = D2 + 2*W, l = L);
    cyl(d1 = D1, d2 = D2, l = L+E);
    }

    translate([0,0,L/2])
    {
        difference()
        {
            cyl(d1 = D2 + 2*W, d2 = D3 + 2*W, l = L2, anchor=BOTTOM);
            translate([0,0,-2*W])
            cyl(d1 = D2, d2 = D3, l = L2+E, anchor=BOTTOM);
        }
    }
}