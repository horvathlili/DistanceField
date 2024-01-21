#include "../Compute/paramsurf.slang"

float map(float3 pos)
{
    return length(pos - mapP(0.5, 0.5));
}
