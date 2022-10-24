
module "tfplan-functions" {
  source = "../../mocks/tfplan-functions.sentinel"
}


mock "tfplan/v2" {
  module {
    source = "../../mocks/mock-tfplan-pass-v2.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
