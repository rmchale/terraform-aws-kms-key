module "label" {
  source      = "git::https://github.com/rmchale/terraform-null-label.git"
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  delimiter   = var.delimiter
  tags        = var.tags
}

resource "aws_kms_key" "default" {
  count                   = var.enabled == true ? 1 : 0
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.policy
  tags                    = module.label.tags
  description             = var.description
}

resource "aws_kms_alias" "default" {
  count         = var.enabled == true ? 1 : 0
  name          = coalesce(var.alias, format("alias/%v", module.label.id))
  target_key_id = join("", aws_kms_key.default.*.id)
}
