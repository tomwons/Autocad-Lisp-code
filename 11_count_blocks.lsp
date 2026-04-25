(setq block_listt (list 
                    '("kolano nyplowe 1" . "kolano nyplowe 1")
                    '
                    ("kolano nyplowe 34" . "kolano nyplowe 3/4")
                    '("kolano nyplowe 12" . "kolano nyplowe 1/2")
                    '
                    ("kolano 1" . "kolano 1")
                    '
                    ("kolano 34" . "kolano 3/4")
                    '
                    ("kolano 12" . "kolano 1/2")
                    '
                    ("nypel mosiężny 1" . "nypel mosiężny 1")
                    '("nypel mosiężny 34" . "nypel mosiężny 3/4")
                    '("nypel mosiężny 12" . "nypel mosiężny 1/2")
                    '("mufa mosiężna 1" . "mufa mosiężna 1")
                    '("mufa mosiężna 34" . "mufa mosiężna 3/4")
                    '("mufa mosiężna 12" . "mufa mosiężna 1/2")
                    '("trójnik mosiężny 1" . "trójnik mosiężny 1")
                    '("trójnik mosiężny 34" . "trójnik mosiężny 3/4")
                    '("trójnik mosiężny 12" . "trójnik mosiężny 1/2")
                    '("zawór kulowy 1" . "zawór kulowy 1")
                    '("zawór kulowy 34" . "zawór kulowy 3/4")
                    '("zawór kulowy 12" . "zawór kulowy 1/2")
                    '("zawór kulowy 1 wz" . "zawór kulowy 1 wz")
                    '("zawór kulowy 34 wz" . "zawór kulowy 3/4 wz")
                    '("zawór kulowy 12 wz" . "zawór kulowy 1/2 wz")
                    '("trójnik mosiężny redukcyjny 134" . 
                      "trójnik mosiężny redukcyjny 1x3/4"
                     )
                    '("trójnik mosiężny redukcyjny 112" . 
                      "trójnik mosiężny redukcyjny 1x1/2"
                     )
                    '("trójnik mosiężny redukcyjny 3412" . 
                      "trójnik mosiężny redukcyjny 3/4x1/2"
                     )
                    '("śrubunek mosiężny prosty 1" . "śrubunek mosiężny prosty 1")
                    '("śrubunek mosiężny prosty 34" . "śrubunek mosiężny prosty 3/4")
                    '("śrubunek mosiężny prosty 12" . "śrubunek mosiężny prosty 1/2")
                    '("śrubunek mosiężny kątowy 1" . "śrubunek mosiężny kątowy 1")
                    '("śrubunek mosiężny kątowy 34" . "śrubunek mosiężny kątowy 3/4")
                    '("śrubunek mosiężny kątowy 12" . "śrubunek mosiężny kątowy 1/2")
                    '("redukcja mosięzna 134" . "redukcja mosięzna 1x3/4")
                    '("redukcja mosięzna 112" . "redukcja mosięzna 1x1/2")
                    '("redukcja mosięzna 3412" . "redukcja mosięzna 3/4x1/2")
                    '("trójnik 16 x 16 x 16" . "trójnik 16 x 16 x 16")
                    '("trójnik 20 x 20 x 20" . "trójnik 20 x 20 x 20")
                    '("trójnik 25 x 25 x 25" . "trójnik 25 x 25 x 25")
                    '("trójnik 32 x 32 x 32" . "trójnik 32 x 32 x 32")
                    '("trójnik 40 x 40 x 40" . "trójnik 40 x 40 x 40")
                    '("trójnik 50 x 50 x 50" . "trójnik 50 x 50 x 50")
                    '("trójnik 63 x 63 x 63" . "trójnik 63 x 63 x 63")
                    '("trójnik 16 x Rp 12 x 16" . "trójnik 16 x Rp 1/2 x 16")
                    '("trójnik 20 x Rp 12 x 20" . "trójnik 20 x Rp 1/2 x 20")
                    '("trójnik 25 x Rp 12 x 25" . "trójnik 25 x Rp 1/2 x 25")
                    '("trójnik 25 x Rp 34 x 25" . "trójnik 25 x Rp 3/4 x 25")
                    '("trójnik 32 x Rp 12 x 32" . "trójnik 32 x Rp 1/2 x 32")
                    '("trójnik 32 x Rp 1 x 32" . "trójnik 32 x Rp 1 x 32")
                    '("trójnik 40 x Rp 12 x 40" . "trójnik 40 x Rp 1/2 x 40 ")
                    '("trójnik 40 x Rp 1 x 40" . "trójnik 40 x Rp 1 x 40")
                    '("trójnik 16 x 20 x 16" . "trójnik 16 x 20 x 16")
                    '("trójnik 20 x 14 x 20" . "trójnik 20 x 14 x 20")
                    '("trójnik 20 x 16 x 16" . "trójnik 20 x 16 x 16")
                    '("trójnik 20 x 16 x 20" . "trójnik 20 x 16 x 20")
                    '("trójnik 20 x 20 x 16" . "trójnik 20 x 20 x 16")
                    '("trójnik 20 x 25 x 20" . "trójnik 20 x 25 x 20")
                    '("trójnik 25 x 16 x 16" . "trójnik 25 x 16 x 16")
                    '("trójnik 25 x 16 x 20" . "trójnik 25 x 16 x 20")
                    '("trójnik 25 x 16 x 25" . "trójnik 25 x 16 x 25")
                    '("trójnik 25 x 20 x 20" . "trójnik 25 x 20 x 20")
                    '("trójnik 25 x 20 x 25" . "trójnik 25 x 20 x 25")
                    '("trójnik 25 x 25 x 16" . "trójnik 25 x 25 x 16")
                    '("trójnik 25 x 32 x 25" . "trójnik 25 x 32 x 25")
                    '("trójnik 32 x 16 x 32" . "trójnik 32 x 16 x 32")
                    '("trójnik 32 x 20 x 25" . "trójnik 32 x 20 x 25")
                    '("trójnik 32 x 20 x 32" . "trójnik 32 x 20 x 32")
                    '("trójnik 32 x 25 x 25" . "trójnik 32 x 25 x 25")
                    '("trójnik 32 x 25 x 32" . "trójnik 32 x 25 x 32")
                    '("trójnik 32 x 32 x 20" . "trójnik 32 x 32 x 20")
                    '("trójnik 40 x 20 x 40" . "trójnik 40 x 20 x 40")
                    '("trójnik 40 x 25 x 32" . "trójnik 40 x 25 x 32")
                    '("trójnik 40 x 25 x 40" . "trójnik 40 x 25 x 40")
                    '("trójnik 40 x 32 x 32" . "trójnik 40 x 32 x 32")
                    '("trójnik 40 x 32 x 40" . "trójnik 40 x 32 x 40")
                    '("mufa przejściowa 20 x Rp 12" . "mufa przejściowa 20 x Rp 1/2")
                    '("mufa przejściowa20 x Rp 34" . "mufa przejściowa20 x Rp 3/4")
                    '("mufa przejściowa25 x Rp 1" . "mufa przejściowa25 x Rp 1")
                    '("mufa przejściowa 25 x Rp 34" . "mufa przejściowa 25 x Rp 3/4")
                    '("mufa przejściowa 32 x Rp 1" . "mufa przejściowa 32 x Rp 1")
                    '("mufa przejściowa 40 x Rp 1 12" . 
                      "mufa przejściowa 40 x Rp 1 1/2"
                     )
                    '("nypel przejściowy 16 x R 12" . "nypel przejściowy 16 x R 1/2")
                    '("nypel przejściowy 20 x R 12" . "nypel przejściowy 20 x R 1/2")
                    '("nypel przejściowy 20 x R 34" . "nypel przejściowy 20 x R 3/4")
                    '("nypel przejściowy 25 x R 1" . "nypel przejściowy 25 x R 1  ")
                    '("nypel przejściowy25 x R 34" . "nypel przejściowy25 x R 3/4")
                    '("nypel przejściowy 32 x R 1" . "nypel przejściowy 32 x R 1")
                    '("nypel przejściowy 32 x R 1 14" . 
                      "nypel przejściowy 32 x R 1 1/4"
                     )
                    '("nypel przejściowy 40 x R 1 14" . 
                      "nypel przejściowy 40 x R 1 1/4 "
                     )
                    '("kolano 16 x16" . "kolano 16 x16")
                    '("kolano 20 x 20" . "kolano 20 x 20")
                    '("kolano 25 x 25" . "kolano 25 x 25")
                    '("łuk 16 x16" . "łuk 16 x16")
                    '("łuk 20x20" . "łuk 20x20")
                    '("łuk 25x25" . "łuk 25x25")
                    '("łuk 32x32" . "łuk 32x32")
                    '("łuk 40x40" . "łuk 40x40")
                    '("złączka prosta 16x16" . "złączka prosta 16x16")
                    '("złączka prosta 20x20" . "złączka prosta 20x20")
                    '("złączka prosta 25x25" . "złączka prosta 25x25")
                    '("złączka prosta 32x32" . "złączka prosta 32x32")
                  )
)

