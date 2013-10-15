class AttachmentsController < ApplicationController
  def create
    @entry = Entry.find(params[:entry_id])
    @attachment = @entry.attachments.create(params[:attachment].permit(:attach))
    redirect_to entry_path(@entry, company: params[:attachment][:company])
  end

  def destroy
    @entry = Entry.find(params[:entry_id])
    @attachment = @entry.attachments.find(params[:id])
    @attachment.attach.destroy
    @attachment.destroy
    redirect_to entry_path(@entry, company: params[:company])
  end
end
