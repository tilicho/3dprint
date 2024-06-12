include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 100;
CUT = false;
D = 3;
D_dist = 47.5;
D_dist2 = 2;
W = 2.4;
H = 10;
H2 =10;
R = 1;
E = 0.1;
EPX = 0.2;
EPZ = 0.2;

HoleZ = 2;
HoleD = 5;

PhoneModel = "IPhone13"; //["IPhone5", "IPhone13"]

Phone_x_ = PhoneModel == "IPhone13" ? 64.8 : 59;
Phone_z_ = PhoneModel == "IPhone13" ? 8.4 : 7.7;
Phone_offset_ = 25.2;
Phone_offset2 = 31.25 - 4.5;

Phone_offset = Phone_offset_ - W;

Phone_x = Phone_x_ + EPX;
Phone_z = Phone_z_ + EPZ;

Rfillet = 13;
Battery_D = 18.6;
Battery_L = 68;

Stab_l = 31.9;
Stab_w = 4;//1.2;//3.6;
Stab_Hole_w = 28;
Stab_dx = 22.4;
Stab_dy = 8;
Stab_r = 2;
Stab_Hole_d = 2.6;
Stab_dz = 2.4;//4;

Stab_back_shift = 15;

Shift_x_mount = 5;

function get_battery_ext_d(fn) = 
    let (a = 360 / fn)
    let (bat_d = Battery_D / cos(a/2))
    bat_d;
    

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module stab_adapter()
{
    difference()
    {
    union()
    {
    cuboid([Stab_l, Stab_dy, Stab_w]);
    translate([0,Stab_dy, -Stab_w/2])
    cuboid([Stab_l+Stab_w, Stab_dy, Stab_w],
        rounding = Stab_r, edges = "Z",
        except=[[-1,-1,1], [1,-1,1]],
        anchor=BOTTOM);
        
    xflip_copy()
    translate([-Stab_l/2-Stab_w/4, 0, -Stab_w/2])
    cuboid([Stab_w/2, Stab_dy, Stab_w], anchor=BOTTOM);
    }
    
    xflip_copy()
    translate([Stab_Hole_w/2,0,0])
    zcyl(d = Stab_Hole_d, l = Stab_w+E);
    
    cuboid([Stab_dx, Stab_dy+E, Stab_w+E],
        rounding = Stab_r, 
            edges = "Z",
            except=[[-1,-1,1], [1,-1,1]]);
    }
}

module battery_hole(external = false)
{
    fn = 6;
    bat_d = get_battery_ext_d(fn);
    ws = W * cos (180 / fn);
    /*
    difference()
    {
    
        union()
        {
            translate([0,0,-(bat_d/2+W)/2])
            cuboid([Battery_L + W, Battery_D+2*ws, bat_d/2+W,
            ],
                rounding=R, edges="Z",
                anchor=CENTER);
            
            xcyl(d = bat_d + 2*W, l = Battery_L + W, $fn = fn, rounding=R);
        };
        
        if (!external)
            translate([W, 0, 0])
            xcyl(d = bat_d, l = Battery_L, $fn = fn); 
    }
    */
    difference()
    {
       cuboid([Battery_L + W, 
               Battery_D + 2*ws,
               bat_d+ws*2],
               rounding=R, edges="Z");
               
       if (!external)
            translate([W, 0, 0])
            xcyl(d = bat_d, l = Battery_L, $fn = fn);
    }
}

module iphone_mount()
{
    difference()
    {
    cuboid([Phone_x+2*W, H, Phone_z+2*W],
        rounding=R, edges="Y" 
        //,except=[[-1, 0, -1], [1, 0, -1]]
        );
    cuboid([Phone_x, H+E, Phone_z]
        );
    }
}

module phone_mount()
{

/*translate([0,-H2,W/2])
difference()
{
cuboid([D_dist + 2*W + D_dist2, H, W],
    rounding=R, edges="Y");
    
xflip_copy()
 translate([-D_dist/2, 0, 0])
    rotate([0, 0, 180/6])
        zcyl(l=W+E, d = D, $fn = 6);    

}

dx1 = D_dist + 2*W + D_dist2;
#
translate([0, H, Phone_offset/2])
cuboid([dx1, H, Phone_offset],
    rounding=R, edges="Y" 
    ,except=[[-1, 0, 1], [1, 0, 1]]
    ); 
    

xflip_copy()
translate([-dx1/2,H,Phone_offset])
fillet(l = H, r = R, 
    spin=180, orient=FRONT);
    
translate([0,H/2,W])
fillet(l = dx1-2*R, r = Rfillet, 
    spin=270, orient=LEFT);

color("green")
{
translate([0,0,W/2])
cuboid([D_dist + 2*W + D_dist2, H, W],
    rounding=R, edges="Y");

}*/

{

ws = W * cos (180 / 6);
bat_d = get_battery_ext_d(6);
shift_z = bat_d/2 + ws - H/2;

//translate([0,0,bat_d+ws*2])
translate([0, -shift_z, (Phone_z+2*W)/2])
translate([0, 0, Phone_offset2+Stab_back_shift])
iphone_mount();



cubez = (Phone_offset2+Stab_back_shift-Battery_D-ws*2);
color("blue")
translate([0, -shift_z, ws*2 + Battery_D])
cuboid([2*H,H,cubez], anchor=BOTTOM);

}



}

module phone_mount_with_battery()
{
fn  = 6;

rotate([-90, 0, 0])
phone_mount();


bat_d = get_battery_ext_d(fn);
ws = W * cos (180 / fn);

translate([Shift_x_mount, Phone_offset/2 , 0])
difference()
{
battery_hole();
xcyl(d = Battery_D/3, l = Battery_L*3, $fn=4);
}

translate([Shift_x_mount, Phone_offset/2 , -bat_d-ws])
difference()
{
battery_hole();
xcyl(d = Battery_D/3, l = Battery_L*3, $fn=4);
}



}




//bat_test();
//battery_hole();

difference()
{
ws = W * cos (180 / 6);
bat_d = get_battery_ext_d(6);
zshift = -bat_d - ws -bat_d/2-ws-Stab_dy/2-1;

translate([0, Stab_w/2+Stab_back_shift-Stab_w, zshift])//-2*H])
//xflip()
rotate([90,0,0])
stab_adapter();


translate([0, Phone_offset/2 , -bat_d - ws])
battery_hole(true);
}

phone_mount_with_battery();

//stab_adapter();
