
# *****************************************************************************
# * Import marker key                                                         *
# *****************************************************************************
$imported ||= {}
$imported["Garryl"] ||= {}
$imported["Garryl"]["Battle Generalizations"] ||= {}
$imported["Garryl"]["Battle Generalizations"]["Version"] = "0.0.0.0"
$imported["Garryl"]["Battle Generalizations"]["BattlerBase"] = true
$imported["Garryl"]["Battle Generalizations"]["Battler"] = true
$imported["Garryl"]["Battle Generalizations"]["Actor"] = true
$imported["Garryl"]["Battle Generalizations"]["Enemy"] = true

module Garryl
  module BattleGeneralizations
    module Settings
      # ***********************************************************************
      # * Settings                                                            *
      # ***********************************************************************
      # * You can modify the variables here to fine tune your game.           *
      # ***********************************************************************
      
      #------------------------------------------------------------------------
      # * Parameters
      #------------------------------------------------------------------------
      # Defines the maximum and minimum parameters (after equipment, buffs,
      # states, and other modifiers) that a battler can have. Note that actors
      # can have maximum limits defined separately (see below).
      # Parameters            mhp     mmp    str   def   mat   mdf   agi   luk
      PARAM_MIN =        [      1,      0,     1,    1,    1,    1,    1,    1]
      PARAM_MAX =        [ 999999,   9999,   999,  999,  999,  999,  999,  999]
      
      # Defines the maximum parameters that actors can have.
      # Any negative value (less than 0) means that it will use the values
      # defined for battlers in general.
      # Parameters            mhp     mmp    str   def   mat   mdf   agi   luk
      ACTOR_PARAM_MAX =  [   9999,     -1,    -1,   -1,   -1,   -1,   -1,   -1]
        
      #------------------------------------------------------------------------
      # * Skills
      #------------------------------------------------------------------------
      ATTACK_SKILL_ID = 1   # The skill ID used for the default attack
      GUARD_SKILL_ID = 2    # The skill ID used for the guard  skill
      
      CRITICAL_MULTIPLIER = 3   # The amount by which damage is multiplied on
                                # a critical hit.
      
      # When guarding, damage taken is divided by (base + (multiplied * grd)).
      # Note: I recommend changing the formula from the default of dividing by
      # 2*grd (base = 0, mult = 2) to dividing by 1+grd (base = 1, mult = 1).
      # This produces a lesser effect for high grd rates, but no longer
      # increases damage taken while guarding when grd is below 50%.
      GUARD_BASE_DIVISOR = 0
      GUARD_MULTIPLIED_DIVISOR = 2
      
      #------------------------------------------------------------------------
      # * States
      #------------------------------------------------------------------------
      DEATH_STATE_ID = 1    # The state ID used for the death state
      
      # Lets you calculate the effect rate using the differences of any
      # combination of parameters, each with different weights. 
      # Takes the place of luk effect rate in the default scripts.
      # Rate per param point      mhp   mmp   str   def   mat   mdf   agi   luk
      EFFECT_RATE_PARAM_DIFF = [  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.001]
      
      EFFECT_RATE_DIFFERENT_STATS_MULTIPLICATIVE = false
                #If true, the increases or decreases of multiple stats that
                # apply to the effect rate will be multiplicative with each
                # other. If false, they will be additive.
      
      STATE_ADD_IGNORES_STATE_RATE_OF_FRIENDLIES = true
                #If true, state rate will be ignored when calculating
                # application chance on friendly targets (except reflected
                # magic skills).
      
      STATE_ADD_IGNORES_EFFECT_RATE_PARAM_DIFF_OF_FRIENDLIES = true
                #If true, param difference effect rate will be ignored when
                # calculating application chance on friendly targets (except
                # reflected magic skills).
      
      #------------------------------------------------------------------------
      # * Buffs
      #------------------------------------------------------------------------
      # Defines the percentage effect of buffs and debuffs on each parameter.
      # Parameters            mhp     mmp    str   def   mat   mdf   agi   luk
      BUFF_PCT_PLUS =    [     25,     25,    25,   25,   25,   25,   25,   25]
      DEBUFF_PCT_MINUS = [     25,     25,    25,   25,   25,   25,   25,   25]
      
      # Defines the maximum amount of buff/debuff stacks that a battler can
      # have at once. The percentage effect of buffs and debuffs on each
      # parameter are defined separately (see Garryl_BattlerBase).
      # Note: Make sure to change buff_icon_index in Game_BattlerBase to get
      # the correct icons if you change the maximum beyond 2.
      # Parameters    mhp   mmp   str   def   mat   mdf   agi   luk
      BUFF_MAX =    [   2,    2,    2,    2,    2,    2,    2,    2]
      DEBUFF_MAX =  [   2,    2,    2,    2,    2,    2,    2,    2]
      
      #------------------------------------------------------------------------
      # * TP
      #------------------------------------------------------------------------
      TP_MAX = 100          # The maximum amount of TP a battler can store
      
      TP_INIT_MIN = 0       # For battlers without the "preserve TP" flag, sets
      TP_INIT_MAX = 24      # tp to a random amount from min to max at the
                            # start of battle.
      
      TP_BASE_CHARGE_FACTOR = 50  # Multiplied by the % of max hp in damage
                                  # taken to determine tp generated when taking
                                  # damage.
      
      #------------------------------------------------------------------------
      # * Common Events
      #------------------------------------------------------------------------
      # When a skill or item calls a common event as part of its effects, this
      # lets the user and targets' indices be saved into game variables that
      # can then be referenced by the event.
      # Set the variable ID to 0 or less to disable.
      # Actor indices are stored as positive numbers.
      # Enemy indices are stored as the negative of the actual index.
      COMMON_EVENT_USER_VARIABLE_ID = 0     # Variable ID into which skill or
                                            # item's user's index is stored.
      COMMON_EVENT_TARGET_VARIABLE_ID = 0   # Variable ID into which skill or
                                            # item's target's index is stored.
      # TODO: Not sure if this works. Need to check the timing of things. It's
      # possible the common event gets run before the variables get set, since
      # the part where the common event gets called upon and the part where the
      # targeting data is available are different.
      
      #------------------------------------------------------------------------
      # * Experience
      #------------------------------------------------------------------------
      RESERVE_MEMBER_EXP_RATE = 1.0   # If "Reserve Member Experience" is
                                      # selected, non-battling party members
                                      # will receive this fraction of the
                                      # normal experience. They still receive
                                      # nothing if it's not checked.
      
      #------------------------------------------------------------------------
      # * Steps
      #------------------------------------------------------------------------
      STEPS_FOR_TURN = 20       # Number of steps outside of battle to become
                                # equivalent to one turn in battle for end of
                                # turn effects, like automatic regeneration,
                                # state clearing (for states that persist out
                                # of combat), etc.
                                # Minimum 1. Integer only.
      
      #------------------------------------------------------------------------
      # * Floor Damage
      #------------------------------------------------------------------------
      FLOOR_DAMAGE_BASE = 10    # Base damage dealt to all actors in the party
                                # with each step over a damage tile
      
      #------------------------------------------------------------------------
      # * Action Selection
      #------------------------------------------------------------------------
      ACTION_RATING_RANGE = 3   # Total range of action ratings that will be
                                # passed to select_enemy_action when
                                # determining what action to take.
                                # In other words, anything of a rating equal
                                # to or less than the highest rating minus
                                # this value will be ignored.
                                # If you want, for example, to only have
                                # enemies use the highest rating action, set
                                # this to 1.
                                # Minimum 1.
      
      # ***********************************************************************
      # * End of Settings                                                     *
      # ***********************************************************************
    end
  end
  
  
  module BattlerBase
    module Settings
      DEATH_STATE_ID = Garryl::BattleGeneralizations::Settings::DEATH_STATE_ID.to_i
      ATTACK_SKILL_ID = Garryl::BattleGeneralizations::Settings::ATTACK_SKILL_ID.to_i
      GUARD_SKILL_ID = Garryl::BattleGeneralizations::Settings::GUARD_SKILL_ID.to_i
      PARAM_MIN = Garryl::BattleGeneralizations::Settings::PARAM_MIN
      PARAM_MAX = Garryl::BattleGeneralizations::Settings::PARAM_MAX
      BUFF_PCT_PLUS = Garryl::BattleGeneralizations::Settings::BUFF_PCT_PLUS
      DEBUFF_PCT_MINUS = Garryl::BattleGeneralizations::Settings::DEBUFF_PCT_MINUS
      MAX_TP = Garryl::BattleGeneralizations::Settings::TP_MAX
    end
  end
  
  module Battler
    module Settings
      TP_INIT_MIN = Garryl::BattleGeneralizations::Settings::TP_INIT_MIN
      TP_INIT_MAX = Garryl::BattleGeneralizations::Settings::TP_INIT_MAX
      TP_BASE_CHARGE_FACTOR = Garryl::BattleGeneralizations::Settings::TP_BASE_CHARGE_FACTOR
      STATE_ADD_IGNORES_STATE_RATE_OF_FRIENDLIES = Garryl::BattleGeneralizations::Settings::STATE_ADD_IGNORES_STATE_RATE_OF_FRIENDLIES
      STATE_ADD_IGNORES_EFFECT_RATE_PARAM_DIFF_OF_FRIENDLIES = Garryl::BattleGeneralizations::Settings::STATE_ADD_IGNORES_EFFECT_RATE_PARAM_DIFF_OF_FRIENDLIES
      BUFF_MAX = Garryl::BattleGeneralizations::Settings::BUFF_MAX
      DEBUFF_MAX = Garryl::BattleGeneralizations::Settings::DEBUFF_MAX
      CRITICAL_MULTIPLIER = Garryl::BattleGeneralizations::Settings::CRITICAL_MULTIPLIER
      GUARD_BASE_DIVISOR = Garryl::BattleGeneralizations::Settings::GUARD_BASE_DIVISOR
      GUARD_MULTIPLIED_DIVISOR = Garryl::BattleGeneralizations::Settings::GUARD_MULTIPLIED_DIVISOR
      EFFECT_RATE_PARAM_DIFF = Garryl::BattleGeneralizations::Settings::EFFECT_RATE_PARAM_DIFF
      EFFECT_RATE_DIFFERENT_STATS_MULTIPLICATIVE = Garryl::BattleGeneralizations::Settings::EFFECT_RATE_DIFFERENT_STATS_MULTIPLICATIVE
      COMMON_EVENT_USER_VARIABLE_ID = Garryl::BattleGeneralizations::Settings::COMMON_EVENT_USER_VARIABLE_ID.to_i
      COMMON_EVENT_TARGET_VARIABLE_ID = Garryl::BattleGeneralizations::Settings::COMMON_EVENT_TARGET_VARIABLE_ID.to_i
    end
  end
  
  module Actor
    module Settings
      PARAM_MAX = Garryl::BattleGeneralizations::Settings::ACTOR_PARAM_MAX
      RESERVE_MEMBER_EXP_RATE = Garryl::BattleGeneralizations::Settings::RESERVE_MEMBER_EXP_RATE
      STEPS_FOR_TURN = Garryl::BattleGeneralizations::Settings::STEPS_FOR_TURN
      FLOOR_DAMAGE_BASE = Garryl::BattleGeneralizations::Settings::FLOOR_DAMAGE_BASE
    end
  end
  
  module Enemy
    module Settings
      ACTION_RATING_RANGE = [Garryl::BattleGeneralizations::Settings::ACTION_RATING_RANGE, 1].max.to_i
    end
  end
