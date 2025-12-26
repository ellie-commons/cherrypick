/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

class Cherrypick.HistoryHeader: Granite.Bin {

    public signal void saved ();

    construct {
        /* -------- START WIDGET -------- */
        var centerbox = new Gtk.CenterBox ();

        var history_label = new Gtk.Label (_("History")) {
            xalign = 0f
        };
        history_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

        var right_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

        var history_save = new Gtk.Button.from_icon_name ("document-save-symbolic") {
            tooltip_text = _("save a snapshot of current color history")
        };
        history_save.add_css_class (Granite.STYLE_CLASS_FLAT);

        var history_restore = new Gtk.Button.from_icon_name ("view-refresh-symbolic") {
            tooltip_text = _("Restore history snapshot")
        };
        history_restore.add_css_class (Granite.STYLE_CLASS_FLAT);


        right_buttons.append (history_save);
        right_buttons.append (history_restore);

        centerbox.start_widget = history_label;
        centerbox.end_widget = right_buttons;

        child = centerbox;



        var settings = Settings.get_instance ();

        history_save.clicked.connect (() => {
            var snapshot = settings.get_strv ("color-history");
            settings.set_strv ("color-snapshot", snapshot);
            saved ();
        ;});

        history_restore.clicked.connect (() => {
            var snapshot = settings.get_strv ("color-snapshot");
            settings.set_strv ("color-history", snapshot);
            ColorController.get_instance ().load_history_from_gsettings ();
        });
    }

}
