=begin
-------------------------------------------------------------------------------

Dynamic Effects
Version 1.0

Created: Oct. 9, 2015
Last update: Oct. 9, 2015

Author: Garryl

Source: https://github.com/Garryl/RGSS3-Scripts

-------------------------------------------------------------------------------

Description:

This script allows for effects with variable values, or "dynamic effects",
which are calculated on the fly from formulas you can provide.
Dynamic effects are defined through note tags. Any normal game object that can
have effects (skills and usable items) supports these effects.
See the Note Tags section for more details.

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

This script requires the Garryl Loader script, available at
https://github.com/Garryl/RGSS3-Scripts/tree/master/RGSS3-Scripts/Loader

-------------------------------------------------------------------------------

Usage Instructions:

This script supports and requires note tags. See below for more information.

-------------------------------------------------------------------------------

Note Tags:

The following note tags are supported. Additional functionality can be
gained by putting the indicated text in the "Note" field of effect-bearing
items (skills, usable items).

Dynamic Effects: These effects work just like normal effects, except that
their values are calculated by a script call, evaluating the formula you
provide (just like skill and item damage formulas). Like the formula box, the
entirety of a value script must be one one line. Use semicolons (';') to split
apart lines of Ruby script.
- EFFECT_CODE is an integer indicating the code of the effect.
  See Game_Battler in the RTP scripts the list of effect codes.
  You can also use the codes of new effects introduced in other scripts
  you may be using. 
- DATA_ID is an integer indicating the id of whatever the effect applies to,
  such as state indices. As many effects don't use the data ID, this value is
  optional. Default is 0.
- VALUE_FORMULA_1 is the Ruby script that will be evaluated when checking the
  dynamic effect's first value.
- VALUE_FORMULA_2 is the Ruby script that will be evaluated when checking the
  dynamic effect's second value. As most effects only use the first value,
  this formula is optional. Default is an empty string (evaluating to 0).
- You can use the following variables in your script.
  a: The battler using the skill or item
  b: The battler subjected to the skill or item
  s: The skill or item using the dynamic effect
  v: $game_variables
- Any amount of white space is allowed around the numbers. They may,
  optionally, be comma-separated.
- VALUE_FORMULA_1 and VALUE_FORMULA_2 must, be on separate lines from each other
  and from the rest of the note tag. The formulas themselves may not have any
  line breaks within them.
- Valid Locations: Skill, Item
- Valid Strings (case insensitive):
  <dynamic effect: EFFECT_CODE, DATA_ID>
    VALUE_FORMULA_1
    VALUE_FORMULA_2
  </dynamic effect>
  Ex: <dynamic effect: 11>  #Effect code 11, data ID 0 (default): Restores hp...
        v[1]                #...a percentage of subject's max hp equal to the value in game variable #1...
        a.atk               #...plus a flat amount equal to the user's atk.
      </dynamic effect>

Warning: Effects are evaluated more than once per use of a skill or item,
and can sometimes be evaluated even if the skill or item fails to be used.
Make very sure that your formulas do not have any side effects (that they
don't modify any variables while being evaluated), or else things probably
won't work as intended.

-------------------------------------------------------------------------------

Change Log:

v1.0
- Friday, October 9, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- Garryl::Loader::LoadEffect
- Game_Battler
- RPG::UsableItem::Effect

-------------------------------------------------------------------------------

Compatibility:

This script defines the following new classes
- Garryl::Loader::LoadDynamicEffect < Garryl::Loader::LoadEffect
- RPG::UsableItem::DynamicEffect < RPG::UsableItem::Effect

The following default script functions are overwritten:
- None

The following default script functions are aliased:
- Game_Battler.item_test_effect
- Game_Battler.item_apply_effect

The following functions are added to default script classes:
- RPG::UsableItem::Effect.static?
- RPG::UsableItem::Effect.dynamic?

-------------------------------------------------------------------------------
=end

#Import requirements check
unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"]
  puts "Error! Garryl Loader module not imported. Required for Garryl Dynamic Effects."
  puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  puts "If Loader script is already included among your materials, please ensure that this script (file: #{__FILE__}) comes after it."
else

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Dynamic_Effects"] ||= {}
$imported["Garryl"]["Dynamic_Effects"]["Version"] = "1.0"
$imported["Garryl"]["Dynamic_Effects"]["Dynamic Effects"] = true

  
module Garryl
  module DynamicEffects
    module Settings
      # *********************************************************************
      # * Settings                                                          *
      # *********************************************************************
      # * You can modify the variables here to fine tune dynamic effects    *
      # * for your game.                                                    *
      # *********************************************************************
      
      #----------------------------------------------------------------------
      # * Default value of a dynamic effect
      # * Used if an eval error occurs
      # * If you are using dynamic effects with new effects provided by
      #   another script, make sure to put their default values here.
      #   Choose a number that makes the effect do nothing.
      # * Ex: multiplying by 1, adding or subtracting 0, etc.
      # * DEFAULT_VALUES[my_effect_code] = [value1, value2]
      #----------------------------------------------------------------------
      DEFAULT_VALUES = Hash.new([0, 0])  #Defaults to 0 if nothing specified
      
      #Additive modifiers
      #Not necessary, default value is 0 already
      
      #Multipliers
      
      #Special flags
      
      #Other
      
      # *********************************************************************
      # * End of Settings                                                   *
      # *********************************************************************
    end
  end
end


module Garryl
  module Loader
    
    # ***********************************************************************
    # * New Class                                                           *
    # ***********************************************************************
    # * LoadDynamicEffect Class                                             *
    # * Extends LoadEffect                                                  *
    # * Defines a configuration for loading dynamic effects from note tags  *
    #   of an object.                                                       *
    # ***********************************************************************
    class LoadDynamicEffect < LoadEffect
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Create Effect
      # * Creates the dynamic effect defined by loaded data
      # * Just like the superclass's version, but creates a different object
      #   class (DynamicEffect instead of Effect).
      # * Also casts value1 and value2 to string, just in case, to ensure
      #   they can be evaluated. The RegexConf still needs a capture type for
      #   value1 and value2 so it knows to capture them, though.
      #----------------------------------------------------------------------
      def create_effect(code, id, val1, val2)
        #puts "creating dynamic effect [#{code}, #{id}, #{val1}, #{val2}]"
        return RPG::UsableItem::DynamicEffect.new(code, id, val1.to_s, val2.to_s)
      end
      
    end #class LoadDynamicEffect

    
    # ***********************************************************************
    # * Note Tags                                                           *
    # ***********************************************************************
    # * This script registers note tags for all of the new features and     *
    # * effects it provides.                                                *
    # ***********************************************************************
    
    #------------------------------------------------------------------------
    # * Effects
    #------------------------------------------------------------------------
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*dynamic\s+effect\s*:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+))?\s*>\s*^(.*)$\s*(?:^(.*)$\s*)?<\s*\/dynamic\s+effect\s*>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING, RegexConf::CAPTURE_STRING)))
                                              # Dynamic effect entry
  end