end

class Game_BattlerBase
  
  # *************************************************************************
  # * Aliases                                                               *
  # *************************************************************************
  alias garryl_alias_game_battlerbase_initialize       initialize
  
  # *************************************************************************
  # * Hook Functions                                                        *
  # *************************************************************************
  # * These functions do things that you might normally do more directly or *
  # * provide a predefined function within the process of a complex action. *
  # * Performing them through these functions allows their functionality to *
  # * more easily be extended by other scripts. Simply alias the function   *
  # * and put your code before and/or after the call to the hook.           *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Overwrite or alias to perform actions to perform when hiding occurs.
  # * Runs at the start of hiding, after @hiding is set but before @hidden
  #   is set.
  #--------------------------------------------------------------------------
  def on_hide_pre
  end
  
  #--------------------------------------------------------------------------
  # * Overwrite or alias to perform actions to perform when hiding occurs.
  # * Runs at the end of hiding, after @hidden is set but before @hiding is
  #   cleared.
  #--------------------------------------------------------------------------
  def on_hide_post
  end
  
  #--------------------------------------------------------------------------
  # * Overwrite or alias to perform actions to perform when appearing occurs.
  # * Runs at the start of hiding, after @appearing is set but before @hidden
  #   is cleared.
  #--------------------------------------------------------------------------
  def on_appear_pre
  end
  
  #--------------------------------------------------------------------------
  # * Overwrite or alias to perform actions to perform when appearing occurs.
  # * Runs at the end of hiding, after @hidden is cleared but before
  #   @appearing is cleared.
  #--------------------------------------------------------------------------
  def on_appear_post
  end
  
  # *************************************************************************
  # * Aliased Functions                                                     *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @hiding = false
    @appearing = false
    garryl_alias_game_battlerbase_initialize
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get State ID of K.O.
  #--------------------------------------------------------------------------
  def death_state_id
    return Garryl::BattlerBase::Settings::DEATH_STATE_ID
  end
  #--------------------------------------------------------------------------
  # * Get Reduced Value of Parameter
  #--------------------------------------------------------------------------
  def param_min(param_id)
    return Garryl::BattlerBase::Settings::PARAM_MIN[param_id]
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Parameter
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return Garryl::BattlerBase::Settings::PARAM_MAX[param_id]
  end
  #--------------------------------------------------------------------------
  # * Get Rate of Change Due to Parameter Buff/Debuff
  #--------------------------------------------------------------------------
  def param_buff_rate(param_id)
    return (1.0 + @buffs[param_id] * Garryl::BattlerBase::Settings::BUFF_PCT_PLUS[param_id])    if @buffs[param_id] > 0
    return (1.0 - @buffs[param_id] * Garryl::BattlerBase::Settings::DEBUFF_PCT_MINUS[param_id]) if @buffs[param_id] < 0
    return (1.0)
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of TP
  #--------------------------------------------------------------------------
  def max_tp
    return Garryl::BattlerBase::Settings::MAX_TP
  end
  #--------------------------------------------------------------------------
  # * Get Percentage of TP
  #--------------------------------------------------------------------------
  def tp_rate
    @tp.to_f / max_tp
  end
  #--------------------------------------------------------------------------
  # * Hide
  #--------------------------------------------------------------------------
  def hide
    if (!hidden?)
      @hiding = true
      on_hide_pre
    end
    @hidden = true
    if @hiding
      on_hide_post
      @hiding = false
    end
  end
  #--------------------------------------------------------------------------
  # * Appear
  #--------------------------------------------------------------------------
  def appear
    if (hidden?)
      @appearing = true
      on_appear_pre
    end
    @hidden = false
    if @appearing
      on_appear_post
      @appearing = false
    end
  end
  #--------------------------------------------------------------------------
  # * Get Skill ID of Normal Attack
  #--------------------------------------------------------------------------
  def attack_skill_id
    return Garryl::BattlerBase::Settings::ATTACK_SKILL_ID
  end
  #--------------------------------------------------------------------------
  # * Get Skill ID of Guard
  #--------------------------------------------------------------------------
  def guard_skill_id
    return Garryl::BattlerBase::Settings::GUARD_SKILL_ID
  end
