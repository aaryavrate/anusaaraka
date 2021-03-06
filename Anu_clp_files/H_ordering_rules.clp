(deftemplate pada_info (slot group_head_id (default 0))(slot group_cat (default 0))(multislot group_ids (default 0))(slot vibakthi (default 0))(slot gender (default 0))(slot number (default 0))(slot case (default 0))(slot person (default 0))(slot H_tam (default 0))(slot tam_source (default 0))(slot preceeding_part_of_verb (default 0)) (multislot preposition (default 0))(slot Hin_position (default 0))(slot pada_head (default 0)))

(defglobal ?*order_debug-file* = order_debug)
(defglobal ?*count*  = 0) 

(deffunction reverse ($?a)
(if (eq (length ?a) 0) then ?a
 else
(create$ (reverse (rest$ ?a)) (first$ ?a))))

(deffunction reverse_daughters ($?a)
(if (< (length ?a) 2) then ?a
 else
(create$ (first$ ?a) (reverse (rest$ ?a)))))
;-----------------------------------------------------------------------------------------------------------------------
;The Fateh Prakash Palace is a perfect example of luxury and style that states Udaipur as a city of royal hospitalilty and culture. Added by Sukhada (13-9-11)
(defrule move_BEandHAVE_b4_SBAR
(declare (salience 1000))
(prep_id-relation-anu_ids ? viSeRya-jo_samAnAXikaraNa  ?vi ?samA)
(prep_id-relation-anu_ids ? subject-subject_samAnAXikaraNa  ?sub ?vi)
(Head-Level-Mother-Daughters ? ? ?mot $? ?sub $?)
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?M $?d ?mot $?d1)
(id-original_word ?samA ?word)
(id-original_word ?vi ?word1)
?f1<-(Head-Level-Mother-Daughters ?word1 ?l ?M1 $?d2 ?SBAR $?d3)
(Head-Level-Mother-Daughters ?word ? ?SBAR $?)
(Node-Category ?SBAR SBAR)
(not (Mother ?head)) ; Added by Shirisha Manju (21-10-11) The anasager lake is an artificial lake that was constructed by raja anaji sometime in the 1150 a.d..
=>
	(bind ?*count* (+ ?*count* 1))
	(retract ?f0 ?f1)
	(assert (Head-Level-Mother-Daughters ?head ?lvl ?M $?d ?mot $?d1 ?SBAR))
	(assert	(Head-Level-Mother-Daughters ?word1 ?l ?M1 $?d2 $?d3))
	(assert (Mother ?head))	
        (printout ?*order_debug-file* "(rule_name - move_BEandHAVE_b4_SBAR " ?*count* " "crlf
                          "             Before    - "?head" "?lvl"  "?M"  "(implode$ $?d)" "?mot"  "(implode$ $?d1)"  "crlf
                          "             After     - "?head" "?lvl"  "?M"  "(implode$ $?d)" "?mot"  "(implode$ $?d1)" "?SBAR")"crlf)
        (printout ?*order_debug-file* "(rule_name - move_BEandHAVE_b4_SBAR " ?*count* " "crlf
                          "             Before    - "?word1" "?l" "?M1" "(implode$ $?d2)" "?SBAR" "(implode$ $?d3)"  "crlf
                          "             After     - "?word1" "?l" "?M1" "(implode$ $?d2)" "(implode$ $?d3) ")"crlf)


) 	
;-----------------------------------------------------------------------------------------------------------------------
; Mysore is also known as the city of palaces.
; Added by Shirisha Manju (12-08-11) Suggested by Sukhada
; Added both in the list by Sukhada (20-9-13) They have both travelled widely. 
;If VP > ADVP VP1 and VP1 > x y z then this rule modifies VP as VP > ADVP x y z and removes the node VP1.
(defrule merge_ADVP
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?h ?l ?VP ?ADVP ?VP1)
?f1<-(Head-Level-Mother-Daughters ?h1 ? ?VP1 $?daut)
(Head-Level-Mother-Daughters ?id ? ?ADVP $?)
(not (id-original_word ?id later|both)) ;This experiment was later performed around 1911 by Hans Geiger (1882 — 1945) and Ernst Marsden (1889 — 1970, who was 20 year-old student and had not yet earned his bachelor's degree).
(Node-Category  ?VP   VP)
(Node-Category  ?VP1  VP)
(Node-Category  ?ADVP ADVP)

=>
	(bind ?*count* (+ ?*count* 1))
	(retract ?f0 ?f1)
	(assert (Head-Level-Mother-Daughters ?h ?l ?VP ?ADVP $?daut))
	(printout ?*order_debug-file* "(rule_name - merge_ADVP " ?*count* " "crlf
                          "             Before    - "?h" "?l"  "?VP"  "?ADVP" "?VP1"  "crlf
                          "             After     - "?h" "?l"  "?VP"  "?ADVP" "(implode$ $?daut) ")"crlf)
 )
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (2-08-11) -- Suggested by Sukhada.
;The balance is supplied by a host of smaller exporters, such as Australia and Venezuela.
(defrule dont_rev_if_PP_goesto_SUCH
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?l ?Mot ?JJ $?d)
(Node-Category  ?Mot  PP)
(Head-Level-Mother-Daughters ?h&such ? ?JJ $?)
(not (Mother  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?l ?Mot  ?JJ $?d))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - dont_rev_if_PP_goesto_SUCH " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "?JJ" "(implode$  $?d) crlf
                         "              After     - "?head" "?l" "?Mot" "?JJ" "(implode$ $?d) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (19-08-11) -- Suggested by Sukhada.
