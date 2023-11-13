/*

Modular spells(enchants) / by art_0



Instalation guide (changes outside of the module) (for /datum/action based spells):

	in code/modules/spells/spell.dm
		add these vars to /datum/action/cooldown/spell
*/
	var/range = 1
	var/cast_on_self = TRUE
	var/cast_on_others = TRUE
	var/list/enchants = list()
/*

		replace every spell type's own range variable with the new range variable
		add this to the proc that checks if the spell can be cast. for /datum/action spells it is "try_invoke()"
*/
	if(!use_enchants(owner))
		to_chat(owner, span_warning("Failed to cast the spell because of one of the enchants!"))
		return FALSE
/*




*/
// if i don't make the enchants work with these fucking AB_CHECK things i'll just change this proc to check with spell's bool variables
/datum/action/proc/IsAvailable(feedback = FALSE)
	if(!owner)
		return FALSE
	if((check_flags & AB_CHECK_HANDS_BLOCKED) && HAS_TRAIT(owner, TRAIT_HANDS_BLOCKED))
		if (feedback)
			owner.balloon_alert(owner, "hands blocked!")
		return FALSE
	if((check_flags & AB_CHECK_IMMOBILE) && HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		if (feedback)
			owner.balloon_alert(owner, "can't move!")
		return FALSE
	if((check_flags & AB_CHECK_INCAPACITATED) && HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		if (feedback)
			owner.balloon_alert(owner, "incapacitated!")
		return FALSE
	if((check_flags & AB_CHECK_LYING) && isliving(owner))
		var/mob/living/action_owner = owner
		if(action_owner.body_position == LYING_DOWN)
			if (feedback)
				owner.balloon_alert(owner, "must stand up!")
			return FALSE
	if((check_flags & AB_CHECK_CONSCIOUS) && owner.stat != CONSCIOUS)
		if (feedback)
			owner.balloon_alert(owner, "unconscious!")
		return FALSE
	return TRUE
