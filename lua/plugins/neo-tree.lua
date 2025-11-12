return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true, -- Close Neo-tree if it's the last window
    popup_border_style = "rounded", -- Nicer looking popups
    
    filesystem = {
      filtered_items = {
        visible = true, -- Always show hidden files
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".git",
          "node_modules",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      -- Note: follow_current_file and use_libuv_file_watcher are already
      -- enabled by default in LazyVim, so no need to specify them here
    },
  },
}
