#pragma once

#ifndef MINM
#define MINM 0
#endif

#ifndef INTERP
#define INTERP 0
#endif

float planeDist(float3 pos, float3 p, float3 n)
{
    float h = -dot(n, p);
    return dot(pos, n) + h;
}

float sphereDist(float3 pos, float3 p, float r)
{
    return length(pos - p) - r;
}

float wk(int i, int j, float3 pos)
{
    float3 p = texturep[float2(i, j)].xyz;
    float3 n = texturen[float2(i, j)].xyz;

    float d = abs(planeDist(pos, p, n));

    return 1 / d;

}

float interp(float3 pos)
{
    float s = 0;

    float dist = 0;

    float d[4] = { 100, 100, 100, 100 };
    
    float pp[4] = { 100, 100, 100, 100 };

    for (int i = 0; i < nx* res; i++)
    {
        for (int j = 0; j < res; j++)
        {
            float3 p = texturep[float2(i, j)].xyz;
            float3 n = texturen[float2(i, j)].xyz;

            float dist = -planeDist(pos, p, n);


           
            int k = 0;
            while (k < 4 && pp[k] < length(p - pos))
            {
                k++;
            }

            if (k < 4)
            {
                int l = 3;

                while (l > k)
                {
                    d[l] = d[l - 1];
                    pp[l] = pp[l - 1];
                    l--;
                }
                d[k] = dist;
                pp[k] = length(p - pos);
            }

        }
    }

    float di = 0;
    float sum = 0;

    for (int l = 0; l <4; l++)
    {
        di += d[ l];
        sum += pp[l];

    }
    
    return abs(di / 4.f);
}

float nointerp(float3 pos)
{
  // return interp(pos);
    float mind = 1000000;
    float3 minp = float3(10000);

    for (int i = 0; i < nx*res; i++)
    {
        for (int j = 0; j < res; j++)
        {
            float3 p = texturep[float2(i, j)].xyz;
            float3 n = texturen[float2(i, j)].xyz;

            float d = max(abs(planeDist(pos, p, n)), sphereDist(pos, p, rs));

#if MINM == 1
            if (  ( length(pos - minp) > length(pos - p)))
            {
                mind = d;
                minp = p;
            }
#endif
#if MINM == 0
            if (d < mind)
            {
                mind = d;
                minp = p;
            }

          
#endif
        }
    }

    return mind;

}

float filter(float3 pos)
{
    #if INTERP == 0
    return nointerp(pos);
    #endif
    #if INTERP == 1
    return interp(pos);
#endif
    return 1;
}



float getDifference(float3 p1, float3 p2)
{
   // return 1;
    return filter(p1) - filter(p2);
}

float3 getNormal_filter(float3 pos)
{
    
    float e = 0.000001;
    float3 n;

    
    float3 p1 = pos + float3(e, 0, 0);
    float3 p2 = pos - float3(e, 0, 0);

    n.x = getDifference(p1, p2);
    
    
    float3 p12 = pos + float3(0, e, 0);
       
    float3 p22 = pos - float3(0, e, 0);
   
    n.y = getDifference(p12, p22);
    
    
    
    float3 p13 = pos + float3(0, 0, e);
     
    float3 p23 = pos - float3(0, 0, e);
      
    n.z = getDifference(p13, p23);

   
    return normalize(n);
}
