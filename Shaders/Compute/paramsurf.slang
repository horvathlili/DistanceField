#pragma once

#define PI 3.14159265359

#include "../Utils/beziers.slang"

#ifndef SHAPE
#define SHAPE 0
#endif

//u,v in [0,1]

float3 sphereP(float u, float v)
{

    float x = sin(u) * cos(v);
    float y = cos(u);
    float z = sin(u) * sin(v);

    return float3(x, y, z);

}

float3 spheredu(float u, float v)
{

    float x = cos(u) * cos(v);
    float y = -sin(u);
    float z = cos(u) * sin(v);

    return float3(x, y, z);
}

float3 spheredv(float u, float v)
{
  
    float x = sin(u) *-sin(v);
    float y = 0;
    float z = sin(u) * cos(v);
    
    return float3(x, y, z);
}

float3 sphereduu(float u, float v)
{

    float x = -sin(u) * cos(v);
    float y = -cos(u);
    float z = -sin(u) * sin(v);

    return float3(x, y, z);
}

float3 sphereduv(float u, float v)
{
    float x = cos(u) * -sin(v);
    float y = 0;
    float z = cos(u) * cos(v);

    return float3(x, y, z);
}

float3 spheredvv(float u, float v)
{
   
    float x = sin(u) * -cos(v);
    float y = 0;
    float z = -sin(u) * sin(v);

    return float3(x, y, z);
}

float3 cylP(float u, float v)
{
    
    float x = cos(u);
    float z = sin(u);
    float y = v;

    return float3(x, y, z);
}

float3 cyldu(float u, float v)
{
    float x = -sin(u);
    float z =  cos(u);
    float y = 0;

    return float3(x, y, z);
}

float3 cyldv(float u, float v)
{

    float x = 0;
    float z = 0;
    float y = 1;

    return float3(x, y, z);
}

float3 cylduu(float u, float v)
{
    float x =  -cos(u);
    float z =  -sin(u);
    float y = 0;

    return float3(x, y, z);
}
float3 cylduv(float u, float v)
{
    float x = 0;
    float z = 0;
    float y = 0;

    return float3(x, y, z);
}

float3 cyldvv(float u, float v)
{
    float x = 0;
    float z = 0;
    float y = 0;

    return float3(x, y, z);
}

float3 coneP(float u, float v)
{
    float x = (v + boundingBox / 2.f) * cos(u);
    float z = (v + boundingBox / 2.f) * sin(u);
    float y = v;

    return float3(x, y, z);
}

float3 conedu(float u, float v)
{
    float x = (v + boundingBox / 2.f) * -sin(u);
    float z = (v + boundingBox / 2.f) * cos(u);
    float y = 0;

    return float3(x, y, z);
}

float3 conedv(float u, float v)
{
    float x = cos(u);
    float z = sin(u);
    float y = 1;

    return float3(x, y, z);
}

float3 coneduu(float u, float v)
{
    float x = (v + boundingBox / 2.f) * -cos(u);
    float z = (v + boundingBox / 2.f) * -sin(u);
    float y = 0;

    return float3(x, y, z);
}

float3 coneduv(float u, float v)
{
    float x =  -sin(u);
    float z =  cos(u);
    float y = 0;

    return float3(x, y, z);
}

float3 conedvv(float u, float v)
{
    float x = 0;
    float z = 0;
    float y = 0;

    return float3(x, y, z);
}

float3 mapP(float u, float v)
{
    #if SHAPE == 0
        return sphereP(u, v);
    #endif
   
   #if SHAPE == 1
    int k = (int)u;
    u = u-k;
        return bezier(u, v,k);
    #endif
#if SHAPE == 2
    return cylP(u, v);
    #endif
    #if SHAPE == 3
    return coneP(u, v);
    #endif
    return float3(0, 0, 0);
}

float3 getdu(float u, float v)
{
    #if SHAPE == 0
    return spheredu(u, v);
    #endif
    #if SHAPE == 1
     int k = (int)u;
    u = u-k;
        return bezierdu(u, v,k);
    #endif
    #if SHAPE == 2
    return cyldu(u, v);
    #endif
     #if SHAPE == 3
    return conedu(u, v);
    #endif
    return float3(0, 0, 0);
}

float3 getdv(float u, float v)
{
#if SHAPE == 0
    return spheredv(u, v);
    #endif
    #if SHAPE == 1
     int k = (int)u;
    u = u-k;
        return bezierdv(u, v,k);
    #endif
    #if SHAPE == 2
    return cyldv(u, v);
    #endif
     #if SHAPE == 3
    return conedv(u, v);
    #endif
    return float3(0, 0, 0);
}

float3 getduu(float u, float v)
{
#if SHAPE == 0
    return sphereduu(u, v);
    #endif
    #if SHAPE == 1
     int k = (int)u;
    u = u-k;
        return bezierduu(u, v,k);
    #endif
    #if SHAPE == 2
    return cylduu(u, v);
    #endif
     #if SHAPE == 3
    return coneduu(u, v);
    #endif
    return float3(0, 0, 0);
}

float3 getduv(float u, float v)
{
#if SHAPE == 0
    return sphereduv(u, v);
    #endif
    #if SHAPE == 1
     int k = (int)u;
    u = u-k;
        return bezierduv(u, v,k);
    #endif
    #if SHAPE == 2
    return cylduv(u, v);
    #endif
     #if SHAPE == 3
    return coneduv(u, v);
    #endif
    return float3(0, 0, 0);
}

float3 getdvv(float u, float v)
{
#if SHAPE == 0
    return spheredvv(u, v);
    #endif
    #if SHAPE == 1
     int k = (int)u;
    u = u-k;
        return bezierdvv(u, v,k);
    #endif
    #if SHAPE == 2
    return cyldvv(u, v);
    #endif
     #if SHAPE == 3
    return conedvv(u, v);
    #endif
    return float3(0, 0, 0);
}

float2 convertParam(float u, float v)
{
    #if SHAPE == 0
    return float2(u * PI, v * (2 * PI));
    #endif
#if SHAPE == 1
    return float2(u, v);
    #endif
    #if SHAPE == 3
    return float2(u * (2* PI), v *(float)boundingBox - boundingBox / 2.f);
    #endif
    #if SHAPE == 2
    return float2(u * (2* PI), v * (float)boundingBox - boundingBox / 2.f);
    #endif

    return float2(u, v);

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