end



class Game_Battler < Game_BattlerBase
  
  # *************************************************************************
  # * New Functions                                                         *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Calculate effect rate change by stats - Additive
  #--------------------------------------------------------------------------
  def effect_rate_additive(user)
    rateMultiplier = 1.0
    Garryl::Battler::Settings::EFFECT_RATE_PARAM_DIFF.each_index { |i| rateMultiplier += (user.param(i) - param(i)) * Garryl::Battler::Settings::EFFECT_RATE_PARAM_DIFF[i] }
    return [rateMultiplier, 0.0].max
  end
  
  #--------------------------------------------------------------------------
  # * Calculate effect rate change by stats - Multiplicative
  #--------------------------------------------------------------------------
  def effect_rate_multiplicative(user)
    rateMultiplier = 1.0
    Garryl::Battler::Settings::EFFECT_RATE_PARAM_DIFF.each_index { |i| rateMultiplier *= [1.0 + (user.param(i) - param(i)) * Garryl::Battler::Settings::EFFECT_RATE_PARAM_DIFF[i], 0.0].max }
    return [rateMultiplier, 0.0].max
  end
  
  # *************************************************************************
  # * Hook Functions                                                        *
  # *************************************************************************
  # * These functions do things that you might normally do more directly or *
  # * provide a predefined function within the process of a complex action. *
  # * Performing them through these functions allows their functionality to *
  # * more easily be extended by other scripts. Simply alias the function   *
  # * and put your code before and/or after the call to the hook.           *
  # *************************************************************************
  # * Note: Many of these function calls specify a user. Typically, this is *
  # * the battler (friendly or opponent) that applies the effect the        *
  # * battler calling the function. However, in some cases there is no      *
  # * other battler (ex: floor damage), so make sure your calls can handle  *
  # * a nil value.                                                          *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Applies HP damage (or healing if negative)
  #--------------------------------------------------------------------------
  def apply_hp_damage(damage, user = nil, item = nil, perform_on_damage = false)
    on_damage(damage) if damage > 0 && perform_on_damage
    self.hp -= damage
  end
  
  #--------------------------------------------------------------------------
  # * Applies MP damage (or restoration if negative)
  #--------------------------------------------------------------------------
  def apply_mp_damage(damage, user = nil, item = nil, perform_on_damage = false)
    on_damage(damage) if damage > 0 && perform_on_damage
    self.mp -= damage
  end
  
  #--------------------------------------------------------------------------
  # * Applies TP damage (or gain if negative)
  #--------------------------------------------------------------------------
  def apply_tp_damage(damage, user = nil, item = nil, perform_on_damage = false)
    on_damage(damage) if damage > 0 && perform_on_damage
    self.tp -= damage
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to apply a state
  #--------------------------------------------------------------------------
  def apply_add_state(state_id, user = nil, item = nil)
    add_state(state_id)
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to remove a state
  #--------------------------------------------------------------------------
  def apply_remove_state(state_id, user = nil, item = nil)
    remove_state(state_id)
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to apply a buff
  #--------------------------------------------------------------------------
  def apply_add_buff(param_id, duration, user = nil, item = nil)
    add_buff(param_id, duration)
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to apply a debuff
  #--------------------------------------------------------------------------
  def apply_add_debuff(param_id, duration, user = nil, item = nil)
    add_debuff(param_id, duration)
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to remove a buff
  #--------------------------------------------------------------------------
  def apply_remove_buff(param_id, user = nil, item = nil)
    remove_buff(param_id) if @buffs[effect.data_id] > 0
  end
  
  #--------------------------------------------------------------------------
  # * Attempts to apply a debuff
  #--------------------------------------------------------------------------
  def apply_remove_debuff(param_id, user = nil, item = nil)
    remove_buff(param_id) if @buffs[effect.data_id] < 0
  end
  
  #--------------------------------------------------------------------------
  # * Applies a permanent change to a battler's params
  #--------------------------------------------------------------------------
  def apply_grow(param_id, value, user = nil, item = nil)
    add_param(param_id, value)
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to apply a state to this battler
  #--------------------------------------------------------------------------
  def calculate_add_state_chance(user, item, effect, state_id, normal_attack = false)
    chance = effect.value1
    
    if (normal_attack)
      chance *= user.atk_states_rate(state_id)
      chance *= state_rate(state_id)
      chance *= luk_effect_rate(user)
    elsif (opposite?(user))
      chance *= state_rate(state_id) unless !Garryl::Battler::Settings::STATE_ADD_IGNORES_STATE_RATE_OF_FRIENDLIES
      chance *= luk_effect_rate(user) unless !Garryl::Battler::Settings::STATE_ADD_IGNORES_EFFECT_RATE_PARAM_DIFF_OF_FRIENDLIES
    end

    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to remove a state from this battler
  #--------------------------------------------------------------------------
  def calculate_remove_state_chance(user, item, effect, state_id, normal_attack = false)
    chance = effect.value1
    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to add a buff to this battler
  #--------------------------------------------------------------------------
  def calculate_add_buff_chance(user, item, effect, buff_id, normal_attack = false)
    chance = 1.0
    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to add a debuff to this battler
  #--------------------------------------------------------------------------
  def calculate_add_debuff_chance(user, item, effect, debuff_id, normal_attack = false)
    chance = 1.0
    chance *= debuff_rate(effect.data_id)
    chance *= luk_effect_rate(user)
    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to remove a buff from this battler
  #--------------------------------------------------------------------------
  def calculate_remove_buff_chance(user, item, effect, buff_id, normal_attack = false)
    chance = 1.0
    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the chance to remove a debuff from this battler
  #--------------------------------------------------------------------------
  def calculate_remove_debuff_chance(user, item, effect, debuff_id, normal_attack = false)
    chance = 1.0
    return chance
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the amount of HP regenerated per turn
  #--------------------------------------------------------------------------
  def calculate_hp_regen
    return (mhp * hrg).to_i
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the amount of MP regenerated per turn
  #--------------------------------------------------------------------------
  def calculate_mp_regen
    return (mmp * mrg).to_i
  end
  
  #--------------------------------------------------------------------------
  # * Calculates the amount of TP regenerated per turn
  #--------------------------------------------------------------------------
  def calculate_tp_regen
    return (max_tp * trg).to_i
  end
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Determine if Buff Is at Maximum Level
  #--------------------------------------------------------------------------
  def buff_max?(param_id)
    @buffs[param_id] >= Garryl::Battler::Settings::BUFF_MAX[param_id]
  end
  #--------------------------------------------------------------------------
  # * Determine if Debuff Is at Maximum Level
  #--------------------------------------------------------------------------
  def debuff_max?(param_id)
    @buffs[param_id] <= (-Garryl::Battler::Settings::DEBUFF_MAX[param_id])
  end
  #--------------------------------------------------------------------------
  # * Apply Critical
  #--------------------------------------------------------------------------
  def apply_critical(damage)
    damage * Garryl::Battler::Settings::CRITICAL_MULTIPLIER
  end
  #--------------------------------------------------------------------------
  # * Applying Guard Adjustment
  #--------------------------------------------------------------------------
  def apply_guard(damage)
