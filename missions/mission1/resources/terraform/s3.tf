resource "aws_s3_bucket" "SauerCloud-mission1-evilcorp-evilbucket" {
  bucket        = "evilcorp-evilbucket-${var.id}"
  acl           = "public-read"
  force_destroy = true
  tags = {
    Name = "evilcorp-evilbucket-${var.id}"
  }
}


resource "aws_s3_bucket_object" "extremely-evil-access-code" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = "extremely-evil-access-code.txt"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/extremely-evil-access-code.txt"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-31" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/COMMIT_EDITMSG"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/COMMIT_EDITMSG"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-30" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/config"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/config"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-29" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/description"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/description"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-28" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/HEAD"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/HEAD"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-27" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/update.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/update.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-26" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/pre-applypatch.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/pre-applypatch.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-25" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/prepare-commit-msg.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/prepare-commit-msg.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-24" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/pre-rebase.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/pre-rebase.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-23" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/pre-receive.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/pre-receive.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-22" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/pre-push.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/pre-push.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-21" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/applypatch-msg.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/applypatch-msg.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-20" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/post-update.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/post-update.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-19" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/pre-commit.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/pre-commit.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-18" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/commit-msg.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/commit-msg.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-17" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/hooks/fsmonitor-watchman.sample"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/hooks/fsmonitor-watchman.sample"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-16" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/index"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/index"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-15" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/info/exclude"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/info/exclude"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-14" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/logs/HEAD"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/logs/HEAD"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-13" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/logs/refs/heads/master"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/logs/refs/heads/master"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-12" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/b7/e1e018a0f8da4ef3d5a64c1553df1e35f595c2"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/b7/e1e018a0f8da4ef3d5a64c1553df1e35f595c2"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-11" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/3f/6afec9effc5f3d850f84ff25e5283dab66f378"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/3f/6afec9effc5f3d850f84ff25e5283dab66f378"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-10" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/79/aa4e7df56fc6685f323a176a398f2eb5784f1f"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/79/aa4e7df56fc6685f323a176a398f2eb5784f1f"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-9" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/05/07d960876596b60500ce9cd984964ec1329eb7"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/05/07d960876596b60500ce9cd984964ec1329eb7"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-8" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/6d/24cbc5ef67c3c00c693e5c15d87dd0233f9813"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/6d/24cbc5ef67c3c00c693e5c15d87dd0233f9813"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-7" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/e6/d51ece5a44247366537509caf928eecb50d07c"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/e6/d51ece5a44247366537509caf928eecb50d07c"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-6" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/9d/1414987ec03733e538782c01a5f236e848a7f2"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/9d/1414987ec03733e538782c01a5f236e848a7f2"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-5" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/6b/178e11fb3a5258765859b37c79d3329c31b32f"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/6b/178e11fb3a5258765859b37c79d3329c31b32f"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-4" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/be/9724a02f5407558199177f92af04c4039c8405"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/be/9724a02f5407558199177f92af04c4039c8405"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-3" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/06/6c9c943d93a315a1eacb5db8c8759c9ec3f1aa"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/06/6c9c943d93a315a1eacb5db8c8759c9ec3f1aa"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-2" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/objects/bd/b84a59910b0f297ed97d6d84446221fc4b5c57"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

resource "aws_s3_bucket_object" "git-1" {
  bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
  key    = ".git/refs/heads/master"
  acl    = "public-read"
  source = "../evilcorp-evilbucket-data/.git/refs/heads/master"
  tags = {
    Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
  }
}

