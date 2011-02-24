(in-package :pifoc)

(defvar *stream* nil)
(defvar *fd* nil)

;; FIXME I could use that maximum request size and answer size is 25
;; FIXME measure speed of the system

(defun run-shell (command)
  (with-output-to-string (stream)
    (sb-ext:run-program "/bin/bash" (list "-c" command)
                        :input nil
                        :output stream)))

(defun find-pifoc-usb-adapter ()
  (let ((port (run-shell "dmesg|grep pl2303|grep ttyUSB|tail -n1|sed s+.*ttyUSB+/dev/ttyUSB+g|tr -d '\\n'")))
    (if (string-equal "" port)
        (error "dmesg output doesn't contain ttyUSB assignment. This can happen when the system ran a long time.
 You could reattach the USB adapter that is connected to the microscope.")
        port)))

#+nil
(find-pifoc-usb-adapter)

(defun connect (&optional (devicename (find-pifoc-usb-adapter)))
  (multiple-value-bind (s fd)
      (open-serial devicename)
    (defparameter *stream* s)
    (defparameter *fd* fd)))
#+nil
(connect)

(defun disconnect ()
  (close-serial *fd*)
  (setf *stream* nil))

#+nil
(disconnect)
 
(defun set-position (position-um)
  (declare (single-float position-um))
  (write-serial *stream*
		(format nil "MOV A~f" position-um)))

(defun get-position ()
  (declare (values single-float &optional))
  (read (talk-serial *fd* *stream* "POS? A")))

(defun on-target-p ()
  (let ((response (talk-serial *fd* *stream* "ONT? A")))
    (cond ((string= "1" response) t)
	  ((string= "0" response) nil)
	  (t (error "unexpected answer to ONT? A: ~a" response)))))