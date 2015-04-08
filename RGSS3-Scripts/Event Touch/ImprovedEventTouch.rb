=begin
-------------------------------------------------------------------------------

Improved Event Touch
Version 1.0

Created: Feb. 22, 2015
Last update: Feb. 22, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script allows Event Touch trigger events to run when they move into the
player's space. The default RTP scripts only trigger when the event's movement
is blocked by the player, thus preventing events with either below or above
characters priority or with through movement enabled from triggering from their
own movement.

-------------------------------------------------------------------------------

Installation:

Copy into a new script slot in the Materials section.

-------------------------------------------------------------------------------

Usage Instructions:

N/A. No special action is required. This script only enhances existing
functionality in existing situations.

-------------------------------------------------------------------------------

Extended Description:

The purpose of this script is to make Event Touch events trigger when the
event moves underneath the player. Normally, Event Touch only triggers when
the event "bumps into" the player (ie: has its movement stopped by the player
or the impassability of the space the player is in). It does NOT trigger when
the event is allowed to move into the player's space (such as when the event 
has THROUGH checked or when priority is above or below characters).

Side note: Random move route doesn't try to bump into the player if it's not
already facing that direction. Any time the RNG decides for the event to move
in the direction of a space it can't move to, it won't turn. It will, however,
do the aforementioned bumping into the player, but only if it's already facing
that direction. If the event is facing away and RNG says to move into the
player, it will neither turn nor trigger.

Solution: Game_Player has code for checking when the player moves into events
with Player Touch and Event Touch triggers. It's a simple enough matter to
co-opt the same concepts for events. This script causes moving events to check
each update if they have finished moving, and if they have, to then check if
they are overlapping the player and thus should run if they have an Event Touch
trigger.

Ongoing Issues: This solution is not perfect, even though it works for my
purposes. There are still a few issues with the implementation, mostly stemming
from only checking at the end of movement.
- If the player and the event are moving into the same space at the same time,
  the event can trigger twice for the same single instance of movement, once
  when the player finishes moving and once when the event finishes moving.
  This would only happen if the event was a particularly quick one (for example,
  incrementing a variable) and finished processing in between the frames that
  each of the event and the player finished their movements in the overlapping
  square.
- If the player and the event cross paths, each one moving into the other's
  square at or near the same time (as long as the second one starts moving
  before the first finishes), the event won't trigger. It's just an unintuitive
  result, since you'd expect them moving through each other to be "overlapping"
  at some point.
Both of these issues require a lot more work to potentially resolve, including
deciding upon an actual solution. The most obvious fixes for each are
contradictory, even.

-------------------------------------------------------------------------------

References:
- Game_Event.update
- Game_Player.update
- Game_Player.update_nonmoving

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- Game_Event.update

The following functions are added to default script classes:
- Game_Event.check_event_trigger_touch_overlap
- Game_Event.update_nonmoving

-------------------------------------------------------------------------------
=end

class Game_Event < Game_Character
  
  #--------------------------------------------------------------------------
  # * Determine if Touch Event is Triggered
  # * Checks against player's x and y coordinates.
  # * Similar to check_event_trigger_touch, except ignores priority and
  #     uses this event's x/y coordinates by default.
  # * If no event is running in the main thread, and this event has
  #     an Event Touch type trigger, and it's in the same space as the player,
  #     and it's not in the middle of a jump (ie: jumping over the player),
  #     starts the event.
  #--------------------------------------------------------------------------
  def check_event_trigger_touch_overlap(x = @x, y = @y)
    return if $game_map.interpreter.running?
    if @trigger == 2 && $game_player.pos?(x, y)
      start if !jumping?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Processing When Not Moving
  #     last_moving : Was it moving previously?
  # * Similar to update_nonmoving in Game_Player, except stripped way down for
  #     only the things relevant to events. Specifically, triggering
  #     Event Touch upon ending movement.
  #--------------------------------------------------------------------------
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    if last_moving
      check_event_trigger_touch_overlap
    end
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  # * Modified function.
  # * Checks if the event has finished movement in this latest update and
  #     does things (like triggering event touch for overlap) if it has.
  #--------------------------------------------------------------------------
  def update
    # Added block
    last_moving = moving?
    # End added block
    super
    # Added block
    update_nonmoving(last_moving) unless moving?
    # End added block
    check_event_trigger_auto
    # Note: Only has its own interpreter if parallel process.
    # Just adding this comment so I don't get confused
    #    if I have to look over this again.
    return unless @interpreter
    @interpreter.setup(@list, @event.id) unless @interpreter.running?
    @interpreter.update
  end

end
