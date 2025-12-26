/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public class Cherrypick.ColorPreview : Gtk.Box {
    private string color_definition = "
@define-color preview_color %s;

        .color-preview {
/* preview_color defined in code */
background-color: @preview_color;
border-left: 1px solid @menu_separator;
box-shadow:
    inset 1px 0 0 0 shade(@preview_color, 1.07),
    inset -1px 0 0 0 shade(@preview_color, 1.07),
    inset 0 -1px 0 0 shade(@preview_color, 1.1);
}
";
    private Gtk.CssProvider css_provider;

    public ColorPreview () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: 0,
            hexpand: true
        );
    }

    construct {
        create_style ();
        sync_color_with_controller ();
    }

    private void create_style () {
        add_css_class ("color-preview");

        css_provider = new Gtk.CssProvider ();

        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    private void sync_color_with_controller () {
        var color_controller = ColorController.get_instance ();

        realize.connect (() => {
            set_color (color_controller.preview_color);
        });

        color_controller.notify ["preview-color"].connect (() => {
            set_color (color_controller.preview_color);
        });

        set_color (color_controller.preview_color);
    }

    private void set_color (Color color) {
        var color_css = color_definition.printf (color.to_rgba_string ());
        css_provider.load_from_string (color_css);

        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }
}
