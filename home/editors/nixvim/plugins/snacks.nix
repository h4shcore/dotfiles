{
  programs.nixvim.plugins.snacks = {
    enable = true;

    settings = {
      bigfile = {
        enabled = true;
      };

      dashboard = {
        enabled = true;
      };

      explorer = {
        enabled = false;
      };

      indent = {
        enabled = true;
      };

      input = {
        enabled = true;
      };

      notifier = {
        enabled = true;
      };

      picker = {
        enabled = true;
      };

      quickfile = {
        enabled = true;
      };

      rename = {
        enabled = true;
      };

      scope = {
        enabled = true;
      };

      scroll = {
        enabled = true;
      };

      statuscolumn = {
        enabled = true;
      };

      words = {
        enabled = true;
      };

      terminal = {
        enabled = false;
      };

      zen = {
        enabled = false;
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options.desc = "Find files";
    }

    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options.desc = "Live grep";
    }

    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options.desc = "Buffers";
    }

    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>lua Snacks.picker.recent()<CR>";
      options.desc = "Recent files";
    }

    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>lua Snacks.picker.help()<CR>";
      options.desc = "Help tags";
    }

    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>lua Snacks.picker.explorer()<CR>";
      options.desc = "Explorer";
    }
  ];
}
