class AttachmentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    authorize! :create, Attachment, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:entry_id])
    @attachment = @entry.attachments.create(params[:attachment].permit(:attach))
    redirect_to entry_path(@entry)
  end

  def destroy
    authorize! :destroy, Attachment, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:entry_id])
    @attachment = @entry.attachments.find(params[:id])
    @attachment.attach.destroy
    @attachment.destroy
    redirect_to entry_path(@entry)
  end
end
