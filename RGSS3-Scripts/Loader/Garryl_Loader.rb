=begin
-------------------------------------------------------------------------------

Note Tag Loader
Version 1.0

Created: May 28, 2015
Last update: June 2, 2015

Author: Garryl

Source: https://github.com/Garryl/RGSS3-Scripts

-------------------------------------------------------------------------------

Description:

This script provides a framework for automated loading of note tags. It is
primarily designed for features and effects, but also includes functions to call
arbitrary methods.

Note: Making full use of this script requires knowledge of regular expressions.
You can learn more about regular expressions in Ruby online.
  - http://rubular.com/
  - http://ruby-doc.org/core-2.1.1/Regexp.html

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

This script provides a framework for automated note tag loading. Through a
simple API, you can configure it to process and load note tags for any of the
game elements that support notes in the RPG Maker VX Ace environment.
  - Actors
  - Classes
  - Skills
  - Items
  - Weapons
  - Armors
  - Enemies
  - States
  - Tilesets
  - Maps

This script was primarily designed for the automated loading of features and
effects from note tags into states, skills, equipment, etc. For simple features
and effects, simply create a loading configuration with a regular expression
configuration defining the regular expression and the data types it expects to
capture and have the Loader module register it. See APIs and Examples below for
more details.

This script also supports custom methods, wherein each time the regular
expression matches inside an object's note, that method of the object is
called, passing the array of (processed) capture data. Alternatively, with no
regular expression provided, the custom method option instead calls the method
once for each object.

-------------------------------------------------------------------------------

APIs:

module Garryl::Loader
- register(NotetagLoadingConfiguration)
  Registers a Garryl::Loader::NotetagLoadingConfiguration (or an object of a
  child class) to be applied when data is loaded.

class Garryl::Loader::RegexConf
- Capture types
  A set of constants that indicate how a RegexConf should process captures.
  CAPTURE_IGNORE: Capture block will be ignored and will not be passed
  CAPTURE_STRING: Capture block will be passed back as a string
  CAPTURE_INT: Capture block will be passed back as an integer
  CAPTURE_FLOAT: Capture block will be passed back as a floating point value
- new(regular expression, [capture type, [capture type, [...]]])
  Creates a new regular expression configuration. When loading occurs, it will
  be used to scan each object's note. See scan() for details.
- scan(string)
  Called automatically in the process of loading note tags for objects.
  Scans the passed string using the regular expression supplied during
  instantiation. Returns an array of all capture results (themselves in
  arrays). Capture results are of the capture types supplied during
  instantiation. Any missing capture results will be the conversion of nil
  (ie: nil.to_s, nil.to_i, nil.to_f, etc.). Capture results beyond those for
  which capture types were supplied are ignored and not included.

class Garryl::Loader::LoadGroup
- Data groups
  A set of constants that indicate what data sets the load group refers to.
  ACTORS: $data_actors
  CLASSES: $data_classes
  SKILLS: $data_skills
  ITEMS: $data_items
  WEAPONS: $data_weapons
  ARMOR: $data_armors
  ENEMIES: $data_enemies
  STATES: $data_states
  TILESETS: $data_tilesets
  MAPS: Game_Map objects, as they are set up
- new([data group, [data group, [...]]])
  Creates a new load group. When loading occurs, it will be used to determine
  which objects' notes the configuration applies to.

class Garryl::Loader::NotetagLoadingConfiguration
  Serves as a base class, extended by others. Has no functionality itself.

class Garryl::Loader::LoadFeature < NotetagLoadingConfiguration
  A class relating to loading configurations for feature-bearing objects.
- GROUP
  A constant LoadGroup object specifying all object types that bear features
  (actors, classes, weapons, armor, enemies, and states).
  It can be modified by other scripts that extend the functionality of other
  object categories to bear features the same way so that any configuration
  using this LoadGroup loads note tags for those objects as well.
