%include 'inc/func.inc'
%include 'class/class_string.inc'

	def_func class/string/init1
		;inputs
		;r0 = string object
		;r1 = vtable pointer
		;r2 = string object
		;r3 = string object
		;outputs
		;r1 = 0 if error, else ok

		def_structure local
			ptr local_inst
			long local_string1
			long local_string2
		def_structure_end

		;save inputs
		vp_sub local_size, r4
		set_src r2, r3
		set_dst [r4 + local_string1], [r4 + local_string2]
		map_src_to_dst

		;init parent
		s_call string, init, {r0, r1}, {r1}
		if r1, !=, 0
			;init myself
			vp_cpy r0, [r4 + local_inst]
			vp_xor r1, r1
			vp_cpy r1, [r0 + string_hashcode]

			vp_cpy [r4 + local_string1], r6
			vp_cpy [r4 + local_string2], r7
			vp_cpy [r6 + string_length], r1
			vp_add [r7 + string_length], r1
			vp_cpy r1, [r0 + string_length]
			f_call sys_mem, copy, {&[r6 + string_data], &[r0 + string_data], [r6 + string_length]}, {_, r1}
			vp_cpy [r7 + string_length], r2
			vp_inc r2
			f_call sys_mem, copy, {&[r7 + string_data], r1, r2}, {_, _}

			vp_cpy [r4 + local_inst], r0
		endif

		vp_add local_size, r4
		vp_ret

	def_func_end
