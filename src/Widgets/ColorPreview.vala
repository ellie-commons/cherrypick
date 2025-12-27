/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
 * The right side, a flat preview surface previewing the last picked color
 */
public class Cherrypick.ColorPreview : Gtk.Box {

    private ColorController color_controller;
    private Gtk.CssProvider css_provider;

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

    public ColorPreview () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0,
            hexpand: true
        );
    }

    construct {
        /*var headerbar = new Gtk.HeaderBar () {
            show_title_buttons = false,
            title_widget = new Gtk.Grid () {visible = false}
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        headerbar.pack_end (new Gtk.WindowControls (Gtk.PackType.END));
        append (headerbar);  */
        //append (new Gtk.WindowControls (Gtk.PackType.END));


        var overlay_color = new Gtk.Overlay () {
            hexpand = true,
            vexpand = true
        };
        overlay_color.add_css_class ("color-preview");
        append (overlay_color);

        add_css_class (Granite.STYLE_CLASS_CHECKERBOARD);
        



        css_provider = new Gtk.CssProvider ();
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        color_controller = ColorController.get_instance ();
        realize.connect (preview);
        color_controller.notify ["preview-color"].connect (preview);
    }

    private void preview () {
        set_color (color_controller.preview_color);
    }

    private void set_color (Cherrypick.Color color) {
        var color_css = color_definition.printf (color.to_rgba_string ());
        css_provider.load_from_string (color_css);

        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var in_all_formats = "";
        foreach (var format in Format.all ()) {
            in_all_formats = "%s\n%s: %s".printf (
                in_all_formats,
                format.to_string (),
                color.to_format_string (format)) ;
        }
        tooltip_text = in_all_formats [1:];
    }
}
