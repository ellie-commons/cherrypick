/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

namespace Cherrypick {
    public enum Format {
        HEX,
        RGB,
        RGBA,
        CMYK,
        HSL,
        HSLA;

        public string to_string () {
            switch (this) {
                case HEX: return "HEX";
                case RGB: return "RGB";
                case RGBA: return "RGBA";
                case CMYK: return "CMYK";
                case HSL: return "HSL";
                case HSLA: return "HSLA";
                default: assert_not_reached ();
            }
        }

        public static Format[] all () {
            return {HEX, RGB, RGBA, CMYK, HSL, HSLA};
        }

        public static string[] all_string () {
            return {
                HEX.to_string (),
                RGB.to_string (),
                RGBA.to_string (),
                CMYK.to_string (),
                HSL.to_string (),
                HSLA.to_string ()
            };
        }
    }
}
