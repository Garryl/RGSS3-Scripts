=begin
-------------------------------------------------------------------------------

Passive Skills and Items
Version 1.0.0.1

Created: Apr. 4, 2015
Last update: Apr. 5, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script provides passive features for skills and items, defined through
note tags. Any feature that a normal feature-bearing game element (actors,
classes, weapons, armors, enemies, and states) can provide can also be provided
by passive skills and items. See the Note Tags section for more details.

-------------------------------------------------------------------------------

License:

Free to use and modify for both commercial and non-commercial. Just don't
claim it as your own. If you've got credits anywhere, give me credit. If not,
don't worry about it. 

-------------------------------------------------------------------------------

Installation:

Copy into a new script slot in the Materials section.

-------------------------------------------------------------------------------

Usage Instructions:

This script supports and requires note tags. See below for more information.

-------------------------------------------------------------------------------

Note Tags:

The following note tags are supported. Additional functionality can be
gained by putting the indicated text in the "Note" field of states, skill,
and so forth.

Usable Item Features: These note tags apply to any game elements that are
usable items (items and skills). Any number of them can be applied to the same
game element, even multiples of the same feature.

These note tags cause the item or skill to passively grant the indicated
features while they are available.
- Inventory Items: Items with passive features will apply to all actors in the
  party while the party has at least one of that item.
- Active Skills: For skills that are usable in battle or in the menu, they will
  grant their passive features to the battler that knows them (whether through
  class and level, event-based permanent learning, or equipment and states,
  but NOT from other passive skill features). The skill's passive features will
  be disabled if the skill or its skill category is sealed. If the skill has
  any equipped weapon requirements, those must also be met for the passive
  features to apply.
- Passive Skills: For skills that are purely passive (not usable in battler or
  in the menu), the restrictions are the same as with active skills. If the
  passive skill has a MP or TP cost assigned to it, it will only apply its
  features while the battler has at least that much MP/TP. The effective MP/TP
  requirement ignores the effects of cost-modifying features (mcr) from passive
  skill features.
- Enemy Action Skills and Conditions: You can assign passive skills (or active
  skills with passive features) to enemies, and their features will apply, just
  like a passive skill known by an actor. However, if you also assign a
  condition to the skill's action, it will only apply while the condition is
  met (discounting the effects of passive skill features, which can affect
  how HP/MP percentages appear if max HP/MP is altered by a passive skill
  feature). If the enemy has the same skill listed for multiple actions with
  different conditions, its passive features will apply while any of those
  conditions are met (ie: OR, not AND). Action ratings do not affect passive
  skill features.

Important Note: Passive skills ignore the effects of other passive skills when
determining whether they are active or not. Otherwise, the recursion would
cause an infinite loop. So don't try to have the effects of one passive skill
change whether o not another one is enabled.

All features of the RPG Maker VX Ace editor are available through user-friendly
note tags. For features with multiple variables (such as element rate, which
specifies both an element and the multiplier applied to it), the numbers are
separated by commas.

- Element Rate:               <passive element rate: ELEMENT_ID, RATE>
- Debuff Rate:                <passive debuff rate: DEBUFF_ID, RATE>
- State Rate:                 <passive state rate: STATE_ID, RATE>
- State Resist:               <passive state resist: STATE_ID>
- Parameters:                 <passive mhp/mmp/atk/def/mat/mdf/agi/luk: MULTIPLIER>
- Ex-Parameters:              <passive hit/eva/cri/cev/mev/mrf/cnt/hrg/mrg/trg: MODIFIER>
- Sp-Parameters:              <passive tgr/grd/rec/pha/mcr/tcr/pdr/mdr/fdr/exr: MULTIPLIER>
- Attack Element:             <passive atk element: ELEMENT_ID>
- Attack State:               <passive atk state: STATE_ID, APPLICATION_RATE>
- Attack Speed:               <passive atk speed: MODIFIER>
- Attack Times:               <passive atk times: MODIFIER>
- Add Skill Type:             <passive stype add: SKILL_TYPE_ID>
- Seal Skill Type:            <passive stype seal: SKILL_TYPE_ID>
- Add Skill:                  <passive skill add: SKILL_ID>
- Seal Skill:                 <passive skill seal: SKILL_ID>
- Equip Weapon Type:          <passive equip wtype: WEAPON_TYPE_ID>
- Equip Armor Type:           <passive equip atype: ARMOR_TYPE_ID>
- Lock Equip Slot:            <passive equip fix: EQUIPMENT_SLOT_INDEX>
- Seal Equip Slot:            <passive equip seal: EQUIPMENT_SLOT_INDEX>
- Enable Dual Wield:          <passive slot type: 1>
- Action Times+:              <passive action plus: CHANCE_OF_BONUS_ACTION>
- Flag - Auto Battle:         <passive special flag: 0>
- Flag - Guard:               <passive special flag: 1>
- Flag - Substitute:          <passive special flag: 2>
- Flag - Preserve TP:         <passive special flag: 3>
- Collapse - Boss:            <passive collapse type: 1>
- Collapse - Instant:         <passive collapse type: 2>
- Collapse - Not Disappear:   <passive collapse type: 3>
- Party - Encounter Half:     <passive party ability: 0>
- Party - Encounter None:     <passive party ability: 1>
- Party - Cancel Surprise:    <passive party ability: 2>
- Party - Raise Preremptive:  <passive party ability: 3>
- Party - Gold Double:        <passive party ability: 4>
- Party - Drop Item Double:   <passive party ability: 5>

