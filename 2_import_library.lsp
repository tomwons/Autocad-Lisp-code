(defun c:MERGEFILE () 
  (setq file-namex "Projektowanie nowe.dwg") ;!zamieñ nazwapliku na aktualna nazwê
  (setq full-pathx (findfile file-namex))
  (if full-pathx 
    (progn 
      (princ (strcat "\n File found at: " full-pathx))
      (setvar "cmdecho" 0)
      (setvar "ATTDIA" 0)
      (command "._-layer" "OD" "*" "")
      (setq pt 0)
      (command "_-insert" full-pathx pt "1" "1" "0")
      (setvar "cmdecho" 1)
      (setvar "ATTDIA" 1)
    )
    (progn 
      (alert (strcat "File not found in directory "))
    )
  )
  (princ)
)