#    damage / (damage > 0 && guard? ? 2 * grd : 1)
    damage / (damage > 0 && guard? ? (Garryl::Battler::Settings::GUARD_BASE_DIVISOR + Garryl::Battler::Settings::GUARD_MULTIPLIED_DIVISOR * grd) : 1)
  end
  #--------------------------------------------------------------------------
  # * Damage Processing
  #    @result.hp_damage @result.mp_damage @result.hp_drain
  #    @result.mp_drain must be set before call.
  #--------------------------------------------------------------------------
  def execute_damage(user, item = nil)
    apply_hp_damage(@result.hp_damage, user, item, true)
    apply_mp_damage(@result.mp_damage, user, item)
    user.apply_hp_damage(-@result.hp_drain, user, item)
    user.apply_mp_damage(-@result.mp_drain, user, item)
  end
  #--------------------------------------------------------------------------
  # * [HP Recovery] Effect
  #--------------------------------------------------------------------------
  def item_effect_recover_hp(user, item, effect)
    value = (mhp * effect.value1 + effect.value2) * rec
    value *= user.pha if item.is_a?(RPG::Item)
    value = value.to_i
    @result.hp_damage -= value
    @result.success = true
    apply_hp_damage(-value, user, item)
  end
  #--------------------------------------------------------------------------
  # * [MP Recovery] Effect
  #--------------------------------------------------------------------------
  def item_effect_recover_mp(user, item, effect)
    value = (mmp * effect.value1 + effect.value2) * rec
    value *= user.pha if item.is_a?(RPG::Item)
    value = value.to_i
    @result.mp_damage -= value
    @result.success = true if value != 0
    apply_mp_damage(-value, user, item)
  end
  #--------------------------------------------------------------------------
  # * [TP Gain] Effect
  #--------------------------------------------------------------------------
  def item_effect_gain_tp(user, item, effect)
    value = effect.value1.to_i
    @result.tp_damage -= value
    @result.success = true if value != 0
    apply_tp_damage(-value, user, item)
  end
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal Attack
  #--------------------------------------------------------------------------
  def item_effect_add_state_attack(user, item, effect)
    user.atk_states.each do |state_id|
      chance = calculate_add_state_chance(user, item, effect, state_id, true)
      if rand < chance
        apply_add_state(state_id, user, item)
        @result.success = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal
  #--------------------------------------------------------------------------
  def item_effect_add_state_normal(user, item, effect)
    chance = calculate_add_state_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_add_state(effect.data_id, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove State] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_state(user, item, effect)
    #chance = effect.value1
    chance = calculate_remove_state_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_remove_state(effect.data_id, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Buff] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_buff(user, item, effect)
    chance = calculate_add_buff_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_add_buff(effect.data_id, effect.value1, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Debuff] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_debuff(user, item, effect)
    chance = calculate_add_debuff_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_add_debuff(effect.data_id, effect.value1, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove Buff] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_buff(user, item, effect)
    chance = calculate_remove_buff_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_remove_buff(effect.data_id, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove Debuff] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_debuff(user, item, effect)
    chance = calculate_remove_debuff_chance(user, item, effect, effect.data_id)
    if rand < chance
      apply_remove_debuff(effect.data_id, user, item)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Raise Parameter] Effect
  #--------------------------------------------------------------------------
  def item_effect_grow(user, item, effect)
    apply_grow(effect.data_id, effect.value1.to_i, user, item)
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Common Event] Effect
  #--------------------------------------------------------------------------
  def item_effect_common_event(user, item, effect)
    $game_variables[Garryl::Battler::Settings::COMMON_EVENT_TARGET_VARIABLE_ID] = (actor? ? index : -index) if (Garryl::Battler::Settings::COMMON_EVENT_TARGET_VARIABLE_ID > 0)
    $game_variables[Garryl::Battler::Settings::COMMON_EVENT_USER_VARIABLE_ID] = (user.actor? ? user.index : -user.index) if (Garryl::Battler::Settings::COMMON_EVENT_USER_VARIABLE_ID > 0)
  end
  #--------------------------------------------------------------------------
  # * Get Effect Change Rate by Luck
  #--------------------------------------------------------------------------
  def luk_effect_rate(user)
    return Garryl::Battler::Settings::EFFECT_RATE_DIFFERENT_STATS_MULTIPLICATIVE ? effect_rate_multiplicate(user) : effect_rate_additive(user)
  end
  #--------------------------------------------------------------------------
  # * Initialize TP
  #--------------------------------------------------------------------------
  def init_tp
    self.tp = [rand(Garryl::Battler::Settings::TP_INIT_MAX - Garryl::Battler::Settings::TP_INIT_MIN) + Garryl::Battler::Settings::TP_INIT_MIN, 0].max
  end
  #--------------------------------------------------------------------------
  # * Charge TP by Damage Suffered
  #--------------------------------------------------------------------------
  def charge_tp_by_damage(damage_rate)
    self.tp += Garryl::Battler::Settings::TP_BASE_CHARGE_FACTOR * damage_rate * tcr
  end
  #--------------------------------------------------------------------------
  # * Regenerate HP
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -calculate_hp_regen
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    #self.hp -= @result.hp_damage
    apply_hp_damage(@result.hp_damage, self)
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Slip Damage
  #--------------------------------------------------------------------------
  def max_slip_damage
    $data_system.opt_slip_death ? hp : [hp - 1, 0].max
  end
  #--------------------------------------------------------------------------
  # * Regenerate MP
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -calculate_mp_regen
    #self.mp -= @result.mp_damage
    apply_mp_damage(@result.mp_damage, self)
  end
  #--------------------------------------------------------------------------
  # * Regenerate TP
  #--------------------------------------------------------------------------
  def regenerate_tp
    #self.tp += 100 * trg
    tp_damage = -calculate_tp_regen
    apply_tp_damage(tp_damage, self)
  end
