/obj/item/weapon/stock_parts
	name = "stock part"
	desc = "What?"
	icon = 'icons/obj/stock_parts.dmi'
	w_class = W_CLASS_SMALL
	var/rating = 1
	melt_temperature = MELTPOINT_STEEL
	autoignition_temperature = AUTOIGNITION_METAL

/obj/item/weapon/stock_parts/New()
	. = ..()
	pixel_x = rand(-5, 5) * PIXEL_MULTIPLIER
	pixel_y = rand(-5, 5) * PIXEL_MULTIPLIER

/obj/item/weapon/stock_parts/get_rating()
	return rating

//Rank 1

/obj/item/weapon/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = Tc_MATERIALS + "=1"
	starting_materials = list(MAT_GLASS = 200)
	w_type = RECYK_GLASS

//Console screens have a higher-than-normal rating so they don't get dumped out of a gadget bag/RPED despite being perfectly usable
/obj/item/weapon/stock_parts/console_screen/get_rating()
	return 5

/obj/item/weapon/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor2_basic"
	origin_tech = Tc_POWERSTORAGE + "=1"
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 50)
	w_type = RECYK_ELECTRONIC
	var/stored_charge = 0
	var/maximum_charge = 30000000

/obj/item/weapon/stock_parts/capacitor/examine(mob/user)
	..()
	if(stored_charge)
		to_chat(user, "<span class='notice'>\The [src.name] is charged to [stored_charge]W.</span>")
		if(stored_charge >= maximum_charge)
			to_chat(user, "<span class='info'>\The [src.name] has maximum charge!</span>")

/obj/item/weapon/stock_parts/capacitor/attackby(obj/item/weapon/W, mob/user)
	if(W.is_wrench(user))
		if(!istype(src.loc, /turf))
			to_chat(user, "<span class='warning'>\The [src] needs to be on the ground to be secured.</span>")
			return
		if(!istype(src.loc, /turf/simulated/floor)) //Prevent from anchoring this to shuttles / space
			to_chat(user, "<span class='notice'>You can't secure \the [src] to [istype(src.loc,/turf/space) ? "space" : "this"]!</span>")
			return
		to_chat(user, "You discharge \the [src] and secure it to the floor.")
		W.playtoolsound(src, 50)
		switch(src.type)
			if(/obj/item/weapon/stock_parts/capacitor)
				new /obj/machinery/power/secured_capacitor(get_turf(src.loc))
			if(/obj/item/weapon/stock_parts/capacitor/adv)
				new /obj/machinery/power/secured_capacitor/adv(get_turf(src.loc))
			if(/obj/item/weapon/stock_parts/capacitor/adv/super, /obj/item/weapon/stock_parts/capacitor/adv/super/pre_charged)
				new /obj/machinery/power/secured_capacitor/adv/super(get_turf(src.loc))
			if(/obj/item/weapon/stock_parts/capacitor/adv/super/ultra)
				new /obj/machinery/power/secured_capacitor/adv/super/ultra(get_turf(src.loc))
		qdel(src)

/obj/item/weapon/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = Tc_MAGNETS + "=1"
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 20)
	w_type = RECYK_ELECTRONIC

/obj/item/weapon/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = Tc_MATERIALS + "=1;" + Tc_PROGRAMMING + "=1"
	starting_materials = list(MAT_IRON = 30)
	w_type = RECYK_ELECTRONIC

/obj/item/weapon/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = Tc_MAGNETS + "=1"
	starting_materials = list(MAT_IRON = 10, MAT_GLASS = 20)
	w_type = RECYK_ELECTRONIC

/obj/item/weapon/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = Tc_MATERIALS + "=1"
	starting_materials = list(MAT_IRON = 80)
	w_type = RECYK_ELECTRONIC

//Rank 2

//The upgraded console screens have been disabled from being conventionally found in-game because nothing in the game
//currently uses their upgraded qualities.
/obj/item/weapon/stock_parts/console_screen/reinforced
	name = "reinforced console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "rscreen"
	origin_tech = Tc_MATERIALS + "=3"
	rating = 2
	starting_materials = list(MAT_IRON = 100, MAT_GLASS = 200)

/obj/item/weapon/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "capacitor2_adv"
	origin_tech = Tc_POWERSTORAGE + "=3"
	rating = 2
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 50)
	maximum_charge = 200000000

/obj/item/weapon/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	origin_tech = Tc_MAGNETS + "=3"
	rating = 2
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 20)

/obj/item/weapon/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = Tc_MATERIALS + "=3;" + Tc_PROGRAMMING + "=2"
	rating = 2
	starting_materials = list(MAT_IRON = 30)

/obj/item/weapon/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = Tc_MAGNETS + "=3"
	rating = 2
	starting_materials = list(MAT_IRON = 10, MAT_GLASS = 20)

/obj/item/weapon/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = Tc_MATERIALS + "=3"
	rating = 2
	starting_materials = list(MAT_IRON = 80)

//Rating 3

/obj/item/weapon/stock_parts/console_screen/reinforced/plasma
	name = "plasma console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "pscreen"
	origin_tech = Tc_MATERIALS + "=5;" + Tc_PLASMATECH + "=3"
	rating = 3
	starting_materials = list(MAT_PLASMA = 100, MAT_GLASS = 200)

