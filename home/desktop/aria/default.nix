{...}: {
  programs.aria2 = {
    enable = true;
    settings = {
      max-connection-per-server = 16;
      min-split-size = "1M";
      split = 16;
      continue = true;
    };
  };
}
