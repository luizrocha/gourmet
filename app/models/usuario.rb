require 'digest/sha1'

class Usuario < ActiveRecord::Base

    validates_presence_of     :nome
    validates_uniqueness_of   :nome

    attr_accessor :password_confirmation
    validates_confirmation_of :password

    validate :password_non_blank



    def self.authenticate(nome, password)
      usuario = self.find_by_nome(nome)
      if usuario
        expected_password = encrypted_password(password, usuario.salt)
        if usuario.hashed_password != expected_password
          usuario = nil
        end
      end
      usuario
    end


    # 'password' - atributo virtual

    def password
      @password
    end

    def password=(pwd)
      @password = pwd
      return if pwd.blank?
      create_new_salt
      self.hashed_password = Usuario.encrypted_password(self.password, self.salt)
    end



  private

    def password_non_blank
      errors.add(:password, "Senha em branco!") if hashed_password.blank?
    end



    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end



    def self.encrypted_password(password, salt)
      string_to_hash = password + "wibble" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end

end 