require "thor"

class SourceFile < Thor
  include Thor::Actions

  desc "fetch source files", "fetch source files from GitHub"
  def fetch
    self.destination_root = "vendor/assets"
    remote = "https://github.com/rtlong/chosen"
    get "#{remote}/raw/include-group-labels/chosen/chosen-sprite.png", "images/chosen-sprite.png"
    get "#{remote}/raw/include-group-labels/chosen/chosen.css", "stylesheets/chosen.css"
    get "#{remote}/raw/include-group-labels/coffee/lib/abstract-chosen.coffee", "javascripts/lib/abstract-chosen.coffee"
    get "#{remote}/raw/include-group-labels/coffee/lib/select-parser.coffee", "javascripts/lib/select-parser.coffee"
    get "#{remote}/raw/include-group-labels/coffee/chosen.jquery.coffee", "javascripts/chosen.jquery.coffee"
    get "#{remote}/raw/include-group-labels/coffee/chosen.proto.coffee", "javascripts/chosen.proto.coffee"
    get "#{remote}/raw/include-group-labels/VERSION", "VERSION"
    inside destination_root do
      version = File.read("VERSION").sub("\n", "")
      gsub_file "../../lib/chosen-rails/version.rb", /VERSION\s=\s"(\d|\.)+"$/ do |match|
        %Q{VERSION = "#{version}"}
      end
    end
  end

  desc "convert css to sass file", "convert css to sass file by sass-convert"
  def convert
    self.destination_root = "vendor/assets"
    inside destination_root do
      run("sass-convert -F css -T sass stylesheets/chosen.css stylesheets/chosen.css.sass")
      gsub_file 'stylesheets/chosen.css.sass', '(chosen-sprite.png)', "('chosen-sprite.png')"
      gsub_file 'stylesheets/chosen.css.sass', ' url', ' image-url'
    end
  end

  desc "clean up useless files", "clean up useless files"
  def cleanup
    self.destination_root = "vendor/assets"
    remove_file "stylesheets/chosen.css"
    remove_file "VERSION"
  end
end
