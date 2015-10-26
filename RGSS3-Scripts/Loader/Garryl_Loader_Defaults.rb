=begin
-------------------------------------------------------------------------------

Default Note Tags
Version 1.0

Created: May 28, 2015
Last update: June 2, 2015

Author: Garryl

Source: https://github.com/Garryl/RGSS3-Scripts

-------------------------------------------------------------------------------

Description:

This script registers note tags for all of the standard features and effects
that can be added normally through the GUI. It serves as both an example of
the Loader script's use, and as an alternative method of adding features and
effects.

This is also used by other scripts that add features and effects in abnormal
places, such as the features of passive skills. If you are not using any such
scripts, this one is entirely optional.

Note: Make sure you place this AFTER the main loader script.

-------------------------------------------------------------------------------

License:

Free to use and modify for both commercial and non-commercial. Just don't
claim it as your own. If you've got credits anywhere, give me credit. If not,
don't worry about it. 

-------------------------------------------------------------------------------

Installation:

Copy into a new script slot in the Materials section. Ensure that any scripts
that use it are placed in later slots.

-------------------------------------------------------------------------------

Usage Instructions:

This script provides note tag-based loading for all default features and
effects of the RPG Make VX Ace engine.

-------------------------------------------------------------------------------

Note Tags:

Features:
- Manually-entered Feature:   <feature: FEATURE_CODE, DATA_ID, VALUE>
- Element Rate:               <feature element rate: ELEMENT_ID, RATE>
- Debuff Rate:                <feature debuff rate: DEBUFF_ID, RATE>
- State Rate:                 <feature state rate: STATE_ID, RATE>
- State Resist:               <feature state resist: STATE_ID>
- Parameters:                 <feature param: PARAM_ID, MULTIPLIER>
- Parameters:                 <feature mhp/mmp/atk/def/mat/mdf/agi/luk: MULTIPLIER>
- Ex-Parameters:              <feature xparam: XPARAM_ID, MULTIPLIER>
- Ex-Parameters:              <feature hit/eva/cri/cev/mev/mrf/cnt/hrg/mrg/trg: MODIFIER>
- Sp-Parameters:              <feature sparam: SPARAM_ID, MULTIPLIER>
- Sp-Parameters:              <feature tgr/grd/rec/pha/mcr/tcr/pdr/mdr/fdr/exr: MULTIPLIER>
- Attack Element:             <feature atk element: ELEMENT_ID>
- Attack State:               <feature atk state: STATE_ID, APPLICATION_RATE>
- Attack Speed:               <feature atk speed: MODIFIER>
- Attack Times:               <feature atk times: MODIFIER>
- Add Skill Type:             <feature stype add: SKILL_TYPE_ID>
- Seal Skill Type:            <feature stype seal: SKILL_TYPE_ID>
- Add Skill:                  <feature skill add: SKILL_ID>
- Seal Skill:                 <feature skill seal: SKILL_ID>
- Equip Weapon Type:          <feature equip wtype: WEAPON_TYPE_ID>
- Equip Armor Type:           <feature equip atype: ARMOR_TYPE_ID>
- Lock Equip Slot:            <feature equip fix: EQUIPMENT_SLOT_INDEX>
- Seal Equip Slot:            <feature equip seal: EQUIPMENT_SLOT_INDEX>
- Slot Type:                  <feature slot type: SLOT_TYPE_DATA_ID>
- Enable Dual Wield:          <feature slot type: dual wield>
- Action Times+:              <feature action plus: CHANCE_OF_BONUS_ACTION>
- Special Flag:               <feature special flag: FLAG_ID>
- Flag - Auto Battle:         <feature special flag: auto battle>
- Flag - Guard:               <feature special flag: guard>
- Flag - Substitute:          <feature special flag: substitute>
- Flag - Preserve TP:         <feature special flag: preserve tp>
- Collapse Type:              <feature collapse type: COLLAPSE_TYPE_ID>
- Collapse - Boss:            <feature collapse type: boss>
- Collapse - Instant:         <feature collapse type: instant>
- Collapse - Not Disappear:   <feature collapse type: not disappear>
- Party Ability:              <feature party ability: PARTY_ABILITY_ID>
- Party - Encounter Half:     <feature party ability: encounter half>
- Party - Encounter None:     <feature party ability: encounter none>
- Party - Cancel Surprise:    <feature party ability: cancel surprise>
- Party - Raise Preemptive:   <feature party ability: raise preemptive>
- Party - Gold Double:        <feature party ability: gold double>
- Party - Drop Item Double:   <feature party ability: drop item double>

