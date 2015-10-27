=begin
-------------------------------------------------------------------------------

State Intensity
Version 1.1

Created: Oct. 26, 2015
Last update: Oct. 26, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script allows for battlers to have states with varying "intensity" values.
This is meant to be combined with other scripts, such as my Dynamic Features
and Dynamic Effects scripts, to create states that are more or less powerful
depending on how they are applied.

-------------------------------------------------------------------------------

License:

Free to use and modify for both commercial and non-commercial. Just don't
claim it as your own. If you've got credits anywhere, give me credit. If not,
don't worry about it. 

-------------------------------------------------------------------------------

Installation:

Copy into a new script slot in the Materials section.

-------------------------------------------------------------------------------

Dependencies:

This script requires the Garryl Loader script v1.1, available at
https://github.com/Garryl/RGSS3-Scripts/tree/master/RGSS3-Scripts/Loader

-------------------------------------------------------------------------------

Usage Instructions:

Scripts can get and set state intensity with the Game_BattlerBase.state_intensity
and Game_BattlerBase.set_state_intensity methods.

When applied via normal attacks, states are applied at their default intensity,
as defined by a formula set by a note tag (default 0 if not present).

Additionally, the unused value2 field of [Add State] Effects (effect code 21),
for both normal attacks (data ID 0) and specific states (data ID = state ID),
has been made to set the state intensity of any states the effects successfully
apply. This can be used by the Add State with Intensity effect note tag.

If a state is re-applied, the new intensity is determined based on the
state-specific setting set by a note tag. If the tag is not present, it uses
the default stacking setting (see settings, below).

This script is designed to be used with my Dynamic Features and Dynamic Effects
scripts, both of which can be found at https://github.com/Garryl/RGSS3-Scripts.
With dynamic features, states can reference the intensity with which they are
applied can can provide greater or lesser effect accordingly. With dynamic
effects, skills and items can apply states with varying intensity levels.

Note: States applied through events and other unusual methods have an intensity
of 0. If you want an event (or something else) to apply a state with intensity,
you can set it to a specific value with a script call to
{battler}.set_state_intensity(state_id, intensity) after it is applied.

-------------------------------------------------------------------------------

Settings:

Settings can be changed in the script below. All settings are in the
Garryl::StateIntensity::Settings module.

The default intensity stacking type, used by states that lack the note tag
setting it explicitly, can be changed. Available options are...
  Stacking::ADDITIVE - Old and new intensities are added together.
  Stacking::NEWEST - New intensity is used, old intensity is discarded.
  Stacking::STRONGEST - The higher of the old and new intensities is used.

-------------------------------------------------------------------------------

Note Tags:

The following note tags are supported. Additional functionality can be
gained by putting the indicated text in the "Note" field of states.

Effects:
- Add State with Intensity:   <effect add state with intensity: STATE_ID, APPLICATION_RATE, INTENSITY>
  - Causes the skill or item to add a state with a specified intensity.

Normal Attack Intensity: Defines a formula to be evaluated that determines
state intensity when added via a normal attack. The value is calculated by a
script call, evaluating the formula you provide just like a skill or item
damage formulas. Like the formula box, the entirety of a value script must be
one one line. Use semicolons (';') to split apart lines of Ruby script. This
note tag is optional. If not present, normal attack intensity defaults to 0.
- INTENSITY_FORMULA is the Ruby script that will be evaluated when checking the
  state intensity's value. You can use the following variables in your script.
  a: The battler whose attack inflicted the state
  b: The battler receiving the state
  i: The skill or item that is the source of the state
  s: The state being added
  v: $game_variables
- INTENSITY_FORMULA may, optionally, be on a separate line from the rest of the
  note tag. The formula itself may not have any line breaks within it.
- Valid Locations: State
- Valid Strings (case insensitive):
  <state intensity normal attack> INTENSITY_FORMULA </state intensity>
  Ex: <state intensity normal attack>[a.mat - b.mdf, 0].max</state intensity>
  Ex: <state intensity normal attack>
        [a.mat - b.mdf, 0].max
      </state intensity>

Intensity Stacking Type: Designates which type of intensity stacking this state
uses if the state is applied while already present on the target battler.
Options are "add" or "additive" (old and new intensities are added together),
"new" or "newest" (new intensity is used, old intensity is discarded), and
"strong" or "strongest" (the higher of the old and new intensities is used).
This note tag is optional. If not present, normal attack intensity defaults to 0.
- Valid Locations: State
- Valid Strings (case insensitive):
  <state intensity stacking: add/additive/new/newest/strong/strongest>

