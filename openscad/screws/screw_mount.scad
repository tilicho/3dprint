include <BOSL2/std.scad>
include <BOSL2/screws.scad>

NUT_THREAD = "M8";

SCREW_LEN = 10;
SCREW_D = "M8";
THREAD = str(SCREW_D, ",", str(SCREW_LEN));
THREAD_D_EXT = 8.5;//10;
THREAD_LEN_SCREW = 10;

SLOP = 0.2;
SLOP_SCREW = 0.05;
HEAD_SIZE = 10;
HEAD_H = 10;
HEAD_TYPE="hex";//"socket";

$fn=50;

CON_X = 17;
CON_Y = 9;//6;
CON_Z = 12;
CON_E = 0.4;//0.02;
CON_R = 6;
CON_ANCHOR = LEFT;
CON_THREADED = true;

THREAD_LEN = CON_Y*2+CON_E*2;
E = 0.1;

CON_LEFT = 1;
CON_RIGHT = 2;

SHOW_CON = "ALL";//["ALL", "LEFT", "RIGHT"]

SHOW = (SHOW_CON == "ALL" ? [CON_LEFT, CON_RIGHT] :
    (SHOW_CON == "LEFT" ? [CON_LEFT] : [CON_RIGHT]));

module perform_cut(cut=false)
{
    if (cut)
        front_half(s=200) children();
    else children();
}

module hole(hole_len, thread=true, slop=SLOP,
    teardrop=true, bevel=true)
{
    if (thread)
        screw_hole(NUT_THREAD, l=hole_len
                  , head="none", 
                  thread=thread,  
                  tolerance="8G", 
                  $slop=slop,
                  teardrop=teardrop,
                  bevel=bevel
                  );
    else
        screw_hole(NUT_THREAD, l=hole_len, head="none", 
                  thread=false,  
                  //tolerance="8G", 
                  $slop=slop);
                  //anchor=anchor);
}

module hole_hex(
    hole_len,
    rot_cyl=180/6,
    dext = THREAD_D_EXT,
    dint = 0,
    anchor=CENTER)
{
    dd = dint ? (dint / cos(180/6)) : dext;
    echo(dd, dext, dint, dd * cos(180.0/12.0), cos(180/12));
    
    yrot(rot_cyl)
      ycyl(
         d = dd, 
         l=hole_len+E, $fn=6, anchor=anchor);
}

module screw_(
    screw_len=15,
    thread_len=-1,
    head_size=12,
    head_h = 5,
    head_type="none",
    cyl_head=true)
{
    thread = str(SCREW_D, ",", str(screw_len));

    spec = screw_info(thread,head=head_type);
    newspec = struct_set(spec,[
        "head_size",head_size,
        "head_height",head_h]
        );

    rotate([0,180,0])
    screw(newspec, 
        //tolerance="6e", 
        thread_len=thread_len >= 0 ? thread_len : screw_len, 
        atype="shaft",
        undersize=SLOP_SCREW)
    
    if (cyl_head)
    {
        attach(TOP)
        {
        up(head_h/2-0.5)
            difference()
            {
            cyl(d= head_size, h = head_h, texture="trunc_ribs");
            
            up(head_h/2)
            chamfer_cylinder_mask(d=head_size+1, chamfer=1);
            }
        }
    }
}

module nut_(nut_h=6, nut_size=15, teardrop=false, chamfer=true)
{
    difference()
    {
    cyl(d = nut_size, h = nut_h, texture="trunc_ribs"
        );
    hole(nut_h+E, bevel=false, teardrop=teardrop);
    
    if (chamfer)
    {
    up(nut_h/2)
    chamfer_cylinder_mask(d=nut_size+2, chamfer=1);
    
    
    down(nut_h/2)
    rotate([180, 0, 0])
    chamfer_cylinder_mask(d=nut_size+2, chamfer=1);
    }
    }
}


module connection_base(h, dx, dy, threaded = true, anchor=CON_ANCHOR,
    rot_cyl = 180/6, slop=SLOP)
{
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    diff()
    {
       cuboid([h, dy, h],
           rounding=h/2,//CON_R,
                edges = "Y",
                except=[RIGHT],
                anchor=anchor)
      {
            if (threaded)
                tag("remove")
                rotate([90,0,0])
                hole(dy+E, slop=slop);
            else
                tag("remove")
                attach(CENTER)
                hole_hex(dy+E,rot_cyl=rot_cyl);
       
            attach(RIGHT)
            {
                cuboid([dy, h, dx-h]
                 ,anchor=BOTTOM);
            };
       }
       
    }
}