- new(RegexConf, [feature code, [data id, [value]]])
  Defines a load configuration to process features for the object's note and
  push them to the object's features array (obj.features).
  LoadFeature configurations are automatically applied to all objects that bear
  features, using the LoadFeature::GROUP LoadGroup.
  Each time the regular expression matches, a new RPG::BaseItem::Feature
  object will be created using the specified feature code, data id, and value,
  using the capture results in order in place of those that were specified as
  nil or that were not passed in the initializer.

class Garryl::Loader::LoadEffect < NotetagLoadingConfiguration
  A class relating to loading configurations for effect-bearing objects,
  similar to how LoadFeature is for features.
- GROUP
  A constant LoadGroup object specifying all object types that bear effects
  (skills and items).
  It can be modified by other scripts that extend the functionality of other
  object categories to bear effects the same way so that any configuration
  using this LoadGroup loads note tags for those objects as well.
- new(RegexConf, [effect code, [data id, [value1, [value2]]]])
  Defines a load configuration to process effects for the object's note and
  push them to the object's effects array (obj.effects).
  LoadEffect configurations are automatically applied to all objects that bear
  effects, using the LoadEffect::GROUP LoadGroup.
  Each time the regular expression matches, a new RPG::UsableItem::Effect
  object will be created using the specified feature code, data id, and values,
  using the capture results in order in place of those that were specified as
  nil or that were not passed in the initializer.

class Garryl::Loader::CustomMethod < NotetagLoadingConfiguration
- new(RegexConf, LoadGroup, :method)
  Defines a load configuration to pass each capture group (an array) to the
  indicated method of each object being loaded. The method will be called once
  for each time the regular expression matches. Each time the method is called,
  it will be passed an array containing the capture results from the regular
  expression, each of which is of the capture type passed to the RegexConf. Any
  captures beyond those for which a capture type was passed will be ignored.
  If RegexConf is nil, this loading configuration acts differently. Instead, it
  calls the method once for each object, passing an array containing only the
  object's note.

-------------------------------------------------------------------------------

Examples:

Example: Defining a note tag for the element rate feature with a note-defined
  element (data_id => integer) and rate (value => floating point).

