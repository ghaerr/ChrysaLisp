(defun-bind find-in-buffer (ss)
	(unless (eql ss "")
		(each (lambda (ln) (when (not (eql nil (defq found (substr ss ln))))
			(defq y _)
			(each (lambda (x) (push find_list (list x y))) found)))
				(elem +text_buffer+ current_text))
		(setq find_index 0)))

(defun-bind open-find ()
	;if there is a previous search, clear and conduct a new one.
	(when (/= (length find_list) 0) (setq find_list (list) find_index 0))
	(find-in-buffer (setq find_textfield (get :text textfield)))
	(bind '(ox oy cx cy sx) (elem +text_position+ current_text))
	(cond
		((> (defq fl_len (length find_list)) 0)
			(bind '(fx fy) (first find_list))
			(elem-set 2 (elem +text_position+ current_text) fx) (elem-set 3 (elem +text_position+ current_text) fy)
			(setq sb_line_col_message (str " - " (str (inc find_index)) " of " (str (length find_list)) " Matches. "))
			(set sb_line_col :text (cat "Line " (str fy) ", Column " (str fx) sb_line_col_message))
			(view-layout status_bar)
			(view-dirty sb_line_col)
			(window-layout vdu_width vdu_height))
		((eql (get :text textfield) "") (setq sb_line_col_message "")
			(view-dirty sb_line_col))
		(t 
			(setq sb_line_col_message " - No Matches Found")
			(set sb_line_col :text (cat "Line " (str cy) ", Column " (str cx) sb_line_col_message))
			(view-layout sb_line_col)
			(view-layout status_bar)
			(view-dirty sb_line_col))))

(defun-bind find-next ()
	(cond 
		((or (not (eql (get :text textfield) find_textfield)) (= (length find_list) 0)) (open-find))
		(t 
			(if (= find_index (dec (defq fl_len (length find_list))))
				(setq find_index 0) (setq find_index (inc find_index)))
			(bind '(fx fy) (elem find_index find_list))
			(elem-set 2 (elem +text_position+ current_text) fx)
			(elem-set 3 (elem +text_position+ current_text) fy)
			(setq sb_line_col_message (str " - " (str (inc find_index)) " of " (str (length find_list)) " Matches. "))
			(set sb_line_col :text (cat "Line " (str fy) ", Column " (str fx) sb_line_col_message))
			(view-layout sb_line_col)
			(view-dirty sb_line_col)
			(window-layout vdu_width vdu_height))))

(defun-bind find-prev ()
	(cond 
		((or (not (eql (get :text textfield) find_textfield)) (= (length find_list) 0)) (open-find))
		(t 
			(if (= find_index 0) 
				(setq find_index (dec (length find_list))) (setq find_index (dec find_index)))
			(bind '(fx fy) (elem find_index find_list))
			(elem-set 2 (elem +text_position+ current_text) fx)
			(elem-set 3 (elem +text_position+ current_text) fy)
			(setq sb_line_col_message (str " - " (str (inc find_index)) " of " (str (length find_list)) " Matches. "))
			(set sb_line_col :text (cat "Line " (str fy) ", Column " (str fx) sb_line_col_message))
			(view-layout sb_line_col)
			(view-dirty sb_line_col)
			(window-layout vdu_width vdu_height))))