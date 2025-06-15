variable "enable_key_rotation"  {
      type    = bool
      default = true
}


variable  "rotation_period_kms" {
     type    = number
     default = 90
}

variable  "deletion_window" {
     type    = number
     default = 1
}