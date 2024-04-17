include <BOSL2/std.scad>
DX1 = 19.4;
DX2 = 23;
DY = 6.8;

W = 10;
R1 = 2;
R2 = 2;

BX = 34.5;

Wall = 1.8;
E = 0.01;


ddx = DX2 - DX1;
$fn = 100;


FX = BX;
FY = 4;
FZ = 5;


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
/*
#prismoid(size1=[DX1, DY], 
        size2=[DX2, DY], 
        h = W);
*/

difference()
{
translate([(BX-DX1)/2 - Wall, 0, 0])
difference()
{
    union()
    {
        prismoid(size1=[BX, DY+2*Wall], 
                size2=[BX, DY+2*Wall], 
                //shift=[ddx/2, 0],
                rounding1 = R1,
                rounding2 = R2,
                h = W);

        fy = FY - 1;
        translate([BX/2-FX/2, 
                    -DY/2 - Wall + fy/2, W])
        prismoid(size1=[FX, fy],
            size2 = [FX, fy],
            rounding1 = 0,
            rounding2 = 0,
            h = FZ);
    }
    translate([0,0,W])
    stensil(10);
}

prismoid(size1=[DX1, DY], 
        size2=[DX2, DY], 
        shift=[ddx/2, 0],
        rounding1 = R1,
        rounding2 = R2,
        h = W+E);


translate([ddx/2,0,W])
prismoid(size1=[DX2, DY],
        size2 = [DX2, DY],
        rounding1 = R1,
        rounding2 = R2,
        h = W);
            
}



