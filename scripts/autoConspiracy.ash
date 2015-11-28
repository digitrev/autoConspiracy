script "autoConspiracy.ash";
notify Giestbar;
/*******************************************************
*	autoConspiracy.ash
*	Version r19
*
*	Will retrieve and automatically adventure to finish
*	the daily quest on the conspiracy island. To ensure
*	successful operation, the user should fill in the 
*	user defined variables below. If you do not fill in
*	the variables with appropriate outfits, autoattacks,
*	and familiars, there is a risk that the script
*	will consume a lot of your adventures for little gain.
*	Quests in the mansion will automatically have your HP
*	recovery threshold set to 95%. Make sure your healing
*	options are sufficient.
*
*	Outfit: the name of the outfit to use for that quest.
*	If left blank, only necessary equipment will be equipped.
*	Personal Ventilation Units will always be equipped in 
*	accessory slot #3 if your outfit does not include one.
*	
*	AutoAttack: for user created combat macros. 
*	If left blank, it will default to mafia's standard behavior
*	for dealing with automated combat.
*
*	Familiar: the proper/official name of the familiar to use.
*	If left blank, your familiar will not be changed.
*
*	Mood: the name of the mood you want to use.
*	If left blank, your mood will not be changed.
*
*	You will NEED to set a CCS or combat macro in order to
*	successfully complete the military-grade fingernail
*	clippers quest!
*
*	Special thanks to SKF for being my guinea pig.
/*******************************************************/

/*******************************************************
*			USER DEFINED VARIABLES START
/*******************************************************/

// For restoring at the end of the script, if desired
string restoreMood			= "";
string restoreAutoAttack 	= "";

// Gore Bucket quest
string goreOutfit			= "goreOutfit";
string goreAutoAttack		= "";
string goreFamiliar			= "hobo monkey";
string goreMood				= "";

// Military-grade Fingernail Clippers quest
string clippingOutfit		= "";
string clippingAutoAttack	= "";
string clippingFamiliar		= "";
string clippingMood			= "";

// Puns quest
string punsOutfit			= "punsOutfit";
string punsAutoAttack		= "";
string punsFamiliar			= "";
string punsMood				= "";

/*******************************************************
*			Variables below are for unrepeatable quests
/*******************************************************/

// ESP Quest
string ESPOutfit 			= "";
string ESPAutoAttack 		= "";
string ESPFamiliar 			= "";
string ESPMood				= "";

// Smokes quest
string smokesOutfit 		= "smokesOutfit";
string smokesAutoAttack		= "";
string smokesFamiliar		= "Steam-Powered Cheerleader";
string smokesMood			= "aftercore, smokes";

// GPS quest
string GPSOutfit			= "GPSOutfit";
string GPSAutoAttack		= "";
string GPSFamiliar			= "xiblaxian holo-companion";
string GPSMood				= "";

// EVE quest
string EVEOutfit			= "";
string EVEAutoattack		= "";
string EVEFamiliar			= "";
string EVEMood				= "";

// P-00 Quest
string serumOutfit			= "";
string serumAutoattack		= "";
string serumFamiliar		= "";
string serumMood			= "";

/*******************************************************
*			USER DEFINED VARIABLES END
*		PLEASE DO NOT MODIFY VARIABLES BELOW
/*******************************************************/

string questlog = "questlog.php?which=1";
string radio = "place.php?whichplace=airport_spooky&action=airport2_radio";
string success = "to the <a class=nounder target=mainpane href=place.php?whichplace=airport_spooky><b>radio</b>";
item [slot] equipment;
familiar fam;

/*******************************************************
*					saveSetup()
*	Saves your familiar and equipment at the start of
*	the script to revert back to them afterwards.
/*******************************************************/
void saveSetup()
{
	fam = my_familiar();
	foreach eqSlot in $slots[]
		equipment[eqSlot] = equipped_item(eqSlot);
}

/*******************************************************
*					restoreSetup()
*	Restores your familiar and equipment after execution
*	of the script to the state they were in at the
*	beginning. Also restores default mood and
*	autoattack if those are set.
/*******************************************************/
void restoreSetup()
{
	use_familiar(fam);
	foreach eqSlot in $slots[]
	{
		if (equipped_item(eqSlot) != equipment[eqSlot])
			equip(eqSlot, equipment[eqSlot]);
	}
	if (restoreAutoAttack != "")
		cli_execute("autoattack " + restoreAutoAttack);
	if (restoreMood != "")
		set_property("currentMood", restoreMood);
		//cli_execute("mood " + restoreMood);
}

