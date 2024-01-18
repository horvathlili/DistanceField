#pragma once

#define PI 3.1415

#ifndef SHAPE
#define SHAPE 0
#endif

//u,v in [0,1]

float3 sphereP(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = sin(u) * cos(v);
    float y = cos(u);
    float z = sin(u) * sin(v);

    return float3(x, y, z);

}

float3 spheredu(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = cos(u) * cos(v);
    float y = -sin(u);
    float z = cos(u) * sin(v);

    return float3(x, y, z);
}

float3 spheredv(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = sin(u) *-sin(v);
    float y = 0;
    float z = sin(u) * cos(v);

    return float3(x, y, z);
}

float3 sphereduu(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = -sin(u) * cos(v);
    float y = -cos(u);
    float z = -sin(u) * sin(v);

    return float3(x, y, z);
}

float3 sphereduv(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = cos(u) * -sin(v);
    float y = 0;
    float z = cos(u) * cos(v);

    return float3(x, y, z);
}

float3 spheredvv(float u, float v)
{
    u *= PI;
    v *= 2 * PI;

    float x = sin(u) * -cos(v);
    float y = 0;
    float z = -sin(u) * sin(v);

    return float3(x, y, z);
}

float3 mapP(float u, float v)
{
    #if SHAPE == 0
        return sphereP(u,v);
    #endif
}

float3 getdu(float u, float v)
{
#if SHAPE == 0
    return spheredu(u, v);
#endif
}

float3 getdv(float u, float v)
{
#if SHAPE == 0
    return spheredv(u, v);
#endif
}

float3 getduu(float u, float v)
{
#if SHAPE == 0
    return sphereduu(u, v);
#endif
}

float3 getduv(float u, float v)
{
#if SHAPE == 0
    return sphereduv(u, v);
#endif
}

float3 getdvv(float u, float v)
{
#if SHAPE == 0
    return spheredvv(u, v);
#endif
}

float2 convertParam(float u, float v)
{
    #if SHAPE == 0
    return float2(u * PI, v * 2 * PI);
    #endif
}

float3 getDifferenceP(float2 p1, float2 p2)
{
    return mapP(p1.x,p1.y) - mapP(p2.x,p2.y);
}

float3 getNormalP(float u, float v)
{
    
    float e = 0.0001;
    float3 n1,n2;

    
    float2 p1 = float2(u + e, v);
    float2 p2 = float2(u - e, v);

    n1 = normalize(getDifferenceP(p1, p2));
    
    
    float2 p3 = float2(u, v+e);
    float2 p4 = float2(u, v-e);
   
    n2 = normalize(getDifferenceP(p3, p4));
    
    
    
    float3 n = normalize(cross(n1, n2));

   
    return n;
}


