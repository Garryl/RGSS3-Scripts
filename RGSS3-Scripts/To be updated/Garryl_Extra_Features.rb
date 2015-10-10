=begin
-------------------------------------------------------------------------------

Extra Features
Version 1.3

Created: Mar. 27, 2015
Last update: Apr. 8, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script provides support for additional features, defined through note
tags. Any normal game object that can have features (actors, classes, enemies,
weapons, armor, and states) supports these features. See the Note Tags section
for more details on what features are implemented and what they do.

This script provides "power features", which enhance the effectiveness of
specific elements, skills and items, and state and debuff applications, flat 
"param plus" features that add a flat amount to a battler's parameters, and
"dynamic features", which have values calculated on the fly from formulas you
can provide.

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
gained by putting the indicated text in the "Note" field of states or skill.

Multiple feature tags can be placed in the same note, even of the same type.
You could, for example, have a weapon that modifies the power of multiple
elements (or even the same element multiple times, if you felt the need).
    Ex: <element power: 3 1.25>
        <element power: 4 1.5>
        <element power: 7 2.1>
        <element power: 9 0.7>

Power Features: These features improve the effects of skills and items.
- Element power: Multiplies damage/healing done with skills/items using an
  element, identified by the element ID (see the Terms tab).
- Debuff power: Multiplies the application rate of a debuff when caused by
  skills/items that have a chance of applying it, identified by the stat
  the debuff applies to.
  (0: mhp, 1: mmp, 2: atk, 3: def, 4: mat, 5: mdf, 6: agi, 7:luk). 
- State power: Multiplies the application rate of a state when caused by
  skills/items that have a chance of applying it, identified by the state ID.
- Skill power: Multiplies the damage/healing done by usage of a skill,
  identified by the skill ID. Only affects the formula, not fixed/percentage
  hp/mp restoration in the "effects" section.
- Item power: Multiplies the damage/healing done by usage of that item,
  identified by the item ID. Only affects the formula, not fixed/percentage
  hp/mp restoration in the "effects" section.

All of the power feature note tags follow the same format.
- ID_NUMBER is a non-zero, positive integer (ie: 1 or greater).
- MULTIPLIER accepts both integers and floating point values, and can be either
positive or negative.
- Any amount of white space is allowed around the numbers. They may,
  optionally, be comma-separated.
- Valid Locations: Actor, Class, Weapon, Armor, Enemy, State
- Valid Strings (case insensitive): <element/debuff/state/skill/item power: ID_NUMBER MULTIPLIER >
    Ex: <element power: 2 1.5>  #Increases the damage/healing of Absorb element
                                #skills and items by 50%.
    Ex: <skill power: 33 0.75>  #Reduces the damage/healing of skill 33 by 25%.
    Ex: <debuff power: 3 2>     #Doubles the application rate of def debuffs.
    Ex: <item power: 25 -1>     #Causes item 25 to heal instead of damage, and
                                #vice-versa.
    Ex: <state power: 12 0>     #Prevents the battler from applying state 12
                                #with skills or items.

Param Plus: These features add a flat amount to a specific parameter. These
tags can be entered in human-readable format (ex: <param plus atk: 35>), or
have their index entered manually (ex: <param plus: 2 35>). Manual entry may be
useful for compatability with other scripts that add new parameters.
(0: mhp, 1: mmp, 2: atk, 3: def, 4: mat, 5: mdf, 6: agi, 7:luk).
- MODIFIER is a positive or negative integer.
- PARAM_INDEX is a positive integer.
- Any amount of white space is allowed around the numbers. They may,
  optionally, be comma-separated.
- Valid Locations: Actor, Class, Weapon, Armor, Enemy, State
- Valid Strings (case insensitive):
  <param plus mhp/mmp/atk/def/mat/mdf/agi/luk: MODIFIER >
  <param plus: PARAM_INDEX MODIFIER >

