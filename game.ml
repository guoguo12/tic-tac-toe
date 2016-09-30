(** Tic-Tac-Toe in OCaml
    By Allen Guo  *)

open Core.Std;;
open Board;;

let rec prompt_for_move ?(show_hint=true) board =
  let rec prompt_for_coord name =
    Printf.printf "%s: " name;
    let a = read_int () in
      if a < 0 || a > 2 then (
        Printf.printf "Invalid coordinate. Try again.\n";
        prompt_for_coord name
      ) else a
  in
  Printf.printf (if show_hint then "It is now your turn.\n" else "");
  let x = prompt_for_coord "x" in
  let y = prompt_for_coord "y" in
  let index = index_of_coord x y in
  if board.(index) <> 0 then (
    Printf.printf "Position (%d, %d) is already occupied. Try again.\n" x y;
    prompt_for_move board ~show_hint:false
  ) else (x, y)

let ai_move board =
  let random_from_array items = items.(Random.int (Array.length items)) in
  let successors = get_successors board (-1) in
  let (x, y, _) = random_from_array successors in (x, y)

let new_game_state ~player_starts =
  let board = Array.create 9 0 in (player_starts, board, player_starts)

let rec run_game (player_turn, board, player_starts) =
  show_board board player_starts;
  (* Check if someone won *)
  let score = get_score board in
  if score <> 0 then (
    let winner = if score = 1 then "You" else "The computer" in
    Printf.printf "%s won.\n" winner
  ) else (
    (* Check if board is full *)
    if board_full board then (
      Printf.printf "Nobody won.\n"
    ) else (
      (* Process next move *)
      if player_turn then (
        let (x, y) = prompt_for_move board in
        Printf.printf "You mark (%d, %d).\n" x y;
        board.(index_of_coord x y) <- 1;
      ) else (
        let (x, y) = ai_move board in
        Printf.printf "The computer marks (%d, %d).\n" x y;
        board.(index_of_coord x y) <- -1;
      );
      run_game (not player_turn, board, player_starts)
    )
  )

let start_game =
  let player_starts =
    Random.self_init ();
    Random.bool ()
  in
  let state = new_game_state ~player_starts in
  let player_mark = if player_starts then "X" else "O" in
  Printf.printf "You are %s. X goes first.\n" player_mark;
  run_game state;;

start_game;;
