#TODO: Basic testing complete. More thorough testing to do later.
#TODO: Test the change to state_addable to account for states that can be added while dead/escaped.
=begin
-------------------------------------------------------------------------------

Improved States
Version 1.0.2.4

Created: Apr. 2, 2015
Last update: Apr. 4, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script provides improved functionality for states, primarily defined
through note tags. This script is part of a project to revamp how states are
handled internally and what can be done with them.

This version is an initial release with type functionality for states. States
can be tagged with any number of types (represented by an integer ID number).
Most anything else can then be tagged with features and effects that work with
state types similarly to how existing features and effects can work with
individual states (see note tags, below). States can also be flagged not to be
removed on death/escape/recover all (ex: resting at an inn).

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

Features: These note tags apply to any game elements that support features
(actors, classes, weapons, armor, enemies, and states). Any number of them can
be applied to the same game element, even multiples of the same feature.

- State type rate: Modifies the chance for any state of a type to be applied to
  the battler with this feature, identified by the state type ID. State type
  rates are multiplicative with each other and with the state rate of the
  state itself.
- Valid Strings (case insensitive): <state type rate: StateTypeID# RateMultiplier >
  StateTypeID# is a non-zero, positive integer (ie: 1 or greater).
  RateMultiplier accepts both integers and floating point values, and can be
  either positive or negative.
  Any amount of white space is allowed around the numbers.
    Ex: <state type rate: 3 0.5 >   #Halves the chance for type 3 states to be
                                    #applied to the battler.

- State type resist: Total immunity to all states of a type, identified by the
  state type ID.
- Valid Strings (case insensitive): <state type resist: StateTypeID# >
  StateTypeID# is a non-zero, positive integer (ie: 1 or greater).
  Any amount of white space is allowed around the numbers.
  Ex: <state type resist: 1 >     #Makes the battler immune to type 1 states.

Effects: These note tags apply to any game elements that support effects
(items and skills). Any number of them can be applied to the same game element,
even multiples of the same effect.

- Remove state by type: Causes the skill or item to remove the first state that
  the target has of a specified type, identified by the state type ID.
- Valid Strings (case insensitive): <remove state type: StateTypeID# SuccessRate >
  StateTypeID# is a non-zero, positive integer (ie: 1 or greater).
  SuccessRate accepts both integers and floating point values, and must be
  a positive value.
  Any amount of white space is allowed around the numbers.
    Ex: <remove state type: 12 0.75 >   #Has a 75% chance to remove the first
                                        #type 12 state.

- Remove all states by type: Like remove state by type, but removes each state
  of that type, not just the first. Checks its success rate rindependently for
  each such state.
- Valid Strings (case insensitive): <remove all state type: StateTypeID# SuccessRate >
  StateTypeID# is a non-zero, positive integer (ie: 1 or greater).
  SuccessRate accepts both integers and floating point values, and must be
  a positive value.
  Any amount of white space is allowed around the numbers.
    Ex: <remove all state type: 7 0.3 > #Has a 30% chance to remove each
                                        #type 7 state from the target.

Other: These note tags apply to specific game elements. Any number of them  of
different types can be applied to the same game element, although whether or
not multiples of the same tag can apply depends on the tag in question.

- State type: Tags the state as being of a specific state type. State types are
  identified by the state type ID number, a positive integer. State types do
  nothing in and of themselves, but they allow other features and effects to
  indentify them and apply their effects.
- Valid Locations: State
- Valid Strings (case insensitive): <state type: StateTypeID# >
  StateTypeID# is a non-zero, positive integer (ie: 1 or greater).
  Any amount of white space is allowed around the numbers.
    Ex: <state type: 1 >   #Identifies this state as a type 1 state.

- Retention: Tags the state to not be removed when dying, when escaping, and/or
  when recovering with the recover_all function (triggered by from events like
  resting at an inn).
- Valid Locations: State
- Valid Strings (case insensitive):
  <retain on death>
  <retain on escape>
  <retain on recover all>

-------------------------------------------------------------------------------

Change Log:

v1.0.2.4
- Saturday, April 4, 2015
- Aliased Game_Battler.state_addable? to allow states that are retained while
  dead/hidden to also be added in those circumstances.
v1.0.2.3
- Friday, April 2, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Game_BattlerBase
- Game_Battler
- RPG::BaseItem
- RPG::UsableItem
- RPG::State
- DataManager

-------------------------------------------------------------------------------

Compatibility:

