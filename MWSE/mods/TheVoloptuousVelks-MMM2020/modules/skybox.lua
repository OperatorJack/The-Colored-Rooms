local common = require("TheVoloptuousVelks-MMM2020.common")

local function enableSkybox()
    common.debug("Enabling custom skybox.")

    local skyRoot = tes3.worldController.weatherController.sceneSkyRoot
    local skyNode = skyRoot.children[1]

    -- hide original 
    for _, node in ipairs(skyNode.children) do
        if (node) then
            node.appCulled = true
        end
    end

    -- attach a duplicate custom skybox
    local node = tes3.loadMesh("vv20\\custom_skybox.nif"):clone()
    skyNode:attachChild(node)

    skyRoot:update()

    common.debug("Enabled custom skybox.")
end

local function disableSkybox()
    common.debug("Disabling custom skybox.")

    local customSkyboxNodeName = "VV20_CUSTOM_SKYBOX"
    local skyRoot = tes3.worldController.weatherController.sceneSkyRoot
    local skyNode = skyRoot.children[1]

    -- show original sky_night_02
    for _, node in ipairs(skyNode.children) do
        if (node) then
            node.appCulled = false
        end
    end

    -- remove custom skybox
    local customSkyboxNode = skyNode:getObjectByName(customSkyboxNodeName)
    skyNode:detachChild(customSkyboxNode)

    skyNode:update()
    skyRoot:update()

    common.debug("Disabled custom skybox.")
end

local skyboxActive = false

local function onCellActivated(e)
    if (common.skybox.cells[e.cell.id] and skyboxActive == false) then
        enableSkybox()
        skyboxActive = true
    end
end
event.register("cellActivated", onCellActivated)

local function onCellDeactivated(e)
    if (common.skybox.cells[e.cell.id] and skyboxActive == true) then
        disableSkybox()
        skyboxActive = false
    end
end
event.register("cellDeactivated", onCellDeactivated)