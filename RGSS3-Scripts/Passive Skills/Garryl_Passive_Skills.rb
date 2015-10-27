=begin
-------------------------------------------------------------------------------

Passive Skills and Items
Version 2.0

Created: Apr. 4, 2015
Last update: Oct. 26, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script provides passive features for skills and items, defined through
note tags. Any feature that a normal feature-bearing game element (actors,
classes, weapons, armors, enemies, and states) can provide can also be provided
by passive skills and items.

This script also expands feature loading with Garryl Loader so that other
scripts that define new features with Garryl Loader note tags should function
in skills and items, too.

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

This script requires the Garryl Loader script v1.2, available at
https://github.com/Garryl/RGSS3-Scripts/tree/master/RGSS3-Scripts/Loader

-------------------------------------------------------------------------------

Usage Instructions:

This script enhances the Loader script so that any feature that can be defined
via note tags can be applied to skills and items, providing passive features.
These cause the item or skill to passively grant the features while they (the
items or skills) are available.
- Inventory Items: Items with passive features will apply to all actors in the
  party while the party has at least one of that item.
- Active Skills: For skills that are usable in battle or in the menu, they will
  grant their passive features to the battler that knows them (whether through
  class and level, event-based permanent learning, or equipment and states,
  although NOT from other passive skill features). The skill's passive features
  will be disabled if the skill or its skill category is sealed. If the skill
  has any equipped weapon requirements, those must also be met for the passive
  features to apply.
- Passive Skills: For skills that are purely passive (not usable in battle or
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

All features of the RPG Maker VX Ace editor can be made available through
user-friendly note tags via the Garryl Loader Defaults script (found with
Garryl Loader, see link above).

-------------------------------------------------------------------------------

Change Log:

v2.0
- Sunday, October 26, 2015
- Now uses Loader module. Much code for loading note tags removed (from ~300
  lines down to 11). As the feature note tags specific to the previous versions
  of this script do not match those of Garryl Loader Defaults, notes in
  existing projects will need to be updated as well.
- Adjusted passive skill/item conditions checking functions for improved
  readability, more similarity to RTP active skill/item conditions methods,
  and easier extensibility.
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

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- N/A

The following default script functions are aliased:
- Game_Actor.feature_objects
- Game_Enemy.feature_objects

The following functions are added to default script classes:
- Game_BattlerBase.passive_usable_item_conditions_met?
- Game_BattlerBase.passive_skill_conditions_met?
- Game_BattlerBase.passive_item_conditions_met?
- Game_Enemy.passive_action_valid?

-------------------------------------------------------------------------------
=end

#Import requirements check
unless ($imported["Garryl"] && $imported["Garryl"]["Loader"] && $imported["Garryl"]["Loader"]["Version"] >= "1.2")
  puts "Error! Garryl Loader module v1.2 or higher not imported. Required for Garryl State Intensity."
  puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  puts "If Loader script is already included among your materials, please ensure that this script (file: #{__FILE__}) comes after it."
else
  
# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Passive Skills"] ||= {}
$imported["Garryl"]["Passive Skills"]["Version"] = "2.0"
$imported["Garryl"]["Passive Skills"]["Skill Features"] = true
$imported["Garryl"]["Passive Skills"]["Party Inventory"] = true

module Garryl
  
  module Loader
    # *************************************************************************
    # * Feature Group                                                         *
    # *************************************************************************
    # * This script expands the feature group to load for skills and items.   *
    # *************************************************************************
    # * Note: Make sure you place this AFTER the main loader script.          *
    # *************************************************************************
    LoadFeature::GROUP.add_data_group(LoadGroup::SKILLS)
    LoadFeature::GROUP.add_data_group(LoadGroup::ITEMS)
  end
  
  module PassiveSkills
    #Empty
  end
end


class Game_BattlerBase
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Check Common Usability Conditions for Passive Skill/Item
  # * Checks if the conditions are met for a passive usable item
  # * Shared conditions for both skills and items
  # * Anything goes, actually
  #--------------------------------------------------------------------------
  def passive_usable_item_conditions_met?(item)
    #puts "DEBUG: Validating passive usable item usability for #{item.name}"
    
    #Unlike active skills/items, don't care about being able to act,
    #nor whether or not we're in battle
    #movable? && occasion_ok?(item)
    return true
  end

  #--------------------------------------------------------------------------
  # * Check Usability Conditions for Passive Skill
  # * Checks if the conditions are met for a passive skill
  # * A lot less restrictive than for an active skill
  #--------------------------------------------------------------------------
  def passive_skill_conditions_met?(skill)
    #puts "DEBUG: Validating passive skill usability for #{skill.name}"
    
    #Unlike active skills, don't care about being able to act,
    #nor whether or not we're in battle
    return (passive_usable_item_conditions_met?(skill) &&
    #Weapon type is valid to care about
      skill_wtype_ok?(skill) &&
    #Don't care about cost unless it's a purely passive skill
      (skill.battle_ok? || skill.menu_ok? || skill_cost_payable?(skill)) &&
    #Skill can't be sealed and rendered unusable
      !skill_sealed?(skill.id) && !skill_type_sealed?(skill.stype_id))
  end
  
  #--------------------------------------------------------------------------
  # * Check Usability Conditions for Passive Item
  # * Checks if the conditions are met for a passive item
  #--------------------------------------------------------------------------
  def passive_item_conditions_met?(item)
    #puts "DEBUG: Validating passive item usability for #{item.name}"
    return passive_usable_item_conditions_met?(item) && $game_party.has_item?(item)
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
    #puts "DEBUG: Validating action usability for #{$data_skills[action.skill_id].name}"
    return conditions_met?(action) && passive_skill_conditions_met?($data_skills[action.skill_id])
  end
  
end

end #Import requirements check
