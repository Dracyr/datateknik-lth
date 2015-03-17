set :protect_from_csrf, true
set :layout, :default

activate :directory_indexes

###
# Compass
###

# Change Compass configuration
compass_config do |config|
  #config.output_style = :compact
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

require "better_errors"
configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload

  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

helpers do
  def page_title
    title = data.page.heading ? "#{data.page.heading}" : "Just Another Site"
    strip_tags(title)
  end
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# Deploy settings
activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end

ready do
  paths = sitemap.resources.select { |r| r.url.include? "courses" } \
      .map { |p| {resource: p, title: p.url.split('/')[2]} }

  paths = sitemap.resources.select { |r| r.url.include? "courses" }
  hash = Hash.new { |hash, key| hash[key] =  Hash.new { |hash, key| hash[key] = [] } }
  paths.each do |path|
    splits = path.path.split('/').drop(1)
    if splits.length == 2
      hash[splits[0]][:files] << splits[1]
    end
    if splits.length == 3
      hash[splits[0]][splits[1]] << splits[2]
    end
  end

  hash.each_key do |course|
    proxy "/courses/#{course}/index", "course.html", locals: { course: course, resources: hash[course] }
  end
end


helpers do
  def markdown(&block)
    raise ArgumentError, "Missing block" unless block_given?
    content = capture_html(&block)
    concat Tilt['markdown'].new { content }.render
  end
end