/obj/item/weapon/stock_parts/capacitor/adv/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "capacitor2_super"
	origin_tech = Tc_POWERSTORAGE + "=5;" + Tc_MATERIALS + "=4"
	rating = 3
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 50)
	maximum_charge = 1000000000

/obj/item/weapon/stock_parts/scanning_module/adv/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "super_scan_module"
	origin_tech = Tc_MAGNETS + "=5"
	rating = 3
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 20, MAT_SILVER = 10)

/obj/item/weapon/stock_parts/manipulator/nano/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = Tc_MATERIALS + "=5;" + Tc_PROGRAMMING + "=2"
	rating = 3
	starting_materials = list(MAT_IRON = 40, MAT_PLASMA = 40)

/obj/item/weapon/stock_parts/micro_laser/high/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = Tc_MAGNETS + "=5"
	rating = 3
	starting_materials = list(MAT_IRON = 10, MAT_GLASS = 20, MAT_URANIUM = 10)

/obj/item/weapon/stock_parts/matter_bin/adv/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = Tc_MATERIALS + "=5"
	rating = 3
	starting_materials = list(MAT_IRON = 80)

//Rating 4
//Please don't make these too easily accessible to the station.

/obj/item/weapon/stock_parts/console_screen/reinforced/plasma/rplasma
	name = "reinforced plasma console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "pscreen"
	origin_tech = Tc_MATERIALS + "=7;" + Tc_PLASMATECH + "=3"
	rating = 4
	starting_materials = list(MAT_PLASMA = 100, MAT_IRON = 100, MAT_GLASS = 200)

/obj/item/weapon/stock_parts/matter_bin/adv/super/bluespace
	name = "bluespace matter bin"
	desc = "A container linked to a small local subspace pocket that holds raw materials. Any machine equipped with this shares its materials pool."
	icon_state = "bluespace_matter_bin"
	origin_tech = Tc_MATERIALS + "=5;" + Tc_BLUESPACE + "=4"
	rating = 4
	starting_materials = list(MAT_IRON = 80, MAT_SILVER = 20, MAT_GOLD = 20)

/obj/item/weapon/stock_parts/micro_laser/high/ultra/giga
	name = "giga micro-laser"
	icon_state = "giga_micro_laser"
	desc = "A tiny laser, capable of fine manipulation, and worryingly high damage capabilities. Used in the construction of certain devices."
	origin_tech = Tc_MAGNETS + "=8"
	rating = 4
	starting_materials = list(MAT_IRON = 250, MAT_URANIUM = 50, MAT_DIAMOND = 20, MAT_PHAZON = 5)

/obj/item/weapon/stock_parts/capacitor/adv/super/ultra
	name = "ultra capacitor"
	icon_state = "capacitor2_ultra"
	desc = "An ultra-high capacity capacitor, used in the construction of certain devices."
	origin_tech = Tc_POWERSTORAGE + "=8;" + Tc_MATERIALS + "=6"
	rating = 4
	starting_materials = list(MAT_IRON = 250, MAT_URANIUM = 100, MAT_GOLD = 20, MAT_PHAZON = 5)
	maximum_charge = 5000000000


/obj/item/weapon/stock_parts/manipulator/nano/pico/femto
	name = "femto manipulator"
	icon_state = "femto_mani"
	desc = "A manipulator capable of manipulating protons, used in the construction of certain devices."
	origin_tech = Tc_MATERIALS + "=7;" + Tc_PROGRAMMING + "=4"
	rating = 4
	starting_materials = list(MAT_IRON = 125, MAT_URANIUM = 30, MAT_SILVER = 10, MAT_PHAZON = 5)


/obj/item/weapon/stock_parts/scanning_module/adv/phasic/bluespace
	name = "bluespace scanning module"
	desc = "A compact, high resolution bluespace scanning module used in the construction of certain devices."
	icon_state = "ultra_scan_module"
	origin_tech = Tc_MAGNETS + "=7"
	rating = 4
	starting_materials = list(MAT_IRON = 50, MAT_GLASS = 20, MAT_SILVER = 10, MAT_PHAZON = 5)


// Subspace stock parts

/obj/item/weapon/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MAGNETS + "=5;" + Tc_MATERIALS + "=4;" + Tc_BLUESPACE + "=2"
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = Tc_PROGRAMMING + "=4;" + Tc_MAGNETS + "=2"
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MAGNETS + "=4;" + Tc_MATERIALS + "=4;" + Tc_BLUESPACE + "=2"
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MAGNETS + "=2;" + Tc_MATERIALS + "=5;" + Tc_BLUESPACE + "=2"
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	origin_tech = Tc_PROGRAMMING + "=3;" + Tc_MAGNETS + "=4;" + Tc_MATERIALS + "=4;" + Tc_BLUESPACE + "=2"
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	origin_tech = Tc_MAGNETS + "=4;" + Tc_MATERIALS + "=4;" + Tc_BLUESPACE + "=2"
	starting_materials = list(MAT_GLASS = 50)

/obj/item/weapon/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	origin_tech = Tc_MAGNETS + "=5;" + Tc_MATERIALS + "=5;" + Tc_BLUESPACE + "=3"
	starting_materials = list(MAT_IRON = 50)
