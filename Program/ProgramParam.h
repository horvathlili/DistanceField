#pragma once
#include "Program3D.h"

class ProgramParam : public Program3D {

private:

    ComputeProgramWrapper::SharedPtr csgProgram;
    Texture::SharedPtr csgTexture;

    std::vector<Texture::SharedPtr> generateTexture(RenderContext* pRenderContext) override;
    void randomBezier();
    void SetUpGui();

    Gui::RadioButtonGroup bg_min;
    Gui::RadioButtonGroup bg_field;
    Gui::RadioButtonGroup bg_shape;

    uint fieldb = 1;

    int n = 20;
    int m = 20;
    std::vector<float3> bezier;

public:
    void renderGui(Gui::Window* w) override;


    ProgramParam();
};
