(ql:quickload :cl-ppcre)

(defparameter *tcase1* (uiop:read-file-lines "tcase1.txt"))

(defun make-pairs (l)
  (cond
    (l (cons (cons (first l) (second l))
             (make-pairs (cddr l))
             ))
    (t '())
    )
  )

(defun row-matches (rs)
  (make-pairs (ppcre:all-matches "\\d+" rs)))

(defun neighborhood (board row pair len)
  (let ((left (max 0 (- (car pair) 1)))
        (right (min (+ (cdr pair) 1) (length (car board)))))
    (mapcar (lambda (s) (subseq s left right))
            (list (nth (max 0 (- row 1)) board)
                  (nth row board)
                  (nth (min (- len 1) (+ row 1)) board)
                  )
            )
    )
  )

(defun check (n)
  (car (member t (mapcar (lambda (s) (not (null (ppcre:scan "[^\\.0-9]" s)))) n)))
  )

(defun process (board row len)
  (cond
    ((>= row len) 0)
    (t (let* ((rs (nth row board))
              (rm (row-matches rs)))
         (+ (reduce #'+
                    (mapcar (lambda (pair)
                              (if (check (neighborhood board row pair len))
                                  (parse-integer (subseq rs (car pair) (cdr pair)))
                                  0)
                              ) rm)
                    )
            (process board (+ row 1) len))
         )
       )
    )
  )

(defun part1 (lines)
  (process lines 0 (length lines))
  )
