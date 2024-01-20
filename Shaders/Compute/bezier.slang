
RWStructuredBuffer<float3> b;

float factorial(float n)
{

    float r = 1;
    for (int i = 1; i <= n; i++)
    {
        r *= i;
    }

    return (float) r;
}

float bernstein(float n, float i, float u)
{
    float bi = factorial(n) /   (float) (factorial(i) * factorial(n - i));

    float p1 = pow(u, i);

    float p2 = pow(1 - u, n - i);

    if (i == 0)
    {
        p1 = 1;
    }

    if (n-i == 0)
    {
        p2 = 1;
    }

    return bi * p1 *p2;

}

float3 bij(float i, float j)
{
   return float3((i) / 20.f, 0.5, (j)/20.f);
   // return b[i*20+j];
}

float3 bezier(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            r += (bij(i, j) * bernstein(n, i, u) * bernstein(m, j, v));

        }
    }

    return r;

}

float3 bezierdu(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n-1; i++)
    {
        for (int j = 0; j < m; j++)
        {
            r += (bij((i + 1) , j ) - bij(i , j )) * bernstein(n-1, i, u) * bernstein(m, j, v);

        }
    }

    return n*r;
}

float3 bezierdv(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m-1; j++)
        {
            r += (bij(i , (j + 1) ) - bij(i , j )) * bernstein(n, i, u) * bernstein(m-1, j, v);

        }
    }

    return m*r;
}


float3 bezierduu(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n-2; i++)
    {
        for (int j = 0; j < m; j++)
        {
            r += (bij((i + 2) , (j) ) - 2 * bij((i + 1) , j ) + bij(i , j )) * bernstein(n-2, i, u) * bernstein(m , j, v);

        }
    }

    return n * (n - 1)*r;
}

float3 bezierdvv(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n ; i++)
    {
        for (int j = 0; j < m-2; j++)
        {
            r += (bij((i) , (j + 2) ) - 2 * bij(i , (j + 1) ) + bij(i, j )) * bernstein(n, i, u) * bernstein(m-2, j, v);

        }
    }

    return m * (m - 1) * r;
}


float3 bezierduv(float u, float v)
{
    float3 r = 0;

    float n = 20;
    float m = 20;

    for (int i = 0; i < n - 1; i++)
    {
        for (int j = 0; j < m -1 ; j++)
        {
            r += (bij((i + 1) , (j + 1) ) - bij((i + 1) , j ) - bij((i), (j + 1) ) + bij(i , j )) * bernstein(n - 1, i, u) * bernstein(m-1, j, v);

        }
    }

    return n * m * r;
}
