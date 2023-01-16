variable "YC_TOKEN" {
  default = ""
}

variable "YC_CLOUD_ID" {
  default = ""
}

variable "YC_FOLDER_ID" {
  default = ""
}

locals {
  cores = {
    default = 2
    stage   = 2
    prod    = 4
  }
  memory = {
    default = 4
    stage   = 4
    prod    = 8
  }
  count = {
    default = 1
    stage   = 1
    prod    = 2
  }
  instances = {
    stage = {
      debian: 1,
    },
    prod = {
      debian: 4,
      debian2: 4,
    }

  }
}