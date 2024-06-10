include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn = 50;
E = 0.1;

BASE = true;
D = 15;
DI = 6;
W = 2.4;
H = 12;


LEG = true;
CUBE_X = 15;
RC = 1;
D_C_ = 8;

LEG_L = 30;
LEG_H2 = 2.4;

D_C = D_C_ / cos(180/6);


module base()
{

difference()
{
cyl(d= D, l=H);
cyl(d = DI, l=H+E);
}

zrot_copies(n=3)
translate([D/2-RC, 0, 0])
{
    difference()
    {
        cuboid([CUBE_X, W, H], anchor=LEFT, rounding=RC, edges="Z");

        translate([CUBE_X/2,0,0])
            yrot(180/6)
                ycyl(d = D_C, l=W+E, $fn=6);
    }
}

}

module leg()
{

dx = CUBE_X/2 - D_C/2;
translate([D/2-dx, W+E, 0])
{
    difference()
    {
        translate([-3*RC + CUBE_X/2, 0, 0])
        {
            difference()
            {
                cuboid([LEG_L, W, H], anchor=LEFT, rounding=RC, edges="Z");
                rotate([0, 7, 0])
                    translate([-RC,0,H])
                        cuboid([LEG_L+2*RC, W+E, H], anchor=LEFT, rounding=RC, edges="Z");

            }
            /*yrot(90)
            zrot(90)
            prismoid(size1=[W, H], size2=[W, LEG_H2], h = LEG_L,
                shift=[0, (LEG_H2-H)/2],
                anchor=BOTTOM
                );*/
        }
    
        translate([CUBE_X/2,0,0])
            yrot(180/6)
                ycyl(d = D_C, l=W+E, $fn=6);

    }
}
}



if (BASE)
base();

zrot_copies(n= BASE && LEG ? 3 : 1)
if (LEG)
leg();