#pragma once
#include "../Utils/ComputeProgramWrapper.h"


class Program3D {

protected:

    //gui
    Gui::RadioButtonGroup bg_sdf3d;

    //plane
    struct Vertex
    {
        float3 pos;
        float3 col;
    };
    Buffer::SharedPtr pVbo;
    Vao::SharedPtr pVao;

    //box
    Buffer::SharedPtr cubeVbo;
    Vao::SharedPtr cubeVao;
    bool isbox = false;

    //camera
    Camera::SharedPtr camera;


    //Program
    GraphicsProgram::SharedPtr Program;
    GraphicsVars::SharedPtr Vars;
    GraphicsState::SharedPtr State;
    ComputeProgramWrapper::SharedPtr ComputeProgram;

    //generate texture
    bool retexture = false;
    //is any texture generated
    bool texturedone = false;
    //render scene
    bool render = false;

    //basic details of the distance field
    int resolution = 32;
    int sliderRes = 32;
    float boundingBox = 2.5f;
    float sliderboundingBox = 2.5f;
    uint texturesize = 0;

    //textures of the field
    std::vector<Texture::SharedPtr> textures;

    //methods
    virtual std::vector<Texture::SharedPtr> generateTexture(RenderContext* pRenderContext) = 0;
    virtual void testing(RenderContext* pRenderContext) = 0;
    void setupGui();
  
    float rs;
    uint interp = 0;
    uint field = 0;
    uint shape = 0;

    uint dim;

    int nx = 1; //it is 1 for normal shapes, for surfaces constructed from multiple bezeir surfaces it is the number of surfaces used

    ComputeProgramWrapper::SharedPtr testProgram;
    bool test = false;
    int testres = 10;


public:
    Program3D();

    bool isOutOfBox(float3 pos);

    void Render(RenderContext* pRenderContext, const Fbo::SharedPtr& pTargetFbo);

    void setCamera(Camera::SharedPtr camera, CameraController::SharedPtr cameraControl);
    CameraController::SharedPtr cameraControl;

    void setVao(Buffer::SharedPtr vbo, Vao::SharedPtr vao);
    void setCubeVao(Buffer::SharedPtr vbo, Vao::SharedPtr vao);
 
    virtual void renderGui(Gui::Window* w) = 0;
};
