(**
 * Copyright (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

open Core
module Json = Hh_json

let print_result (name, pos) =
  let pos_str = Pos.string pos in
  print_endline (pos_str ^ " " ^ name);
  ()

let to_json input =
  let entries = List.map input begin fun (name, pos) ->
    let filename = Pos.filename pos in
    let line, start, end_ = Pos.info_pos pos in
    Json.JAssoc [ "name", Json.JString name;
                  "filename",  Json.JString filename;
                  "line",  Json.JInt line;
                  "char_start", Json.JInt start;
                  "char_end",Json.JInt end_;
                ]
  end in
  Json.JList entries

let print_json res =
  print_endline (Json.json_to_string (to_json res))

let print_readable res =
  List.iter res print_result;
  print_endline ((string_of_int (List.length res)) ^ " total results")

let go (res : ServerFindRefs.result) output_json =
  if output_json then
    print_json res
  else
    print_readable res
