(asdf:defsystem pifoc
  :depends-on (:sb-posix)
  :components ((:module "pifoc"
                        :serial t
                        :components ((:file "package")
                                     (:file "serial")
                                     (:file "focus")))))
