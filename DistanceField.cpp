#include "DistanceField.h"

#if FALCOR_D3D12_AVAILABLE
FALCOR_EXPORT_D3D12_AGILITY_SDK
#endif

uint32_t mSampleGuiWidth = 250;
uint32_t mSampleGuiHeight = 200;
uint32_t mSampleGuiPositionX = 20;
uint32_t mSampleGuiPositionY = 40;


float3 mapP(float u, float v)
{

    float x = sin(u) * cos(v);
    float y = cos(u);
    float z = sin(u) * sin(v);

    return float3(x, y, z);

}

float3 getdu(float u, float v)
{

    float x = cos(u) * cos(v);
    float y = -sin(u);
    float z = cos(u) * sin(v);

    return float3(x, y, z);
}

float3 getdv(float u, float v)
{

    float x = sin(u) * -sin(v);
    float y = 0;
    float z = sin(u) * cos(v);

    return float3(x, y, z);
}


float geomNewton(float3 pos)
{
    float2 t = float2(rand()/(float)RAND_MAX*10,rand() / (float)RAND_MAX*10);


    for (int i = 0; i < 100; i++)
    {

        float3 du = getdu(t.x, t.y);
        float3 dv = getdv(t.x, t.y);

        float3 pn = mapP(t.x, t.y);

        float2 b = float2(dot(pos - pn, du), dot(pos - pn, dv));

        float4 A = float4(dot(du, du), dot(du, dv), dot(dv, du), dot(dv, dv));

        float X = 1.f / (float)(A.x * A.w - A.y * A.z);

        float2 c = float2(0);

        c.x = X * (A.w * b.x - A.y * b.y);
        c.y = X * (A.x * b.y - A.y * b.x);

        //std::cout << c.x << " " << c.y << std::endl;

        float3 qn = pn + c.x * du + c.y * dv;
        float3 pn1 = mapP(t.x + c.x, t.y + c.y);

        float3 f1 = qn - pn;
        float3 f2 = pn1 - qn;

        float a0 = dot(pos - pn, f1);
        float a1 = dot(pos - pn, 2.f * f2) - dot(f1, f1);
        float a2 = dot(-3.f * f1, f2);
        float a3 = -2 * dot(f2, f2);
        float al = 1 - (a0 + a1 + a2 + a3) / (a1 + 2 * a2 + 3 * a3);

        if (al > 0 && al < 20) {
            t.x = t.x + al * c.x;
            t.y = t.y + al * c.y;
        }

    }

    float3 pn = mapP(t.x, t.y);

    //std::cout << pn.x << " " << pn.y << " " << pn.z << std::endl;

    return length(pos - pn);

}

float3 getQueryPoint(float3 p)
{
    float3 pos = float3(-(float)2.5f / 2.0);
    pos.x += (float)2.5f / (float)3.f * (p.x + 0.5f);
    pos.y += (float)2.5f / (float)3.f * (p.y + 0.5f);
    pos.z += (float)2.5f / (float)3.f * (p.z + 0.5f);

    return pos;
}

void DistanceField::initPlane() {

    const Vertex vertices[] =
    {
        {float3(-1, -1, 0), float3(1, 0, 0)},
        {float3(1, -1, 0), float3(0, 1,0)},
        {float3(-1, 1, 0), float3(0, 0,1)},
        {float3(1, 1, 0), float3(0,0, 0)},
    };

    const uint32_t vbSize = (uint32_t)(sizeof(Vertex) * arraysize(vertices));

    pVbo = Buffer::create(vbSize, Buffer::BindFlags::Vertex, Buffer::CpuAccess::Write, (void*)vertices);
    FALCOR_ASSERT(pVbo);

    // Create VAO
    VertexLayout::SharedPtr pLayout = VertexLayout::create();
    VertexBufferLayout::SharedPtr pBufLayout = VertexBufferLayout::create();
    pBufLayout->addElement("POSITION", 0, ResourceFormat::RGB32Float, 1, 0);
    pBufLayout->addElement("COLOR", 12, ResourceFormat::RGB32Float, 1, 1);
    pLayout->addBufferLayout(0, pBufLayout);

    Vao::BufferVec buffers{ pVbo };
    pVao = Vao::create(Vao::Topology::TriangleStrip, pLayout, buffers);
    FALCOR_ASSERT(pVao);

    programP.setVao(pVbo, pVao);
   
}

