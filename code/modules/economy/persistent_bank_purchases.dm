
var/global/list/persistent_bank_purchaseables =	list(\
	new /datum/bank_purchaseable/human_item/reset,\
	new /datum/bank_purchaseable/candy_heart,\
	new /datum/bank_purchaseable/human_item/crayon,\
	new /datum/bank_purchaseable/human_item/paint_rainbow,\
	new /datum/bank_purchaseable/human_item/crayon_box,\
	new /datum/bank_purchaseable/human_item/paint_plaid,\
	new /datum/bank_purchaseable/human_item/stickers,\
	new /datum/bank_purchaseable/human_item/handkerchief,\
	new /datum/bank_purchaseable/human_item/bee_egg,\
	new /datum/bank_purchaseable/human_item/harmonica,\
	new /datum/bank_purchaseable/human_item/airhorn,\
	new /datum/bank_purchaseable/human_item/dramatichorn,\
	new /datum/bank_purchaseable/human_item/saxophone,\
	new /datum/bank_purchaseable/human_item/trumpet,\
	new /datum/bank_purchaseable/human_item/fiddle,\
	new /datum/bank_purchaseable/human_item/gold_zippo,\
	new /datum/bank_purchaseable/human_item/drinking_flask,\
	new /datum/bank_purchaseable/human_item/toy_sword,\
	new /datum/bank_purchaseable/human_item/sound_synth,\
	new /datum/bank_purchaseable/human_item/record,\
	new /datum/bank_purchaseable/human_item/sparkler_box,\
	new /datum/bank_purchaseable/human_item/dabbing_license,\
	new /datum/bank_purchaseable/human_item/chem_hint,\
	new /datum/bank_purchaseable/human_item/pixel_pass,\

	new /datum/bank_purchaseable/altjumpsuit,\
	new /datum/bank_purchaseable/altclown,\

	new /datum/bank_purchaseable/backpack/bp_fjallraven,\
	new /datum/bank_purchaseable/backpack/bp_randoseru,\
	new /datum/bank_purchaseable/backpack/bp_anello,\
	new /datum/bank_purchaseable/backpack/bp_brown,\
	new /datum/bank_purchaseable/backpack/nt_backpack,\
	new /datum/bank_purchaseable/backpack/bp_studded,\
	new /datum/bank_purchaseable/backpack/bp_itabag,\

	new /datum/bank_purchaseable/limbless,\
	new /datum/bank_purchaseable/space_diner,\
	new /datum/bank_purchaseable/missile_arrival,\
	new /datum/bank_purchaseable/lunchbox,\

	new /datum/bank_purchaseable/bird_respawn,\
	new /datum/bank_purchaseable/critter_respawn,\
	new /datum/bank_purchaseable/golden_ghost,\

	new /datum/bank_purchaseable/fruithat,\
	new /datum/bank_purchaseable/hoodie,\
	new /datum/bank_purchaseable/pride_o_matic,\
	new /datum/bank_purchaseable/fake_waldo,\
	new /datum/bank_purchaseable/moustache,\
	new /datum/bank_purchaseable/gold_that,\
	new /datum/bank_purchaseable/dancin_shoes,\
	new /datum/bank_purchaseable/frog,\
	new /datum/bank_purchaseable/dye_beret,\
	new /datum/bank_purchaseable/dye_cardigan,\


	new /datum/bank_purchaseable/alohamaton,\
	new /datum/bank_purchaseable/ai_hat)


