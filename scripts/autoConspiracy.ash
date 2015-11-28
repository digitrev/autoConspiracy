script "autoConspiracy.ash";
notify Giestbar;

import <zlib.ash>

/*******************************************************
*	zlib defaults
/*******************************************************/
setvar("ac_useAutoAttack", true);
setvar("ac_outfitOrMaximizer", "outfits");

setvar("ac_restoreMood","");
setvar("ac_restoreAutoAttack","");

setvar("ac_goreOutfit","");
setvar("ac_goreAutoAttack","");
setvar("ac_goreFamiliar","");
setvar("ac_goreMood","");
setvar("ac_goreMaximizer","");

setvar("ac_clippingOutfit","");
setvar("ac_clippingAutoAttack","");
setvar("ac_clippingFamiliar","");
setvar("ac_clippingMood","");
setvar("ac_clippingMaximizer","");

setvar("ac_punsOutfit","");
setvar("ac_punsAutoAttack","");
setvar("ac_punsFamiliar","");
setvar("ac_punsMood","");
setvar("ac_punsMaximizer","");

setvar("ac_ESPOutfit","");
setvar("ac_ESPAutoAttack","");
setvar("ac_ESPFamiliar","");
setvar("ac_ESPMood","");
setvar("ac_ESPMaximizer","");

setvar("ac_smokesOutfit","");
setvar("ac_smokesAutoAttack","");
setvar("ac_smokesFamiliar","");
setvar("ac_smokesMood","");
setvar("ac_smokesMaximizer","");

setvar("ac_GPSOutfit","");
setvar("ac_GPSAutoAttack","");
setvar("ac_GPSFamiliar","");
setvar("ac_GPSMood","");
setvar("ac_GPSMaximizer","");

setvar("ac_EVEOutfit","");
setvar("ac_EVEAutoattack","");
setvar("ac_EVEFamiliar","");
setvar("ac_EVEMood","");
setvar("ac_EVEMaximizer","");

setvar("ac_serumOutfit","");
setvar("ac_serumAutoattack","");
setvar("ac_serumFamiliar","");
setvar("ac_serumMood","");
setvar("ac_serumMaximizer","");
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
string restoreMood       = vars["ac_restoreMood"];
string restoreAutoAttack = vars["ac_restoreAutoAttack"];

// Gore Bucket quest
string goreOutfit        = vars["ac_goreOutfit"];
string goreAutoAttack    = vars["ac_goreAutoAttack"];
string goreFamiliar      = vars["ac_goreFamiliar"];
string goreMood          = vars["ac_goreMood"];
string goreMaximizer     = vars["ac_goreMaximizer"];

// Military-grade Fingernail Clippers quest
string clippingOutfit    = vars["ac_clippingOutfit"];
string clippingAutoAttack= vars["ac_clippingAutoAttack"];
string clippingFamiliar  = vars["ac_clippingFamiliar"];
string clippingMood      = vars["ac_clippingMood"];
string clippingMaximizer = vars["ac_clippingMaximizer"];

// Puns quest
string punsOutfit        = vars["ac_punsOutfit"];
string punsAutoAttack    = vars["ac_punsAutoAttack"];
string punsFamiliar      = vars["ac_punsFamiliar"];
string punsMood          = vars["ac_punsMood"];
string punsMaximizer     = vars["ac_punsMaximizer"];

/*******************************************************
*			Variables below are for unrepeatable quests
/*******************************************************/

// ESP Quest
string ESPOutfit         = vars["ac_ESPOutfit"];
string ESPAutoAttack     = vars["ac_ESPAutoAttack"];
string ESPFamiliar       = vars["ac_ESPFamiliar"];
string ESPMood           = vars["ac_ESPMood"];
string ESPMaximizer      = vars["ac_ESPMaximizer"];

// Smokes quest
string smokesOutfit      = vars["ac_smokesOutfit"];
string smokesAutoAttack  = vars["ac_smokesAutoAttack"];
string smokesFamiliar    = vars["ac_smokesFamiliar"];
string smokesMood        = vars["ac_smokesMood"];
string smokesMaximizer   = vars["ac_smokesMaximizer"];

// GPS quest
string GPSOutfit         = vars["ac_GPSOutfit"];
string GPSAutoAttack     = vars["ac_GPSAutoAttack"];
string GPSFamiliar       = vars["ac_GPSFamiliar"];
string GPSMood           = vars["ac_GPSMood"];
string GPSMaximizer      = vars["ac_GPSMaximizer"];

