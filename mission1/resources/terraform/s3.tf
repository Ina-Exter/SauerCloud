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

resource "aws_s3_bucket_object" "git-30" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/COMMIT_EDITMSG"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/COMMIT_EDITMSG"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-29" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/config"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/config"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-28" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/description"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/description"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-27" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/HEAD"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/HEAD"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-26" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/update.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/update.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-25" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/pre-applypatch.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/pre-applypatch.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-24" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/prepare-commit-msg.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/prepare-commit-msg.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-23" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/pre-rebase.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/pre-rebase.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-22" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/pre-receive.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/pre-receive.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-21" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/pre-push.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/pre-push.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-20" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/applypatch-msg.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/applypatch-msg.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-19" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/post-update.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/post-update.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-18" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/pre-commit.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/pre-commit.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-17" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/commit-msg.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/commit-msg.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-16" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/hooks/fsmonitor-watchman.sample"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/hooks/fsmonitor-watchman.sample"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-15" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/index"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/index"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-14" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/info/exclude"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/info/exclude"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-13" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/logs/HEAD"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/logs/HEAD"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-12" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/logs/refs/heads/master"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/logs/refs/heads/master"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-11" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/89/2743504368f63d322963c076b6ca45282680bf"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/89/2743504368f63d322963c076b6ca45282680bf"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-10" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/4d/6d8a8d537c12f30960cd6ffb74a207c3e41357"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/4d/6d8a8d537c12f30960cd6ffb74a207c3e41357"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-9" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/74/7a6aae67a712517ca671d7310d2e817b9ecc62"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/74/7a6aae67a712517ca671d7310d2e817b9ecc62"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-8" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/86/972d85f2771f3203957ebc15fe85958a31a335"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/86/972d85f2771f3203957ebc15fe85958a31a335"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-7" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/6e/fb5f88e891c94dafe52a49a6c961a26723afc6"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/6e/fb5f88e891c94dafe52a49a6c961a26723afc6"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-6" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/a5/7ebeeb812e957f19e3f698675308216cb470dc"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/a5/7ebeeb812e957f19e3f698675308216cb470dc"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-5" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/f2/1b7e0ee3d62d712d44bf9fd53aee6ed417d0e1"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/f2/1b7e0ee3d62d712d44bf9fd53aee6ed417d0e1"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-4" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/96/d490736bd62b2257b05ef7b098b08a4e6ce334"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/96/d490736bd62b2257b05ef7b098b08a4e6ce334"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-3" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/3d/aa037b38a816fd91056ca47d5365ce4ba5e744"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/3d/aa037b38a816fd91056ca47d5365ce4ba5e744"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-2" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

resource "aws_s3_bucket_object" "git-1" {
	bucket = "${aws_s3_bucket.AWS-secgame-mission1-evilcorp-evilbucket.id}"
	key = ".git/refs/heads/master"
	acl = "public-read"
	source = "../evilcorp-evilbucket-data/.git/refs/heads/master"
	tags = {
  	  Name = "AWS-secgame-mission1-evilcorp-evilbucket-data-${var.id}"
	}
}

