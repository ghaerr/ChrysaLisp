%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_symbol.inc'
%include 'class/class_error.inc'
%include 'class/class_lisp.inc'

	def_func class/lisp/func_gensym
		;inputs
		;r0 = lisp object
		;r1 = args
		;outputs
		;r0 = lisp object
		;r1 = value

		ptr this, args, prefix, value
		ulong length

		push_scope
		retire {r0, r1}, {this, args}

		devirt_call vector, get_length, {args}, {length}
		ifnot {length}
			func_call symbol, create_from_long, {this->lisp_nextsym, 10}, {args}
			func_call symbol, create_from_cstr, {"G"}, {prefix}
			func_call symbol, append, {prefix, args}, {value}
			func_call ref, deref, {prefix}
			func_call ref, deref, {args}
			func_call lisp, sym_intern, {this, value}, {value}
			assign {this->lisp_nextsym + 1}, {this->lisp_nextsym}
		else
			func_call error, create, {"(gensym) wrong numbers of args", args}, {value}
		endif

		eval {this, value}, {r0, r1}
		pop_scope
		return

	def_func_end
