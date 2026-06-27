{...}: {
  users.users.daksh = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
