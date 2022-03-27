# Hosting-Static-Website-On-AWS-S3-Using-Terraform

-----
## Description

In this article, I will help you with how to host a simple static website on S3 using Terraform and how to access the website using a specific name. We will configure an S3 bucket to provide users access to our website.

Amazon S3 is a service offered by Amazon Web Services that provides object storage through a web service interface. It provides unlimited storage for various use cases at a very low cost.

-----
## Prerequisite

AWS account with Secreat_key and Access_key (  with policies for the S3 )

-----
## Table of Contents

1. Create an S3 bucket
2. Enabling static website hosting for bucket
3. Setting Bucket Policy for public access
4. Upload web files to S3 bucket
5. Point website url to bucket name using Rout 53.

Now, let’s get into it!

