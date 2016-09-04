class TmpAttachmentsController < ApplicationController
  def create
    @attachment = TmpAttachment.new(attachment_params)

    respond_to do |format|
      if @attachment.save
        format.json { render json: { object: @attachment, status: true } }
      else
        format.json { render json: { status: false } }
      end
    end
  end

  private

  def attachment_params
    status                = params[:from].to_sym
    params[status][:file] = params[status][:file]

    params.require(status).permit(:file, :name)
  end
end
