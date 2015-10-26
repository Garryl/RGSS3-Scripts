=begin
-------------------------------------------------------------------------------

Dynamic Effects Default Note Tags
Version 1.0

Created: Oct. 10, 2015
Last update: Oct. 10, 2015

Author: Garryl

Source: https://github.com/Garryl/RGSS3-Scripts

-------------------------------------------------------------------------------

Description:

This script registers dynamic versions of note tags for all of the standard
effects that can be added normally through the GUI.

Note: Make sure you place this AFTER the loader and dynamic features scripts.

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

This script provides note tag-based loading for dynamic versions of all default
effects of the RPG Make VX Ace engine.

-------------------------------------------------------------------------------

Note Tags:

Effects:
- HP Recovery:                <dynamic effect recover hp>
                                PERCENT_HP_FORMULA
                                FLAT_HP_FORMULA
                              </dynamic effect>
- MP Recovery:                <dynamic effect recover mp>
                                PERCENT_MP_FORMULA
                                FLAT_MP_FORMULA
                              </dynamic effect>
- TP Gain:                    <dynamic effect gain tp>
                                FLAT_TP_FORMULA
                              </dynamic effect>
- Add State:                  <dynamic effect add state: STATE_ID>
                                APPLICATION_RATE_FORMULA
                              </dynamic effect>
- Add State - Normal Attack:  <dynamic effect add normal attack state>
                                APPLICATION_RATE_FORMULA
                              </dynamic effect>
- Remove State:               <dynamic effect remove state: STATE_ID>
                                REMOVAL_RATE_FORMULA
                              </dynamic effect>
- Add Buff:                   <dynamic effect add buff: PARAM_ID>
                                NUM_TURNS_FORMULA
                              </dynamic effect>
- Add Buff:                   <dynamic effect add buff mhp/mmp/atk/def/mat/mdf/agi/luk>
                                NUM_TURNS_FORMULA
                              </dynamic effect>
- Add Debuff:                 <dynamic effect add debuff: PARAM_ID>
                                NUM_TURNS_FORMULA
                              </dynamic effect>
- Add Debuff:                 <dynamic effect add debuff mhp/mmp/atk/def/mat/mdf/agi/luk>
                                NUM_TURNS_FORMULA
                              </dynamic effect>
- Remove Buff:                N/A
- Remove Debuff:              N/A
- Special Effect:             N/A
- Raise Parameter:            <dynamic effect grow: PARAM_ID>
                                AMOUNT_FORMULA
                              </dynamic effect>
- Raise Parameter:            <dynamic effect grow mhp/mmp/atk/def/mat/mdf/agi/luk>
                                AMOUNT_FORMULA
                              </dynamic effect>
- Learn Skill:                N/A
- Common Event:               N/A

-------------------------------------------------------------------------------

Change Log:

v1.0
- Saturday, October 10, 2015
- Initial release.

-------------------------------------------------------------------------------
=end

#Import requirements check
unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"] && $imported["Garryl"]["Dynamic_Effects"]
  unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"]
    puts "Error! Garryl Loader module not imported."
    puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  end
  unless $imported && $imported["Garryl"] && $imported["Garryl"]["Dynamic_Effects"]
    puts "Error! Garryl Dynamic Effects module not imported."
    puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  end
  puts "If these scripts are already included among your materials, please ensure that Dynamic Effects Loader Defaults (file: #{__FILE__}) comes after them."
else

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Dynamic_Effects_Loader_Defaults"] ||= {}
$imported["Garryl"]["Dynamic_Effects_Loader_Defaults"]["Version"] = "1.0"

module Garryl
  module Loader
    # *************************************************************************
    # * Default Note Tags                                                     *
    # *************************************************************************
    # * This script registers note tags for dynamic versions of all of the    *
    # * standard effects that can be added normally through the GUI.          *
    # *************************************************************************
    # * Note: Make sure you place this AFTER the main loader script.          *
    # *************************************************************************
    
    
    #--------------------------------------------------------------------------
    # * Effects
    #--------------------------------------------------------------------------
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+recover\s+hp\s*>\s*^(.*)$\s*(?:^(.*)$\s*)?<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_RECOVER_HP, 0))      # HP Recovery
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+recover\s+mp\s*>\s*^(.*)$\s*(?:^(.*)$\s*)?<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_RECOVER_MP, 0))      # MP Recovery
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+gain\s+tp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GAIN_TP, 0))         # TP Gain
    
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+state\s*:\s*([0-9]+)>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_STATE))          # Add State
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+normal\s+attack\s+state\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_STATE, 0))       # Add State - normal attack
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+remove\s+state\s*:\s*([0-9]+)>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_REMOVE_STATE))       # Remove State
    
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s*:\s*([0-9]+)>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF))           # Add Buff
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mhp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 0))        # Add Buff - mhp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mmp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 1))        # Add Buff - mmp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+atk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 2))        # Add Buff - atk
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+def\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 3))        # Add Buff - def
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mat\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 4))        # Add Buff - mat
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+mdf\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 5))        # Add Buff - mdf
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+agi\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 6))        # Add Buff - agi
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+buff\s+luk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_BUFF, 7))        # Add Buff - luk
    
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s*:\s*([0-9]+)>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF))         # Add Debuff
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mhp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 0))      # Add Debuff - mhp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mmp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 1))      # Add Debuff - mmp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+atk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 2))      # Add Debuff - atk
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+def\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 3))      # Add Debuff - def
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mat\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 4))      # Add Debuff - mat
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+mdf\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 5))      # Add Debuff - mdf
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+agi\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 6))      # Add Debuff - agi
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+add\s+debuff\s+luk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_ADD_DEBUFF, 7))      # Add Debuff - luk
    
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s*:\s*([0-9]+)>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW))               # Raise Parameter
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mhp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 0))            # Raise Parameter - mhp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mmp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 1))            # Raise Parameter - mmp
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+atk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 2))            # Raise Parameter - atk
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+def\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 3))            # Raise Parameter - def
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mat\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 4))            # Raise Parameter - mat
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+mdf\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 5))            # Raise Parameter - mdf
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+agi\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 6))            # Raise Parameter - agi
    register(LoadDynamicEffect.new(RegexConf.new(/<\s*effect\s+grow\s+luk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+effect\s*>/i, RegexConf::CAPTURE_STRING),
    Game_Battler::EFFECT_GROW, 7))            # Raise Parameter - luk

  end
end

end #Import requirements check
