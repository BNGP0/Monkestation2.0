




/datum/action/cooldown/spell/proc/enchants_on_cast(var/mob/living/user, var/E = 0)
	switch(E)
		if(1) // selfharm
			if (user == /mob/living/carbon/human)
				var/mob/living/carbon/human/h = user
				h.adjustBruteLoss(10)
				to_chat(usr, "<span class='warning'>Selfharm enchant damaged a human</span>")
			else if (user == /mob/living/simple_animal)
				var/mob/living/simple_animal/s = user
				s.adjustHealth(10)
				to_chat(usr, "<span class='warning'>Selfharm enchant damaged a mob</span>")
			return TRUE
		if(2)


	return TRUE

// ongain procs are called only if you learn the spell from a modular spell book, don't forger about it in case of adding new ways of learning spells with enchants
/datum/action/cooldown/spell/proc/enchants_on_gain(var/datum/action/cooldown/spell/spell,var/mob/user , var/E = 0)
	switch(E) //return false means the enchant only has an effect when learned and not when used so it shouldn't be added to the spell itself
		if(2) //extra cooldown

			return FALSE
	return FALSE















