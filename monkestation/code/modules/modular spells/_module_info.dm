/*

Modular spells by art_0




Instalation guide (changes outside of the module) (for /datum/action based spells):

	in code/modules/spells/spell.dm
		add these vars to /datum/action/cooldown/spell
*/
	var/range = 1
	var/cast_on_self = TRUE
	var/cast_on_others = TRUE
/*

		replace every spell type's own range variable with the new range variable












*/
