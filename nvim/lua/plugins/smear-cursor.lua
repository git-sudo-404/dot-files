return {
  "sphamba/smear-cursor.nvim",

  opts = {
    -- 1. Fire Color
    cursor_color = "#ff4000",

    -- 2. STOP THE GLITCH (The most important fix)
    -- This stops the plugin from hacking the text under your cursor
    hide_target_hack = false,

    -- 3. Disable in Insert Mode
    smear_insert_mode = false,

    -- 4. Physics (Keep it snappy)
    stiffness = 0.6,
    trailing_stiffness = 0.3,
    trailing_exponent = 2,

    -- 5. Rendering
    -- Keep legacy support if you like the blocky fire look
    legacy_computing_symbols_support = true,
  },
}
