variable "hello" {
  type = string
}

variable "list_test" {
  type = list(any)
}

variable "map_test" {
  type = map(any)
}

variable "splat_test" {
  type = list(any)
}

output "world" {
  value = "Helllo %{if var.hello == "barsoon"}Mars%{else}World%{endif}"
}

output "world2" {
  value = var.hello == "world" ? "correct" : var.hello
}

output "list_test1" {
  value = [for lt in var.list_test : upper(lt)]
}

output "list_test2" {
  value = { for i, v in var.list_test : "${i}" => upper(v) }
}

output "map_test1" {
  value = [for k, v in var.map_test : upper(k)]
}

output "map_test2" {
  value = { for k, v in var.map_test : upper(k) => v }
}

output "map_test3" {
  value = [for k, v in var.map_test : upper(k) if v == 1]
}

output "splat_test1" {
  value = [for m in var.splat_test : m.mars_name]
}

output "splat_test2" {
  value = var.splat_test[*].mars_name
}
