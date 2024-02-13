#include "ProgramImplicit3D.h"
#include <vector>


void ProgramImplicit3D::SetUpGui() {
    Gui::RadioButton min1;
    min1.label = "distance";
    min1.buttonID = 0;
    min1.sameLine = false;
    Gui::RadioButton interp;
    interp.label = "interpolation";
    interp.buttonID = 1;
    interp.sameLine = true;
    Gui::RadioButton csg;
    csg.label = "csg";
    csg.buttonID = 2;
    csg.sameLine = true;

    bg_min.push_back(min1);
    bg_min.push_back(interp);
    bg_min.push_back(csg);

    Gui::RadioButton g1;
    g1.label = "g1";
    g1.buttonID = 1;
    g1.sameLine = false;
    Gui::RadioButton g2;
    g2.label = "g2";
    g2.buttonID = 2;
    g2.sameLine = true;

    bg_field.push_back(g1);
  //  bg_field.push_back(g2);

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
    Gui::RadioButton cube;
    cube.label = "cube";
    cube.buttonID = 4;
    cube.sameLine = true;

    bg_shape.push_back(sphere);
   // bg_shape.push_back(bezier);
    bg_shape.push_back(cyl);
    bg_shape.push_back(cone);
    bg_shape.push_back(cube);
}


ProgramImplicit3D::ProgramImplicit3D() {

    ComputeProgram = ComputeProgramWrapper::create();
    ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/implicitg1.cs.slang");

    testProgram = ComputeProgramWrapper::create();
    testProgram->createProgram("Samples/DistanceField/Shaders/Compute/test.cs.slang");

    SetUpGui();

    dim = 3;
}

void ProgramImplicit3D::testing(RenderContext* pRenderContext) {

   /* auto& comp = *testProgram;

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
    //comp.getProgram()->addDefine("MINM", std::to_string(minm));
    comp.getProgram()->addDefine("INTERP", std::to_string(interp));
    comp.getProgram()->addDefine("SHAPE", std::to_string(shape));
    comp.getProgram()->addDefine("DIM", std::to_string(dim));
    comp.allocateStructuredBuffer("data1", testres * testres * testres);
    comp.allocateStructuredBuffer("b", bezierdb, bezier.data(), sizeof(float3) * bezierdb);
    comp.allocateStructuredBuffer("nm", n, nm.data(), sizeof(float2) * n);


    comp.runProgram(pRenderContext, testres, testres);

    std::vector<float> data1;

    auto dataptr = comp.mapBuffer<const float>("data1");
    data1.resize(testres * testres * testres);
    data1.assign(dataptr, dataptr + testres * testres * testres);
    comp.unmapBuffer("data1");


    float avg = 0;
    float secondn = 0;
    float maxn = 0;
    int avgdb = 0;
    for (int i = 0; i < testres * testres * testres; i++) {

        if (!isnan(data1[i]) && data1[i] < boundingBox / 3.f) {
            avg += data1[i];
            avgdb++;
            secondn += data1[i] * data1[i];
            if (data1[i] > maxn) {
                maxn = data1[i];
            }
        }
       // std::cout << data1[i] << std::endl;
    }

    std::cout <<"1: "<< avg / (float)(avgdb) << std::endl;
    std::cout << "2: " << secondn / (float)(avgdb) << std::endl;
    std::cout << "inf: " << maxn<< std::endl;*/
}

void ProgramImplicit3D::renderGui(Gui::Window* w) {
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
    w->radioButtons(bg_min, interp);
    w->separator();
    if (w->button("Run test")) {
        test = true;
    }
    w->slider("Test resolution", testres, 1, 512);
}


std::vector<Texture::SharedPtr> ProgramImplicit3D::generateTexture(RenderContext* pRenderContext) {
    Texture::SharedPtr pTexp = nullptr; //one for the surface point
    Texture::SharedPtr pTexn = nullptr; //one for the normal
    Texture::SharedPtr pTex3 = nullptr;

    ResourceFormat format = ResourceFormat::RGBA16Float;

    if (texturesize == 1) {
        format = ResourceFormat::RGBA32Float;
    }

    field = fieldb;

    if (field == 1) {
        ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/implicitg1.cs.slang");
    }

    nx = 1;
   

    pTexp = Texture::create3D(resolution, resolution, resolution, format, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTexn = Texture::create3D(resolution, resolution, resolution, format, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTex3 = Texture::create3D(resolution, resolution, resolution, format, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);

    auto& comp = *ComputeProgram;

    comp["texp"].setUav(pTexp->getUAV(0));
    comp["texn"].setUav(pTexn->getUAV(0));
    comp["tex3"].setUav(pTex3->getUAV(0));
    comp["csCb"]["res"] = resolution;
    comp["csCb"]["boundingBox"] = boundingBox;
    comp.getProgram()->addDefine("SHAPE", std::to_string(shape));
    comp.allocateStructuredBuffer("data1", resolution * resolution * resolution);
    comp.allocateStructuredBuffer("nm", n, nm.data(), sizeof(float2) * n);
    comp["csCb"]["shape"] = shape;
    comp["csCb"]["n"] = n;
    comp["csCb"]["nx"] = nx;

    comp.runProgram(pRenderContext, resolution, resolution, resolution);

    std::vector<float4> data1;

    auto dataptr = comp.mapBuffer<const float4>("data1");
    data1.resize(resolution * resolution * resolution);
    data1.assign(dataptr, dataptr + resolution * resolution * resolution);
    comp.unmapBuffer("data1");


    std::cout << data1[0].x << " " << data1[0].y << " " << data1[0].z << std::endl;
   /* for (int i = 0; i < resolution * resolution; i++) {
        std::cout << data1[i].x << " " << data1[i].y <<" "<<data1[i].z<< std::endl;
    }*/

    std::vector<Texture::SharedPtr> textures;
    textures.push_back(pTexp);
    textures.push_back(pTexn);
    textures.push_back(pTex3);

    return textures;
}

