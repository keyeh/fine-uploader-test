class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]

  def signature
    secret = "0y/AboyXkjs1vTu/oBoxRzsHv44GXPyEVItaK3M8"

    if params.deep_find(:headers)
      headers = params.deep_find(:headers)
      signed_header_b64 = sign(secret, headers)


      render :json => {:signature => signed_header_b64}
    else
      # acl = params.deep_find(:acl)
      # bucket = params.deep_find(:bucket)
      # contenttype = params.deep_find(:"Content-Type")
      # key = params.deep_find(:key)
      # filename = params.deep_find(:"x-amz-meta-qqfilename")
      # maxlength = params.deep_find(:"content-length-range")
      # expiration = params.deep_find(:expiration)

      policy_b64 = Base64.encode64(request.body.read).gsub("\n", "")

      signed_b64 = sign(secret, policy_b64)

      reply = {:policy => policy_b64, :signature => signed_b64}


      render :json => reply


    end
  end

  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.all
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(key: params[:key], uuid: params[:uuid], name: params[:name], bucket: params[:bucket])
    if @upload.save
      head 200
    else
      head 500
    end

  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
      params[:upload]
    end



    def sign(secret, toSign)
      Base64.encode64(
                      OpenSSL::HMAC.digest(
                        OpenSSL::Digest::Digest.new('sha1'),
                        secret, toSign
                      )
                    ).gsub("\n", "")
    end
end











class Hash
  def deep_find(key, object=self, found=false)
    if object.respond_to?(:key?) && object.key?(key)
      return object[key]
    elsif object.is_a? Enumerable
      object.find { |*a| found = deep_find(key, a.last) }
      return found
    end
  end
end
