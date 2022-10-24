
module "tfrun-functions" {
  source = "../../mocks/tfrun-functions.sentinel"
}


mock "tfplan/v2" {
  module {
    source = "../../mocks/mock-tfplan-fail-v2.sentinel"
  }
}

mock "tfrun" {
  module {
    source = "../../mocks/mock-tfrun.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