;But the full effect on prices of the winter wheat now being planted will not be felt until the second half of next year.
(defrule dont_rev_if_VP_ends_with_verb
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?l ?Mot $?d ?VP)
(Head-Level-Mother-Daughters ?word ? ?VP ?id)
(Node-Category  ?Mot  VP)
(Node-Category  ?VP  VP)
(id-cat_coarse ?id verb)
(not (Mother  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?l ?Mot  $?d ?VP))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - dont_rev_if_VP_ends_with_verb " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "(implode$  $?d)" "?VP crlf
                         "              After     - "?head" "?l" "?Mot" "(implode$ $?d)" "?VP ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (19-08-11) -- Suggested by Sukhada.
;Some analysts saw the payment as an effort also to dispel takeover speculation. 
(defrule dont_rev_if_S_goesto_ADVP_and_VP
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?l ?Mot ?ADVP ?VP)
(Head-Level-Mother-Daughters ?also_id ? ?ADVP $?)
(id-original_word ?also_id also) 
(Node-Category  ?Mot S)
(Node-Category  ?ADVP ADVP)
(Node-Category  ?VP VP)
(not (Mother  ?ADVP))
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?l ?Mot  ?ADVP ?VP))
        (assert (Mother  ?ADVP))
        (printout ?*order_debug-file* "(rule_name - dont_rev_if_S_goesto_ADVP_and_VP " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "?ADVP" "?VP crlf
                         "              After     - "?head" "?l" "?Mot" "?ADVP" "?VP ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (29-11-11) -- Suggested by Sukhada.
;They accused him of the crime. Could you convert my dollars into pounds?
(defrule dont_rev_if_VP_head_accused
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?l ?Mot ?verb $?d)
(id-original_word ?head accused|convert)
(Node-Category  ?Mot VP)
(not (Mother  ?Mot))
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?l ?Mot $?d ?verb))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - dont_rev_if_VP_head_accused " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "?verb" "(implode$ $?d) crlf
                         "              After     - "?head" "?l" "?Mot" "(implode$ $?d)" "?verb ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;May I come in Sir? May I attend Bal Sabha, Sir? 
