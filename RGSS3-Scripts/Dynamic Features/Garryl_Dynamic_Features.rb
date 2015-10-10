=begin
-------------------------------------------------------------------------------

Dynamic Features
Version 2.0

Created: Apr. 8, 2015
Last update: Oct. 9, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script allows for features with variable values, or "dynamic features",
which are calculated on the fly from formulas you can provide.
Dynamic features are defined through note tags. Any normal game object that can
have features (actors, classes, enemies, weapons, armor, and states) supports
these features. See the Note Tags section for more details.

This script provides is an updated version of the dynamic features provided by
my earlier "power features" and "extra features" scripts. Dynamic features are
provided here without the overhead and compatibility issues of the other
features those earlier scripts included. Here, they are also rewritten to
leverage my autoloader script for improved compatibility with other scripts.

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
gained by putting the indicated text in the "Note" field of feature-bearing
items (states, weapons, armor, etc.)

Dynamic Features: These features work just like normal features, except that
their values are calculated by a script call, evaluating the formula you
provide (just like skill and item damage formulas). Like the formula box, the
entirety of a value script must be one one line. Use semicolons (';') to split
apart lines of Ruby script.
- FEATURE_CODE is a positive integer indicating the code of the feature.
  See Game_BattlerBase in the RTP scripts the list of feature codes.
  You can also use the codes of new features introduced in other scripts
  you may be using.
- DATA_ID is a positive integer indicating the id of whatever the feature
  applies to, such as element indices.
- VALUE_FORMULA is the Ruby script that will be evaluated when checking the
  dynamic feature's value. You can use the following variables in your script.
  a: The battler whose feature is being evaluated.
  s: The feature-bearing item providing the dynamic feature
  v: $game_variables
- Any amount of white space is allowed around the numbers. They may,
  optionally, be comma-separated.
- VALUE_FORMULA may, optionally, be on a separate line from the rest of the
  note tag. The formula itself may not have any line breaks within it.
- Valid Locations: Actor, Class, Weapon, Armor, Enemy, State
- Valid Strings (case insensitive):
  <dynamic feature: FEATURE_CODE, DATA_ID> VALUE_FORMULA </dynamic feature>
  Ex: <dynamic feature: 21, 2>1 + (1-a.hp_rate)</dynamic feature>   #Increases a
                                    #battler's atk proportionately to its missing HP.
  Ex: <dynamic feature: 21, 2>
        1 + (1-a.hp_rate)
      </dynamic feature>

Note: Dynamic features work semi-recursively. You can chain them from one param
to another and they will work as expected (ex: increasing hit by some function
of agi, while agi is dynamically modified by atk and def, will take into
account the dynamic features affecting agi when calculating hit). However, when
the dynamic features loop back on themselves, recursion is limited to one
iteration whenever evaluation occurs; essentially, when calculating its value,
a dynamic feature will not take itself into account, and when calculating its
value to supply it to another dynamic feature's formula, it will ignore that
feature and any others further up the line of calculation.

Warning: Features are evaluated ridiculously often. Make very sure that your
formulas do not have any side effects (that they don't modify any variables
while being evaluated), or else things probably won't work as intended.

-------------------------------------------------------------------------------

Change Log:

v2.0
- Friday, October 9, 2015
- Independent release of dynamic features.
- Rewritten to use Garryl Loader.
- Changed note tag format.
- Added access to the source of the feature in dynamic feature formulas.
v1.3
- Wednesday, April 8, 2015
- Initial release of dynamic features in Extra Features script.

-------------------------------------------------------------------------------

References:
- Garryl::Loader::LoadFeature
- Game_BattlerBase
- RPG::BaseItem
- RPG::BaseItem::Feature

-------------------------------------------------------------------------------

Compatibility:

This script defines the following new classes
- Garryl::Loader::LoadDynamicFeature < Garryl::Loader::LoadFeature
- RPG::BaseItem::DynamicFeature < RPG::BaseItem::Feature

The following default script functions are overwritten:
- Game_BattlerBase.all_features

The following default script functions are aliased:
- RPG::BaseItem.features

The following functions are added to default script classes:
- RPG::BaseItem::Feature.static?
- RPG::BaseItem::Feature.dynamic?

-------------------------------------------------------------------------------
=end

#Import requirements check
unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"]
  puts "Error! Garryl Loader module not imported. Required for Garryl Dynamic Features."
  puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  puts "If Loader script is already included among your materials, please ensure that this script (file: #{__FILE__}) comes after it."
