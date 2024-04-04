Angle = 30;//[0:1:90]
Len = 350;//[0:1:1000]
Num = 3;//[0:1:10]
R = 10;//[0:1:50]
Scale = 0.5;//[0:0.1:1.2]
N = 2;//[0:1:5]

StepRot = 30; //[0:1:180]

module obj(r = 10, h = 130)
{
    cylinder(r=r, h=h, r2 = r / 4, center=false);
    //cube([r, 10, h]);
}

function mtrans(zoff) =
    [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, zoff],
        [0, 0, 0, 1]
    ];


function mrot(an) = 
    [
        [cos(an), 0, sin(an), 0],
        [0, 1, 0, 0],
        [-sin(an), 0, cos(an), 0],
        [0, 0, 0, 1]
    ];

function scalem(z = 1) = 
    [
        [z, 0, 0, 0],
        [0, z, 0, 0],
        [0, 0, z, 0],
        [0, 0, 0, 1]
    ];

function new_matrix(orig_matrix, an, trans, scalez) = 
      orig_matrix * mtrans(trans) * mrot(an) * scalem(scalez);


module node(parent_matrix, an, trans, scalez = 1) 
{
    new_mat = new_matrix(parent_matrix, an, trans, scalez);
    
//mtrans(trans) * mrot(an) * scalem(scalez) * parent_matrix;
    multmatrix(new_mat) children();
}

module branch(orig_matrix, n_sub, an, trans, scalez = 0.5)
{
        dz = trans / n_sub;
        cur_scale = 1;

        node(orig_matrix, 0, 0, 1) children();

        for (i = [0:1:n_sub-1])
        {
            cur_scale =  scalez * 1 / (i + 1); 

            //1 / (i + 1);//1 / exp(i); //scalez * pow(scalez, i); //1 / (i + 1); //scalez;
            echo(cur_scale);
            z = i * dz;
            node(orig_matrix, an, z, cur_scale) children();
            node(orig_matrix, -an, z, cur_scale) children();
        }
}

module tree(orig_matrix, n_sub, an, trans, scalez = 1, n=3)
{
    if (n > 0)
    {
        dz = trans / n_sub;
        cur_scale = 1;

        
        
        for (i = [0:1:n_sub-1])
        {
            cur_scale =  scalez / (1 * (i + 1)); 

            //1 / (i + 1);//1 / exp(i); //scalez * pow(scalez, i); //1 / (i + 1); //scalez;
            //echo(cur_scale);
            z = i * dz;
            node(orig_matrix, an, z, cur_scale) children();
            node(orig_matrix, -an, z, cur_scale) children();
            
            new_mat = new_matrix(orig_matrix, an, z, cur_scale);
            tree(new_mat, n_sub, an, trans, scalez, n - 1) children();

            new_mat2 = new_matrix(orig_matrix, -an, z, cur_scale);
            tree(new_mat2, n_sub, an, trans, scalez, n - 1) children();
        }
    }
}


//multmatrix(mrot(30) * mtrans(10)) obj();

orig_matrix1 = mrot(0) * mtrans(0);
orig_matrix = new_matrix(orig_matrix1, 0, 0, 0.9);
/*node(orig_matrix, 30, 10) obj();
*/




//branch(orig_matrix, Num, Angle, Len) obj(R, Len);
//new_mat = new_matrix(orig_matrix, Angle, 0, 0.5);
//branch(new_mat, Num, Angle, Len) obj();
node(orig_matrix, 0, 0, 1) obj(R, Len);

for (r = [0:StepRot:180])
{
   rotate([0, 0, r]) 
   tree(orig_matrix, Num, Angle, Len, Scale, N) obj(R, Len);
}