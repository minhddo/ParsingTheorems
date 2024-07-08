signature CONVERTER =
sig 
	(* val convert_entry_to_prop: Proofterm.thm_id * Thm_Name.T -> term  *)
	val find_all_theorems: theory -> (term * string) list;
	(* val get_term_format: term -> 'a *)
	val convert_Typ: Term.typ -> string
(* 	val convert_TFree: Term.typ -> string
	val convert_Type: Term.typ -> string
	val convert_TVar: Term.typ -> string *)
	val convert_Term: Term.term -> string
(* 	val convert_Const: Term.term -> string
	val convert_Free: Term.term -> string
	val convert_Var: Term.term -> string
	val convert_Abs: Term.term -> string
	val convert_App: Term.term -> string *)
end;
  (*Consts: val consts_of: Proof.context -> Consts.T *)
structure Converter: CONVERTER =
struct

(*

val dest_thm_names: theory -> (Proofterm.thm_id * Thm_Name.T) list
  type thm_id = {serial: serial, theory_name: string}
  type T = string * int
val get_thm_names: theory -> Thm_Name.T Inttab.table
	type T = string * int
	type 'a table
	structure Inttab = Table(type key = int val ord = int_ord);
val full_prop_of: thm -> term 

*)

fun find_all_theorems thy = 
	thy |> Global_Theory.dest_thm_names
		|> map snd
		|> map (fn thm_nameT => (Global_Theory.get_thm_name thy (thm_nameT, Position.none), fst thm_nameT)) (* Keeping the theorem name for further reference *)
		|> map (fn thm_and_name => (Thm.full_prop_of (fst thm_and_name), snd thm_and_name));

fun convert_TFree (TFree (name, typ)) = 
	"type_signature=\"TFree\" type_name=\"" ^ name ^ "\" ";
fun convert_Type (Type (name, list_typ)) = 
	"type_signature=\"Type\" type_name=\"" ^ name ^ "\" ";
fun convert_TVar (TVar ((stringz, intz), sor)) =
	"type_signature=\"TVar\" type_name=\"" ^ stringz ^ "\" type_index=\"" ^ (Int.toString intz) ^ "\" "; 

fun convert_Typ (TFree t) = convert_TFree (TFree t)
  | convert_Typ (Type t) =  convert_Type (Type t)
  | convert_Typ (TVar t) = convert_TVar (TVar t);


fun convert_Const (Const (name, typ)) = 
	"<tree type=\"Const\" name=\"" ^ name ^ "\" " ^ (convert_Typ typ) ^ "></tree>"
  | convert_Const u = ""; 
fun convert_Free (Free (name, typ)) =
	"<tree type=\"Free\" name=\"" ^ name ^ "\" " ^ (convert_Typ typ) ^ "></tree>"
  | convert_Free u = "";
fun convert_Var (Var ((name, ind), typ)) =
	"<tree type=\"Var\" name=\"" ^ name ^ "\" var_index=\"" ^ (Int.toString ind) ^ "\" " ^ (convert_Typ typ) ^ "></tree>"
  | convert_Var u = "";
fun convert_Bound (Bound i) = 
	"<tree type=\"Bound\" bound_index=\"" ^ (Int.toString i) ^ "\"></tree>"
fun convert_Abs (Abs (var_name, typ, term)) =
	"<tree type=\"Abs\" var_name=\"" ^ var_name ^ "\" " ^ (convert_Typ typ) ^ ">\n\t" ^ (convert_Term term) ^ "\n</tree>"
  | convert_Abs u = ""
and convert_App (term1 $ term2) =
	"<tree type=\"App\" >\n\t" ^ (convert_Term term1) ^ "\n\t" ^ (convert_Term term2) ^ "\n</tree>"
  | convert_App u = ""
and convert_Term (Const t) = convert_Const (Const t)
  | convert_Term (Free t) = convert_Free (Free t) 
  | convert_Term (Var t) = convert_Var (Var t)
  | convert_Term (Abs t) = convert_Abs (Abs t)
  | convert_Term (t1 $ t2) = convert_App (t1 $ t2)
  | convert_Term u = "";
end;

(*   
  type indexname = string * int
  type class = string
  type sort = class list
  type arity = string * sort list * sort
  datatype typ =
    Type  of string * typ list |
    TFree of string * sort |
    TVar  of indexname * sort
  datatype term =
    Const of string * typ |   => Name, Type
    Free of string * typ |    => Name, Type
    Var of indexname * typ |  => 
    Bound of int |
    Abs of string * typ * term |
    $ of term * term 
*)