// EVE quest
string EVEOutfit         = vars["ac_EVEOutfit"];
string EVEAutoattack     = vars["ac_EVEAutoattack"];
string EVEFamiliar       = vars["ac_EVEFamiliar"];
string EVEMood           = vars["ac_EVEMood"];
string EVEMaximizer      = vars["ac_EVEMaximizer"];

// P-00 Quest
string serumOutfit       = vars["ac_serumOutfit"];
string serumAutoattack   = vars["ac_serumAutoattack"];
string serumFamiliar     = vars["ac_serumFamiliar"];
string serumMood         = vars["ac_serumMood"];
string serumMaximizer    = vars["ac_serumMaximizer"];

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
}

/*******************************************************
*					changeSetup()
*	Changes familiar, outfit, mood and autoattack for
*	quest, based on user defined variables.
/*******************************************************/
void changeSetup(string fam, string gear, string aa, string mood, string maximizer)
{
	if (gear != "" && vars["ac_outfitOrMaximizer"].contains_text("outfit"))
		outfit(gear);
	if (fam != "")
		use_familiar(fam.to_familiar());
	if (maximizer != "" && vars["ac_outfitOrMaximizer"].contains_text("maximize"))
		maximize(maximizer, false);
	if (aa != "" && vars["ac_useAutoAttack"].to_boolean())
		cli_execute("autoattack " + aa);
	if (mood != ""){
		if (restoreMood == "")
			restoreMood = get_property("currentMood");
		set_property("currentMood", mood);
	}
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
	while (!contains_text(visit_url(questlog),success) && my_adventures() > 0)
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
		if (get_property("choiceAdventure989") != "1")
			set_property("choiceAdventure989", 1);
			
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
			changeSetup(punsFamiliar, punsOutfit, punsAutoAttack, punsMood, punsMaximizer);
			if (item_amount($item[encrypted micro-cassette recorder]) > 0)
				equip($item[encrypted micro-cassette recorder]);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest,"Gore Tipper"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(goreFamiliar, goreOutfit, goreAutoAttack, goreMood, goreMaximizer);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			if (item_amount($item[gore bucket]) > 0)
				equip($item[gore bucket]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest,"The Big Clipper"))
		{
			changeSetup(clippingFamiliar, clippingOutfit, clippingAutoAttack, clippingMood, clippingMaximizer);
			string hpRecovery = get_property("hpAutoRecovery"); 	// To set back to old setting
			set_property("hpAutoRecovery", "0.95");
			finishQuest($location[The Mansion of Dr. Weirdeaux]);
			set_property("hpAutoRecovery", hpRecovery);
		}
		else if (contains_text(quest, "Choking on the Rind"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(EVEFamiliar, EVEOutfit, EVEAutoAttack, EVEMood, EVEMaximizer);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest, "Out of Order"))
		{
			changeSetup(GPSFamiliar, GPSOutfit, GPSAutoAttack, GPSMood, GPSMaximizer);
			if (item_amount($item[GPS-tracking wristwatch]) > 0)
				equip($item[GPS-tracking wristwatch]);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest, "Fake Medium at Large"))
		{
			// Get Ventilation Unit if they don't have one yet
			if ((!have_equipped($item[Personal Ventilation Unit])) && (item_amount($item[Personal Ventilation Unit]) == 0))
				adv1($location[The Secret Government Laboratory],-1,"");
			changeSetup(ESPFamiliar, ESPOutfit, ESPAutoAttack, ESPMood, ESPMaximizer);
			if (item_amount($item[Personal Ventilation Unit]) > 0)
				equip($slot[acc3],$item[Personal Ventilation Unit]);
			finishQuest($location[The Secret Government Laboratory]);
		}
		else if (contains_text(quest, "Running Out of Smokes"))
		{
			changeSetup(smokesFamiliar, smokesOutfit, smokesAutoAttack, smokesMood, smokesMaximizer);
			finishQuest($location[The Deep Dark Jungle]);
		}
		else if (contains_text(quest, "Serum Sortie"))
		{
			if (can_interact())
				buy(5,$item[experimental serum P-00]);
			if (item_amount($item[experimental serum P-00]) < 5)
			{
				changeSetup(serumFamiliar, serumOutfit, serumAutoAttack, serumMood, serumMaximizer);
				string hpRecovery = get_property("hpAutoRecovery"); // To set back to old setting
				set_property("hpAutoRecovery", "0.95");
				finishQuest($location[The Mansion of Dr. Weirdeaux]);
				set_property("hpAutoRecovery", hpRecovery);
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