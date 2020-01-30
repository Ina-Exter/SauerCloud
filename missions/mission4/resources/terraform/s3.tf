#S3
resource "aws_s3_bucket" "SauerCloud-mission4-final-s3" {
  bucket        = "secgame-mission4-final-s3-${var.id}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "secgame-mission4-final-s3-${var.id}"
  }
}

#S3 OBJECTS 
resource "aws_s3_bucket_object" "picture-of-buddha-cat-1" {
  bucket = aws_s3_bucket.SauerCloud-mission4-final-s3.id
  key    = "buddha_wot.jpg"
  source = "../flags/buddha_wot.jpg"
  tags = {
    Name = "SauerCloud-mission4-picture-of-cat-buddha-${var.id}"
  }
}

resource "aws_s3_bucket_object" "picture-of-buddha-cat-2" {
  bucket = aws_s3_bucket.SauerCloud-mission4-final-s3.id
  key    = "buddha_drug_kingpin.jpg"
  source = "../flags/buddha_drug_kingpin.jpg"
  tags = {
    Name = "SauerCloud-mission4-picture-of-cat-buddha-${var.id}"
  }
}

resource "aws_s3_bucket_object" "on_buddha" {
  bucket = aws_s3_bucket.SauerCloud-mission4-final-s3.id
  key    = "on_buddha.txt"
  source = "../flags/on_buddha.txt"
  tags = {
    Name = "SauerCloud-mission4-text-about-cat-buddha-${var.id}"
  }
}
