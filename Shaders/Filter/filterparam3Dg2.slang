#pragma once

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

float cylinderDist(float3 p, float r, float3 c, float3 n, float3 d)
{
    float x = dot(p - c, n);
    float y = dot(p - c, d);

    return length(float2(x, y)) - r;

}


float getTorusDist(float3 pos, float3 fp, float3 t, float3 n, float kr, float kR)
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

    if (abs(kr) < 0.1 && abs(kR) < 0.1)
    {
        dTorus = planeDist(pos, fp, normalize(n));
       // return (dTorus);
    }

    if (abs(kR) < 0.1 && abs(kr) >= 0.1)
    {

        //recalculate the center
        c = fp + n * 1 / kr;
        dTorus = cylinderDist(pos, r, c, n, t);
        
    }

  
    if (kr < 0 && abs(kr) > 0.1)
    {
       dTorus *= -1;
    }

    return dTorus;
}


float nointerp(float3 pos)
{
  // return interp(pos);
    float3 uvw = ((pos) / float3(boundingBox) + 0.5) * (res);
    float3 p = texturep[uvw].xyz;
    float3 n = texturen[uvw].xyz;
    float3 t = texture3[uvw].xyz;

    float kr = texturep[uvw].w;
    float kR = texturen[uvw].w;
            
    float d = max(abs(getTorusDist(pos, p, t, n, kr, kR)), sphereDist(pos, p, rs));
   // d = abs(getTorusDist(pos, p, t, n, kr, kR));
    return d;

}

float getTexture(float3 uvw, float3 pos)
{
    float3 p = texturep[uvw].xyz;
    float3 n = texturen[uvw].xyz;
    float3 t = texture3[uvw].xyz;

    float kr = texturep[uvw].w;
    float kR = texturen[uvw].w;
            
    float d = getTorusDist(pos, p, t, n, kr, kR);

    d = (max(abs(d), sphereDist(pos, p, rs)));

    return (d);

}

float trilinear(float3 pos)
{
    float3 pp = ((pos) / float3(boundingBox) + 0.5);
    
    float3 fuvw = clamp(pp * (float(res)) - 0.5, 0, float(res) - 1);
    int3 uvw = clamp(fuvw, 0, res - 2);
   
    
    float d000 = getTexture(uvw, pos);
    float d100 = getTexture(uvw + float3(1, 0, 0), pos);
    float d010 = getTexture(uvw + float3(0, 1, 0), pos);
    float d001 = getTexture(uvw + float3(0, 0, 1), pos);
    float d110 = getTexture(uvw + float3(1, 1, 0), pos);
    float d101 = getTexture(uvw + float3(1, 0, 1), pos);
    float d011 = getTexture(uvw + float3(0, 1, 1), pos);
    float d111 = getTexture(uvw + float3(1, 1, 1), pos);

    float a1 = fuvw.x - uvw.x;
    float ha1 = 6 * pow(a1, 5) - 15 * pow(a1, 4) + 10 * pow(a1, 3);
    ha1 = -2 * pow(a1, 3) + 3 * pow(a1, 2);
    ha1 = a1;
  
    float d00 = d000 * (1 - ha1) + d100 * ha1;
    float d01 = d001 * (1 - ha1) + d101 * ha1;
    float d10 = d010 * (1 - ha1) + d110 * ha1;
    float d11 = d011 * (1 - ha1) + d111 * ha1;
  

    float a2 = fuvw.y - uvw.y;
    float ha2 = 6 * pow(a2, 5) - 15 * pow(a2, 4) + 10 * pow(a2, 3);
    ha2 = -2 * pow(a2, 3) + 3 * pow(a2, 2);

    ha2 = a2;
    float d0 = d00 * (1 - ha2) + d10 * ha2;
    float d1 = d01 * (1 - ha2) + d11 * ha2;
   

    float a3 = fuvw.z - uvw.z;
    float ha3 = 6 * pow(a3, 5) - 15 * pow(a3, 4) + 10 * pow(a3, 3);
    ha3 = -2 * pow(a3, 3) + 3 * pow(a3, 2);
    ha3 = a3;
    return abs(d0 * (1 - ha3) + d1 * ha3);

    return 0;

}

float filter(float3 pos)
{
#if INTERP == 0
    return nointerp(pos);
#endif
#if INTERP == 1
    return trilinear(pos);
#endif
    return nointerp(pos);
}



float getDifference(float3 p1, float3 p2)
{
   // return 1;
    return filter(p1) - filter(p2);
}

float3 getNormal_filter(float3 pos)
{
    
    float e = 0.00001;
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