module Garryl::Loader
  register(LoadFeature.new(
    RegexConf.new(/<feature element rate:\s*([1-9][0-9]*)[,\s]\s*([\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i,
      RegexConf::CAPTURE_INT, RegexConf::CAPTURE_FLOAT),
    Game_BattlerBase::FEATURE_ELEMENT_RATE))
end

Example: Defining a note tag for the recover HP effect with a note-defined
  percentage (value1 => float) and flat (value2 => floating point) hp change.

module Garryl::Loader
  register(LoadEffect.new(
    RegexConf.new(/<effect recover hp:\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)[,\s]\s*([\-\+]?[0-9]+(?:\.[0-9]+)?)\s*>/i,
      RegexConf::CAPTURE_FLOAT, RegexConf::CAPTURE_FLOAT),
    Game_Battler::EFFECT_RECOVER_HP, 0))
end

Example: Defining a note tag to add a note-defined level parameter to enemies.

module Garryl::Loader
  register(CustomMethod.new(
    RegexConfig.new(/<level:\s*(\d+)\s*>/i, NoteRegexConfig::CAPTURE_INT),
    LoadGroup.new(LoadGroup::ENEMIES),
    :notetag_level))
end

RPG::Enemy
  attr_accessor :level
  def notetag_level(capture)
    @level = capture[0]
  end
end

-------------------------------------------------------------------------------

Change Log:

v1.0
- Tuesday, June 2, 2015
- Initial release.

-------------------------------------------------------------------------------

References:
- DataManager
- Game_Map

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- N/A

The following default script functions are aliased:
- DataManager.load_database
- Game_Map.setup

The following functions are added to default script classes:
- N/A

-------------------------------------------------------------------------------
=end

# ***************************************************************************
# * Import marker key                                                       *
# ***************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Loader"] ||= {}
$imported["Garryl"]["Loader"]["Version"] = "1.0"


module Garryl
  # *************************************************************************
  # * Loader Module                                                         *
  # *************************************************************************
  module Loader
    #------------------------------------------------------------------------
    # * Array of NotetagLoadingConfiguration to be loaded. 
    # * Populated by the register function
    #------------------------------------------------------------------------
    LOAD = []
    
    #------------------------------------------------------------------------
    # * Registers a NotetagLoadingConfiguration to be loaded
    #------------------------------------------------------------------------
    def self.register(loading_configuration)
      LOAD.push(loading_configuration)
    end
    
    # ***********************************************************************
    # * RegexConf Class                                                     *
    # * Defines a regular expression configuration (the regex itself and    *
    #   the expected capture types).                                        *
    # ***********************************************************************
    class RegexConf
      # *********************************************************************
      # * Constants                                                         *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Constants (Capture types)
      #----------------------------------------------------------------------
      CAPTURE_IGNORE  = nil #Capture block will be ignored and will not be passed
      CAPTURE_STRING  = 1   #Capture block will be passed back as a string
      CAPTURE_INT     = 2   #Capture block will be passed back as an integer
      CAPTURE_FLOAT   = 3   #Capture block will be passed back as a floating point value
      
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(regexp, *capture_types)
        @regexp = regexp
        @capture_types = capture_types
      end
      
      #----------------------------------------------------------------------
      # * Scan
      # * Scans a string and returns the captures in the specified types
      #----------------------------------------------------------------------
      def scan(note)
        captures = []
        note.scan(@regexp) do |raw_capture|
          #puts "Processing capture (#{raw_capture}) with types (#{@capture_types}) on regex (#{@regexp})"
          capture = []
          @capture_types.each do |type|
            case type
            when CAPTURE_STRING
              capture.push(raw_capture.shift.to_s)
            when CAPTURE_INT
              capture.push(raw_capture.shift.to_i)
            when CAPTURE_FLOAT
              capture.push(raw_capture.shift.to_f)
            else
              raw_capture.shift
            end
          end
          captures.push(capture)
        end
        return captures
      end
    end #class RegexConf
    
    # ***********************************************************************
    # * LoadGroup Class                                                     *
    # * Defines a group of data objects for which related loading will      *
    #   be performed.                                                       *
    # ***********************************************************************
    class LoadGroup
      # *********************************************************************
      # * Constants                                                         *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Constants (Data groups)
      #----------------------------------------------------------------------
      ACTORS       = 1
      CLASSES      = 2
      SKILLS       = 3
      ITEMS        = 4
      WEAPONS      = 5
      ARMOR        = 6
      ENEMIES      = 7
      STATES       = 8
      TILESETS     = 9
      MAPS         = 10
      
      # *************************************************************************
      # * Public Instance Variables                                             *
      # *************************************************************************
      #--------------------------------------------------------------------------
      # * Public Instance Variables
      #--------------------------------------------------------------------------
      attr_accessor :data_groups
      
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(*load_for)
        #load_for.each do |id| self.push(id) end
        @data_groups = load_for
      end
      
      #----------------------------------------------------------------------
      # * Resolve Groups
      # * Resolves the specified data groups into the actual data arrays they
      #   represent.
      # * Note: Since maps are loaded individually on demand, they have no
      #   data array to resolve to.
      #----------------------------------------------------------------------
      def resolve_groups
        group = []
        @data_groups.each do |load_element|
          case load_element
          when ACTORS
            group.push($data_actors)
          when CLASSES
            group.push($data_classes)
          when SKILLS
            group.push($data_skills)
          when ITEMS
            group.push($data_items)
          when WEAPONS
            group.push($data_weapons)
          when ARMOR
            group.push($data_armors)
          when ENEMIES
            group.push($data_enemies)
          when STATES
            group.push($data_states)
          when TILESETS
            group.push($data_tilesets)
          when MAPS
            #group.push($data_mapinfos) #Map note tags must be loaded when the maps are loaded
          end
        end
        return group.uniq
      end
      
      #----------------------------------------------------------------------
      # * Has Map Group?
      # * Since maps are loaded individually on demand, they have no
      #   data array to resolve to. Instead, this is used to check if the
      #   load group is for maps when a map is loaded.
      #----------------------------------------------------------------------
      def has_map_group?
        return @data_groups.include?(MAPS)
      end
      
    end #class LoadGroup
    
    # ***********************************************************************
    # * NotetagLoadingConfiguration Class                                   *
    # * Defines a configuration for loading note tags.                      *
    # * Does nothing on its own. Use the child classes instead.             *
    # ***********************************************************************
    class NotetagLoadingConfiguration
      
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(regexp_config, load_for)
        @regexp_config = regexp_config
        @load_for = load_for
      end
      
      #----------------------------------------------------------------------
      # * Load Notetag for Object
      #----------------------------------------------------------------------
      def load_notetag(obj)
      end
      
      #----------------------------------------------------------------------
      # * Resolve Load Group
      #----------------------------------------------------------------------
      def load_group
        group = (@load_for ? @load_for.resolve_groups : [])
        return group.uniq
      end
      
      #----------------------------------------------------------------------
      # * Load For Maps?
      #----------------------------------------------------------------------
      def load_for_maps?
        return @load_for.has_map_group?
      end
      
    end #class NotetagLoadingConfiguration
    
    # ***********************************************************************
    # * CustomMethod Class                                                  *
    # * Extends NotetagLoadingConfiguration                                 *
    # * Defines a configuration for loading note tags via a method of the   *
    #   object.                                                             *
    # ***********************************************************************
    class CustomMethod < NotetagLoadingConfiguration
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(regexp_config, load_for, method)
        super(regexp_config, load_for)
        @method = method
      end
      
      #----------------------------------------------------------------------
      # * Load Notetag for Object
      #----------------------------------------------------------------------
      def load_notetag(obj)
        #passes each capture by the regexp as an array to the method along with the object
        #captures.each do |capture| obj.method(capture) end
        #If regexp_config is nil, passes the whole note field
        super
        
        captures = (@regexp_config ? @regexp_config.scan(obj.note) : [obj.note])
        
        captures.each do |capture|
          #puts "Captured (#{capture}) for CustomMethod feature in #{obj.name}"
          obj.send(@method, capture) if @method
        end
      end
    end #class CustomMethod
    
    # ***********************************************************************
    # * LoadFeature Class                                                   *
    # * Extends NotetagLoadingConfiguration                                 *
    # * Defines a configuration for loading object features from note tags  *
    #   of the object.                                                      *
    # ***********************************************************************
    class LoadFeature < NotetagLoadingConfiguration
      
      # *********************************************************************
      # * Constants                                                         *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Constants (Feature LoadGroup)
      #----------------------------------------------------------------------
      GROUP = LoadGroup.new(LoadGroup::ACTORS, LoadGroup::CLASSES, LoadGroup::WEAPONS, LoadGroup::ARMOR, LoadGroup::ENEMIES, LoadGroup::STATES)
      
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(regexp_config, feature_code = nil, data_id = nil, value = nil)
        super(regexp_config, GROUP)
        @feature_code = feature_code
        @data_id = data_id
        @value = value
      end
      
      #----------------------------------------------------------------------
      # * Load Notetag for Object
      #----------------------------------------------------------------------
      def load_notetag(obj)
        #adds a new feature to the data object upon which the notetag loading is applied
        #uses the feature code, data ID, and value if specified
        #for nils, uses the results passed form the regexp config, in order
        super
        
        captures = @regexp_config.scan(obj.note)
        
        captures.each do |capture|
          #puts "Captured (#{capture}) for LoadFeature feature in #{obj.name}"
          
          code = (@feature_code.nil?() ? capture.shift : @feature_code)
          code = 0 if code.nil?   #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          id = (@data_id.nil?() ? capture.shift : @data_id)
          id = 0 if id.nil?       #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          val = (@value.nil?() ? capture.shift : @value)
          val = 0 if val.nil?     #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          
          #Instead of creating the Feature object here, define a new method that
          #does it so it can be aliased/overwritten for future expansion, like with dynamic features
          obj.features.push(create_feature(code, id, val))
        end
      end
      
      #----------------------------------------------------------------------
      # * Create Feature
      # * Creates the feature defined by loaded data
      #----------------------------------------------------------------------
      def create_feature(code, id, val)
        #puts "creating feature [#{code}, #{id}, #{val}]"
        return RPG::BaseItem::Feature.new(code, id, val)
      end
      
    end #class LoadFeature
    
    # ***********************************************************************
    # * LoadEffect Class                                                    *
    # * Extends NotetagLoadingConfiguration                                 *
    # * Defines a configuration for loading object effects from note tags   *
    #   of the object.                                                      *
    # ***********************************************************************
    class LoadEffect < NotetagLoadingConfiguration
      
      # *********************************************************************
      # * Constants                                                         *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Constants (Effect LoadGroup)
      #----------------------------------------------------------------------
      GROUP  = LoadGroup.new(LoadGroup::SKILLS, LoadGroup::ITEMS)
      
      # *********************************************************************
      # * Methods                                                           *
      # *********************************************************************
      #----------------------------------------------------------------------
      # * Object Initialization
      #----------------------------------------------------------------------
      def initialize(regexp_config, effect_code = nil, data_id = nil, value1 = nil, value2 = nil)
        super(regexp_config, GROUP)
        @effect_code = effect_code
        @data_id = data_id
        @value1 = value1
        @value2 = value2
      end
      
      #----------------------------------------------------------------------
      # * Load Notetag for Object
      #----------------------------------------------------------------------
      def load_notetag(obj)
        #adds a new effect to the data object upon which the notetag loading is applied
        #uses the effect code, data ID, value1, and value2 if specified
        #for nils, uses the results passed form the regexp config, in order
        super
        
        captures = @regexp_config.scan(obj.note)
        
        captures.each do |capture|
          #puts "Captured (#{capture}) for LoadEffect effect in #{obj.name}"
          
          code = (@effect_code.nil?() ? capture.shift : @effect_code)
          code = 0 if code.nil?   #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          id = (@data_id.nil?() ? capture.shift : @data_id)
          id = 0 if id.nil?       #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          val1 = (@value1.nil?() ? capture.shift : @value1)
          val1 = 0 if val1.nil?   #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          val2 = (@value2.nil?() ? capture.shift : @value2)
          val2 = 0 if val2.nil?   #Use default (0) if no value specified and nothing captured (capture.shift === nil)
          
          #Instead of creating the Effect object here, define a new method that
          #does it so it can be aliased/overwritten for future expansion, like with dynamic features
          obj.effects.push(create_effect(code, id, val1, val2))
        end
      end
      
      #----------------------------------------------------------------------
      # * Create Effect
      # * Creates the effect defined by loaded data
      #----------------------------------------------------------------------
      def create_effect(code, id, val1, val2)
        #puts "creating effect [#{code}, #{id}, #{val1}, #{val2}]"
        return RPG::UsableItem::Effect.new(code, id, val1, val2)
      end
      
    end #class LoadEffect

  end #module Loader
  
end #module Garryl


#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================
module DataManager
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  class << self
    alias garryl_loader_alias_datamanager_load_database     load_database
  end
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Load Database
  #--------------------------------------------------------------------------
  def self.load_database
    garryl_loader_alias_datamanager_load_database
    
    for load_configuration in Garryl::Loader::LOAD
      groups = load_configuration.load_group
      for group in groups
        for obj in group
          next if obj.nil?
#          next if obj.note == ""
          load_configuration.load_notetag(obj)
        end
      end
    end
  end
end #module DataManager


#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================
class Game_Map
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_loader_alias_game_map_setup                    setup
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup(map_id)
    garryl_loader_alias_game_map_setup(map_id)
    
    unless @map.nil?
#      unless @map.note == ""
        for load_configuration in Garryl::Loader::LOAD
          load_configuration.load_notetag(@map) if load_configuration.load_for_maps?
        end
#      end
    end
  end
end #class Game_Map
