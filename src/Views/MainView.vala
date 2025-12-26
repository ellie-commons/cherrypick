/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

class Cherrypick.MainView: Gtk.Box {

    private Gtk.Button pick_button;
    private Granite.Toast toast;
    private ColorPicker color_picker;
    public Cherrypick.FormatArea format_area;

    construct {
        toast = new Granite.Toast ("");
        toast.hide ();

        var color_preview = new Cherrypick.ColorPreview ();


        var format_label = new Gtk.Label (_("Format")) {
            xalign = 0f,
            margin_top = 6
        };
        format_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
        format_area = new Cherrypick.FormatArea ();

        var history_header = new HistoryHeader () {
            margin_top = 12
        };

        var history_buttons = new HistoryButtons ();

        pick_button = new Gtk.Button.with_label (_("Pick Color")) {
            margin_top = 12,
            tooltip_text = _("Allows you to click on a colour on the screen to get its code in the preferred format")
        };
        pick_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);


        // We do not use spacing, but instead margin_top for each subelement
        // This way we avoid Le Blank Space caused by overlay eating up spacing
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6) {
            vexpand = true,
            valign = Gtk.Align.START,
            margin_start = margin_bottom = margin_end = 12,
            margin_top = 0
        };

        var overlay = new Gtk.Overlay ();

        vbox.append (overlay);
        vbox.append (format_label);
        vbox.append (format_area);
        vbox.append (history_header);
        vbox.append (history_buttons);
        vbox.append (pick_button);

        toast = new Granite.Toast ("");
        overlay.add_overlay (toast);



        color_picker = new ColorPicker ();

        // Make sure all the tooltips are up to date
        history_buttons.update_buttons ();


        /* ---------------- CONNECTS AND BINDS ---------------- */
        format_area.format_selector.notify ["selected"].connect_after (history_buttons.update_buttons);

        format_area.copied.connect ((message) => {
            if (message != "") {
                toast.title = message;
                toast.send_notification ();
            }
        });

        history_header.saved.connect (on_saved);

        pick_button.clicked.connect (on_pick);
        color_picker.picked.connect (format_area.copy_to_clipboard);
        /* when the app is opened the user probably wants to pick the color
            straight away. So setting the pick button as focused default
            action so that pressing Return or Space starts the pick */
        set_focus (pick_button);
    }

    public void on_pick () {
        color_picker.pick.begin ();
    }

    private void on_saved () {
        toast.title = _("History saved");
        toast.send_notification ();
    }
}
