![cover_bossmenu|690x388](https://forum-cfx-re.akamaized.net/original/5X/0/6/8/5/0685bd100dce8fb22ef7d8c136ac775d1c74bd0a.jpeg)

# KS Bossmenu for ESX

A modern, feature-rich boss menu for ESX-based servers.  
Manage your job, employees, salaries, and society account with a clean and responsive Vue 3 interface.

# [⬇️ Download](https://github.com/Kxiox/ks_bossmenu/releases)

## Features

- **Modern UI:** Built with Vue 3, Bootstrap 5, and Bootstrap Icons.
- **Multi-language support:** Easily add or switch between languages (EN/DE included).
- **Customizable:** Change colors, logos, and currency per job in `config.lua`.
- **Employee Management:** Add, promote, demote, or fire employees directly from the menu.
- **Salary Management:** View and change job grade salaries.
- **Society Account:** Deposit and withdraw money, view all transactions.
- **Action Log:** See the latest actions performed by bosses.
- **Permissions:** Only configured grades can access the boss menu.
- **Easy Integration:** Plug-and-play with ESX and oxmysql.

## Installation

1. **Download and extract** the resource to your `resources` folder.
2. **Configure** your jobs, colors, and settings in `config.lua`.
3. **Add** `ensure ks_bossmenu` to your `server.cfg`.
4. **Import** the included SQL file if provided.
5. **Restart your server.**

## Requirements

- ESX (1.9 or higher)
- oxmysql

## Customization

- **Add your own logo:** Place your image in `img` and set the filename in `config.lua`.
- **Change colors and currency** in `config.lua`.
- **Add more translations** by creating new JSON files in `locales`.

## Support
[☎️ Discord](https://discord.gg/ZcAtT6ShAk)
[📄 Documentation](https://kxiox.gitbook.io/kxiox-scripts/ks-bossmenu/)

> This project is licensed under the GNU General Public License v3.0.