(defrule dont_reverse_VP_if_ends_with_sir
(declare (salience 1400))
(Head-Level-Mother-Daughters ? ?l ?Mot $?d ?S)
(and (Node-Category  ?Mot VP)(Node-Category  ?S S))
(Head-Level-Mother-Daughters ?head ? ?S $?)
(id-original_word ?head sir|Sir)
(not (Mother  ?Mot))
=>
	(assert (Mother  ?Mot))
	(printout ?*order_debug-file* "(rule_name - dont_reverse_VP_if_ends_with_sir " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "(implode$  $?d)" "?S crlf
                         "              After     - "?head" "?l" "?Mot" "(implode$ $?d)" "?S ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (26-07-14) -- Suggested by Sukhada.
;Do you think we should go to the party?  He disputed that our program was superior.We [assume] that the motion is in y-direction, more correctly in — y-direction because we choose upward direction as positive.
;S :  I do not think ghosts exist. ;I want to go there.
;But he adds, "I feel pressured, disappointed, uncomfortable and, frankly, quite angry with Viacom. 
;Mr. Canepa confirmed he had consented to the sanctions but declined to comment further. 
;Mr. Hahn agrees that he has a "retentive" memory, but friends say that is an understatement. 
;Many worry that Saleh will remain a power broker in Yemen through relatives and allies he put in key state positions. 
;Israeli defense officials warn that Syria, a close Iranian ally, is believed to possess GPS-guided missiles and chemical weapons. 
(defrule dont_rev_VP_if_immediate_sis_sbar
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?l ?Mot ?verb ?sbar $?d)
(Node-Category  ?Mot VP)
(Node-Category  ?sbar SBAR|S)
(Head-Level-Mother-Daughters  ?  ?  ?verb ?id)
(id-cat_coarse ?id verb)
(id-root ?head ?root) 
(test (member$ ?root (create$ think matter wonder say dispute suppose comment figure point assume add confirm agree doubt worry believe estimate)) ) 
(not (Mother  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (assert (Mother  ?Mot))
	(printout ?*order_debug-file* "(rule_name - dont_rev_VP_if_immediate_sis_sbar " ?*count* " " crlf
                         "              Before    - "?head" "?l" "?Mot" "?verb" "?sbar" "(implode$ $?d) crlf
                         "              After     - "?head" "?l" "?Mot" "?verb" "?sbar" "(implode$ $?d) ")" crlf)

)
;-----------------------------------------------------------------------------------------------------------------------

;Added by Shirisha Manju (30-07-15) -- Suggested by Sukhada.
;Stock futures trading has minted [dozens of millionaires] in their 20s and 30s.
;xarjana laKapawiyoM ke
;Such program trades, which can involve the purchase or sale of [millions of dollars] of stock, occur in a matter of seconds.
;One kind of response from the earliest times has been to observe the physical environment carefully, look for any meaningful patterns and relations in natural phenomena, and build and use new tools to interact with nature.
;Drink plenty of water. -- bahuwa sArA pAnI pIjie.
(defrule dont_reverse_NP
(declare (salience 1400))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?mot ?NP ?PP $?d)
(Node-Category  ?mot  NP)(Node-Category  ?PP  PP)
(id-original_word ?head ?wrd&lot|most|number|spot|kinds|kind|set|sort|whole|dozens|some|millions|type|tens|hundreds|thousands|billions|dollars|plenty)
(Head-Level-Mother-Daughters ?h ? ?PP ?IN $? ?NP2)
(id-root ?h of)
(not (Mother  ?mot))
(not (Mother  ?NP2))
=>
        (bind ?*count* (+ ?*count* 1))
        (assert (Mother  ?mot))
        (assert (Mother  ?NP2))
        (printout ?*order_debug-file* "(rule_name - dont_rev_NP " ?*count* " " crlf)
)

;-----------------------------------------------------------------------------------------------------------------------
(defrule print_for_debugging2
(declare (salience 1000))
=>
(bind ?*count* (+ ?*count* 1))
(printout ?*order_debug-file* "(debug_info  "?*count*" Applying Reversing rules )" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Have you ever seen Pacific?  Added by Sukhada
;The Princess was very surprised to hear this. 
;She had always thought that gold could buy anything.
(defrule move_ADVP_after_v
(declare (salience 960)) ; Salience is increased from 960 to 1960, for: "His plays are still widely performed in the USA."
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot ?advp ?vp $?daut )
(Node-Category  ?Mot  VP)
(Node-Category  ?advp  ADVP|RB)
(not (Mother  ?advp))
(not (Mother  ?Mot));Her heart beats fast. 
=>
        (retract ?f0)
	(assert (Mother  ?advp))
	(assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?vp ?advp $?daut ))
	(printout ?*order_debug-file* "(rule_name - move_ADVP_after_v " ?*count* " " crlf
                         "              Before    - "?head" " ?lev" "?Mot" "?advp" "?vp" "(implode$ $?daut) crlf
	                 "              After     - "?head" " ?lev" "?Mot" "?vp" "?advp" "(implode$ $?daut) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;So we conclude that the thieves did not enter through the front door, Pranjol said.
;wo hama niRkarRa nikAlawe hEM ki cora sAmane ke xaravAje se nahIM Guse We.
;I think so.  He pointed a gun at her.
(defrule rev_VP_or_WHPP
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot $?daut)
(Node-Category  ?Mot  VP|WHPP|Inf_VP)
(not (Mother  ?Mot))
(not (Daughters_replaced  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))	
	(bind ?note "reverse") ;In the second case, the car moves from O to P and then moves back from P to Q .
	(loop-for-count (?i 1 (length $?daut))
		(bind ?id (nth$ ?i $?daut))
		(if (eq (sub-string 1 2 ?id) "CC")  then
			(bind ?note "dont_reverse")
		)
	)
	(if (neq ?note "dont_reverse") then
        	(retract ?f0)
	       	(bind ?rev_daut (create$ ?head ?lev (reverse_daughters ?Mot $?daut)))
		(assert (Head-Level-Mother-Daughters ?rev_daut))
		(assert (Mother  ?Mot))
		(printout ?*order_debug-file* "(rule_name - rev_VP_or_PP_or_WHPP " ?*count* " " crlf
                         "              Before    - "?head" " ?lev" "?Mot" "(implode$ $?daut) crlf
	                 "              After     - "(implode$ ?rev_daut) ")" crlf)
	)
)
;-----------------------------------------------------------------------------------------------------------------------
;;Ex. I gave her a book. I will tell you the story tomorrow. 
;Added by Shirisha Manju (11-08-11) Suggested by Sukhada
; The root fact is loaded only for OL bcoz Ol shows head as root sometimes and word some times
;I refused to lend him extra money.
(defrule rev_VP_for_obj1_obj2
(declare (salience 799))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d1 ?d $?rest)
(Node-Category  ?Mot  VP|Inf_VP)
(and (prep_id-relation-anu_ids ? kriyA-object_2 ?head ?obj2)(prep_id-relation-anu_ids ? kriyA-object_1 ?head ?obj1))
(Head-Level-Mother-Daughters  ?obj2 ? ?d1  $?modf  ?y )
(Head-Level-Mother-Daughters  ?obj1 ? ?d  $?mod  ?x )
(not (Mother  ?d1))
(not (Mother ?d))
(not (prep_id-relation-anu_ids ? viSeRya-jo_samAnAXikaraNa  ?obj2 ?));I will show you the house which I bought.
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters  ?head ?lev ?Mot $?daut ?d ?d1  $?rest))
        (assert (Mother  ?d1))
        (assert (Mother  ?d))
        (printout ?*order_debug-file* "(rule_name - rev_VP_for_obj1_obj2 " ?*count* " " crlf
                         "              Before    - "?head" " ?lev" "?Mot" "(implode$ $?daut)" " ?d1" "?d" "(implode$ ?rest) crlf
                         "              After     - "?head" " ?lev" "?Mot" "(implode$ $?daut)" " ?d" "?d1" "(implode$ ?rest) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;I have sent the child to the school.
;She brought her boyfriend to the party.
;I will take you to school. 
; Added by Shirisha Manju (15-10-13) Suggested by Sukhada.
(defrule mv_destination_before_verb
(declare (salience 940))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?PP ?NP $?rest)
(and (Node-Category  ?Mot VP)(Node-Category  ?NP NP)(Node-Category  ?PP  PP))
(id-original_word ?head ?w&sent|brought|take)
(Head-Level-Mother-Daughters  ?  ?  ?PP ?TO ?NP1)
(and (Node-Category  ?TO TO)(Node-Category  ?NP1 NP))
(Head-Level-Mother-Daughters  ?h  ?  ?NP1  $?)
(id-original_word ?h ?wrd)
(test (or (neq (gdbm_lookup "place.gdbm" ?wrd) "FALSE") (member$ ?wrd (create$ party marraige))))
=>
	(bind ?*count* (+ ?*count* 1))
	(retract ?f0)
	(assert (Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?NP ?PP $?rest))
	(printout ?*order_debug-file* "(rule_name - mv_destination_before_verb " ?*count* " " crlf
                         "              Before    - "?head" " ?lev" "?Mot" "(implode$ $?daut)" " ?PP" "?NP" "(implode$ $?rest) crlf
                         "              After     - "?head" " ?lev" "?Mot" "(implode$ $?daut)" " ?NP" "?PP" "(implode$ $?rest) ")" crlf)

)
;-----------------------------------------------------------------------------------------------------------------------
;At this point, the Dow was down about 35 points.
; Added by Shirisha Manju(09-07-11) Suggested by Sukhada.
(defrule rev_ADVP
(declare (salience 940))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d ?d1 )
(Node-Category  ?Mot  ADVP)
(Node-Category  ?d1  NP)
(not (Mother  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (bind ?rev_daut (create$ ?head ?lev (reverse_daughters ?Mot $?daut ?d ?d1)))
        (assert (Head-Level-Mother-Daughters ?rev_daut))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - rev_ADVP " ?*count* " " crlf
                         "              Before    - "?head" " ?lev" "?Mot" "(implode$ $?daut)" " ?d" "?d1 crlf
                         "              After     - "(implode$ ?rev_daut) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(15-06-11) Suggested by Sukhada.
; The mystery of the Nixon tapes was never solved
; Anne told me I would almost certainly be hired.
(defrule rev_ADVP_goesto_RB
(declare (salience 900))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut $?d1 ?d $?d2)
(Head-Level-Mother-Daughters ?head_id ? ?d $?)
(id-original_word ?head_id ?wrd&never|certainly|apparently|clearly|really)
(Node-Category  ?d  ADVP)
(Node-Category  ?Mot  VP)
(not (Mother ?d))
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters   ?head ?lev ?Mot $?daut ?d $?d1 $?d2))
	(assert (Mother ?d))
        (printout ?*order_debug-file* "(rule_name - rev_ADVP_goesto_RB " ?*count* " " crlf
	                 "              Before    - " ?head" " ?lev" " ?Mot" "(implode$ $?daut)" "(implode$ $?d1)" "?d" "(implode$ $?d2) crlf 
			 "		After	  - " ?head" " ?lev" " ?Mot" "(implode$ $?daut)" " ?d " "(implode$ $?d1)" "(implode$ $?d2) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(30-05-11) Suggested by Sukhada. Modified by Sukhada on 31-05-11.
;Buying of shares was brisk on Wall Street today. She is very careful about her work.  
(defrule rev_ADJP_goesto_PP
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d)
(Node-Category  ?Mot  ADJP)
(Node-Category  ?d  PP|S);Dick is important to fix the problem.
(not (Mother  ?Mot))
=>      
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters   ?head ?lev ?Mot ?d $?daut))
        (assert (Mother  ?Mot))
  	(printout ?*order_debug-file* "(rule_name - rev_ADJP_goesto_PP " ?*count* " "crlf
                         "              Before    - "?head" " ?lev" "?Mot" "(implode$ $?daut)" "?d crlf
                         "              After     - "?head" " ?lev" " ?Mot" "?d" "(implode$ $?daut) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(14-06-11) -- suggested by sukhada
;The yield of kharif crops was not good this season.
(defrule rev_ADJP_goesto_RB
(declare (salience 900))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d $?dt)
(Head-Level-Mother-Daughters ? ? ?d ?id)
(Node-Category  ?Mot  ADJP)
(Node-Category  ?d  RB)
(id-original_word ?id not)
(not (Mother  ?Mot))
=>       
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters   ?head ?lev ?Mot $?daut $?dt ?d))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - rev_ADJP_goesto_RB " ?*count* " " crlf
                         "              Before    - "?head" "?lev" "?Mot" "(implode$ $?daut)" "?d " "(implode$ $?dt) crlf 
                         "              After     - "?head" "?lev" "?Mot" "(implode$ $?daut)" "(implode$ $?dt)" "?d ")"crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(20-06-11) Suggested by Dipti mam
