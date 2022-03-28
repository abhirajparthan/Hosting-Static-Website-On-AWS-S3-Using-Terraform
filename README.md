# Hosting-Static-Website-On-AWS-S3-Using-Terraform

-----
## Description

In this article, I will help you with how to host a simple static website on S3 using Terraform and how to access the website using a specific name. We will configure an S3 bucket to provide users access to our website.

Amazon S3 is a service offered by Amazon Web Services that provides object storage through a web service interface. It provides unlimited storage for various use cases at a very low cost.

-----
## Prerequisite

AWS account with Secreat_key and Access_key (  with policies for the S3 )

------
## Diagram

![abhiraj123](https://user-images.githubusercontent.com/100773790/160301663-cead2e5a-5199-4fff-b36c-39563d2abed9.png)

-----
## Table of Contents

1. Create an S3 bucket
2. Enabling static website hosting for bucket
3. Setting Bucket Policy for public access
4. Upload web files to S3 bucket
5. Point website url to bucket name using Rout 53.

Now, let’s get into it!

## 1 - Create an S3 bucket

 I have created a bucket with the name "s3.abhiraj.ga" and I added the access permission "public-read" to the bucket.
~~~
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

~~~

## 2 - Enabling static website hosting for bucket

Here I have enabled the static website for the bucket with index_docuemt.

~~~
#++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Enable Static Website
#++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_s3_bucket_website_configuration" "static" {

  bucket = aws_s3_bucket.abhirajs3.bucket

  index_document {
    suffix = "index.html"
  }


    }

~~~~

## 3 - Setting Bucket Policy for public access

Here I have added the bucket policy for public access.

~~~
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

~~~


## 4 - Upload web files to S3 bucket

Here, The files are uploaded to the S3 bucket. My file location is "/root/2119_gymso_fitness". I have added the "mime_types" in the variable.tf file. So please refer to the variable.tf file for clarification.

~~~
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

~~~

## 5 - Point website url to bucket name using Rout 53.

Here the static website end point added as CNAME in the rout 53 through script.
~~~
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

~~~

## Output

The output will print the Static website end point and the Domain name like this.

![Screenshot from 2022-03-28 01-31-39](https://user-images.githubusercontent.com/100773790/160299989-91de6d3d-1641-482f-bcf3-841546cc213e.png)




## Conclusion

This tutorial we discussed how to host a static website on AWS S3 using terraform and how to point the website URL to a specific name using Rout53. The goal is to get you started on using S3 to host a simple static website as it is cheap and easy to do.

### ⚙️ Connect with Me

<p align="center">
 <a href="https://www.instagram.com/_r.e.b.e.l.z_33/"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/abhiraj-parthan-82038b191"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/></a> 