Features can also be entered manually by their feature codes. This may be
useful for additional features provided by scripts.

- Manually-entered Feature:   <passive: FEATURE_CODE, DATA_ID, VALUE>

-------------------------------------------------------------------------------

Change Log:

v1.0.0.1
- Sunday, April 5, 2015
- Corrected some of the regexes and some incorrect flag numbers in the note tag
  descriptions.
v1.0.0.0
- Saturday, April 4, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Game_Actor
- Game_BattlerBase
- Game_Enemy
- RPG::UsableItem
- DataManager

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- N/A

The following default script functions are aliased:
- Game_Actor.feature_objects
- Game_Enemy.feature_objects
- DataManager.load_database

The following functions are added to default script classes:
- Game_BattlerBase.passive_skill_conditions_met?
- Game_BattlerBase.passive_item_conditions_met?
- Game_Enemy.passive_action_valid?
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_manual
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_all
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_arbitrary_id_value
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_arbitrary_id
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_arbitrary_value_f
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_arbitrary_value_i
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_param
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_xparam
- RPG::UsableItem.load_notetag_passive_skills_usable_item_features_sparam
- DataManager.load_passive_skills_notetags

-------------------------------------------------------------------------------
=end

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Passive Skills"] ||= {}
$imported["Garryl"]["Passive Skills"]["Version"] = "1.0.0.1"
$imported["Garryl"]["Passive Skills"]["Skill Features"] = true
$imported["Garryl"]["Passive Skills"]["Party Inventory"] = true