Effects:
- Manually-entered Effect:    <effect: EFFECT_CODE, DATA_ID, VALUE1, VALUE2>
- HP Recovery:                <effect recover hp: PERCENT_HP, FLAT_HP>
- MP Recovery:                <effect recover mp: PERCENT_MP, FLAT_MP>
- TP Gain:                    <effect gain tp: FLAT_TP>
- Add State:                  <effect add state: STATE_ID, APPLICATION_RATE>
- Add State - Normal Attack:  <effect add normal attack state: APPLICATION_RATE>
- Remove State:               <effect remove state: STATE_ID, REMOVAL_RATE>
- Add Buff:                   <effect add buff: PARAM_ID, NUM_TURNS>
- Add Buff:                   <effect add buff mhp/mmp/atk/def/mat/mdf/agi/luk: NUM_TURNS>
- Add Debuff:                 <effect add debuff: PARAM_ID, NUM_TURNS>
- Add Debuff:                 <effect add debuff mhp/mmp/atk/def/mat/mdf/agi/luk: NUM_TURNS>
- Remove Buff:                <effect remove buff: PARAM_ID>
- Remove Buff:                <effect remove buff mhp/mmp/atk/def/mat/mdf/agi/luk>
- Remove Debuff:              <effect remove debuff: PARAM_ID>
- Remove Debuff:              <effect remove debuff mhp/mmp/atk/def/mat/mdf/agi/luk>
- Special Effect:             <effect special: SPECIAL_EFFECT_ID>
- Special Effect - Escape:    <effect special: escape>
- Raise Parameter:            <effect grow: PARAM_ID, AMOUNT>
- Raise Parameter:            <effect grow mhp/mmp/atk/def/mat/mdf/agi/luk: AMOUNT>
- Learn Skill:                <effect learn skill: SKILL_ID>
- Common Event:               <effect common event: COMMON_EVENT_ID>

-------------------------------------------------------------------------------

Change Log:

v1.1
- Saturday, October 10, 2015
- Bug fix. Incorrect definitions for remove buff/debuff effects where the param is specified by name.
v1.0
- Tuesday, June 2, 2015
- Initial release.

-------------------------------------------------------------------------------
=end

#Import requirements check
unless (($imported || {})["Garryl"] || {})["Loader"]
  puts "Error! Garryl Loader module not imported."
  puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  puts "If Loader script is already included among your materials, please ensure that Loader Defaults (file: #{__FILE__}) comes after it."
else

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Loader_Defaults"] ||= {}
$imported["Garryl"]["Loader_Defaults"]["Version"] = "1.1"

