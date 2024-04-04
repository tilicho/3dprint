include <BOSL2/std.scad>
include <BOSL2/screw_drive.scad>

$fn=60;
CUT = true;

H = 12;

D1 = 7.7;
D0 = 7.1;
R = D1 / 2.0;
R0 = D0 / 2.0;
N = 6;
D = 9;
ROUNDING = 5;
W = 1.2;
WZ = 0.6;
E = 0.1;

module perform_cut()
{
    if (CUT)
        front_half() children();
    else children();
}

module hex_dr_mask()
{
scale_f = R0 / R;
move([0, 0, H/2])
rotate([180,0,0])
linear_extrude(height=H, center=true, scale=scale_f)
//hexagon(ir=R);
circle(R);
}

module obj()
{

perform_cut()
diff()
cuboid([D * N + W, D + W, H + WZ - 0.1], rounding=ROUNDING, edges="Z", anchor=BOTTOM)
{
tag("remove") xcopies(D, n = N)
move([0, 0, -H/2 + WZ/2]) rotate([0, 0, 90]) hex_dr_mask();
};

}


//rotate([90, 0, 0])
{

obj();


/*#translate([0,0,2])
xcopies(D, n = N)
circle(d = 2 * R0);

#
translate([0,0,H+5])
xcopies(D, n = N)
circle(d = D);
*/
}