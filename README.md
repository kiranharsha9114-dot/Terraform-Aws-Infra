terraform-aws-devsecops-infra/
│
├── modules/                        # Reusable modules (core infra)
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── cloudwatch/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│
│
├── environments/                  # Environment-specific configs
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf
│   │
│   ├── prod/                      # (optional but looks pro)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf
│
│
├── backend/                       # Remote state setup (run once)
│   ├── s3.tf
│   ├── dynamodb.tf
│   ├── provider.tf
│
│
├── scripts/                       # Automation scripts
│   ├── deploy.sh
│   ├── destroy.sh
│   ├── user_data.sh
│
│
├── policies/                      # IAM JSON policies (clean separation)
│   ├── ec2-policy.json
│   ├── cloudwatch-policy.json
│
│
├── docs/                          # Documentation + diagrams
│   ├── architecture.png
│   ├── architecture.drawio
│
│
├── .gitignore
├── README.md
└── LICENSE
