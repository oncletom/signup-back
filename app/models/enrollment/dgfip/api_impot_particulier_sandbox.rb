class Enrollment::ApiImpotParticulierSandbox < Enrollment::Dgfip::SandboxEnrollment
  protected

  def sent_validation
    super

    unless scopes.any? { |k, v| v && %w[dgfip_annee_n_moins_1 dgfip_annee_n_moins_2].include?(k) }
      errors[:scopes] << "Vous devez cocher au moins une année de revenus souhaitée avant de continuer"
    end
    unless scopes.any? { |k, v| v && %w[dgfip_acces_spi dgfip_acces_etat_civil].include?(k) }
      errors[:scopes] << "Vous devez cocher au moins une modalité d’accès avant de continuer"
    end
  end
end
