output "key" {
  value = var.type == "password" && var.rotation_type == "overlap" ? time_rotating.schedule1.unix > time_rotating.schedule2["schedule"].unix ? "key1" : "key2" : var.type == "password" ? "key1" : null
}