module Garryl
  module PassiveSkills
    module Regex
      #usable items (skill, item)
      PASSIVE_SKILL_FEATURE  = /<passive:\s*([\-\+]?[0-9]+)([,]\s*([\-\+]?[0-9]+)([,]\s*([\-\+]?[0-9]+(\.[0-9]+)?))?)?\s*>/i
                          #code [, data ID [, value]]
      
      
      FEATURE_ELEMENT_RATE  = /<passive element rate:\s*([1-9][0-9]*)[,]?\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
                                              # Element Rate
      FEATURE_DEBUFF_RATE   = /<passive debuff rate:\s*([1-9][0-9]*)[,]?\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
                                              # Debuff Rate
      FEATURE_STATE_RATE    = /<passive state rate:\s*([1-9][0-9]*)[,]?\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
                                              # State Rate
      FEATURE_STATE_RESIST  = /<passive state resist:\s*([1-9][0-9]*)\s*>/i
                                              # State Resist
      FEATURE_PARAM         = [
        /<passive mhp:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mmp:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive atk:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive def:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mat:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mdf:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive agi:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive luk:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      ]                                       # Parameter
      FEATURE_XPARAM        = [
        /<passive hit:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive eva:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive cri:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive cev:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mev:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mrf:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive cnt:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive hrg:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mrg:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive trg:\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      ]                                       # Ex-Parameter
      FEATURE_SPARAM        = [
        /<passive tgr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive grd:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive rec:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive pha:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mcr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive tcr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive pdr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive mdr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive fdr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i,
        /<passive exr:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      ]                                       # Sp-Parameter
      FEATURE_ATK_ELEMENT   = /<passive atk element:\s*([1-9][0-9]*)\s*>/i
                                              # Atk Element
      FEATURE_ATK_STATE     = /<passive atk state:\s*([1-9][0-9]*)[,]?\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
                                              # Atk State
      FEATURE_ATK_SPEED     = /<passive atk speed:\s*([\-\+]?[0-9]+)\s*>/i
                                              # Atk Speed
      FEATURE_ATK_TIMES     = /<passive atk times:\s*([\-\+]?[0-9]+)\s*>/i
                                              # Atk Times+
      FEATURE_STYPE_ADD     = /<passive stype add:\s*([1-9][0-9]*)\s*>/i
                                              # Add Skill Type
      FEATURE_STYPE_SEAL    = /<passive stype seal:\s*([1-9][0-9]*)\s*>/i
                                              # Disable Skill Type
      FEATURE_SKILL_ADD     = /<passive skill add:\s*([1-9][0-9]*)\s*>/i
                                              # Add Skill
      FEATURE_SKILL_SEAL    = /<passive skill seal:\s*([1-9][0-9]*)\s*>/i
                                              # Disable Skill
      FEATURE_EQUIP_WTYPE   = /<passive equip wtype:\s*([1-9][0-9]*)\s*>/i
                                              # Equip Weapon
      FEATURE_EQUIP_ATYPE   = /<passive equip atype:\s*([1-9][0-9]*)\s*>/i
                                              # Equip Armor
      FEATURE_EQUIP_FIX     = /<passive equip fix:\s*([0-9]+)\s*>/i
                                              # Lock Equip
      FEATURE_EQUIP_SEAL    = /<passive equip seal:\s*([0-9]+)\s*>/i
                                              # Seal Equip
      FEATURE_SLOT_TYPE     = /<passive slot type:\s*([0-9]+)\s*>/i
                                              # Slot Type
      FEATURE_ACTION_PLUS   = /<passive action plus:\s*([\+]?[0-9]+(\.[0-9]+)?)\s*>/i
                                              # Action Times+
      FEATURE_SPECIAL_FLAG  = /<passive special flag:\s*([0-9]+)\s*>/i
                                              # Special Flag
      FEATURE_COLLAPSE_TYPE = /<passive collapse type:\s*([0-9]+)\s*>/i
                                              # Collapse Effect
      FEATURE_PARTY_ABILITY = /<passive party ability:\s*([0-9]+)\s*>/i
                                              # Party Ability
    end
  end
end


class Game_BattlerBase
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Checks if the conditions are met for a passive skill
  # * A lot less restrictive than for an active skill
  #--------------------------------------------------------------------------
  def passive_skill_conditions_met?(skill)
    usable = true
    
    #puts "DEBUG: Validating passive skill usability for #{skill.name}"
    
    #Unlike active skills, don't care about being able to act,
    #nor whether or not we're in battle
    #usable = usable && usable_item_conditions_met?(skill)
    
    #Weapon type is valid to care about
    #It doesn't depend on features, so it's valid
    usable = usable && skill_wtype_ok?(skill)
    
    #Can't care about skill cost as it depends on mcr, which is a feature,
    #leading to an infinite loop
    #Don't care about cost unless it's a purely passive skill
    usable = usable && (skill.battle_ok? || skill.menu_ok? || skill_cost_payable?(skill))
    
    #Can't care about sealed skills, as that's done by a feature,
    #leading to an infinite loop
    #Skill can't be sealed and rendered unusable
    usable = usable && !skill_sealed?(skill.id) && !skill_type_sealed?(skill.stype_id)
    
    return usable
  end
  
  #--------------------------------------------------------------------------
  # * Checks if the conditions are met for a passive item
  # * Anything goes, actually
  #--------------------------------------------------------------------------
  def passive_item_conditions_met?(item)
    #puts "DEBUG: Validating passive item usability for #{item.name}"
    return true
  end

end

class Game_Actor < Game_Battler
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_passive_skills_alias_game_actor_feature_objects  feature_objects
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Array of All Objects Retaining Features
  #--------------------------------------------------------------------------
  def feature_objects
    #puts "DEBUG: Getting feature objects for actor: #{name}"
    
    #Do not recursively check passive skill features!
    #When evaluating the function of a passive skill, ignore the effects of passive skills.
    ignoring_passive_skills = @ignore_passive_skills
    @ignore_passive_skills = true
    
    #Check features of all skills known and items in party inventory
    usable_passive_skills = (ignoring_passive_skills ? [] : skills.select do |skill| passive_skill_conditions_met?(skill) end)
    #Items in party inventory
    usable_passive_items = $game_party.items.select do |item| passive_item_conditions_met?(item) end
    
    #Restore passive skill checking flag
    @ignore_passive_skills = ignoring_passive_skills
    
    return garryl_passive_skills_alias_game_actor_feature_objects + usable_passive_skills + usable_passive_items
  end
  
