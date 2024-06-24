include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn = 100;
CUT = false;
D = 3;
D_dist = 47.5;
D_dist2 = 10;
W = 2.4;
H = 3;//10;
R = 1;
E = 0.1;
EPX = 0.2;
EPZ = 0.4;

PhoneModel = "IPhone5"; //["IPhone5", "IPhone13"]

function get_phone_x(model) = model == "IPhone13" ? 64.8 : 59;
function get_phone_y(model) = model == "IPhone13" ? 8.4 : 7.7;

Phone_x_ = get_phone_x(PhoneModel);
Phone_z_ = get_phone_y(PhoneModel);
Phone_offset_ = 25.2;
Phone_offset2 = 31.25 - 4.5;

HoleZ = 2;
HoleD = 5;

//Phone_x_ = 64.4;//59;
//Phone_z_ = 8.2;//7.7;
//Phone_offset = 29;



Phone_x = Phone_x_ + EPX;
Phone_z = Phone_z_ + EPZ;

HookX1 = 24;
HookX2 = 27;
HookX3 = 10;

module iphone_mount(model=PhoneModel,
    h = H, w = W, epx=EPX, epz=EPZ)
{
    dx = get_phone_x(model)+ epx;
    dz = get_phone_y(model)+ epz;
    
    difference()
    {
    cuboid([dx+2*w, h, dz+2*w],
        rounding=R, edges="Y" 
        //,except=[[-1, 1, -1]]
        );
    cuboid([dx, h+E, dz]
        );
    }
}

module iphone_3dprint()
{
    iphone_mount();

    translate([-Phone_x/2-W-HookX1/2-W/2, 0, -Phone_z/2-W/2])
    {
    cuboid([HookX1+W, H, W], rounding=R,
        edges = [-1,0,1]);

    translate([W/2-HookX1/2-W/2, 0, -HookX2/2-W/2])
    {
    #cuboid([W, H, HookX2]);


    translate([HookX3/2+W/2, 0, -HookX2/2-W/2])
    cuboid([HookX3+W*2, H, W], rounding=R,
        edges="Y", except = [-1, 0, 1]);
    }

    }

}

rotate([90,0,0])
//iphone_3dprint();

iphone_mount();