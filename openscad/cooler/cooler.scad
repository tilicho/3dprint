include <BOSL2/std.scad>
include <BOSL2/screws.scad>
DX_ = 100;
DY_ = 71.4;
WALL = 9;

DX = DX_ + WALL;
DY = DY_ + WALL;

H = 7;
R = 5;
D = 5;
E = 0.1;
$fn = 100;

Part2W = 8;
Part2WGapX = 0.4;
Part2WGapY = 16;
Part2H = 9;
Part2R = R;


VholeLen = 5;
VholeD = 5.8;
VholeD2 = 5.8;
P2HexOuter = 5.8;//8.4;
P2VholeD = 4.2; 

INNER_FRAME = true;
OUTER_FRAME = true;
PRINTER_FRAME = true;
PLANK = true;

module make_hole(dd = 5, hdx, hdy, h)
{
    translate([hdx, hdy, 0]) 
        cyl(l = h+E, d = dd);
}


module make_vhole()
{
    translate([DX/2-VholeLen/2,0,0])
        rotate([0, 90, 0])
            hex_drive_mask(VholeD, length=VholeLen+E);
        //xcyl(l = VholeLen+E, d = VholeD);
}

module frame_with_holes(dx, dy, d, rf, wall, h)
{
    ndx = dx + wall;
    ndy = dy + wall;
    //hdx = (ndx - wall) / 2;
    hdy = ndy / 2 - wall/2;
    hdx = hdy;
 
    diff()
    rect_tube(size=[ndx, ndy], wall=wall, 
        rounding=rf, irounding=rf, h=h, center=true)
    {
        tag("remove")
            yflip()
            {
                make_hole(d, hdx, hdy, h);
                xflip()
                    make_hole(d, hdx, hdy, h);
            }
        tag("remove") make_hole(d, hdx, hdy, h);
               
        tag("remove") xflip()
            make_hole(d, hdx, hdy, h);
    
    }
}


module frame_part1()
{
    frame_with_holes(DX_, DY_, VholeD, R, WALL, H);
}



module frame1()
{
    difference()
    {
        frame_part1();

        make_vhole();

        xflip()
            make_vhole();
            
    }
}

P2DX = DX + /*2*WALL*/ + 2*Part2WGapX + WALL;
P2DY = DY + /*2*WALL*/ + 2*Part2WGapY + WALL;

module make_vhole_outer()
{
    translate([(P2DX)/2,0,0])
        xcyl(l = Part2W+E, d = P2VholeD);
}

module make_hhole_outer(dx = 10, doo = P2VholeD)
{
    translate([dx,(P2DY)/2,0])
        ycyl(l = Part2W+E, d = doo);
        //hex_drive_mask(5, length=Part2W+E);
}



module make_hex_outer()
{
    translate([(P2DX-WALL*2)/2,0,0])
        rotate([0, 90, 0])
            hex_drive_mask(P2HexOuter, length=Part2W+E);
}
CutY = 5;

module round_half()
{
translate([(-P2DX)/2,CutY,0])
        back_half(s=200)
            cuboid([Part2W, Part2W, Part2H],  rounding=2, edges="Z");
}

module frame2()
{
    
    
    front_half(s=200, y = CutY) 
    difference()
    {
        
        rect_tube(size=[P2DX+Part2W, P2DY+Part2W], wall=Part2W, 
                rounding=Part2R, irounding=Part2R, h=Part2H, center=true);
                
            
            
        make_vhole_outer();
        xflip()
            make_vhole_outer();
            
            
        make_hex_outer();
        xflip()
            make_hex_outer();
            
        yflip()
        make_hhole_outer(0, VholeD2);
    
        /*yflip()
        {
            make_hhole_outer();
            xflip()
                make_hhole_outer();
        }*/
    }
    
    round_half();
    xflip()
        round_half();
    
}

module frame_part3_top(dx, dy, h)
{
    additional_hole_dx = 30;
    translate([0, 0, h/2])
    {
        difference()
        {
            cuboid([dx, dy, h], rounding=3, edges="Z");
            translate([0, 0, (h/2)/3])
                ycyl(l = h, d = VholeD2);
                
            translate([additional_hole_dx, 0, (h/2)/3])
                ycyl(l = h, d = VholeD2);
                
            xflip()
            translate([additional_hole_dx, 0, (h/2)/3])
                ycyl(l = h, d = VholeD2);
        }
    }
}

module frame_part3()
{
    dx = 40;
    d = 4;
    r = 4;
    wall = 10;
    h = 6.6;
    hatx = 80;
    rfillet = 8;
    l = 80;
    
    pw = wall * 1.2;
    
    frame_with_holes(dx, dx, d, r, wall, h);

    
    
    my = l/2 + (dx + wall)/2;
    translate([0, my, 0])
    cuboid([pw, l, h]);
    
    translate([0, my + l/2, -h/2])
    frame_part3_top(hatx, h, h*3);
    
    {
        translate([pw/2, (dx+wall)/2, 0])
        fillet(l = h, r = rfillet);
        
        xflip()
        translate([pw/2, (dx+wall)/2, 0])
        fillet(l = h, r = rfillet);
        
        translate([pw/2, (dx+wall)/2+l-h/2, 0])
        fillet(l = h, r = rfillet, spin=270);
        
        xflip()
        translate([pw/2, (dx+wall)/2+l-h/2, 0])
        fillet(l = h, r = rfillet, spin=270);
    }
}

module frame_part4_top(dx, dy, h)
{
    translate([0, 0, h/2])
    {
        difference()
        {
            cuboid([dx, dy, h], rounding=2, edges="Y");
            
            translate([0, 0, -h/2 + dx/2])
            ycyl(l = h, d = VholeD2);
            
            zflip()
            translate([0, 0, -h/2 + dx/2])
            ycyl(l = h, d = VholeD2);
        }
    }
}

if (INNER_FRAME)
frame1();

if (OUTER_FRAME)
color("red") frame2();

if (PRINTER_FRAME)
color("yellow")
translate([0, -P2DY+Part2W- 100, 0])
{
    frame_part3();
}

if (PLANK)
color("blue")
translate([90, 0, 0])
rotate([90, 0, 0])
frame_part4_top(9, 5, 60);