Dynamic Features: These features work just like normal features, except that
their values are calculated by a script call, evaluating the formula you
provide (just like skill and item damage formulas). Like the formula box, the
entirety of a value script must be one one line. Use semicolons (';') to split
apart lines of Ruby script.
- FEATURE_CODE is a positive integer indicating the code of the feature.
  See Game_BattlerBase in the RTP scripts the list of feature codes.
  You can also use the codes of new features introduces in 
- DATA_ID is a positive integer indicating the id of whatever the feature
  applies to, such as element indices.
- VALUE_FORMULA is the Ruby script that will be evaluated when checking the
  dynamic feature's value. You can use the following variables in your script.
  a: The battler whose feature is being evaluated.
  v: $game_variables
- Any amount of white space is allowed around the numbers. They may,
  optionally, be comma-separated.
- Valid Locations: Actor, Class, Weapon, Armor, Enemy, State
- Valid Strings (case insensitive):
  <dynamic: FEATURE_CODE, DATA_ID> VALUE_FORMULA </dynamic>
  Ex: <dynamic: 21, 2>1-hp_rate</dynamic>   #Increases a battler's atk
                                    #proportionately to its missing HP.

Note: Dynamic features work semi-recursively. You can chain them from one param
to another and they will work as expected (ex: increasing hit by some function
of agi, while agi is dynamically modified by atk and def, will take into
account the dynamic features affecting agi when calculating hit). However, when
the dynamic features loop back on themselves, recursion is limited to one
iteration whenever evaluation occurs; essentially, when calculating its value,
a dynamic feature will not take itself into account, and when calculating its
value to supply it to another dynamic feature's formula, it will ignore that
feature and any others further up the line of calculation.

For example, if you had a battler with 10 def and three dynamic param plus
features, adding a flat value to def, equal to a.def
(ie: <dynamic: 21, 3>a.def</dynamic>). The first one would evaluate a.def,
taking into account the second (which would count only the third) and third
(which would count only the second), then the second one would do the same with
the first and third, and finally the third would do the same with the first and
second dynamic features.

base def: 10
f1: +(base def + f1.f2 + f1.f3)
  = +(10 + (10 + f1.f2.f3) + (10 + f1.f3.f2))
  = +(10 + (10 + 10) + (10 + 10))
  = +50
f2: +(base def + f2.f1 + f2.f3)
  = +50
f3: +(base def + f3.f1 + f3.f2)
  = +50
def = base def + f1 + f2 + f3
    = 160

Warning: Features are evaluated ridiculously often. Make very sure that your
formulas do not have any side effects (that they don't modify any variables
while being evaluated), or else things probably won't work as intended.

-------------------------------------------------------------------------------

Change Log:

v1.3
- Wednesday, April 8, 2015
- Added dynamic features.
v1.2
- Sunday, April 5, 2015
- Added param plus, for adding flat amounts to a parameter.
- Note tags with multiple numbers can now, optionally, be comma-separated.
- Changed the names of the aliased functions and the notetag loading functions
  to match the new style I'm trying out for greater compatability between my
  scripts.
v1.1
- Saturday, March 28, 2015
- Bug fix. User was not passed to elements_max_rate for Normal Attack element attacks.
v1.0
- Friday, March 27, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Game_BattlerBase
- Game_Battler
- RPG::BaseItem
- RPG::BaseItem::Feature
- DataManager

-------------------------------------------------------------------------------

Compatibility:

This script uses feature codes in the 367xxx range.

This script defines the following new classes
- RPG::BaseItem::DynamicFeature < RPG::BaseItem::Feature

The following default script functions are overwritten:
- Game_Battler.make_damage_value
- Game_Battler.item_element_rate
- Game_Battler.elements_max_rate
- Game_Battler.item_effect_add_state_attack
- Game_Battler.item_effect_add_state_normal
- Game_Battler.item_effect_add_debuff

