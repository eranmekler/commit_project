#Main file. Connects to infrastructure module. Refer to ./locals.tf and change desired values.
module "commit-proj" {
  source        = "./infrastructure"
  accountId     = local.accountid
  myregion      = local.region
  commit_domain = local.commit_domain
}