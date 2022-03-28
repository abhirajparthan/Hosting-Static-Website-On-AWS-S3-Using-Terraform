#++++++++++++++++++++++++++++++++++++++++++++++++++
# S3 Creation with public read acces
#++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_s3_bucket" "abhirajs3" {


  bucket = "s3.abhiraj.ga"


  tags = {
    Name        = var.project
    Environment = var.project
  }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Enable Static Website
#++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_s3_bucket_website_configuration" "static" {

  bucket = aws_s3_bucket.abhirajs3.bucket

  index_document {
    suffix = "index.html"
  }


    }

#+++++++++++++++++++++++++++++++++++++++++++++++++++++
#Bucket policy for access
#+++++++++++++++++++++++++++++++++++++++++++++++++++++

data "aws_iam_policy_document" "allow_access_from_public" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    
    actions = [
      "s3:GetObject","s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.abhirajs3.arn,
      "${aws_s3_bucket.abhirajs3.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_policy" "allow_access_from_public" {

  bucket = aws_s3_bucket.abhirajs3.id
  policy = data.aws_iam_policy_document.allow_access_from_public.json
}


#++++++++++++++++++++++++++++++++++++++++++++++++++++
# File Upload to S3
#++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_s3_object" "upload" {

   for_each = fileset("/root/2119_gymso_fitness", "**")
 
   bucket = aws_s3_bucket.abhirajs3.bucket
   key    =  each.value
   source = "/root/2119_gymso_fitness/${each.value}"


  etag         = filemd5("/root/2119_gymso_fitness/${each.value}")
  content_type  = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])

}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
# rout 53 zone ID
#++++++++++++++++++++++++++++++++++++++++++++++++++++++

data "aws_route53_zone" "zone" {

  name         = var.domain

}

resource "aws_route53_record" "CNAME" {

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.project
  type    = "CNAME"
  ttl     = "10"
  records = [aws_s3_bucket_website_configuration.static.website_endpoint]

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++
# output
#+++++++++++++++++++++++++++++++++++++++++++++++++++++
