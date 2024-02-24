local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}
local sn_health = 100
local sn_armor = 100
local x = 50
local y = ScrH() - 70
local cols = {Color(0, 0, 0, 80), Color(255,255,255,255), Color(255, 50, 50, 200), Color(50, 50, 255, 200), Color(78, 92, 115, 255)}

local textLicense = {
    have = "Есть лицензия",
    notHave = "Нет лицензии"
}

local health_icon = Material('icons_hud/icon_health.png')
local armor_icon = Material('icons_hud/icon_armor.png')
local profile_icon = Material('icons_hud/icon_profile.png')
local money_icon = Material('icons_hud/icon_money.png')
local job_icon = Material('icons_hud/icon_job.png')
local license_icon = Material('icons_hud/icon_license.png')
local gun_icon = Material('icons_hud/icon_gun.png')
local ammo_icon = Material('icons_hud/icon_ammo.png')

surface.CreateFont('HUDInfo', {
    font = "Roboto-MediumItalic",
	extended = false,
	size = 24,
	weight = 1000,
    antialias = true,
})

local function HUD() 
    local ply = LocalPlayer()
    local Health = ply:Health()
    local Armor = ply:Armor()
    local team_colors = team.GetColor(ply:Team())
    local wep = ply:GetActiveWeapon()
    local HaveDarkRP = (DarkRP) and true or false
    sn_health = math.Clamp(Lerp(0.05, sn_health, Health), 0, 100)
    sn_armor = math.Clamp(Lerp(0.05, sn_armor, Armor), 0, 100)

    -- HEALTH
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(health_icon)
    surface.DrawTexturedRect(x - 36, y + 30, 32, 32)

    -- ARMOR
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(armor_icon)
    surface.DrawTexturedRect(x, y + 30, 32, 32)

    -- PROFILE(NICK)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(profile_icon)
    surface.DrawTexturedRect(x + 36, y + 30, 32, 32)

    if HaveDarkRP then

        -- MONEY
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(money_icon)
        surface.DrawTexturedRect(x + 36, y - 6, 32, 32)

        -- JOB
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(job_icon)
        surface.DrawTexturedRect(x + 36, y - 42, 32, 32)

        -- LICENSE
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(license_icon)
        surface.DrawTexturedRect(x + 36, y - 78, 32, 32)

        draw.SimpleText(ply:getDarkRPVar("money") .. '$ + ' .. ply:getDarkRPVar("salary") .. '$', "HUDInfo", x + 72, y - 2, cols[2], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(ply:getDarkRPVar("job"), "HUDInfo", x + 72, y - 38, Color(team_colors.r, team_colors.g, team_colors.b, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText((ply:getDarkRPVar("HasGunlicense")) and textLicense.have or textLicense.notHave, "HUDInfo", x + 72, y - 74, cols[2], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local y_1 = y - 2*sn_health
    local y_2 = y - 2*sn_armor
    draw.RoundedBox(3, x - 29, y - 2*100 + 26, 20, 200, cols[1])
    draw.RoundedBox(3, x + 6, y - 2*100 + 26, 20, 200, cols[1])
    draw.RoundedBox(3, x - 29, y_1 + 26, 20, 2*sn_health, cols[3])
    draw.RoundedBox(3, x + 6, y_2 + 26, 20, 2*sn_armor, cols[4])

    draw.SimpleText(ply:Name(), "HUDInfo", x + 72, y + 32, cols[2], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    if !IsValid(wep) then return end
    -- GUN ICON
    draw.RoundedBox(20, ScrW() - 252, y - 26, 36, 36, cols[5])
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(gun_icon)
    surface.DrawTexturedRect(ScrW() - 250, y - 24, 32, 32)
    -- AMMO ICON
    if wep:GetMaxClip1() > 0 then
         draw.RoundedBox(20, ScrW() - 252, y + 19, 36, 36, cols[5])
         surface.SetDrawColor(255, 255, 255)
         surface.SetMaterial(ammo_icon)
         surface.DrawTexturedRect(ScrW() - 250, y + 19, 32, 32)
        draw.SimpleText(wep:Clip1() .. ' / ' .. ply:GetAmmoCount(wep:GetPrimaryAmmoType()), "HUDInfo", ScrW() - 212, y + 25, cols[2], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    draw.SimpleText(wep:GetPrintName(), "HUDInfo", ScrW() - 212, y - 20, cols[2], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if hide[name] then
		return false
	end
end)

hook.Add("HUDPaint", "HUDPaint_DrawABox", HUD)