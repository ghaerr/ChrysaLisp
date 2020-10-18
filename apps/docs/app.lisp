;imports
(import "sys/lisp.inc")
(import "class/lisp.inc")
(import "gui/lisp.inc")

(structure '+event 0
	(byte 'close+ 'button+))

(defq margin_width (* 8 3)
	doc_list '("VM" "ASSIGNMENT" "STRUCTURE" "COMMS" "FUNCTIONS" "LISP" "ENVIRONMENT"
	"ITERATION" "TERMINAL" "COMMANDS" "DIARY" "SYNTAX" "CLASSES" "INTRO" "TAOS" "TODO"))

(defun-bind normal-line ()
	(cond
		((starts-with "```" line_str)
			(setq state :code))
		((starts-with "#### " line_str)
			(def (setq line_widget (create-text)) :text (slice 5 -1 line_str)
				:font (create-font "fonts/OpenSans-Regular.ctf" 22)))
		((starts-with "### " line_str)
			(def (setq line_widget (create-text)) :text (slice 4 -1 line_str)
				:font (create-font "fonts/OpenSans-Regular.ctf" 26)))
		((starts-with "## " line_str)
			(def (setq line_widget (create-text)) :text (slice 3 -1 line_str)
				:font (create-font "fonts/OpenSans-Regular.ctf" 30)))
		((starts-with "# " line_str)
			(def (setq line_widget (create-text)) :text (slice 2 -1 line_str)
				:font (create-font "fonts/OpenSans-Regular.ctf" 34)))
		((starts-with "* " line_str)
			(def (setq line_widget (create-flow)) :flow_flags  flow_right_fill)
			(def (defq space1_widget (create-text)) :text " ")
			(def (defq bullet_widget (create-text)) :text (num-to-utf8 0xe979) 
					:font (create-font "fonts/Entypo.ctf" 18))
			(def (defq space2_widget (create-text)) :text " ")
			(def (defq text_widget (create-text)) :text (slice 2 -1 line_str))
			(view-add-back line_widget space1_widget)
			(view-add-back line_widget bullet_widget)
			(view-add-back line_widget space2_widget)
			(view-add-back line_widget text_widget))
		((find-rev "`" line_str)
			(def (setq line_widget (create-flow)) :flow_flags  flow_right_fill)
			(defq word_lst (map trim (split (cat " " line_str " ") "`")))
			(each (lambda (word)
				(setq word_cnt (inc word_cnt))
				(cond
					((even? word_cnt)
						(def (defq word_widget (create-text)) :text (cat " " word " ") :ink_color argb_blue))
					(t	(def (defq word_widget (create-text)) :text word :ink_color argb_black)))
				(view-add-back line_widget word_widget)) word_lst)
			(setq word_cnt (inc word_cnt)))
		(t
			(def (setq line_widget (create-text)) :text line_str))))

(defun-bind code-line ()
	(cond
		((starts-with "```" line_str)
			(setq state :normal word_cnt 0))
		((defq tab_pos (find-rev (ascii-char 9) line_str))
			(def (setq line_widget (create-flow)) :flow_flags  flow_right_fill)
			(def (defq tab_widget (create-text)) :text (pad "    " (* 4 (inc tab_pos))))
			(def (defq code_widget (create-text)) :text (slice (inc tab_pos) -1 line_str)
				:font *env_terminal_font* :ink_color argb_blue)
			(view-add-back line_widget tab_widget)
			(view-add-back line_widget code_widget))
		(t
			(def (setq line_widget (create-text)) :text line_str
				:font *env_terminal_font* :ink_color argb_blue))))

(defun-bind populate-page (file)
	(ui-tree page_flow (create-flow) (:flow_flags (logior flow_flag_right flow_flag_fillh)
			:font *env_window_font*)
		(ui-label _ (:min_width margin_width :color argb_grey15))
		(ui-flow page_widget (:flow_flags (logior flow_flag_down flow_flag_fillw))))
	(defq state :normal word_cnt 0)
	(each-line (lambda (line_str)
		(defq line_str (trim-end line_str (ascii-char 13)) line_widget (while nil))
		(case state
			(:normal (normal-line))
			(:code (code-line)))
		(if line_widget (view-add-child page_widget line_widget))) (file-stream (cat "docs/" file ".md")))
	(apply view-change (cat (list page_flow 0 0) (view-pref-size page_flow)))
	(view-layout (view-add-child page_scroll page_flow))
	(view-dirty-all (view-layout doc_flow)))

(ui-window window (:color argb_grey15)
	(ui-title-bar _ "Docs" (0xea19) +event_close+)
	(ui-flow doc_flow (:flow_flags flow_right_fill :font *env_window_font* :color *env_toolbar_col*)
		(ui-flow index (:flow_flags (logior flow_flag_down flow_flag_fillw))
			(each (lambda (path)
				(component-connect (ui-button _
					(:text path :flow_flags (logior flow_flag_align_vcenter flow_flag_align_hleft))) +event_button+)) doc_list))
		(ui-scroll page_scroll scroll_flag_vertical (:min_width 848 :min_height 800))))

(defun-bind main ()
	(populate-page (elem 0 doc_list))
	(bind '(x y w h) (apply view-locate (view-pref-size window)))
	(gui-add (view-change window x y w h))
	(while (cond
		((= (defq id (get-long (defq msg (mail-read (task-mailbox))) ev_msg_target_id)) +event_close+)
			nil)
		((= id +event_button+)
			(populate-page (get :text (view-find-id window (get-long msg ev_msg_action_source_id)))))
		(t (view-event window msg))))
	(view-hide window))
