class User < ActiveRecord::Base
  openid_registrable :required_fields => {
      :email => 'http://axschema.org/contact/email',
      :username => 'http://axschema.org/namePerson/friendly',
    },
    :optional_fields => {
      :first_name => 'http://axschema.org/namePerson/first',
      :last_name => 'http://axschema.org/namePerson/last',
      :address => 'http://axschema.org/contact/postalAddress/home',
      :city => 'http://axschema.org/contact/city/home',
      :zip => 'http://axschema.org/contact/postalCode/home',
      :phone => 'http://axschema.org/contact/phone/default'
    }
end
