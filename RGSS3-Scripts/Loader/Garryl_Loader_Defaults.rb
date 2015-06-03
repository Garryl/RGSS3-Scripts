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

v1.0
- Tuesday, June 2, 2015
- Initial release.

-------------------------------------------------------------------------------
=end

#Import requirements check
unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"]
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
$imported["Garryl"]["Loader_Defaults"]["Version"] = "1.0"

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
    # * Note: Make sure you place this AFTER the main loader script.          *
    # *************************************************************************
    
    
    #--------------------------------------------------------------------------
    # * Features
    #--------------------------------------------------------------------------
    register(LoadFeature.new(RegexConf.new(/<feature:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?))?)?\s*>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT)))
                                              # Manual feature entry
          
    register(LoadFeature.new(RegexConf.new(/<feature element rate:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ELEMENT_RATE))  # Element Rate
    register(LoadFeature.new(RegexConf.new(/<feature debuff rate:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_DEBUFF_RATE))   # Debuff Rate
    register(LoadFeature.new(RegexConf.new(/<feature state rate:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_STATE_RATE))    # State Rate
    register(LoadFeature.new(RegexConf.new(/<feature state resist:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STATE_RESIST))  # State Resist
    
    register(LoadFeature.new(RegexConf.new(/<feature param:\s*([0-9]+)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM))         # Parameter
    register(LoadFeature.new(RegexConf.new(/<feature mhp:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 0))      # Parameter - mhp
    register(LoadFeature.new(RegexConf.new(/<feature mmp:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 1))      # Parameter - mmp
    register(LoadFeature.new(RegexConf.new(/<feature atk:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 2))      # Parameter - atk
    register(LoadFeature.new(RegexConf.new(/<feature def:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 3))      # Parameter - def
    register(LoadFeature.new(RegexConf.new(/<feature mat:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 4))      # Parameter - mat
    register(LoadFeature.new(RegexConf.new(/<feature mdf:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 5))      # Parameter - mdf
    register(LoadFeature.new(RegexConf.new(/<feature agi:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 6))      # Parameter - agi
    register(LoadFeature.new(RegexConf.new(/<feature luk:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_PARAM, 7))      # Parameter - luk
    
    register(LoadFeature.new(RegexConf.new(/<feature xparam:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM))        # Ex-Parameter
    register(LoadFeature.new(RegexConf.new(/<feature hit:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 0))     # Ex-Parameter - hit
    register(LoadFeature.new(RegexConf.new(/<feature eva:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 1))     # Ex-Parameter - eva
    register(LoadFeature.new(RegexConf.new(/<feature cri:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 2))     # Ex-Parameter - cri
    register(LoadFeature.new(RegexConf.new(/<feature cev:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 3))     # Ex-Parameter - cev
    register(LoadFeature.new(RegexConf.new(/<feature mev:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 4))     # Ex-Parameter - mev
    register(LoadFeature.new(RegexConf.new(/<feature mrf:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 5))     # Ex-Parameter - mrf
    register(LoadFeature.new(RegexConf.new(/<feature cnt:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 6))     # Ex-Parameter - cnt
    register(LoadFeature.new(RegexConf.new(/<feature hrg:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 7))     # Ex-Parameter - hrg
    register(LoadFeature.new(RegexConf.new(/<feature mrg:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 8))     # Ex-Parameter - mrg
    register(LoadFeature.new(RegexConf.new(/<feature trg:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_XPARAM, 9))     # Ex-Parameter - trg
    
    register(LoadFeature.new(RegexConf.new(/<feature sparam:\s*([0-9]+)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM))        # Sp-Parameter
    register(LoadFeature.new(RegexConf.new(/<feature tgr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 0))     # Sp-Parameter - tgr
    register(LoadFeature.new(RegexConf.new(/<feature grd:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 1))     # Sp-Parameter - grd
    register(LoadFeature.new(RegexConf.new(/<feature rec:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 2))     # Sp-Parameter - rec
    register(LoadFeature.new(RegexConf.new(/<feature pha:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 3))     # Sp-Parameter - pha
    register(LoadFeature.new(RegexConf.new(/<feature mcr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 4))     # Sp-Parameter - mcr
    register(LoadFeature.new(RegexConf.new(/<feature tcr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 5))     # Sp-Parameter - tcr
    register(LoadFeature.new(RegexConf.new(/<feature pdr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 6))     # Sp-Parameter - pdr
    register(LoadFeature.new(RegexConf.new(/<feature mdr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 7))     # Sp-Parameter - mdr
    register(LoadFeature.new(RegexConf.new(/<feature fdr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 8))     # Sp-Parameter - fdr
    register(LoadFeature.new(RegexConf.new(/<feature exr:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_SPARAM, 9))     # Sp-Parameter - exr
    
    register(LoadFeature.new(RegexConf.new(/<feature atk element:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_ELEMENT))   # Atk Element
    register(LoadFeature.new(RegexConf.new(/<feature atk state:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ATK_STATE))     # Atk State
    
    register(LoadFeature.new(RegexConf.new(/<feature atk speed:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_SPEED, 0))  # Atk Speed
    register(LoadFeature.new(RegexConf.new(/<feature atk times:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_ATK_TIMES, 0))  # Atk Times+
    
    register(LoadFeature.new(RegexConf.new(/<feature stype add:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STYPE_ADD))     # Add Skill Type
    register(LoadFeature.new(RegexConf.new(/<feature stype seal:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_STYPE_SEAL))    # Disable Skill Type
    register(LoadFeature.new(RegexConf.new(/<feature skill add:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SKILL_ADD))     # Add Skill
    register(LoadFeature.new(RegexConf.new(/<feature skill seal:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SKILL_SEAL))    # Disable Skill
    
    register(LoadFeature.new(RegexConf.new(/<feature equip wtype:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_WTYPE))   # Equip Weapon
    register(LoadFeature.new(RegexConf.new(/<feature equip atype:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_ATYPE))   # Equip Armor
    register(LoadFeature.new(RegexConf.new(/<feature equip fix:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_FIX))     # Lock Equip
    register(LoadFeature.new(RegexConf.new(/<feature equip seal:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_EQUIP_SEAL))    # Seal Equip
    
    register(LoadFeature.new(RegexConf.new(/<feature slot type:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SLOT_TYPE))     # Slot Type
    register(LoadFeature.new(RegexConf.new(/<feature slot type:\s*dual wield\s*>/i),
    Game_BattlerBase::FEATURE_SLOT_TYPE, 1))  # Slot Type - dual wield
    
    register(LoadFeature.new(RegexConf.new(/<feature action plus:\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ACTION_PLUS, 0))# Action Times+
    
    register(LoadFeature.new(RegexConf.new(/<feature special flag:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG))  # Special Flag
    register(LoadFeature.new(RegexConf.new(/<feature special flag:\s*auto battle\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 0))   # Special Flag - auto battle
    register(LoadFeature.new(RegexConf.new(/<feature special flag:\s*guard\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 1))   # Special Flag - guard
    register(LoadFeature.new(RegexConf.new(/<feature special flag:\s*substitute\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 2))   # Special Flag - substitute
    register(LoadFeature.new(RegexConf.new(/<feature special flag:\s*preserve tp\s*>/i),
    Game_BattlerBase::FEATURE_SPECIAL_FLAG, 3))   # Special Flag - preserve tp
    
    register(LoadFeature.new(RegexConf.new(/<feature collapse type:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE)) # Collapse Effect
    register(LoadFeature.new(RegexConf.new(/<feature collapse type:\s*boss\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 1))  # Collapse Effect - boss
    register(LoadFeature.new(RegexConf.new(/<feature collapse type:\s*instant\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 2))  # Collapse Effect - instant
    register(LoadFeature.new(RegexConf.new(/<feature collapse type:\s*not disappear\s*>/i),
    Game_BattlerBase::FEATURE_COLLAPSE_TYPE, 3))  # Collapse Effect - not disappear
    
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_BattlerBase::FEATURE_PARTY_ABILITY)) # Party Ability
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*encounter half\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 0))  # Party Ability - encounter half
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*encounter none\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 1))  # Party Ability - encounter none
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*cancel surprise\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 2))  # Party Ability - cancel surprise
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*raise preemptive\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 3))  # Party Ability - raise preemptive
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*gold double\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 4))  # Party Ability - gold double
    register(LoadFeature.new(RegexConf.new(/<feature party ability:\s*drop item double\s*>/i),
    Game_BattlerBase::FEATURE_PARTY_ABILITY, 5))  # Party Ability - drop item double

    #--------------------------------------------------------------------------
    # * Effects
    #--------------------------------------------------------------------------
    register(LoadEffect.new(RegexConf.new(/<effect:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)(?:[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?))?)?)?\s*>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT)))
                                              # Manual effect entry
          
    register(LoadEffect.new(RegexConf.new(/<effect recover hp:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_RECOVER_HP, 0))      # HP Recovery
    register(LoadEffect.new(RegexConf.new(/<effect recover mp:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_RECOVER_MP, 0))      # MP Recovery
    register(LoadEffect.new(RegexConf.new(/<effect gain tp:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_GAIN_TP, 0))         # TP Gain
    
    register(LoadEffect.new(RegexConf.new(/<effect add state:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_ADD_STATE))          # Add State
    register(LoadEffect.new(RegexConf.new(/<effect add normal attack state:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_ADD_STATE, 0))       # Add State - normal attack
    register(LoadEffect.new(RegexConf.new(/<effect remove state:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_REMOVE_STATE))       # Remove State
    
    register(LoadEffect.new(RegexConf.new(/<effect add buff:\s*([0-9]+)[,\s]\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF))           # Add Buff
    register(LoadEffect.new(RegexConf.new(/<effect add buff mhp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 0))        # Add Buff - mhp
    register(LoadEffect.new(RegexConf.new(/<effect add buff mmp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 1))        # Add Buff - mmp
    register(LoadEffect.new(RegexConf.new(/<effect add buff atk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 2))        # Add Buff - atk
    register(LoadEffect.new(RegexConf.new(/<effect add buff def:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 3))        # Add Buff - def
    register(LoadEffect.new(RegexConf.new(/<effect add buff mat:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 4))        # Add Buff - mat
    register(LoadEffect.new(RegexConf.new(/<effect add buff mdf:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 5))        # Add Buff - mdf
    register(LoadEffect.new(RegexConf.new(/<effect add buff agi:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 6))        # Add Buff - agi
    register(LoadEffect.new(RegexConf.new(/<effect add buff luk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_BUFF, 7))        # Add Buff - luk
    
    register(LoadEffect.new(RegexConf.new(/<effect add debuff:\s*([0-9]+)[,\s]\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF))         # Add Debuff
    register(LoadEffect.new(RegexConf.new(/<effect add debuff mhp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 0))      # Add Debuff - mhp
    register(LoadEffect.new(RegexConf.new(/<effect add debuff mmp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 1))      # Add Debuff - mmp
    register(LoadEffect.new(RegexConf.new(/<effect add debuff atk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 2))      # Add Debuff - atk
    register(LoadEffect.new(RegexConf.new(/<effect add debuff def:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 3))      # Add Debuff - def
    register(LoadEffect.new(RegexConf.new(/<effect add debuff mat:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 4))      # Add Debuff - mat
    register(LoadEffect.new(RegexConf.new(/<effect add debuff mdf:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 5))      # Add Debuff - mdf
    register(LoadEffect.new(RegexConf.new(/<effect add debuff agi:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 6))      # Add Debuff - agi
    register(LoadEffect.new(RegexConf.new(/<effect add debuff luk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_ADD_DEBUFF, 7))      # Add Debuff - luk
    
    register(LoadEffect.new(RegexConf.new(/<effect remove buff:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF))        # Remove Buff
    register(LoadEffect.new(RegexConf.new(/<effect remove buff mhp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 0))     # Remove Buff - mhp
    register(LoadEffect.new(RegexConf.new(/<effect remove buff mmp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 1))     # Remove Buff - mmp
    register(LoadEffect.new(RegexConf.new(/<effect remove buff atk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 2))     # Remove Buff - atk
    register(LoadEffect.new(RegexConf.new(/<effect remove buff def:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 3))     # Remove Buff - def
    register(LoadEffect.new(RegexConf.new(/<effect remove buff mat:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 4))     # Remove Buff - mat
    register(LoadEffect.new(RegexConf.new(/<effect remove buff mdf:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 5))     # Remove Buff - mdf
    register(LoadEffect.new(RegexConf.new(/<effect remove buff agi:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 6))     # Remove Buff - agi
    register(LoadEffect.new(RegexConf.new(/<effect remove buff luk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_BUFF, 7))     # Remove Buff - luk
    
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF))      # Remove Debuff
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff mhp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 0))   # Remove Debuff - mhp
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff mmp:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 1))   # Remove Debuff - mmp
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff atk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 2))   # Remove Debuff - atk
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff def:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 3))   # Remove Debuff - def
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff mat:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 4))   # Remove Debuff - mat
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff mdf:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 5))   # Remove Debuff - mdf
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff agi:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 6))   # Remove Debuff - agi
    register(LoadEffect.new(RegexConf.new(/<effect remove debuff luk:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_REMOVE_DEBUFF, 7))   # Remove Debuff - luk
    
    register(LoadEffect.new(RegexConf.new(/<effect special:\s*([0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_SPECIAL))            # Special Effect
    register(LoadEffect.new(RegexConf.new(/<effect special:\s*escape\s*>/i),
    Game_Battler::EFFECT_SPECIAL, Game_Battler::SPECIAL_EFFECT_ESCAPE)) # Special Effect - escape
    
    register(LoadEffect.new(RegexConf.new(/<effect grow:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW))               # Raise Parameter
    register(LoadEffect.new(RegexConf.new(/<effect grow mhp:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 0))            # Raise Parameter - mhp
    register(LoadEffect.new(RegexConf.new(/<effect grow mmp:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 1))            # Raise Parameter - mmp
    register(LoadEffect.new(RegexConf.new(/<effect grow atk:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 2))            # Raise Parameter - atk
    register(LoadEffect.new(RegexConf.new(/<effect grow def:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 3))            # Raise Parameter - def
    register(LoadEffect.new(RegexConf.new(/<effect grow mat:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 4))            # Raise Parameter - mat
    register(LoadEffect.new(RegexConf.new(/<effect grow mdf:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 5))            # Raise Parameter - mdf
    register(LoadEffect.new(RegexConf.new(/<effect grow agi:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 6))            # Raise Parameter - agi
    register(LoadEffect.new(RegexConf.new(/<effect grow luk:\s*([\-\+]?[0-9]+)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_GROW, 7))            # Raise Parameter - luk
    
    register(LoadEffect.new(RegexConf.new(/<effect learn skill:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_LEARN_SKILL))        # Learn Skill
    register(LoadEffect.new(RegexConf.new(/<effect common event:\s*([1-9][0-9]*)\s*>/i, RegexConf::CAPTURE_INT),
    Game_Battler::EFFECT_COMMON_EVENT))       # Common Events

  end
end

end #Import requirements check