end


class Game_Enemy < Game_Battler
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_passive_skills_alias_game_enemy_feature_objects  feature_objects
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Array of All Objects Retaining Features
  #--------------------------------------------------------------------------
  def feature_objects
    #puts "DEBUG: Getting feature objects for enemy: #{name}"
    
    #Do not recursively check passive skill features!
    #When evaluating the function of a passive skill, ignore the effects of passive skills.
    ignoring_passive_skills = @ignore_passive_skills
    @ignore_passive_skills = true
    
    #Check features of all skills available
    usable_passive_skill_list = []
    if (!ignoring_passive_skills)
      enemy.actions.each do |action|
        usable_passive_skill_list.push($data_skills[action.skill_id]) if passive_action_valid?(action)
      end
      #Get skills added by features, even though enemies don't use them
      usable_passive_skill_list += added_skills.sort.collect do |id| $data_skills[id] end
      usable_passive_skill_list.uniq!
    end
    
    #Restore passive skill checking flag
    @ignore_passive_skills = ignoring_passive_skills
    
    return garryl_passive_skills_alias_game_enemy_feature_objects + usable_passive_skill_list
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Determine if Action Is Valid in Current State
  #     action : RPG::Enemy::Action
  #--------------------------------------------------------------------------
  def passive_action_valid?(action)
    usable = true
    
    #puts "DEBUG: Validating action usability for #{$data_skills[action.skill_id].name}"
    
    #Can't check if conditions are met as conditions can be pased on hp%/mp%,
    #which in turn depend on features, leading to an infinite loop
    usable = usable && conditions_met?(action)
    
    usable = usable && passive_skill_conditions_met?($data_skills[action.skill_id])
    
    return usable
  end
  
end


