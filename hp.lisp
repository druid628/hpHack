#!/usr/local/bin/clisp
(use-package :socket)

;; Comment out for a more accurate emulation of hp.c...
(push :hush *features*)

(defun encode (message)
  (format nil "~C%-12345X@PJL RDYMSG DISPLAY = ~S~%~C%-12345X~%"
	  #\Escape message #\Escape))

(defun set-display (message host &optional (port 9100))
  #-hush (write-line "Connecting...")
  (with-open-stream (socket (socket-connect port host :external-format :dos))
    (format t "Sent ~D bytes.~%"
	    (length (write-sequence (encode message) socket)))))

(defun wave (message host)
  (format t "HP Display hack -- based on hp.c by sili@l0pht.com~%~
             Hostname:   ~A~%~
             Message: ~A~%"
	  host message))
  
(let ((host (car ext:*args*))
      (message (cadr ext:*args*)))
  #-hush (wave message host)
  (set-display message host))

