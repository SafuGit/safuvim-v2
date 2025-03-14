local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local menu = Menu({
  position = "50%",
  size = {
    width = 25,
    height = 15,
  },
  border = {
    style = "single",
    text = {
      top = "[SafuVIM Menu]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  lines = {
    Menu.item("Go Home"),
    Menu.item("Open Terminal"),
    Menu.item("Lazy Plugins"),
    -- Menu.separator("Noble-Gases", {
    --   char = "-",
    --   text_align = "right",
    -- }),
    Menu.item("Focus Mode"),
    Menu.item("Mason LSP"),
    Menu.item("Git GUI"),
    Menu.item("Open File Browser"),
    Menu.item("Open Leetcode")
  },
  max_width = 20,
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  },
  on_close = function()
    print("Menu Closed!")
  end,
  on_submit = function(item)
    -- print("Menu Submitted: ", item.text)
    if item.text == "Go Home" then
      print("Go Home")
      vim.cmd("Alpha")
    end
    if item.text == "Lazy Plugins" then
      print("Lazy Plugins")
      vim.cmd("Lazy")
    end
    if item.text == "Open Terminal" then
      print("Open Terminal")
      vim.cmd("terminal")
    end
    if item.text == "Focus Mode" then
      print("Focus Mode")
      require("zen-mode").toggle({
        window = {
            width = .80,
            height = 1,
        }
      })
    end
    if item.text == "Mason LSP" then
      print("Mason LSP")
      vim.cmd("Mason")
    end
    if item.text == "Git GUI" then
      print("Git GUI")
      vim.cmd("Fugit2")
    end

    if item.text == "Open File Browser" then
      print("Open File Browser")
      vim.cmd("Telescope file_browser path=D:/Coding")
    end

    if item.text == "Open Leetcode" then
      print("Open Leetcode")
      vim.cmd("Leet")
    end
  end,
})

-- mount the component
menu:mount()