The following default script functions are aliased:
- Game_BattlerBase.all_features
- Game_BattlerBase.param_plus
- DataManager.load_database

The following functions are added to default script classes:
- Game_BattlerBase.element_power
- Game_BattlerBase.debuff_power
- Game_BattlerBase.state_power
- Game_BattlerBase.skill_power
- Game_BattlerBase.item_power
- RPG::BaseItem.load_notetag_extra_features
- RPG::BaseItem.load_notetag_feature_arbitrary_power
- RPG::BaseItem.load_notetag_feature_element_power
- RPG::BaseItem.load_notetag_feature_debuff_power
- RPG::BaseItem.load_notetag_feature_state_power
- RPG::BaseItem.load_notetag_feature_skill_power
- RPG::BaseItem.load_notetag_feature_item_power
- RPG::BaseItem.load_notetag_feature_param_plus
- RPG::BaseItem.load_notetag_feature_dynamic
- RPG::BaseItem::Feature.static?
- RPG::BaseItem::Feature.dynamic?
- DataManager.load_extra_features_notetags

-------------------------------------------------------------------------------
=end

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Extra Features"] ||= {}
$imported["Garryl"]["Extra Features"]["Version"] = "1.3"
$imported["Garryl"]["Extra Features"]["Element Power"] = true
$imported["Garryl"]["Extra Features"]["Debuff Power"] = true
$imported["Garryl"]["Extra Features"]["State Power"] = true
$imported["Garryl"]["Extra Features"]["Skill Power"] = true
$imported["Garryl"]["Extra Features"]["Item Power"] = true
$imported["Garryl"]["Extra Features"]["Param Plus"] = true
$imported["Garryl"]["Extra Features"]["Dynamic Features"] = true

module Garryl
  module ExtraFeatures
    module BattlerBase
      #----------------------------------------------------------------------
      # * Constants (Features)
      #----------------------------------------------------------------------
      FEATURE_ELEMENT_POWER = 367011          # Element Power
      FEATURE_DEBUFF_POWER  = 367012          # Debuff Power
      FEATURE_STATE_POWER   = 367013          # State Power
      FEATURE_SKILL_POWER   = 367014          # Skill Power
      FEATURE_ITEM_POWER    = 367015          # Item Power
      FEATURE_PARAM_PLUS    = 367021          # Parameter Plus
    end
    
    module Regex
      #base items (essentially, anything that has features)
      ELEMENT_POWER = /<element power:\s*([1-9][0-9]*)[,]?\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      DEBUFF_POWER  = /<debuff power:\s*([1-9][0-9]*)[,]?\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      STATE_POWER   = /<state power:\s*([1-9][0-9]*)[,]?\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      SKILL_POWER   = /<skill power:\s*([1-9][0-9]*)[,]?\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      ITEM_POWER    = /<item power:\s*([1-9][0-9]*)[,]?\s*([\-\+]?[0-9]+(\.[0-9]+)?)\s*>/i
      PARAM_PLUS    = [
        /<param plus mhp:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus mmp:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus atk:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus def:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus mat:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus mdf:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus agi:\s*([\+\-]?[0-9]+)\s*>/i,
        /<param plus luk:\s*([\+\-]?[0-9]+)\s*>/i
      ]
      PARAM_PLUS_MANUAL = /<param plus:\s*([0-9]+)[,]?\s*([\+\-]?[0-9]+)\s*>/i
      
      DYNAMIC_FEATURE_MANUAL = /<dynamic:\s*([0-9]+)[,]?\s*([0-9]+)\s*>(.*)<\/dynamic>/i

    end
  end
end  
  
