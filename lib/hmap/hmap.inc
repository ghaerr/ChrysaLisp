;generic hash map
(import 'sys/lisp.inc)

(structure '+hmap 0
	(byte 'num_buckets+ 'cmp_fnc+ 'hash_fnc+ 'buckets+))

(defun-bind hmap (num_buckets &optional cmp_fnc hash_fnc)
	(setd cmp_fnc eql hash_fnc hash)
	(defq obj (cap (+ 3 (* num_buckets 2)) (list)))
	(push obj num_buckets cmp_fnc hash_fnc)
	(while (>= (setq num_buckets (dec num_buckets)) 0)
		(push obj (list) (list)))
	obj)

(defun-bind hmap-insert (obj key val)
	(defq b (+ +hmap_buckets+ (* (% ((elem +hmap_hash_fnc+ obj) key) (elem +hmap_num_buckets+ obj)) 2))
		e (some (# (if ((elem +hmap_cmp_fnc+ obj) %0 key) _)) (elem b obj)))
	(cond
		(e (elem-set e (elem (inc b) obj) val))
		(t (push (elem b obj) key) (push (elem (inc b) obj) val))))

(defun-bind hmap-find (obj key)
	(defq b (+ +hmap_buckets+ (* (% ((elem +hmap_hash_fnc+ obj) key) (elem +hmap_num_buckets+ obj)) 2))
		e (some (# (if ((elem +hmap_cmp_fnc+ obj) %0 key) _)) (elem b obj)))
	(if e (elem e (elem (inc b) obj))))

(defun-bind hmap-each (_obj _hf)
	(defq _i (- +hmap_buckets+ 2))
	(while (< (setq _i (+ _i 2)) (length _obj))
		(each _hf (elem _i _obj) (elem (inc _i) _obj)))
	_obj)

(defq o (hmap 10))
(hmap-insert o "bert" 'wendy)
(hmap-insert o "alf" 60)
(hmap-insert o "wally" (list 4 5 6))
(hmap-insert o "tristum" "qwerty")
(hmap-each o (# (print %0 " : " %1)))
(print "wally = " (hmap-find o "wally"))
(print "bert = " (hmap-find o "bert"))
(print "alf = " (hmap-find o "alf"))
(print "tristum = " (hmap-find o "tristum"))
(print o)