(defun c:recount (/ block_list ss cnt i bo output_file) 

  ; Prompt user to specify the output CSV file name with .csv extension
  (setq base_path "L:/PROJ_Instalatorzy/Wymiana/eksport mat/")
  (setq file_name (getstring "\nPodaj numer kontraktu (bez rozszerzenia pliku): "))
  (setq output_file (strcat base_path file_name ".csv"))

  (vl-load-com)
  (setq block_list block_listt)

  ; Prompt the user to select entities (blocks) for counting
  (setq ss (ssget '((0 . "INSERT"))))

  ; Open the CSV file for writing
  (setq csv_file (open output_file "w"))

  (foreach block_data block_list 
    (setq i   -1
          cnt 0
    )
    (while (< (setq i (1+ i)) (sslength ss)) 
      (setq bo (vlax-ename->vla-object (ssname ss i)))
      (if (= (car block_data) (vlax-get bo 'EffectiveName)) 
        (setq cnt (1+ cnt))
      )
    )
    ; Write the block count to the CSV file using the second element of the pair in block_data
    (write-line (strcat file_name ";" (cdr block_data) ";" (itoa cnt)) csv_file)
    (setq env_name (cdr block_data))
    (setenv env_name (itoa cnt))
  )
  (close csv_file)
  (princ (strcat "\nData exported to " output_file))

  (command "_REGEN")
  (princ)
)




