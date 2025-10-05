-- ~/.config/nvim/lua/user/plugins/astrocore.lua
-- Or wherever your astrocore customization is located

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- Handle large files better
        autopairs = true, -- Auto-close pairs like (), [], {}
        cmp = true, -- Enable completion engine
        diagnostics_mode = 3, -- Show diagnostics aggressively
        highlighturl = true, -- Highlight URLs
        notifications = true, -- Enable notifications
      },
      diagnostics = {
        virtual_text = true, -- Show diagnostics inline
        underline = true,
      },
      options = {
        opt = {
          relativenumber = true, -- Show relative line numbers
          number = true, -- Show absolute line number for current line
          spell = false, -- Disable spell checking
          signcolumn = "yes", -- Always show the sign column
          wrap = false, -- Disable line wrapping
          mouse = "a", -- Enable mouse support in all modes
        },
        g = {
          -- Global variables if needed
        },
      },
      mappings = {
        -- Normal Mode Mappings
        n = {
          ["<D-s>"] = {
            function()
              vim.cmd "silent write"
              vim.notify("💾 Saved", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Save file",
          },

          ["cp"] = {
            function()
              local curpos = vim.api.nvim_win_get_cursor(0)
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              vim.fn.setreg("+", table.concat(lines, "\n"))
              vim.api.nvim_win_set_cursor(0, curpos)
              vim.notify("📋 Buffer copied to system clipboard", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Copy entire buffer to clipboard",
          },

          ["pst"] = {
            function()
              local curpos = vim.api.nvim_win_get_cursor(0)
              local clip = vim.fn.getreg "+"
              local lines = vim.split(clip, "\n")
              vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
              vim.api.nvim_win_set_cursor(0, { math.min(curpos[1], #lines), 0 })
              vim.notify("📥 Clipboard pasted into buffer", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Paste clipboard contents into buffer",
          },

          ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<Leader>x"] = {
            function() require("astrocore.buffer").close(vim.fn.bufnr()) end,
            desc = "Close current buffer",
          },

          -- Compile & Run C++23 via Homebrew's g++-15
          ["<F5>"] = {
            function()
              vim.cmd "silent write"
              local src = vim.fn.expand "%:p"
              local dir = vim.fn.expand "%:p:h"
              local is_windows = vim.fn.has "win32" == 1
              local exe = vim.fn.expand "%:p:r" .. (is_windows and ".exe" or "")
              local input = dir .. "/input.txt"
              local output = dir .. "/output.txt"
              local err_file = dir .. "/compile_errors.txt"

              if vim.bo.filetype ~= "cpp" then
                vim.notify("Not a C++ file", vim.log.levels.WARN, { title = "C++ Run" })
                return
              end

              if vim.fn.filereadable(input) == 0 then
                vim.fn.writefile({ "# Add input here" }, input)
                vim.notify("Created input.txt", vim.log.levels.INFO, { title = "C++ Run" })
              end

              -- Use Homebrew GCC 15 with explicit include paths
              local compiler = "/opt/homebrew/opt/gcc/bin/g++-15"
              local include_root = "/opt/homebrew/opt/gcc/include/c++/15"
              local compile_cmd = string.format(
                "%s -std=c++23 -O2 -Wall -Wextra -nostdinc++ -I%s -I%s/aarch64-apple-darwin24 %s -o %s",
                compiler,
                include_root,
                include_root,
                vim.fn.shellescape(src),
                vim.fn.shellescape(exe)
              )
              local run_cmd = string.format(
                "%s < %s > %s",
                vim.fn.shellescape(exe),
                vim.fn.shellescape(input),
                vim.fn.shellescape(output)
              )

              vim.notify("🚀 Compiling with Homebrew GCC...", vim.log.levels.INFO, { title = "C++ Run" })

              require("plenary.job")
                :new({
                  command = "bash",
                  args = {
                    "-c",
                    string.format(
                      "%s 2> %s && %s 2>> %s",
                      compile_cmd,
                      vim.fn.shellescape(err_file),
                      run_cmd,
                      vim.fn.shellescape(err_file)
                    ),
                  },
                  cwd = dir,
                  on_exit = function(_, code)
                    local handle = io.open(err_file, "r")
                    local has_errors = handle and handle:read(1)
                    if handle then handle:close() end

                    if code == 0 and not has_errors then
                      vim.notify(
                        "✅ C++ Executed successfully. Output in output.txt",
                        vim.log.levels.INFO,
                        { title = "C++ Run" }
                      )
                    else
                      vim.notify(
                        "❌ C++ Compilation/Runtime Error. See compile_errors.txt",
                        vim.log.levels.ERROR,
                        { title = "C++ Run" }
                      )
                      if vim.fn.filereadable(err_file) == 1 then vim.cmd("vsplit " .. vim.fn.fnameescape(err_file)) end
                    end
                  end,
                })
                :start()
            end,
            desc = "Compile & Run C++23 (using input/output files)",
          },

          -- Run Python scripts with Ctrl+Enter
          ["<C-CR>"] = {
            function()
              vim.cmd "silent write"
              local current_file = vim.fn.expand "%:p"
              local dir = vim.fn.expand "%:p:h"
              local input_file = dir .. "/input.txt"
              local output_file = dir .. "/output.txt"

              if vim.bo.filetype ~= "python" then
                vim.notify("Not a Python file", vim.log.levels.WARN, { title = "Python Run" })
                return
              end

              if vim.fn.filereadable(input_file) == 0 then
                vim.fn.writefile({ "# Add input here" }, input_file)
                vim.notify("Created input.txt", vim.log.levels.INFO, { title = "Python Run" })
              end

              local python_executable = "python3"
              vim.notify(
                "🐍 Running " .. vim.fn.pathshorten(current_file),
                vim.log.levels.INFO,
                { title = "Python Run" }
              )

              require("plenary.job")
                :new({
                  command = python_executable,
                  args = { vim.fn.fnameescape(current_file) },
                  cwd = dir,
                  stdin = input_file,
                  stdout = output_file,
                  stderr = output_file,
                  on_exit = function(_, code)
                    if code == 0 then
                      vim.notify(
                        "✅ Python script finished. Output in output.txt",
                        vim.log.levels.INFO,
                        { title = "Python Run" }
                      )
                    else
                      vim.notify(
                        "❌ Python script failed. Check output.txt for errors.",
                        vim.log.levels.ERROR,
                        { title = "Python Run" }
                      )
                      if vim.fn.filereadable(output_file) == 1 then
                        vim.cmd("vsplit " .. vim.fn.fnameescape(output_file))
                      end
                    end
                  end,
                })
                :start()
            end,
            desc = "Run Python file (input.txt -> output.txt)",
          },

          -- View output and error files
          ["<Leader>vo"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/output.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file))
              else
                vim.notify("output.txt not found", vim.log.levels.WARN, { title = "View File" })
              end
            end,
            desc = "View output.txt",
          },
          ["<Leader>ve"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/compile_errors.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file))
              else
                vim.notify("compile_errors.txt not found", vim.log.levels.WARN, { title = "View File" })
              end
            end,
            desc = "View compile_errors.txt",
          },
          ["<Leader>vi"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/input.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("split " .. vim.fn.fnameescape(file))
              else
                vim.notify("input.txt not found", vim.log.levels.WARN, { title = "View File" })
              end
            end,
            desc = "View input.txt",
          },
        },

        -- Insert Mode Mappings
        i = {
          ["<C-s>"] = {
            function()
              vim.cmd "silent write"
              vim.notify("💾 Saved", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Save file (Insert Mode)",
          },
          ["<A-Left>"] = { "<C-o>b", desc = "Move word left" },
          ["<A-Right>"] = { "<C-o>w", desc = "Move word right" },
          ["<A-Up>"] = { "<Esc>:m .-2<CR>==gi", desc = "Move line up" },
          ["<A-Down>"] = { "<Esc>:m .+1<CR>==gi", desc = "Move line down" },
          ["<C-e>"] = { "<End>", desc = "Move to end of line" },
          ["<C-a>"] = { "<Home>", desc = "Move to start of line" },
        },
      },
    },
  },
}
