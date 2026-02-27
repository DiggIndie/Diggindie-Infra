# 기존 AWS 리소스를 Terraform Cloud State로 가져오기
# 사용법: 로컬에서 실행해서 임포트 했습니당 ~
#
# 사전 준비:
#   1. main.tf의 organization 이름 변경
#   2. Terraform Cloud Variables 등록 완료
#   3. terraform login
#   4. terraform init
#   5. 아래 $DB_PASSWORD를 실제 비밀번호로 변경 후 실행

# ──────────────────────────────────────────────
# 변수 설정
# ──────────────────────────────────────────────
$KEY_NAME = "diggindie"
$DB_PASSWORD = "diggindie비밀번호지롱"

$VARS = "-var=`"key_name=$KEY_NAME`" -var=`"db_password=$DB_PASSWORD`""

# ──────────────────────────────────────────────
# VPC
# ──────────────────────────────────────────────
Invoke-Expression "terraform import $VARS module.vpc.aws_vpc.main vpc-057228e2f6a80c029"
Invoke-Expression "terraform import $VARS module.vpc.aws_internet_gateway.main igw-0ba4c8eb8af03a996"
Invoke-Expression "terraform import $VARS module.vpc.aws_subnet.public_a subnet-04105f77e34ef8ad1"
Invoke-Expression "terraform import $VARS module.vpc.aws_subnet.public_b subnet-0ead2c86bb7095dfb"
Invoke-Expression "terraform import $VARS module.vpc.aws_route_table.public rtb-0633d9c67512d7ef3"
Invoke-Expression "terraform import $VARS module.vpc.aws_route_table_association.public_a subnet-04105f77e34ef8ad1/rtb-0633d9c67512d7ef3"
Invoke-Expression "terraform import $VARS module.vpc.aws_route_table_association.public_b subnet-0ead2c86bb7095dfb/rtb-0633d9c67512d7ef3"
Invoke-Expression "terraform import $VARS module.vpc.aws_security_group.web sg-0f5905bcb05ea2fd5"
Invoke-Expression "terraform import $VARS module.vpc.aws_security_group.db sg-05a838626dc313612"

# ──────────────────────────────────────────────
# EC2
# ──────────────────────────────────────────────
Invoke-Expression "terraform import $VARS module.ec2.aws_instance.main i-0e01b7db5f1565c3f"
Invoke-Expression "terraform import $VARS module.ec2.aws_eip.main eipalloc-03c22e399b3265fcb"

# ──────────────────────────────────────────────
# RDS
# ──────────────────────────────────────────────
Invoke-Expression "terraform import $VARS module.rds.aws_db_subnet_group.main diggindie-dev-db-subnet-group"
Invoke-Expression "terraform import $VARS module.rds.aws_db_instance.main diggindie-dev-db"

# ──────────────────────────────────────────────
# ECR
# ──────────────────────────────────────────────
Invoke-Expression "terraform import $VARS aws_ecr_repository.main diggindie-dev"

# ──────────────────────────────────────────────
# S3
# ──────────────────────────────────────────────
Invoke-Expression "terraform import $VARS aws_s3_bucket.images diggindie-imgs"
Invoke-Expression "terraform import $VARS aws_s3_bucket_public_access_block.images diggindie-imgs"

# ──────────────────────────────────────────────
# 완료 후 확인
# ──────────────────────────────────────────────
Write-Host "`n=== Import 완료! 확인 중... ===" -ForegroundColor Green
Invoke-Expression "terraform state list"
Write-Host "`n=== terraform plan 실행해서 'No changes' 나오면 성공! ===" -ForegroundColor Green

terraform plan -var="key_name=diggindie" -var="db_password=$DB_PASSWORD"
