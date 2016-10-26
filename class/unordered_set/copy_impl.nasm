%include 'inc/func.inc'
%include 'class/class_unordered_set.inc'
%include 'class/class_vector.inc'

	def_func class/unordered_set/copy_impl
		;inputs
		;r0 = unordered_set object
		;r1 = empty map/set object
		;outputs
		;r0 = unordered_set object
		;r1 = full map/set object
		;trashes
		;all but r0, r4

		vp_push r1
		f_call unordered_set, for_each, {r0, $callback, r4}, {_, _}
		vp_pop r1
		vp_ret

	callback:
		;inputs
		;r0 = predicate data pointer
		;r1 = element iterator
		;outputs
		;r1 = 0 if break, else not

		vp_cpy r0, r2
		f_call ref, ref, {[r1]}
		vp_push r0
		f_call unordered_set, get_bucket, {[r2], r0}, {r0}
		vp_pop r1
		f_jmp vector, push_back, {r0, r1}

	def_func_end
