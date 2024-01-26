
RWStructuredBuffer<float3> b;

RWStructuredBuffer<float2> nm; //the number of controlpoints on the patches

//db - number of controlpoints before the patch we need
//k - the number of the patch we will use

float factorial(float f)
{

    float r = 1;
    for (int i = 1; i <= f; i++)
    {
        r *= i;
    }

    return (float) r;
}

float bernstein(float k, float i, float u)
{
    float bi = factorial(k) / (float) (factorial(i) * factorial(k - i));

    float p1 = pow(u, i);

    float p2 = pow(1 - u, k - i);

    if (i == 0)
    {
        p1 = 1;
    }

    if (k - i == 0)
    {
        p2 = 1;
    }

    return bi * p1 * p2;

}

float3 bij(float i, float j, int db, int k)
{
    //return float3((i) / 20.f, sin(i/10.f)/3.f, (j) / 20.f);
   
    return b[db + i * (nm[k].y + 1) + j];
}

float3 bezier(float u, float v, float k) //k is the number of the bezier surface
{
    float3 r = 0;

    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }

    for (int i = 0; i <= nm[k].x; i++)
    {
        for (int j = 0; j <= nm[k].y; j++)
        {
            r += (bij(i, j,db,k) * bernstein(nm[k].x, i, u) * bernstein(nm[k].y, j, v));

        }
    }

    return r;

}

float3 bezierdu(float u, float v, float k)
{
    float3 r = 0;

    
    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }

    for (int i = 0; i <= nm[k].x - 1; i++)
    {
        for (int j = 0; j <= nm[k].y; j++)
        {
            r += (bij((i + 1), j,db,k) - bij(i, j,db,k)) * bernstein(nm[k].x - 1, i, u) * bernstein(nm[k].y, j, v);

        }
    }

    return nm[k].x * r;
}

float3 bezierdv(float u, float v, float k)
{
    float3 r = 0;
    
    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }

    for (int i = 0; i <= nm[k].x; i++)
    {
        for (int j = 0; j <= nm[k].y - 1; j++)
        {
            r += (bij(i, (j + 1),db,k) - bij(i, j,db,k)) * bernstein(nm[k].x, i, u) * bernstein(nm[k].y - 1, j, v);

        }
    }

    return nm[k].y * r;
}


float3 bezierduu(float u, float v, float k)
{
    float3 r = 0;
    
    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }
  
    for (int i = 0; i <= nm[k].x - 2; i++)
    {
        for (int j = 0; j <= nm[k].y; j++)
        {
            r += (bij((i + 2), (j),db,k) - 2 * bij((i + 1), j,db,k) + bij(i, j,db,k)) * bernstein(nm[k].x - 2, i, u) * bernstein(nm[k].y, j, v);

        }
    }
   
    return nm[k].x * (nm[k].x - 1) * r;
}

float3 bezierdvv(float u, float v, float k)
{
    float3 r = 0;
    
    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }
  

    for (int i = 0; i <= nm[k].x; i++)
    {
        for (int j = 0; j <= nm[k].y - 2; j++)
        {
            r += (bij((i), (j + 2), db, k) - 2 * bij(i, (j + 1), db, k) + bij(i, j, db, k)) * bernstein(nm[k].x, i, u) * bernstein(nm[k].y - 2, j, v);

        }
    }
    
    return nm[k].y * (nm[k].y - 1) * r;
}


float3 bezierduv(float u, float v, float k)
{
    float3 r = 0;
 
    float db = 0;
    for (int l = 0; l < k; l++)
    {
        db += (nm[l].x + 1) * (nm[l].y + 1);

    }
  

    for (int i = 0; i <= nm[k].x - 1; i++)
    {
        for (int j = 0; j <= nm[k].y - 1; j++)
        {
            r += (bij((i + 1), (j + 1), db, k) - bij((i + 1), j, db, k) - bij((i), (j + 1), db, k) + bij(i, j, db, k)) * bernstein(nm[k].x - 1, i, u) * bernstein(nm[k].y - 1, j, v);

        }
    }
   
    return nm[k].x * nm[k].y * r;
}
