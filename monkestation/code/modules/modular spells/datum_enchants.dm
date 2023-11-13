/*
Old code

Due to datum enchants not working for some fucking reason no mater what i try to do with them,
i am switching to a switch statement with all enchant effects in it

at the other hand, maybe it's not even that bad knowing that these enchants shouldn't be changed in the game (or at least the ones that currently exist)
and there's supposed to be only one instance of each of them in the world

*/

//=======enchant
/datum/spell_enchant
	var/name = "Enchant"
	var/desc = "Enchant Description"

/datum/spell_enchant/proc/on_cast(var/mob/living/user)
	return TRUE

// ongain procs are called only if you learn the spell from a modular spell book, don't forger about it in case of adding new ways of learning spells with enchants
/datum/spell_enchant/proc/ongain(var/datum/action/cooldown/spell/spell)
	return


/datum/action/cooldown/spell/proc/use_enchants(mob/user = usr)
	to_chat(usr, "<span class='warning'>Activating enchantments while casting the spell</span>")
	for (var/datum/spell_enchant/E in enchants)
		to_chat(usr, "<span class='warning'>Preparing to activate enchantment cast</span>")
		if (!E.on_cast(usr))
			to_chat(usr, "<span class='warning'>Spell failed to activate one of the enchants</span>")
			return FALSE
		to_chat(usr, "<span class='warning'>Activated one enchantment cast</span>")
	return TRUE


// enchant types
datum/spell_enchant/selfharm
	name = "SelfHarm"
	desc = "Damages the user each time it is cast."

datum/spell_enchant/selfharm/on_cast(mob/user = usr)
	if (user == /mob/living/carbon/human)
		var/mob/living/carbon/human/h = user
		h.adjustBruteLoss(10)
		to_chat(usr, "<span class='warning'>Selfharm enchant damaged a human</span>")
	else if (user == /mob/living/simple_animal)
		var/mob/living/simple_animal/s = user
		s.adjustHealth(10)
		to_chat(usr, "<span class='warning'>Selfharm enchant damaged a mob</span>")
	return TRUE

/datum/spell_enchant/extra_cd
	name = "Extra cooldown"
	desc = "Gives additional 5 seconds of cooldown to a spell."

/datum/spell_enchant/extra_cd/ongain(datum/action/cooldown/spell/spell)
	if (spell != null)
		spell.cooldown_time += 5 SECONDS


// the first pperfectly balanced enchantment with no exploits
/datum/spell_enchant/deadcast
	name = "Dead Cast"
	desc = "Allows the spell to be cast by a corpse.Doesn't work properly with some spells."

/datum/spell_enchant/deadcast/ongain(datum/action/cooldown/spell/spell)
	if (spell != null)
		spell.spell_requirements += SPELL_CASTABLE_AS_BRAIN
		datum_flags -= AB_CHECK_CONSCIOUS
		datum_flags -= AB_CHECK_INCAPACITATED


/datum/spell_enchant/nonabstract_req
	name = "Non-Physical Cast"
	desc = "Allows the spell to be cast without a body.Doesn't work properly with some spells."

/datum/spell_enchant/nonabstract_req/ongain(datum/action/cooldown/spell/spell)
	if (spell != null)
		spell.spell_requirements += SPELL_CASTABLE_WHILE_PHASED

//Ported more enchants fromm the files i recovered from the old pc
datum/spell_enchant/more_range
	name = "More Range"
	desc = "Increases range of the spells that have it. Allows you to cast most of the spells both onto yourself and onto others."

/datum/spell_enchant/more_range/ongain(datum/action/cooldown/spell/spell, mob/user)
	if (spell == null)
		return
	var/datum/action/cooldown/spell/list_target/T = spell
	T.range += 1
	T.cast_on_self = TRUE
	T.cast_on_others = TRUE


/obj/item/book/spell_study/enchanter/more_range
	enchant = /datum/spell_enchant/more_range
	cost = 2


// leg disable
/datum/spell_enchant/paraplegic
	name = "Paraplegic"
	desc = "Learning a spell with this enchant will make your legs stop functioning forever.Unfortunately, doesn't give you a free wheelchair."

/datum/spell_enchant/paraplegic/ongain(datum/action/cooldown/spell/spell, mob/user)
	if (user == /mob/living/carbon/human)
		var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
		var/mob/living/carbon/human/H = user
		to_chat(user, "One of enchants in the spell you learned paralyzed your legs")
		H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
	else
		to_chat(user, "The enchant fails to make you paraplegic.")

/obj/item/book/spell_study/enchanter/paraplegic
	enchant = /datum/spell_enchant/paraplegic
	cost = -7
	significant = TRUE
	can_stack = FALSE




