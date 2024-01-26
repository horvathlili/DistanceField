#ifndef FIELD
#define FIELD 1
#endif

#ifndef DIM
#define DIM 3
#endif


#if DIM == 3
#if FIELD == 1
#include "Filter/filterparam3Dg1.slang"
#endif
#if FIELD == 2
#include "Filter/filterparam3Dg2.slang"
#endif
#endif

#if DIM == 2
#if FIELD == 1
#include "Filter/filterparam.slang"
#endif
#if FIELD == 2
#include "Filter/filterparamg2.slang"
#endif
#endif

#if DIM == 3

Texture3D texturep;
Texture3D texturen;
Texture3D texture3;
#endif

#if DIM == 2
Texture2D texturep;
Texture2D texturen;
Texture2D texture3;
#endif