;How many people did you see? How much money did you earn? I wonder how much money you earned.
;In which school do you study? I wonder how much you swim
(defrule WHNP_rule
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  ?whnp ?sq)
?f1<-(Head-Level-Mother-Daughters ?h ?l ?sq $?dau ?vp)
(Node-Category  ?Mot  SBARQ|SBAR)
(Node-Category ?whnp WHNP|WHADJP|WHPP)
(Node-Category ?sq  SQ|S)
(Node-Category ?vp VP)
(not (Mother  ?Mot))
(not (prep_id-relation-anu_ids ? viSeRya-jo_samAnAXikaraNa ? ?));Added by Sukhada(9.8.11). Ex. I will show you the house which I bought. Phil gave me a sweater which he bought in Paris. 
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0 ?f1)
	(assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?sq))
	(assert (Head-Level-Mother-Daughters ?h ?l ?sq $?dau ?whnp ?vp))
	(assert (Mother  ?Mot))
        (printout ?*order_debug-file* "(rule_name - WHNP_rule " ?*count* " " crlf
                         "              Before    - "?h" "?l" "?sq" "(implode$ $?dau)" "?vp crlf
                         "              After     - "?h" "?l" "?sq" "(implode$ $?dau)" "?whnp" "?vp ")" crlf)
	(printout ?*order_debug-file* "(rule_name - WHNP_rule " ?*count* " " crlf
                         "              Before    - "?head" "?lev" "?Mot" "?whnp" "?sq crlf
                         "              After     - "?head" "?lev" "?Mot" "?sq ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(28-05-11) Suggested by Sukhada
;This is the way to go. 
(defrule move_S_last_child_first
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d)
(Node-Category  ?Mot  NP)
(Node-Category  ?d S)
(not (Mother  ?Mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?d $?daut))
        (assert (Mother  ?Mot))
	(printout ?*order_debug-file* "(rule_name - move_S_last_child_first " ?*count* crlf
                         "              Before    - "?head" "?lev" "?Mot" "(implode$ $?daut)" " ?d crlf
                         "              After     - "?head" "?lev" "?Mot" "?d" "(implode$  $?daut) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(20-06-11) Suggested by Dipti mam
; He never really recovered from the shock of his wife's death. I have never played golf in my life.
(defrule move_negation_before_verb
(declare (salience 900))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d ?ADVP $?d1) 
(Head-Level-Mother-Daughters ?never ? ?ADVP $?)
(id-original_word ?never never)
(Node-Category ?ADVP ADVP)
(Head-Level-Mother-Daughters ?h ?l ?mot $?d2 $?d3 ?VP)
(Node-Category ?VP VP)
?f1<-(Head-Level-Mother-Daughters ?h1 ?l1 ?VP $?d4 ?V $?d5)
(or (Node-Category ?V VBD) (id-cat_coarse ?V verb))
(not (Mother  ?ADVP))
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0 ?f1)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d $?d1))
;        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d $?d1 ?VP))
	(assert (Head-Level-Mother-Daughters ?h1 ?l1 ?VP $?d4 ?ADVP ?V $?d5))
        (assert (Mother  ?ADVP))
	(assert (Mother ?VP))
        (printout ?*order_debug-file* "(rule_name - move_negation_before_verb " ?*count* crlf
                         "              Before    - "?head" "?lvl" "?Mot" "(implode$ $?d)" "?ADVP" "(implode$ $?d1)" "?VP crlf
                         "              After     - "?head" "?lvl" "?Mot" "(implode$ $?d)" "(implode$ $?d1)" "?VP")" crlf crlf)
	(printout ?*order_debug-file* "(rule_name - move_negation_before_verb " ?*count* crlf
                        "              Before    - "?h1" "?l1" "?VP" "(implode$ $?d4)" "?V " "(implode$ $?d5) crlf
                        "              After     - "?h1" "?l1" "?VP" "(implode$ $?d4)" "?ADVP" "?V" "(implode$ $?d5) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(20-06-11) Suggested by Sukhada
;The government has promised not to raise taxes. 
(defrule move_negation_before_inf_verb
(declare (salience 900))
(Head-Level-Mother-Daughters ?never ? ?ADVP $?)
(id-original_word ?never never|not)
(Node-Category ?ADVP ADVP|RB)
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d ?ADVP $?d1 ?TO_VP) 
(Node-Category ?TO_VP TO_VP)
(Head-Level-Mother-Daughters ? ? ?TO_VP $? ?Inf_VP)
(Node-Category ?Inf_VP Inf_VP)
?f1<-(Head-Level-Mother-Daughters ?h1 ?l1 ?Inf_VP $?d4 ?V $?d5)
(or (Node-Category ?V VBD|VB) (id-cat_coarse ?V verb))
(not (Mother  ?ADVP))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0 ?f1)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d $?d1 ?TO_VP))
        (assert (Head-Level-Mother-Daughters ?h1 ?l1 ?Inf_VP $?d4 ?ADVP ?V $?d5))
        (assert (Mother  ?ADVP))
        (assert (Mother ?Inf_VP))
        (printout ?*order_debug-file* "(rule_name - move_negation_before_inf_verb " ?*count* crlf
                         "              Before    - "?head" "?lvl" "?Mot" "(implode$ $?d)" "?ADVP" "(implode$ $?d1)" "?TO_VP crlf
                         "              After     - "?head" "?lvl" "?Mot" "(implode$ $?d)" "(implode$ $?d1)" "?TO_VP")" crlf crlf)
        (printout ?*order_debug-file* "(rule_name - move_negation_before_inf_verb " ?*count* crlf
                        "              Before    - "?h1" "?l1" "?Inf_VP" "(implode$ $?d4)" "?V " "(implode$ $?d5) crlf
                        "              After     - "?h1" "?l1" "?Inf_VP" "(implode$ $?d4)" "?ADVP" "?V" "(implode$ $?d5) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(20-06-11) Suggested by Sukhada
;When the dollar is in a free-fall, even central banks can not stop it.
(defrule move_first_RB_in_NP_to_last
(declare (salience 900))
?f0<-(Head-Level-Mother-Daughters ?h ?l ?Mot ?RB $?d)
(Node-Category ?Mot NP)
(Head-Level-Mother-Daughters ?head ? ?RB ?id)
(id-original_word ?head even)
(not (Mother ?Mot))
=>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f0 )
	(assert (Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?RB))
	(assert (Mother ?Mot))
        (printout ?*order_debug-file* "(rule_name - first_RB_in_NP_to_last " ?*count* crlf
                         "              Before    - "?h" "?l" "?Mot" "?RB"  "(implode$ $?d) crlf
                         "              After     - "?h" "?l" "?Mot"  "(implode$ $?d)" "?RB")" crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(03-10-16) Suggested by Rajini
;You think yourself very clever, do not you?  <prp> <verb> <prp> <sen> <==> <prp> <prp> <sen> <verb> 
;Before: Apa socawe hEM Apane Apa ko awyanwa cawura hE nA ?
;After:  Apa Apane Apa ko awyanwa cawura socawe hEM, hE nA ?
(defrule get_prps_together
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?h ?l ?S ?NP ?VP)
(and (Node-Category ?S S)(Node-Category ?NP NP)(Node-Category ?VP VP))
(Head-Level-Mother-Daughters ? ? ?NP ?PRP)
(Node-Category ?PRP PRP)
?f1<-(Head-Level-Mother-Daughters ?h1 ?l1 ?VP ?VB ?S1)
(and (Node-Category ?S1 S)(Node-Category ?VB VB|VBD|VBP))
?f2<-(Head-Level-Mother-Daughters ?h2 ?l2 ?S1 ?NP1 $?post)
(Head-Level-Mother-Daughters ? ? ?NP1 ?PRP1)
(Node-Category ?PRP1 PRP)
=>
	(bind ?*count* (+ ?*count* 1))
	(retract ?f0 ?f1 ?f2)
	(assert (Head-Level-Mother-Daughters ?h ?l ?S ?NP ?S1))
	(assert (Head-Level-Mother-Daughters ?h2 ?l2 ?S1 ?NP1 $?post ?VP))
	(assert (Head-Level-Mother-Daughters ?h1 ?l1 ?VP ?VB ))
        (printout ?*order_debug-file* "(rule_name - get_prps_together " ?*count* crlf
			"		Before	- " ?h" " ?l" " ?S" " ?NP" " ?VP crlf
			"			  " ?h1" "?l1" "?VP" "?VB" "?S1 crlf
			"			  " ?h2" "?l2" "?S1" "?NP1" "(implode$ $?post) crlf
			"		After 	- " ?h" "?l " "?S" " ?NP" "?S1   crlf
			"			  " ?h1" "?l1" "?VP" "?VB crlf
			"			  " ?h2" "?l2" "?S1" "?NP1" "(implode$ $?post)" " ?VP crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;The;Assumptions while writing this rule:
;If the daughters of the NP are not numbers then only this rule fires.
;These are given assuming that if first daughter of the Mother-NP is NP the rest daughters will never be numbers
;PP: VP: Information International said it believes that the complaints, filed in federal court in Georgia, are without merit.
;RRC :These equations give the velocity and the distance traveled as a function of time and also the variation of velocity with distance. 
;Standing in the middle of the great epic like a lighthouse, it illuminates the whole of the epic.
;It is the sort of work that calls for a high level of concentration.
(defrule reverse-NP-Daughters
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?mot ?NP ?PP $?d)
(id-original_word ?head ?wrd&~lot&~most&~number&~spot&~kinds&~set&~sort&~whole&~dozens)
(Node-Category  ?mot  NP)
(Node-Category  ?NP  NP)
(Node-Category  ?PP PP|VP|RRC|ADJP); ADJP: Previously, Mr. Vitulli, 43 years old, was general marketing manager of Chrysler Corp.'s Chrysler division. 
(not (Mother  ?mot))
;And I think a lot of people will harp on program trading. This room would look big for a spot of paint.
;Chamba has a number of temples, palaces and stylized buildings
=>      
        (bind ?*count* (+ ?*count* 1))
	(retract ?f0)
	(bind ?NP_rev (create$ ?head ?lvl (reverse_daughters ?mot ?NP ?PP $?d)))
	(assert (Head-Level-Mother-Daughters ?NP_rev))
	(assert (Mother  ?mot))
	(printout ?*order_debug-file* "(rule_name - reverse-NP-Daughters "  ?*count* crlf 
                         "              Before    - "?head" "?lvl" "?mot" "?NP" "?PP " "(implode$ $?d) crlf
	                 "              After     - "(implode$ ?NP_rev) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(20-06-11) Suggested by Sukhada
;Cray has been working on the project for more than six years. 
;Current PCs are more than 50 times faster and have memory capacity 500 times greater than their 1977 counterparts.
;Defense Minister Ehud Barak has estimated that an Iranian attack would claim fewer than 500 Israeli casualties a statement intended to calm the nation, but which has achieved the opposite effect.
(defrule move_more_than_after_head
(declare (salience 800))
?f<-(Head-Level-Mother-Daughters ?h ?l ?NP ?QP $?d ?NN)
(and (Node-Category  ?NP NP|ADJP)(Node-Category  ?QP QP))
?f0<-(Head-Level-Mother-Daughters ?h1 ?l1 ?QP $?pre ?more ?than $?post ?head)
(Head-Level-Mother-Daughters ?m_id ? ?more ?)
(Head-Level-Mother-Daughters ?t_id ? ?than ?)
(id-original_word ?m_id more|less|few|fewer|lesser)
(id-root ?t_id than)
(Head-Level-Mother-Daughters ?h2 ?l2 ?NN ?id)
(id-root ?id ?w)
(not (Mother  ?QP))
=>
	(bind ?*count* (+ ?*count* 1))
	(assert (Mother  ?QP))
	(if (and (neq ?w year)(neq ?w percent)(neq ?w symbol-percent)) then
	 	(assert (Head-Level-Mother-Daughters ?h1 ?l1 ?QP $?pre $?post ?head ?more ?than))
        	(retract ?f0)
		(printout ?*order_debug-file* "(rule_name - move_more_than_after_head "  ?*count* crlf 
			"              Before    - "?h1" " ?l1" " ?QP" " (implode$ $?pre)" " ?more" " ?than" " (implode$ $?post)" " ?head crlf
			"	      After     - "?h1" " ?l1" " ?QP" " (implode$ $?pre)" "(implode$ $?post)" " ?head" " ?more" " ?than crlf)
	else
        	(retract ?f0 ?f)
	 	(assert (Head-Level-Mother-Daughters ?h1 ?l1 ?QP $?pre $?post ?head ))
		(printout ?*order_debug-file* "(rule_name - move_more_than_after_head "  ?*count* crlf 
			"		 Before    - "?h1" " ?l1" " ?QP" " (implode$ $?pre)" " ?more" " ?than" " (implode$ $?post)" " ?head crlf
			"		After	   - "?h1" " ?l1" " ?QP" " (implode$ $?pre)" "(implode$ $?post)" " ?head crlf)
		(assert (Head-Level-Mother-Daughters ?h ?l ?NP ?QP $?d ?NN ?more ?than))
		(printout ?*order_debug-file* "(rule_name - move_more_than_after_head "  ?*count* crlf
                        "                Before    - "?h" " ?l" " ?NP" " ?QP" "(implode$ $?d)" " ?NN crlf
			"		After	   - "?h" " ?l" " ?NP" " ?QP" "(implode$ $?d)" " ?NN " " ?more" " ?than" " crlf)
	)
)
;-----------------------------------------------------------------------------------------------------------------------
;All our sisters are coming. He left all his money to the orphanage. 
(defrule replace_NP-daut_PDT
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?mot ?PDT ?PRP ?N )
(Node-Category  ?mot  NP)
(Node-Category  ?PDT  PDT)
(not (Mother  ?mot))
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?mot ?PRP  ?PDT ?N ))
        (assert (Mother  ?mot))
	(printout ?*order_debug-file* "(rule_name - replace_NP-daut_PDT "  ?*count* crlf
                         "              Before    - "?head" "?lvl" "?mot" "?PDT" "?PRP" "?N crlf
                         "              After     - "?head" "?lvl" "?mot" "?PRP" "?PDT" "?N ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(13-07-11) Suggested by Sukhada
;Several fund managers expect a rough market this morning before prices stabilize.
;Marriage deals are also fixed under the tree, though this practice is disapproved by the temple authorities.
(defrule prep_in_SBAR_rule
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?SBAR ?prep $?d)
(Head-Level-Mother-Daughters ? ? ?prep ?id)
(Node-Category ?SBAR SBAR|PP)
(Node-Category ?prep IN)
(not (prep_id-relation-anu_ids ? kriyA-vAkya_viBakwi  ? ?id));It was so dark that I could not see anything.
(not (Mother  ?SBAR))
(id-original_word ?head ?wrd)
(test (eq (member$ ?wrd (create$ that because as though although If if unless since per) ) FALSE)); He argues that efforts to firm up prices will be undermined by producers' plans to expand production capacity.  A quick turnaround is crucial to Quantum because its cash requirements remain heavy. Some grammars are better than others, as we have proved. The limiting speed is about 11.2 kilometres per second.
=>
        (bind ?*count* (+ ?*count* 1))
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?SBAR $?d ?prep))
        (assert (Mother  ?SBAR))
        (printout ?*order_debug-file* "(rule_name - prep_in_SBAR_rule "  ?*count* crlf
                         "              Before    - "?head" "?lvl" "?SBAR" "?prep" "(implode$ $?d) crlf
                         "              After     - "?head" "?lvl" "?SBAR" "(implode$ $?d)" "?prep ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Here we undef all the rules (As this rule are firing again after the nodes are replaced with terminal)
(defrule undefrules
(declare (salience 799))
;?f0<-(cntrl_fact_for_rev_order)
=>
;(save-facts "hindi_rev_order.dat" local Head-Level-Mother-Daughters)
(undefrule merge_ADVP)
(undefrule rev_VP_or_WHPP)
(undefrule rev_ADJP_goesto_PP)
(undefrule move_S_last_child_first)
(undefrule reverse-NP-Daughters)
(undefrule replace_NP-daut_PDT)
(undefrule move_negation_before_verb)
(undefrule WHNP_rule)
(undefrule prep_in_SBAR_rule)
(undefrule rev_ADVP_goesto_RB)
(undefrule move_ADVP_after_v)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule print_for_debugging3
(declare (salience 750))
=>
(bind ?*count* (+ ?*count* 1))
(printout ?*order_debug-file* "(debug_info  "?*count*"  Replacing Mother-Node with Child-Node  )" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule get_SBAR
(declare (salience 730))
?f0<-(Head-Level-Mother-Daughters ?h ?l ROOT1 $?r)
(Head-Level-Mother-Daughters ? ? ?NP $?id ?Mot $?)
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre ?dat $?pos)
?f1<-(Head-Level-Mother-Daughters ? ? ?dat $?child)
(Node-Category  ?Mot SBAR|SBARQ)
(Node-Category  ?dat ?DAT)
(Node-Category ?NP ?noun)
=>
	(bind ?*count* (+ ?*count* 1))
	(retract ?f)
	;(if (eq ?noun NP) then
	;	(assert (dont_separate_sbar ?Mot))
	;)
	(if (or (eq ?DAT SBAR)(eq ?DAT SBARQ)) then
	(retract ?f0)
	(assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre $?pos))
;	(assert (sbar-mother-dau ?Mot ?dat))
	(assert (Head-Level-Mother-Daughters ?h ?l ROOT1 $?r ?dat))
	(printout ?*order_debug-file* "(rule_name - get_SBAR "  ?*count* crlf
        	         "              Before    - "?head" "?lvl" "?Mot" "(implode$ $?pre)"  "?dat" "(implode$ $?pos) crlf
                	 "              After     - "?head" "?lvl" "?Mot" "(implode$ $?pre)" "(implode$ $?pos) ")" crlf)
	else
;	(retract ?f1)
	(assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre $?child $?pos)))
	(printout ?*order_debug-file* "(rule_name - get_SBAR "  ?*count* crlf
        	         "              Before    - "?head" "?lvl" "?Mot" "(implode$ $?pre)"  "?dat" "(implode$ $?pos) crlf
                	 "              After     - "?head" "?lvl" "?Mot" "(implode$ $?pre)" "(implode$ $?child)" "(implode$ $?pos) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule replace-daughters
(declare (salience 700))
?used1<-(Head-Level-Mother-Daughters ?head ?lvl ?mother $?daughters)
?used2<-(Head-Level-Mother-Daughters ?head1 ?level ?mother1 $?pre ?mother $?post)
(not (replaced_daughters ?mother))
=>
        (bind ?*count* (+ ?*count* 1))
	(retract  ?used2)
	(assert (Head-Level-Mother-Daughters ?head1 ?level ?mother1 $?pre $?daughters $?post))
	(assert (replaced_daughters ?mother))
	(printout ?*order_debug-file* "(rule_name - replace-daughters "  ?*count* crlf
        	         "              Before    - "?head1" "?level" "?mother1" "(implode$ $?pre)" "?mother" "(implode$ $?post) crlf
                	 "              After     - "?head1" "?level" "?mother1" "(implode$ $?pre)" "(implode$ $?daughters)" "(implode$ $?post) ")" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (30-07-15) -- Suggested by Sukhada.
;Eng: Mr. Otero, who apparently has an unpublished number, also could not be reached. 
;Anu: SrImAna ovterova, jisameM UparI wOra se aprakASiwa safKyA hE, BI nahIM pahuzcA jA sakA.
(defrule dont_separate_sbar_for_jo_samAnAXikaraNa
(declare (salience 551))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre ?vid ?sid $?po)
(Node-Category  ?Mot ROOT)
?f1<-(Head-Level-Mother-Daughters ?h ? ?dat ?sid $?child)
(Node-Category  ?dat SBAR|SBARQ)
(prep_id-relation-anu_ids - viSeRya-jo_samAnAXikaraNa ?vid ?sid)
(not (prep_id-relation-anu_ids ? viSeRya-of_saMbanXI  ? ?vid));He was the leader of the first Indian expedition which attempted to climb Everest.
(not (prep_id-relation-anu_ids ? subject-subject_samAnAXikaraNa  ? ?vid));She was a severe woman who seldom smiled.
(not (prep_id-relation-anu_ids ? kriyA-aBihiwa  ? ?vid));Once there was a king who was generous and kind. 
=>
	(assert (dont_separate_sbar ?dat))
)
;-----------------------------------------------------------------------------------------------------------------------
;This rule delete's all the SBAR from ROOT
(defrule rmv_sbar_from_root
(declare (salience 550))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut)
(Node-Category  ?Mot ROOT)
?f1<-(Head-Level-Mother-Daughters ?h ? ?dat $?child)
(id-original_word ?h ?word&~while);The cyclist will slip while taking the circular turn.
(Node-Category  ?dat SBAR|SBARQ)
(test (member$ $?child $?daut))
(test (neq (length $?child) 0))
(not (dont_separate_sbar ?dat)) ;The boy who came yesterday from Delhi is my friend.
=>
	(retract ?f)
	(assert (Sen  $?child))
	(loop-for-count (?i 1 (length $?child))
                 (bind ?id (nth$ ?i $?child))
                 (bind $?daut (delete-member$ $?daut ?id)))
	(assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut))
)
;-----------------------------------------------------------------------------------------------------------------------
;Here ROOT category is changed to SBAR
(defrule get_sen_fact
(declare (salience 500))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut)
?f1<-(Node-Category  ?Mot ROOT)
=>
	(retract ?f1)
	(assert (Sen $?daut))
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule rm_last_node_in_sen
(declare (salience 95))
?f0<-(Sen $?daughters ?id)
(test (neq (numberp ?id) TRUE))
=>
        (retract ?f0)
        (assert (Sen $?daughters))
        (assert (removed_node))
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule print_error_msg_to_user
(declare (salience 94))
(removed_node)
=>
        (printout t "ERROR (Order Problem) : Not all the ids were substituted" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule assert_dummy_fact
(declare (salience 90))
=>
  (assert (hindi_id_order))
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule hin_order
(declare (salience 80))
?f1<-(hindi_id_order $?dau)
?f0<-(Sen $?daughters ?id)
(not (Sen $? ?id1&:(> ?id ?id1)))
=>
	(retract ?f0 ?f1)
	(assert (hindi_id_order $?dau $?daughters ?id))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju 22-01-13 (Suggested by Sukhada)
;If the object is released from rest, the initial potential energy is completely converted into the kinetic energy of the object just before it hits the ground.
(defrule insert_sen_con_id
(declare (salience 61))
(pada_info (group_head_id 10001)(preposition $?prep_ids))
(Sen $?prep_ids $? ?id)
?f1<-(hindi_id_order  $?ids ?id $?ids1)
(not (got_new_id 10001))
=>
	(retract ?f1)
	(assert (hindi_id_order $?ids ?id 10001 $?ids1))
	(assert (got_new_id 10001))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(27-02-12)
(defrule rm_prep_id_in_order
(declare (salience 60))
(pada_info (preposition $?prep_ids))
?f1<-(hindi_id_order  $?ids ?pid $?ids1)
(test (member$ ?pid $?prep_ids))
(not (pre_id_deleted ?pid))
=>
        (retract ?f1)
        (assert (hindi_id_order   $?ids $?ids1))
        (assert (pre_id_deleted ?pid))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (30-07-12)
(defrule rm_to_id_in_order
(declare (salience 60))
(pada_info (group_cat infinitive) (group_ids ?to_id ?))
?f1<-(hindi_id_order  $?ids ?to_id $?ids1)
(not (to_id_deleted ?to_id))
=>
        (retract ?f1)
        (assert (hindi_id_order   $?ids $?ids1))
        (assert (to_id_deleted ?to_id))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha manju (27-07-15) 
;I asked him not to wait for me. 
;mEMne usako mere lie prawIkRA_nahIM karane ke lie kahA.
(defrule rm_not_id_b4_inf_in_order
(declare (salience 61))
(pada_info (group_cat infinitive) (group_ids ?to_id ?))
(id-root ?id1&:(=(- ?to_id 1) ?id1) not)
?f1<-(hindi_id_order  $?ids ?id1 $?ids1)
(not (not_id_deleted ?id1))
=>
        (retract ?f1)
        (assert (hindi_id_order   $?ids $?ids1))
        (assert (not_id_deleted ?id1))
)

;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(27-02-12)
(defrule rm_prep_node_in_cons
(declare (salience 60))
?f0<-(Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?IN)
(Node-Category ?IN IN)
?f1<-(Head-Level-Mother-Daughters ? ? ?IN ?id)
=>
	(retract ?f0 ?f1)
	(assert (Head-Level-Mother-Daughters ?h ?l ?Mot $?d))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(27-02-12)
(defrule rm_prep_id_in_cons
(declare (salience 55))
(pada_info (preposition $?prep_ids))
?f0<-(Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?pid $?d1)
(test (member$ ?pid $?prep_ids))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?h ?l ?Mot $?d $?d1))
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(31-07-13) Suggested by Chaitanya Sir
;Removing meaning_to_be_decided control fact for auxillary verbs
(defrule rm_aux_id_ctrl_fact
(declare (salience 54))
(pada_info  (group_cat VP) (group_ids $?ids ?h))
(test (neq (length $?ids) 0))
?f<-(meaning_to_be_decided ?id)
(test (member$ ?id $?ids))
=>
	(retract ?f)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule end_order
(declare (salience -200))
(hindi_id_order $?dau)
=>
        (bind ?*count* (+ ?*count* 1))
        (printout ?*order_debug-file* "(debug_info  "?*count* "  Final-order " (implode$ $?dau)")" crlf)
	(close ?*order_debug-file*)
)
;-----------------------------------------------------------------------------------------------------------------------