end


class Game_Battler
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_dynamic_effects_alias_game_battler_item_effect_test   item_effect_test
  alias garryl_dynamic_effects_alias_game_battler_item_effect_apply  item_effect_apply
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Test Effect
  # * Snapshots dynamic effects for test application of the skill or item
  #--------------------------------------------------------------------------
  def item_effect_test(user, item, effect)
    effect = effect.snapshot(item, user, self) if effect.dynamic?
    return garryl_dynamic_effects_alias_game_battler_item_effect_test(user, item, effect)
  end
  
  #--------------------------------------------------------------------------
  # * Apply Effect
  # * Snapshots dynamic effects for this use of the skill or item
  #--------------------------------------------------------------------------
  def item_effect_apply(user, item, effect)
    effect = effect.snapshot(item, user, self) if effect.dynamic?
    return garryl_dynamic_effects_alias_game_battler_item_effect_apply(user, item, effect)
  end
end


class RPG::UsableItem::Effect
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic effects
  # * True
  #--------------------------------------------------------------------------
  def static?
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic effects
  # * False
  #--------------------------------------------------------------------------
  def dynamic?
    return false
  end
end


# ***************************************************************************
# * New Class                                                               *
# ***************************************************************************
class RPG::UsableItem::DynamicEffect < RPG::UsableItem::Effect
  # *************************************************************************
  # * Class Variables                                                       *
  # *************************************************************************
  @@dynamic_effect_recursion_list = []   #List of all dynamic effects that
            #are being recursively evaluated. Skips effects on the list.
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic effects
  # * False
  #--------------------------------------------------------------------------
  def static?
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Identifies static/dynamic effects
  # * True
  #--------------------------------------------------------------------------
  def dynamic?
    return true
  end
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Default value of a dynamic effect
  # * Used in case of skipping due to recursion or when an eval error occurs
  #--------------------------------------------------------------------------
  def default_value1
    #puts "DEBUG: Getting default value1"
    return Garryl::DynamicEffects::Settings::DEFAULT_VALUES[@effect_code][0]
  end
  
  def default_value2
    #puts "DEBUG: Getting default value2"
    return Garryl::DynamicEffects::Settings::DEFAULT_VALUES[@effect_code][1]
  end
  
  #--------------------------------------------------------------------------
  # * Evaluates the value script
  # * a: Current reference battler using the skill or item
  # * b: Current reference battler subjected to the skill or item
  # * s: Skill or item that is the source of the effect
  # * v: $game_variables
  #--------------------------------------------------------------------------
  def evaluate(a, b, s, v = $game_variables)
    v1 = Kernel.eval(@value1) rescue default_value1
    v2 = Kernel.eval(@value2) rescue default_value2
    return [v1, v2]
  end
  
  #--------------------------------------------------------------------------
  # * Dynamically evaluates the effect values.
  # * Can deal with recursion, on the off-chance someone manages to reference
  #   the values of effects within the resolution of effects.
  #--------------------------------------------------------------------------
  def values(source_item = nil, reference_user = nil, reference_subject = nil)
    #puts"DEBUG: Evaluating dynamic effect by battler #{reference_user.name} against battler #{reference_subject.name} via item #{source_item.name}"
    if (!@@dynamic_effect_recursion_list.include?(self))
      #puts "  Evaluating"
      #puts "  SCRIPT 1: #{@value1}"
      #puts "  SCRIPT 2: #{@value2}"
      @@dynamic_effect_recursion_list.push(self)
      evaluated_values = evaluate(reference_user, reference_subject, source_item, $game_variables)
      @@dynamic_effect_recursion_list.delete(self)
    else
      #puts "  Skipping evaluation"
      evaluated_values = [default_value1, default_value2]
    end
    #puts "RESULT: #{evaluated_values[0]}, #{evaluated_values[1]}"
    
    return evaluated_values
  end
  
  #--------------------------------------------------------------------------
  # * Creates a snapshot of this effect with its source and reference battler
  # * Source is the skill or item that has the effect
  # * References are the battlers using and subjected to the effect
  #--------------------------------------------------------------------------
  def snapshot(source_item = nil, reference_user = nil, reference_subject = nil)
    evaluated_values = values(source_item, reference_user, reference_subject)
    return RPG::UsableItem::Effect.new(@code, @data_id, evaluated_values[0], evaluated_values[1])
  end
  
end




end #Import requirements check
