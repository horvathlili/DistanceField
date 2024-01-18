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

    bg_min.push_back(min1);
    bg_min.push_back(min2);

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
}

ProgramParam::ProgramParam() {

    ComputeProgram = ComputeProgramWrapper::create();
    ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/paramg2.cs.slang");

    SetUpGui();
}

void ProgramParam::renderGui(Gui::Window* w) {
    w->radioButtons(bg_field, fieldb);
    if (w->button("start")) {
        retexture = true;
        resolution = sliderRes;
        boundingBox = sliderboundingBox;
    }
    w->slider("resolution", sliderRes, 1, 100);
    w->slider("intersecting sphere", rs, 0.f, 1.f);
    (w->slider("boundingBox", sliderboundingBox, 2.f, 20.f));
    w->radioButtons(bg_min, minm);
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


    pTexp = Texture::create2D(resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTexn = Texture::create2D(resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTex3 = Texture::create2D(resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);

    auto& comp = *ComputeProgram;

    comp["texp"].setUav(pTexp->getUAV(0));
    comp["texn"].setUav(pTexn->getUAV(0));
    comp["tex3"].setUav(pTex3->getUAV(0));
    comp["csCb"]["res"] = resolution;
    comp["csCb"]["boundingBox"] = boundingBox;
    //comp.allocateStructuredBuffer("data1", resolution *  resolution);


    comp.runProgram(pRenderContext, resolution, resolution);

    std::vector<float4> data1;

  /*  auto dataptr = comp.mapBuffer<const float4>("data1");
    data1.resize(resolution * resolution);
    data1.assign(dataptr, dataptr + resolution * resolution);
    comp.unmapBuffer("data1");

    for (int i = 0; i < resolution * resolution; i++) {
        std::cout << data1[i].x << " " << data1[i].y <<" "<<data1[i].z<< std::endl;
    }*/
  
    std::vector<Texture::SharedPtr> textures;
    textures.push_back(pTexp);
    textures.push_back(pTexn);
    textures.push_back(pTex3);

    return textures;
}