This script uses feature codes in the 367xxx range.
This script uses effect codes in the 367xxx range.

The following default script functions are overwritten:
- Game_BattlerBase.clear_states
- Game_BattlerBase.recover_all
- Game_Battler.clear_states
- Game_Battler.die
- Game_Battler.escape

The following default script functions are aliased:
- Game_BattlerBase.state_rate
- Game_BattlerBase.state_resist_set
- Game_Battler.state_addable?
- Game_Battler.item_effect_test
- Game_Battler.item_effect_apply
- RPG::State.initialize
- DataManager.load_database

The following functions are added to default script classes:
- Game_BattlerBase.state_type?
- Game_BattlerBase.states_by_type
- Game_BattlerBase.state_type_rate
- Game_BattlerBase.state_type_resist_set
- Game_BattlerBase.state_type_resist?
- Game_Battler.remove_state_by_type
- Game_Battler.item_effect_remove_state_type
- Game_Battler.item_effect_remove_all_state_type
- RPG::BaseItem.load_notetag_improved_states_features
- RPG::BaseItem.load_notetag_feature_state_type_rate
- RPG::BaseItem.load_notetag_feature_state_type_resist
- RPG::UsableItem.load_notetag_improved_states_effects
- RPG::UsableItem.load_notetag_effect_remove_state_type
- RPG::UsableItem.load_notetag_effect_remove_all_state_type
- RPG::State.load_notetag_improved_states_state_types
- RPG::State.load_notetag_state_type
- RPG::State.load_notetag_retention
- DataManager.load_improved_states_notetags

-------------------------------------------------------------------------------
=end

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Improved States"] ||= {}
$imported["Garryl"]["Improved States"]["Version"] = "1.0.2.3"
$imported["Garryl"]["Improved States"]["State Types"] = true
$imported["Garryl"]["Improved States"]["Retention"] = true

module Garryl
  module ImprovedStates
    module BattlerBase
      #--------------------------------------------------------------------------
      # * Constants (Features)
      #--------------------------------------------------------------------------
      FEATURE_STATE_TYPE_RATE    = 367113          # State Type Rate
      FEATURE_STATE_TYPE_RESIST  = 367114          # State Type Resist
    end
    
    module Battler
      #----------------------------------------------------------------------
      # * Constants (Effects)
      #----------------------------------------------------------------------
      EFFECT_REMOVE_STATE_TYPE   = 367122          # Remove State Type
      EFFECT_REMOVE_ALL_STATE_TYPE = 367123        # Remove All State Type
    end
    
    module Regex
      #base items (actor, class, weapon, armor, enemy, state)
      FEATURE_STATE_TYPE_RATE   = /<state type rate:\s*([1-9][0-9]*)\s*([\-\+]?[0-9]*(\.[0-9]+)?)\s*>/i
      FEATURE_STATE_TYPE_RESIST = /<state type resist:\s*([1-9][0-9]*)\s*>/i
      
      #usable items (skill, item)
      EFFECT_REMOVE_STATE_TYPE  = /<remove state type:\s*([1-9][0-9]*)\s*([\+]?[0-9]*(\.[0-9]+)?)\s*>/i
                                                        #state type ID, chance to remove (positive fraction)
      EFFECT_REMOVE_ALL_STATE_TYPE  = /<remove all state type:\s*([1-9][0-9]*)\s*([\+]?[0-9]*(\.[0-9]+)?)\s*>/i
                                                        #state type ID, chance to remove (positive fraction)
      
      #states
      STATE_TYPE                = /<state type:\s*([1-9][0-9]*)\s*>/i
      RETAIN_ON_DIE             = /<retain on death>/i
      RETAIN_ON_ESCAPE          = /<retain on escape>/i
      RETAIN_ON_RECOVER_ALL     = /<retain on recover all>/i
    end
  end
end  


class Game_BattlerBase
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_improved_states_alias_battlerbase_state_rate     state_rate
  alias garryl_improved_states_alias_battlerbase_state_resist_set   state_resist_set
