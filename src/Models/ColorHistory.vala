/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* A list of recently used colors
*/
public class Cherrypick.ColorHistory: Object, Gee.Traversable<Color>, Gee.Iterable<Color> {
    private Gee.LinkedList<Color> colors = new Gee.LinkedList<Color> ();
    public int size {get; set construct;}
    public signal void changed ();

    public ColorHistory (int size) {
        Object (
            size: size
        );
    }

    public void append (Color color) {
        /* Remember only the newest "size" number of values. Discard older
            ones */
        if (colors.size < size) {
            colors.add (color);
            return;
        }
        colors.remove_at (0);
        colors.add (color);
        changed ();
    }

    public new Color get (int index) {
        return colors[index];
    }

    public bool @foreach (Gee.ForallFunc<Color> color) {
        return iterator ().foreach (color);
    }

    public Gee.Iterator<Color> iterator () {
        return colors.iterator ();
    }
}

