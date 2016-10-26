%include 'inc/func.inc'
%include 'inc/task.inc'

	def_func sys/task_restore
		;restore next task
		;r15 = control block to restore

		;round robin past any list head
		ln_get_forward r15, r0
		f_bind sys_task, statics, r0
		vp_cpy r15, [r0 + tk_statics_current_tcb]

		;restore old stack pointer
		vp_cpy [r15 + tk_node_stack], r4

		;pop task state
		tk_load_state
		vp_ret

	def_func_end