end




class Game_Actor < Game_Battler
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Parameter
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return Garryl::Actor::Settings::PARAM_MAX[param_id] if (Garryl::Actor::Settings::PARAM_MAX[param_id] >= 0)
    return super
  end
  #--------------------------------------------------------------------------
  # * Get EXP Rate for Reserve Members
  #--------------------------------------------------------------------------
  def reserve_members_exp_rate
    $data_system.opt_extra_exp ? Garryl::Actor::Settings::RESERVE_MEMBER_EXP_RATE : 0
  end
  #--------------------------------------------------------------------------
  # * Number of Steps Regarded as One Turn in Battle
  #--------------------------------------------------------------------------
  def steps_for_turn
    return [Garryl::Actor::Settings::STEPS_FOR_TURN.to_i, 1].max
  end
  #--------------------------------------------------------------------------
  # * Floor Damage Processing
  #--------------------------------------------------------------------------
  def execute_floor_damage
    damage = (basic_floor_damage * fdr).to_i
    #self.hp -= [damage, max_floor_damage].min
    apply_hp_damage([damage, max_floor_damage].min)
    perform_map_damage_effect if damage > 0
  end
  #--------------------------------------------------------------------------
  # * Get Base Value for Floor Damage
  #--------------------------------------------------------------------------
  def basic_floor_damage
    return Garryl::Actor::Settings::FLOOR_DAMAGE_BASE
  end
end


class Game_Enemy < Game_Battler
  
  # *************************************************************************
  # * Overwritten Functions                                                 *
  # *************************************************************************
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def make_actions
    super
    return if @actions.empty?
    action_list = enemy.actions.select {|a| action_valid?(a) }
    return if action_list.empty?
    rating_max = action_list.collect {|a| a.rating }.max
    rating_zero = rating_max - Garryl::Enemy::Settings::ACTION_RATING_RANGE
    action_list.reject! {|a| a.rating <= rating_zero }
    @actions.each do |action|
      action.set_enemy_action(select_enemy_action(action_list, rating_zero))
    end
  end
end
