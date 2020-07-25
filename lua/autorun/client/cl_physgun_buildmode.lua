-- Physgun Build Mode - by Wenli

local pb_ = "physgun_buildmode_"
CreateClientConVar(pb_ .. "enabled", 0, true, true)

local convars = {
    sleep = "0",
    nocollide = "1",
    norotate = "1",
    snapmove = "1",
    snap_position = "0",
    snap_boxcentre = "0",
    grid_x = "1",
    grid_y = "1",
    grid_z = "1",
    origin_x = "0",
    origin_y = "0",
    origin_z = "0",
    snap_angles = "0",
    angles_p = "45",
    angles_y = "45",
    angles_r = "45"
}

local convars_full = {}
local convar_array = {}

for k, v in pairs(convars) do
    local convar = pb_ .. k
    CreateClientConVar(convar, v, true, true)
    convar_array[#convar_array + 1] = convar
    convars_full[convar] = v
end

--********************************************************************************************************************//
-- Derma controls
--********************************************************************************************************************//
hook.Add("PopulateToolMenu", "Physgun Build Mode:CustomMenuSettings", function()
    spawnmenu.AddToolMenuOption("Options", "Player", "Custom_Menu", "Physgun Build Mode", "", "", function(panel)
        panel:ClearControls()
        local checkbox_enabled = panel:CheckBox("Enabled", "physgun_buildmode_enabled")
        checkbox_enabled:SetTooltip("You can also use the concommand phys_buildmode to toggle on/off")
        local checkbox_sleep = panel:CheckBox("Sleep Instead of Freeze", pb_ .. "sleep")
        checkbox_sleep:SetTooltip("If sleep is enabled, the prop will move again if pushed or hit")
        panel:CheckBox("Auto Nocollide", pb_ .. "nocollide")
        local checkbox_norotate = panel:CheckBox("No Rotation While Moving", pb_ .. "norotate")
        checkbox_norotate:SetTooltip("GMod 9 rotation behavior")
        local checkbox_snap_boxcentre = panel:CheckBox("Snap by Bounding Box Centre", pb_ .. "snap_boxcentre")
        checkbox_snap_boxcentre:SetTooltip("Useful for certain props, e.g. PHX super flat plates")
        panel:CheckBox("Snap While Moving", pb_ .. "snapmove")
        panel:CheckBox("Snap Position", pb_ .. "snap_position")
        local slider_origin_x = panel:NumSlider("Grid - X", pb_ .. "grid_x", 0, 50, 4)
        slider_origin_x:SetTooltip("Sets the grid offset in the X direction")
        local slider_origin_y = panel:NumSlider("Grid - Y", pb_ .. "grid_y", 0, 50, 4)
        slider_origin_y:SetTooltip("Sets the grid offset in the Y direction")
        local slider_origin_z = panel:NumSlider("Grid - Z", pb_ .. "grid_z", 0, 50, 4)
        slider_origin_z:SetTooltip("Sets the grid offset in the Z direction")
        panel:NumSlider("Origin - X", pb_ .. "origin_x", -50, 50, 3)
        panel:NumSlider("Origin - Y", pb_ .. "origin_y", -50, 50, 3)
        panel:NumSlider("Origin - Z", pb_ .. "origin_z", -50, 50, 3)
        local button_setorigin = panel:Button("Set Origin by Entity")
        button_setorigin:SetTooltip("Set the grid offset according to the prop currently in view")

        button_setorigin.DoClick = function()
            local ent = LocalPlayer():GetEyeTraceNoCursor().Entity
            local origin = Vector(0, 0, 0)

            if IsValid(ent) then
                local pos = ent:GetPos()
                origin.x = pos.x % GetConVar(pb_ .. "grid_x"):GetInt()
                origin.y = pos.y % GetConVar(pb_ .. "grid_y"):GetInt()
                origin.z = pos.z % GetConVar(pb_ .. "grid_z"):GetInt()
            end

            RunConsoleCommand(pb_ .. "origin_x", tostring(origin.x))
            RunConsoleCommand(pb_ .. "origin_y", tostring(origin.y))
            RunConsoleCommand(pb_ .. "origin_z", tostring(origin.z))
        end

        panel:CheckBox("Snap Angles", pb_ .. "snap_angles")
        panel:NumSlider("Angles - Pitch", pb_ .. "angles_p", 0, 180, 1)
        panel:NumSlider("Angles - Yaw", pb_ .. "angles_y", 0, 180, 1)
        panel:NumSlider("Angles - Roll", pb_ .. "angles_r", 0, 180, 1)
    end)
end)

--********************************************************************************************************************//
-- Server-related functions
--********************************************************************************************************************//

-- Toggle on/off
local function Buildmode_Toggle(ply)
    if GetConVar(pb_ .. "enabled"):GetInt() == 0 then
        ply:ChatPrint("Physgun Build Mode enabled")
        RunConsoleCommand(pb_ .. "enabled", "1")
    else
        ply:ChatPrint("Physgun Build Mode disabled")
        RunConsoleCommand(pb_ .. "enabled", "0")
    end
end

concommand.Add("phys_buildmode", Buildmode_Toggle)