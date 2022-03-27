variable "region"  {

	default = "us-east-1"
}

variable "access_key"  {

	default	= "AKIASAXYWX7XXXXXXXXXXXXX"
}

variable "secret_key"  {

	default = "5Gp8ASEBVPM+f6JjnHXXXXXXXXXXXXXXXXXXXXXXXXXX"

}

variable "project" 	{

	default = "s3.abhiraj.ga"
}


variable "mime_types" {
  default = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    json  = "application/json"
    png	  = "image/png"
    jpg   = "image/jpeg"    
    woff2 = "font/woff2" 
    woff  = "font/woff"
    eot	  = "application/vnd.ms-fontobject" 
    js	  = "text/javascript"
    otf   = "font/otf"
    svg   = "image/svg+xml"
 }
}


