#pragma once

#ifndef MINM
#define MINM 0
#endif

float planeDist(float3 pos, float3 p, float3 n)
{
    float h = -dot(n, p);
    return dot(pos, n) + h;
}

float sdTorus(float3 p, float3 center, float3 axis, float r, float R)
{
    float3 p2 = p - center;
    float3 e2 = normalize(axis);
    float3 n = cross(e2, normalize(p2));

    float3 e1 = normalize(cross(e2, n));

    float px = dot(e1, p2);
    float py = dot(e2, p2);

    float dist1 = sqrt((px - R) * (px - R) + py * py) - r;
    float dist2 = sqrt((px + R) * (px + R) + py * py) - r;

    if (dist1 * dist2 < 0) //egymásbalóg a tórusz
    {
    
        return min(dist1, dist2);
    }
    
    if (abs(dist1) <= abs(dist2))
        return dist1;
    else
        return dist2;


}

float sphereDist(float3 pos, float3 p, float r)
{
    return length(pos - p) - r;
}

float getTorusDist(float3 pos, float3 fp, float3 t,float3 n, float kr, float kR)
{
    float r = 1.0f / abs(kr);
    float R;

    //bigger (according to the orientation of the torus)
    if (kr * kR > 0)
    {
        R = 1.0f / abs(kR) - r;
    }
    else
    {
        R = 1.0f / abs(kR) + r;
    }

    //calculate center
    float3 c = fp + n / kR;


    //calculate frequently used values
    float dTorus = sdTorus(pos, c, t, r, R);

   if (R < 0.01)
    {
    
        c = fp + n / kr;
         dTorus = sphereDist(pos, c, r);
    }

    return dTorus;
}





float filter(float3 pos)
{

    float mind = 1000000;
    float3 minp = float3(10000);

    for (int i = 1; i < res; i++)
    {
        for (int j = 0; j <res; j++)
        {
            float3 p = texturep[float2(i, j)].xyz;
            float3 n = texturen[float2(i, j)].xyz;
            float3 t = texture3[float2(i, j)].xyz;

            float kr = texturep[float2(i, j)].w;
            float kR = texturen[float2(i, j)].w;
            
            float d = max(abs(getTorusDist(pos, p, t, n, kr, kR)) ,sphereDist(pos, p, rs));

#if MINM == 1
            if (  ( length(pos - minp) >= length(pos - p)))
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
