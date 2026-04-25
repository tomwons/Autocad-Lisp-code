example : dialog {
    label = "Przyk³adowe Okno Dialogowe";
    
    : row {
        : radio_column {
            label = "Opcje";
            : radio_button { label = "OKC-DDWH"; key = "opt1"; }
            : radio_button { label = "Pompy S1255-1256"; key = "opt2"; }
            : radio_button { label = "VVM S320"; key = "opt3"; }
            : radio_button { label = "OKC-DDWH_cyrk"; key = "opt4"; }
            : radio_button { label = "Pompy S1255-1256_cyrk"; key = "opt5"; }
            : radio_button { label = "VVM S320_cyrk"; key = "opt6"; }
        }
    }
    
    : row {
        : button { label = "OK"; is_default = true; key = "ok"; }
        : button { label = "Anuluj"; is_cancel = true; key = "cancel"; }
    }
}

