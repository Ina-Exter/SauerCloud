#S3
resource "aws_s3_bucket" "AWS-secgame-mission5-super-secret-utlimate-s3" {
    bucket = "aws-secgame-mission5-super-secret-utlimate-s3-${var.id}"
    acl = "private"
    force_destroy = true
    tags = {
        Name = "AWS-secgame-mission5-super-secret-utlimate-s3-${var.id}"
    }
}

resource "aws_s3_bucket" "AWS-secgame-mission5-s3-es" {
    bucket = "aws-secgame-mission5-s3-personal-data-emetselch-${var.id}"
    acl = "private"
    force_destroy = true
    tags = {
        Name = "AWS-secgame-mission5-s3-es-${var.id}"
    }
}

#S3 OBJECTS
resource "aws_s3_bucket_object" "picture-of-mila-best-cat-1" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila1.jpg"
    source = "../flags/mila1.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-2" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila2.jpg"
    source = "../flags/mila2.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-3" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila3.jpg"
    source = "../flags/mila3.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-4" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila4.jpg"
    source = "../flags/mila4.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-5" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila5.jpg"
    source = "../flags/mila5.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-6" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila6.jpg"
    source = "../flags/mila6.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-7" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila7.jpg"
    source = "../flags/mila7.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "picture-of-mila-best-cat-8" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = "mila8.jpg"
    source = "../flags/mila8.jpg"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-pictures-of-the-developers-cat-${var.id}"
    }
}

resource "aws_s3_bucket_object" "flag-hey-there-hacker" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission5-super-secret-utlimate-s3.id}"
    key = ".hey_there_hacker.txt"
    source = "../flags/.hey_there_hacker.txt"
    tags = {
        Name = "AWS-secgame-mission5-super-secret-ultimate-flag-${var.id}"
    }
}

