/datum/action/cooldown/spell/conjure/construct
	name = "Summon Construct Shell"
	desc = "This spell conjures a construct which may be controlled by Shades."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "artificer"
	sound = 'sound/magic/summonitems_generic.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 1 MINUTES

	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	range = 0 //monkestation edit
	summon_type = list(/obj/structure/constructshell)

/datum/action/cooldown/spell/conjure/construct/lesser // Used by artificers.
	name = "Create Construct Shell"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	cooldown_time = 3 MINUTES
