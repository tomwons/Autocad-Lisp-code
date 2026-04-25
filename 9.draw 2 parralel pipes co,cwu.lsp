(defun trap2 (errmsg) 
  (setvar "FILLMODE" 1)
  (setvar "CMDECHO" 1)
  (setvar "PLINEWID" 0)

  (setq *error* temperr)
  (prompt "\nResetting System Variables ")
)
(setq pro 0) ;Remember Promieñ 
(setq wid 80);Remember szerokoœæ
(setq orientationdir "lewo")
(setq kolanko "N")
(setq ruraka "HEIZUNG")
(setq linetype "Hidden2")
(setq linescale "500")
(setq layer1 "SVP_Heizungsrücklauf")
(setq layer2 "SVP_Heizungsvorlauf")


(defun c:pipedrawing (/ oldWd oldFil oldEch lEnt pl1 pl2 vLst1 vLst2 *error* oldFil 
                      oldEch cOption
                     ) 
  (setq temperr *error*)
  (setq *error* trap2)
  (vl-load-com)
  (command "_.UNDO" "_BEgin")

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun GetPlineVerAndPrint (plObj) 
    (setq points (GetPlineVer plObj)) ; Uzyskujemy wszystkie punkty

    ;; Sprawdzanie poprawnoœci punktów
    (if 
      (and (>= (length points) 2)  ; Czy s¹ co najmniej dwa punkty
           (listp (car points)) ; Czy pierwszy punkt to lista wspó³rzêdnych
           (listp (cadr points)) ; Czy drugi punkt to lista wspó³rzêdnych
           (numberp (car (car points))) ; Czy X pierwszego punktu to liczba
           (numberp (cadr (car points))) ; Czy Y pierwszego punktu to liczba
           (numberp (car (cadr points))) ; Czy X drugiego punktu to liczba
           (numberp (cadr (cadr points))) ; Czy Y drugiego punktu to liczba
      )
      (progn 
        ;; Pobierz pierwszy i drugi punkt
        (setq first-point (car points))
        (setq second-point (cadr points))

        ;; Oblicz ró¿nice
        (setq dx (- (car second-point) (car first-point))) ; Ró¿nica X
        (setq dy (- (cadr second-point) (cadr first-point))) ; Ró¿nica Y

        ;; Okreœlenie kierunku
        (cond 
          ;; Warunki dla LEWO
          ((or 
             (and (< dx 0) (= dy 0)) ; X maleje, Y bez zmian
             (and (< dx 0) (> dy 0)) ; X maleje, Y roœnie
             (and (= dx 0) (> dy 0)) ; X bez zmian, Y roœnie
             (and (> dx 0) (> dy 0)) ; X roœnie, Y roœnie
           )
           (setq orientationdir "lewo")
           (princ "/n Kierunek Lewo")
          )

          ;; Warunki dla PRAWO
          ((or 
             (and (> dx 0) (= dy 0)) ; X roœnie, Y bez zmian
             (and (> dx 0) (< dy 0)) ; X roœnie, Y maleje
             (and (= dx 0) (< dy 0)) ; X bez zmian, Y maleje
             (and (< dx 0) (< dy 0)) ; X maleje, Y maleje
           )
           (setq orientationdir "prawo")
           (princ "/n Kierunek Prawo")
          )

          ;; Nieokreœlony kierunek (opcjonalne)
          (t (setq orientationdir "Brak kierunku"))
        )
      )
      ;; Jeœli punkty s¹ nieprawid³owe
      (setq orientationdir "B³¹d: Brak wystarczaj¹cej liczby punktów lub dane s¹ nieprawid³owe.")
    )
  )


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; Funkcja GetPlineVer - zachowujemy j¹ bez zmian
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
              ruraka
              "\n"
      ) ;_ end of strcat
    ) ;_ end of princ
    (initget "HEIZUNG LINKEWASSER RECHTEWASSER") ;Setup for keywords
    (setq lEnt2 (getpoint "Wybierz pierwszy punkt [HEIZUNG/LINKEWASSER/RECHTEWASSER]: ")) ;Get 1st point
    (cond 
      ((= lEnt2 "HEIZUNG")
       (progn 
         (setq ruraka "HEIZUNG")
         (setq wid1 80)
         (setq wid wid1)
         (setq pro 0)
         (setq kolanko "N")
       )
      )
      ((= lEnt2 "LINKEWASSER")
       (progn 
         (setq ruraka "LINKEWASSER")
         (setq wid1 80)
         (setq wid wid1)
         (setq pro 0)
         (setq kolanko "N")
       )
      )
      ((= lEnt2 "RECHTEWASSER")
       (progn 
         (setq ruraka "RECHTEWASSER")
         (setq wid1 80)
         (setq wid wid1)
         (setq pro 0)
         (setq kolanko "N")
       )
      )
    )
  )
  (if (entlast) (setq lEnt (entlast)))
  (princ "\nSpesify start point: ")
  (command "_.pline" lEnt2 pause)
  (command "_w" wid wid)
  (while (= 1 (getvar "CMDACTIVE")) 
    (command pause)
    (princ "\nSpecify next point: ")
  ) ; end while
  (if 
    (not 
      (equal lEnt (entlast))
    )
    (progn 
      (setq promien2 pro)
      (setq lEnt (entlast))
      (command "_.fillet" "_r" promien2)
      (command "_.fillet" "_p" lEnt)
      (setq lEnt  (vlax-ename->vla-object lEnt)
            pl1   (car 
                    (vlax-safearray->list 
                      (vlax-variant-value 
                        (vla-Offset lEnt (/ wid 2))
                      )
                    )
                  )
            pl2   (car 
                    (vlax-safearray->list 
                      (vlax-variant-value 
                        (vla-Offset lEnt (- (/ wid 2)))
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

      ; Wywo³anie GetPlineVerAndPrint, aby wydrukowaæ wspó³rzêdne
      (GetPlineVerAndPrint (vlax-vla-object->ename pl1))

      (vla-put-ConstantWidth pl1 0.0)
      (vla-put-ConstantWidth pl2 0.0)

      (cond 
        ((equal ruraka "HEIZUNG")
         (progn 
           (cond 
             ((equal orientationdir "lewo")
              (progn 
                (setq layer1 "SVP_Heizungsvorlauf")
                (setq layer2 "SVP_Heizungsrücklauf")
                (vla-put-Linetype pl1 linetype)
                (vla-put-LinetypeScale pl1 linescale)
              )
             )
             ((equal orientationdir "prawo")
              (progn 
                ;; Kod dla przypadku, gdy ORIENT jest "prawo"
                (vla-put-Linetype pl2 linetype)
                (vla-put-LinetypeScale pl2 linescale)
                (setq layer1 "SVP_Heizungsrücklauf")
                (setq layer2 "SVP_Heizungsvorlauf")
              )
             )
           )
         )
        )

        ((equal ruraka "LINKEWASSER")
         (cond 
           ((equal orientationdir "prawo")
            (progn 
              (progn 
                (setq layer1 "SVP_Trinkwasser Warm")
                (setq layer2 "SVP_Trinkwasser Kalt")
                (vla-put-Linetype pl1 linetype)
                (vla-put-LinetypeScale pl1 linescale)
              )
            )
           )
           ((equal orientationdir "lewo")
            (progn 
              (setq layer1 "SVP_Trinkwasser Kalt")
              (setq layer2 "SVP_Trinkwasser Warm")
              (vla-put-Linetype pl2 linetype)
              (vla-put-LinetypeScale pl2 linescale)
            )
           )
         )
        )
        ((equal ruraka "RECHTEWASSER")
         (cond 
           ((equal orientationdir "lewo")
            (progn 
              (progn 
                (setq layer1 "SVP_Trinkwasser Warm")
                (setq layer2 "SVP_Trinkwasser Kalt")
                (vla-put-Linetype pl1 linetype)
                (vla-put-LinetypeScale pl1 linescale)
              )
            )
           )
           ((equal orientationdir "prawo")
            (progn 
              (setq layer1 "SVP_Trinkwasser Kalt")
              (setq layer2 "SVP_Trinkwasser Warm")
              (vla-put-Linetype pl2 linetype)
              (vla-put-LinetypeScale pl2 linescale)
            )
           )
         )
        )
      )
      ;; Przenieœ polilinie na odpowiednie warstwy
      (vla-put-Layer pl1 layer1)
      (vla-put-Layer pl2 layer2)

      (vla-Delete lEnt)
      (if (equal kolanko "Y") 
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
)