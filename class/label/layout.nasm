%include 'inc/func.ninc'
%include 'class/class_label.ninc'
%include 'class/class_flow.ninc'

def_func class/label/layout
	;inputs
	;r0 = label object
	;trashes
	;all but r0, r4

	def_struct local
		ptr local_inst
	def_struct_end

	;save inputs
	vp_sub local_size, r4
	set_src r0
	set_dst [r4 + local_inst]
	map_src_to_dst

	vp_cpy [r0 + view_w], r10
	vp_cpy [r0 + view_h], r11
	vp_sub label_border_size * 2, r10
	vp_sub label_border_size * 2, r11
	f_call flow, change, {[r0 + label_flow], label_border_size, label_border_size, r10, r11}

	vp_cpy [r4 + local_inst], r0
	vp_cpy [r0 + view_color], r1
	vp_shr 24, r1
	vpif r1, ==, 0xff
		f_call label, opaque, {r0}
	endif
	vp_add local_size, r4
	vp_ret

def_func_end
