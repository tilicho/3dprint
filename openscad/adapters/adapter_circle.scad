include <BOSL2/std.scad>

D1 = 50.8;
H1 = 8.2;
W = 1.2;
E = 0.1;
$fn = 100;

H2 = 3.5;
D2 = 48.8;

rotate([180, 0, 0])
{
    difference()
    {
        cyl(d = D1, h = H1);
        cyl(d = D1 - W*2, h = H1 + E);
    }

    translate([0, 0, H1/2+H2/2])
    {
        difference()
        {
            cyl(d1 = D1, d2 = D2, h = H2); 
            cyl(d1 = D1 - 2*W, d2 = D2 - 2*W, h = H2 + E); 
        }
    }
}