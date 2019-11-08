#S3
resource "aws_s3_bucket" "AWS-secgame-mission5-super-secret-utlimate-s3" {
    bucket = "aws-secgame-mission5-super-secret-utlimate-s3-${var.id}"
    acl = "private"
    force_destroy = true
    tags = {
        Name = "AWS-secgame-mission5-super-secret-utlimate-s3-${var.id}"
    }
}

#S3 OBJECTS (one per pic but same name tag)
resource "aws_s3_bucket_object" "picture-of-mila-best-cat-1" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila1.jpg"
    source = "../flags/mila1.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}
