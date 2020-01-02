class DocumentationConstraint
  def self.documentation
    CodeLanguage.route_constraint.merge(product_with_parent)
  end

  def self.product_list
    [
      'account',
      'application',
      'audit',
      'voice',
      'messaging',
      'verify',
      'number-insight',
      'concepts',
      'client-sdk',
      'stitch',
      'conversation',
      'messages',
      'numbers',
      'dispatch',
      'redact',
      'vonage-business-cloud',
    ]
  end

  def self.product
    { product: Regexp.new(product_list.compact.join('|')) }
  end

  def self.product_with_parent_list
    [
      'audit',
      'application',
      'voice/sip',
      'voice/voice-api',
      'messaging/sms',
      'messaging/conversion-api',
      'messaging/us-short-codes',
      'verify',
      'number-insight',
      'concepts',
      'client-sdk/in-app-voice',
      'client-sdk/in-app-video',
      'client-sdk/in-app-messaging',
      'conversation',
      'messages',
      'dispatch',
      'numbers',
      'vonage-business-cloud/smart-numbers',
      'vonage-business-cloud/integration-suite',
      'vonage-business-cloud/vbc-apis/account-api',
      'vonage-business-cloud/vbc-apis/extension-api',
      'vonage-business-cloud/vbc-apis/reports-api',
      'vonage-business-cloud/vbc-apis/user-api',
      'account/subaccounts',
      'reports',
      'redact',
    ]
  end

  def self.product_with_parent
    { product: Regexp.new(products_for_routes.compact.join('|')) }
  end

  def self.products_for_routes
    (product_with_parent_list + product_list).uniq
  end
end
