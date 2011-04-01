require 'test_helper'

class OpenidRegistrableTest < ActiveSupport::TestCase

  def mock_openid_data
    {"http://axschema.org/contact/email" => ['karel@novak.cz'],
     "http://axschema.org/namePerson/friendly" => ['karel'],
     "http://axschema.org/namePerson/first" => ['Karel'],
     "http://axschema.org/namePerson/last" => ['Novak'],
     "http://axschema.org/contact/postalAddress/home" => ['Vinohrady 20'],
     "http://axschema.org/contact/city/home" => ['Praque'],
     "http://axschema.org/contact/postalCode/home" => ['000 00'],
     "http://axschema.org/contact/phone/default" => ['+420.000 000 00']}
  end

  context 'Model' do
    should 'respond to #openid_registrable' do
      assert User.respond_to? :openid_registrable
    end

    should 'respond to #openid_fields_to_model_fields_mapping' do
      assert User.respond_to? :openid_fields_to_model_fields_mapping
    end
  end

  context 'Model#openid_registrable' do
    should 'define class method :openid_required_fields' do
      assert_equal ['http://axschema.org/contact/email','http://axschema.org/namePerson/friendly'], User.openid_required_fields
    end

    should 'define class method :openid_optional_fields' do
      assert_equal ["http://axschema.org/namePerson/first",
        "http://axschema.org/contact/postalCode/home",
        "http://axschema.org/contact/city/home",
        "http://axschema.org/contact/phone/default",
        "http://axschema.org/namePerson/last",
        "http://axschema.org/contact/postalAddress/home"], User.openid_optional_fields
    end
  end

  context 'Model#openid_fields_to_model_fields_mapping' do
    should 'return mapping fields' do
      assert_equal ({:first_name=>"http://axschema.org/namePerson/first",
        :zip=>"http://axschema.org/contact/postalCode/home",
        :city=>"http://axschema.org/contact/city/home",
        :email=>"http://axschema.org/contact/email",
        :last_name=>"http://axschema.org/namePerson/last",
        :phone=>"http://axschema.org/contact/phone/default",
        :address=>"http://axschema.org/contact/postalAddress/home",
        :username=>"http://axschema.org/namePerson/friendly"}), User.openid_fields_to_model_fields_mapping
    end
  end

  context 'Model#assign_openid_fields' do
    setup {
      @user = User.new
    }
    should 'assign all openid fields to model fields' do
      @user.assign_openid_fields(mock_openid_data)

      assert_equal ({"city"=>"Praque",
        "address"=>"Vinohrady 20",
        "zip"=>"000 00",
        "username"=>"karel",
        "phone"=>"+420.000 000 00",
        "last_name"=>"Novak",
        "first_name"=>"Karel",
        "email"=>"karel@novak.cz"}), @user.attributes
    end

    should 'assign openid fields to model fields or ignore some' do
      @user.assign_openid_fields(mock_openid_data, [:username])

      assert_equal ({"city"=>"Praque",
        "address"=>"Vinohrady 20",
        "zip"=>"000 00",
        "username"=>nil,
        "phone"=>"+420.000 000 00",
        "last_name"=>"Novak",
        "first_name"=>"Karel",
        "email"=>"karel@novak.cz"}), @user.attributes
    end
  end
end