/datum/bank_purchaseable
	var/name = "a thing u can buy"
	var/cost = 0
	var/atom/path = null //Object to spawn. If null, spawn nothing
	var/carries_over = 1
	var/icon = 'icons/obj/items/items.dmi'
	var/icon_state = "spacebux"
	var/icon_dir = 0
	var/icon_frame = 1

	var/list/required_levels = list() //Associated List of JOB:REQUIRED LEVEL ("Clown"=999) etc. Optional jobxp requirements for this.

	//Return 1 for successful purchase.
	//	All children that need to spawn an item should have a call to this base
	proc/Create(var/mob/living/M)
		var/equip_success = 0
		if (!path)
			return equip_success
		if (ishuman(M)) // yeah, just do the same exact thing as with trinkets. Maybe this 'put item in any open slot' thing should be its own proc?
			var/mob/living/carbon/human/H = M
			equip_success = 1
			var/obj/I = new path(H.loc)
			I.name = "[H.real_name][pick_string("trinkets.txt", "modifiers")] [I.name]"
			I.real_name = I.name
			I.quality = rand(5,80)
			var/equipped = 0
			if (H.back?.storage && H.equip_if_possible(I, SLOT_IN_BACKPACK))
				equipped = 1
			else if (H.belt?.storage && H.equip_if_possible(I, SLOT_IN_BELT))
				equipped = 1
			if (!equipped)
				if (!H.l_store && H.equip_if_possible(I, SLOT_L_STORE))
					equipped = 1
				else if (!H.r_store && H.equip_if_possible(I, SLOT_R_STORE))
					equipped = 1
				else if (!H.l_hand && H.equip_if_possible(I, SLOT_L_HAND))
					equipped = 1
				else if (!H.r_hand && H.equip_if_possible(I, SLOT_R_HAND))
					equipped = 1

				if (!equipped)
					I.set_loc(get_turf(src))

		if (isrobot(M)) //Assuming the cyborg spawns naked. otherwise we would do all these funky checks for equipped clothing and replacing them etc... who cares!!!
			var/mob/living/silicon/robot/R = M
			if (ispath(path, /obj/item/clothing))
				if(ispath(path,/obj/item/clothing/under))
					var/obj/O = new path(R.loc)
					R.clothes["under"] = O
					O.set_loc(R)
					equip_success = 1
				else if(ispath(path,/obj/item/clothing/suit))
					var/obj/O = new path(R.loc)
					R.clothes["suit"] = O
					O.set_loc(R)
					equip_success = 1
				else if(ispath(path,/obj/item/clothing/mask))
					var/obj/O = new path(R.loc)
					R.clothes["mask"] = O
					O.set_loc(R)
					equip_success = 1
				else if(ispath(path,/obj/item/clothing/head))
					var/obj/O = new path(R.loc)
					R.clothes["head"] = O
					O.set_loc(R)
					equip_success = 1
				if(equip_success)
					R.update_appearance()

		if(isAI(M))
			var/mob/living/silicon/ai/AI = M
			path = null
			AI.bought_hat = TRUE
			return


		//The AI can't really wear items...
		//Maybe use this space later to give the AI critter pets or spawn objects inside the AI core?

		return equip_success

	proc/hasJobXP(var/key)
		var/pass = 1
		for(var/X in required_levels)
			var/level = get_level(key, X)
			if(level < required_levels[X])
				pass = 0
		return pass

	nothing
		name = "Nothing"
		cost = 0

		Create(var/mob/living/M)
			return 1

	///////////////////////
	//HUMAN PURCHASEABLES//
	///////////////////////

	human_item

		Create(var/mob/living/M)
			if (!ishuman(M))
				return 0
			return ..()

		reset
			name = "Clear Purchase"
			cost = 0
			path = null

		crayon
			name = "Crayon"
			cost = 50
			path = /obj/item/pen/crayon/random
			icon = 'icons/obj/writing.dmi'
			icon_state = "crayon"

		paint_rainbow
			name = "Rainbow Paint Can"
			cost = 1500
			path = /obj/item/paint_can/rainbow
			icon = 'icons/misc/old_or_unused.dmi'
			icon_state = "paint"

		paint_plaid
			name = "Plaid Paint Can"
			cost = 3000
			path = /obj/item/paint_can/rainbow/plaid
			icon = 'icons/misc/old_or_unused.dmi'
			icon_state = "paint"

		crayon_box
			name = "Crayon Creator"
			cost = 2500
			path = /obj/item/item_box/crayon
			icon = 'icons/obj/items/storage.dmi'
			icon_state = "item_box"

		stickers
			name = "Sticker Box"
			cost = 300
			path = /obj/item/item_box/assorted/stickers
			icon = 'icons/obj/items/storage.dmi'
			icon_state = "sticker_box_assorted"

		handkerchief
			name = "Handkerchief"
			cost = 1000
			path = null
			icon = 'icons/obj/items/cloths.dmi'
			icon_state = "hanky_pink"

			Create(mob/living/M)
				// equivalent to /obj/item/cloth/handkerchief/random, but that deletes itself in new(), so this is used
				path = pick(concrete_typesof(/obj/item/cloth/handkerchief/colored))
				..()

		bee_egg
			name = "Bee Egg"
			cost = 550
			path = /obj/item/reagent_containers/food/snacks/ingredient/egg/bee
			icon = 'icons/misc/bee.dmi'
			icon_state = "petbee_egg"

		harmonica
			name = "Harmonica"
			cost = 150
			path = /obj/item/instrument/harmonica
			icon = 'icons/obj/instruments.dmi'
			icon_state = "harmonica"

		airhorn
			name = "Air Horn"
			cost = 800
			path = /obj/item/instrument/bikehorn/airhorn
			icon = 'icons/obj/instruments.dmi'
			icon_state = "airhorn"

		dramatichorn
			name = "Dramatic Horn"
			cost = 400
			path = /obj/item/instrument/bikehorn/dramatic
			icon = 'icons/obj/instruments.dmi'
			icon_state = "bike_horn"

		saxophone
			name = "Saxophone"
			cost = 600
			path = /obj/item/instrument/saxophone
			icon = 'icons/obj/instruments.dmi'
			icon_state = "sax"

		trumpet
			name = "Trumpet"
			cost = 700
			path = /obj/item/instrument/trumpet
			icon = 'icons/obj/instruments.dmi'
			icon_state = "trumpet"

		fiddle
			name = "Fiddle"
			cost = 700
			path = /obj/item/instrument/fiddle
			icon = 'icons/obj/instruments.dmi'
			icon_state = "fiddle"

		gold_zippo
			name = "Gold Zippo"
			cost = 500
			path = /obj/item/device/light/zippo/gold
			icon = 'icons/obj/items/cigarettes.dmi'
			icon_state = "gold_zippo"

		drinking_flask
			name = "Drinking Flask"
			cost = 400
			path = /obj/item/reagent_containers/food/drinks/flask
			icon = 'icons/obj/foodNdrink/bottle.dmi'
			icon_state = "flask"

		toy_sword
			name = "Toy Sword"
			cost = 900
			path = /obj/item/toy/sword
			icon = 'icons/obj/items/weapons.dmi'
			icon_state = "sword1-"

		sound_synth
			name = "Sound Synthesizer"
			cost = 14000
			path = /obj/item/noisemaker
			icon = 'icons/obj/instruments.dmi'
			icon_state = "bike_horn"

		record
			name = "Record"
			cost = 2000
			path = /obj/item/record/spacebux
			icon = 'icons/obj/radiostation.dmi'
			icon_state = "record_red"

		sparkler_box
			name = "Sparkler Box"
			cost = 1000
			path = /obj/item/storage/sparkler_box
			icon = 'icons/obj/items/sparklers.dmi'
			icon_state = "sparkler_box-close"

		dabbing_license
			name = "Dabbing License"
			cost = 4200
			path = /obj/item/card/id/dabbing_license
			icon = 'icons/obj/items/card.dmi'
			icon_state = "id_dab"

		chem_hint
			name = "Secret chem hint"
			cost = 3500
			path = /obj/item/chem_hint
			carries_over = 0
			icon = 'icons/obj/dojo.dmi'
			icon_state = "scroll"

		pixel_pass
			name = "Pixel Pass"
			cost = 2500
			path = /obj/item/pixel_pass
			icon_state = "pixel_pass"

	altjumpsuit
		name = "Alternate Jumpsuit"
		cost = 1500
		icon = 'icons/obj/clothing/uniforms/item_js_rank.dmi'
		icon_state = "assistant-alt"

		Create(var/mob/living/M)
			var/succ = 0
			if (ishuman(M))
				var/mob/living/carbon/human/H = M

				if (H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under))
					var/obj/item/clothing/under/origin = text2path("[H.w_uniform.type]/april_fools")
					if (ispath(origin))
						H.w_uniform.icon = origin.icon
						H.w_uniform.icon_state = origin.icon_state
						H.w_uniform.item_state = origin.item_state
						H.w_uniform.desc = initial(origin.desc)
						succ = 1

				if (H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit))
					var/obj/item/clothing/suit/origin = text2path("[H.wear_suit.type]/april_fools")
					if (ispath(origin))
						H.wear_suit.icon_state = origin.icon_state
						H.wear_suit.item_state = origin.item_state
						H.wear_suit.wear_state = origin.wear_state
						H.wear_suit.desc = initial(origin.desc)
						if (istype(H.wear_suit, /obj/item/clothing/suit/labcoat))
							H.wear_suit.coat_style = origin.coat_style
						succ = 1

				if (H.head && istype(H.head, /obj/item/clothing/head))
					var/obj/item/clothing/head/origin = text2path("[H.head.type]/april_fools")
					if (ispath(origin))
						H.head.icon_state = origin.icon_state
						H.head.item_state = origin.item_state
						H.head.desc = initial(origin.desc)
						if (istype(H.head, /obj/item/clothing/head/helmet/space/engineer))
							var/obj/item/clothing/head/helmet/space/engineer/helmet_with_flashlight = H.head
							var/obj/item/clothing/head/helmet/space/engineer/orig = origin
							helmet_with_flashlight.base_icon_state = orig.base_icon_state
						succ = 1

			return succ

	altclown
		name = "Alternate Clown Outfit"
		cost = 200
		icon = 'icons/obj/clothing/uniforms/item_js_gimmick.dmi'
		icon_state = "pinkclown"

		Create(var/mob/living/M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				if (H.mind)
					if (H.mind.assigned_role == "Clown")
						var/type = pick("purple","pink","yellow")
						H.w_uniform.icon = 'icons/obj/clothing/uniforms/item_js_gimmick.dmi'
						H.w_uniform.wear_image_icon = 'icons/mob/clothing/jumpsuits/worn_js_gimmick.dmi'
						H.w_uniform.icon_state = "[type]clown"
						H.w_uniform.item_state = "[type]clown"
						H.w_uniform.name = "[type] clown suit"
						var/obj/item/clothing/mask/clown_hat/the_mask = H.wear_mask
						the_mask.icon_state = "[type]clown"
						the_mask.base_icon_state = "[type]clown"
						the_mask.item_state = "[type]clown"
						the_mask.name = "[type] clown mask"
						H.shoes.icon_state = "[type]clown"
						H.shoes.item_state = "[type]clown"
						H.shoes.name = "[type] clown shoes"
						H.shoes.desc = "Normal clown shoes, just [type] instead of red."
						if (type == "purple")
							H.w_uniform.desc = "What kind of clown are you for wearing this color? It's a good question, honk."
							H.wear_mask.desc = "Purple is a very flattering color on almost everyone."
						if (type == "pink")
							H.w_uniform.desc = "The color pink is the embodiment of love and hugs and nice people. Honk."
							H.wear_mask.desc = "This reminds you of cotton candy."
						if (type == "yellow")
							H.w_uniform.desc = "Have a happy honk!"
							H.wear_mask.desc = "A ray of sunshine."
						return 1
				return 0

			return 0

	limbless
		name = "No Limbs"
		cost = 10000
		icon = 'icons/obj/foodNdrink/food_ingredient.dmi'
		icon_state = "nugget0"

		Create(var/mob/living/M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				SPAWN(6 SECONDS)
					if (H.limbs)
						if (H.limbs.l_arm)
							H.limbs.l_arm.delete()
						if (H.limbs.r_arm)
							H.limbs.r_arm.delete()
						if (H.limbs.l_leg)
							H.limbs.l_leg.delete()
						if (H.limbs.r_leg)
							H.limbs.r_leg.delete()
						boutput( H, SPAN_NOTICE("<b>Your limbs magically disappear! Oh, no!</b>") )
				return 1
			return 0

	space_diner
		name = "Space Diner Patron"
		cost = 5000
		icon = 'icons/obj/furniture/chairs.dmi'
		icon_state = "bar-stool"

		Create(var/mob/living/M)
			var/list/start
			for(var/turf/T in get_area_turfs(/area/diner/dining, 1))
				start = T
				break
			if (!start)
				return 0
			if (istype(M.loc, /obj/storage)) // for stowaways
				var/obj/storage/S = M.loc
				S.set_loc(start)
			else
				M.set_loc(start)
			return 1

	frog
		name = "Adopt a Frog"
		cost = 6000
		icon = 'icons/misc/critter.dmi'
		icon_state = "frog"
		icon_dir = SOUTH

		Create(var/mob/living/M)
			var/mob/living/critter/small_animal/frog/froggo = new(M.loc)
			SPAWN(1 SECOND)
				froggo.real_name = input(M.client, "Name your frog:", "Name your frog!", "frog")
				phrase_log.log_phrase("name-frog", froggo.real_name, TRUE)
				logTheThing(LOG_STATION, M, "named their adopted frog [froggo.real_name]")
				froggo.name = froggo.real_name
			return 1

	missile_arrival
		name = "Missile Arrival"
		cost = 20000
		path = /obj/item/tank/pocket/oxygen  // oh boy they'll need this if they are unlucky
		icon = 'icons/obj/large/32x64.dmi'
		icon_state = "arrival_missile"
		icon_dir = SOUTH

		Create(var/mob/living/M)
			var/mob/living/carbon/human/H = M
			if(istype(H))
				H.equip_new_if_possible(/obj/item/clothing/mask/breath, SLOT_WEAR_MASK)
			var/mob/living/silicon/sillycon = M
			if(istype(sillycon))
				var/obj/item/organ/brain/latejoin/latejoin_brain = null
				if (istype(sillycon,/mob/living/silicon/ai))
					var/mob/living/silicon/ai/AI = sillycon
					latejoin_brain = AI.brain
				if (istype(sillycon,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = sillycon
					latejoin_brain = R.part_head?.brain
				if(istype(latejoin_brain))
					return FALSE //Don't missile launch latejoin silicons that already exist
			SPAWN(0)
				if(istype(M.loc, /obj/storage))
					launch_with_missile(M.loc)
				else
					launch_with_missile(M)
			..()
			return TRUE

	critter_respawn
		name = "Alt Ghost Critter"
		cost = 1000
		icon = 'icons/mob/critter/robotic/boogie.dmi'
		icon_state = "boogie"
		var/list/respawn_critter_types = list(/mob/living/critter/small_animal/boogiebot/weak, /mob/living/critter/small_animal/figure/weak)

		Create(var/mob/M)
			return 1

	bird_respawn
		name = "Lil Bird Ghost Critter"
		cost = 1000
		icon = 'icons/misc/critter.dmi'
		icon_state = "sparrow"
		icon_dir = SOUTH
		var/list/respawn_critter_types = list(/mob/living/critter/small_animal/sparrow/weak, /mob/living/critter/small_animal/sparrow/robin/weak)

		Create(var/mob/M)
			return 1

	golden_ghost
		name = "Golden Ghost"
		cost = 1500
		icon = 'icons/mob/mob.dmi'
		icon_state = "ghost"
		icon_dir = SOUTH

		Create(var/mob/M)
			return 1

	backpack
		name = "Youshouldn'tseemeeium bag"
		var/bag_type = /obj/item/storage/backpack

		Create(var/mob/living/M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				if (H.back && istype(H.back, /obj/item/storage/backpack))
					var/obj/item/storage/backpack/old_bag = H.back
					if(old_bag.slots != 7) //No changing slot amounts
						return 0
					var/obj/item/storage/backpack/new_bag = new src.bag_type(M) //Spawn it inside the player so it respects satchel preference
					//Delete anything in the new bag, replace with contents of old bag.
					for (var/obj/item/I as anything in new_bag.storage.get_contents())
						qdel(I)
					for (var/obj/item/I as anything in old_bag.storage.get_contents())
						old_bag.storage.transfer_stored_item(I, new_bag, TRUE)
					qdel(old_bag)
					H.equip_if_possible(new_bag, SLOT_BACK)
					return 1
			return 0

		bp_fjallraven
			name = "Rucksack"
			cost = 1400
			icon_state = "bp_fjallraven_red"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/fjallravenred

			Create(var/mob/living/M)
				//Randomise each time a new one is made.
				if(prob(50))
					src.bag_type = /obj/item/storage/backpack/fjallravenred
				else
					src.bag_type = /obj/item/storage/backpack/fjallravenyel
				. = ..()

		bp_randoseru
			name = "Randoseru"
			cost = 1500
			icon_state = "bp_randoseru"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/randoseru

		bp_anello
			name = "Travel Backpack"
			cost = 1600
			icon_state = "bp_anello"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/anello

		nt_backpack
			name = "NT Backpack"
			cost = 600
			icon_state = "NTbackpack"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/NT

		bp_studded
			name = "Studded Backpack"
			cost = 1500
			icon_state = "bp_studded"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/studdedblack

		bp_itabag
			name = "Itabag"
			cost = 1600
			icon_state = "bp_itabag_pink"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/itabag

			Create(var/mob/living/M)
				//Randomise each time a new one is made.
				var/list/itabag_types = concrete_typesof(/obj/item/storage/backpack/itabag)
				src.bag_type = pick(itabag_types)
				. = ..()
				//Add the randomised mascot.
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.back && istype(H.back, /obj/item/storage/backpack/itabag))
						var/itabagmascot = pick("Heisenbee","Bombini","Morty","Sylvester","Dr. Acula","a clown","a mime","Jones the cat","Stir Stir","a bumblespider","a space bee","the Amusing Duck")
						H.back.desc = "Comes in cute pastel shades. Within the heart-shaped window, you can see buttons and stickers of [itabagmascot]!"

		bp_brown
			name = "Brown Backpack"
			cost = 500
			icon_state = "backpackbr"
			icon = 'icons/obj/items/storage.dmi'
			bag_type = /obj/item/storage/backpack/brown

	lunchbox
		name = "Lunchbox"
		cost = 600
		icon = 'icons/obj/items/storage.dmi'
		icon_state = "lunchbox_purple"

		Create(var/mob/living/M)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				var/obj/item/storage/lunchbox/L = pick(childrentypesof(/obj/item/storage/lunchbox))
				if ((!H.l_hand && H.equip_if_possible(new L(H), SLOT_L_HAND)) || (!H.r_hand && H.equip_if_possible(new L(H), SLOT_R_HAND)) || (H.back?.storage && H.equip_if_possible(new L(H), SLOT_IN_BACKPACK)))
					return 1
			return 0

	candy_heart
		name = "Send Candy Heart"
		cost = 2500
		icon = 'icons/obj/foodNdrink/food_candy.dmi'
		icon_state = "heart-1"

		Create(var/mob/M)
			SPAWN(rand(3 SECONDS, 15 SECONDS)) // stagger in case multiple purchases
				var/datum/db_record/R = pick(data_core.general.records)
				var/obj/storage/S = new /obj/storage/crate/packing
				S.name = "special delivery ([R["name"]])"
				var/obj/item/I = new /obj/item/reagent_containers/food/snacks/candy/candyheart(S)
				I.name = "candy heart (to: [R["name"]] from: [M])"
				if(transception_array) //hand off delivery to array's management systems
					transception_array.direct_queue += S
				else
					for(var/i in 1 to 3)
						shippingmarket.receive_crate(S)
						sleep(randfloat(10 SECONDS, 20 SECONDS))
						if(istype(get_area(S), /area/station))
							return
					var/list/turf/last_chance_turfs = get_area_turfs(/area/station/quartermaster/office, 1)
					if(length(last_chance_turfs))
						S.set_loc(pick(last_chance_turfs))
					else
						S.set_loc(get_random_station_turf())
			return TRUE

	/////////////////////////////////////
	//CLOTHING (FITS HUMAN AND CYBORGS)//
	/////////////////////////////////////

	fruithat
		name = "Fruit Hat"
		cost = 150
		path = /obj/item/clothing/head/fruithat
		icon = 'icons/obj/clothing/item_hats.dmi'
		icon_state = "fruithat"

	hoodie
		name = "Hoodie"
		cost = 1500
		path = /obj/item/clothing/suit/hoodie/random
		icon = 'icons/obj/clothing/overcoats/hoods/hoodies.dmi'
		icon_state = "hoodie"

	pride_o_matic
		name = "Pride-O-Matic Jumpsuit"
		cost = 1200
		path = /obj/item/clothing/under/pride/special
		icon = 'icons/obj/clothing/uniforms/item_js_pride.dmi'
		icon_state = "gay"

	fake_waldo
		name = "Stripe Outfit"
		cost = 1400
		path = /obj/item/clothing/under/gimmick/fake_waldo
		icon = 'icons/obj/clothing/uniforms/item_js_gimmick.dmi'
		icon_state = "waldont1"

	moustache
		name = "Discount Fake Moustache"
		cost = 500
		path = /obj/item/clothing/mask/moustache/safe
		icon = 'icons/obj/clothing/item_masks.dmi'
		icon_state = "moustache"

	gold_that
		name = "Golden Top Hat"
		cost = 900
		path = /obj/item/clothing/head/that/gold
		icon = 'icons/obj/clothing/item_hats.dmi'
		icon_state = "gtophat"

	dancin_shoes
		name = "Dancin Shoes"
		cost = 2000
		path = /obj/item/clothing/shoes/heels/dancin
		icon = 'icons/obj/clothing/item_shoes.dmi'
		icon_state = "wheels"

	dye_cardigan
		name = "Dyeable Cardigan"
		cost = 1200
		path = /obj/item/clothing/suit/knitsweater/cardigan/dyeable
		icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
		icon_state = "cardigan"

	dye_beret
		name = "Dyeable Beret"
		cost = 1200
		path = /obj/item/clothing/head/beret/dyeable
		icon = 'icons/obj/clothing/item_hats.dmi'
		icon_state = "dye_beret"

	////////////////////////
	//CYBORG PURCHASEABLES//
	////////////////////////

	alohamaton
		name = "Alohamaton Skin"
		cost = 4000
		icon = 'icons/mob/robots.dmi'
		icon_state = "alohamaton"
		icon_dir = SOUTH

		Create(var/mob/living/M)
			if (isrobot(M))
				var/mob/living/silicon/robot/R = M
				R.alohamaton_skin = 1
				R.update_appearance()
				return 1
			return 0

	////////////////////
	//AI PURCHASEABLES//
	////////////////////

	malfAI
		name = "Malf AI Skin (placeholder)"
		cost = 2000
		icon = 'icons/mob/ai.dmi'
		icon_state = "ai"

		Create(var/mob/living/M)
			if (isAI(M))
				var/mob/living/silicon/ai/A = M
				A.custom_emotions = ai_emotions | list("ROGUE(reward)" = "ai_red")
				A.faceEmotion = "ai_red"
				A.set_color("#EE0000")
				return 1
			return 0

	ai_hat
		name = "AI hat"
		cost = 1000
		icon = 'icons/obj/clothing/item_hats.dmi'
		icon_state = "frog_hat"

		Create(var/mob/living/M)
			if (isAI(M))
				var/mob/living/silicon/ai/A = M
				A.bought_hat = TRUE
				return 1
			return 0
