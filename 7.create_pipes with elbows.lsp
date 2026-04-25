(defun trap2 (errmsg) 

  (setvar "FILLMODE" 1)
  (setvar "CMDECHO" 1)
  (setvar "PLINEWID" 0)

  (setq *error* temperr)
  (prompt "\nResetting System Variables ")
)

(setq promien 490) ;Remember Promień 
(setq widthF 140);Remember szerokość
(setq kolan "N")
(setq typr "flat51")

(defun c:flat51 (/ oldWd oldFil oldEch lEnt pl1 pl2 vLst1 vLst2 *error* oldFil oldEch 
                 cOption
                ) 
  (setq temperr *error*)
  (setq *error* trap2)
  (vl-load-com)
  (command "_.UNDO" "_BEgin")
  (defun GetPlineVer (plObj) 
    (mapcar 'cdr 
            (vl-remove-if-not 
              '(lambda (x) (= (car x) 10))
              (entget plObj)
            )
    )
  ) ; end of GetPLineVer
  (setq oldFil (getvar "FILLMODE")
        oldEch (getvar "CMDECHO")
  ) ; end setq
  (setvar "FILLMODE" 0)
  (setvar "CMDECHO" 0)

  (setq lEnt2 nil)
  (while (/= (type lEnt2) 'List) 
    (princ 
      (strcat "\nObecne ustawienia: " 
              typr
              "\n"
      ) ;_ end of strcat
    ) ;_ end of princ
    (initget "flat51 plugkanal113 comfo160 comfo200") ;Setup for keywords
    (setq lEnt2 (getpoint "Wybierz pierwszy punkt [flat51/plugkanal113/comfo160/comfo200]: ")) ;Get 1st point
    (cond 
      ((= lEnt2 "flat51")
       (progn 
         (setq wid1 140)
         (setq widthF wid1)
         (setq promien 490)
         (setq kolan "N")
         (setq typr "flat51")
       )
      )
      ((= lEnt2 "plugkanal113")
       (progn 
         (setq wid1 113)
         (setq widthF wid1)
         (setq promien 390)
         (setq kolan "N")
         (setq typr "plugkanal113")
       )
      )

      ((= lEnt2 "comfo160")
       (progn 
         (setq wid1 190)
         (setq widthF wid1)
         (setq promien 200)
         (setq kolan "Y")
         (setq typr "comfo160")
       )
      )
      ((= lEnt2 "comfo200")
       (progn 
         (setq wid1 230)
         (setq widthF wid1)
         (setq promien 250)
         (setq kolan "Y")
         (setq typr "comfo200")
       )
      )
    )
  )
  (if (entlast) (setq lEnt (entlast)))
  (princ "\nSpesify start point: ")
  (command "_.pline" lEnt2 pause)
  (command "_w" widthF widthF)
  (while (= 1 (getvar "CMDACTIVE")) 
    (command pause)
    (princ "\nSpecify next point: ")
  ) ; end while
  (if 
    (not 
      (equal lEnt (entlast))
    )
    (progn 
      (setq promien2 promien)
      (setq lEnt (entlast))
      (command "_.fillet" "_r" promien2)
      (command "_.fillet" "_p" lEnt)
      (setq lEnt  (vlax-ename->vla-object lEnt)
            pl1   (car 
                    (vlax-safearray->list 
                      (vlax-variant-value 
                        (vla-Offset lEnt (/ widthF 2))
                      )
                    )
                  )
            pl2   (car 
                    (vlax-safearray->list 
                      (vlax-variant-value 
                        (vla-Offset lEnt (- (/ widthF 2)))
                      )
                    )
                  )
            vLst1 (GetPlineVer 
                    (vlax-vla-object->ename pl1)
                  )
            vLst2 (GetPlineVer 
                    (vlax-vla-object->ename pl2)
                  )
      ) ; end setq
      (vla-put-ConstantWidth pl1 0.0)
      (vla-put-ConstantWidth pl2 0.0)
      (vla-Delete lEnt)
      (if (equal kolan "Y") 
        (foreach itm vLst1 
          (command "._line" itm (car vLst2) "")
          (setq vLst2 (cdr vLst2))
        )
      )
    ) ; end progn
  ) ; end if
  (setvar "FILLMODE" 1)
  (setvar "CMDECHO" 1)
  (setvar "PLINEWID" 0)
  (command "._UNDO" "_End")
  (setq *error* temperr)
  (princ)
) ;_ end of defun