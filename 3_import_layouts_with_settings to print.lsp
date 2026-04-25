(defun trap1 (errmsg) 
  (command "_.UNDO" "_BEgin")
  (setvar "FILEDIA" 1)
  (setvar "CMDECHO" 1)
  (setvar "ATTDIA" 1)

  (setq *error* temperr)
  (prompt "\nResetting System Variables ")
)

;; Read CSV  -  Lee Mac
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

;; CSV -> List  -  Lee Mac
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


(defun pobierznazwe2 (nzhaus / data file) 
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

(defun pobierznazwe3 (nzhaus / data file) 
  (if 
    (and 
      (setq file (findfile nzhaus))
      (setq data (cdr (LM:readcsv file)))
    )
    (progn 
      (setq szablon (apply 'append data))
      (setq result (apply 'strcat 
                          (mapcar '(lambda (e) (strcat "\"" e "\" ")) szablon)
                   )
      )
    )
    (setq result nil)
  )
  result
)

(defun deleteplot (/ plk itemik) 

  (setq plk (vla-get-PlotConfigurations 
              (vla-get-activedocument 
                (vlax-get-acad-object)
              )
            )
  )
  (vlax-for itemik plk 
    (vlax-invoke-method itemik 'delete)
  )
)
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
  ; name - the Page Setup Name
  ; all - a flag, T for all nil for current layout
(defun SetNamePageSetupAllLayouts (name all / lst adoc pltcfg layt) 
  (or adoc (setq adoc (vla-get-ActiveDocument (vlax-get-acad-object))))
  (if 
    (vl-position 
      name
      (vlax-for pltcfg (vla-get-plotconfigurations adoc) 
        (setq lst (cons (vlax-get pltcfg 'Name) lst))
      )
    )
    (progn 
      (vlax-for layt (vla-get-Layouts adoc) 
        (if (/= (vla-get-name layt) "Model") 
          (if all 
            (vla-copyfrom layt (vla-item (vla-get-PlotConfigurations adoc) name))
            (if (= (vla-get-name layt) (getvar 'ctab)) 
              (vla-copyfrom layt 
                            (vla-item (vla-get-PlotConfigurations adoc) name)
              )
            )
          )
        )
      )
      (vla-Regen adoc acActiveViewport)
    )
  )
  (princ)
)
  ;To call the main function:
  ; to change to PDF all layouts
(defun pagesetup (pliknazwa / file-name full-path) 

  (setq file-name pliknazwa)
  (setq full-path (findfile file-name))

  ;; This will return the full path to the file if it is found in the specified directory
  ;; If the file is not found, it will return nil
  (if full-path 
    (progn 
      (princ (strcat "\n File found at: " full-path))
      (setvar "cmdecho" 0)
      (setvar "ATTDIA" 0)
      (command "._PSETUPIN" full-path "*")
      (setvar "cmdecho" 1)
      (setvar "ATTDIA" 1)
    )
    (progn 
      (alert (strcat "File not found in directory "))
    )
  )
  (princ)
)
(defun i:IsReadOnly (fileName / fileH) 
  (cond 
    ((setq fileH (open filename "a"))
     (close fileH)
    )
    ((not fileH))
  )
)
(defun i:CloseDBXDoc (dbxDoc) 
  (vl-catch-all-apply 'vlax-Release-Object (list dbxDoc))
  (setq dbdDoc nil)
)
(defun i:OpenDBXDoc (fileName / newFile dbxDoc chkOpen) 
  (cond 
    ((or (i:IsReadOnly fileName) 
         (= (strcase (vl-filename-extension filename)) 
            ".DWT"
         )
     )
     (setq newFile (vl-filename-mktemp "Temp .dwg"))
     (vl-file-copy fileName newFile)
    )
  )

  (if (< (atoi (substr (getvar "ACADVER") 1 2)) 16) 
    (setq dbxDoc (vlax-create-object "ObjectDBX.AxDbDocument"))
    (setq dbxDoc (vlax-create-object 
                   (strcat "ObjectDBX.AxDbDocument." 
                           (substr (getvar "ACADVER") 1 2)
                   )
                 )
    )
  )
  (setq chkOpen (vl-catch-all-apply 
                  'vla-Open
                  (list dbxDoc 
                        (cond 
                          (newFile)
                          (fileName)
                        )
                  )
                )
  )
  (cond 
    ((vl-catch-all-error-p chkOpen)
     (vlax-Release-Object dbxDoc)
     nil
    )
    (dbxDoc)
  )
)
(defun copylayouts (pliknazwa / aDoc L&Os loc source adlayout filename) 
  (setq filename pliknazwa)
  (setq loc (findfile filename))
  (if loc 
    (progn 
      (setq source (i:openDBXDoc loc))
      (if source  ; dodatkowe sprawdzenie
        (progn 
          (vlax-for itm (vla-get-layouts source) 
            (if (/= (setq ln (vla-get-name itm)) "Model") 
              (setq L&Os (cons (list (vla-get-TabOrder itm) ln) L&Os))
            )
          )
          (i:CloseDBXDoc source) ; poprawione wywo³anie funkcji
          (command "._layout" "s" loc "*")
          (setq adlayout (Vla-get-layouts 
                           (vla-get-ActiveDocument (vlax-get-acad-object))
                         )
          )
          (foreach itm 
            (mapcar 'cadr 
                    (vl-sort L&Os 
                             '(lambda (a b) (> (Car a) (car b)))
                    )
            )
            (vla-put-TabOrder 
              (vla-item adlayout itm)
              1
            )
          )
        )
        (alert "Unable to open file.")
      )
    )
    (alert (strcat "File " filename " not found."))
  )
  (princ)
)
(defun c:LAYOUTSX (/ layList l chosenOption layoute rel layobj colorx view *error*) 
  (vl-load-com)
  (setq temperr *error*)
  (setq *error* trap1)
  (deleteplot)
  (setvar "FILEDIA" 0)
  (pobierznazwe3 "listaszablon.csv")

  (setq layList szablon)
  (progn 
    (setvar "clayer" "0")
    (foreach rel (setq dane (pobierznazwe2 "listawarstw.csv")) 
      (if 
        (and 
          (setq layobj (tblobjname "layer" (car rel)))
          (setq colorx (cadr rel))
          (setq view (caddr rel))
        )
        (progn 
          (if (not (equal colorx "")) 
            (vla-put-color (vlax-ename->vla-object layobj) colorx)
          )
          (vla-put-Plottable (vlax-ename->vla-object layobj) view)
        )
      )
    )
    (vlax-for l (vla-get-layouts (vla-get-activedocument (vlax-get-acad-object))) 
      (if (member (vla-get-name l) layList) 
        (vla-delete l)
      )
    )
  )
  (puryfikacja)
  (initget "DE GB HLS HLSPIW HLSGB")
  (setq chosenOption (getkword "\n WYBIERZ LAYOUTSET: [DE/GB/HLS/HLSPIW/HLSGB] <DE>: "))
  (cond 
    ((equal chosenOption "DE")
     (progn 
       (setvar "CMDECHO" 0)
       (copylayouts "deNAZWA_LUFT_V0.dwg")
       (pagesetup "deNAZWA_LUFT_V0.dwg")
       (SetNamePageSetupAllLayouts "PDF" T)
     )
    )
    ((equal chosenOption "GB")
     (progn 
       (setvar "CMDECHO" 0)
       (copylayouts "gbNAZWA_VENT_V0.dwg")
       (pagesetup "gbNAZWA_VENT_V0.dwg")
       (SetNamePageSetupAllLayouts "PDFGB" T)
     )
    )
    ((equal chosenOption "HLS")
     (progn 

       (vlax-for layoute 
         (vla-get-layouts 
           (vla-get-ActiveDocument (vlax-get-acad-object))
         )

         (if (/= (vla-get-name layoute) "Model") 
           (vla-delete layoute)
         )
       )
       (progn 
         (setvar "clayer" "0")
         (foreach rel (setq dane (pobierznazwe2 "listawarstw.csv")) 

           (if 
             (and 
               (setq layobj (tblobjname "layer" (car rel)))
               (setq colorx (cadr rel))
               (setq view (caddr rel))
             )
             (progn 
               (vla-put-Plottable (vlax-ename->vla-object layobj) 1)
             )
           )
         )
       )
       (setvar "CMDECHO" 0)

       (copylayouts "NAZWA_HLS.dwg")
       (pagesetup "NAZWA_HLS.dwg")
       (SetNamePageSetupAllLayouts "HLS" T)
     )
    )
    ((equal chosenOption "HLSPIW")
     (progn 

       (vlax-for layoute 
         (vla-get-layouts 
           (vla-get-ActiveDocument (vlax-get-acad-object))
         )

         (if (/= (vla-get-name layoute) "Model") 
           (vla-delete layoute)
         )
       )
       (progn 
         (setvar "clayer" "0")
         (foreach rel (setq dane (pobierznazwe2 "listawarstw.csv")) 

           (if 
             (and 
               (setq layobj (tblobjname "layer" (car rel)))
               (setq colorx (cadr rel))
               (setq view (caddr rel))
             )
             (progn 
               (vla-put-Plottable (vlax-ename->vla-object layobj) 1)
             )
           )
         )
       )
       (setvar "CMDECHO" 0)

       (copylayouts "NAZWA_HLS_PIWKO.dwg")
       (pagesetup "NAZWA_HLS_PIWKO.dwg")
       (SetNamePageSetupAllLayouts "HLS" T)
     )
    )
    ((equal chosenOption "HLSGB")
     (progn 

       (vlax-for layoute 
         (vla-get-layouts 
           (vla-get-ActiveDocument (vlax-get-acad-object))
         )

         (if (/= (vla-get-name layoute) "Model") 
           (vla-delete layoute)
         )
       )
       (progn 
         (setvar "clayer" "0")
         (foreach rel (setq dane (pobierznazwe2 "listawarstw.csv")) 

           (if 
             (and 
               (setq layobj (tblobjname "layer" (car rel)))
               (setq colorx (cadr rel))
               (setq view (caddr rel))
             )
             (progn 
               (vla-put-Plottable (vlax-ename->vla-object layobj) 1)
             )
           )
         )
       )
       (setvar "CMDECHO" 0)

       (copylayouts "NAZWA_HLS gb.dwg")
       (pagesetup "NAZWA_HLS gb.dwg")
       (SetNamePageSetupAllLayouts "HLS" T)
     )
    )
    (t (princ "\nInvalid option"))
  )
  (setvar "FILEDIA" 1)
  (setvar "CMDECHO" 1)
  (setvar "ATTDIA" 1)
  (setq *error* temperr)

  (princ)
)