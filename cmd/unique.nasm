%include 'inc/func.inc'
%include 'class/class_string.inc'
%include 'class/class_stream.inc'
%include 'class/class_vector.inc'
%include 'class/class_slave.inc'
%include 'class/class_unordered_set.inc'

	def_func cmd/unique

		buffer_size equ 120

		ptr slave, arg, args, stream, set
		ulong argc, index, length
		struct buffer, buffer

		;init app vars
		push_scope

		;initialize pipe details and command args, abort on error
		func_call slave, create, {}, {slave}
		if {slave}
			;create string set
			func_call unordered_set, create, {@class/string/compare, 31}, {set}

			;arg 1 is command name
			func_call slave, get_args, {slave}, {args}
			devirt_call vector, get_length, {args}, {argc}
			if {argc != 1}
				;from command line
				assign {1}, {index}
				loop_while {index != argc}
					func_call vector, get_element, {args, index}, {arg}
					func_call unordered_set, insert, {set, arg}, {_, _}
					assign {index + 1}, {index}
				loop_end
			else
				;from stdin
				loop_start
					func_call stream, read_line, {slave->slave_stdin, &buffer, buffer_size}, {length}
					breakif {length == -1}
					func_call string, create_from_buffer, {&buffer, length}, {arg}
					func_call unordered_set, insert, {set, arg}, {_, _}
					func_call string, deref, {arg}
				loop_end
			endif

			;output string set
			func_call unordered_set, for_each, {set, $callback, slave}, {_, _}
			func_call unordered_set, deref, {set}

			;clean up
			func_call slave, deref, {slave}
		endif
		pop_scope
		return

	callback:
		;inputs
		;r0 = predicate data pointer
		;r1 = element iterator
		;outputs
		;r1 = 0 if break, else not

		const char_lf, 10
		pptr iter
		ptr pdata

		push_scope
		retire {r0, r1}, {pdata, iter}

		func_call stream, write, {pdata->slave_stdout, &(*iter)->string_data, (*iter)->string_length}
		func_call stream, write_char, {pdata->slave_stdout, char_lf}

		eval {1}, {r1}
		pop_scope
		return

	def_func_end
