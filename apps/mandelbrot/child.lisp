;imports
(import 'sys/lisp.inc)
(import 'class/lisp.inc)
(import 'gui/lisp.inc)

(structure 'work 0
	(long 'mbox 'x 'y 'x1 'y1 'w 'h))

(defun-bind depth (x0 y0)
	(defq i -1 xc 0 yc 0 x2 0 y2 0)
	(while (and (/= (setq i (inc i)) 255) (< (+ x2 y2) (const (fmul 2.0 2.0))))
		(setq yc (+ (fmul 2.0 xc yc) y0) xc (+ (- x2 y2) x0)
			x2 (fmul xc xc) y2 (fmul yc yc))) i)

;native versions
(ffi depth "apps/mandelbrot/depth" 0)

(defun-bind mandel (xp y x1 y1 w h)
	(defq reply (string-stream (cat "")))
	(write reply (cat (char mbox (const long_size))
		(char x (const long_size)) (char y (const long_size))
		(char x1 (const long_size)) (char y1 (const long_size))))
	(setq y (dec y))
	(while (/= (setq y (inc y)) y1)
		(defq x (dec xp))
		(while (/= (setq x (inc x)) x1)
			(write reply (char (depth (/ (* (- x (/ w 2) (/ w 4)) 2.0) w) (/ (* (- y (/ h 2)) 2.0) h)))))
		(task-sleep 0))
	(mail-send (str reply) mbox))

(defun-bind rect (mbox x y x1 y1 w h)
	(cond
		((>= (* (- x1 x) (- y1 y)) (const (* 129 129)))
			;split into more tasks
			(defq farm (open-farm "apps/mandelbrot/child.lisp" 3 kn_call_child)
				x2 (+ x (/ (- x1 x) 2)) y2 (+ y (/ (- y1 y) 2)))
			(mail-send (array mbox x y x2 y2 w h) (elem 0 farm))
			(mail-send (array mbox x2 y x1 y2 w h) (elem 1 farm))
			(mail-send (array mbox x y2 x2 y1 w h) (elem 2 farm))
			(rect mbox x2 y2 x1 y1 w h))
		(t	;do here
			(mandel x y x1 y1 w h))))

;read work request
(defq msg (mail-read (task-mailbox)))
(rect (get-long msg work_mbox) (get-long msg work_x) (get-long msg work_y)
	(get-long msg work_x1) (get-long msg work_y1) (get-long msg work_w) (get-long msg work_h))
