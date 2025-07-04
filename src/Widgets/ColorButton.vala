/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    class ColorButton: Gtk.Button {
        public Color color {get; set construct;}
        public new string css_name {get; set construct;}
        private Gtk.CssProvider css_provider;

        private const string BUTTON_CSS = """
            .%s {
                background-color: %s;
            }
        """;

        public ColorButton (Color color, string name) {
            Object (
                css_name: name,
                color: color
            );
        }

        construct {
            //var relief = Gtk.ReliefStyle.HALF;
            css_provider = new Gtk.CssProvider ();
            add_css_class (css_name);

            var color_controller = ColorController.get_instance ();

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            notify ["color"].connect (() => {
                if (color != null) {
                    update_color ();
                }
            });

            clicked.connect (() => {
                color_controller.preview_color = color;
            });
        }

        private void update_color () {
                var css = BUTTON_CSS.printf (css_name, color.to_hex_string ());
                css_provider.load_from_string (css);

                Gtk.StyleContext.add_provider_for_display (
                    Gdk.Display.get_default (),
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
        }
    }
}
