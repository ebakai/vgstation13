// Multitool -- A multitool is used for hacking electronic devices.

#define DETECT_TICKER_PERIOD	10 //in deciseconds
#define DETECT_AI				1
#define DETECT_PAI				2
#define DETECT_RECORDER			4
#define DETECT_ANALYZER			8

 //////////////////////////////////////////////////////////

/obj/item/device/multitool
	name					= "multitool"
	desc					= "Used for pulsing wires to test which to cut. Not recommended by doctors."
	icon_state				= "multitool"
	flags					= FPRINT
	siemens_coefficient		= 1
	force					= 5.0
	w_class					= 2.0
	throwforce				= 5.0
	throw_range				= 15
	throw_speed				= 3
	attack_delay			= 5
	starting_materials		= list(MAT_IRON = 50, MAT_GLASS = 20)
	w_type					= RECYK_ELECTRONIC
	melt_temperature		= MELTPOINT_SILICON
	autoignition_temperature = AUTOIGNITION_METAL
	origin_tech				= Tc_MAGNETS + "=1;" + Tc_ENGINEERING + "=1"
	// VG: We dun changed dis so we can link simple machines. - N3X
	var/datum/weakref/buffer // simple machine buffer for device linkage
	var/clone				= 0 // If this is on cloning will happen, this is handled in machinery code.

/obj/item/device/multitool/proc/IsBufferA(var/typepath)
	var/obj/machinery/bufRef = buffer?.get()
	if(!bufRef)
		return 0
	return istype(bufRef,typepath)

/obj/item/device/multitool/is_multitool(mob/user)
	return TRUE

/obj/item/device/multitool/attack_self(var/mob/user)
	. = ..()
	if(.)
		return
	if(!buffer?.get() && !clone) // Can't enable cloning without buffer.
		return

	clone = !clone
	if(clone)
		to_chat(user, "<span class='notice'>You enable cloning on \the [src].</span>")
	else
		to_chat(user, "<span class='notice'>You disable cloning on \the [src].</span>")

/obj/item/device/multitool/examine(var/mob/user)
	. = ..()

	if (buffer?.get())
		to_chat(user, "<span class='notice'>Cloning is [clone ? "enabled" : "disabled"].</span>")

/obj/item/device/multitool/proc/setBuffer(var/obj/newBuf)
	// Combined with the weakref nullcheck in examine(), this implicitly makes it so that cloning is disabled when the object is GC'd.
	buffer = newBuf == null ? null : makeweakref(newBuf)
	clone = FALSE

