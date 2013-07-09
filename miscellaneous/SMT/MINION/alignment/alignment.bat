(load "global_path.clp")
(bind ?*path* (str-cat ?*path* "/miscellaneous/SMT/MINION/alignment/get_slot_number.clp"))
(load ?*path*)
(load-facts "minion.dat")
(load-facts "manual_lwg_new.dat")
(load-facts "manual_word.dat")
(load-facts "aper_op_without_@.dat")
(load-facts "hindi_id_order_for_minion.dat")
(run)
(save-facts "word_alignment_tmp1.dat" local anu_id-anu_mng-sep-man_id-man_mng)
(clear)
;---------------------------------------------------------------------------------------
(load "global_path.clp")
(bind ?*path* (str-cat ?*path* "/miscellaneous/SMT/MINION/alignment/modify_minion_output.clp"))
(load ?*path*)
(load-facts "database_mng.dat")
(load-facts "revised_root.dat")
(load-facts "word.dat")
(load-facts "original_word.dat")
(load-facts "word_alignment_tmp1.dat")
(load-facts "manual_id_mapping.dat")
(load-facts "manual_lwg_new.dat")
(load-facts "manual_lwg.dat")
(load-facts "shallow_parser_root.dat")
(load-facts "hindi_id_order_for_minion.dat")
(load-facts "aper_op_without_@.dat")
(load-facts "hin_mng_without_@.dat")
(load-facts "meaning_alignment_source_tmp.dat")
(load-facts "para_sent_id_info.dat")
(load-facts "position.dat")
(load-facts "restricted_word_mngs.dat")
(load-facts "manual_word.dat")
(assert (left_out_mngs))
(assert (left_out_words))
(open "minion_sen_dic.txt" dic_fp "w")
(open "mngs_aligned_with_anu.dat" mng_fp1 "w")
;(open "mngs_aligned_with_dic.dat" mng_fp "w")
(open "wsd_errors_tmp.dat" mng_fp "w")
(open "mngs_aligned_with_minion.dat" mng_fp2 "w")
(run)
(save-facts "word_alignment_tmp2.dat" local anu_id-anu_mng-sep-man_id-man_mng)
(save-facts "left_out_word_and_phrase_info.dat" local left_out_mngs left_out_words phrase_ids-mng)
(save-facts "meaning_alignment_source.dat" local id-src-eng_wrds-anu_mng-man_mng)
(save-facts "correction_info.dat" local id-root-corrected_mng)
(close dic_fp)
(close mng_fp)
(close mng_fp1)
(close mng_fp2)
(clear)
;---------------------------------------------------------------------------------------
(load "global_path.clp")
(bind ?*path* (str-cat ?*path* "/miscellaneous/SMT/MINION/alignment/get_mng.clp"))
(load ?*path*)
(load-facts "left_out_word_and_phrase_info.dat")
(load-facts "word_alignment_tmp2.dat")
(load-facts "word.dat")
(load-facts "manual_lwg_new.dat")
(load-facts "hindi_id_order_for_minion.dat")
(load-facts "manual_id_mapping.dat")
(load-facts "restricted_word_mngs.dat")
(load-facts "position.dat")
(load-facts "shallow_parser_root.dat")
(load-facts "aper_op_without_@.dat")
(load-facts "hin_mng_without_@.dat")
(load-facts "correction_info.dat")
(open "minion_sen_dic.txt" dic_fp1 "a")
(run)
(save-facts "word_alignment.dat" local anu_id-anu_mng-sep-man_id-man_mng)
(close dic_fp1)
(clear)
;-----------------------------------------------------------------------------------------
(load "global_path.clp")
(bind ?*path* (str-cat ?*path* "/miscellaneous/SMT/MINION/alignment/get_phrase.clp"))
(load ?*path*)
(load-facts "left_out_word_and_phrase_info.dat")
(load-facts "GNP_agmt_info.dat")
(load-facts "Eng_sen_without_punct.dat")
(load-facts "word_alignment.dat")
(load-facts "hindi_id_order_for_minion.dat")
(load-facts "restricted_word_mngs.dat")
(load-facts "aper_op_without_@.dat")
(load-facts "word.dat")
(load-facts "manual_lwg.dat")
(load-facts "manual_id_mapping.dat")
(load-facts "hin_mng_without_@.dat")
(load-facts "manual_hin.morph.dat")
(load-facts "database_mng.dat")
(load-facts "meaning_alignment_source.dat")
(open "minion_sen_dic.txt" dic_fp2 "a")
(run)
(close dic_fp2)
(clear)
;-----------------------------------------------------------------------------------------
(exit)
