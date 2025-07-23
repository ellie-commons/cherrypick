/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

namespace Cherrypick {
    class ColorButton: Gtk.Box {
        public Cherrypick.Color color;
        public Gtk.Button button;
        new string css_name;
        private Gtk.CssProvider css_provider;

        private const string BUTTON_CSS = """
            .%s * {
                background-color: %s;
            }
        """;


        public ColorButton (Color newcolor, string name) {

            //var relief = Gtk.ReliefStyle.HALF;
            //tooltip_text = _("Switch preview and colour code to this colour");

            css_provider = new Gtk.CssProvider ();

            this.color = newcolor;
            css_name = name;
            add_css_class (name);

            button = new Gtk.Button () {
                width_request = 52
            };

            update_color (newcolor);
            append (button);

        }

        public void update_color (Color newcolor) {
                remove_css_class (css_name);
                color = newcolor;
                var css = BUTTON_CSS.printf (css_name, newcolor.to_hex_string ());
                css_provider.load_from_string (css);

                Gtk.StyleContext.add_provider_for_display (
                    Gdk.Display.get_default (),
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
                add_css_class (css_name);

        }
    }
}
