resource "aws_sqs_queue" "audit_trail_queue" {
  name                      = "${var.sqs_queue}"
  fifo_queue                = true
  content_based_deduplication = true

  tags = merge(
    {
      Name = var.sqs_queue
    },
    var.tags 
  )
}
