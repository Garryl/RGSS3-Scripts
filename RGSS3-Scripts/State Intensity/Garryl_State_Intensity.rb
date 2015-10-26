=begin
-------------------------------------------------------------------------------

State Intensity
Version 1.0

Created: Oct. 9, 2015
Last update: Oct. 9, 2015

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

Usage Instructions:

Scripts can get and set state intensity with the Game_BattlerBase.state_intensity
and Game_BattlerBase.set_state_intensity methods.

Additionally, the unused value2 field of [Add State] Effects (effect code 21),
for both normal attacks (data ID 0) and specific states (data ID = state ID),
has been made to set the state intensity of any states the effects successfully
apply. You'll need another script to create effects with value2 set, however.

This script is designed to be used with my Dynamic Features and Dynamic Effects
scripts, both of which can be found at https://github.com/Garryl/RGSS3-Scripts.
With dynamic features, states can reference the intensity with which they are
applied can can provide greater or lesser effect accordingly. With dynamic
effects, skills and items can apply states with varying intensity levels.

-------------------------------------------------------------------------------

Change Log:

v1.0
- Friday, October 9, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Game_BattlerBase
- Game_Battler

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- Game_Battler.item_effect_add_state_attack
- Game_Battler.item_effect_add_state_normal

The following default script functions are aliased:
- Game_BattlerBase.clear_states
- Game_BattlerBase.erase_state
- Game_Battler.add_state

The following functions are added to default script classes:
- Game_BattlerBase.state_intensity
- Game_BattlerBase.set_state_intensity

-------------------------------------------------------------------------------
=end

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["StateIntensity"] ||= {}
$imported["Garryl"]["StateIntensity"]["Version"] = "1.0"

  
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
#    @states = []
#    @state_turns = {}
#    @state_steps = {}
    @state_intensities = {}
  end
  
  #--------------------------------------------------------------------------
  # * Erase States
  #--------------------------------------------------------------------------
  def erase_state(state_id)
    garryl_state_intensity_alias_game_battlerbase_erase_state(state_id)
#    @states.delete(state_id)
#    @state_turns.delete(state_id)
#    @state_steps.delete(state_id)
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
    return (state?(state_id) ? @state_intensities[state_id] : 0)
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
#      state = $data_states[state_id]
#      @state_intensities[state_id] = intensity unless @state_intensities.has_key?(state_id) && @state_intensities[state_id] >= intensity
      set_state_intensity(state_id, intensity) unless state_intensity(state_id) >= intensity 
    end
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal Attack
  # * Uses effect.value2 for state intensity
  #--------------------------------------------------------------------------
  def item_effect_add_state_attack(user, item, effect)
    user.atk_states.each do |state_id|
      chance = effect.value1
      chance *= state_rate(state_id)
      chance *= user.atk_states_rate(state_id)
      chance *= luk_effect_rate(user)
      if rand < chance
        add_state(state_id, effect.value2)  #Uses effect.value2 for intensity
        @result.success = true
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal
  # * Uses effect.value2 for state intensity
  #--------------------------------------------------------------------------
  def item_effect_add_state_normal(user, item, effect)
    chance = effect.value1
    chance *= state_rate(effect.data_id) if opposite?(user)
    chance *= luk_effect_rate(user)      if opposite?(user)
    if rand < chance
      add_state(effect.data_id, effect.value2)  #Uses effect.value2 for intensity
      @result.success = true
    end
  end
  
end

