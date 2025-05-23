#!/usr/bin/env lua

-- Use a list because table keys are randomly sorted
-- It's also easier to add options or edit them this way
local options = {
  {
    name = "Log out",
    icon = "system-log-out",
    command = "swaymsg exit"
  },
  {
    name = "Lock",
    icon = "system-lock-screen",
    command = "swaylock"
  },
  {
    name = "Shut down",
    icon = "system-shutdown",
    command = "systemctl poweroff"
  },
  {
    name = "Restart",
    icon = "system-reboot",
    command = "systemctl reboot"
  },
  {
    name = "Soft Reboot",
    icon = "system-reboot",
    command = "systemctl soft-reboot"
  }
}

for i, opt in ipairs(options) do
  if arg[1] then
    if opt.name == arg[1] then
      io.popen(opt.command..' &')
      os.exit(1)
    end
  else
    print(opt.name..'\0icon\x1f'..opt.icon)
  end
end
