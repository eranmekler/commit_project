module "commit-proj" {
  source                    = "./infrastructure"
  accountId                 = local.accountid
  myregion                  = local.region
}