 ;Added by Shirisha Manju (19-11-11)
 (deffunction never-called ()
 (assert (hindi_id_order))
 (assert (id-Apertium_output))
 (assert (id-left_punctuation))
 (assert (id-right_punctuation))
 (assert (hid-punc_head-left_punctuation))
 (assert (hid-punc_head-right_punctuation))
 (assert (id-HM-source))
 (assert (id-inserted_sub_id))
 (assert (id-word))
 (assert (id-last_word))
 (assert (para_id-sent_id-word_id-original_word-hyphenated_word))
 (assert (id-original_word))
 (assert (Parser_used))
 (assert (id-wsd_number))
 (assert (affecting_id-affected_ids-wsd_group_root_mng))
 (assert (affecting_id-affected_ids-wsd_group_word_mng))
 (assert (id-wsd_root_mng))
 (assert (id-wsd_word_mng))
 (assert (id-H_vib_mng))
 (assert (id-wsd_root))
 (assert (make_verbal_noun))
 (assert (kriyA_id-object_viBakwi))
 (assert (kriyA_id-object2_viBakwi))
 (assert (kriyA_id-subject_viBakwi))
 (assert (kriyA_id-object1_viBakwi))
 (assert (id-tam_type))
 (assert (id-E_tam-H_tam_mng))
 (assert (id-preceeding_part_of_verb))
 (assert (root_id-TAM-vachan))
 (assert (id-attach_emphatic))
 (assert (id-eng-src))
 (assert (meaning_has_been_decided))
 (assert (id-attach_eng_mng))
 (assert (conj_head-left_head-right_head))
 )