module Garryl
  module Loader
    # *************************************************************************
    # * Default Note Tags                                                     *
    # *************************************************************************
    # * This script registers note tags for all of the standard features and  *
    # * effects that can be added normally through the GUI. It serves as both *
    # * an example of the script's use, and as an alternative method of       *
    # * adding features and effects.                                          *
    # * This is also used by other scripts that add features and effects in   *
    # * abnormal places, such as the features of passive skills.              *
    # * If you are not using any such scripts, this one is entirely optional. *
    # *************************************************************************
    # * Note: Make sure you place this script AFTER the main loader script.   *
    # *************************************************************************
    
    
    #--------------------------------------------------------------------------
    # * Features
    #--------------------------------------------------------------------------
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s*:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?))?)?\s*>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT)))
                                              # Manual feature entry
          
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+element rate\s*:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ELEMENT_RATE))  # Element Rate
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+debuff\s+rate\s*:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_DEBUFF_RATE))   # Debuff Rate
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+state\s+rate\s*:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_STATE_RATE))    # State Rate
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+state\s+resist\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STATE_RESIST))  # State Resist
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+param\s*:\s*([0-9]+)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM))         # Parameter
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mhp\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 0))      # Parameter - mhp
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mmp\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 1))      # Parameter - mmp
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+atk\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 2))      # Parameter - atk
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+def\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 3))      # Parameter - def
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mat\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 4))      # Parameter - mat
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mdf\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 5))      # Parameter - mdf
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+agi\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 6))      # Parameter - agi
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+luk\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 7))      # Parameter - luk
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+xparam\s*:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM))        # Ex-Parameter
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+hit\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 0))     # Ex-Parameter - hit
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+eva\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 1))     # Ex-Parameter - eva
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+cri\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 2))     # Ex-Parameter - cri
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+cev\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 3))     # Ex-Parameter - cev
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mev\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 4))     # Ex-Parameter - mev
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mrf\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 5))     # Ex-Parameter - mrf
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+cnt\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 6))     # Ex-Parameter - cnt
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+hrg\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 7))     # Ex-Parameter - hrg
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mrg\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 8))     # Ex-Parameter - mrg
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+trg\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 9))     # Ex-Parameter - trg
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+sparam\s*:\s*([0-9]+)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM))        # Sp-Parameter
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+tgr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 0))     # Sp-Parameter - tgr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+grd\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 1))     # Sp-Parameter - grd
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+rec\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 2))     # Sp-Parameter - rec
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+pha\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 3))     # Sp-Parameter - pha
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mcr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 4))     # Sp-Parameter - mcr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+tcr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 5))     # Sp-Parameter - tcr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+pdr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 6))     # Sp-Parameter - pdr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+mdr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 7))     # Sp-Parameter - mdr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+fdr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 8))     # Sp-Parameter - fdr
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+exr\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 9))     # Sp-Parameter - exr
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+atk\s+element\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_ELEMENT))   # Atk Element
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+atk\s+state\s*:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ATK_STATE))     # Atk State
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+atk\s+speed\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_SPEED, 0))  # Atk Speed
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+atk\s+times\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_TIMES, 0))  # Atk Times+
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+stype\s+add\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STYPE_ADD))     # Add Skill Type
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+stype\s+seal\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STYPE_SEAL))    # Disable Skill Type
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+skill\s+add\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SKILL_ADD))     # Add Skill
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+skill\s+seal\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SKILL_SEAL))    # Disable Skill
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+equip\s+wtype\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_WTYPE))   # Equip Weapon
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+equip\s+atype\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_ATYPE))   # Equip Armor
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+equip\s+fix\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_FIX))     # Lock Equip
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+equip\s+seal\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_SEAL))    # Seal Equip
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+slot\s+type\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SLOT_TYPE))     # Slot Type
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+slot\s+type\s*:\s*dual\s+wield\s*>/i),
    Game_BattlerBase::FEATURE_SLOT_TYPE, 1))  # Slot Type - dual wield
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+action\s+plus\s*:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ACTION_PLUS, 0))# Action Times+
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+special\s+flag\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG))  # Special Flag
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+special\s+flag\s*:\s*auto\s+battle\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 0))   # Special Flag - auto battle
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+special\s+flag\s*:\s*guard\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 1))   # Special Flag - guard
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+special\s+flag\s*:\s*substitute\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 2))   # Special Flag - substitute
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+special\s+flag\s*:\s*preserve\s+tp\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 3))   # Special Flag - preserve tp
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+collapse\s+type\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE)) # Collapse Effect
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+collapse\s+type\s*:\s*boss\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 1))  # Collapse Effect - boss
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+collapse\s+type\s*:\s*instant\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 2))  # Collapse Effect - instant
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+collapse\s+type\s*:\s*not\s+disappear\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 3))  # Collapse Effect - not disappear
    
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_PARTY_ABILITY)) # Party Ability
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*encounter\s+half\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 0))  # Party Ability - encounter half
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*encounter\s+none\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 1))  # Party Ability - encounter none
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*cancel\s+surprise\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 2))  # Party Ability - cancel surprise
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*raise\s+preemptive\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 3))  # Party Ability - raise preemptive
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*gold\s+double\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 4))  # Party Ability - gold double
    register(LoadFeature.new(RegexConf.new(/<\s*feature\s+party\s+ability\s*:\s*drop\s+item\s+double\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 5))  # Party Ability - drop item double

    #--------------------------------------------------------------------------
    # * Effects
    #--------------------------------------------------------------------------
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s*:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?))?)?)?\s*>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT)))
                                              # Manual effect entry
          
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+recover\s+hp\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_RECOVER_HP, 0))      # HP Recovery
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+recover\s+mp\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_RECOVER_MP, 0))      # MP Recovery
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+gain\s+tp\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_GAIN_TP, 0))         # TP Gain
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+state\s*:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_ADD_STATE))          # Add State
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+normal\s+attack\s+state\s*:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_ADD_STATE, 0))       # Add State - normal attack
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+state\s*:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_REMOVE_STATE))       # Remove State
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s*:\s*([0-9]+)[,\s]\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF))           # Add Buff
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mhp\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 0))        # Add Buff - mhp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mmp\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 1))        # Add Buff - mmp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+atk\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 2))        # Add Buff - atk
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+def\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 3))        # Add Buff - def
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mat\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 4))        # Add Buff - mat
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mdf\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 5))        # Add Buff - mdf
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+agi\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 6))        # Add Buff - agi
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+luk\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 7))        # Add Buff - luk
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s*:\s*([0-9]+)[,\s]\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF))         # Add Debuff
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mhp\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 0))      # Add Debuff - mhp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mmp\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 1))      # Add Debuff - mmp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+atk\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 2))      # Add Debuff - atk
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+def\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 3))      # Add Debuff - def
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mat\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 4))      # Add Debuff - mat
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mdf\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 5))      # Add Debuff - mdf
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+agi\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 6))      # Add Debuff - agi
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+luk\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 7))      # Add Debuff - luk
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF))        # Remove Buff
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+mhp\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 0))     # Remove Buff - mhp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+mmp\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 1))     # Remove Buff - mmp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+atk\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 2))     # Remove Buff - atk
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+def\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 3))     # Remove Buff - def
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+mat\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 4))     # Remove Buff - mat
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+mdf\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 5))     # Remove Buff - mdf
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+agi\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 6))     # Remove Buff - agi
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+buff\s+luk\s*>/i),
    Game_Battler::EFFECT_REMOVE_BUFF, 7))     # Remove Buff - luk
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF))      # Remove Debuff
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+mhp\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 0))   # Remove Debuff - mhp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+mmp\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 1))   # Remove Debuff - mmp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+atk\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 2))   # Remove Debuff - atk
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+def\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 3))   # Remove Debuff - def
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+mat\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 4))   # Remove Debuff - mat
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+mdf\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 5))   # Remove Debuff - mdf
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+agi\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 6))   # Remove Debuff - agi
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+remove\s+debuff\s+luk\s*>/i),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 7))   # Remove Debuff - luk
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+special\s*:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_SPECIAL))            # Special Effect
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+special\s*:\s*escape\s*>/i),
    Game_Battler::EFFECT_SPECIAL, Game_Battler::SPECIAL_EFFECT_ESCAPE)) # Special Effect - escape
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s*:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW))               # Raise Parameter
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mhp\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 0))            # Raise Parameter - mhp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mmp\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 1))            # Raise Parameter - mmp
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+atk\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 2))            # Raise Parameter - atk
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+def\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 3))            # Raise Parameter - def
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mat\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 4))            # Raise Parameter - mat
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mdf\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 5))            # Raise Parameter - mdf
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+agi\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 6))            # Raise Parameter - agi
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+grow\s+luk\s*:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 7))            # Raise Parameter - luk
    
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+learn\s+skill\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_LEARN_SKILL))        # Learn Skill
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+common\s+event\s*:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_COMMON_EVENT))       # Common Events
    
  end #module Loader
end #module Garryl

end #Import requirements check
