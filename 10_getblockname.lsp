;(bidet, centrala, kibel, miska, lodówka, pisuar, pralka, prysznic, umywalka, wanna, wodomierz, zlew, zrodlo, kran, zlowozmywarka,)



(defun c:getblockname () 
  (setq selList (list))
  (while (setvar 'errno 0) 
    (setq sel (car (entsel "Wybierz blok: ")))
    (cond 
      ((= 7 (getvar 'errno))
       (alert "Nie wybrano ¿adnego bloku.")
      )
      (T
       (if sel 
         (progn 
           (setq name (cdr (assoc 2 (entget sel))))
           (setq entn (getstring "\nCo to jest? "))

           (setq text (strcat "(" "\"" name "\" . \"""svp_" entn "\"" ")"))
           (setq filename (strcat "D:/Dane/Pulpit/autocaddane.txt"))
           (if (findfile filename) 
             (progn 
               (setq file (open filename "a"))
               (write-line text file)
               (close file)
             )
             (progn 
               (setq file (open filename "w"))
               (write-line text file)
               (close file)
             )
           )
         )
       )
      )
    )
  )
)
