/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* Buttons for color operation all goes there
*/
class Cherrypick.MainView: Gtk.Box {

    private Granite.Toast toast;
    private ColorPicker color_picker;
    public Gtk.Button pick_button;

    construct {
        // We use a lot of margin_top for each subelement
        // This way we avoid Le Blank Space caused by overlay eating up spacing
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 6;
        vexpand = true;
        valign = Gtk.Align.START;
        margin_start = margin_bottom = margin_end = 12;
        margin_top = 0;

        /* ---------------- TOASTS ---------------- */

        toast = new Granite.Toast ("");

        var overlay = new Gtk.Overlay ();
        overlay.add_overlay (toast);

        /* ---------------- FORMAT ---------------- */
        var format_label = new Gtk.Label (_("Format")) {
            xalign = 0f,
            margin_top = 6
        };
        format_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
        var format_area = new Cherrypick.FormatArea ();


        /* ---------------- HISTORY ---------------- */

        var history_header = new HistoryHeader () {
            margin_top = 12
        };

        var history_buttons = new HistoryButtons ();

        /* ---------------- BIG BUTTON ---------------- */
        pick_button = new Gtk.Button.with_label (_("Pick Color")) {
            margin_top = 12,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>P"},
                _("Click to pick a color on the screen"))
        };
        pick_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);



        /* ---------------- PARENT ---------------- */
        append (overlay);
        append (format_label);
        append (format_area);
        append (history_header);
        append (history_buttons);
        append (pick_button);

        color_picker = new ColorPicker ();

        // Make sure all the tooltips are up to date
        history_buttons.update_buttons ();


        /* ---------------- CONNECTS AND BINDS ---------------- */
        format_area.format_selector.notify ["selected"].connect_after (history_buttons.update_buttons);

        format_area.copied.connect (on_message);
        history_header.saved.connect (on_message);

        color_picker.picked.connect (format_area.copy_to_clipboard);
        pick_button.clicked.connect (on_pick);
    }

    private void on_message (string message) {
        toast.title = message;
        toast.send_notification ();
    }

    public void on_pick () {
        color_picker.pick.begin ();
    }
}
