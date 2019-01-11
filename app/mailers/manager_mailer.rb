# encoding: UTF-8
class ManagerMailer < ApplicationMailer
	include Sidekiq::Worker
  include Roadie::Rails::Automatic

  def new_manager(manager_email)
  	mail :to => manager_email, :subject => t('manager_mailer.new_manager.title')
  end

  def assignment_cancelled(host_id, witness_id, unassigning_user)
  	@host = Host.find(host_id)
  	@witness = Witness.find(witness_id)
    @unassigning_user = unassigning_user

  	  	mail :to => "edut.basalon@gmail.com", :subject => "ביטול ציוות"

  end

  def witness_contact_help(witness, help_type)

  end
end
