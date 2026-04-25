(defun restore () 
  (setq oldsnapik (getvar "osmode"))
)
(defun trap2 (errmsg) 

  (setvar "FILLMODE" 1)
  (setvar "CMDECHO" 1)
  (setvar "ATTDIA" 1)
  (setvar "osmode" oldsnapik)
  (setq *error* temperr)
  (prompt "\nResetting System Variables ")
)




(defun printinput (selectionList relation2) 
  (princ 
    (strcat "\n" 
            "\n - 3ci :"
            (cond 
              ((cdr (assoc (caaddr (reverse selectionList)) relation2)))
              ("")
            )
            "\n - 2gi:"
            (cond 
              ((cdr (assoc (caadr (reverse selectionList)) relation2)))
              ("")
            )
            "\n - ostatni:"
            (cond ((cdr (assoc (caar (reverse selectionList)) relation2))) (""))
    )
  )
)

(defun testDialog () 
  (setq dialog (load_dialog "example.dcl"))
  (if (not (new_dialog "example" dialog)) 
    (progn 
      (alert "B³¹d podczas ³adowania pliku DCL")
      (exit)
    )
  )

  ;; Dodajemy akcje dla poszczególnych opcji
  (action_tile "opt1" "(setq entName \"OKC-DDWH\")")
  (action_tile "opt2" "(setq entName \"Pompy S1255-1256\")")
  (action_tile "opt3" "(setq entName \"VVM S320\")")
  (action_tile "opt4" "(setq entName \"OKC-DDWH_cyrk\")")
  (action_tile "opt5" "(setq entName \"Pompy S1255-1256_cyrk\")")
  (action_tile "opt6" "(setq entName \"VVM S320_cyrk\")")

  (action_tile "ok" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")
  (start_dialog)
  (unload_dialog dialog)
)

(defun funkpom (entName relation2) 
  (setq found nil)
  (foreach relation relation2 
    (if (equal entName (car relation)) 
      (progn 
        (setq found t)
        (setvar "cmdecho" 0)
        (setvar "ATTDIA" 0)
        (setq insBlok (cdr relation))
        ;; Obs³uga dla svp_zrodlo
        (if (equal insBlok "svp_zrodlo") 
          (progn 
            (testDialog)
          )
        )
        ;; Obs³uga dla svp_wodomierz
        (if (equal insBlok "svp_wodomierz") 
          (progn 
            (setq odkamieniacz (getstring "Czy ma byæ odkamieniacz? (T/N)"))
            (if (or (equal odkamieniacz "T") (equal odkamieniacz "t")) 
              (setq entName "wod_odkam")
            )
          )
        )
        ;; Przywracanie zmiennych
        (setvar "cmdecho" 1)
        (setvar "ATTDIA" 1)
      )
    )
  )
  ;; Zwróæ now¹ wartoœæ entName lub oryginaln¹, jeœli brak dopasowania
  entName
)

(defun c:drawnik (/ *error*) 
  (restore)
  (setq temperr *error*)
  (setq *error* trap2)
  (setq selectionList (list))
  (setq relation2 '(("bidet" . "svp_bidet")
                    ("bid" . "svp_bidet")
                    ("centrala" . "svp_centrala")
                    ("cen" . "svp_centrala")
                    ("kibel" . "svp_kibel")
                    ("kib" . "svp_kibel")
                    ("kran" . "svp_kranik")
                    ("kra" . "svp_kranik")
                    ("lodowka" . "svp_lodówka")
                    ("lod" . "svp_lodówka")
                    ("pisuar" . "svp_pisuar")
                    ("pis" . "svp_pisuar")
                    ("prysznic" . "svp_prysznic")
                    ("pry" . "svp_prysznic")
                    ("pralka" . "svp_pralka")
                    ("pra" . "svp_pralka")
                    ("umywalka" . "svp_umywalka")
                    ("umy" . "svp_umywalka")
                    ("wanna" . "svp_wanna")
                    ("wan" . "svp_wanna")
                    ("p1" . "svp_pion1")
                    ("p2" . "svp_pion2")
                    ("p3" . "svp_pion3")
                    ("wodomierz" . "svp_wodomierz")
                    ("wod" . "svp_wodomierz")
                    ("wod_odkam" . "svp_wod_odkam")
                    ("zlewzmywarka" . "svp_zlewzmywarka")
                    ("zle" . "svp_zlewzmywarka")
                    ("zlew" . "svp_zlewzmywarka")
                    ("zrodlo" . "svp_zrodlo")
                    ("zro" . "svp_zrodlo")
                    ("OKC-DDWH" . "OKC-DDWH")
                    ("Pompy S1255-1256" . "Pompy S1255-1256")
                    ("VVM S320" . "VVM S320")
                    ("OKC-DDWH_cyrk" . "OKC-DDWH_cyrk")
                    ("Pompy S1255-1256_cyrk" . "Pompy S1255-1256_cyrk")
                    ("VVM S320_cyrk" . "VVM S320_cyrk")
                   )
  )
  (while (setvar 'errno 0)  ; reset errno - necessary
    (setq entName (getstring "\nPodaj nazwe sanitariatu: "))
    ;; Weryfikacja wprowadzonej nazwy i aktualizacja zmiennej
    (setq entName (funkpom entName relation2))
    (while (not found) 
      (if (or (not entName) (= entName "")) 
        ;; Jeœli entName jest puste (brak wartoœci lub pusty ci¹g)

        (progn 
          (setq endmeabe (getstring "\nDel Ostatni (C)\nWróæ (W)\nZakoñcz (Spacja)\n "))
          (cond 
            ((or (equal endmeabe "c") (equal endmeabe "C"))
             (if selectionList 
               (progn 
                 (setq selectionList (reverse (cdr (reverse selectionList))))
                 (printinput selectionList relation2)
               )
               (alert "Nie ma ju¿ wiêcej pozycji do usuniêcia.")
             )
            )
            ((or (equal endmeabe "w") (equal endmeabe "W"))
             (setq found t)
            )
            (T
             (progn 
               (if selectionList 
                 (progn 
                   (setq p1 nil)
                   (setq pointSelected 0)
                   (while (not p1) 
                     (if (= pointSelected 0) 
                       (progn 

                         (setq p1 (getpoint "wybierz punkt wstawiania rozwiniêcia "))
                         (if (not p1) 
                           (alert "Nie poprawne dane. Spróbuj ponownie.")
                           (setq pointSelected 1)
                         )
                       )
                     )
                   )
                   (setq offset 0)

                   (setvar "osmode" 0)
                   (foreach selection selectionList  ; przegl¹da wszystkie wybrane obiekty i przypisuje je do selection
                     (setq entName (car selection)) ; wpisuje wartoœæ 1 zlew
                     (setq exitName (cdr selection)) ;wpisuje wartoœæ 2 np svp_zlew
                     (foreach relation relation2  ;przegl¹da wszystkie definicje z listy relation2 i przypisuje je do relation
                       (if (equal entName (car relation))  ;
                         (progn 
                           (setvar "cmdecho" 0)
                           (setvar "ATTDIA" 0)
                           (setq insBlok (cdr relation))
                           (if (equal insBlok "svp_zrodlo") 
                             (setq offset (+ offset 1300))
                           )
                           (if (equal insBlok "svp_wodomierz") 
                             (setq offset (+ offset 1300))
                           )
                           (if (equal insBlok "svp_wod_odkam") 
                             (setq offset (+ offset 1600))
                           )
                           (if 
                             (or (equal insBlok "svp_zrodlo_cyrk") 
                                 (equal insBlok "svp_zrodlo")
                                 (equal insBlok "OKC-DDWH")
                                 (equal insBlok "Pompy S1255-1256")
                                 (equal insBlok "VVM S320")
                                 (equal insBlok "OKC-DDWH_cyrk")
                                 (equal insBlok "Pompy S1255-1256_cyrk")
                                 (equal insBlok "VVM S320_cyrk")
                             )
                             (setq offset (+ offset 1300))
                           )
                           (if (equal insBlok "svp_zlewzmywarka") 
                             (setq offset (+ offset 600))
                           )
                           (if (equal insBlok "svp_wanna") 
                             (setq offset (+ offset 800))
                           )
                           (setq offset (+ offset 1000))
                           (setq pt (polar p1 0 offset))
                           (command "_insert" insBlok pt "1" "1" "0")
                           (setvar "ATTDIA" 1)
                           (setvar "cmdecho" 1)
                         )
                       )
                     )
                   )
                   (setq insBlok "svp_dupa")
                   (setq pt (polar p1 (- pi) 0))
                   (command "_insert" insBlok pt "1" "1" "0")
                   (setq selectionList (list))
                   (setvar "osmode" oldsnapik)
                   ((setq continue nil))
                 )
                 (alert "Nie wybrano ¿adnego napisu lub bloku.")
               )
             )
            )
          )
        )

        (progn 
          (alert "Nie istnieje taki obiekt.")
          (setq entName (getstring "\nPodaj nazwe sanitariatu: "))
          (setq entName (funkpom entName relation2))
          ;; UWAGA: nie dopisujemy tutaj do selectionList — dodanie nast¹pi
          ;; dopiero po wyjœciu z pêtli (tam gdzie masz finalny append)
        )
      )
    )
    (if (and entName (not (equal entName ""))) 
      (setq selectionList (append selectionList (list (cons entName nil))))
    )
    (printinput selectionList relation2)
  )
  (setq *error* temperr)
)