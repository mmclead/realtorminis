#hack in the payment account id
# module Simplepay
#   module Services
#     class Standard < Service
#       field :amazonPaymentsAccountId, value: 
#     end
#   end
# end


Simplepay.aws_access_key_id     = ENV['AWS_SIMPLE_PAYMENT_ACCESS_KEY_ID']
Simplepay.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
Simplepay.amazon_payments_account_id = ENV['AMAZON_PAYMENTS_ACCOUNT_ID']
Simplepay.use_sandbox = true 