#  alias garryl_improved_states_alias_battlerbase_state_resist?  state_resist?
  
  # *************************************************************************
  # * Constants                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Constants (Features)
  #--------------------------------------------------------------------------
  FEATURE_STATE_TYPE_RATE   = Garryl::ImprovedStates::BattlerBase::FEATURE_STATE_TYPE_RATE
  FEATURE_STATE_TYPE_RESIST = Garryl::ImprovedStates::BattlerBase::FEATURE_STATE_TYPE_RESIST
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get State Rate
  # * Includes rates of all state types
  #--------------------------------------------------------------------------
  def state_rate(state_id)
    rate = garryl_improved_states_alias_battlerbase_state_rate(state_id);
    $data_states[state_id].state_types.each do |type_id|
      rate *= state_type_rate(type_id)
    end
    return rate
  end
  
  #--------------------------------------------------------------------------
  # * Get Array of States to Resist
  # * Includes resistance to all state types
  #--------------------------------------------------------------------------
  def state_resist_set
    #features_set(FEATURE_STATE_RESIST)
    resist_set = garryl_improved_states_alias_battlerbase_state_resist_set
    
    #Determine if any state are resisted by type
    type_resist_set = state_type_resist_set
    $data_states.each do |state|
      if (!state.nil? && !state.state_types.nil?)
        state.state_types.each do |type_id|
          if (type_resist_set.include?(type_id))
            resist_set.push(state.id)
          end
        end
      end
    end
    
    return resist_set.uniq
  end
  
#  #--------------------------------------------------------------------------
#  # * Determine if State Is Resisted
#  # * Includes resistance to all state types
#  #--------------------------------------------------------------------------
#  def state_resist?(state_id)
#    #Check if this specific state is resisted
#    resist = garryl_improved_states_alias_battlerbase_state_resist?(state_id)
#    
#    #Determine if any of the state's types are resisted
#    resist_set = state_type_resist_set
#    $data_states[state_id].state_types.each do |type_id|
#      resist = resist || resist_set.include?(type_id)
#    end
#    
#    return resist
#  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clear_states(recovering = false, dying = false, escaping = false)
    if (recovering)
      @states.each do |state_id|
        erase_state(state_id) unless $data_states[state_id].retain_on_recover_all
      end
    elsif (dying)
      @states.each do |state_id|
        erase_state(state_id) unless $data_states[state_id].retain_on_die
      end
    elsif (escaping)
      @states.each do |state_id|
        erase_state(state_id) unless $data_states[state_id].retain_on_escape
      end
    else
      @states = []
      @state_turns = {}
      @state_steps = {}
    end
  end
  
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    clear_states(true)
    @hp = mhp
    @mp = mmp
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Check if has any states of the state type
  #--------------------------------------------------------------------------
  def state_type?(state_type_id)
    has_state_type = false
    states.each do |state|
      has_state_type = has_state_type || state.state_types.include?(state_type_id)
    end
    return has_state_type
  end
  
  #--------------------------------------------------------------------------
  # * Get Current States with the indicated type as an Object Array
  #--------------------------------------------------------------------------
  def states_by_type(state_type_id)
    states_of_type = []
    states.each do |state|
      states_of_type.push(state) if state.state_types.include?(state_type_id)
    end
    return states_of_type
  end
  
  #--------------------------------------------------------------------------
  # * Get State Type Rate
  #--------------------------------------------------------------------------
  def state_type_rate(state_type_id)
    features_pi(FEATURE_STATE_TYPE_RATE, state_type_id)
  end
  
  #--------------------------------------------------------------------------
  # * Get Array of State Types to Resist
  #--------------------------------------------------------------------------
  def state_type_resist_set
    features_set(FEATURE_STATE_TYPE_RESIST)
  end
  
  #--------------------------------------------------------------------------
  # * Determine if State Type Is Resisted
  #--------------------------------------------------------------------------
  def state_type_resist?(state_type_id)
    state_type_resist_set.include?(state_type_id)
  end
  
end


