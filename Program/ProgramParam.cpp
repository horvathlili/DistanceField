#include "ProgramParam.h"
#include <vector>


void ProgramParam::SetUpGui() {
    Gui::RadioButton min1;
    min1.label = "distance";
    min1.buttonID = 0;
    min1.sameLine = false;
    Gui::RadioButton min2;
    min2.label = "footpoint";
    min2.buttonID = 1;
    min2.sameLine = true;
    Gui::RadioButton interp;
    interp.label = "interpolation";
    interp.buttonID = 2;
    interp.sameLine = true;

    bg_min.push_back(min1);
    bg_min.push_back(min2);
    bg_min.push_back(interp);

    Gui::RadioButton g1;
    g1.label = "g1";
    g1.buttonID = 1;
    g1.sameLine = false;
    Gui::RadioButton g2;
    g2.label = "g2";
    g2.buttonID = 2;
    g2.sameLine = true;

    bg_field.push_back(g1);
    bg_field.push_back(g2);

    Gui::RadioButton sphere;
    sphere.label = "sphere";
    sphere.buttonID = 0;
    sphere.sameLine = false;
    Gui::RadioButton bezier;
    bezier.label = "bezier";
    bezier.buttonID = 1;
    bezier.sameLine = true;
    Gui::RadioButton cyl;
    cyl.label = "cylinder";
    cyl.buttonID = 2;
    cyl.sameLine = true;
    Gui::RadioButton cone;
    cone.label = "cone";
    cone.buttonID = 3;
    cone.sameLine = true;

    bg_shape.push_back(sphere);
    bg_shape.push_back(bezier);
    bg_shape.push_back(cyl);
    bg_shape.push_back(cone);
}

float factorial(float n)
{

    float r = 1;
    for (int i = 1; i <= n; i++)
    {
        r *= i;
    }

    return (float)r;
}

float bernstein(float n, float i, float u)
{
    float bi = factorial(n) / (float)(factorial(i) * factorial(n - i));

    return bi * pow(u, i) * pow(1 - u, n - i);

}

void ProgramParam::randomBezier() {

    n = 1;
    nm.push_back(float2(5, 5));

    for (int i = 0; i < n; i++) {
        bezierdb += (int)(nm[i].x + 1) * (int)(nm[i].y + 1);
    }

    bezier.resize(bezierdb);

    float db = 0;

    for (int l = 0; l < n; l++) {

        for (int i = 0; i <= nm[0].x; i++) {
            for (int j = 0; j <= nm[0].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[0].y + 1) + j] = float3(i / (float)5 * boundingBox - boundingBox / 2.f, rand() / (float)RAND_MAX, j / (float)5 * boundingBox - boundingBox / 2.f);
            }
        }

        db += (nm[l].x + 1) * (nm[l].y + 1);
    }

   /* for (int i = 0; i < n * m; i++) {
        std::cout << bezier[i].x <<" " << bezier[i].y << " " << bezier[i].z << " " << std::endl;
    }*/

}

void ProgramParam::cubeBezier() {

    n = 6;
    nm.push_back(float2(1, 1));
    nm.push_back(float2(1, 1));
    nm.push_back(float2(1, 1));
    nm.push_back(float2(1, 1));
    nm.push_back(float2(1, 1));
    nm.push_back(float2(1, 1));

    for (int i = 0; i < n; i++) {
        bezierdb += (int)(nm[i].x + 1) * (int)(nm[i].y + 1);
    }

    bezier.resize(bezierdb);

    float db = 0;

    
        for (int i = 0; i <= nm[0].x; i++) {
            for (int j = 0; j <= nm[0].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[0].y + 1) + j] = float3(-0.5 + i, -0.5, -0.5 + j);
            }
        }

        db += (nm[0].x + 1) * (nm[0].y + 1);

        for (int i = 0; i <= nm[1].x; i++) {
            for (int j = 0; j <= nm[1].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[1].y + 1) + j] = float3(-0.5 + i,-0.5 + j,-0.5);
            }
        }

        db += (nm[1].x + 1) * (nm[1].y + 1);

        for (int i = 0; i <= nm[2].x; i++) {
            for (int j = 0; j <= nm[2].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[2].y + 1) + j] = float3(-0.5,-0.5 + i, -0.5 + j);
            }
        }

        db += (nm[1].x + 1) * (nm[1].y + 1);

        for (int i = 0; i <= nm[2].x; i++) {
            for (int j = 0; j <= nm[2].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[2].y + 1) + j] = float3(+0.5, -0.5 + i, -0.5 + j);
            }
        }
        db += (nm[1].x + 1) * (nm[1].y + 1);

        for (int i = 0; i <= nm[2].x; i++) {
            for (int j = 0; j <= nm[2].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[2].y + 1) + j] = float3( -0.5 + i, -0.5 + j,+0.5);
            }
        }
        db += (nm[1].x + 1) * (nm[1].y + 1);

        for (int i = 0; i <= nm[2].x; i++) {
            for (int j = 0; j <= nm[2].y; j++) {
                //bezier[i * m + j] = float3(i / (float)n, 0.5, j / (float)m);
                bezier[(int)db + i * (int)(nm[2].y + 1) + j] = float3( -0.5 + i,+0.5, -0.5 + j);
            }
        }


    /* for (int i = 0; i < n * m; i++) {
         std::cout << bezier[i].x <<" " << bezier[i].y << " " << bezier[i].z << " " << std::endl;
     }*/

}

