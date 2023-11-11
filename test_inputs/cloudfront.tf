resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Allow CloudFront to reach the S3 bucket for domain"
}

resource "aws_cloudfront_distribution" "example" {
  http_version = "http2"

  origin {
    domain_name = "domain_name"
    origin_id   = "example"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"

  enabled     = true
  aliases     = ["domain_name_source"]
  price_class = "PriceClass_100"

  default_cache_behavior {
    target_origin_id = "example"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400
  }

  dynamic "custom_error_response" {
    for_each = [403]
    content {
      error_code            = 403
      error_caching_min_ttl = 3600
      response_code         = 200
      response_page_path    = "index.html"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:000000000000:certificate/8d0fab65-ddc4-4aa2-b1b1-ac56255e3257"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}