#output "instance" {
#    value = "${aws_instance.instance.id}"
#}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = "$aws.instance_compute.id"
}
