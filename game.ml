(** Tic-Tac-Toe in OCaml
    By Allen Guo *)

open Core.Std;;

(** Ask user for coordinates of next move, repeating the prompt until the
    response is a valid location. *)
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
  if Board.get_item board x y <> 0 then (
    Printf.printf "Position (%d, %d) is occupied. Try again.\n" x y;
    prompt_for_move board ~show_hint:false
  ) else (x, y)

(** Returns the coordinates of an optimal move for the given board.
    Uses the minimax algorithm. *)
let ai_move board =
  let third (_, _, x) = x in
  let min_on_third t1 t2 = if third t2 < third t1 then t2 else t1 in
  (* Computes the minimax value of a min-node *)
  let rec min_value depth board =
    let successors = Board.get_successors board (-1) in
    if Board.get_score board <> 0 then
      (Board.get_score board) * depth
    else if Array.length successors = 0 then
      0
    else
      Array.map third successors
      |> Array.map ~f:(max_value (depth + 1))
      |> Array.fold ~init:Int.max_value ~f:min
  (* Computes the minimax value of a max-node *)
  and max_value depth board =
    let successors = Board.get_successors board 1 in
    if Board.get_score board <> 0 then
      (Board.get_score board) * depth
    else if Array.length successors = 0 then
      0
    else
      Array.map third successors
      |> Array.map ~f:(min_value depth)
      |> Array.fold ~init:Int.min_value ~f:max
  in
  (* Pick an optimal action *)
  Board.get_successors board (-1)
  |> Array.map ~f:(fun (x, y, new_board) -> (x, y, max_value 1 new_board))
  |> Array.fold ~init:(-1, -1, Int.max_value) ~f:min_on_third
  |> (fun (x, y, _) -> (x, y))

(** Returns a new game state. *)
let new_game_state ~player_starts =
  let board = Board.new_board () in (player_starts, board, player_starts)

(** This is the main game loop. *)
let rec run_game (player_turn, board, player_starts) =
  (* Display board *)
  Board.show_board board player_starts;
  (* Check if someone won *)
  let score = Board.get_score board in
  if score <> 0 then (
    let winner = if score = 1 then "You" else "The computer" in
    Printf.printf "%s won.\n" winner
  ) else (
    (* Check if board is full *)
    if Board.board_full board then (
      Printf.printf "Nobody won.\n"
    ) else (
      (* Process next move *)
      if player_turn then (
        let (x, y) = prompt_for_move board in
        Printf.printf "You mark (%d, %d).\n" x y;
        Board.set_item board x y 1;
      ) else (
        let (x, y) = ai_move board in
        Printf.printf "The computer marks (%d, %d).\n" x y;
        Board.set_item board x y (-1);
      );
      (* Recurse, but switch whose turn it is *)
      run_game (not player_turn, board, player_starts)
    )
  )

(** This starts the game. *)
let _ =
  let player_starts =
    Random.self_init ();
    Random.bool ()
  in
  let state = new_game_state ~player_starts in
  let player_mark = if player_starts then "X" else "O" in
  Printf.printf "You are %s. X goes first.\n" player_mark;
  run_game state;;
