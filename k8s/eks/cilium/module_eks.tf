module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.31"

  cluster_name    = local.name
  cluster_version = "1.24"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_alias.this.target_key_arn
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    remote_access = {
      ec2_ssh_key               = var.enable_ssh ? aws_key_pair.this.0.id : null
      source_security_group_ids = var.enable_ssh && var.enable_test_ec2 ? [module.test_ec2.sg_id] : []
    }
    iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    create_launch_template       = false
    launch_template_name         = ""
  }

  eks_managed_node_groups = {
    al2 = {
      ami_type = "AL2_x86_64"

      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
    bottlerocket = {
      ami_type = "BOTTLEROCKET_x86_64"

      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }
}
