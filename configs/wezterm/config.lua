local wezterm = require('wezterm')

return {
  font = wezterm.font('Iosevka SS02'),
  font_size = 10.5,

  enable_tab_bar = false,

  exit_behavior = "Close",

  check_for_updates = false,

  colors = {
    background = '#111111',
    foreground = '#EFEFEF',
    cursor_bg = 'white',
    cursor_border = 'white',

    ansi = {'#2E3436', '#CC0000', '#4E9A06', '#C4A000', '#3465A4', '#75507B', '#06989A', '#D3D7CF'},
    brights = {'#555753', '#EF2929', '#8AE234', '#FCE94F', '#729FCF', '#AD7FA8', '#34E2E2', '#EEEEEC'},

    visual_bell = '#FF0000'
  },

  window_padding = {
    left = 6,
    right = 6,
    top = 6,
    bottom = 6,
  }
}