class RPG::UsableItem < RPG::BaseItem
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features
    load_notetag_passive_skills_usable_item_features_manual
    load_notetag_passive_skills_usable_item_features_all
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - manual features
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_manual
    #puts "#{self.note}"
    self.note.scan(Garryl::PassiveSkills::Regex::PASSIVE_SKILL_FEATURE) do |code, blank1, id, blank2, value|
      #code [, data ID [, value]]
      #1        3           5
      
      #puts "Captured [#{code}, #{id}, #{value}]"
      if (!id.nil? && !value.nil?)
        @features.push(RPG::BaseItem::Feature.new(code.to_i, id.to_i, value.to_f))
      elsif (!id.nil?)
        @features.push(RPG::BaseItem::Feature.new(code.to_i, id.to_i))
      else
        @features.push(RPG::BaseItem::Feature.new(code.to_i))
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - all
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_all
    load_notetag_passive_skills_usable_item_features_arbitrary_id_value(Garryl::PassiveSkills::Regex::FEATURE_ELEMENT_RATE, Game_BattlerBase::FEATURE_ELEMENT_RATE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id_value(Garryl::PassiveSkills::Regex::FEATURE_DEBUFF_RATE,  Game_BattlerBase::FEATURE_DEBUFF_RATE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id_value(Garryl::PassiveSkills::Regex::FEATURE_STATE_RATE,   Game_BattlerBase::FEATURE_STATE_RATE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_STATE_RESIST, Game_BattlerBase::FEATURE_STATE_RESIST);
    load_notetag_passive_skills_usable_item_features_param
    load_notetag_passive_skills_usable_item_features_xparam
    load_notetag_passive_skills_usable_item_features_sparam
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_ATK_ELEMENT,  Game_BattlerBase::FEATURE_ATK_ELEMENT);
    load_notetag_passive_skills_usable_item_features_arbitrary_id_value(Garryl::PassiveSkills::Regex::FEATURE_ATK_STATE,    Game_BattlerBase::FEATURE_ATK_STATE);
    load_notetag_passive_skills_usable_item_features_arbitrary_value_i( Garryl::PassiveSkills::Regex::FEATURE_ATK_SPEED,    Game_BattlerBase::FEATURE_ATK_SPEED);
    load_notetag_passive_skills_usable_item_features_arbitrary_value_i( Garryl::PassiveSkills::Regex::FEATURE_ATK_TIMES,    Game_BattlerBase::FEATURE_ATK_TIMES);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_STYPE_ADD,    Game_BattlerBase::FEATURE_STYPE_ADD);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_STYPE_SEAL,   Game_BattlerBase::FEATURE_STYPE_SEAL);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_EQUIP_WTYPE,  Game_BattlerBase::FEATURE_EQUIP_WTYPE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_EQUIP_ATYPE,  Game_BattlerBase::FEATURE_EQUIP_ATYPE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_EQUIP_FIX,    Game_BattlerBase::FEATURE_EQUIP_FIX);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_EQUIP_SEAL,   Game_BattlerBase::FEATURE_EQUIP_SEAL);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_SLOT_TYPE,    Game_BattlerBase::FEATURE_SLOT_TYPE);
    load_notetag_passive_skills_usable_item_features_arbitrary_value_f( Garryl::PassiveSkills::Regex::FEATURE_ACTION_PLUS,  Game_BattlerBase::FEATURE_ACTION_PLUS);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_SPECIAL_FLAG, Game_BattlerBase::FEATURE_SPECIAL_FLAG);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_COLLAPSE_TYPE,Game_BattlerBase::FEATURE_COLLAPSE_TYPE);
    load_notetag_passive_skills_usable_item_features_arbitrary_id(      Garryl::PassiveSkills::Regex::FEATURE_PARTY_ABILITY,Game_BattlerBase::FEATURE_PARTY_ABILITY);
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - arbitrary notetags
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_arbitrary_id_value(regex, feature_code)
    #puts "#{self.note}"
    self.note.scan(regex) {|id, value|
      #puts "Captured [#{id}, #{value}]"
      @features.push(RPG::BaseItem::Feature.new(feature_code, id.to_i, value.to_f))
    }
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - arbitrary notetags
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_arbitrary_id(regex, feature_code)
    #puts "#{self.note}"
    self.note.scan(regex) {|id, blank|
      #puts "Captured [#{id}]"
      @features.push(RPG::BaseItem::Feature.new(feature_code, id.to_i))
    }
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - arbitrary notetags
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_arbitrary_value_f(regex, feature_code, id = 0)
    #puts "#{self.note}"
    self.note.scan(regex) {|value, blank|
      #puts "Captured [#{value}]"
      @features.push(RPG::BaseItem::Feature.new(feature_code, id, value.to_f))
    }
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - arbitrary notetags with integer value
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_arbitrary_value_i(regex, feature_code, id = 0)
    #puts "#{self.note}"
    self.note.scan(regex) {|value, blank|
      #puts "Captured [#{value}]"
      @features.push(RPG::BaseItem::Feature.new(feature_code, id, value.to_i))
    }
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - params
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_param
    #puts "#{self.note}"
    Garryl::PassiveSkills::Regex::FEATURE_PARAM.each_with_index do |regex, key|
      #self.note.scan(regex) do |value, blank|
        #puts "Captured [#{code}, #{id}, #{value}]"
        #@features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARAM, key, value.to_f))
      #end
      load_notetag_passive_skills_usable_item_features_arbitrary_value_f(regex, Game_BattlerBase::FEATURE_PARAM, key)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - xparams
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_xparam
    Garryl::PassiveSkills::Regex::FEATURE_XPARAM.each_with_index do |regex, key|
      load_notetag_passive_skills_usable_item_features_arbitrary_value_f(regex, Game_BattlerBase::FEATURE_XPARAM, key)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load passive skills - usable item features notetags - sparams
  #--------------------------------------------------------------------------
  def load_notetag_passive_skills_usable_item_features_sparam
    Garryl::PassiveSkills::Regex::FEATURE_SPARAM.each_with_index do |regex, key|
      load_notetag_passive_skills_usable_item_features_arbitrary_value_f(regex, Game_BattlerBase::FEATURE_SPARAM, key)
    end
  end
  
end


module DataManager
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  class << self
    alias garryl_passive_skills_alias_datamanager_load_database    load_database
  end
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    garryl_passive_skills_alias_datamanager_load_database
    load_passive_skills_notetags
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Loads the note tags
  #--------------------------------------------------------------------------
  def self.load_passive_skills_notetags
    #puts "DEBUG: Loading passive skills notetags"
    #puts "DEBUG: Loading usable item features"
    groups = [$data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        next if obj.note.empty?
        #puts "DEBUG: Loading for #{obj.name}"
        obj.load_notetag_passive_skills_usable_item_features
      end
    end
    #puts "DEBUG: Finished loading passive skills notetags"
  end
end
