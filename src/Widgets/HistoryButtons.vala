/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
 * Horizontal list of ColorButtons representing the content of ColorHistory
 */
class Cherrypick.HistoryButtons: Gtk.Box {
    private Gee.ArrayList<ColorButton> color_buttons;
    private ColorController color_controller;

    public HistoryButtons () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 8
        );
    }

    construct {

        color_controller = ColorController.get_instance ();
        color_buttons = new Gee.ArrayList<ColorButton> ();

        color_controller.color_history.changed.connect (() => {
            update_buttons ();
        });

        for (var i = 0; i < color_controller.color_history.size; i++) {
            var button_name = "color-button-%d".printf (i);
            var color = color_controller.color_history[i];
            var color_button = new ColorButton (color, button_name) {
                width_request = 45,
                height_request = 30
            };
            color_button.button.clicked.connect (() => {
                color_controller.preview_color = color_button.color;
                color_controller.color_history.append (color_button.color);
                update_buttons ();
            });

            color_buttons.add (color_button);
            append (color_button);
        }
    }

    public void update_buttons () {
        for (var i = 0; i < color_buttons.size; i++) {
            var button = color_buttons[i];
            var this_ones_color = color_controller.color_history[i];
            button.update_color (this_ones_color);
            button.tooltip_text = (this_ones_color.to_preferred_string ());
        }
    }
}