/obj/item/device/multitool/attack(mob/M as mob, mob/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/S = H.organs_by_name[user.zone_sel.selecting]
		if (!S)
			return
		if(!(S.is_robotic()) || user.a_intent != I_HELP)
			return ..()
		if(S.status & ORGAN_MALFUNCTIONING)
			if(do_after(user, M, 6 SECONDS))
				if(user != M)
					user.visible_message("<span class='attack'>\The [user] uses \the [src] to reboot \the [M]'s [S.display_name].</span>",\
					"<span class='attack'>You reboot \the [M]'s [S.display_name] with \the [src].</span>",\
					"You hear beeping.")
				else
					user.visible_message("<span class='attack'>\The [user] uses \the [src] to reboot their [S.display_name].</span>",\
					"<span class='attack'>You reboot your [S.display_name] with \the [src].</span>",\
					"You hear beeping.")
				S.status &= ~ORGAN_MALFUNCTIONING
				return
		else if(S.is_malfunctioning()) //Not malfunctioning from the flag. Easy mistake to make.
			to_chat(user, "<span class = 'notice'>\The [S.display_name] is malfunctioning due to damage, not electrical error.</span>")
			return
	..()

/////////////////////////
//Disguised AI detector// - changes color based on proximity to various surveillance devices
/////////////////////////

/obj/item/device/multitool/ai_detect
	var/detected = 0 //bitflags
	var/cooldown = FALSE

/obj/item/device/multitool/ai_detect/New()
	..()
	spawn() src.ticker()

/obj/item/device/multitool/ai_detect/proc/ticker()
	var/mob/M
	var/range
	var/turf/our_turf
	var/turf/T
	while(src && !src.gcDestroyed)
		detected = 0
		our_turf = get_turf(src)
		range = range(8,our_turf)

		// Search for people looking at camera monitors
		for(var/obj/machinery/computer/security/monitor in tv_monitors)
			// This is greater than 0 if someone is looking at this console
			if(length(SStgui.open_uis_by_src[ref(monitor)]))
				// cam_screen.vis_contents contains all turfs the selected camera is currently looking at
				if(our_turf in monitor.cam_screen.vis_contents)
					src.detected |= DETECT_AI
					break

		//Search for AIs
		if(!(detected & DETECT_AI))
			if(cameranet.chunkGenerated(our_turf.x, our_turf.y, our_turf.z))
				var/datum/camerachunk/chunk = cameranet.getCameraChunk(our_turf.x, our_turf.y, our_turf.z)
				if(chunk && chunk.seenby.len)
					for(M in chunk.seenby)
						if(get_dist(src,M) < 8)
							src.detected |= DETECT_AI
							break

		for(T in range) //Search for pAIs
			if(src.findItem(/mob/living/silicon/pai,T))
				src.detected |= DETECT_PAI
				break

		for(T in range) //Search for recorders
			if(src.findItem(/obj/item/device/taperecorder,T))
				src.detected |= DETECT_RECORDER
				break

		for(T in range) //Search for analyzers
			if(src.findComponent(/obj/item/device/assembly/voice,T))
				src.detected |= DETECT_ANALYZER
				break

		src.update_icon()
		sleep(DETECT_TICKER_PERIOD)
	return

/obj/item/device/multitool/ai_detect/proc/findItem(pathToFind,atom/thingToSearch)
	if(locate(pathToFind) in thingToSearch.contents)
		return 1
	for(var/mob/living/carbon/mob in thingToSearch)
		if(.(pathToFind,mob))
			return 1
	return 0

/obj/item/device/multitool/ai_detect/proc/findComponent(pathToFind,atom/thingToSearch)
	if(locate(pathToFind) in thingToSearch.contents)
		return 1
	for(var/obj/item/device/assembly_holder/assembly in thingToSearch)
		if(.(pathToFind,assembly))
			return 1
	for(var/obj/item/device/transfer_valve/valve in thingToSearch)
		if(.(pathToFind,valve))
			return 1
	for(var/mob/living/carbon/mob in thingToSearch)
		if(.(pathToFind,mob))
			return 1
	return 0

/obj/item/device/multitool/ai_detect/update_icon()
	if(src.detected)
		if(src.detected & DETECT_AI)
			src.icon_state = "[initial(src.icon_state)]_red"
		else if(src.detected & DETECT_PAI)
			src.icon_state = "[initial(src.icon_state)]_orange"
		else if(src.detected & DETECT_RECORDER)
			src.icon_state = "[initial(src.icon_state)]_yellow"
		else if(src.detected & DETECT_ANALYZER)
			src.icon_state = "[initial(src.icon_state)]_blue"
	else
		src.icon_state = initial(src.icon_state)
	return

/obj/item/device/multitool/ai_detect/examine(mob/user)
	..()
	if(src.detected)
		user << "<span class='info'>The screen displays:</span>"
		if(detected & DETECT_AI)
			to_chat(user, "<span class='info'>AI detected</span>")
		if(detected & DETECT_PAI)
			to_chat(user, "<span class='info'>pAI detected</span>")
		if(detected & DETECT_RECORDER)
			to_chat(user, "<span class='info'>Tape recorder detected</span>")
		if(detected & DETECT_ANALYZER)
			to_chat(user, "<span class='info'>Voice analyzer detected</span>")
	else
		to_chat(user, "<span class='info'>The screen is not displaying anything.</span>")

	if (cooldown == TRUE)
		to_chat(user, "<span class='info'>\The [src] seems to be charging. Is it wireless?</span>")

/obj/item/device/multitool/ai_detect/attack_self()
	var/EPI_RANGE = 7 //range to turn off cameras nearby
	var/PROB_DC_CAMS = 25 //probability to turn off cameras far away
	var/turf/T = get_turf(src)

	if (cooldown == TRUE)
		to_chat(usr, "<span class='info'>It's not ready yet!</span>")
		return

	if (cooldown == FALSE)
		for(var/obj/machinery/camera/C in view(EPI_RANGE)) //guaranteed to turnoff nearby cameras
			if (C.status) //check it's actually working
				C.emp_act(1)
				playsound(C,"sound/effects/electricity_short_disruption.ogg",50,1)

		for(var/obj/machinery/camera/H in cameranet.cameras) //global camera list
			if (prob(PROB_DC_CAMS) && T.z == H.z && H.status) //same Zlvl & working
				H.emp_act(1)
				playsound(H,"sound/effects/electricity_short_disruption.ogg",50,1)

		cooldown = TRUE
		to_chat(usr, "<span class='info'>You can feel the AI's circuits grinding.</span>")
		spawn(3000) //5minutes
			cooldown = FALSE
			to_chat(usr, "<span class='info'>\The [src] is now fully charged.</span>")

////////////////////////////////////////////////////////////////////////
#undef DETECT_TICKER_PERIOD
#undef DETECT_AI
#undef DETECT_PAI
#undef DETECT_RECORDER
#undef DETECT_ANALYZER
