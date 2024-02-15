#pragma once

#define PI 3.14159265359

#ifndef SHAPE
#define SHAPE 0
#endif

//u,v in [0,1]

float sphereI(float3 p)
{

    return p.x*p.x + p.y*p.y + p.z*p.z - 1;

}

float3 spheregradient(float3 p)
{

   float3 g ;

    g.x = 2 * p.x;
    g.y = 2 * p.y;
    g.z = 2 * p.z;

    return g;
}

float3x3 sphered2(float3 p)
{
    return float3x3(3, 0, 0, 0, 3, 0, 0, 0, 3);
}


float torusI(float3 p)
{
    return pow(p.x * p.x + p.y * p.y + p.z * p.z + 0.5 * 0.5 - 0.2, 2) - 4 * 0.5 * 0.5 * (p.x * p.x + p.y * p.y);
}

float3 torusgradient(float3 p)
{

    float3 g;
    g.x = 4 * p.x * (-0.45 + p.x*p.x + p.y*p.y + p.z*p.z);
    g.y = 4 * p.y * (-0.45 + p.x*p.x + p.y*p.y + p.z*p.z);
    g.z = 4 * p.z * (-0.05 + p.x * p.x + p.y * p.y + p.z * p.z);
    return g;
}

float3x3 torusd2(float3 p)
{
    return float3x3(1 + (-1.8+12* p.x * p.x + 4*p.y * p.y + 4* p.z * p.z), 8 * p.x * p.y, 8 * p.x * p.z,
    8 * p.x * p.y, 1 +  (-1.8 + 12 * p.x * p.x + 4*p.y * p.y + 4*p.z * p.z), 8 * p.y * p.z,
    8 * p.x * p.z, 8 * p.y * p.z, 1 + 4 * (-0.2 + p.x * p.x + p.y * p.y + 3* p.z * p.z));

}


float mapI(float3 p)
{
    #if SHAPE == 0
        return sphereI(p);
    #endif
#if SHAPE == 1
    return torusI(p);
    #endif
   
   
    return 10;
}

float3 gradientI(float3 p)
{
#if SHAPE == 0
    return spheregradient(p);
#endif
#if SHAPE == 1
    return torusgradient(p);
    #endif
   
   
    return float3(0, 0, 0);
}

float3x3 d2I(float3 p)
{
#if SHAPE == 0
    return sphered2(p);
#endif
#if SHAPE == 1
    return torusd2(p);
    #endif

    return float3x3(1,0,0,0,1,0,0,0,1);

}



