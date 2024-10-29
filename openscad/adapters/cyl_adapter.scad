include <BOSL2/std.scad>

D1 = 27.5;
D2 = 30;
H  = 13;
E = 0.1;
$fn = 100;

difference()
{
{
zcyl(d = D2, h = H)
align(BOTTOM)
zcyl(d = D2 + 2, h = 2);
}

zcyl(d = D1, h = H + 5 + E);
}



/*

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
}*/