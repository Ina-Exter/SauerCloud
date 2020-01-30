#!/bin/bash


mv terraform/s3.tf ./s3old.tf
touch ./terraform/s3.tf

cat << 'EOF' > ./terraform/s3.tf
resource "aws_s3_bucket" "SauerCloud-mission1-evilcorp-evilbucket" {
    bucket = "evilcorp-evilbucket-${var.id}"
    acl = "public-read"
    force_destroy = true
    tags = {
        Name = "evilcorp-evilbucket-${var.id}"
    }
}


resource "aws_s3_bucket_object" "extremely-evil-access-code" {
    bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id
    key = "extremely-evil-access-code.txt"
    acl = "public-read"
    source = "../evilcorp-evilbucket-data/extremely-evil-access-code.txt"
    tags = {
        Name = "SauerCloud-mission1-evilcorp-evilbucket-data-${var.id}"
    }
}	

EOF

unzip evilcorp-evilbucket-data.zip
cd evilcorp-evilbucket-data
find .git/* -type f -exec echo "resource \"aws_s3_bucket_object\" \"git-{}\" {" >> ../terraform/s3.tf \; \
	-exec echo "	bucket = aws_s3_bucket.SauerCloud-mission1-evilcorp-evilbucket.id" >> ../terraform/s3.tf \; \
	-exec echo "	key = \"{}\"" >> ../terraform/s3.tf \; \
	-exec echo "	acl = \"public-read\"" >> ../terraform/s3.tf \; \
	-exec echo "	source = \"../evilcorp-evilbucket-data/{}\"" >> ../terraform/s3.tf \; \
	-exec echo "	tags = {" >> ../terraform/s3.tf \; \
	-exec echo "  	  Name = \"SauerCloud-mission1-evilcorp-evilbucket-data-\${var.id}\"" >> ../terraform/s3.tf \; \
	-exec echo "	}" >> ../terraform/s3.tf \; \
 	-exec echo "}" >> ../terraform/s3.tf \; \
	-exec echo "" >> ../terraform/s3.tf \;
cd ..

LINE_COUNT=$(grep 'git-.*' terraform/s3.tf -c)
while [[ $LINE_COUNT -ne 0 ]]
do
	sed -i "0,/git-\..*/s//git-$LINE_COUNT\" {/" terraform/s3.tf
	let LINE_COUNT=$LINE_COUNT-1
done

rm -rf evilcorp-evilbucket-data/
