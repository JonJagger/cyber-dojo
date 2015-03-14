Feature: hitch-hiker playing scrabble

Scenario: last earthling playing scrabble in the past
  Given the hitch-hiker selects some tiles
  When they spell 6 times 9
  Then the score is 42