module connection_base2(
    h = CON_Z, 
    dx = CON_X, 
    dy = CON_Y, 
    threaded = true, 
    anchor=CON_ANCHOR,
    rot_cyl = 180/6, 
    slop=SLOP,
    only_one_third = false)
{
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    diff()
    {
       cuboid([h, dy, h],
           rounding=h/2,//CON_R,
                edges = "Y",
                except=[RIGHT],
                anchor=anchor)
      {
            if (threaded)
                tag("remove")
                rotate([90,0,0])
                hole(dy+E, slop=slop);
            else
                tag("remove")
                attach(CENTER)
                hole_hex(dy+E,rot_cyl=rot_cyl);
       
            attach(RIGHT)
                {
                    cuboid([dy, h, dx-h]
                     ,anchor=BOTTOM);
                };
                
            if (!only_one_third)
            {
                attach(BOTTOM)
                {
                tag("remove")
                translate([0,0,-h/2])
                ycyl(d = h+CON_E*2, h = dy/3+CON_E, anchor=CENTER);
                
                tag("remove")
                translate([0,0,-h/2])
                cuboid([h+CON_E, dy/3+CON_E, h+CON_E], anchor=CENTER);
                }
            }
            else
            {
                attach(BOTTOM)
                //yflip_copy()
                {
                tag("remove")
                translate([0,
                    -dy/2+2*dy/6-CON_E/2
                    ,-h/2])
                {
                  ycyl(d = h+CON_E, h = 2*dy/3+CON_E, anchor=CENTER);
                    
                  cuboid([h+CON_E/2, 2*dy/3+CON_E, h+CON_E/2], anchor=CENTER);
                }
                }
            }
       }
       
       //tag("remove")
       //translate([h/2,0,0])
       //ycyl(d = h+E*2, h = dy/3+CON_E, anchor=CENTER);
       
       /*#tag("remove")
       translate([h/2,0,0])
       cuboid([h, dy/3+CON_E, h+E], anchor=CENTER);*/
    }
}


module connection(
    h = CON_Z,
    dx = CON_X,
    dy = CON_Y,
    threaded = true, 
    anchor = CON_ANCHOR,
    show = [CON_LEFT, CON_RIGHT],
    rot_cyl = 180/6,
    slop=SLOP)
{
    show_left = len(search(CON_LEFT, show));
    show_right = len(search(CON_RIGHT, show));
    
    shift_y = dy/2+CON_E/2;
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    
    if (show_left)
    translate([dx_shift, shift_y,0])
    connection_base(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop);
    
    
    if (show_right)
    //rotate([0,45,0])
    translate([-dx_shift, -shift_y,0])
    xflip()
        connection_base(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop);

}

module connection2(
    h = CON_Z,
    dx = CON_X,
    dy = CON_Y,
    threaded = true, 
    anchor = CON_ANCHOR,
    show = SHOW,
    rot_cyl = 180/6,
    slop=SLOP,
    only_one_third = false)
{
    show_left = len(search(CON_LEFT, show));
    show_right = len(search(CON_RIGHT, show));
    
    shift_y = 0;//(show_left && show_right) ? dy/6 : dy/2;//dy/2+CON_E/2;
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    
    if (show_left)
    translate([dx_shift, shift_y,0])
    connection_base2(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop,
                only_one_third=only_one_third);
    
    
    if (show_right)
    //rotate([0,45,0])
    translate([-dx_shift, -shift_y,0])
    xflip()
        connection_base2(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop,
        only_one_third=only_one_third);

}

module test_screw()
{

perform_cut(true)
{
perform_cut(false)
{
!screw_();
//(screw_len=15, thread_len=10, head_size=12, head_h=5, head_type="none");

translate([0,0,15])
nut_();
}
}
}

module test_connection()
{
connection(
        h=13
        ,dx = 60 
        ,dy = 5
        ,threaded=true 
        ,show=[1] 
        ,anchor=RIGHT);
        
}
//rotate([90,0,0])
//connection(threaded = CON_THREADED, show=SHOW);

//test_screw();

test_connection();

//connection_base2();
//connection2(dx = 23, dy=5, h=13, show=[2], only_one_third = true, threaded=false, anchor=LEFT);
