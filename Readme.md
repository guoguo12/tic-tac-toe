# Tic-tac-toe in OCaml

This is a command-line, human-vs-computer implementation of [tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe).

The computer plays optimally using the [minimax algorithm](https://en.wikipedia.org/wiki/Minimax).

The computer will play optimally even if the state of the board guarantees that it will lose.
This is achieved by scaling the win/loss value of a leaf node (+1 or -1) by the depth of the minimax tree,
so that the agent will try to prolong the game as much as possible.
(See the "Fighting the Good Fight: Depth" section in [this article](http://neverstopbuilding.com/minimax).)

## Instructions

Clone this repo, run `make` to compile, then run `./game.native` to play.

You'll need to have [OCaml](https://ocaml.org/docs/install.html) installed, by the way.

## Dependencies

This project requires [Jane Street Core](https://github.com/janestreet/core).
