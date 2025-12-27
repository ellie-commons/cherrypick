/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* Controlls the state of the color picker.
* UI elements derive their state from the controller.
* Implemented as a singleton for ease of access from multiple UI components
* Everything is kept there but most widgets are public
*/
public class Cherrypick.ColorController : Object {

    public Cherrypick.Color preview_color {get; set;}
    public Cherrypick.Color last_picked_color {get; set;}
    public Cherrypick.ColorHistory color_history {get; set;}

    private const int HISTORY_SIZE = 5;

    /**
    * Gets reference to the controller
    */
    private static ColorController? instance;
    public static ColorController get_instance () {
        if (instance == null) {
            instance = new ColorController ();
        }
        return instance;
    }

    private ColorController () {}

    construct {
        color_history = new Cherrypick.ColorHistory (HISTORY_SIZE);

        notify ["last-picked-color"].connect (() => {
            preview_color = last_picked_color;
        });

        load_history_from_gsettings ();

        color_history.changed.connect (save_history_to_gsettings);
    }

    public void load_history_from_gsettings () {
        var settings = Cherrypick.Settings.get_instance ();
        var color_history_rgba_codes = settings.get_strv ("color-history");
        foreach (var rgba_code in color_history_rgba_codes) {
            var color = new Color ();
            color.parse (rgba_code);
            color_history.append (color);
        }
        last_picked_color = color_history[color_history.size - 1];
    }

    public void save_history_to_gsettings () {
        var settings = Cherrypick.Settings.get_instance ();
        var rgba_codes = new string[color_history.size];
        for (int i = 0; i < color_history.size; i++) {
            rgba_codes[i] = color_history[i].to_rgba_string ();
        }
        settings.set_strv ("color-history", rgba_codes);
    }
}