(defglobal ?*hin_sen-file* = h_sen_fp)
(defglobal ?*rmd_mng-file* = rm_mng_fp)
 
 (deftemplate pada_info (slot group_head_id (default 0))(slot group_cat (default 0))(multislot group_ids (default 0))(slot vibakthi (default 0))(slot gender (default 0))(slot number (default 0))(slot case (default 0))(slot person (default 0))(slot H_tam (default 0))(slot tam_source (default 0))(slot preceeding_part_of_verb (default 0)) (multislot preposition (default 0))(slot Hin_position (default 0))(slot pada_head (default 0)))
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Roja (29-06-11)
 ;To replace hyphen(-) with underscore(_) only in cases where we get underscore in the sentence. 
 ;Ex: Child_abuse is the physical or emotional or sexual mistreatment of children. (Note: used for WordNet purpose)
 ; Modified by Shirisha Manju -- removed for hindi meaning (27-01-12)
 (defrule replace_hyphen_with_underscore
 (declare (salience  2600))
 ?f0<-(para_id-sent_id-word_id-original_word-hyphenated_word  ?para_id  ?sent_id  ?wid  ?org_wrd $? ?hyp_wrd $?)
 (id-original_word  ?wid  ?hyp_wrd)
 (hindi_id_order $? ?wid $?)
 ?f2<-(id-Apertium_output ?wid ?wrd_analysis $?wrd)
 =>
	(bind ?hyp_word (string-to-field (str-cat @ ?hyp_wrd)))
	(bind ?hyp_wd   (string-to-field (str-cat \@ ?hyp_wrd)))
   	(if (or (eq $?wrd_analysis  ?hyp_word)  (eq $?wrd_analysis  ?hyp_wd)) then
      		(assert (id-Apertium_output ?wid ?org_wrd $?wrd))
      		(retract ?f0 ?f2)
   	)
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Add english meaning to the hindi mng
 ;Added by Shirisha Manju (19-09-13) 
 (defrule add_eng_mng
 (declare (salience 2550))
 ?f0<-(id-Apertium_output ?id $?wrd_analysis)
 ?f1<-(id-attach_eng_mng ?id ?mng)
 (pada_info (group_ids $? ?id $? ?))
 =>
	(retract ?f0 ?f1)
	(bind $?n_mng (create$ $?wrd_analysis PUNCT-OpenParen ?mng PUNCT-ClosedParen))
	(assert (id-Apertium_output ?id $?n_mng))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (19-09-13)
 ;The receiver has the task of operating on the received [signal].
 ;As already mentioned, the purpose of a communication system is to transmit information or message [signals].
 (defrule add_eng_mng1
 (declare (salience 2549))
 ?f0<-(id-Apertium_output ?id $?wrd_analysis ?v_mng)
 ?f1<-(id-attach_eng_mng ?id ?mng)
 (pada_info (group_ids  $? ?id)(vibakthi ?vib))
 =>
        (retract ?f0 ?f1)
	(if (and (eq (str-index "_" (implode$ (create$ ?vib))) FALSE) (neq ?vib 0)) then
	        (bind $?n_mng (create$ $?wrd_analysis PUNCT-OpenParen ?mng PUNCT-ClosedParen ?v_mng))
        	(assert (id-Apertium_output ?id $?n_mng))
	else 
		(bind $?n_mng (create$ $?wrd_analysis ?v_mng PUNCT-OpenParen ?mng PUNCT-ClosedParen))
                (assert (id-Apertium_output ?id $?n_mng))
	)
 )
 ;----------------------------------------------------------------------------------------------------------
 ; Added by Shirisha Manju
 ;When none worked satisfactorily , his assistant complained ," All our work is in vain ". 
 (defrule attach_emphatic
 (declare (salience 2548))
 ?f1<-(id-attach_emphatic ?id ?wrd)
 ?f0<-(id-Apertium_output ?id $?wrd_analysis)
 =>
        (retract ?f0 ?f1)
	(assert (id-Apertium_output ?id $?wrd_analysis ?wrd))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (23-02-12)
 ;Things had just gone too far.
 (defrule get_rt_punt_if_no_aper_mng
 (declare (salience 2530))
 (Parser_used Stanford-Parser)
 (or (hid-punc_head-right_punctuation ?id ? ?punc)(hid-punc_head-left_punctuation ?id ? ?punc))
 ?f1<-(id-Apertium_output ?id $?wrd_analysis) 
 ?f0<-(hindi_id_order $?id1 ?id $?d1)
 (test (eq (length $?wrd_analysis) 0))
 =>
	(retract ?f1 ?f0)
	(assert (hindi_id_order $?id1 ?punc $?d1))
	(assert (id-mng ?id $?wrd_analysis ))
 )
 ;----------------------------------------------------------------------------------------------------------
 (defrule get_apertium_mng_with_lt_and_rt_punc
 (declare (salience 2521))
 (Parser_used Stanford-Parser)
 (hid-punc_head-right_punctuation ?id ? ?rp)
; (hid-left_punctuation ?id ?lp)
 (hid-punc_head-left_punctuation ?id ? ?lp)
 ?f1<-(id-Apertium_output ?id ?w $?wrd_analysis ?w1)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
        (retract ?f0 ?f1)
	(assert (id-mng ?id $?wrd_analysis ?w $?wrd_analysis ?w1))
	(bind ?w (string-to-field (str-cat ?lp ?w)))
	(bind ?w1 (string-to-field (str-cat ?w1 ?rp)))
        (assert (hindi_id_order $?id1 ?w $?wrd_analysis ?w1 $?id2))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju
 ;One can reach kumbhalgarh by road from udaipur (84km) and ranakpur which is 18km from kumbhalgarh. 
 (defrule get_apertium_mng_with_lt_and_rt_punc1
 (declare (salience 2520))
 (Parser_used Stanford-Parser)
 (hid-punc_head-right_punctuation ?id ? ?rp)
 (hid-punc_head-left_punctuation ?id ? ?lp)
 ?f1<-(id-Apertium_output ?id ?wrd)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
        (retract ?f0 ?f1)
	(assert (id-mng ?id ?wrd ))
	(bind ?wrd (string-to-field (str-cat ?lp ?wrd ?rp)))
        (assert (hindi_id_order $?id1 ?wrd $?id2))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju
 ;Revenue totaled $5 million.
 (defrule get_apertium_mng_with_left_punc
 (declare (salience 2510))
 (Parser_used Stanford-Parser)
 (hid-punc_head-left_punctuation ?id ? ?punc $?p )
 ?f1<-(id-Apertium_output ?id ?w $?wrd_analysis)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
        (retract ?f0 ?f1)
	(assert (id-mng ?id ?w $?wrd_analysis ))
	(bind ?w (string-to-field (str-cat ?punc ?w)))
        (assert (hindi_id_order $?id1 ?w $?p $?wrd_analysis $?id2))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (08-02-2012)
 ;If you are a technician, obey the signals.
 (defrule get_apertium_mng_with_right_punc
 (declare (salience 2510))
 (Parser_used Stanford-Parser)
 (hid-punc_head-right_punctuation ?id ? ?punc $?p)
 ?f1<-(id-Apertium_output ?id $?wrd_analysis ?w)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
  =>
        (retract ?f0 ?f1)
	(assert (id-mng ?id $?wrd_analysis ?w))
        (bind ?w (string-to-field (str-cat ?w ?punc)))
        (assert (hindi_id_order $?id1 $?wrd_analysis ?w $?p $?id2))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (10-12-2011)
 (defrule get_apertium_mng
 (declare (salience 2500))
 (Parser_used Stanford-Parser)
 ?f1<-(id-Apertium_output ?id $?wrd_analysis)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
	(retract ?f0 ?f1)
        (assert (hindi_id_order $?id1  $?wrd_analysis $?id2))
	(assert (id-mng ?id $?wrd_analysis))
 )
 ;======================== Generate hindi sentence using Apertium output and  punctuations ====================
 ;Added by Shirisha Manju (22-12-10)
 (defrule gene_sent_rt_lt
 (declare (salience 1001))
 ?f1<-(id-Apertium_output ?id $?wrd_analysis)
 (id-left_punctuation ?id "left_paren")
 (id-right_punctuation ?id "right_paren")
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
	(retract ?f0 )
        (assert (hindi_id_order $?id1 left_paren $?wrd_analysis right_paren $?id2))
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (22-12-10)
 ;Ex: Mr. Smith (a lawyer for Kodak) refused to comment.
 ;Rule is Modified again by Roja(11-01-11)
 ;Ex: As can be seen from Figure 11.1 the functions printf(), and scanf() fall under the category of formatted console I per O functions.
 (defrule gene_sent_lt_NONE
 (declare (salience 1000))
 ?f1<-(id-Apertium_output ?id ?wrd $?wrd_analysis)
 (id-left_punctuation ?id "NONE")
 (id-right_punctuation ?id ?rp)
 (test (or (eq ?rp "left_paren")(eq ?rp "right_paren" )(eq ?rp "equal_to" )(eq ?rp "left_parenright_paren")(eq ?rp "left_parenright_paren,") ))
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
  	(retract ?f0)
	(bind ?rp1 (string-to-field ?rp))
	(if (or (eq ?rp "left_paren" )(eq ?rp "right_paren" ) (eq ?rp "equal_to" )) then
		(assert (hindi_id_order $?id1 ?wrd $?wrd_analysis ?rp1 $?id2))
	else  (if (or (eq ?rp "left_parenright_paren")(eq ?rp "left_parenright_paren,")) then   
		        (bind ?wrd (string-to-field(str-cat ?wrd ?rp1)))
			(assert (hindi_id_order $?id1 ?wrd $?wrd_analysis $?id2))
              )
	)
 )
 ;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (22-12-10) 	
 ;Ex: Mr. Smith (a lawyer for Kodak) refused to comment.
 (defrule gen_sent_rt_NONE
 (declare (salience 1000))
 ?f1<-(id-Apertium_output ?id $?wrd_analysis)
 (id-left_punctuation ?id ?lp)
 (test (or (eq ?lp "left_paren")(eq ?lp "right_paren" )(eq ?lp "$" )))
 (id-right_punctuation ?id "NONE")
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
        (retract ?f0 )
	(bind ?lp1 (string-to-field ?lp))
	(assert (hindi_id_order $?id1 ?lp1 $?wrd_analysis  $?id2))
 )
;----------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (21-11-11)
 ; The inscription on the tomb of Michael-Faraday (1897-1990).
 (defrule gen_sent_lt
 (declare (salience 1000))
 ?f1<-(id-Apertium_output ?id $?wrd_analysis)
 (id-right_punctuation ?id ").")
 (id-left_punctuation ?id "left_paren")
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
        (retract ?f0 )
        (assert (hindi_id_order $?id1 left_paren $?wrd_analysis  right_paren $?id2))
 )
;----------------------------------------------------------------------------------------------------------
 ;Substituting Apertium output for the id(1000) 
 ;Added by Shirisha Manju (03-12-10)
 (defrule gene_sent1
 (declare (salience 950))
 (id-Apertium_output ?id $?wrd_analysis)
 ?f0<-(hindi_id_order $?id1 ?id $?id2)
 =>
 	(retract ?f0) 
	(assert (hindi_id_order $?id1  $?wrd_analysis  $?id2))
 )
 ;---------------------------------------------------------------------------------------------------------
 (defrule match_exp
 (declare (salience 500))
 ?f1<-(id-last_word ?id ?wrd)
 (not (Parser_used Stanford-Parser) )
 (id-right_punctuation   ?id  ?rp)
 ?f<-(hindi_id_order $?var ?lid)
 =>
       (retract ?f ?f1)
       (assert (hindi_id_order $?var ?lid ?rp))
 )
 ;---------------------------------------------------------------------------------------------------------
 ;;Added by Shirisha Manju (23-11-13)
 ;Your account of the accident does not agree [with hers].
 (defrule rm_repeated_mng_from_sentence
 (declare (salience 200))
 ?f<-(hindi_id_order $?pre ?mng ?mng $?post)
 (test (eq  (member$ ?mng (create$ bAra SurU kaBI XIre Binna karIba)) FALSE));The frequent sleeping of students is a big problem.
 (id-mng ?id $?m ?mng ?mng $?m1)
 (id-word ?id ?wrd)
 (id-HM-source ?id ? ?src)
 =>
	(retract ?f)
	(assert (hindi_id_order $?pre ?mng $?post))
	(printout t "Removed repeated meaning  : " ?mng" "?mng crlf)
	(bind $?n_mng (create$ $?m ?mng ?mng $?m1))
        (printout ?*rmd_mng-file* "(id-word-mng-removed_mng-src	"?id"	"?wrd"	"(implode$ $?n_mng)"	"?mng"	"?src ")" crlf)
 )
 ;---------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (25-01-12)
 (defrule print_sen
 (declare (salience 100))
 ?f<- (hindi_id_order $?var)
 =>
	(retract ?f)
	(printout ?*hin_sen-file* (implode$ $?var) crlf)	
 )
 ;---------------------------------------------------------------------------------------------------------
 (defrule end
 (declare (salience -10))
 =>
        (close ?*hin_sen-file* )
 )
 ;---------------------------------------------------------------------------------------------------------
