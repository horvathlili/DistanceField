#pragma once
#include "Program3D.h"

class ProgramParam : public Program3D {

private:

    ComputeProgramWrapper::SharedPtr csgProgram;
    Texture::SharedPtr csgTexture;

    std::vector<Texture::SharedPtr> generateTexture(RenderContext* pRenderContext) override;

    void SetUpGui();

    Gui::RadioButtonGroup bg_min;

public:
    void renderGui(Gui::Window* w) override;


    ProgramParam();
};
