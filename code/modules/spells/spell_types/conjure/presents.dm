/datum/action/cooldown/spell/conjure/presents
	name = "Conjure Presents!"
	desc = "This spell lets you reach into S-space and retrieve presents! Yay!"

	school = SCHOOL_CONJURATION
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 13.75 SECONDS

	invocation = "HO HO HO"
	invocation_type = INVOCATION_SHOUT

	range = 3//monkestation edit
	summon_type = list(/obj/item/a_gift)
	summon_amount = 5
