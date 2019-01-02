# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :omniauthable, omniauth_providers: %i[resource_provider france_connect]

  rolify

  def self.from_service_provider_omniauth(data)
    # note that api-auth sub might conflict with franceconnect uid
    # we should use the provider field to mitigate that
    # it is used as the role field for now
    user = where(
      uid: data[:info]['sub']
    ).first_or_create
    user.update(
      oauth_roles: data[:info]['roles'],
      email: data[:info]['email'],
      provider: data[:info]['legacy_account_type']
    )
    user
  end

  def self.from_france_connect_omniauth(data)
    where(
      provider: data['provider'],
      uid: data.info['uid'],
      email: data.info['email']
    ).first_or_create
  end

  def provided_by?(provider)
    send("#{provider}?")
  end

  def france_connect?
    provider == 'france_connect'
  end

  def service_provider?
    provider == 'service_provider'
  end

  def dgfip?
    provider == 'dgfip'
  end

  def api_particulier?
    provider == 'api_particulier'
  end

  def franceconnect?
    provider == 'franceconnect'
  end

  def api_droits_cnam?
    provider == 'api_droits_cnam'
  end

  def sent_messages
    Message.with_role(:sender, self)
  end

  # def send_message(enrollment, params)
  #   message = enrollment.messages.create(params)
  #   add_role(:sender, message)
  #   message
  # end
end
