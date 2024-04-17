include <BOSL2/std.scad>
DX1 = 19.4;
DX2 = 23;
DY = 6.4;

W = 9;
R1 = 2;
R2 = 2;

BX = 34.5;

Wall = 1.2;
E = 0.01;


ddx = DX2 - DX1;
$fn = 100;
CUT = false;
MIRROR = true;

FX = BX;
FY = 4;
FZ = 5;


ShiftY = 1;
ShiftX = 1;

module perform_cut(needcut = false)
{
    if (needcut)
        front_half(s=200) children();
    else if (CUT)
        front_half(s=200) children();
    else children();
}

module perform_mirror()
{
    if (MIRROR)
        mirror([0, 1, 0]) children();
    else children();
}

module stensil(sl)
{
SL = sl;
difference()
{
prismoid(size1=[BX+SL, DY+2*Wall+SL], 
        size2=[BX+SL, DY+2*Wall+SL], 
        //shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W + E);

prismoid(size1=[BX, DY+2*Wall], 
        size2=[BX, DY+2*Wall], 
        //shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W + E);
}
}


module stensil2(sl)
{
if (1)
{
right_half(s=200)
difference()
{
bx = BX;
bx2 = bx - 15;

prismoid(size1=[bx+sl, DY+2*Wall+sl], 
        size2=[bx+sl, DY+2*Wall+sl], 
        //shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W + E);

prismoid(size1=[bx2, DY+2*Wall+ShiftY], 
        size2=[bx, DY+2*Wall+ShiftY], 
        //shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W + E);
}
}
}


perform_mirror()
perform_cut()
difference()
{
translate([(BX-DX1)/2 - Wall, 0, 0])
difference()
{
    union()
    {
        prismoid(
                size1=[BX-ShiftX, DY+2*Wall], 
                size2=[BX, DY+2*Wall+ShiftY], 
                shift=[0, -ShiftY/2],
                rounding1 = R1,
                rounding2 = R2,
                h = W);

        fy = FY+0.2;
        
        translate([BX/2-FX/2, 
            -DY/2 - Wall + fy/2 - ShiftY, 
                    W])
        prismoid(size1=[FX, fy],
            size2 = [FX, fy],
            rounding1 = 0,
            rounding2 = 0,
            h = FZ);
    }
    translate([0,-ShiftY,W])
    stensil(10);
    
    translate([0,-ShiftY/2,0])
    stensil2(10);
}

prismoid(size1=[DX1, DY], 
        size2=[DX2, DY], 
        shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W+E);

SDX = 0.6;

translate([ddx/2,0,W])
prismoid(size1=[DX2, DY],
        size2 = [DX2+SDX, DY+SDX],
        rounding1 = R1,
        rounding2 = R2,
        h = W);
            
}


//perform_cut(true) stensil2(10);



