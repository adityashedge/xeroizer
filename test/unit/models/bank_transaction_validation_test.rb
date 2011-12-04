require "test_helper"

class BankTransactionValidationTest < Test::Unit::TestCase
  must "supply either SPEND or RECEIVE as the type" do
    instance = Xeroizer::Record::BankTransaction.build({:type => "xxx"}, nil)
    
    assert false == instance.valid?, "Expected invalid because of invalid type"
    
    expected_error = "Invalid type. Expected either SPEND or RECEIVE."

    assert_equal expected_error, instance.errors_for(:type).first, "Expected an error about type"

    instance = Xeroizer::Record::BankTransaction.build({:type => "SPEND"}, nil)
    
    instance.valid?
    
    assert_empty instance.errors_for(:type), "Expected no error about type"

    instance = Xeroizer::Record::BankTransaction.build({:type => "RECEIVE"}, nil)
    
    instance.valid?
    
    assert_empty instance.errors_for(:type), "Expected no error about type"
  end

  must "supply a non-blank contact" do
    instance = Xeroizer::Record::BankTransaction.build({}, nil)
    
    assert false == instance.valid?, "Expected invalid because of missing contact"

    assert_equal "can't be blank", instance.errors_for(:contact).first, "Expected an error about blank contact"
  end

  must "supply at least on line item" do
    zero_line_items = []
    
    instance = Xeroizer::Record::BankTransaction.build({:line_items => zero_line_items}, nil)
    
    assert false == instance.valid?, "Expected invalid because of empty line items"

    assert_equal "Invalid line items. Must supply at least one.", instance.errors_for(:line_items).first, 
      "Expected an error about blank line items"
  end
end