else

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Dynamic_Features"] ||= {}
$imported["Garryl"]["Dynamic_Features"]["Version"] = "2.0"
$imported["Garryl"]["Dynamic_Features"]["Dynamic Features"] = true

  
module Garryl
  module DynamicFeatures
    module Settings
      # *********************************************************************
      # * Settings                                                          *
      # *********************************************************************
      # * You can modify the variables here to fine tune dynamic features   *
      # * for your game.                                                    *
      # *********************************************************************
      
      #----------------------------------------------------------------------
      # * Default value of a dynamic feature
      # * Used in case of skipping due to recursion or when an eval error
      #   occurs
      # * If you are using dynamic features with new features provided by
      #   another script, make sure to put their default values here.
      #   Choose a number that makes the feature do nothing.
      # * Ex: multiplying by 1, adding or subtracting 0, etc.
      # * DEFAULT_VALUES[my_feature_code] = value
      #----------------------------------------------------------------------
      DEFAULT_VALUES = Hash.new(0)  #Defaults to 0 if nothing specified
      
      #Additive modifiers
      #Not necessary, default value is 0 already
      
      #Multipliers
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_ELEMENT_RATE] = 1
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_DEBUFF_RATE] = 1
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_STATE_RATE] = 1
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_PARAM] = 1
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_SPARAM] = 1
      
      #Special flags
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_SPECIAL_FLAG] = -1
      DEFAULT_VALUES[Game_BattlerBase::FEATURE_PARTY_ABILITY] = -1
      
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
    # * LoadDynamicFeature Class                                            *
    # * Extends LoadFeature                                                 *
    # * Defines a configuration for loading dynamic features from note tags *
    #   of an object.                                                       *
    # ***********************************************************************
    class LoadDynamicFeature < LoadFeature
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Create Feature
      # * Creates the dynamic feature defined by loaded data
      # * Just like the superclass's version, but creates a different object
      #   class (DynamicFeature instead of Feature).
      # * Also casts value to string, just in case, to ensure it can be
      #   evaluated. The RegexConf still needs a capture type for value so
      #   it knows to capture it, though.
      #----------------------------------------------------------------------
      def create_feature(code, id, val)
        #puts "creating feature [#{code}, #{id}, #{val}]"
        return RPG::BaseItem::DynamicFeature.new(code, id, val.to_s)
      end
      
    end #class LoadDynamicFeature

    
    # ***********************************************************************
    # * Note Tags                                                           *
    # ***********************************************************************
    # * This script registers note tags for all of the new features and     *
    # * effects it provides.                                                *
    # ***********************************************************************
    
    #------------------------------------------------------------------------
    # * Features
    #------------------------------------------------------------------------
#    register(LoadDynamicFeature.new(RegexConf.new(/<dynamic feature:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+))?\s*>(.*)<\/dynamic feature>/i,
#          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING)))
#    register(LoadDynamicFeature.new(RegexConf.new(/<dynamic feature:\s*([\-\+]?[0-9]+)[,\s]\s*([\-\+]?[0-9]+)\s*>(.*)<\/dynamic feature>/i,
#          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING)))
    register(LoadDynamicFeature.new(RegexConf.new(/<dynamic feature:\s*([\-\+]?[0-9]+)(?:[,\s]\s*([\-\+]?[0-9]+))?\s*>\s*^?(.*)$?\s*<\/dynamic feature>/i,
          RegexConf::CAPTURE_INT, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING)))
                                              # Dynamic feature entry
  end
end


class Game_BattlerBase
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Array of All Feature Objects
  # * Passes battler to obj.features for dynamic feature resolution
  #--------------------------------------------------------------------------
  def all_features
    feature_objects.inject([]) do |r, obj| r + obj.features(self) end
    #TODO: Can (and should) I rewrite this to snapshot the dynamic features here instead of in BaseItem.features()? 
  end
  
end


class RPG::BaseItem
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_dynamic_features_alias_rpg_baseitem_features   features
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Aliases features accessor
  # * Snapshots dynamic features if passes a reference battler.
  # * Otherwise, acts as a simple accessor.
  #--------------------------------------------------------------------------
  def features(reference_battler = nil)
    #Normal accessor if no reference battler
    return garryl_dynamic_features_alias_rpg_baseitem_features if reference_battler.nil?()
    
    #If there is a reference battler, clone this item's features and resolve the dynamic ones for it
    #puts "DEBUG: Resolving features for battler base: #{name}"
    
    #Gets all features, which includes snapshots of dynamic features.
    features_result = garryl_state_potency_alias_rpg_baseitem_features
    
    #select static features
    resolved_features = features_result.select do |feature| feature.static? end
    
    #snapshot dynamic features and add them to the list
    dynamic_features = features_result.select do |feature| feature.dynamic? end
    dynamic_features.each do |feature| resolved_features.push(feature.snapshot(self, reference_battler)) end
    
    return resolved_features
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
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_dynamic_features_alias_rpg_baseitem_dynamicfeature_value   value
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Aliases accessor of superclass
  # * If passed the source item and a reference battler, dynamically
  #   evaluates the feature value.
  # * Otherwise, acts as a simple accessor.
  #--------------------------------------------------------------------------
  def value(source_item = nil, reference_battler = nil)
    
    #Normal accessor if no source item or reference battler
    if source_item.nil? || reference_battler.nil?()
      #puts( ("DEBUG: No source item and/or reference battler: Normal value access."))
      return garryl_dynamic_features_alias_rpg_baseitem_dynamicfeature_value
      
    #If there is a reference battler, evaluate for it
    else
      #puts"DEBUG: Evaluating dynamic feature on battler #{reference_battler.name} via item #{source_item.name}"
      #puts "SCRIPT: #{@value}"
      if (!@@dynamic_feature_recursion_list.include?(self))
        #puts "  Evaluating"
        @@dynamic_feature_recursion_list.push(self)
        evaluated_value = evaluate(reference_battler, source_item, $game_variables)
        @@dynamic_feature_recursion_list.delete(self)
      else
        #puts "  Skipping evaluation"
        evaluated_value = default_value
      end
      #puts "RESULT: #{evaluated_value}"
      
      return evaluated_value
    end
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
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
    return Garryl::DynamicFeatures::Settings::DEFAULT_VALUES[@feature_code]
  end
  
  #--------------------------------------------------------------------------
  # * Evaluates the value script
  # * a: Current reference battler
  # * s: Base item that is the source of the feature
  # * v: $game_variables
  #--------------------------------------------------------------------------
  def evaluate(a, s, v = $game_variables)
    #return eval(@value)
    return Kernel.eval(@value) rescue default_value
  end
  
  #--------------------------------------------------------------------------
  # * Creates a snapshot of this feature with its source and reference battler
  # * Source is the base item that has the feature
  # * Reference is the battler affected by the feature
  #--------------------------------------------------------------------------
  def snapshot(source_item = nil, reference_battler = nil)
    return RPG::BaseItem::Feature.new(@code, @data_id, value(source_item, reference_battler))
  end
  
end


end #Import requirements check
