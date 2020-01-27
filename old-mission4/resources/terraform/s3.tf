resource "aws_s3_bucket" "AWS-secgame-mission4-evilcorp-evilbucket" {
    bucket = "evilcorp-evilbucket-${var.id}"
    acl = "public-read"
    force_destroy = true
    tags = {
        Name = "evilcorp-evilbucket-${var.id}"
    }
}


resource "aws_s3_bucket_object" "extremely-evil-access-code" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission4-evilcorp-evilbucket.id}"
    key = "flag.txt"
    acl = "public-read"
    source = "../flag.txt"
    tags = {
        Name = "AWS-secgame-mission4-evilcorp-evilbucket-data-${var.id}"
    }
}	
