module "vpc" {
  source = "./module/vpc"

  # Pass variables to VPC module
  vpc_id                  = "10.0.0.0/16"
  public_subnet_id_value  = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  private_subnet_id_value = "10.0.2.0/24"
  availability_zone1      = "ap-south-1b"
}

module "ec2" {
  source = "./module/ec2_instance"

  # Pass variables to EC2 module
  ami_value              = "ami-0522ab6e1ddcc7055"
  instance_type_value    = "t2.large"
  key_name               = "manoj"
  instance_count         = "1"
  public_subnet_id_value = module.vpc.public_subnet_id
  availability_zone      = "ap-south-1a"
  vpc_id                 = module.vpc.vpc_id
  # Correctly pass user_data to the module
  user_data = filebase64("${path.module}/module/ec2_instance/jenkins.sh")
}

# module "eks" {
#   source = "./module/eks"

#   # Pass variables to EKS module
#   public_subnet_id_value  = module.vpc.public_subnet_id
#   private_subnet_id_value = module.vpc.private_subnet_id
#   instance_type_value     = "t2.large"
#   cluster_name            = "EKS_01"
#   workernode_name         = "Node_01"
#   key_name                = "manoj"
#   security_group_id       = module.ec2.security_group_id
# }