class Game_BattlerBase
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_extra_features_alias_game_battlerbase_all_features   all_features
  alias garryl_extra_features_alias_game_battlerbase_param_plus     param_plus
  
  # *************************************************************************
  # * Constants                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Constants (Features)
  #--------------------------------------------------------------------------
  FEATURE_ELEMENT_POWER = Garryl::ExtraFeatures::BattlerBase::FEATURE_ELEMENT_POWER
  FEATURE_DEBUFF_POWER  = Garryl::ExtraFeatures::BattlerBase::FEATURE_DEBUFF_POWER
  FEATURE_STATE_POWER   = Garryl::ExtraFeatures::BattlerBase::FEATURE_STATE_POWER
  FEATURE_SKILL_POWER   = Garryl::ExtraFeatures::BattlerBase::FEATURE_SKILL_POWER
  FEATURE_ITEM_POWER    = Garryl::ExtraFeatures::BattlerBase::FEATURE_ITEM_POWER
  FEATURE_PARAM_PLUS    = Garryl::ExtraFeatures::BattlerBase::FEATURE_PARAM_PLUS
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Array of All Feature Objects
  #--------------------------------------------------------------------------
  def all_features
    #puts "DEBUG: Resolving features for battler base: #{name}"
    
    #Gets all features, which includes snapshots of dynamic features.
    features_result = garryl_extra_features_alias_game_battlerbase_all_features
    
    #select static features
    resolved_features = features_result.select do |feature| feature.static? end
    
    #snapshot dynamic features and add them to the list
    dynamic_features = features_result.select do |feature| feature.dynamic? end
    dynamic_features.each do |feature| resolved_features.push(feature.snapshot(self)) end
    
    return resolved_features
  end
  
  #--------------------------------------------------------------------------
  # * Get Added Value of Parameter
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    garryl_extra_features_alias_game_battlerbase_param_plus(param_id) + features_sum(FEATURE_PARAM_PLUS, param_id)
  end

  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Element Power
  #--------------------------------------------------------------------------
  def element_power(element_id)
    features_pi(FEATURE_ELEMENT_POWER, element_id)
  end
  
  #--------------------------------------------------------------------------
  # * Get Debuff Power
  #--------------------------------------------------------------------------
  def debuff_power(param_id)
    features_pi(FEATURE_DEBUFF_POWER, param_id)
  end
  
  #--------------------------------------------------------------------------
  # * Get State Power
  #--------------------------------------------------------------------------
  def state_power(state_id)
    features_pi(FEATURE_STATE_POWER, state_id)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Power
  #--------------------------------------------------------------------------
  def skill_power(skill_id)
    features_pi(FEATURE_SKILL_POWER, skill_id)
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Power
  #--------------------------------------------------------------------------
  def item_power(item_id)
    features_pi(FEATURE_ITEM_POWER, item_id)
  end
  
end



