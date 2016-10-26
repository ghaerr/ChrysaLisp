%include 'inc/func.inc'
%include 'class/class_unordered_map.inc'
%include 'class/class_lisp.inc'

	def_func class/lisp/env_push
		;inputs
		;r0 = lisp object
		;outputs
		;r0 = lisp object

		ptr this, env

		push_scope
		retire {r0}, {this}

		func_call unordered_map, create, {this->lisp_enviroment->unordered_set_key_callback, 1}, {env}
		func_call unordered_map, insert, {env, this->lisp_sym_parent, this->lisp_enviroment}, {_, _}
		func_call ref, deref, {this->lisp_enviroment}
		assign {env}, {this->lisp_enviroment}

		eval {this}, {r0}
		pop_scope
		return

	def_func_end