void DistanceField::initBox() {
    std::vector<Vertex>vertices;

    //front									 
    vertices.push_back({ float3(-0.5, -0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, -0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, +0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, +0.5), float3(1,1,1) });
    //back
    vertices.push_back({ float3(+0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, +0.5, -0.5), float3(1,1,1) });
    //right									 
    vertices.push_back({ float3(+0.5, -0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, -0.5), float3(1,1,1) });
    //left									 
    vertices.push_back({ float3(-0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, -0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, +0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, +0.5, +0.5), float3(1,1,1) });
    //top									 
    vertices.push_back({ float3(-0.5, +0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, +0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, +0.5, -0.5), float3(1,1,1) });
    //bottom								 
    vertices.push_back({ float3(-0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, -0.5, -0.5), float3(1,1,1) });
    vertices.push_back({ float3(-0.5, -0.5, +0.5), float3(1,1,1) });
    vertices.push_back({ float3(+0.5, -0.5, +0.5), float3(1,1,1) });

    Vertex indices[36];
    int index = 0;

    for (int i = 0; i < 6 * 4; i += 4)
    {
        indices[index + 0] = vertices[i + 0];
        indices[index + 1] = vertices[i + 1];
        indices[index + 2] = vertices[i + 2];
        indices[index + 3] = vertices[i + 1];
        indices[index + 4] = vertices[i + 3];
        indices[index + 5] = vertices[i + 2];
        index += 6;
    }

    const uint32_t vbSize = (uint32_t)(sizeof(Vertex) * arraysize(indices));

    cubeVbo = Buffer::create(vbSize, Buffer::BindFlags::Vertex, Buffer::CpuAccess::Write, (void*)indices);
    FALCOR_ASSERT(cubeVbo);

    // Create VAO
    VertexLayout::SharedPtr pLayout = VertexLayout::create();
    VertexBufferLayout::SharedPtr pBufLayout = VertexBufferLayout::create();
    pBufLayout->addElement("POSITION", 0, ResourceFormat::RGB32Float, 1, 0);
    pBufLayout->addElement("COLOR", 12, ResourceFormat::RGB32Float, 1, 1);
    pLayout->addBufferLayout(0, pBufLayout);

    Vao::BufferVec buffers{ cubeVbo };
    cubeVao = Vao::create(Vao::Topology::TriangleList, pLayout, buffers);
    FALCOR_ASSERT(cubeVao);

    programP.setCubeVao(cubeVbo, cubeVao);
  
}
void DistanceField::initCamera() {

    camera = Camera::create();
    camera->setPosition(float3(0.75, 0.75, -0.75));
    camera->setTarget(float3(0, 0, 0));
    camera->setUpVector(float3(0, 1, 0));
    camera->setAspectRatio(1280.0f / 720.0f);
    camera->setNearPlane(0.01f);
    camera->setFarPlane(1000.0f);
    camera->beginFrame();

    cameraControl = FirstPersonCameraController::create(camera);
    cameraControl->setCameraSpeed(1.0f);

   programP.setCamera(camera, cameraControl);
     
}

void DistanceField::onGuiRender(Gui* pGui)
{
    Gui::Window w(pGui, "Field", { 500, 360 }, { 10, 10 });
    programP.renderGui(&w);
}

void DistanceField::onLoad(RenderContext* pRenderContext)
{
    initPlane(); initBox();

    initCamera();


    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            for (int k = 0; k < 3; k++) {

                float3 pos = getQueryPoint(float3(i, j, k));

                std::cout << pos.x << " " << pos.y << " " << pos.z << std::endl;
                std::cout<<geomNewton(pos)<<std::endl;
                std::cout << glm::length(pos) - 1 << std::endl;
            }
        }
    }
   
}

void DistanceField::onFrameRender(RenderContext* pRenderContext, const Fbo::SharedPtr& pTargetFbo)
{
    const float4 clearColor(1.f, 1.f, 1.f, 1);
    pRenderContext->clearFbo(pTargetFbo.get(), clearColor, 1.0f, 0, FboAttachmentType::All);

    programP.cameraControl->update();

    programP.Render(pRenderContext, pTargetFbo);
}

void DistanceField::onShutdown()
{
}

bool DistanceField::onKeyEvent(const KeyboardEvent& keyEvent)
{
    return cameraControl->onKeyEvent(keyEvent);
}

bool DistanceField::onMouseEvent(const MouseEvent& mouseEvent)
{
    return cameraControl->onMouseEvent(mouseEvent);
}

void DistanceField::onHotReload(HotReloadFlags reloaded)
{
}

void DistanceField::onResizeSwapChain(uint32_t width, uint32_t height)
{
    camera->setAspectRatio((float)width / (float)height);
}

int WINAPI WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPSTR lpCmdLine, _In_ int nShowCmd)
{
    DistanceField::UniquePtr pRenderer = std::make_unique<DistanceField>();
    SampleConfig config;
    config.windowDesc.title = "Falcor Project Template";
    config.windowDesc.resizableWindow = true;
    config.windowDesc.width = 1280;
    config.windowDesc.height = 720;
    Sample::run(config, pRenderer);
    return 0;
}
