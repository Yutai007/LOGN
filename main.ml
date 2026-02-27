let sort arr =
  let n = Array.length arr in
  let result = Array.make n 0 in
  for i = 0 to n - 1 do
    let rank = ref 0 in
    for j = 0 to n - 1 do
      if arr.(j) < arr.(i) || (arr.(j) = arr.(i) && j < i)
      then incr rank
    done;
    result.(!rank) <- arr.(i)
  done;
  result
let () =
  let a = [|1; 5; 2; 1; 0|] in
  let sorted = sort a in
  Array.iter (fun x -> Printf.printf "%d " x) sorted;
  print_newline ()