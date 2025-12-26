/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* Wrapper around GLib.Settings to retried it directly via get_instance ()
*/
public class Cherrypick.Settings: GLib.Settings {
    private static Settings? instance;

    public static Settings get_instance () {
        if (instance == null) {
            instance = new Settings ();
        }
        return instance;
    }

    private Settings () {
        Object (
            schema_id: "io.github.ellie_commons.cherrypick"
        );
    }
}

