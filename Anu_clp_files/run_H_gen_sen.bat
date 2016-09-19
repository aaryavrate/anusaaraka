 (load "global_path.clp")
 (bind ?*path* (str-cat ?*path* "/Anu_clp_files/English_sentence.bclp"))
 (bload ?*path*)
 (load-facts "word.dat")
 (load-facts "vibakthi_info.dat")
 (load-facts "punctuation_info.dat")
 (load-facts "hindi_id_order.dat")
 (open "hin_eng_sent.dat" e_sen_fp "w")
 (run)
 (clear)
 ;----------------------------------------------------------------------
 (load "global_path.clp")
 (bind ?*path* (str-cat ?*path* "/Anu_clp_files/template_after_mng.clp"))
 (load ?*path*)
 (load-facts "word.dat")
 (load-facts "id_Apertium_output.dat")
 (load-facts "hindi_id_order.dat")
 (load-facts "GNP_agmt_info.dat")
 (run)
 (save-facts "id_Apertium_output.dat" local id-Apertium_output)
 (clear)
 ;----------------------------------------------------------------------
 (load "global_path.clp")
 (bind ?*path* (str-cat ?*path* "/Anu_clp_files/hindi_sentence.bclp"))
 (bload ?*path*)
 (load-facts "word.dat")
 (load-facts "parser_type.dat")
 (load-facts "id_Apertium_output.dat")
 (load-facts "hindi_id_order.dat")
 (load-facts "hindi_punctuation.dat")
 (load-facts "punctuation_info.dat")
 (load-facts "original_word.dat")
 (load-facts "underscore_hyphen_replace_info.dat")
 (load-facts "wsd_facts_output.dat")
 (load-facts "GNP_agmt_info.dat")
 (load-facts "hindi_meanings.dat")
 (load-facts "cat_consistency_check.dat")
 (load-facts "relations_tmp1.dat")
 (open "hindi_sentence_tmp.dat" h_sen_fp "w")
 (open "removed_repeated_mng.dat" rm_mng_fp "w")
 (run)
 (save-facts "id_Apertium_output.dat" local id-Apertium_output)
 (clear)
 ;--------------------------------------------------------------------------
 (load "global_path.clp")
 (bind ?*path* (str-cat ?*path* "/Anu_clp_files/eng_hin_pos.clp"))
 (load ?*path*)
 (load-facts "Eng_id_order.dat")
 (load-facts "hindi_id_order.dat")
 (load-facts "lwg_info.dat")
 (load-facts "GNP_agmt_info.dat")
 (load-facts "hindi_meanings.dat")
 (load-facts "hindi_meanings_with_grp_ids.dat")
 (load-facts "original_word.dat")
 (load-facts "id_Apertium_output.dat")
 (assert (index 1))
 (assert (English_Sen))
 (open "position.dat" pos_fp "w")
 (run)
 (save-facts "Eng_sen_without_punct.dat" local English_Sen)
 (close pos_fp)
 (clear)
 (exit)
 ;--------------------------------------------------------------------------
