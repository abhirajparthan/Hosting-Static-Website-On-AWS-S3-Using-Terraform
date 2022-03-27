
output  "end_point"   {

        value   =  aws_s3_bucket.abhirajs3.website_endpoint

}

output  "website_url"   {

        value   =  "http://${aws_route53_record.CNAME.name}"

}

~   