-------------------------------------------------------------------------------

Change Log:

v1.1
- Friday, October 26, 2015
- Added note tag for add state with intensity effect.
v1.0
- Friday, October 26, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Game_BattlerBase
- Game_Battler
- RPG::State

-------------------------------------------------------------------------------

Compatibility:

This script defines the following new classes
- RPG::State::ApplicationIntensity

The following default script functions are overwritten:
- Game_Battler.item_effect_add_state_attack
- Game_Battler.item_effect_add_state_normal

The following default script functions are aliased:
- Game_BattlerBase.clear_states
- Game_BattlerBase.erase_state
- Game_Battler.add_state
- RPG::State.initialize

The following functions are added to default script classes:
- Game_BattlerBase.state_intensity
- Game_BattlerBase.set_state_intensity
- Game_Battler.atk_state_intensity
- Game_Battler.make_atk_state_intensity
- Game_Battler.make_state_intensity
- RPG::State.notetag_init_atk_intensity
- RPG::State.notetag_init_stacking_intensity
- RPG::State.notetag_init_classify_stacking_intensity

-------------------------------------------------------------------------------
=end


#Import requirements check
unless ($imported["Garryl"] && $imported["Garryl"]["Loader"] && $imported["Garryl"]["Loader"]["Version"] >= "1.1")
  puts "Error! Garryl Loader module v1.1 or higher not imported. Required for Garryl State Intensity."
  puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  puts "If Loader script is already included among your materials, please ensure that this script (file: #{__FILE__}) comes after it."
else
  
# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["StateIntensity"] ||= {}
$imported["Garryl"]["StateIntensity"]["Version"] = "1.1"


