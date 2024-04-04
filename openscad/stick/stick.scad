include <BOSL2/std.scad>

D1 = 9;
D2 = 15;
ED = 0.4;

R1 = (D1 - ED) / 2;
R2 = (D2 + ED) / 2;
L = 63;
WALL = 1.8;
BASE = 2.4;
EPS=0.1;
$fn = 50;
CUT = true;


module do_cut()
{
    if (CUT)
        left_half() children();
    else
        children();
}

module half_cphere(r, wall)
{
    bottom_half()
        diff()
            spheroid(r = r + wall, $fn=15)
            tag("remove") spheroid(r = r);
}

module disk1(r, h)
{
    linear_extrude(h, center=true)
    circle(r= r);
}

module do_disk(r1, r2, h)
{
    diff()
    {
      disk1(r1, h);
      tag("remove") disk1(r2, h + 2 * EPS);
    }
}

module stick_holder()
{

    diff()
    cyl(h = L, r1= R1+WALL, r2 = R2+WALL)
    tag("remove") cyl(h = L+EPS, r1 = R1, r2 = R2);

    move([0,0,-L/2])
    half_cphere(R1, WALL);

    move([0, 0, L/2])
    do_disk(R2 + WALL + BASE, R2, WALL);
    
}

rotate([180, 0, 0])
do_cut()
stick_holder();