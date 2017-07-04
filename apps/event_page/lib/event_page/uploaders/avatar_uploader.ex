defmodule EventPage.Web.AvatarUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @async true
  @versions [:original, :figure]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  # Define a figure transformation:
  def transform(:figure, _) do
    {:convert, "-strip -thumbnail 500x500^ -gravity center -extent 500x500 -format png", :png}
  end


  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  def storage_dir(version, _) do
    "uploads/page_contents/attendee/avatars/#{version}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
