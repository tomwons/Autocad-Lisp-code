(setq oldsnapx (getvar "osmode"))
(defun trap3 (errmsg) 

  (setvar "osmode" oldsnapx)
  (setvar "CMDECHO" 1)
  (setvar "PLINEWID" 0)

  (setq *error* temperr)
  (prompt "\nResetting System Variables ")
)

;;; Helper function to get the point from pt1 perp to entity picked at point pt2
(defun GetPerpPoint (pt1 pt2 /) 
  (setvar "LASTPOINT" pt1)
  (osnap pt2 "_perp")
) ;_ end of defun

;;; Helper function to get the distance from pt1 perp to entity picked at point pt2
(defun GetPerpDist (pt1 pt2 /) 
  (distance pt1 (GetPerpPoint pt1 pt2))
) ;_ end of defun

(setq MFillet:Inc "Yes") ;Remember Stopniowanie fillet

;;; Fillet multiple lines by selecting with fences
(defun c:FILLETLINE420 (/ ss1 ss2 n m en1 en2 pt1 pt2 ptlast rad rad1 cmd *error*) 
  (setq temperr *error*)
  (setq *error* trap3)
  (command "_.UNDO" "_BEgin")
  (setq cmd (getvar "CMDECHO")) ;Get value of CMDECHO
  (setvar "CMDECHO" 0) ;Don't show prompts on command line
  (setvar "osmode" 0)


  (setq rad (getvar "FILLETRAD")) ;Get the normal fillet Promieñ

  (while (/= (type pt1) 'List) 
    (princ 
      (strcat "\nObecne ustawienia: Promieñ = " 
              (rtos rad)
              ", Stopniowanie = "
              MFillet:Inc
              "\n"
      ) ;_ end of strcat
    ) ;_ end of princ
    (initget "Promieñ Stopniowanie") ;Setup for keywords
    (setq pt1 (getpoint "Przeci¹gnij przez 1 grupe linii [Promieñ/Stopniowanie]: ")) ;Get 1st point
    (cond 
      ((and (= pt1 "Promieñ") 
            (setq rad1 (getDist (strcat "Nowy Promieñ <" (rtos rad) ">: ")))
       ) ;_ end of and
       (setq rad rad1)
      )
      ((= pt1 "Stopniowanie")
       (initget "Yes No")
       (if 
         (setq rad1 (getkword 
                      (strcat "Czy chcesz stopniowaæ Promieñ? [Yes/No] <" 
                              MFillet:Inc
                              ">: "
                      )
                    )
         )
         (setq MFillet:Inc rad1)
       ) ;_ end of if
      )
    ) ;_ end of cond
  ) ;_ end of while
  (setq pt2 (getpoint pt1 "Przeci¹gnij przez 1 grupe linii: ")
        ss1 (ssget "_F" 
                   (list pt1 pt2)
                   '((0 . "LINE")
                     (8 . "SVP_Extract,SVP_Supply")
                    )
            )
  ) ;_ end of setq
  (setq pt1 (getpoint "Przeci¹gnij przez 2 grupe linii: ")
        pt2 (getpoint pt1 "2 grupa linii: ")
        ss2 (ssget "_F" 
                   (list pt1 pt2)
                   '((0 . "LINE")
                     (8 . "SVP_Extract,SVP_Supply")
                    )
            )
  ) ;_ end of setq
  (setq n    0
        m    0
        rad1 0.0 ;Initialize the Promieñ to add
  ) ;_ end of setq
  (while (and ss1 ss2 (< n (sslength ss1)) (< m (sslength ss2))) 
    (setq en1 (ssname ss1 n)
          pt1 (cadr (cadddr (car (ssnamex ss1 n))))
          en2 (ssname ss2 m)
          pt2 (cadr (cadddr (car (ssnamex ss2 m))))
    ) ;_ end of setq
    (if (and ptlast (= MFillet:Inc "Yes")) 
      (setq rad1 (+ rad1 (GetPerpDist ptlast pt1)))
    ) ;_ end of if
    (setvar "FILLETRAD" (+ rad rad1))
    (command "_.FILLET" (list en1 pt1) (list en2 pt2))
    (setq n      (1+ n)
          m      (1+ m)
          ptlast pt1
    ) ;_ end of setq
  ) ;_ end of while
  (setvar "FILLETRAD" rad) ;Restore previous Promieñ
  (setvar "osmode" oldsnapx)
  (setvar "CMDECHO" 1)
  (setvar "PLINEWID" 0)
  (command "_.UNDO" "_End")
  (setq *error* temperr)



  (princ)
) ;_ end of defun


