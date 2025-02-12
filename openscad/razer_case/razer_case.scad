include <BOSL2/std.scad>

H = 14.0;

D1 = 90.0;

D2 = 60.0;

H2 = 45;
H1 = 9;

W = 2.4;

R = 1;
USB_W = 9+R;
USB_H = 17+R;


H3 = 3.5;
D4 = 20;
$fn = 50;

CUT = false;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module usb()
{
    cuboid([USB_W, D1/2, USB_H], rounding=3);
}

module cone(wall = 0, usb = false)
{
cyl(l = H1, d = D1+wall)
align(TOP)
{
cyl(l = H2, d1 = D1+wall, d2 = D2+wall);
if (usb)
{
    translate([0,D1/2,0])
    usb();
}
}

}

//usb();

module base()
{

difference()
{

cone(wall=W);

cone(wall=0, usb=true);

}

}

module cup()
{
    difference()
    {
        cyl(l = H3, d2 = D2 + 3*W+1, d1 = D2 + 2*W+1);
        
        translate([0,0,W/2])
        cyl(l = H3, d2 = D2 + 2*W+1, d1 = D2 + W+1);
        
        cyl(l=H3, d = D4);
        
        
        translate([0,-25,0])
        cuboid([10, 20+D4/3, H3+W], 
            anchor=FRONT, 
            edges="Z", rounding=3);
    }
        
}

perform_cut()
{

base();


translate([0,0,H2+H1/2])
zflip()
!cup();
}