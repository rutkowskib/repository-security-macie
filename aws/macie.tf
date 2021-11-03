resource "aws_macie2_account" "macie_account" {
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

resource "aws_macie2_custom_data_identifier" "stripe_identifier" {
  name                   = "Stripe secret"
  regex                  = "STRIPE_SECRET"

  depends_on = [ aws_macie2_account.macie_account ]
}