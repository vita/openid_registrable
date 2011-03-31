# Makes possible define required and optional fields for registration via OpenID
# and to map them to fields of your model.

module OpenidRegistrable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    # Using:
    #
    # class User < ActiveRecord::Base
    #   openid_registrable :required_fields => {
    #       :email => 'http://axschema.org/contact/email',
    #     },
    #     :optional_fields => {
    #       :first_name => 'http://axschema.org/namePerson/first',
    #       :last_name => 'http://axschema.org/namePerson/last',
    #     }
    # end

    def openid_registrable(options)
      [:required_fields, :optional_fields].each do |fields|
        unless options[fields].empty?
          (class << self; self; end).instance_eval do
            # define methods openid_require_fields and openid_optional_fields
            # methods returns array generated from options given in #openid_registrable, e.g.:
            # => ['http://axschema.org/namePerson/first', 'http://axschema.org/namePerson/last']
            define_method "openid_#{fields}" do
              options[fields].values
            end
          end
        end
      end

      # define method :openid_fields_to_model_fields_mapping
      # method returns hash genered from options given in #openid_registrable, e.g.:
      # => {:first_name=>"http://axschema.org/namePerson/first",
      #     :last_name=>"http://axschema.org/namePerson/last"}

      if options[:required_fields] or options[:optional_fields]
        (class << self; self; end).instance_eval do
          define_method :openid_fields_to_model_fields_mapping do
            mapping = {}
            mapping.merge!(options[:required_fields]) if options[:required_fields]
            mapping.merge!(options[:optional_fields]) if options[:optional_fields]
          end
        end
      end

      send :include, InstanceMethods
    end
  end

  module InstanceMethods

    # Using with open_id_authentication (https://github.com/Velir/open_id_authentication)
    #
    # authenticate_with_open_id(@openid_identifier, :required => User.openid_required_fields, :optional => User.openid_optional_fields) do |result, identity_url, sreg_data, ax_data|
    #   if result.successful?
    #     if self.current_user = User.find_by_identity_url(identity_url)
    #       current_user.assign_openid_fields(ax_data, [:username])
    #
    #       current_user.changes.empty? ? successful_login : successful_login(edit_user_path(:user => current_user.attributes))
    #     else
    #       self.current_user = User.new(:identity_url => identity_url)
    #       current_user.assign_openid_fields(ax_data)
    #
    #       successful_login(registration_via_openid_path(:user => current_user.attributes))
    #     end
    #   else
    #     failed_login result.message
    #   end
    # end

    def assign_openid_fields(openid_fields, ignored_fields=[])
      if self.class.respond_to?(:openid_fields_to_model_fields_mapping)
        self.class.openid_fields_to_model_fields_mapping.each do |model_field, openid_field|

          if openid_fields[openid_field].kind_of?(Array)
            value = openid_fields[openid_field].first
          else
            value = openid_fields[openid_field]
          end

          if value.present? and not ignored_fields.include?(model_field)
            self.send("#{model_field}=", value)
          end
        end
      end
    end
  end
end