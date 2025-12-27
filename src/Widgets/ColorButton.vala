/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

 /**
 * A button displaying a single solid color. If it has an alpha channel, it will be displayed with a checkerboard.
 */
class Cherrypick.ColorButton: Gtk.Box {

    public Cherrypick.Color color;
    public Gtk.Button button;
    new string css_name;
    private Gtk.CssProvider css_provider;
    private Gtk.Overlay overlay_color;

    private const string BUTTON_CSS = """
        .%s * {
            background-color: %s;
        }
    """;

    public ColorButton (Color newcolor, string name) {

        //var relief = Gtk.ReliefStyle.HALF;
        //tooltip_text = _("Switch preview and colour code to this colour");

        css_provider = new Gtk.CssProvider ();
        css_name = name;
        color = newcolor;

        button = new Gtk.Button () {
            width_request = 52
        };
        button.add_css_class (css_name);

        overlay_color = new Gtk.Overlay () {
            child = button
        };
        overlay_color.add_css_class (css_name);
        overlay_color.add_css_class (Granite.STYLE_CLASS_CHECKERBOARD);

        update_color (newcolor);
        append (overlay_color);

    }

    public void update_color (Color newcolor) {
            button.remove_css_class (css_name);
            overlay_color.remove_css_class (css_name);

            color = newcolor;

            // Prepare the new sauce
            var css = BUTTON_CSS.printf (css_name, newcolor.to_rgba_string ());
            css_provider.load_from_string (css);

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            button.add_css_class (css_name);
            overlay_color.add_css_class (css_name);
    }
}
