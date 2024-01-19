#include "Program3D.h"

void Program3D::setVao(Buffer::SharedPtr vbo, Vao::SharedPtr vao) {
    pVbo = vbo;
    pVao = vao;
}

Program3D::Program3D() {
    Program::Desc d1;

    d1.addShaderLibrary("Samples/DistanceField/Shaders/3d.vs.slang").entryPoint(ShaderType::Vertex, "main");
    d1.addShaderLibrary("Samples/DistanceField/Shaders/3d.ps.slang").entryPoint(ShaderType::Pixel, "main");

    Program = GraphicsProgram::create(d1);
    FALCOR_ASSERT(Program);

    State = GraphicsState::create();
    State->setProgram(Program);
    FALCOR_ASSERT(State);

    Vars = GraphicsVars::create(State->getProgram().get());
}

void Program3D::setCamera(Camera::SharedPtr c, CameraController::SharedPtr cControl) {

    camera = c;
    cameraControl = cControl;

}

void Program3D::setCubeVao(Buffer::SharedPtr vbo, Vao::SharedPtr vao) {
    cubeVao = vao;
    cubeVbo = vbo;
}

bool Program3D::isOutOfBox(float3 pos)
{
    float b = boundingBox - 0.5f * boundingBox / (float)resolution;
    bool r = (pos.x > -b / 2.0 && pos.x < b / 2.0 &&
        pos.y > -b / 2.0 && pos.y < b / 2.0 &&
        pos.z > -b / 2.0 && pos.z < b / 2.0);

    return !r;
}


void Program3D::Render(RenderContext* pRenderContext, const Fbo::SharedPtr& pTargetFbo) {
    State->setFbo(pTargetFbo);
    isbox = isOutOfBox(camera->getPosition());

    if (retexture) {
        textures = generateTexture(pRenderContext);
        retexture = false;
        texturedone = true;
    }

    if (texturedone) {

        float4x4 m = glm::scale(float4x4(1.0), float3(boundingBox - 0.5f * boundingBox / (float)resolution));
        Vars["vsCb"]["model"] = m;
        Vars["vsCb"]["viewproj"] = camera->getViewProjMatrix();
        Vars["vsCb"]["box"] = isbox;

        Vars["texturep"] = textures[0];
        Vars["texturen"] = textures[1];
        Vars["texture3"] = textures[2];
        Vars["psCb"]["eye"] = camera->getPosition();
        Vars["psCb"]["center"] = camera->getTarget();
        Vars["psCb"]["up"] = camera->getUpVector();
        Vars["psCb"]["ar"] = camera->getAspectRatio();
        Vars["psCb"]["box"] = isbox;
        Vars["psCb"]["boundingBox"] = boundingBox;
        Vars["psCb"]["viewproj"] = camera->getViewProjMatrix();
        Vars["psCb"]["res"] = resolution;
        Vars["psCb"]["rs"] = rs;
        Program->addDefine("MINM", std::to_string(minm));
        Program->addDefine("FIELD", std::to_string(field));
       

        if (isbox) {
            State->setVao(cubeVao);
            pRenderContext->draw(State.get(), Vars.get(), 36, 0);
        }
        else {
            State->setVao(pVao);
            pRenderContext->draw(State.get(), Vars.get(), 4, 0);
        }
    }
}

