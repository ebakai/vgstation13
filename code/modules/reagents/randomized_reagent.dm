/datum/randomized_reagent
	var/brute = 0
	var/oxy   = 0
	var/tox   = 0
	var/fire  = 0
	var/clone = 0

	var/explode = 0

	var/simp_type = null
	var/immerse   = FALSE
	var/kill      = FALSE
	var/cat       = FALSE

/datum/randomized_reagent/proc/init()
	var/datum/log_controller/I = investigations[I_CHEMS]
	var/investigate_text = "<small>[time_stamp()]</small> || Initializing <a href='?_src_=vars;Vars=\ref[src]'>randomized reagent</a>"
	for(var/k in vars)
		vars[k] = initial(vars[k])

	// Modifiers, do nothing on their own
	if(prob(5)) // explode=1 just gibs, explode=2 is a non-breaching explosion, explode=3 breaches, explode=4 breaches reinforced floors
		explode = 1

		if(prob(1))
			explode += 1

		if(prob(0.1))
			explode += 1

		if(prob(0.1))
			explode += 1

		investigate_text += "- explode [explode]"

	// Standard damage types
	var/generator/G = generator("num", 150, 0.001, SQUARE_RAND) // Second numeric argument is significantly more likely
	for(var/k in list("brute", "oxy", "tox", "fire", "clone"))
		if(prob((k!="clone")?20:2)) // Room-temperature clone damage healing should be rare
			vars[k] = G.Rand()
			if(prob(75)) // Mostly beneficial
				vars[k] = -vars[k]
			investigate_text += "- [k] [vars[k]]"

	// Effects to discourage unethical testing by non-antags
	if(prob(3)) // Turn female humans into boring males
		investigate_text += "- immerse"
		immerse = TRUE

	if(prob(1)) // Instant death
		kill = TRUE
		investigate_text += "- kill"

	if(prob(0.5)) // Transform into a simple animal
		simp_type = pick(/mob/living/simple_animal/cat, /mob/living/simple_animal/cat/kitten, /mob/living/simple_animal/cat/snek, /mob/living/simple_animal/corgi, /mob/living/simple_animal/corgi/puppy, /mob/living/simple_animal/corgi/sasha, /mob/living/simple_animal/corgi/saint, /mob/living/simple_animal/crab, /mob/living/simple_animal/cow, /mob/living/simple_animal/chicken, /mob/living/simple_animal/rabbit, /mob/living/simple_animal/rabbit/bunny, /mob/living/simple_animal/hostile/lizard, /mob/living/simple_animal/hostile/lizard/frog, /mob/living/simple_animal/penguin, /mob/living/simple_animal/penguin/chick)
		investigate_text += "- simplify [simp_type]"

	if(prob(0.25)) // Transform into a catbeast
		cat = TRUE
		investigate_text += "- cat"

	investigate_text += "<br />"
	I.write(investigate_text)


/datum/randomized_reagent/proc/on_mindful_life(var/mob/living/carbon/human/H)
	if(kill)
		H.death(explode)
		switch(explode)
			if(2)
				explosion(get_turf(H), 0, 0, 1, 3, whodunnit=H)
			if(3)
				explosion(get_turf(H), 0, 1, 3, 5, whodunnit=H)
			if(4 to INFINITY)
				explosion(get_turf(H), 1, 3, 5, 7, whodunnit=H)
		return

	if(simp_type)
		var/mob/living/simple_animal/S = new simp_type(get_turf(H))
		S.name = get_first_word(H.name)
		S.real_name = get_first_word(H.real_name)
		S.flavor_text = H.flavor_text
		S.gender = H.gender
		S.desc = "Something is off about this one."
		S.meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/human
		H.reagents.trans_to(S.reagents, S.reagents.maximum_volume)

		S.health = 100
		S.maxHealth = 100
		S.stop_automated_movement = TRUE
		S.wander = FALSE
		S.speak_chance = 0
		S.can_breed = FALSE //No ERP allowed
		S.is_pet = FALSE //No ERP allowed

		H.Premorph()
		H.audible_scream()
		H.mind.transfer_to(S)
		var/obj/effect/smoke/smoke = new /obj/effect/smoke(get_turf(H))
		smoke.time_to_live = 1
		if(explode)
			hgibs(get_turf(H), H.virus2, H.dna, H.species.flesh_color, H.species.blood_color, explode*explode)
		qdel(H)
		return

	if(immerse && isjusthuman(H) && H.gender != MALE)
		H.emote("faint")
		var/obj/effect/smoke/smoke = new /obj/effect/smoke(get_turf(H))
		smoke.time_to_live = 1
		H.gender = MALE

		H.my_appearance.h_style = pick("Bald", "Bedhead", "Bedhead 2", "Bowl", "Skinhead", "Balding Hair", "Nitori", "Manbun")
		H.my_appearance.f_style = pick("Neckbeard", "Full Beard", "Unshaven")
		H.my_appearance.s_tone = rand(-10, 10)

		H.my_appearance.r_eyes = H.my_appearance.g_eyes = H.my_appearance.b_eyes = 0
		H.my_appearance.r_facial = H.my_appearance.r_hair = 20
		H.my_appearance.g_facial = H.my_appearance.g_hair = 20
		H.my_appearance.b_facial = H.my_appearance.b_hair = 20

		H.update_hair()
		H.update_body()
		H.regenerate_icons()
		H.check_dna_integrity()
		H.update_dna_from_appearance()

	if(cat && !iscatbeast(H))
		H.set_species("Tajaran")
		H.regenerate_icons()
		H.emote("me", MESSAGE_HEAR, pick("meows", "mews"))
		playsound(H, 'sound/voice/catmeow.ogg', 100)

	H.adjustBruteLoss(brute*REM)
	H.adjustOxyLoss(oxy*REM)
	H.adjustToxLoss(tox*REM)
	H.adjustFireLoss(fire*REM)
	H.adjustCloneLoss(clone*REM)
	H.updatehealth()

var/datum/randomized_reagent/global_randomized_reagent = null

/proc/init_randomized_reagent()
	global_randomized_reagent = new
	global_randomized_reagent.init()
