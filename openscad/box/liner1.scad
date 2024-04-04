include <BOSL2/std.scad>

L = 130;
H0 = 6;
H2 = 1.8;
H = H0 - H2;

R = 2;
$fn = 50;
D = 3.2;
D2 = 7.4;
E = 0.1;

dW = 3.6;

LOOSE = 0.6;
//LOOSEH = 0.6;

W = D2 + dW;

LINE1 = true;
DEBUG = true;

module line1(dz2 = 0, hole1 = true, hole2 = true)
{
    diff()
    cuboid([W, L, H + dz2], rounding=R, edges="Z")
    {
        if (hole1)
        {
            tag("remove") 
            attach(TOP) 
            translate([0, L/2 - D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D2, d1 = D, center = false); 
        }

        if (hole2)
        {

            tag("remove") 
            attach(TOP) 
            translate([0, -L/2 + D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D2, d1 = D, center = false); 

            
        }

    }
}

module flip()
{
    if (!LINE1)
        rotate([0, 180, 0]) children();
    else
        children();
}

module line2(h2 = H2)
{
    flip()
    {
        translate([-W - LOOSE, 0, 0])
        mirror([0, 0, 1])
        line1();
    
        translate([W + LOOSE, 0, 0])
        mirror([0, 0, 1])
        line1();

        
        translate([0, 0, H/2 + h2/2])
        diff()
        cuboid([W*3 + 2 * LOOSE, L, h2], rounding=R, edges="Z")
        {
            tag("remove") 
            attach(TOP) 
            translate([-W - LOOSE, L/2 - D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false); 

            tag("remove") 
            attach(TOP) 
            translate([W + LOOSE, L/2 - D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false); 

            tag("remove") 
            attach(TOP) 
            translate([-W - LOOSE, -L/2 + D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false);

            tag("remove") 
            attach(TOP) 
            translate([W + LOOSE, -L/2 + D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false);

         }

    }
}

module line1_ex(h2 = H2, dz2 = 0.6)
{

    line1();

    translate([0, 0, -H/2 - h2/2])
    diff()
    cuboid([W*3 + 2 * LOOSE, L, h2 + dz2], rounding=R, edges="Z")
    {
            tag("remove") 
            attach(TOP) 
            translate([0, L/2 - D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false); 

            tag("remove") 
            attach(TOP) 
            translate([0, -L/2 + D2, -H - E]) 
            cylinder(H + 2 * E, d2 = D, d1 = D, center = false); 

    }
}

module debug(b)
{
    if (!b)
    {
        if (DEBUG)
            #children();
    }
    else
        children();
}

debug(LINE1) line1_ex();
debug(!LINE1) line2();
