(defun puryfikacja () 
  (progn 
    (setvar "CMDecho" 0)
    (setvar "ATTDIA" 0)
    (repeat 3 
      (command 
        "._-purge"
        "C"
        ""
        "N"
      )
    )
    (setvar "CMDecho" 1)
    (setvar "ATTDIA" 1)
  )
  (princ)
)

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

(defun pobierznazwe (csvname / data file) 
  (if 
    (and 
      (setq file (findfile csvname))
      (setq data (cdr (LM:readcsv file)))
    )
    (progn 
      (setq wanted_layer2 (mapcar '(lambda (e) (car e)) data))
      (princ 
        (strcat "(" 
                (apply 'strcat 
                       (mapcar '(lambda (e) (strcat "\"" e "\" ")) wanted_layer2)
                )
                ")"
        )
      )
    )
  )
  (princ)
)

(defun _make_layer (lname ltyp col plot desc / new_layer accol) 
  (if (not (tblsearch "LAYER" lname))  ;layer name
    (progn 
      (setq new_layer (vla-add 
                        (vla-get-layers 
                          (vla-get-activedocument 
                            (vlax-get-acad-object)
                          )
                        )
                        lname
                      )
      )

      (vla-put-description new_layer desc) ;description
      (vla-put-linetype 
        new_layer
        (if (tblsearch "LTYPE" ltyp) 
          ltyp ;linetype
          "Continuous"
        )
      )

      (vla-put-plottable 
        new_layer
        (if plot 
          :vlax-true
          :vlax-false
        )
      ) ;plottable
      (setq accol (vla-getinterfaceobject 
                    (vlax-get-acad-object)
                    (strcat "AutoCAD.AcCmColor." 
                            (itoa (atoi (getvar "acadver")))
                    )
                  )
      )
      (vla-put-colorindex accol col)
      (vla-put-truecolor new_layer accol) ;color
      (vlax-release-object accol)
    )
  )
)
;;Usage:
(defun DEMO () 
  (_make_layer "SVP_Exhaust" ;layer name
               "CENTER" ;linetype
               3 ;color
               T ;plottable
               "brak opisu" ;description
  )
  (princ)
)
(defun C:verify (/ layersput acobj acdoc model docs dbx acver wanted_layer file 
                 selected_file path doc l x obj
                ) 
  (vl-load-com)
  (DEMO)
  (setq layersput (tblobjname "layer" "SVP_Exhaust"))
  (progn 
    (vla-put-Lock (vlax-ename->vla-object layersput) 1)
    (vla-put-LayerOn (vlax-ename->vla-object layersput) 1)
    (vla-put-freeze (vlax-ename->vla-object layersput) 0)
  )
  (setq acobj (vlax-get-acad-object)
        acdoc (vla-get-activedocument acobj)
        model (vla-get-modelspace acdoc)
        docs  (vla-get-documents acobj)
  )
  ;acobj jest ustawiona na obiekt AutoCAD.
  ;acdoc jest ustawiona na aktywny dokument AutoCAD.
  ;model jest ustawiona na przestrzeñ modelu (modelspace) dla aktywnego dokumentu.
  ;docs jest ustawiona na kolekcjê wszystkich dokumentów w AutoCAD.
  ;lista dostêpu

  (setq dbx (vla-GetInterfaceObject acobj 
                                    (if 
                                      (< (setq acver (atoi (getvar "ACADVER"))) 16)
                                      "ObjectDBX.AxDbDocument"
                                      (strcat "ObjectDBX.AxDbDocument." 
                                              (itoa acver)
                                      )
                                    )
            )
  )
  ;Ustawienie zmiennej na interfejs ObjectDBX do aktualnej sessji AutoCAD jest wykonywane
  ;po to, aby umo¿liwiæ programowi dostêp do ró¿nych obiektów, funkcji i w³aœciwoœci dostêpnych w AutoCAD,
  ;takich jak dokumenty, modele, ustawienia drukowania itp.

  (setq wanted_layer '("A_WALLS"))
  (setq file nil)
  (setq selected_file nil)
  ;ustawienie zmiennych
  (progn 
    (while (not file) 
      (progn 
        (princ)
        (setq file (getfiled "Wybierz plik (tworzenie punktu odniesienia -automatycznie sie kasuje.)" 
                             (cond (path) ((getvar 'dwgprefix)))
                             "dwg"
                             2
                   )
        )
        (setq selected_file file)
      )
      ;wybór pliku Ÿród³owego
      (setq path (strcat (vl-filename-directory file) "\\")
            doc  nil
            l    nil
      )
      ;ustawienie folderu w który znajduje siê plik Ÿródlowy
      (vlax-for x docs 
        (if (eq (vla-get-fullname x) file) 
          (setq doc x)
        )
      )
      ;wyszukiwanie pliku o nazwie zdefiniowanej w zmiennej file
      (or doc (vla-open dbx file :vlax-true))
      ;otwarcie pliku okreœlonego w file w cichym trybie
      (vlax-for obj (vla-get-modelspace (cond (doc) (dbx))) 
        (if (member (vla-get-layer obj) wanted_layer) 
          (progn 
            (vla-put-layer obj "SVP_Exhaust")
            (setq l (cons obj l))
          )
        )
      )
      ;W powy¿szym kodzie u¿ywana jest pêtla vlax-for, która przeszukuje zbiór vla-get-modelspace,
      ;który zawiera obiekty znajduj¹ce siê w modelu. W ka¿dym kroku pêtli, sprawdzana jest warunek,
      ;czy warstwa obiektu obj znajduj¹cego siê w modelu znajduje siê na liœcie wanted_layer.
      ;Jeœli warunek jest prawdziwy, obiekt jest dodawany na pocz¹tek listy l
      (if l 
        (vlax-invoke (cond (doc) (dbx)) 'copyobjects l model)
      )
      ;sprawdzenie czy lista l nie jest pusta. Jeœli nie jest pusta to kopiuje obiekty z listy l
      (princ 
        (strcat "\n" 
                (itoa (length l))
                " objects imported from "
                (strcase (vl-filename-base file))
        )
      )
      ;przekazuje info z jakiego pliku zosta³y skopiowane obiekty
    )
    (princ)
    ;ciche zakoñczenie dzia³ania
  )
  (vlax-release-object dbx)
  ;uwolenienie pliku Ÿródlowego
  (princ)
  ;ciche zakoñczenie dzia³ania
)
; pierwsza weryfikacja dwóch dwgów do odpowiedniego ustawienia rzutów w Ÿródle
;potrzebne do odpowiedniego wklejenia warstw i porównania róznic w dalszym etapie
(defun copyobiects (/ acobj acdoc model docs dbx acver wanted_layer filet 
                    selected_file path doc l x obj
                   )  ;;kopiowanie wszystkiego z warstw z listy wanted_layer2
  (setq acobj (vlax-get-acad-object)
        acdoc (vla-get-activedocument acobj)
        model (vla-get-modelspace acdoc)
        docs  (vla-get-documents acobj)
  )
  ;acobj jest ustawiona na obiekt AutoCAD.
  ;acdoc jest ustawiona na aktywny dokument AutoCAD.
  ;model jest ustawiona na przestrzeñ modelu (modelspace) dla aktywnego dokumentu.
  ;docs jest ustawiona na kolekcjê wszystkich dokumentów w AutoCAD.
  ;lista dostêpu

  (setq dbx (vla-GetInterfaceObject acobj 
                                    (if 
                                      (< (setq acver (atoi (getvar "ACADVER"))) 16)
                                      "ObjectDBX.AxDbDocument"
                                      (strcat "ObjectDBX.AxDbDocument." 
                                              (itoa acver)
                                      )
                                    )
            )
  )
  ;Ustawienie zmiennej na interfejs ObjectDBX do aktualnej sessji AutoCAD jest wykonywane
  ;po to, aby umo¿liwiæ programowi dostêp do ró¿nych obiektów, funkcji i w³aœciwoœci dostêpnych w AutoCAD,
  ;takich jak dokumenty, modele, ustawienia drukowania itp.
  (setq wanted_layer wanted_layer2)
  ;ustawienie zmiennych
  (progn 
    ;(setq file filet)
    (setq path (strcat (vl-filename-directory file) "\\")
          doc  nil
          l    nil
    )
    ;ustawienie folderu w który znajduje siê plik Ÿródlowy
    (vlax-for x docs 
      (if (eq (vla-get-fullname x) file) 
        (setq doc x)
      )
    )
    ;wyszukiwanie pliku o nazwie zdefiniowanej w zmiennej file
    (or doc (vla-open dbx file :vlax-true))
    ;otwarcie pliku okreœlonego w file w cichym trybie
    (vlax-for obj (vla-get-modelspace (cond (doc) (dbx))) 
      (if (member (vla-get-layer obj) wanted_layer) 

        (setq l (cons obj l))
      )
    )
    ;W powy¿szym kodzie u¿ywana jest pêtla vlax-for, która przeszukuje zbiór vla-get-modelspace,
    ;który zawiera obiekty znajduj¹ce siê w modelu. W ka¿dym kroku pêtli, sprawdzana jest warunek,
    ;czy warstwa obiektu obj znajduj¹cego siê w modelu znajduje siê na liœcie wanted_layer.
    ;Jeœli warunek jest prawdziwy, obiekt jest dodawany na pocz¹tek listy l
    (if l 
      (vlax-invoke (cond (doc) (dbx)) 'copyobjects l model)
    )
    ;sprawdzenie czy lista l nie jest pusta. Jeœli nie jest pusta to kopiuje obiekty z listy l
    (princ 
      (strcat "\n" 
              (itoa (length l))
              " objects imported from "
              (strcase (vl-filename-base file))
      )
    )
    ;przekazuje info z jakiego pliku zosta³y skopiowane obiekty

    (princ)
    ;ciche zakoñczenie dzia³ania
  )
  (vlax-release-object dbx)
  ;uwolenienie pliku Ÿródlowego
  (princ)
  ;ciche zakoñczenie dzia³ania
)

(defun deletestuff (/ layerList layer lay obj blk)  ;kasowanie wszystkiego z warstw z filtru wanted_layer2
  (defun *error* (msg) 
    (and UFlag (vla-EndUndoMark *doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*") 
        (princ (strcat "\n** Error: " msg " **"))
    )
    (princ)
  )

  (setq layerList wanted_layer2)
  (setq *doc (cond 
               (*doc)
               ((vla-get-ActiveDocument 
                  (vlax-get-acad-object)
                )
               )
             )
  )
  ;dostêpy
  (foreach layer layerList 
    (if 
      (and (tblsearch "LAYER" layer) 
           (eq :vlax-false 
               (vla-get-lock 
                 (vla-item (vla-get-Layers *doc) layer)
               )
           )
      )
      ; wyszkuje warstwe z listy jesli znajdzie pobiera do zmiennej
      (progn 
        (setq uFlag (not (vla-StartUndoMark *doc)))
        (vlax-for lay (vla-get-Layouts *doc)           (vlax-for obj (vla-get-Block lay) 
            (if 
              (eq (strcase layer) 
                  (strcase (vla-get-layer obj))
              )

              (vl-catch-all-apply 
                (function vla-delete)
                (list obj)
              )
            )
          )
        )
        (setq uFlag (vla-EndUndomark *doc))
      )

      (princ (strcat "\n** Layer " layer " Not Found **"))
    )
  )
  (princ)
)

(defun C:IMPORTDRAWING (/ layname layobj layname) 
  (vl-load-com)
  ;wcztanie bibliotek VLA
  (pobierznazwe "listawarstw.csv")
  (setq file (getfiled "Wybierz plik Ÿród³owy" 
                       (cond (path) ((getvar 'dwgprefix)))
                       "dwg"
                       2
             )
  )
  (setvar "clayer" "0")
  ;ustawienie bie¿acej warstwy na 0 aby unikn¹c b³êdów dotyczacych operacji na bie¿¹cej warstwie
  (foreach layname wanted_layer2 
    (if 
      (and 
        (setq layobj (tblobjname "layer" layname))
      )
      (progn 
        (vla-put-Lock (vlax-ename->vla-object layobj) 0)
        (vla-put-LayerOn (vlax-ename->vla-object layobj) 1)
        (vla-put-freeze (vlax-ename->vla-object layobj) 0)
      )
    )
  )
  ;operacje na ustawieniach warstw
  (deletestuff)
  (puryfikacja)
  (copyobiects)
  (command "_regen")
  (princ)
)



