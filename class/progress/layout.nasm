%include 'inc/func.inc'
%include 'class/class_progress.inc'

	def_func class/progress/layout
		;inputs
		;r0 = progress object
		;trashes
		;all but r0, r4

		f_jmp progress, opaque, {r0}

	def_func_end