class Game_Battler < Game_BattlerBase
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Calculate Damage
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    #puts "DEBUG: Make damage value"
    #puts "  User: #{user.name}"
    #puts "  Subject: #{name}"
    #puts "  Item: #{item.name} (ID: #{item.id})"
    value = item.damage.eval(user, self, $game_variables)
    #puts "  Base Damage: #{value}"
    value *= user.skill_power(item.id) if item.is_a?(RPG::Skill)  #Skill power
    #puts "  User Skill Power: #{user.skill_power(item.id)}" if item.is_a?(RPG::Skill)
    value *= user.item_power(item.id) if item.is_a?(RPG::Item)    #Item power
    #puts "  User Item Power: #{user.item_power(item.id)}" if item.is_a?(RPG::Item)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    @result.make_damage(value.to_i, item)
  end
  
  #--------------------------------------------------------------------------
  # * Get Element Modifier for Skill/Item
  #--------------------------------------------------------------------------
  def item_element_rate(user, item)
    #puts "DEBUG: Element rate"
    #puts "  User: #{user.name}"
    #puts "  Subject: #{name}"
    if (item.damage.element_id < 0)
      return (user.atk_elements.empty? ? 1.0 : elements_max_rate(user.atk_elements, user))
    else
      #puts "  Fixed Element ID: #{item.damage.element_id}"
      #puts "    Element Rate: #{element_rate(item.damage.element_id)}"
      #puts "    User Element Power: #{user.element_power(item.damage.element_id)}"
      #puts "    Final Rate: #{element_rate(item.damage.element_id) * user.element_power(item.damage.element_id)}"
      return element_rate(item.damage.element_id) * user.element_power(item.damage.element_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Get Maximum Elemental Adjustment Amount
  #     elements : An array of attribute IDs
  #    Returns the most effective adjustment of all elemental alignments.
  #--------------------------------------------------------------------------
  def elements_max_rate(elements, user = nil)
    #puts "  Using best element"
    #return elements.inject([0.0]) {|r, i| r.push(element_rate(i) * (user == nil ? 1.0 : user.element_power(i))) }.max
    return elements.inject([0.0]) {|r, i|
      e_rate = element_rate(i)
      e_pwr = (user == nil ? 1.0 : user.element_power(i))
      rate = e_rate * e_pwr
      r.push(rate)
      #puts "  Element ID: #{i}"
      #puts "    Element Rate: #{e_rate}"
      #puts "    User Element Power: #{e_pwr}"
      #puts "    Final Rate: #{rate}"
    }.max
  end
  
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal Attack
  #--------------------------------------------------------------------------
  def item_effect_add_state_attack(user, item, effect)
    #puts "DEBUG: State application (normal attack)"
    #puts "  User: #{user.name}"
    #puts "  Subject: #{name}"
    user.atk_states.each do |state_id|
      chance = effect.value1
      chance *= state_rate(state_id)
      chance *= user.atk_states_rate(state_id)
      chance *= user.state_power(state_id)      #State power
      chance *= luk_effect_rate(user)
      #puts "  State ID: #{state_id}"
      #puts "    Base Chance: #{effect.value1}"
      #puts "    State Rate: #{state_rate(state_id)}"
      #puts "    User Attack States Rate: #{user.atk_states_rate(state_id)}"
      #puts "    User State Power: #{user.state_power(state_id)}"
      #puts "    Luck Effect Rate: #{luk_effect_rate(user)}"
      #puts "    Final Chance: #{chance}"
      if rand < chance
        add_state(state_id)
        @result.success = true
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal
  #--------------------------------------------------------------------------
  def item_effect_add_state_normal(user, item, effect)
    #puts "DEBUG: State application (direct)"
    #puts "  User: #{user.name}"
    #puts "  Subject: #{name}"
    chance = effect.value1
    chance *= state_rate(effect.data_id) if opposite?(user)
    chance *= user.state_power(effect.data_id)              #State power
    chance *= luk_effect_rate(user)      if opposite?(user)
    #puts "  State ID: #{effect.data_id}"
    #puts "    Base Chance: #{effect.value1}"
    #puts "    State Rate: #{state_rate(effect.data_id)}"
    #puts "    User State Power: #{user.state_power(effect.data_id)}"
    #puts "    Luck Effect Rate: #{luk_effect_rate(user)}"
    #puts "    Final Chance: #{chance}"
    if rand < chance
      add_state(effect.data_id)
      @result.success = true
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Debuff] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_debuff(user, item, effect)
    #puts "DEBUG: Debuff application"
    #puts "  User: #{user.name}"
    #puts "  Subject: #{name}"
    chance = debuff_rate(effect.data_id) * luk_effect_rate(user)
    chance *= user.debuff_power(effect.data_id)                 #Debuff power
    #puts "  Debuff ID: #{effect.data_id}"
    #puts "    Debuff Rate: #{debuff_rate(effect.data_id)}"
    #puts "    Luck Effect Rate: #{luk_effect_rate(user)}"
    #puts "    User Debuff Power: #{user.debuff_power(effect.data_id)}"
    #puts "    Final Chance: #{chance}"
    if rand < chance
      add_debuff(effect.data_id, effect.value1)
      @result.success = true
    end
  end
  