/*******************************************************
*					changeSetup()
*	Changes familiar, outfit, mood and autoattack for
*	quest, based on user defined variables.
/*******************************************************/
void changeSetup(string fam, string gear, string aa, string mood)
{
	if (gear != "")
		outfit(gear);
	if (fam != "")
		use_familiar(fam.to_familiar());
		//cli_execute("familiar " + fam);
	if (aa != "")
		cli_execute("autoattack " + aa);
	if (mood != ""){
		if (restoreMood == "")
			restoreMood = get_property("currentMood");
		set_property("currentMood", mood);
	}
		//cli_execute("mood " + mood);
}

/*******************************************************
*					finishQuest()
*	Adventures at the appropriate location for the quest
*	until the quest is finished. Automatically restores
*	mp after every fight. Equips appropriate items for
*	quest as necessary.
/*******************************************************/
void finishQuest(location place)
{
	while (!contains_text(visit_url(questlog),success))
	{
		if (my_mp() < 100)
			restore_mp(100);
		adventure(1,place);
	}
}

void main()
{
	try
	{
		// Save equipment and familiar state
		saveSetup();
		// Set kolmafia variables for EVE/ESP quest
		if (get_property("choiceAdventure988") != "1")
			set_property("choiceAdventure988", 1);
			//cli_execute("set choiceAdventure988=1");
		if (get_property("choiceAdventure989") != "1")
			set_property("choiceAdventure989", 1);
			//cli_execute("set choiceAdventure989=1");
			
		// Check for unturned in quest
		if (contains_text(visit_url(questlog),success))
			visit_url("choice.php?pwd&option=1&whichchoice=984"); 
		
		// Grab quest
		visit_url(radio);
		visit_url("choice.php?pwd&option=1&whichchoice=984");
		string quest = visit_url(questLog); // get questlog text
		
		// Do the quest!
		if (contains_text(quest,"Pungle in the Jungle"))
		{
			changeSetup(punsFamiliar, punsOutfit, punsAutoAttack, punsMood);
			if (item_amount($item[encrypted micro-cassette recorder]) > 0)
				equip($item[encrypted micro-cassette recorder]);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest,"Gore Tipper"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(goreFamiliar, goreOutfit, goreAutoAttack, goreMood);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			if (item_amount($item[gore bucket]) > 0)
				equip($item[gore bucket]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest,"The Big Clipper"))
		{
			changeSetup(clippingFamiliar, clippingOutfit, clippingAutoAttack, clippingMood);
			string hpRecovery = get_property("hpAutoRecovery"); 	// To set back to old setting
			set_property("hpAutoRecovery", "0.95");
			//cli_execute("set hpAutoRecovery=0.95"); 				// Change hp recovery for mansion
			finishQuest($location[The Mansion of Dr. Weirdeaux]);
			set_property("hpAutoRecovery", hpRecovery);
			//cli_execute("set hpAutoRecovery=" + hpRecovery);
		}
		else if (contains_text(quest, "Choking on the Rind"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(EVEFamiliar, EVEOutfit, EVEAutoAttack, EVEMood);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest, "Out of Order"))
		{
			changeSetup(GPSFamiliar, GPSOutfit, GPSAutoAttack, GPSMood);
			if (item_amount($item[GPS-tracking wristwatch]) > 0)
				equip($item[GPS-tracking wristwatch]);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest, "Fake Medium at Large"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(ESPFamiliar, ESPOutfit, ESPAutoAttack, ESPMood);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest, "Running Out of Smokes"))
		{
			changeSetup(smokesFamiliar, smokesOutfit, smokesAutoAttack, smokesMood);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest, "Serum Sortie"))
		{
			if (can_interact())
				buy(5,$item[experimental serum P-00]);
			if (item_amount($item[experimental serum P-00]) < 5)
			{
				changeSetup(serumFamiliar, serumOutfit, serumAutoAttack, serumMood);
				string hpRecovery = get_property("hpAutoRecovery"); // To set back to old setting
				set_property("hpAutoRecovery", "0.95");
				//cli_execute("set hpAutoRecovery=0.95"); 			// Change hp recovery for mansion
				finishQuest($location[The Mansion of Dr. Weirdeaux]);
				set_property("hpAutoRecovery", hpRecovery);
				//cli_execute("set hpAutoRecovery=" + hpRecovery);
			}
		}
		else
			print("I can't figure out what your conspiracy island quest is. :(", "red");
		// Turn in quest!
		visit_url(radio);
		visit_url("choice.php?pwd&option=1&whichchoice=984");
	}
	finally
	{
		// Remove Personal Ventilation Unit if it is equipped.
		foreach eqSlot in $slots[acc1, acc2, acc3]
		{
			if (equipped_item(eqSlot) == $item[Personal Ventilation Unit])
				equip(eqSlot,$item[none]);
		}
		restoreSetup();
	}
}