#include "ProgramParam.h"
#include <vector>


ProgramParam::ProgramParam() {

    ComputeProgram = ComputeProgramWrapper::create();
    ComputeProgram->createProgram("Samples/DistanceField/Shaders/Compute/param.cs.slang");
}

void ProgramParam::renderGui(Gui::Window* w) {
    if (w->button("start")) {
        retexture = true;
        resolution = sliderRes;
        boundingBox = sliderboundingBox;
    }
    w->slider("resolution", sliderRes, 1, 100);
    w->slider("intersecting sphere", rs, 0.f, 1.f);
    (w->slider("boundingBox", sliderboundingBox, 2.f, 20.f));
    w->slider("closest geometry (0 = distance, 1 = footpoint)", minm, 0, 1);
}


std::vector<Texture::SharedPtr> ProgramParam::generateTexture(RenderContext* pRenderContext) {
    Texture::SharedPtr pTexp = nullptr; //one for the surface point
    Texture::SharedPtr pTexn = nullptr; //one for the normal

    ResourceFormat format = ResourceFormat::RGBA16Float;

    if (texturesize == 1) {
        format = ResourceFormat::RGBA32Float;
    }


    pTexp = Texture::create2D(resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);
    pTexn = Texture::create2D(resolution, resolution, format, 1, 1, nullptr, ResourceBindFlags::ShaderResource | ResourceBindFlags::UnorderedAccess);

    auto& comp = *ComputeProgram;

    comp["texp"].setUav(pTexp->getUAV(0));
    comp["texn"].setUav(pTexn->getUAV(0));
    comp["csCb"]["res"] = resolution;
    comp["csCb"]["boundingBox"] = boundingBox;

    comp.runProgram(pRenderContext, resolution, resolution);
  
    std::vector<Texture::SharedPtr> textures;
    textures.push_back(pTexp);
    textures.push_back(pTexn);

    return textures;
}

