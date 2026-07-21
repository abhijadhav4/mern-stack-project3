/*
===========================================
Amazon ECR Repositories
===========================================

This file creates two ECR repositories.

1. frontend
2. backend

GitHub Actions will build Docker images
and push them into these repositories.

===========================================
*/

#############################
# Frontend Repository
#############################

resource "aws_ecr_repository" "frontend" {

  name = local.frontend_repository

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {

    scan_on_push = true

  }

  tags = merge(
    local.common_tags,
    {
      Name = "frontend-ecr"
    }
  )

}

#############################
# Backend Repository
#############################

resource "aws_ecr_repository" "backend" {

  name = local.backend_repository

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {

    scan_on_push = true

  }

  tags = merge(
    local.common_tags,
    {
      Name = "backend-ecr"
    }
  )

}

#############################
# Lifecycle Policy
#############################

resource "aws_ecr_lifecycle_policy" "frontend_policy" {

  repository = aws_ecr_repository.frontend.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only latest 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

}

resource "aws_ecr_lifecycle_policy" "backend_policy" {

  repository = aws_ecr_repository.backend.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only latest 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

}