(import "class/lisp.inc")
(import "lib/options/options.inc")

;read up to chunk_size chars from stream
(defun read-chunk (_)
	(defq chunk (list))
	(while (and (/= chunk_size (length chunk))
			(defq c (read-char _))
			(push chunk c)))
	(if (/= 0 (length chunk)) chunk))

;dump a file to stdout
(defun dump-file (_)
	(when _
		(defq adr 0)
		(while (defq c (read-chunk _))
			(prin (int-to-hex-str adr) " " (apply cat (map (lambda (_)
				(cat (byte-to-hex-str _) " ")) c)))
			(times (- chunk_size (length c)) (prin "   "))
			(print (apply cat (map (lambda (_)
				(if (<= 32 _ 126) (char _) ".")) c)))
			(setq adr (+ adr chunk_size)))))

(defq usage `(
(("-h" "--help")
"Usage: dump [options] [path] ...
	options:
		-h --help: this help info.
		-c --chunk num: chunk size, default 8.
	If no paths given on command line
	then will dump stdin.")
(("-c" "--chunk")
	,(lambda (args arg)
		(setq chunk_size (str-as-num (elem-get 0 args)))
		(slice 1 -1 args)))
))

(defun main ()
	;initialize pipe details and command args, abort on error
	(when (and
			(defq stdio (create-stdio))
			(defq chunk_size 8 args (options stdio usage)))
		(if (<= (length args) 1)
			;dump from stdin
			(dump-file (io-stream 'stdin))
			;dump from args as files
			(each (# (dump-file (file-stream %0))) (slice 1 -1 args)))))
