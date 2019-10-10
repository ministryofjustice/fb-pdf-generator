PDFKit.configure do |config|
  config.default_options = {
    quiet: true,
    page_size: 'Legal',
    print_media_type: true
  }
  config.verbose = false
end