end



# ***************************************************************************
# * New Class                                                               *
# ***************************************************************************
class RPG::BaseItem::DynamicFeature < RPG::BaseItem::Feature
  # *************************************************************************
  # * Class Variables                                                       *
  # *************************************************************************
  @@dynamic_feature_recursion_list = []   #List of all dynamic features that
            #are being recursively evaluated. Skips features on the list.
  
  # *************************************************************************
  # * Accessors                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Accessors (overwritten)
  #--------------------------------------------------------------------------
  attr_writer   :value            #Overwrites that of the superclass
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Overwrites accessor of superclass
  #--------------------------------------------------------------------------
  def value(reference_battler = nil)
    #puts( (reference_battler ? "DEBUG: Evaluating dynamic feature on battler #{reference_battler.name}" : "DEBUG: No reference battler!"))
    #puts "SCRIPT: #{@value}"
    if (!@@dynamic_feature_recursion_list.include?(self))
      #puts "  Evaluating"
      @@dynamic_feature_recursion_list.push(self)
      evaluated_value = evaluate(reference_battler, $game_variables)
      @@dynamic_feature_recursion_list.delete(self)
    else
      #puts "  Skipping evaluation"
      evaluated_value = default_value
    end
    #puts "RESULT: #{evaluated_value}"
    
    return evaluated_value
  end
  
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic features
  # * False
  #--------------------------------------------------------------------------
  def static?
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic features
  # * True
  #--------------------------------------------------------------------------
  def dynamic?
    return true
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Default value of a dynamic feature
  # * Used in case of skipping due to recursion or when an eval error occurs
  #--------------------------------------------------------------------------
  def default_value
    #puts "DEBUG: Getting default value"
    
    case @feature_code
    #multipliers
    when Game_BattlerBase::FEATURE_DEBUFF_RATE, Game_BattlerBase::FEATURE_ELEMENT_RATE, Game_BattlerBase::FEATURE_STATE_RATE, Game_BattlerBase::FEATURE_PARAM, Game_BattlerBase::FEATURE_SPARAM
      return 1
    #special flags
    when Game_BattlerBase::FEATURE_SPECIAL_FLAG, Game_BattlerBase::FEATURE_PARTY_ABILITY
      return -1
    #multipliers - new features from this script
    when Game_BattlerBase::FEATURE_DEBUFF_POWER, Game_BattlerBase::FEATURE_ELEMENT_POWER, Game_BattlerBase::FEATURE_STATE_POWER, Game_BattlerBase::FEATURE_ITEM_POWER, Game_BattlerBase::FEATURE_SKILL_POWER
      return 1
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # * Evaluates the value script
  # * a: Current reference battler
  # * v: $game_variables
  #--------------------------------------------------------------------------
  def evaluate(a, v)
    #return eval(@value)
    return Kernel.eval(@value) rescue default_value
  end
  
  #--------------------------------------------------------------------------
  # * Creates a snapshot of this feature with its reference battler
  #--------------------------------------------------------------------------
  def snapshot(reference_battler = nil)
    return RPG::BaseItem::Feature.new(@code, @data_id, value(reference_battler))
  end
  
end


class RPG::BaseItem::Feature
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic features
  # * True
  #--------------------------------------------------------------------------
  def static?
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic features
  # * False
  #--------------------------------------------------------------------------
  def dynamic?
    return false
  end
end