ProgramParam::ProgramParam() {

    ComputeProgram = ComputeProgramWrapper::create();
    ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/paramg2.cs.slang");

    testProgram = ComputeProgramWrapper::create();
    testProgram->createProgram("Samples/DistanceField/Shaders/Compute/test.cs.slang");

    SetUpGui();
    randomBezier();
}

void ProgramParam::testing(RenderContext* pRenderContext) {

    auto& comp = *testProgram;

    //    testres = 217;
    comp["csCb"]["testres"] = testres;
    comp["texturep"] = textures[0];
    comp["texturen"] = textures[1];
    comp["texture3"] = textures[2];
    comp["csCb"]["boundingBox"] = boundingBox;
    comp["csCb"]["res"] = resolution;
    comp["csCb"]["n"] = n;
    comp["csCb"]["nx"] = nx;
    comp["csCb"]["shape"] = shape;
    comp["csCb"]["rs"] = rs;
    comp.getProgram()->addDefine("FIELD", std::to_string(field));
    int interp = minm < 2 ? 0 : 1;
    Program->addDefine("MINM", std::to_string(minm));
    Program->addDefine("INTERP", std::to_string(interp));
    comp.getProgram()->addDefine("SHAPE", std::to_string(shape));
    comp.allocateStructuredBuffer("data1", testres*testres*testres);
    comp.allocateStructuredBuffer("b", bezierdb, bezier.data(), sizeof(float3) * bezierdb);
    comp.allocateStructuredBuffer("nm", n, nm.data(), sizeof(float2) * n);


    comp.runProgram(pRenderContext, testres, testres);

    std::vector<float> data1;

    auto dataptr = comp.mapBuffer<const float>("data1");
    data1.resize(testres * testres * testres);
    data1.assign(dataptr, dataptr + testres * testres * testres);
    comp.unmapBuffer("data1");


    float avg = 0;
    for (int i = 0; i < testres * testres * testres; i++) {
        avg += data1[i];

        std::cout << data1[i] << std::endl;
    }

    std::cout << avg / (float)(testres * testres * testres) << std::endl;

}

void ProgramParam::renderGui(Gui::Window* w) {
    w->radioButtons(bg_field, fieldb);
    w->radioButtons(bg_shape, shape);
    if (w->button("start")) {
        retexture = true;
        resolution = sliderRes;
        boundingBox = sliderboundingBox;
    }
    w->slider("resolution", sliderRes, 1, 100);
    w->slider("intersecting sphere", rs, 0.f, 1.f);
    (w->slider("boundingBox", sliderboundingBox, 2.f, 20.f));
    w->radioButtons(bg_min, minm);
    w->separator();
    if (w->button("Run test")) {
        test = true;
    }
    w->slider("Test resolution", testres, 1, 512);
}


std::vector<Texture::SharedPtr> ProgramParam::generateTexture(RenderContext* pRenderContext) {
    Texture::SharedPtr pTexp = nullptr; //one for the surface point
    Texture::SharedPtr pTexn = nullptr; //one for the normal
    Texture::SharedPtr pTex3 = nullptr;

    ResourceFormat format = ResourceFormat::RGBA16Float;

    if (texturesize == 1) {
        format = ResourceFormat::RGBA32Float;
    }

    field = fieldb;

    if (field == 1) {
        ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/param.cs.slang");
    }
    if (field == 2) {
        ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/paramg2.cs.slang");
    }

    nx = 1;
    if (shape == 1) {
        nx = n;
    }

    std::cout << nx << std::endl;

    pTexp = Texture::create2D(nx*resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTexn = Texture::create2D(nx*resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTex3 = Texture::create2D(nx*resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);

    auto& comp = *ComputeProgram;

    comp["texp"].setUav(pTexp->getUAV(0));
    comp["texn"].setUav(pTexn->getUAV(0));
    comp["tex3"].setUav(pTex3->getUAV(0));
    comp["csCb"]["res"] = resolution;
    comp["csCb"]["boundingBox"] = boundingBox;
    comp.getProgram()->addDefine("SHAPE", std::to_string(shape));
    comp.allocateStructuredBuffer("data1", nx*resolution *  resolution);
    comp.allocateStructuredBuffer("b", bezierdb, bezier.data(), sizeof(float3) * bezierdb);
    comp.allocateStructuredBuffer("nm", n, nm.data(), sizeof(float2) * n);
    comp["csCb"]["shape"] = shape;
    comp["csCb"]["n"] = n;
    comp["csCb"]["nx"] = nx;

    comp.runProgram(pRenderContext, nx*resolution, resolution);

    std::vector<float4> data1;

    auto dataptr = comp.mapBuffer<const float4>("data1");
    data1.resize(nx*resolution * resolution);
    data1.assign(dataptr, dataptr + nx*resolution * resolution);
    comp.unmapBuffer("data1");

   

    /*for (int i = 0; i < resolution * resolution; i++) {
        std::cout << data1[i].x << " " << data1[i].y <<" "<<data1[i].z<< std::endl;
    }*/
  
    std::vector<Texture::SharedPtr> textures;
    textures.push_back(pTexp);
    textures.push_back(pTexn);
    textures.push_back(pTex3);

    return textures;
}

