// the spell book
/obj/item/book/granter/action/spell/modular
//	spellname = "spell"
	icon = 'monkestation/code/modules/modular spells/icons_32x32.dmi'
	icon_state ="bookSpellmaker"
	desc = "This book lets you learn a custom spell. Or maybe it doesn't"
	remarks = list(
		"...",
		"Learning...",
		"Interesting...",
	)
	var/list/book_enchants = list()
	var/e_balance = -3
	var/datum/action/cooldown/spell/spell

/obj/item/book/granter/action/spell/modular/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/book/spell_study/enchanter))
		var/obj/item/book/spell_study/E = W
		E.on_book_add(B = src, U = user)
		e_balance -= E.cost
	else
		return ..()

/obj/item/book/granter/action/spell/modular/attack_self(mob/user)
	if (e_balance < 0)
		to_chat(user, "<span class='warning'>The enchantments are out of balance, the spell can't be cast!</span>")
		return FALSE
//		..() // didn't work. for some reason
	if(reading)
		to_chat(user, span_warning("You're already reading this!"))
		return FALSE
//	if(is_blind(user)) // no idea why but this blind check doesn't work on monkestation
//		to_chat(user, span_warning("You are blind and can't read anything!"))
//		return FALSE
	if(uses <= 0)
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i in 1 to pages_to_mastery)
		if(!turn_page(user))
			to_chat(user, span_warning("You stop reading the book"))
			on_reading_stopped()
			reading = FALSE
			return
	if(do_after(user, 5 SECONDS, src))
		uses--
		on_reading_finished(user)
	reading = FALSE
	return TRUE // not sure why calling parrent proc didn't work but whatever



/obj/item/book/granter/action/spell/modular/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You feel like you've experienced enough to cast [spell]!</span>")
	var/datum/action/cooldown/spell/S = new spell
	S.enchants = book_enchants
// ongain procs
	if (S.enchants.len != 0)
		to_chat(user, "<span class='warning'>Enchantments detected while gaining the spell</span>")
		S.spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
		to_chat(user, "<span class='warning'>Extra spell requirements removed</span>")
//		for (var/datum/spell_enchant/E in S.enchants)
		for (var/E in S.enchants)
			to_chat(user, "<span class='warning'>Preparing to activate enchantment gain</span>")
			E.ongain(src)
			to_chat(user, "<span class='warning'>Activated enchantment gain</span>")
// ongain procs end
	to_chat(user, "<span class='warning'>Enchantment gain looop ended</span>")
//	user.mind.AddSpell(S)
	S.Grant(user)
	to_chat(user, "<span class='warning'>Spell added to the mind</span>")
	user.log_message("learned the spell ([S])", LOG_ATTACK, color="orange")
//	onlearned(user)


/obj/item/book/granter/action/spell/modular/examine(mob/living/M)
	. = ..()
	. += "<span class='notice'>It has : [book_enchants.len] enchantments.</span>"
	. += "<span class='notice'>Its enchantment balance is [e_balance].</span>"
	. += "<span class='notice'>The spell of the book is [spell].</span>"


//spell study
/obj/item/book/spell_study
	name = "Arcane study "
	desc = "A piece of paper with something about spells written on it."
	icon = 'monkestation/code/modules/modular spells/icons_32x32.dmi'
	icon_state ="enchant_scroll"
	var/cost = 0

/obj/item/book/spell_study/proc/on_book_add(obj/item/book/granter/action/spell/modular/B, mob/U)
	return

//enchantment scroll
/obj/item/book/spell_study/enchanter
	name = "Enchantment Scroll"
	desc = "A piece of paper with a part of a spell on it."
	icon = 'monkestation/code/modules/modular spells/icons_32x32.dmi'
	icon_state ="enchant_scroll"
	var/datum/spell_enchant/enchant = /datum/spell_enchant
	var/significant = FALSE
	var/can_stack = TRUE

/obj/item/book/spell_study/enchanter/examine(mob/living/M)
	. = ..()
	. += "<span class='notice'>The cost of the enchant is: [cost].</span>"
	. += "<span class='notice'>[enchant]</span>"
	. += "<span class='notice'>[enchant.name]</span>"
	. += "<span class='notice'>[enchant.desc]</span>"


//proc that adds the enchant to the spell
/obj/item/book/spell_study/enchanter/on_book_add(obj/item/book/granter/action/spell/modular/B, mob/U)
	B.book_enchants.Add(enchant)
	balloon_alert(U, "Enchantment added")
	qdel(src)
//


//initialises an enchant the first time a scroll with it is created instead of initialising them all at the start of the round to avoid fucking with subsystems
GLOBAL_LIST_EMPTY(spell_enchants)
/obj/item/book/spell_study/enchanter/Initialize(mapload)
	. = ..()
	var/found_ench = GLOB.spell_enchants.Find(enchant)
	if (found_ench)
		enchant = GLOB.spell_enchants[found_ench]
	else
		var/new_ench = new enchant()
		enchant = new_ench




/obj/item/book/spell_study/attackby(obj/item/W, mob/user, params)
	return
/obj/item/book/spell_study/attack_self(mob/user)
	return

//enchanters
/obj/item/book/spell_study/enchanter/selfharm
	enchant = /datum/spell_enchant/selfharm
	cost = -3

/obj/item/book/spell_study/enchanter/extra_cd
	enchant = /datum/spell_enchant/extra_cd
	cost = -3

/obj/item/book/spell_study/enchanter/deadcast
	enchant = /datum/spell_enchant/deadcast
	cost = 4

// books
/obj/item/book/granter/action/spell/modular/summonitem
	spell = /datum/action/cooldown/spell/summonitem
	e_balance = -5

/obj/item/book/granter/action/spell/modular/telepathy
	spell = /datum/action/cooldown/spell/list_target/telepathy
	e_balance = -2

/obj/item/book/granter/action/spell/modular/forcewall
	spell = /datum/action/cooldown/spell/forcewall
	e_balance = -4

/obj/item/book/granter/action/spell/modular/shadowwalk
	spell = /datum/action/cooldown/spell/jaunt/shadow_walk
	e_balance = -6

