PDFKit.configure do |config|
  config.default_options = {
    quiet: true,
    page_size: 'Legal',
    print_media_type: true,
    footer_right: '[page]/[topage]'
  }
  config.verbose = false
end
