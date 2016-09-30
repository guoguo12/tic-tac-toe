open Core.Std;;

let index_of_coord x y = 3 * y + x

let get_row board y =
  List.map (List.range 0 3)
           (fun x -> board.(index_of_coord x y))

let get_col board x =
  List.map (List.range 0 3)
           (fun y -> board.(index_of_coord x y))

let get_main_diagonal board =
  List.map (List.range 0 3)
           (fun i -> board.(index_of_coord i i))

let get_secondary_diagonal board =
  List.map (List.range 0 3)
           (fun i -> board.(index_of_coord i (2 - i)))

let all_positions =
  [(0, 2); (1, 2); (2, 2);
   (0, 1); (1, 1); (2, 1);
   (0, 0); (1, 0); (2, 0)]

let get_successors board player =
  let get_successor x y =
    let new_board = Array.copy board in
    let index = index_of_coord x y in
    if new_board.(index) = 0 then (
      new_board.(index) <- player;
      [(x, y, new_board)]
    ) else []
  in
  List.map ~f:(fun (x, y) -> get_successor x y)
           all_positions
  |> List.concat
  |> Array.of_list

let get_all_sums board =
  let sum_list = List.fold ~init:0 ~f:(+) in
  List.map ~f:sum_list
           [(get_row board 0);
            (get_row board 1);
            (get_row board 2);
            (get_col board 0);
            (get_col board 1);
            (get_col board 2);
            (get_main_diagonal board);
            (get_secondary_diagonal board)]

let get_score board =
  (* The sum of three positions will be 3 or -3 if there is a winner *)
  let winners = List.filter (get_all_sums board) (fun x -> x = 3 || x = -3) in
  match winners with
  | [] -> 0
  | x :: _ -> x / 3

let board_full board =
  let number_of_open_positions =
    List.filter all_positions
                (fun (x, y) -> board.(index_of_coord x y) = 0)
    |> List.length
  in
  number_of_open_positions = 0

let show_board board player_starts =
  let mark_of_int = function
    | 1 -> if player_starts then " X " else " O "
    | -1 -> if player_starts then " O " else " X "
    | _ -> "   "
  in
  let print_row y =
    let marks = List.map ~f:mark_of_int (get_row board y) in
    Printf.printf "%d %s\n" y (String.concat marks ~sep:"|")
  in
  let print_divider () = Printf.printf "  -----------\n" in
  Printf.printf "\n=============================\n\n";
  print_row 2;
  print_divider ();
  print_row 1;
  print_divider ();
  print_row 0;
  Printf.printf "   0   1   2\n\n"
