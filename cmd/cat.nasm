%include 'inc/func.inc'
%include 'class/class_string.inc'
%include 'class/class_stream.inc'
%include 'class/class_stream_str.inc'
%include 'class/class_vector.inc'
%include 'class/class_slave.inc'

	def_func cmd/cat

		buffer_size equ 120

		ptr slave, arg, args, stream
		ulong argc, index, length
		struct buffer, buffer

		;init app vars
		push_scope

		;initialize pipe details and command args, abort on error
		func_call slave, create, {}, {slave}
		if {slave}
			;cat files to stdout, arg 1 is command name
			func_call slave, get_args, {slave}, {args}
			devirt_call vector, get_length, {args}, {argc}
			if {argc != 1}
				;names from command line
				assign {1}, {index}
				loop_while {index != argc}
					devirt_call vector, ref_element, {args, index}, {arg}
					local_call cat_string, {slave, arg, &buffer}, {r0, r1, r2}
					assign {index + 1}, {index}
				loop_end
			else
				;names from stdin
				loop_start
					func_call stream, read_line, {slave->slave_stdin, &buffer, buffer_size}, {length}
					breakif {length == -1}
					func_call string, create_from_buffer, {&buffer, length}, {arg}
					local_call cat_string, {slave, arg, &buffer}, {r0, r1, r2}
				loop_end
			endif

			;clean up
			func_call slave, deref, {slave}
		endif
		pop_scope
		return

	cat_string:
		;r0 = slave
		;r1 = arg string
		;r2 = buffer

		const char_lf, 10

		ptr slave, arg, buffer, file, stream
		ulong length

		push_scope
		retire {r0, r1, r2}, {slave, arg, buffer}

		func_call string, create_from_file, {&arg->string_data}, {file}
		func_call string, deref, {arg}
		if {file}
			func_call stream_str, create, {file}, {stream}
			loop_start
				func_call stream, read_line, {stream, buffer, buffer_size}, {length}
				breakif {length == -1}
				func_call stream, write, {slave->slave_stdout, buffer, length}
				func_call stream, write_char, {slave->slave_stdout, char_lf}
				func_call sys_task, yield
			loop_end
			virt_call stream, write_flush, {slave->slave_stdout}
			func_call stream, deref, {stream}
		endif

		pop_scope
		return

	def_func_end
