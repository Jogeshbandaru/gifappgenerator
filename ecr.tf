resource "aws_ecr_repository" "cat_gif_app_repo" {
  name = "cat-gif-app"
  image_scanning_configuration {
    scan_on_push = true
  }
}
