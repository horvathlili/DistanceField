#pragma once
#include "Program3D.h"

class ProgramParam3D : public Program3D {

private:

    ComputeProgramWrapper::SharedPtr csgProgram;
    Texture::SharedPtr csgTexture;

    std::vector<Texture::SharedPtr> generateTexture(RenderContext* pRenderContext) override;
    virtual void testing(RenderContext* pRenderContext) override;
    void randomBezier();
    void cubeBezier();
    void SetUpGui();

    Gui::RadioButtonGroup bg_min;
    Gui::RadioButtonGroup bg_field;
    Gui::RadioButtonGroup bg_shape;

    uint fieldb = 1;

    int n = 1;
    std::vector<float3> bezier;
    std::vector<float2> nm;
    int bezierdb;

public:
    void renderGui(Gui::Window* w) override;


    ProgramParam3D();
};