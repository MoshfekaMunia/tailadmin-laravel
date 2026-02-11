locals {
  # Read SSH public keys from files
  app_ssh_public_key = file("${path.module}/appserver-key.pub")
  db_ssh_public_key  = file("${path.module}/dbserver-key.pub")

  # Or read from home directory (use absolute path)
  # app_ssh_public_key = file(pathexpand("~/.ssh/appserver-key.pub"))
  # db_ssh_public_key  = file(pathexpand("~/.ssh/dbserver-key.pub"))

  # DT user provided key
  dt_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICV/wCuwCL2hgXodxQBFcyJd/rurJfo+Gl90QVu5AL2M dt-home-task-key"
}
