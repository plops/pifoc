(defpackage :serial
  (:shadowing-import-from :cl close open ftruncate truncate time)
  (:use :cl :sb-posix)
  (:export #:open-serial
           #:close-serial
           #:fd-type
           #:serial-recv-length
           #:read-response
           #:write-serial
           #:talk-serial))

(defpackage :pifoc
  (:use :cl :serial)
  (:export #:get-position
           #:set-position
           #:connect
           #:disconnect))