module Garryl
  module StateIntensity
    module Stacking
      #Different available intensity stacking types
      ADDITIVE  = :add
      NEWEST    = :new
      STRONGEST = :strong
    end
    
    module Settings
      # ***********************************************************************
      # * Settings                                                            *
      # ***********************************************************************
      # * You can modify the variables here to fine tune your game.           *
      # ***********************************************************************
      
      #------------------------------------------------------------------------
      # * Default State Intensity Stacking Type
      #------------------------------------------------------------------------
      #This will be used when not explicitly set in a state's note tags
      DEFAULT_STACKING_TYPE = Stacking::NEWEST
      
      # ***********************************************************************
      # * End of Settings                                                     *
      # ***********************************************************************
    end
  end
  
  module Loader
    # ***********************************************************************
    # * Note Tags                                                           *
    # ***********************************************************************
    # * This script registers note tags for all of the new features and     *
    # * effects it provides.                                                *
    # ***********************************************************************
    #------------------------------------------------------------------------
    # * Initializers
    #------------------------------------------------------------------------
    register(CustomInitializer.new(
        RegexConf.new(/<\s*state\s+intensity\s+normal\s+attack\s*>\s*(.*)\s*<\s*\/state\s+intensity\s*>/i, RegexConf::CAPTURE_STRING),
        LoadGroup.new(LoadGroup::STATES),
        :notetag_init_atk_intensity)
    )   # State intensity when applied via normal attack
    
    register(CustomInitializer.new(
        RegexConf.new(/<\s*state\s+intensity\s+stacking\s*:\s+(add(?:itive)?|new(?:est)?|strong(?:est)?)\s*>/i, RegexConf::CAPTURE_STRING),
        LoadGroup.new(LoadGroup::STATES),
        :notetag_init_stacking_intensity)
    )   # State intensity used when state is re-applied
    
    #--------------------------------------------------------------------------
    # * Effects
    #--------------------------------------------------------------------------
    register(LoadEffect.new(RegexConf.new(/<\s*effect\s+add\s+state\s+with\s+intensity\s*:\s*([0-9]+)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_ADD_STATE))          # Add State with Intensity

  end

end



class Game_BattlerBase
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_state_intensity_alias_game_battlerbase_clear_states   clear_states
  alias garryl_state_intensity_alias_game_battlerbase_erase_state    erase_state
  
  # *************************************************************************
  # * Constants                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Constants (Features)
  #--------------------------------------------------------------------------
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clear_states
    garryl_state_intensity_alias_game_battlerbase_clear_states
    @state_intensities = {}
  end
  
  #--------------------------------------------------------------------------
  # * Erase States
  #--------------------------------------------------------------------------
  def erase_state(state_id)
    garryl_state_intensity_alias_game_battlerbase_erase_state(state_id)
    @state_intensities.delete(state_id)
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get State Intensity
  # * Returns the state's intensity, or 0 if state is not present
  #--------------------------------------------------------------------------
  def state_intensity(state_id)
    #return (state?(state_id) ? @state_intensities[state_id] : 0)
    #Small moment between when the state is added and when intensity is set
    #that state? is true but state_intensities still has nil
    return ((state?(state_id) && @state_intensities[state_id]) ? @state_intensities[state_id] : 0)
  end
  
  #--------------------------------------------------------------------------
  # * Set State Intensity
  # * Sets the intensity of a state only if it is present
  #--------------------------------------------------------------------------
  def set_state_intensity(state_id, intensity)
    @state_intensities[state_id] = intensity if state?(state_id)
  end
  
end


class Game_Battler < Game_BattlerBase
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_state_intensity_alias_game_battler_add_state   add_state
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Add State
  # * Sets intensity it state was addable
  # * Stacks or replaces intensity according to state's settings
  #--------------------------------------------------------------------------
  def add_state(state_id, intensity = 0)
    addable = state_addable?(state_id)  #check addability before it gets added
    
    garryl_state_intensity_alias_game_battler_add_state(state_id)
#    if state_addable?(state_id)
#      add_new_state(state_id) unless state?(state_id)
#      reset_state_counts(state_id)
#      @result.added_states.push(state_id).uniq!
#    end
    
    #If the state was added successfully, apply the intensity, too
    #If the state was already present, use the higher intensity value
    if addable && state?(state_id)
#      set_state_intensity(state_id, intensity) unless state_intensity(state_id) >= intensity
      set_state_intensity(state_id, $data_states[state_id].stack_intensity(state_intensity(state_id), intensity)) 
    end
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal Attack
  # * Uses state's attack state intensity for state intensity
  #--------------------------------------------------------------------------
  def item_effect_add_state_attack(user, item, effect)
    user.atk_states.each do |state_id|
      chance = effect.value1
      chance *= state_rate(state_id)
      chance *= user.atk_states_rate(state_id)
      chance *= luk_effect_rate(user)
      if rand < chance
#        add_state(state_id)
        add_state(state_id, atk_state_intensity(state_id, user, item))  #Calculates intensity
        @result.success = true
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal
  # * Uses the normally-unused effect.value2 for state intensity
  #--------------------------------------------------------------------------
  def item_effect_add_state_normal(user, item, effect)
    chance = effect.value1
    chance *= state_rate(effect.data_id) if opposite?(user)
    chance *= luk_effect_rate(user)      if opposite?(user)
    if rand < chance
#        add_state(state_id)
      #Uses effect.value2 for intensity
      #add_state(effect.data_id, effect.value2)
      state_id = effect.data_id
      intensity = ($data_states[state_id] ? make_state_intensity(effect.value2, user, item, $data_states[state_id]) : 0)
      add_state(state_id, intensity)
      @result.success = true
    end
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * State Application Intensity on Attack 
  # * Returns the intensity at which the state is applied on a normal attack.
  # * Actual calculations done in make_atk_state_intensity(), this just
  #   confirms the state ID is valid ($data_states[state_id] has a state and
  #   isn't nil) and passes the actual state to it, rather than the ID.
  #--------------------------------------------------------------------------
  def atk_state_intensity(state_id, user, item)
    intensity = ($data_states[state_id] ? make_atk_state_intensity(user, item, $data_states[state_id]) : 0)
    return intensity
  end
  
  #--------------------------------------------------------------------------
  # * Calculates State Application Intensity on Attack
  # * Evaluates the formula and performs the actual calculations for the
  #   final intensity the state will be added at when applied on attack.
  #--------------------------------------------------------------------------
  def make_atk_state_intensity(user, item, state)
    intensity = state.atk_intensity.eval(user, self, item, state, $game_variables)
    return make_state_intensity(intensity, user, item, state)
  end
  
  #--------------------------------------------------------------------------
  # * Perform Adjustments to State Application Intensity
  # * Performs calculations and adjustments to the intensity the state will
  #   be added at.
  #--------------------------------------------------------------------------
  def make_state_intensity(intensity, user, item, state)
    #intensity *= item_element_rate(user, item) if state.atk_intensity.apply_item_element_rate?
    #intensity *= pdr if state.atk_intensity.physical?
    #intensity *= mdr if state.atk_intensity.magical?
    #intensity *= rec if state.atk_intensity.recover?
    #intensity = apply_critical(intensity) if @result.critical && state.atk_intensity.apply_critical?
    #intensity = apply_variance(intensity, (state.atk_intensity.use_item_variance? ? item.damage.variance : state.atk_intensity.variance)) if state.atk_intensity.apply_variance?
    #intensity = apply_guard(intensity) if state.atk_intensity.apply_guard?
    return intensity
  end
  
end


class RPG::State < RPG::BaseItem
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_state_intensity_alias_rpg_state_initialize   initialize
  
  # *************************************************************************
  # * New Accessors                                                         *
  # *************************************************************************
  attr_accessor :atk_intensity
  attr_accessor :stacking_intensity

  # *************************************************************************
  # * Constants                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Stacking
  #--------------------------------------------------------------------------
  STACKING_INTENSITY_ADDITIVE   = Garryl::StateIntensity::Stacking::ADDITIVE
  STACKING_INTENSITY_NEWEST     = Garryl::StateIntensity::Stacking::NEWEST
  STACKING_INTENSITY_STRONGEST  = Garryl::StateIntensity::Stacking::STRONGEST
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    garryl_state_intensity_alias_rpg_state_initialize
    @atk_intensity = RPG::State::ApplicationIntensity.new
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Initializes attack intensity from note tag loading
  #--------------------------------------------------------------------------
  def notetag_init_atk_intensity(capture)
    @atk_intensity = RPG::State::ApplicationIntensity.new
    @atk_intensity.formula = capture[0] unless capture.nil?
  end
  
  #--------------------------------------------------------------------------
  # * Initializes intensity stacking type from note tag loading
  #--------------------------------------------------------------------------
  def notetag_init_stacking_intensity(capture)
    if (capture.nil?)
      @stacking_intensity = Garryl::StateIntensity::Settings::DEFAULT_STACKING_TYPE
    else
      @stacking_intensity = notetag_init_classify_stacking_intensity(capture)
    end
#    @stacking_intensity = (capture.nil? ? Garryl::StateIntensity::Settings::DEFAULT_STACKING_TYPE : notetag_init_stacking_intensity_classify(capture)) 
  end
  
  #--------------------------------------------------------------------------
  # * Translates the capture block to an intensity type
  #--------------------------------------------------------------------------
  def notetag_init_classify_stacking_intensity(capture)
    case capture[0]
      #/<\s*state\s+intensity\s+stacking\s*:\s+(add(?:itive)?|new(?:est)?|strong(?:est)?)\s*>/i
    when /add(?:itive)?/i
      return STACKING_INTENSITY_ADDITIVE
    when /new(?:est)?/i
      return STACKING_INTENSITY_NEWEST
    when /strong(?:est)?/i
      return STACKING_INTENSITY_STRONGEST
    else
      return Garryl::StateIntensity::Settings::DEFAULT_STACKING_TYPE
    end
  end
  
  #--------------------------------------------------------------------------
  # * Stacks intensity according to the stacking rules
  # * Returns the value intensity should be set to
  # * If stacking is somehow set to a bad value, uses the new intensity only
  #--------------------------------------------------------------------------
  def stack_intensity(old_intensity, new_intensity, stacking_type = @stacking_intensity)
    case stacking_type
    when STACKING_INTENSITY_ADDITIVE
      return old_intensity + new_intensity
    when STACKING_INTENSITY_NEWEST
      return new_intensity
    when STACKING_INTENSITY_STRONGEST
      return [old_intensity, new_intensity].max
    else
      return new_intensity
    end
  end
  

end


#Defines the intensity of a state when applied through a normal attack
class RPG::State::ApplicationIntensity
  
  # *************************************************************************
  # * Accessors                                                             *
  # *************************************************************************
  attr_accessor :formula
  
  # *************************************************************************
  # * Functions                                                             *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(formula = '0')
    @formula = formula      #Formula to be evaluated
  end
  
  #--------------------------------------------------------------------------
  # * Evaluates the value script
  # * a: Battler inflicting the state
  # * b: Battler receiving the state
  # * i: Skill or item that is the source of the state
  # * s: The state being added
  # * v: $game_variables
  #--------------------------------------------------------------------------
  def eval(a, b, i, s, v = $game_variables)
    return Kernel.eval(@formula) rescue 0
  end
  
end

end #Import requirements check
