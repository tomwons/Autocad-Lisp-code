;; Parses a CSV file into a matrix list of cell values.
;; csv - [str] filename of CSV file to read
 
(defun LM:readcsv (csv / des lst sep str) 
  (if (setq des (open csv "r")) 
    (progn 
      (setq sep ",")
      (while (setq str (read-line des)) 
        (setq lst (cons (LM:csv->lst str sep 0) lst))
      )
      (close des)
    )
  )
  (reverse lst)
)

;; Parses a line from a CSV file into a list of cell values.
;; str - [str] string read from CSV file
;; sep - [str] CSV separator token
;; pos - [int] initial position index (always zero)
 
(defun LM:csv->lst (str sep pos / s) 
  (cond 
    ((not (setq pos (vl-string-search sep str pos)))
     (if (wcmatch str "\"*\"") 
       (list (LM:csv-replacequotes (substr str 2 (- (strlen str) 2))))
       (list str)
     )
    )
    ((or (wcmatch (setq s (substr str 1 pos)) "\"*[~\"]") 
         (and (wcmatch s "~*[~\"]*") (= 1 (logand 1 pos)))
     )
     (LM:csv->lst str sep (+ pos 2))
    )
    ((wcmatch s "\"*\"")
     (cons 
       (LM:csv-replacequotes (substr str 2 (- pos 2)))
       (LM:csv->lst (substr str (+ pos 2)) sep 0)
     )
    )
    ((cons s (LM:csv->lst (substr str (+ pos 2)) sep 0)))
  )
)

(defun LM:csv-replacequotes (str / pos) 
  (setq pos 0)
  (while (setq pos (vl-string-search "\"\"" str pos)) 
    (setq str (vl-string-subst "\"" "\"\"" str pos)
          pos (1+ pos)
    )
  )
  str
)

(defun pobierzdane (nzhaus / data file) 
  (if 
    (and 
      (setq file (findfile nzhaus))
      (setq data (LM:readcsv file))
    )
    (progn 
      (setq data (cdr data))
      (setq result '()) ;; initialize empty list
      (foreach line data 
        (setq result (cons (mapcar 'strcase line) result)) ;; convert to lowercase and add to result list
      )
      (reverse result) ;; reverse the order of the list
    )
  )
)


(defun c:LAYERSTOGGLE (/ layobj) 
  (vl-load-com)
    (progn 
      (setvar "clayer" "0")
      (foreach rel (setq dane (pobierzdane "listawarstw.csv")) 
        (if 
          (and 
            (setq layobj (tblobjname "layer" (car rel)))
            (setq colorx (cadr rel))
            (setq view (caddr rel))
          )
          (progn 
            (vla-put-LayerOn (vlax-ename->vla-object layobj) 1)
            (if (not (equal colorx "")) 
              (vla-put-color (vlax-ename->vla-object layobj) colorx)
            )
            (vla-put-freeze (vlax-ename->vla-object layobj) 0)
            (vla-put-Lock (vlax-ename->vla-object layobj) 0)
          )
        )
      )
  )

  (command "_regen")
  (princ)
)
