include <BOSL2/std.scad>
$fn=50;

R = 1;
x = 6.2;
y = 4.6;
z = 9;

sx = 1.4;
sy = 1.7;
sz = 8;
E = 0.1;

rotate([0,-90,0])
diff()
{
cuboid([x,y,z], rounding=R, edges="X", except=TOP)
{
align(LEFT+FRONT+UP)
{  
    cuboid([sx, sy, sz], rounding=R/2, edges="X", except=BOTTOM);

}
align(LEFT+BACK+UP)
{
    cuboid([sx, sy, sz], rounding=R/2, edges="X", except=BOTTOM);

}
align(LEFT)
{
    tag("remove") 
    translate([sx+E,0,0])
    cuboid([x+E,y-2*sy,z+E]);
}
align(LEFT+UP)
{
    tag("remove")
    translate([sx,0,-2+E])
    cuboid([x-sx+E,y-2*sy+0.4,2]);//, rounding=R/2, edges="X");
}

}
}