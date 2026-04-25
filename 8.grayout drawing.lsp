(defun delsolhat (/ d) 
  (vlax-for b (vla-get-blocks (setq d (vla-get-activedocument (vlax-get-acad-object)))) 
    (if (= :vlax-false (vla-get-isxref b)) 
      (vlax-for o b 
        (if 
          (and (= "AcDbWipeout" (vla-get-objectname o)) 
               (vlax-write-enabled-p o)
          )
          (vla-delete o)
        )
      )
    )
  )
  (vla-regen d acallviewports)
  (princ)
)



(defun dupax (/ col count *doc nazw obj block att col) 
  (vl-load-com)
  (setq col 251) ; Ustawiamy kolor
  (vlax-for block 
    (vla-get-blocks 
      (vla-get-activedocument 
        (vlax-get-acad-object)
      )
    )
    (vlax-for obj block 
      (if (eq "AcDbBlockReference" (vla-get-objectname obj)) 
        (if (= :vlax-true (vla-get-hasattributes obj)) 
          ;; Iteracja przez wszystkie atrybuty w referencji bloku
          (foreach att (vlax-invoke obj 'getattributes) 
            ;; Zmieñ kolor atrybutu
            (vla-put-Color att col)
          )
        )
      )
    )
  )
  (command "_REGEN")
  (princ)
)

(defun kolorynaprawall (/ *error* LAYER UFLAG layerList) 
  (vl-load-com)
  (defun *error* (msg) 
    (and UFlag (vla-EndUndoMark *doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*") 
        (princ (strcat "\n** Error: " msg " **"))
    )
    (princ)
  )


  (setq *doc (cond 
               (*doc)
               ((vla-get-ActiveDocument 
                  (vlax-get-acad-object)
                )
               )
             )
  )



  (progn 
    (setq uFlag (not (vla-StartUndoMark *doc)))

    (vlax-for lay (vla-get-Layouts *doc) 

      (vlax-for obj (vla-get-Block lay) 

        (vl-catch-all-apply 
          (function 
            (lambda (x) 
              (vla-put-color x 251)
              (vla-put-Lineweight x 5)
            )
          )
          (list obj)
        )
      )
    )


    (vlax-for blk (vla-get-Blocks *doc) 
      (if (/= (vla-get-Name blk) "*Model_Space") 

        (vlax-for obj blk 
          (vl-catch-all-apply 
            (function 
              (lambda (x) 
                (vla-put-layer x "0")
                (vla-put-Lineweight x 5)
                (vla-put-color x acByBlock)
              )
            )
            (list obj)
          )
        )
      )
    )

    (setq uFlag (vla-EndUndomark *doc))
  )





  (alert "Zakoñczone")


  (princ)
)



(defun c:kasiafix () 
  (dupax)
  (kolorynaprawall)
  (delsolhat)
)
