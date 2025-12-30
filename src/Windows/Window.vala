/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public class Cherrypick.Window : Gtk.Window {

    private static GLib.Once<Cherrypick.Window> _instance;
    public static unowned Cherrypick.Window instance (Application application) {
        return _instance.once (() => { return new Cherrypick.Window (application);});
    }

    private Cherrypick.MainView vbox;

    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "app.";
    public const string ACTION_PICK = "pick";
    public const string ACTION_COPY = "copy";
    public const string ACTION_PASTE = "paste";

    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_PICK, on_pick },
        { ACTION_COPY, copy },
        { ACTION_PASTE, paste }
    };

    public Window (Gtk.Application app) {
        Object (
            application: app,
            ///TRANSLATORS: Do not translate app name
            title: _("Cherrypick"),
            default_width: 480,
            default_height: 240,
            resizable: false
        );
    }

    construct {
        Intl.setlocale ();

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("app", actions);

        // We need to hide the title area for the split headerbar
        set_titlebar (new Gtk.Grid () {visible = false});

        var titlelabel = new Gtk.Label (_("Cherrypick"));
        titlelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

        var headerbar = new Gtk.HeaderBar () {
            title_widget = titlelabel
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        //headerbar.show_title_buttons = false;
        //headerbar.pack_start (new Gtk.WindowControls (Gtk.PackType.START));

        vbox = new Cherrypick.MainView ();


        /* We want the color preview area to span the entire height of the
            window, so using a custom grid layout for the entire window
            including the headerbar */
        var window_grid = new Gtk.Grid ();
        window_grid.attach (headerbar, 0, 0);
        window_grid.attach (vbox, 0, 1);
        window_grid.attach (new Cherrypick.ColorPreview (), 1, 0, 1, 2);

        /* As the headerbar spans only half the window, it would be
            more convenient to be able to move the window from anywhere */
        var window_handle = new Gtk.WindowHandle () {
            child = window_grid
        };

        child = window_handle;

        /* when the app is opened the user probably wants to pick the color
            straight away. So setting the pick button as focused default
            action so that pressing Return or Space starts the pick */
        set_focus (vbox.pick_button);
    }

    public void on_pick () {
        vbox.on_pick ();
    }

    public void copy () {
        vbox.copy ();
    }

    public void paste () {
        vbox.paste ();
    }
}
