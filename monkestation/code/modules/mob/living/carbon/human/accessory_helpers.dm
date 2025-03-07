/datum/species/proc/return_accessory_layer(layer, datum/sprite_accessory/added_accessory, mob/living/carbon/human/host, passed_color)
	var/list/return_list = list()
	var/layertext = mutant_bodyparts_layertext(layer)
	var/g = (host.physique == FEMALE) ? "f" : "m"
	for(var/list_item in added_accessory.external_slots)
		var/can_hidden_render = return_exernal_render_state(list_item, host)
		if(!can_hidden_render)
			continue // we failed the render check just dont bother
		if(!host.get_organ_slot(list_item) && !istype(host, /mob/living/carbon/human/dummy/extra_tall))
			continue
		var/mutable_appearance/new_overlay = mutable_appearance(added_accessory.icon, layer = -layer)
		if(added_accessory.gender_specific)
			new_overlay.icon_state = "[g]_[list_item]_[added_accessory.icon_state]_[layertext]"
		else
			new_overlay.icon_state = "m_[list_item]_[added_accessory.icon_state]_[layertext]"
		new_overlay.color = passed_color
		return_list += new_overlay
		if(added_accessory.is_emissive)
			return_list += emissive_appearance_copy(new_overlay, host)

	for(var/list_item in added_accessory.body_slots)
		if(!host.get_bodypart(list_item) && !istype(host, /mob/living/carbon/human/dummy/extra_tall))
			continue
		var/mutable_appearance/new_overlay = mutable_appearance(added_accessory.icon, layer = -layer)
		if(added_accessory.gender_specific)
			new_overlay.icon_state = "[g]_[list_item]_[added_accessory.icon_state]_[layertext]"
		else
			new_overlay.icon_state = "m_[list_item]_[added_accessory.icon_state]_[layertext]"
		new_overlay.color = passed_color
		return_list += new_overlay
		if(added_accessory.is_emissive)
			return_list += emissive_appearance_copy(new_overlay, host)

	if(istype(host, /mob/living/carbon/human/dummy/extra_tall))
		var/mob/living/carbon/human/dummy/extra_tall/bleh = host
		bleh.extra_bodyparts += return_list

	return return_list

/proc/return_exernal_render_state(external_slot, mob/living/carbon/human/human)
	switch(external_slot)
		if(ORGAN_SLOT_EXTERNAL_TAIL)
			if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
				return FALSE
			return TRUE
		if(ORGAN_SLOT_EXTERNAL_SNOUT)
			if(!(human.wear_mask?.flags_inv & HIDESNOUT) && !(human.head?.flags_inv & HIDESNOUT))
				return TRUE
			return FALSE
		if(ORGAN_SLOT_EXTERNAL_FRILLS)
			if(!(human.head?.flags_inv & HIDEEARS))
				return TRUE
			return FALSE
		if(ORGAN_SLOT_EXTERNAL_SPINES)
			return TRUE //todo
		if(ORGAN_SLOT_EXTERNAL_WINGS)
			if(!human.wear_suit)
				return TRUE
			if(!(human.wear_suit.flags_inv & HIDEJUMPSUIT))
				return TRUE
			return FALSE
		if(ORGAN_SLOT_EXTERNAL_ANTENNAE)
			return TRUE //todo
		if(ORGAN_SLOT_EXTERNAL_POD_HAIR)
			if((human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
				return FALSE
			return TRUE
