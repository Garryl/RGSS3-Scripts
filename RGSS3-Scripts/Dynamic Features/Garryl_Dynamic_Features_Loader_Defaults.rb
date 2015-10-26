=begin
-------------------------------------------------------------------------------

Dynamic Features Default Note Tags
Version 1.0

Created: Oct. 10, 2015
Last update: Oct. 10, 2015

Author: Garryl

Source: https://github.com/Garryl/RGSS3-Scripts

-------------------------------------------------------------------------------

Description:

This script registers dynamic versions of note tags for all of the standard
features that can be added normally through the GUI.

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
features of the RPG Make VX Ace engine.

-------------------------------------------------------------------------------

Note Tags:

Features:
- Element Rate:               <dynamic feature element rate: ELEMENT_ID>RATE_FORMULA</dynamic feature>
- Debuff Rate:                <dynamic feature debuff rate: DEBUFF_ID>RATE_FORMULA</dynamic feature>
- State Rate:                 <dynamic feature state rate: STATE_ID>RATE_FORMULA</dynamic feature>
- State Resist:               N/A
- Parameters:                 <dynamic feature param: PARAM_ID>MULTIPLIER_FORMULA</dynamic feature>
- Parameters:                 <dynamic feature mhp/mmp/atk/def/mat/mdf/agi/luk>MULTIPLIER_FORMULA</dynamic feature>
- Ex-Parameters:              <dynamic feature xparam: XPARAM_ID>MULTIPLIER_FORMULA</dynamic feature>
- Ex-Parameters:              <dynamic feature hit/eva/cri/cev/mev/mrf/cnt/hrg/mrg/trg>MODIFIER_FORMULA</dynamic feature>
- Sp-Parameters:              <dynamic feature sparam: SPARAM_ID>MODIFIER_FORMULA</dynamic feature>
- Sp-Parameters:              <dynamic feature tgr/grd/rec/pha/mcr/tcr/pdr/mdr/fdr/exr>MULTIPLIER_FORMULA</dynamic feature>
- Attack Element:             N/A
- Attack State:               <dynamic feature atk state: STATE_ID>APPLICATION_RATE_FORMULA</dynamic feature>
- Attack Speed:               <dynamic feature atk speed>MODIFIER_FORMULA</dynamic feature>
- Attack Times:               <dynamic feature atk times>MODIFIER_FORMULA</dynamic feature>
- Add Skill Type:             N/A
- Seal Skill Type:            N/A
- Add Skill:                  N/A
- Seal Skill:                 N/A
- Equip Weapon Type:          N/A
- Equip Armor Type:           N/A
- Lock Equip Slot:            N/A
- Seal Equip Slot:            N/A
- Slot Type:                  N/A
- Enable Dual Wield:          N/A
- Action Times+:              <dynamic feature action plus>CHANCE_OF_BONUS_ACTION_FORMULA</dynamic feature>
- Special Flag:               N/A
- Collapse Type:              N/A
- Party Ability:              N/A

-------------------------------------------------------------------------------

Change Log:

v1.0
- Saturday, October 10, 2015
- Initial release.

-------------------------------------------------------------------------------
=end

#Import requirements check
unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"] && $imported["Garryl"]["Dynamic_Features"]
  unless $imported && $imported["Garryl"] && $imported["Garryl"]["Loader"]
    puts "Error! Garryl Loader module not imported."
    puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  end
  unless $imported && $imported["Garryl"] && $imported["Garryl"]["Dynamic_Features"]
    puts "Error! Garryl Dynamic Features module not imported."
    puts "Get it at https://github.com/Garryl/RGSS3-Scripts"
  end
  puts "If these scripts are already included among your materials, please ensure that Dynamic Features Loader Defaults (file: #{__FILE__}) comes after them."
else

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Dynamic_Features_Loader_Defaults"] ||= {}
$imported["Garryl"]["Dynamic_Features_Loader_Defaults"]["Version"] = "1.0"

module Garryl
  module Loader
    # *************************************************************************
    # * Default Note Tags                                                     *
    # *************************************************************************
    # * This script registers note tags for dynamic versions of all of the    *
    # * standard features that can be added normally through the GUI.         *
    # *************************************************************************
    # * Note: Make sure you place this AFTER the main loader script.          *
    # *************************************************************************
    
    
    #--------------------------------------------------------------------------
    # * Features
    #--------------------------------------------------------------------------
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+element\s+rate\s*:\s*([1-9][0-9]*)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_ELEMENT_RATE))  # Element Rate
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+debuff\s+rate\s*:\s*([1-9][0-9]*)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_DEBUFF_RATE))   # Debuff Rate
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+state\s+rate\s*:\s*([1-9][0-9]*)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_STATE_RATE))    # State Rate
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+param\s*:\s*([0-9]+)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM))         # Parameter
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mhp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 0))      # Parameter - mhp
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mmp\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 1))      # Parameter - mmp
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+atk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 2))      # Parameter - atk
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+def\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 3))      # Parameter - def
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mat\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 4))      # Parameter - mat
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mdf\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 5))      # Parameter - mdf
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+agi\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 6))      # Parameter - agi
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+luk\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_PARAM, 7))      # Parameter - luk
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+xparam\s*:\s*([0-9]+)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM))        # Ex-Parameter
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+hit\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 0))     # Ex-Parameter - hit
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+eva\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 1))     # Ex-Parameter - eva
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+cri\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 2))     # Ex-Parameter - cri
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+cev\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 3))     # Ex-Parameter - cev
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mev\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 4))     # Ex-Parameter - mev
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mrf\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 5))     # Ex-Parameter - mrf
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+cnt\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 6))     # Ex-Parameter - cnt
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+hrg\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 7))     # Ex-Parameter - hrg
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mrg\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 8))     # Ex-Parameter - mrg
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+trg\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_XPARAM, 9))     # Ex-Parameter - trg
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+sparam\s*:\s*([0-9]+)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM))        # Sp-Parameter
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+tgr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 0))     # Sp-Parameter - tgr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+grd\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 1))     # Sp-Parameter - grd
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+rec\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 2))     # Sp-Parameter - rec
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+pha\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 3))     # Sp-Parameter - pha
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mcr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 4))     # Sp-Parameter - mcr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+tcr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 5))     # Sp-Parameter - tcr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+pdr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 6))     # Sp-Parameter - pdr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+mdr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 7))     # Sp-Parameter - mdr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+fdr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 8))     # Sp-Parameter - fdr
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+exr\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_SPARAM, 9))     # Sp-Parameter - exr
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+atk\s+state\s*:\s*([1-9][0-9]*)\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_INT, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_ATK_STATE))     # Atk State
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+atk\s+speed\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_ATK_SPEED, 0))  # Atk Speed
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+atk\s+times\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_ATK_TIMES, 0))  # Atk Times+
    
    register(LoadDynamicFeature.new(RegexConf.new(/<\s*dynamic\s+feature\s+action\s+plus\s*>\s*^?(.*)$?\s*<\s*\/dynamic\s+feature\s*>/i, RegexConf::CAPTURE_STRING),
    Game_BattlerBase::FEATURE_ACTION_PLUS, 0))# Action Times+
    
  end
end

end #Import requirements check
