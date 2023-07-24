module "commit-proj" {
  source                    = "./infrastructure"
  accountId                 = local.accountid
  myregion                  = local.region
  commit_domain             = local.commit_domain
}