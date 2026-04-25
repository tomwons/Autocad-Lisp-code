skala : dialog {
    label = "Dopasowanie do formatu skali";
    
    : row {
        : radio_column {
            label = "Opcje";
            : radio_button { label = "1:50"; key = "opt1"; }
            : radio_button { label = "1:75"; key = "opt2"; }
        }
    }
    
    : row {
        : button { label = "OK"; is_default = true; key = "ok"; }
        : button { label = "Anuluj"; is_cancel = true; key = "cancel"; }
    }
}