class Game_Battler < Game_BattlerBase
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_improved_states_alias_battler_state_addable?     state_addable?
  alias garryl_improved_states_alias_battler_item_effect_test   item_effect_test
  alias garryl_improved_states_alias_battler_item_effect_apply  item_effect_apply
  
  # *************************************************************************
  # * Constants                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Constants (Effects)
  #--------------------------------------------------------------------------
  EFFECT_REMOVE_STATE_TYPE  = Garryl::ImprovedStates::Battler::EFFECT_REMOVE_STATE_TYPE
  EFFECT_REMOVE_ALL_STATE_TYPE = Garryl::ImprovedStates::Battler::EFFECT_REMOVE_ALL_STATE_TYPE
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Determine if States Are Addable
  #--------------------------------------------------------------------------
  def state_addable?(state_id)
    #alive? && $data_states[state_id] && !state_resist?(state_id) &&
    #  !state_removed?(state_id) && !state_restrict?(state_id)
    addable = garryl_improved_states_alias_battler_state_addable?(state_id)
    return addable if addable
    
    #confirm it's a valid state
    state = $data_states[state_id]
    return false if state.nil?
    
    #check for hidden/retain on escape
    #check for dead/retain on die
    addable = true
    addable = addable && (!death_state? || state.reatin_on_die)
    addable = addable && (!hidden? || state.retain_on_escape)
    addable = addable && !state_resist?(state_id) && !state_removed?(state_id) && !state_restrict?(state_id)
    
    return addable
  end
  
  #--------------------------------------------------------------------------
  # * Test Effect
  #--------------------------------------------------------------------------
  def item_effect_test(user, item, effect)
    case effect.code
    when EFFECT_REMOVE_STATE_TYPE
      return state_type?(effect.data_id)
    when EFFECT_REMOVE_ALL_STATE_TYPE
      return state_type?(effect.data_id)
    else
      return garryl_improved_states_alias_battler_item_effect_test(user, item, effect)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Apply Effect
  #--------------------------------------------------------------------------
  def item_effect_apply(user, item, effect)
    case effect.code
    when EFFECT_REMOVE_STATE_TYPE
      item_effect_remove_state_type(user, item, effect)
    when EFFECT_REMOVE_ALL_STATE_TYPE
      item_effect_remove_all_state_type(user, item, effect)
    else
      garryl_improved_states_alias_battler_item_effect_apply(user, item, effect)
    end
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clear_states(recovering = false, dying = false, escaping = false)
    super(recovering, dying, escaping)
    @result.clear_status_effects
  end
  
  #--------------------------------------------------------------------------
  # * Knock Out
  #--------------------------------------------------------------------------
  def die
    @hp = 0
    clear_states(false, true)
    clear_buffs
  end
  
  #--------------------------------------------------------------------------
  # * Escape
  #--------------------------------------------------------------------------
  def escape
    hide if $game_party.in_battle
    clear_actions(false, false, true)
    clear_states
    Sound.play_escape
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Remove State by Type
  #--------------------------------------------------------------------------
  def remove_state_by_type(state_type_id)
    if state_type?(state_type_id)
      states_of_type = states_by_type(state_type_id)
      remove_state(states_of_type.first.id) unless states_of_type.empty?
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Remove State Type] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_state_type(user, item, effect)
    chance = effect.value1
    if rand < chance
      remove_state_by_type(effect.data_id)
      @result.success = true
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Remove ALL State Type] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_all_state_type(user, item, effect)
    chance = effect.value1
    states_by_type(effect.data_id).each do |state|
      if rand < chance
        remove_state(state.id)
        @result.success = true
      end
    end
  end
  
end


class RPG::BaseItem
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load improved states features notetags
  #--------------------------------------------------------------------------
  def load_notetag_improved_states_features
    load_notetag_feature_state_type_rate
    load_notetag_feature_state_type_resist
  end
  
  #--------------------------------------------------------------------------
  # * Load features notetags - state type rate
  #--------------------------------------------------------------------------
  def load_notetag_feature_state_type_rate
    #puts "#{self.note}"
    self.note.scan(Garryl::ImprovedStates::Regex::FEATURE_STATE_TYPE_RATE) do |id, value|
      #puts "Captured [#{id}, #{value}]"
      @features.push(RPG::BaseItem::Feature.new(Garryl::ImprovedStates::BattlerBase::FEATURE_STATE_TYPE_RATE, id.to_i, value.to_f))
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load features notetags - state type resist
  #--------------------------------------------------------------------------
  def load_notetag_feature_state_type_resist
    #puts "#{self.note}"
    #self.note.scan(Garryl::ImprovedStates::Regex::FEATURE_STATE_TYPE_RESIST) do |id|
    self.note.scan(Garryl::ImprovedStates::Regex::FEATURE_STATE_TYPE_RESIST) do |id, blank|
      #See notetag loading for state type for how scan can mess up and return
      #an array when you ask only for one capture
      #puts "Captured [#{id}]"
      @features.push(RPG::BaseItem::Feature.new(Garryl::ImprovedStates::BattlerBase::FEATURE_STATE_TYPE_RESIST, id.to_i))
    end
  end
  
end


