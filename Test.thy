theory Test
  imports Main "../AFPs/afp-2023/thys/Weight_Balanced_Trees/Weight_Balanced_Trees"
begin
ML_file \<open>converter.ML\<close>
(*ML_file \<open>../Versions/Isabelle2023/src/HOL/Tools/SMT/smt_systems.ML\<close>*)
(*ML_file "../Versions/Isabelle2023/src/Pure/term_xml.ML"*)
ML \<open>
val test_term = fst (List.nth (Converter.find_all_theorems @{theory Weight_Balanced_Trees}, 0));
open Term_XML;
val the_typ = Term.type_of test_term;
val xmlz = Converter.convert_Term test_term;
;

val lisz = List.nth (Converter.find_all_theorems @{theory Weight_Balanced_Trees}, 0)
(*val out_file = TextIO.openOut "ML_out";
TextIO.output (out_file, xmlz);
TextIO.closeOut out_file;*)
\<close>                     
  

end