class RPG::BaseItem
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load extra features notetags
  #--------------------------------------------------------------------------
  def load_notetag_extra_features
    load_notetag_feature_element_power
    load_notetag_feature_debuff_power
    load_notetag_feature_state_power
    load_notetag_feature_skill_power
    load_notetag_feature_item_power
    load_notetag_feature_param_plus
    load_notetag_feature_dynamic
  end
  
  #--------------------------------------------------------------------------
  # * Load arbitrary power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_arbitrary_power(regex, feature_code)
    #puts "#{self.note}"
    self.note.scan(regex) {|id, value|
      #puts "Captured [#{id}, #{value}]"
      @features.push(RPG::BaseItem::Feature.new(feature_code, id.to_i, value.to_f))
    }
  end
  
  #--------------------------------------------------------------------------
  # * Load element power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_element_power
    load_notetag_feature_arbitrary_power(Garryl::ExtraFeatures::Regex::ELEMENT_POWER, Game_BattlerBase::FEATURE_ELEMENT_POWER)
  end
  
  #--------------------------------------------------------------------------
  # * Load debuff power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_debuff_power
    load_notetag_feature_arbitrary_power(Garryl::ExtraFeatures::Regex::DEBUFF_POWER, Game_BattlerBase::FEATURE_DEBUFF_POWER)
  end
  
  #--------------------------------------------------------------------------
  # * Load state power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_state_power
    load_notetag_feature_arbitrary_power(Garryl::ExtraFeatures::Regex::STATE_POWER, Game_BattlerBase::FEATURE_STATE_POWER)
  end
  
  #--------------------------------------------------------------------------
  # * Load skill power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_skill_power
    load_notetag_feature_arbitrary_power(Garryl::ExtraFeatures::Regex::SKILL_POWER, Game_BattlerBase::FEATURE_SKILL_POWER)
  end
  
  #--------------------------------------------------------------------------
  # * Load item power notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_item_power
    load_notetag_feature_arbitrary_power(Garryl::ExtraFeatures::Regex::ITEM_POWER, Game_BattlerBase::FEATURE_ITEM_POWER)
  end
  
  #--------------------------------------------------------------------------
  # * Load param plus notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_param_plus
    #puts "#{self.note}"
    
    #User-friendly regexes
    Garryl::ExtraFeatures::Regex::PARAM_PLUS.each_with_index do |regex, key|
      self.note.scan(regex) do |value, blank|
        #puts "Captured [#{value}] for param #{key} plus in #{self.name}"
        @features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARAM_PLUS, key, value.to_i))
      end
    end
    
    #Manual entry regex
    self.note.scan(Garryl::ExtraFeatures::Regex::PARAM_PLUS_MANUAL) do |id, value|
      #puts "Captured [#{id}, #{value}] for manual param plus in #{self.name}"
      @features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARAM_PLUS, id.to_i, value.to_i))
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load dynamic feature notetags
  #--------------------------------------------------------------------------
  def load_notetag_feature_dynamic
    #puts "#{self.note}"
    
    #User-friendly regexes
#    Garryl::ExtraFeatures::Regex::PARAM_PLUS.each_with_index do |regex, key|
#      self.note.scan(regex) do |value, blank|
#        #puts "Captured [#{value}] for param #{key} plus in #{self.name}"
#        @features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARAM_PLUS, key, value.to_i))
#      end
#    end
    
    #Manual entry regex
    self.note.scan(Garryl::ExtraFeatures::Regex::DYNAMIC_FEATURE_MANUAL) do |code, id, value_script|
      #puts "Captured [#{code}, #{id}, #{value_script}] for manual dynamic feature in #{self.name}"
      @features.push(RPG::BaseItem::DynamicFeature.new(code.to_i, id.to_i, value_script))
    end
  end
  
end



module DataManager
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  class << self
    alias garryl_extra_features_alias_datamanager_load_database  load_database
  end
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    garryl_extra_features_alias_datamanager_load_database
    load_extra_features_notetags
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Loads the note tags into features
  #--------------------------------------------------------------------------
  def self.load_extra_features_notetags
    #puts "DEBUG: Loading extra feature notetags"
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors, $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        next if obj.note == ""
        #puts "DEBUG: Loading extra features for #{obj.name}"
        obj.load_notetag_extra_features
      end
    end
    #puts "DEBUG: Finished loading extra feature notetags"
  end
end
