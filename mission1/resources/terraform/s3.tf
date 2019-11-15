resource "aws_s3_bucket" "AWS-secgame-mission1-evilcorp-evilbucket" {
    bucket = "evilcorp-evilbucket-${var.id}"
    acl = "public-read"
    force_destroy = true
    tags = {
        Name = "evilcorp-evilbucket-${var.id}"
    }
}


resource "aws_s3_bucket_object" "extremely-evil-access-code" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = "extremely-evil-access-code.txt"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/extremely-evil-access-code.txt"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	

resource "aws_s3_bucket_object" "extremely-evil-git-folder1" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/update.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/update.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder2" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/pre-applypatch.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/pre-applypatch.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder3" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/prepare-commit-msg.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/prepare-commit-msg.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder4" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/pre-rebase.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/pre-rebase.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder5" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/pre-receive.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/pre-receive.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder6" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/pre-push.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/pre-push.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder7" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/applypatch-msg.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/applypatch-msg.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder8" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/post-update.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/post-update.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder9" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/pre-commit.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/pre-commit.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder10" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/commit-msg.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/commit-msg.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder11" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/hooks/fsmonitor-watchman.sample"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/hooks/fsmonitor-watchman.sample"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder12" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/description"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/description"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder13" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/HEAD"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/HEAD"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder14" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/4d/6d8a8d537c12f30960cd6ffb74a207c3e41357"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/4d/6d8a8d537c12f30960cd6ffb74a207c3e41357"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder15" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/74/7a6aae67a712517ca671d7310d2e817b9ecc62"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/74/7a6aae67a712517ca671d7310d2e817b9ecc62"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder16" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/86/972d85f2771f3203957ebc15fe85958a31a335"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/86/972d85f2771f3203957ebc15fe85958a31a335"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder17" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/a9/01e6822448751707b618ef5ef966159f003d02"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/a9/01e6822448751707b618ef5ef966159f003d02"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder18" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/e9/bfadd3a7dbd3d7bc2bb8fdf61e95892046bf24"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/e9/bfadd3a7dbd3d7bc2bb8fdf61e95892046bf24"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder19" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/ff/e15afca9c23ec64b0c53c9ad33531240e548ee"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/ff/e15afca9c23ec64b0c53c9ad33531240e548ee"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder20" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/7b/5e91f20f3c7333c61139aee5bffd6cadffe6cb"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/7b/5e91f20f3c7333c61139aee5bffd6cadffe6cb"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder21" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder22" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/logs/HEAD"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/logs/HEAD"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder23" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/logs/refs/heads/master"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/logs/refs/heads/master"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder24" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/config"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/config"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder25" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/COMMIT_EDITMSG"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/COMMIT_EDITMSG"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder26" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/index"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/index"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder27" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/info/exclude"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/info/exclude"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	

resource "aws_s3_bucket_object" "extremely-evil-git-folder28" {
    bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
    key = ".git/refs/heads/master"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/.git/refs/heads/master"
    tags = {
        Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	
	
