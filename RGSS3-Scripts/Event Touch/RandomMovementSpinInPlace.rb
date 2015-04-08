=begin
-------------------------------------------------------------------------------

Random Movement Spin in Place
Version 1.0

Created: Feb. 22, 2015
Last update: Feb. 22, 2015

Author: Garryl

-------------------------------------------------------------------------------

Description:

This script causes random movement route events to visually turn when they try
to randomly move into an impassable space. It also causes Event Touch trigger
events to trigger when they turn around into the player as a result.

-------------------------------------------------------------------------------

Installation:

Copy into a new script slot in the Materials section.

-------------------------------------------------------------------------------

Usage Instructions:

N/A. No special action is required. This script only enhances existing
functionality in existing situations.

-------------------------------------------------------------------------------

Extended Description:

With random move route, any time the RNG decides for the event to move
in the direction of a space it can't move to, it won't turn. Mostly this is just
a cosmetic thing. Some people (myself included) like seeing NPCs turn in place
to indicate the direction they're trying to move, instead of standing stock
still when they can't move in the direction they want.

There is a practical aspect to this, however. Event Touch triggers only trigger
if the event bumps into the player. Without the turning, the random-movement
event only bumps into the player if it's already facing that way before trying
and failing to move. If the event is facing away and RNG says to move into the
player, it will not turn not trigger.

Side Note: The random move route (Game_Event.move_type_random) has a 2/6 chance
of moving in a random direction, a 3/6 chance of moving forwards, and a 1/6
chance of standing still. The 3/6 chance of moving forwards triggers touch
events just fine. It's the 2/6 chance of moving randomly that's the issue. This
script affects both that and the "Move at Random" custom move route command.

-------------------------------------------------------------------------------

References:
- Game_Character.move_random
- Game_Event.move_type_random

-------------------------------------------------------------------------------

Compatibility:

The following default script functions are overwritten:
- Game_Character.move_random

-------------------------------------------------------------------------------
=end

class Game_Character < Game_CharacterBase
  
  #--------------------------------------------------------------------------
  # * Move at Random
  #--------------------------------------------------------------------------
  def move_random
    #move_straight(2 + rand(4) * 2, false)
    move_straight(2 + rand(4) * 2)
  end

end