class RPG::UsableItem < RPG::BaseItem
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load improved states effects notetags
  #--------------------------------------------------------------------------
  def load_notetag_improved_states_effects
    load_notetag_effect_remove_state_type
    load_notetag_effect_remove_all_state_type
  end
  
  #--------------------------------------------------------------------------
  # * Load effect notetags - remove state type
  #--------------------------------------------------------------------------
  def load_notetag_effect_remove_state_type
    #puts "#{self.note}"
    self.note.scan(Garryl::ImprovedStates::Regex::EFFECT_REMOVE_STATE_TYPE) do |id, value|
      #puts "Captured [#{id}, #{value}]"
      @effects.push(RPG::UsableItem::Effect.new(Garryl::ImprovedStates::Battler::EFFECT_REMOVE_STATE_TYPE, id.to_i, value.to_f))
    end
  end
  
  #--------------------------------------------------------------------------
  # * Load effect notetags - remove all states by type
  #--------------------------------------------------------------------------
  def load_notetag_effect_remove_all_state_type
    #puts "#{self.note}"
    self.note.scan(Garryl::ImprovedStates::Regex::EFFECT_REMOVE_ALL_STATE_TYPE) do |id, value|
      #puts "Captured [#{id}, #{value}]"
      @effects.push(RPG::UsableItem::Effect.new(Garryl::ImprovedStates::Battler::EFFECT_REMOVE_ALL_STATE_TYPE, id.to_i, value.to_f))
    end
  end
  
end


class RPG::State < RPG::BaseItem
  alias garryl_improved_states_alias_rpg_state_initialize initialize
  
  def initialize
    garryl_improved_states_alias_rpg_state_initialize
    @state_types = []
    @retain_on_die          = false
    @retain_on_escape       = false
    @retain_on_recover_all  = false
  end
  
  attr_reader   :state_types
  attr_reader   :retain_on_die
  attr_reader   :retain_on_escape
  attr_reader   :retain_on_recover_all
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load improved states state types notetags
  #--------------------------------------------------------------------------
  def load_notetag_improved_states_state_types
    load_notetag_state_type
    load_notetag_state_retention
  end
  
  #--------------------------------------------------------------------------
  # * Load notetags - state types
  #--------------------------------------------------------------------------
  def load_notetag_state_type
    #puts "#{self.note}"
    @state_types = []     #This shouldn't be necessary, I think, as the state's initialize should be called first, no?
                          #Unless the data_load just unmarshals data, in which case it would load an object already initialized as an older version of the class.
    #self.note.scan(Garryl::ImprovedStates::Regex::STATE_TYPE) do |id|
    self.note.scan(Garryl::ImprovedStates::Regex::STATE_TYPE) do |id, blank|  #checking only one capture nets the whole array for some stupid reason
      #puts "Captured [#{id}]"
      @state_types.push(id.to_i)
    end
    @state_types.uniq!    #removes duplicates
    @state_types.sort!    #places in order
  end
  
  #--------------------------------------------------------------------------
  # * Load notetags - retention
  #--------------------------------------------------------------------------
  def load_notetag_state_retention
    #puts "#{self.note}"
    @retain_on_die = (self.note =~ Garryl::ImprovedStates::Regex::RETAIN_ON_DIE ? true : false)
    @retain_on_escape = (self.note =~ Garryl::ImprovedStates::Regex::RETAIN_ON_ESCAPE ? true : false)
    @retain_on_recover_all = (self.note =~ Garryl::ImprovedStates::Regex::RETAIN_ON_RECOVER_ALL ? true : false)
  end
  
end


module DataManager
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  class << self
    alias garryl_improved_states_alias_datamanager_load_database    load_database
  end
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    garryl_improved_states_alias_datamanager_load_database
    load_improved_states_notetags
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Loads the note tags
  #--------------------------------------------------------------------------
  def self.load_improved_states_notetags
    #puts "DEBUG: Loading improved states notetags"
    #puts "DEBUG: Loading base item features"
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors, $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        next if obj.note == ""
        #puts "DEBUG: Loading for #{obj.name}"
        obj.load_notetag_improved_states_features
      end
    end
    #puts "DEBUG: Loading usable item effects"
    groups = [$data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        next if obj.note == ""
        #puts "DEBUG: Loading for #{obj.name}"
        obj.load_notetag_improved_states_effects
      end
    end
    #puts "DEBUG: Loading state types"
    groups = [$data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        next if obj.note == ""
        #puts "DEBUG: Loading for #{obj.name}"
        obj.load_notetag_improved_states_state_types
      end
    end
    #puts "DEBUG: Finished loading improved states notetags"
  end
end
