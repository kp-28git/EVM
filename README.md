# Electronic Voting Machine (EVM) Module

This Verilog module implements an Electronic Voting Machine (EVM) for a four-party election system. The module allows users to cast votes for specific parties and displays voting results using a 7-segment display. It includes functionality to count votes for each party, show individual and total vote counts, and reset the system as needed.

## Table of Contents

- [Features](#features)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Module Functionality](#module-functionality)


## Features

- **Vote Casting**: Allows voting for four different parties using a switch interface.
- **Vote Confirmation**: Votes are counted upon pressing a button while `voting_en` (voting enable) is active.
- **Vote Reset**: Clears all vote counts with a reset signal.
- **7-Segment Display**: Shows the total votes and individual party votes in real time.

## Inputs

| Signal         | Width   | Description                                      |
| -------------- | ------- | ------------------------------------------------ |
| `voter_switch` | 4 bits  | 4-bit voting switch input, each bit represents a party (party 1-4). |
| `Push_Button`  | 1 bit   | Button to cast the vote for the selected party.  |
| `voting_en`    | 1 bit   | Enables/disables the voting process.             |
| `reset`        | 1 bit   | Resets the vote counts for all parties.          |
| `sw1` - `sw4`  | 1 bit each | Individual switches to select a party for viewing vote count. |
| `swout`        | 1 bit   | Enables display of total vote count for all parties. |

## Outputs

| Signal         | Width   | Description                                      |
| -------------- | ------- | ------------------------------------------------ |
| `dout`         | 7 bits  | Total vote count for all parties, max of 128 votes. |
| `v1`           | 5 bits  | Vote count for the currently selected party.     |
| `seg3`         | 7 bits  | Displays the party number (1-4) currently being voted for on a 7-segment display. |
| `seg2`         | 7 bits  | Shows the vote count for the selected party on a 7-segment display. |

## Module Functionality

1. **Vote Counting**: Each party has a dedicated vote counter, which increments by 1 each time `Push_Button` is pressed, given the conditions:
   - `voting_en` is active.
   - The respective bit in `voter_switch` is high (indicating the selected party).
   - When `reset` is high, all party counters are cleared.

2. **Total Vote Calculation**:
   - If `swout` is high and voting is enabled, `dout` displays the total votes across all parties.
   - The total vote count is limited to 7 bits, allowing a maximum displayable vote count of 128.

3. **7-Segment Display Control**:
   - The `seg3` output displays the party number (1-4) currently being voted for, using 7-segment encoding.
   - The `seg2` output displays the vote count for the selected party.
   - The `seven` function translates the binary vote count into 7-segment encoding.
